#region jsDoc
/// @func ReflexSplitContainer(_data)
/// @desc
///		Two-pane container separated by a draggable divider.
///		Implements Godot-like SplitContainer behavior using Flex Panel style only:
///		- Pane A size is controlled via flex_basis (pixels)
///		- Pane B fills remaining space via flex_grow
///		- Divider thickness is controlled via width/height (pixels)
///		- Optional dragger visibility modes and collapsed behavior
///		- Touch support with multi-device tracking
///
///		Content should be added to pane_a / pane_b via get_pane_a() / get_pane_b().
///
/// @param {Struct|String|Undefined} [_data]=undefined Optional flexpanel create struct or JSON.
/// @returns {Struct.ReflexSplitContainer}
#endregion
function ReflexSplitContainer(_data=undefined) : ReflexUI(_data) constructor
{
	// -------------------------------------------------------------------------
	// Constants
	// -------------------------------------------------------------------------
	enum ReflexSplitContainerDraggerVisibility {
		DRAGGER_VISIBLE = 0,
		DRAGGER_HIDDEN = 1,
		DRAGGER_HIDDEN_COLLAPSED = 2
	}
	
	enum ReflexSplitContainerAnchorMode {
		ANCHOR_A = 0,        // Pane A pixel size is definitive (divider stays fixed relative to start)
		ANCHOR_B = 1,        // Pane B pixel size is definitive (divider stays fixed relative to end)
		ANCHOR_RATIO = 2     // Ratio is definitive (divider stays fixed proportionally)
	}
	
	enum ReflexSplitContainerCollapseSide {
		COLLAPSE_A = 0,
		COLLAPSE_B = 1
	}
	
	// -------------------------------------------------------------------------
	// Internal nodes
	// -------------------------------------------------------------------------
	__pane_a = new ReflexUI();
	__divider = new ReflexLeafLogic();
	__pane_b = new ReflexUI();

	// Insert internal nodes in fixed order without routing overrides
	static __base_insert = Reflex.insert;
	__base_insert(__pane_a, -1);
	__base_insert(__divider, -1);
	__base_insert(__pane_b, -1);

	// Enable clipping on both panes to prevent content overdraw
	__pane_a.set_clip_content(true);
	__pane_b.set_clip_content(true);

	// -------------------------------------------------------------------------
	// Defaults
	// -------------------------------------------------------------------------
	__vertical = false;

	__collapsed = false;
	__collapse_side = ReflexSplitContainerCollapseSide.COLLAPSE_A;
	__saved_offset = 0;  // Saved offset for collapse/uncollapse
	__dragger_visibility = ReflexSplitContainerDraggerVisibility.DRAGGER_VISIBLE;

	__divider_size = 6;

	__min_pane_a = 0;
	__min_pane_b = 0;

	__split_offset = 0;
	__split_ratio = 0.5;
	__split_has_explicit_offset = false;

	__dragging = false;
	__drag_start_mouse = 0;
	__drag_start_offset = 0;
	__drag_device = -1;  // Touch device tracking (-1 = none, 0+ = device index)

	__last_avail = -1;

	// Theme system for visual customization
	__theme = {
		// Divider background
		divider_color: c_gray,
		divider_alpha: 0.75,
		
		// Divider hot (hover) state
		divider_hot_color: c_ltgray,
		divider_hot_alpha: 0.9,
		
		// Divider drag (active) state
		divider_drag_color: c_white,
		divider_drag_alpha: 1.0,
		
		// Grip lines
		grip_color: c_white,
		grip_alpha: 0.8,
		grip_line_count: 3,
		grip_line_spacing: 3,
		grip_line_length: 40  // Max length (will be clamped to fit)
	};

	__divider_hot = false;
	
	__anchor_mode = ReflexSplitContainerAnchorMode.ANCHOR_A;
	__anchor_b_pixels = 0;
	
	// -------------------------------------------------------------------------
	// Events
	// -------------------------------------------------------------------------
	events.drag_started = variable_get_hash("drag_started");
	events.dragged = variable_get_hash("dragged");
	events.drag_ended = variable_get_hash("drag_ended");

	#region jsDoc
	/// @func on_drag_started(_func)
	/// @desc Adds a listener for drag start.
	/// @param {Function} _func
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static on_drag_started = function(_func)
	{
		__add_event_listener(events.drag_started, _func);
		return self;
	}

	#region jsDoc
	/// @func on_dragged(_func)
	/// @desc Adds a listener for continuous drag updates. Receives (offset).
	/// @param {Function} _func
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static on_dragged = function(_func)
	{
		__add_event_listener(events.dragged, _func);
		return self;
	}

	#region jsDoc
	/// @func on_drag_ended(_func)
	/// @desc Adds a listener for drag end.
	/// @param {Function} _func
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static on_drag_ended = function(_func)
	{
		__add_event_listener(events.drag_ended, _func);
		return self;
	}

	// -------------------------------------------------------------------------
	// Public API
	// -------------------------------------------------------------------------

	#region jsDoc
	/// @func get_pane_a()
	/// @desc Returns the left/top pane wrapper.
	/// @returns {Struct.ReflexUI}
	#endregion
	static get_pane_a = function()
	{
		return __pane_a;
	};

	#region jsDoc
	/// @func get_pane_b()
	/// @desc Returns the right/bottom pane wrapper.
	/// @returns {Struct.ReflexUI}
	#endregion
	static get_pane_b = function()
	{
		return __pane_b;
	};

	#region jsDoc
	/// @func get_divider()
	/// @desc Returns the divider node for custom rendering or input handling.
	/// @returns {Struct.ReflexLeafLogic}
	#endregion
	static get_divider = function()
	{
		return __divider;
	};

	#region jsDoc
	/// @func set_vertical(_enabled)
	/// @desc Sets orientation. False -> horizontal (row). True -> vertical (column).
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_vertical = function(_enabled)
	{
		__vertical = (_enabled == true);
		__apply_orientation();
		__apply_divider_style();
		__apply_clamped_offset(true);
		return self;
	};

	#region jsDoc
	/// @func is_vertical()
	/// @desc Returns true if orientation is vertical.
	/// @returns {Bool}
	#endregion
	static is_vertical = function()
	{
		return __vertical;
	};

	#region jsDoc
	/// @func set_split_offset(_pixels)
	/// @desc Sets split offset in pixels (Pane A basis).
	/// @param {Real} _pixels
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_split_offset = function(_pixels)
	{
		__split_has_explicit_offset = true;
		__split_offset = _pixels;
		__apply_clamped_offset(true);
		return self;
	};

	#region jsDoc
	/// @func get_split_offset()
	/// @desc Gets current split offset in pixels.
	/// @returns {Real}
	#endregion
	static get_split_offset = function()
	{
		return __split_offset;
	};

	#region jsDoc
	/// @func set_split_ratio(_ratio01)
	/// @desc Sets split ratio [0..1]. Useful for resolution independent state.
	/// @param {Real} _ratio01
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_split_ratio = function(_ratio01)
	{
		var _ratio = _ratio01;
		if (_ratio < 0) { _ratio = 0; }
		if (_ratio > 1) { _ratio = 1; }

		__split_ratio = _ratio;
		__split_has_explicit_offset = false;
		__apply_clamped_offset(true);
		return self;
	};

	#region jsDoc
	/// @func get_split_ratio()
	/// @desc Gets split ratio derived from current offset and available space.
	/// @returns {Real}
	#endregion
	static get_split_ratio = function()
	{
		var _avail = __get_avail_main();
		var _divider = __get_effective_divider_size();
		var _denom = max(1, _avail - _divider);
		return clamp(__split_offset / _denom, 0, 1);
	};
	
	#region jsDoc
	/// @func set_collapsed(_enabled, _side)
	/// @desc Collapses one side and disables dragging. Restores saved offset when uncollapsing.
	/// @param {Bool} _enabled
	/// @param {Real|Undefined} [_side]=undefined Optional ReflexSplitContainerCollapseSide value
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_collapsed = function(_enabled, _side=undefined)
	{
		if (_side != undefined) {
			__collapse_side = _side;
		}

		var _was_collapsed = __collapsed;
		__collapsed = (_enabled == true);

		// Save offset when collapsing
		if (__collapsed && !_was_collapsed) {
			__saved_offset = __split_offset;
		}
		// Restore offset when uncollapsing
		else if (!__collapsed && _was_collapsed) {
			__split_offset = __saved_offset;
		}

		__apply_clamped_offset(true);
		return self;
	};
	
	#region jsDoc
	/// @func is_collapsed()
	/// @desc Returns collapsed state.
	/// @returns {Bool}
	#endregion
	static is_collapsed = function()
	{
		return __collapsed;
	};
	
	#region jsDoc
	/// @func set_collapse_side(_side)
	/// @desc Sets which pane is collapsed when collapsed=true.
	/// @param {Real} _side ReflexSplitContainerCollapseSide.COLLAPSE_A or COLLAPSE_B
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_collapse_side = function(_side)
	{
		__collapse_side = _side;
		if (__collapsed) {
			__apply_clamped_offset(true);
		}
		return self;
	};
	
	#region jsDoc
	/// @func get_collapse_side()
	/// @desc Gets which pane will be collapsed when collapsed=true.
	/// @returns {Real}
	#endregion
	static get_collapse_side = function()
	{
		return __collapse_side;
	};

	#region jsDoc
	/// @func set_dragger_visibility(_mode)
	/// @desc Sets dragger visibility mode:
	///			0 visible, 1 hidden (hit area remains), 2 hidden-collapsed (size 0, disabled).
	/// @param {Real} _mode
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_dragger_visibility = function(_mode)
	{
		__dragger_visibility = _mode;
		__apply_divider_style();
		__apply_clamped_offset(true);
		return self;
	};

	#region jsDoc
	/// @func get_dragger_visibility()
	/// @desc Gets dragger visibility mode.
	/// @returns {Real}
	#endregion
	static get_dragger_visibility = function()
	{
		return __dragger_visibility;
	};

	#region jsDoc
	/// @func set_divider_size(_px)
	/// @desc Sets divider thickness (pixels).
	/// @param {Real} _px
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_divider_size = function(_px)
	{
		__divider_size = max(0, _px);
		__apply_divider_style();
		__apply_clamped_offset(true);
		return self;
	};

	#region jsDoc
	/// @func get_divider_size()
	/// @desc Gets divider thickness (pixels).
	/// @returns {Real}
	#endregion
	static get_divider_size = function()
	{
		return __divider_size;
	};

	#region jsDoc
	/// @func set_min_pane_a(_px)
	/// @desc Sets minimum size for pane A (pixels along main axis).
	/// @param {Real} _px
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_min_pane_a = function(_px)
	{
		__min_pane_a = max(0, _px);
		__apply_clamped_offset(true);
		return self;
	};

	#region jsDoc
	/// @func get_min_pane_a()
	/// @desc Gets minimum size for pane A.
	/// @returns {Real}
	#endregion
	static get_min_pane_a = function()
	{
		return __min_pane_a;
	};

	#region jsDoc
	/// @func set_min_pane_b(_px)
	/// @desc Sets minimum size for pane B (pixels along main axis).
	/// @param {Real} _px
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_min_pane_b = function(_px)
	{
		__min_pane_b = max(0, _px);
		__apply_clamped_offset(true);
		return self;
	};

	#region jsDoc
	/// @func get_min_pane_b()
	/// @desc Gets minimum size for pane B.
	/// @returns {Real}
	#endregion
	static get_min_pane_b = function()
	{
		return __min_pane_b;
	};
	
	#region jsDoc
	/// @func set_anchor_mode(_mode)
	/// @desc
	///		Sets how the split is preserved on parent resize:
	///		- ANCHOR_A: Pane A pixel size is definitive (divider stays fixed relative to start).
	///		- ANCHOR_B: Pane B pixel size is definitive (divider stays fixed relative to end).
	///		- ANCHOR_RATIO: Ratio is definitive (divider stays fixed proportionally).
	///
	///		Switching anchor modes captures current layout state to prevent unexpected jumps.
	///		For nested same-axis splits, use ANCHOR_B for inner splits to maintain stability
	///		relative to their end edge when the outer container resizes.
	///
	/// @param {Real} _mode One of ReflexSplitContainerAnchorMode values.
	/// @returns {Struct.ReflexSplitContainer}
	#endregion
	static set_anchor_mode = function(_mode)
	{
		var _avail = __get_avail_main();
		var _divider = __get_effective_divider_size();
		
		// Capture current state into the new anchor representation to prevent jumps
		if (_mode == ReflexSplitContainerAnchorMode.ANCHOR_B) {
			if (_avail > 0) {
				__anchor_b_pixels = max(0, _avail - _divider - __split_offset);
			} else {
				__anchor_b_pixels = 0;
			}
		} else if (_mode == ReflexSplitContainerAnchorMode.ANCHOR_RATIO) {
			__split_ratio = get_split_ratio();
			__split_has_explicit_offset = false;
		}

		__anchor_mode = _mode;

		// Re-apply so the new mode takes effect immediately
		__apply_clamped_offset(true);
		return self;
	};
	
	#region jsDoc
	/// @func get_anchor_mode()
	/// @desc Gets the current anchor mode (see set_anchor_mode).
	/// @returns {Real}
	#endregion
	static get_anchor_mode = function()
	{
		return __anchor_mode;
	};
	
	// -------------------------------------------------------------------------
	// Child routing
	// -------------------------------------------------------------------------

	#region jsDoc
	/// @func add(_child_node)
	/// @desc Routes children into pane A then pane B (recommended usage).
	/// @param {Struct.Reflex} _child_node
	/// @returns {Undefined}
	#endregion
	static add = function(_child_node)
	{
		__route_child_into_panes(_child_node);
	};

	#region jsDoc
	/// @func insert(_child_node, _index_value)
	/// @desc Routes children into panes (index ignored for external content).
	/// @param {Struct.Reflex} _child_node
	/// @param {Real} [_index_value]=-1
	/// @returns {Undefined}
	#endregion
	static insert = function(_child_node, _index_value=-1)
	{
		__route_child_into_panes(_child_node);
	};

	// -------------------------------------------------------------------------
	// Private helpers
	// -------------------------------------------------------------------------

	#region jsDoc
	/// @func __route_child_into_panes(_child_node)
	/// @desc Internal: places first external child into pane A, subsequent into pane B.
	/// @param {Struct.Reflex} _child_node
	#endregion
	static __route_child_into_panes = function(_child_node)
	{
		if (_child_node == undefined) { return; }
		if (_child_node == __pane_a) { return; }
		if (_child_node == __pane_b) { return; }
		if (_child_node == __divider) { return; }

		var _count_a = flexpanel_node_get_num_children(__pane_a.node_handle);
		if (_count_a <= 0) {
			__pane_a.add(_child_node);
			return;
		}

		__pane_b.add(_child_node);
	};

	#region jsDoc
	/// @func __apply_orientation()
	/// @desc Sets root flex direction based on __vertical.
	#endregion
	static __apply_orientation = function()
	{
		if (__vertical) {
			flexpanel_node_style_set_flex_direction(node_handle, flexpanel_flex_direction.column);
		} else {
			flexpanel_node_style_set_flex_direction(node_handle, flexpanel_flex_direction.row);
		}
	};

	#region jsDoc
	/// @func __get_effective_divider_size()
	/// @desc Returns divider thickness used in layout.
	///       Returns 0 when hidden-collapsed OR when fully collapsed.
	/// @returns {Real}
	#endregion
	static __get_effective_divider_size = function()
	{
		if (__dragger_visibility == ReflexSplitContainerDraggerVisibility.DRAGGER_HIDDEN_COLLAPSED) {
			return 0;
		}
		return __divider_size;
	};

	#region jsDoc
	/// @func __apply_divider_style()
	/// @desc Applies divider display/size rules for current visibility + orientation + collapsed state.
	#endregion
	static __apply_divider_style = function()
	{
		// Display rule: hide if collapsed or hidden-collapsed
		if (__collapsed || __dragger_visibility == ReflexSplitContainerDraggerVisibility.DRAGGER_HIDDEN_COLLAPSED) {
			flexpanel_node_style_set_display(__divider.node_handle, flexpanel_display.none);
		} else {
			flexpanel_node_style_set_display(__divider.node_handle, flexpanel_display.flex);
		}

		// Divider fixed thickness + cross-axis fill
		var _thickness = __get_effective_divider_size();

		if (__vertical) {
			flexpanel_node_style_set_height(__divider.node_handle, _thickness, flexpanel_unit.point);
			flexpanel_node_style_set_width(__divider.node_handle, 100, flexpanel_unit.percent);
		} else {
			flexpanel_node_style_set_width(__divider.node_handle, _thickness, flexpanel_unit.point);
			flexpanel_node_style_set_height(__divider.node_handle, 100, flexpanel_unit.percent);
		}

		// Divider should not shrink
		flexpanel_node_style_set_flex_shrink(__divider.node_handle, 0);

		// Panes cross-axis fill (safe default)
		if (__vertical) {
			flexpanel_node_style_set_width(__pane_a.node_handle, 100, flexpanel_unit.percent);
			flexpanel_node_style_set_width(__pane_b.node_handle, 100, flexpanel_unit.percent);
		} else {
			flexpanel_node_style_set_height(__pane_a.node_handle, 100, flexpanel_unit.percent);
			flexpanel_node_style_set_height(__pane_b.node_handle, 100, flexpanel_unit.percent);
		}

		// Pane B should take remainder
		flexpanel_node_style_set_flex_grow(__pane_b.node_handle, 1);
	};

	#region jsDoc
	/// @func __get_avail_main()
	/// @desc Returns available size along main axis from current layout.
	/// @returns {Real}
	#endregion
	static __get_avail_main = function()
	{
		if (__vertical) {
			return get_layout_height();
		}
		return get_layout_width();
	};

	#region jsDoc
	/// @func __apply_clamped_offset(_recompute_from_ratio)
	/// @desc Clamps and applies split offset to pane styles.
	///       When collapsed, forces offset to 0 regardless of saved value.
	///       When uncollapsed with anchor mode, properly recomputes based on anchor.
	/// @param {Bool} _recompute_from_ratio If true, recompute from anchor mode when appropriate.
	#endregion
	static __apply_clamped_offset = function(_recompute_from_ratio)
	{
		var _avail = __get_avail_main();
		if (_avail <= 0) {
			return;
		}

		var _divider = __get_effective_divider_size();

		// Base target
		var _target = __split_offset;

		// Collapsed forces pane A to 0 (ignoring minimums) and disables dragging elsewhere
		if (__collapsed) {
			_target = 0;
		} else {
			if (_recompute_from_ratio) {
				// Anchor B: keep pane B size fixed in pixels
				// This is critical for nested same-axis splits to maintain stability
				if (__anchor_mode == ReflexSplitContainerAnchorMode.ANCHOR_B) {
					_target = _avail - _divider - __anchor_b_pixels;
				}
				// Anchor Ratio: keep divider at consistent proportional position
				else if (__anchor_mode == ReflexSplitContainerAnchorMode.ANCHOR_RATIO) {
					// Only recompute from ratio when not explicitly offset-driven
					if (!__split_has_explicit_offset) {
						var _denom = max(0, _avail - _divider);
						_target = _denom * __split_ratio;
					}
				}
				// Anchor A: do nothing (pixel offset already definitive)
			}
		}

		// Clamp (but not when collapsed - allow full collapse ignoring minimums)
		if (__collapsed) {
			if (__collapse_side == ReflexSplitContainerCollapseSide.COLLAPSE_B) {
				// Pane B collapsed -> Pane A takes everything (divider effectively 0 while collapsed)
				__split_offset = max(0, _avail - _divider);
			} else {
				// Pane A collapsed
				__split_offset = 0;
			}
		} else {
			var _min_offset = __min_pane_a;
			var _max_offset = max(0, _avail - _divider - __min_pane_b);

			var _clamped = clamp(_target, _min_offset, _max_offset);
			__split_offset = _clamped;
		}
		
		// Update stored anchor state from the final applied offset
		if (!__collapsed) {
			if (__anchor_mode == ReflexSplitContainerAnchorMode.ANCHOR_B) {
				__anchor_b_pixels = max(0, _avail - _divider - __split_offset);
			} else if (__anchor_mode == ReflexSplitContainerAnchorMode.ANCHOR_RATIO) {
				if (!__split_has_explicit_offset) {
					var _ratio_denom = max(1, _avail - _divider);
					__split_ratio = clamp(__split_offset / _ratio_denom, 0, 1);
				}
			}
		}

		// Apply flex sizing
		flexpanel_node_style_set_flex_grow(__pane_a.node_handle, 0);
		flexpanel_node_style_set_flex_shrink(__pane_a.node_handle, 0);

		flexpanel_node_style_set_flex_basis(__pane_a.node_handle, __split_offset, flexpanel_unit.point);
		flexpanel_node_style_set_flex_basis(__pane_b.node_handle, 0, flexpanel_unit.point);
	};
	
	#region jsDoc
	/// @func __drag_is_enabled()
	/// @desc Returns true if dragging is allowed under current state.
	/// @returns {Bool}
	#endregion
	static __drag_is_enabled = function()
	{
		if (__collapsed) { return false; }
		if (__dragger_visibility == ReflexSplitContainerDraggerVisibility.DRAGGER_HIDDEN_COLLAPSED) { return false; }
		return true;
	};

	// -------------------------------------------------------------------------
	// Divider logic (input + draw + resize watching)
	// -------------------------------------------------------------------------
	__divider.set_step(function()
	{
		// Watch resize (local clamp/apply only)
		var _avail = __get_avail_main();
		if (_avail > 0 && _avail != __last_avail) {
			__last_avail = _avail;
			__apply_clamped_offset(true);
		}

		// Divider visibility/hit semantics
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);

		var _pos = flexpanel_node_layout_get_position(__divider.node_handle, false);
		var _hot = (__drag_is_enabled()) && (_mx >= _pos.left) && (_mx < _pos.left + _pos.width) && (_my >= _pos.top) && (_my < _pos.top + _pos.height);

		__divider_hot = _hot;

		// Mouse input
		if (!__dragging) {
			if (__drag_is_enabled() && _hot && mouse_check_button_pressed(mb_left)) {
				__dragging = true;
				__split_has_explicit_offset = true;
				__drag_device = -1; // Mouse

				__drag_start_offset = __split_offset;
				__drag_start_mouse = (__vertical) ? _my : _mx;

				__trigger_event(events.drag_started);
			}
		}

		// Continue drag with mouse
		if (__dragging && __drag_device == -1) {
			if (mouse_check_button(mb_left)) {
				var _cur_mouse = (__vertical) ? _my : _mx;
				var _delta = _cur_mouse - __drag_start_mouse;

				__split_offset = __drag_start_offset + _delta;
				__apply_clamped_offset(false);

				__trigger_event(events.dragged, __split_offset);
			} else {
				__dragging = false;
				__drag_device = -1;
				__trigger_event(events.drag_ended);
			}
		}

		// Touch support (mirroring scrollbar pattern)
		var _max_touch_devices = 4;
		for (var _device = 0; _device < _max_touch_devices; _device++) {
			// Touch released
			if (device_mouse_check_button_released(_device, mb_left)) {
				if (__drag_device == _device) {
					__dragging = false;
					__drag_device = -1;
					__trigger_event(events.drag_ended);
				}
			}
			// Touch pressed - start drag
			else if (device_mouse_check_button_pressed(_device, mb_left)) {
				if (!__dragging && __drag_is_enabled()) {
					var _touch_x = device_mouse_x_to_gui(_device);
					var _touch_y = device_mouse_y_to_gui(_device);
					
					var _touch_hot = (_touch_x >= _pos.left) && (_touch_x < _pos.left + _pos.width) && 
					                 (_touch_y >= _pos.top) && (_touch_y < _pos.top + _pos.height);
					
					if (_touch_hot) {
						__dragging = true;
						__split_has_explicit_offset = true;
						__drag_device = _device;

						__drag_start_offset = __split_offset;
						__drag_start_mouse = (__vertical) ? _touch_y : _touch_x;

						__trigger_event(events.drag_started);
					}
				}
			}
			// Touch continue drag
			else if (device_mouse_check_button(_device, mb_left) && __dragging && __drag_device == _device) {
				var _touch_x = device_mouse_x_to_gui(_device);
				var _touch_y = device_mouse_y_to_gui(_device);
				
				var _cur_mouse = (__vertical) ? _touch_y : _touch_x;
				var _delta = _cur_mouse - __drag_start_mouse;

				__split_offset = __drag_start_offset + _delta;
				__apply_clamped_offset(false);

				__trigger_event(events.dragged, __split_offset);
			}
		}
	});

	__divider.set_draw(function()
	{
		// Draw rules:
		// - Visible: draw with grip lines
		// - Hidden: do not draw
		// - Hidden-collapsed: no node, nothing to draw
		// - Collapsed: do not draw (divider is hidden via display:none)
		if (__dragger_visibility != ReflexSplitContainerDraggerVisibility.DRAGGER_VISIBLE) {
			return;
		}

		var _pos = flexpanel_node_layout_get_position(__divider.node_handle, false);

		// Choose color and alpha based on state
		var _color = __theme.divider_color;
		var _alpha = __theme.divider_alpha;
		
		if (__dragging) {
			_color = __theme.divider_drag_color;
			_alpha = __theme.divider_drag_alpha;
		} else if (__divider_hot) {
			_color = __theme.divider_hot_color;
			_alpha = __theme.divider_hot_alpha;
		}

		// Draw divider background
		draw_set_alpha(_alpha);
		draw_set_color(_color);
		draw_rectangle(_pos.left, _pos.top, _pos.left + _pos.width, _pos.top + _pos.height, false);

		// Draw grip lines for visual affordance
		draw_set_color(__theme.grip_color);
		draw_set_alpha(__theme.grip_alpha);
		
		var _line_count = __theme.grip_line_count;
		var _line_spacing = __theme.grip_line_spacing;
		var _max_length = __theme.grip_line_length;
		
		if (__vertical) {
			// Horizontal grip lines for vertical splitter
			var _cx = _pos.left + _pos.width / 2;
			var _cy = _pos.top + _pos.height / 2;
			var _line_width = min(_pos.width * 0.6, _max_length);
			
			// Center the lines
			var _total_height = (_line_count - 1) * _line_spacing;
			var _start_y = _cy - _total_height / 2;
			
			for (var i = 0; i < _line_count; i++) {
				var _ly = _start_y + (i * _line_spacing);
				draw_line_width(_cx - _line_width/2, _ly, _cx + _line_width/2, _ly, 1);
			}
		}
		else {
			// Vertical grip lines for horizontal splitter
			var _cx = _pos.left + _pos.width / 2;
			var _cy = _pos.top + _pos.height / 2;
			var _line_height = min(_pos.height * 0.6, _max_length);
			
			// Center the lines
			var _total_width = (_line_count - 1) * _line_spacing;
			var _start_x = _cx - _total_width / 2;
			
			for (var i = 0; i < _line_count; i++) {
				var _lx = _start_x + (i * _line_spacing);
				draw_line_width(_lx, _cy - _line_height/2, _lx, _cy + _line_height/2, 1);
			}
		}
		
		draw_set_alpha(1.0);
	});

	// -------------------------------------------------------------------------
	// Initial style application
	// -------------------------------------------------------------------------
	set_flex_grow(1);
	set_flex_basis(0);
	
	__apply_orientation();
	__apply_divider_style();
	__apply_clamped_offset(true);
}
