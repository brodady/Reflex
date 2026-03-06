#region jsDoc
/// @func ReflexTabBar(_data)
/// @desc
///   Self-contained tab strip widget for Reflex UI.
///   - Owns scroll container and canvas for overflow handling
///   - Manages tab metadata (no page nodes)
///   - Supports drag reorder and cross-bar transfer
///   - Smooth placeholder-gap animations for tab movement
///
/// @param {Struct|String|Undefined} [_data]=undefined Optional flexpanel create struct or JSON
/// @returns {Struct.ReflexTabBar}
#endregion
function ReflexTabBar(_data=undefined) : ReflexUI(_data) constructor
{
	// =========================================================================
	// PUBLIC API - SETTERS
	// =========================================================================
	
	#region jsDoc
	/// @func set_tabs(_tabs_array)
	/// @desc Replaces the entire tab list. Tabs stable by tab_id.
	/// @param {Array<Struct>} _tabs_array Array of tab structs
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static set_tabs = function(_tabs_array)
	{
		__tabs = _tabs_array;
		__layout_dirty = true;
		__trigger_event(events.tabs_changed, { tabs: __tabs });
		
		// Clamp selection
		if (__current_index >= array_length(__tabs)) __current_index = array_length(__tabs) - 1;
		if (__current_index < 0 && array_length(__tabs) > 0 && !__deselect_enabled) __current_index = 0;
		
		return self;
	};
	
	#region jsDoc
	/// @func set_current_index(_index)
	/// @desc Sets the current tab index. Pass -1 to deselect if allowed.
	/// @param {Real} _index Target index (-1 for deselect)
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static set_current_index = function(_index)
	{
		var _new_index = _index;
		
		// Clamp and validate
		if (_new_index < -1) _new_index = -1;
		if (_new_index >= array_length(__tabs)) _new_index = array_length(__tabs) - 1;
		if (_new_index == -1 && !__deselect_enabled && array_length(__tabs) > 0) _new_index = 0;
		
		if (__current_index != _new_index)
		{
			__current_index = _new_index;
			var _tab_id = (__current_index >= 0 && __current_index < array_length(__tabs)) 
				? __tabs[__current_index].tab_id : -1;
			__trigger_event(events.selection_changed, { index: __current_index, tab_id: _tab_id });
		}
		
		return self;
	};
	
	#region jsDoc
	/// @func set_current_tab_id(_tab_id)
	/// @desc Sets current selection by tab_id if present.
	/// @param {Real} _tab_id Target tab ID
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static set_current_tab_id = function(_tab_id)
	{
		var _count = array_length(__tabs);
		for (var _i = 0; _i < _count; _i++)
		{
			if (__tabs[_i].tab_id == _tab_id)
			{
				set_current_index(_i);
				break;
			}
		}
		return self;
	};
	
	#region jsDoc
	/// @func set_deselect_enabled(_enabled)
	/// @desc Allows clicking the active tab to deselect (current index becomes -1).
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static set_deselect_enabled = function(_enabled)
	{
		__deselect_enabled = _enabled;
		return self;
	};
	
	#region jsDoc
	/// @func set_drag_reorder_enabled(_enabled)
	/// @desc Enables drag reorder and cross-bar transfer.
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static set_drag_reorder_enabled = function(_enabled)
	{
		__drag_reorder_enabled = _enabled;
		return self;
	};
	
	#region jsDoc
	/// @func set_rearrange_group(_group_id)
	/// @desc Sets group id for cross-bar transfer. Group 0 disables transfer.
	/// @param {Real} _group_id
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static set_rearrange_group = function(_group_id)
	{
		__rearrange_group = _group_id;
		return self;
	};
	
	#region jsDoc
	/// @func set_tabs_closable(_enabled)
	/// @desc Global toggle. If false, close buttons are hidden regardless of per-tab closable flag.
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static set_tabs_closable = function(_enabled)
	{
		__tabs_closable = _enabled;
		__layout_dirty = true;
		return self;
	};
	
	// =========================================================================
	// PUBLIC API - GETTERS
	// =========================================================================
	
	#region jsDoc
	/// @func get_uuid()
	/// @desc Returns the unique id of this tab bar instance.
	/// @returns {Real}
	#endregion
	static get_uuid = function() { return __uuid; };
	
	#region jsDoc
	/// @func get_viewport()
	/// @desc Returns the internal viewport ReflexUI node.
	/// @returns {Struct.ReflexUI}
	#endregion
	static get_viewport = function() { return __scroller.get_viewport(); };
	
	#region jsDoc
	/// @func get_tabs()
	/// @desc Returns the current tabs array.
	/// @returns {Array<Struct>}
	#endregion
	static get_tabs = function() { return __tabs; };
	
	#region jsDoc
	/// @func get_tab_count()
	/// @desc Returns tab count.
	/// @returns {Real}
	#endregion
	static get_tab_count = function() { return array_length(__tabs); };
	
	#region jsDoc
	/// @func get_current_index()
	/// @desc Returns current selected index.
	/// @returns {Real}
	#endregion
	static get_current_index = function() { return __current_index; };
	
	#region jsDoc
	/// @func get_current_tab_id()
	/// @desc Returns current selected tab id or -1.
	/// @returns {Real}
	#endregion
	static get_current_tab_id = function()
	{
		if (__current_index < 0 || __current_index >= array_length(__tabs)) return -1;
		return __tabs[__current_index].tab_id;
	};
	
	#region jsDoc
	/// @func get_rearrange_group()
	/// @desc Returns current rearrange group id.
	/// @returns {Real}
	#endregion
	static get_rearrange_group = function() { return __rearrange_group; };
	
	// =========================================================================
	// PUBLIC API - FUNCTIONS
	// =========================================================================
	
	#region jsDoc
	/// @func add_tab(_tab_struct, _select)
	/// @desc Appends a tab. If select=true, selects the new tab.
	/// @param {Struct} _tab_struct Tab struct with tab_id, title, etc.
	/// @param {Bool} [_select]=false Whether to select the new tab
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static add_tab = function(_tab_struct, _select=false)
	{
		array_push(__tabs, _tab_struct);
		__layout_dirty = true;
		__trigger_event(events.tabs_changed, { tabs: __tabs });
		if (_select) set_current_index(array_length(__tabs) - 1);
		return self;
	};
	
	#region jsDoc
	/// @func insert_tab(_index, _tab_struct, _select)
	/// @desc Inserts a tab at index. Index is clamped to [0,count].
	/// @param {Real} _index Target index
	/// @param {Struct} _tab_struct Tab struct
	/// @param {Bool} [_select]=false Whether to select the new tab
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static insert_tab = function(_index, _tab_struct, _select=false)
	{
		var _count = array_length(__tabs);
		var _clamped_index = clamp(_index, 0, _count);

		// Keep anim array aligned with tabs if it already matches
		var _anim_matches = (array_length(__tab_lefts_anim) == _count);

		array_insert(__tabs, _clamped_index, _tab_struct);

		if (_anim_matches)
		{
			// Seed inserted anim position from nearest neighbor (prevents global reset)
			var _seed_left = 0;
			if (_clamped_index > 0)
			{
				_seed_left = __tab_lefts_anim[_clamped_index - 1];
			}
			else if (_count > 0)
			{
				_seed_left = __tab_lefts_anim[0];
			}
			array_insert(__tab_lefts_anim, _clamped_index, _seed_left);
		}

		__layout_dirty = true;
		__trigger_event(events.tabs_changed, { tabs: __tabs });
		if (_select) set_current_index(_clamped_index);
		return self;
	};
	
	#region jsDoc
	/// @func remove_tab_by_index(_index)
	/// @desc Removes a tab at index. Updates selection. Returns removed tab struct or undefined.
	/// @param {Real} _index
	/// @returns {Struct|Undefined}
	#endregion
	static remove_tab_by_index = function(_index)
	{
		var _count = array_length(__tabs);
		if (_index < 0 || _index >= _count) return undefined;

		// Keep anim array aligned with tabs if it already matches
		var _anim_matches = (array_length(__tab_lefts_anim) == _count);

		var _removed = __tabs[_index];
		array_delete(__tabs, _index, 1);

		if (_anim_matches)
		{
			array_delete(__tab_lefts_anim, _index, 1);
		}

		__layout_dirty = true;
		__trigger_event(events.tabs_changed, { tabs: __tabs });

		// Update selection
		if (__current_index == _index)
		{
			set_current_index(_index); // Will clamp appropriately
		}
		else if (__current_index > _index)
		{
			set_current_index(__current_index - 1);
		}

		return _removed;
	};
	
	#region jsDoc
	/// @func remove_tab_by_id(_tab_id)
	/// @desc Removes the first tab with tab_id. Returns removed tab struct or undefined.
	/// @param {Real} _tab_id
	/// @returns {Struct|Undefined}
	#endregion
	static remove_tab_by_id = function(_tab_id)
	{
		var _count = array_length(__tabs);
		for (var _i = 0; _i < _count; _i++)
		{
			if (__tabs[_i].tab_id == _tab_id)
			{
				return remove_tab_by_index(_i);
			}
		}
		return undefined;
	};
	
	#region jsDoc
	/// @func clear_tabs()
	/// @desc Removes all tabs.
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static clear_tabs = function()
	{
		__tabs = [];
		__tab_lefts_anim = [];
		__current_index = -1;
		__layout_dirty = true;
		__trigger_event(events.tabs_changed, { tabs: __tabs });
		return self;
	};
	// =========================================================================
	// EVENTS
	// =========================================================================
	
	events = {};
	events.tab_requested = variable_get_hash("tab_requested");
	events.selection_changed = variable_get_hash("selection_changed");
	events.close_requested = variable_get_hash("close_requested");
	events.reorder_requested = variable_get_hash("reorder_requested");
	events.transfer_requested = variable_get_hash("transfer_requested");
	events.drag_outside = variable_get_hash("drag_outside");
	events.tabs_changed = variable_get_hash("tabs_changed");
	
	#region jsDoc
	/// @func on_tab_requested(_func)
	/// @desc Adds a listener for when user clicks a tab.
	/// @param {Function} _func Callback receives { index, tab_id }
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static on_tab_requested = function(_func)
	{
		__add_event_listener(events.tab_requested, _func);
		return self;
	};
	
	#region jsDoc
	/// @func on_selection_changed(_func)
	/// @desc Adds a listener for when selection changes internally.
	/// @param {Function} _func Callback receives { index, tab_id }
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static on_selection_changed = function(_func)
	{
		__add_event_listener(events.selection_changed, _func);
		return self;
	};
	
	#region jsDoc
	/// @func on_close_requested(_func)
	/// @desc Adds a listener for when user clicks close button.
	/// @param {Function} _func Callback receives { index, tab_id }
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static on_close_requested = function(_func)
	{
		__add_event_listener(events.close_requested, _func);
		return self;
	};
	
	#region jsDoc
	/// @func on_reorder_requested(_func)
	/// @desc Adds a listener for when drag reorder within same bar completes.
	/// @param {Function} _func Callback receives { from_index, to_index, tab_id }
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static on_reorder_requested = function(_func)
	{
		__add_event_listener(events.reorder_requested, _func);
		return self;
	};
	
	#region jsDoc
	/// @func on_transfer_requested(_func)
	/// @desc Adds a listener for when drag to another bar completes.
	/// @param {Function} _func Callback receives { tab_id, from_bar, to_bar, to_index }
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static on_transfer_requested = function(_func)
	{
		__add_event_listener(events.transfer_requested, _func);
		return self;
	};
	
	#region jsDoc
	/// @func on_drag_outside(_func)
	/// @desc Adds a listener for when dragged tab leaves all bars.
	/// @param {Function} _func Callback receives { tab_id, from_bar }
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static on_drag_outside = function(_func)
	{
		__add_event_listener(events.drag_outside, _func);
		return self;
	};
	
	#region jsDoc
	/// @func on_tabs_changed(_func)
	/// @desc Adds a listener for when tab list is modified.
	/// @param {Function} _func Callback receives { tabs }
	/// @returns {Struct.ReflexTabBar}
	#endregion
	static on_tabs_changed = function(_func)
	{
		__add_event_listener(events.tabs_changed, _func);
		return self;
	};
	
	// =========================================================================
	// PRIVATE STATE
	// =========================================================================
	
	// Unique instance ID
	static __next_uuid = 0;
	__uuid = __next_uuid++;
	
	// Tab model
	__tabs = [];
	__current_index = -1;
	__deselect_enabled = false;
	
	// Configuration
	__drag_reorder_enabled = true;
	__rearrange_group = 0;
	__tabs_closable = true;
	
	// Layout cache
	__layout_dirty = true;
	__tab_lefts_anim = [];       // Animated positions (lerped)
	__total_width = 0;
	
	// Interaction state
	__hover_index = -1;
	__hover_on_close = false;
	
	// Drag state (LOCAL)
	__drag_active = false;
	__drag_index = -1;
	__drag_grab_offset_x = 0;
	__drag_ghost_left = 0;
	__drag_ghost_left_target = 0;
	__drag_outside = false;
	__drag_threshold = 5;
	__drag_start_mouse_x = 0;
	__drag_start_mouse_y = 0;
	__drag_lifted = false;
	
	// Viewport metrics (cached each step)
	__vp_left = 0;
	__vp_top = 0;
	__vp_width = 0;
	__vp_height = 0;
	__content_left = 0;
	__content_top = 0;
	
	// Theme
	__theme = {
		tab_width: 150,
		tab_height: 20,
		tab_padding_x: 4,
		tab_gap: 2,
		close_size: 14,
		close_padding: 4,
		anim_speed: 0.3,  // Lerp factor for tab animation
		
		// Colors
		color_bg: c_dkgray,
		color_active: c_white,
		color_inactive: make_color_rgb(200, 200, 200),
		color_hover: make_color_rgb(230, 230, 230),
		color_text_active: c_black,
		color_text_inactive: make_color_rgb(80, 80, 80),
		color_close: make_color_rgb(180, 60, 60),
		color_close_hover: make_color_rgb(220, 80, 80),
		color_border: make_color_rgb(150, 150, 150),
		color_ghost_outline: c_blue,
		
		// Font
		font_asset: __fnt_reflex  // Use default font if not set
	};
	
	// =========================================================================
	// INTERNAL NODES
	// =========================================================================
	
	// Self
	// Ensure this node occupies a real vertical slot in parent column layouts
	set_flex_grow(0);
	set_flex_shrink(0);
	set_flex_basis(__theme.tab_height);
	set_min_height(__theme.tab_height);
	set_height(__theme.tab_height);
	
	// Scroll container for overflow
	__scroller = new ReflexScrollContainer();
	__scroller.add_to(self);
	__scroller.set_flex_grow(1);
	__scroller.set_min_height(__theme.tab_height);
	__scroller.set_flex_basis(0);
	__scroller.set_scrollbar_size(0);
	__scroller.set_mouse_wheel_primary_axis(1); // Horizontal primary
	__scroller.set_enable_drag_scroll(false);   // We handle drag for reorder
	
	// Canvas for drawing and input
	__canvas = new ReflexLeafLogic();
	__canvas.add_to(__scroller.get_content());
	__canvas.set_width(__theme.tab_height);  // Initial size
	__canvas.set_height(__theme.tab_height);
	
	// =========================================================================
	// GLOBAL DRAG REGISTRY
	// =========================================================================
	
	static __shared = {
		__bar_registry: [],

		drag_active: false,
		drag_threshold_met: false,

		source: undefined,
		origin: undefined,
		dst: undefined,

		origin_index: -1,

		tab_struct: undefined,
		tab_id: 0,
		group: 0,

		index: 0,

		mouse_x: 0,
		mouse_y: 0,

		// Cross-bar width polish
		origin_tab_width: 0,
		grab_offset_norm: 0
	};
	
	#region jsDoc
	/// @func __register()
	/// @desc Adds this bar to the shared weak registry if missing, and prunes dead entries.
	/// @returns {Undefined}
	#endregion
	static __register = function()
	{
		var _registry = __shared.__bar_registry;
		
		// Prune dead refs and check if we are already registered
		var _need_add = true;
		var _len = array_length(_registry);
		
		for (var _i = _len - 1; _i >= 0; _i--) {
			var _ref = _registry[_i];
			if (!weak_ref_alive(_ref)) {
				array_delete(_registry, _i, 1);
				continue;
			}
			
			var _bar = _ref.ref;
			if (_bar == self) {
				_need_add = false;
			}
		}
		
		if (_need_add) {
			array_push(_registry, weak_ref_create(self));
		}
	};

	#region jsDoc
	/// @func __unregister()
	/// @desc Unregisters this bar from the global registry.
	#endregion
	static __unregister = function()
	{
		var _list = __shared.registry;
		var _count = array_length(_list);
		for (var _i = 0; _i < _count; _i++)
		{
			if (_list[_i] == self)
			{
				array_delete(_list, _i, 1);
				break;
			}
		}
	};
	
	// Override add_to/remove_from to handle registration
	static __base_add_to = add_to;
	static add_to = function(_parent_or_ui_layer)
	{
		var _result = __base_add_to(_parent_or_ui_layer);
		__register();
		return _result;
	};
	
	static __base_remove_from = remove_from;
	static remove_from = function(_parent_or_ui_layer)
	{
		__unregister();
		var _result = __base_remove_from(_parent_or_ui_layer);
		return _result;
	};
	
	// =========================================================================
	// PRIVATE METHODS - LAYOUT
	// =========================================================================
	
	#region jsDoc
	/// @func __update_metrics()
	/// @desc Reads viewport/content absolute geometry into cached variables.
	#endregion
	static __update_metrics = function()
	{
		var _viewport = __scroller.get_viewport();
		var _content = __scroller.get_content();
		__vp_left = _viewport.get_layout_left();
		__vp_top = _viewport.get_layout_top();
		__vp_width = _viewport.get_layout_width();
		__vp_height = _viewport.get_layout_height();
		__content_left = _content.get_layout_left();
		__content_top = _content.get_layout_top();
	};
	
	#region jsDoc
	/// @func __compute_layout()
	/// @desc Computes derived layout for uniform-width tabs.
	///       Updates:
	///       - __total_width (full tab strip width, including gaps)
	///       - __canvas size (scroll content size)
	///       - __tab_lefts_anim length (preserves existing anim where possible)
	#endregion
	static __compute_layout = function()
	{
		var _count = array_length(__tabs);
		
		// Ensure anim array matches tab count
		var _seed_anim = false;
		if (array_length(__tab_lefts_anim) != _count) {
			__tab_lefts_anim = array_create(_count, 0);
			_seed_anim = true;
		}
		
		var _gap = __theme.tab_gap;
		var _tab_w = __theme.tab_width;
		var _tab_h = __theme.tab_height;
		
		var _pitch = _tab_w + _gap;
		
		// Total width of the strip (no trailing gap)
		if (_count <= 0) {
			__total_width = 0;
		}
		else {
			__total_width = (_count * _tab_w) + ((_count - 1) * _gap);
		}
		
		// Update scroll content size (this is what enables mouse wheel scrolling)
		//__canvas.set_width(__total_width);
		//__canvas.set_height(_tab_h);
		__scroller.set_content_size(__total_width, _tab_h);
		
		// Seed anim positions if recreated
		if (_seed_anim) {
			for (var _i = 0; _i < _count; _i++) {
				__tab_lefts_anim[_i] = _i * _pitch;
			}
		}
		
		__layout_dirty = false;
	};
	
	// =========================================================================
	// PRIVATE METHODS - INTERACTION
	// =========================================================================
	
	#region jsDoc
	/// @func __update_hover(_mx, _my)
	/// @desc Updates hover state (tab index and close hit).
	/// @param {Real} _mx Mouse X
	/// @param {Real} _my Mouse Y
	#endregion
	static __update_hover = function(_mx, _my)
	{
		__hover_index = -1;
		__hover_on_close = false;
		
		// Check if mouse is in viewport
		if (_mx < __vp_left || _mx > __vp_left + __vp_width) return;
		if (_my < __vp_top || _my > __vp_top + __vp_height) return;
		
		var _tabs = __tabs;
		var _count = array_length(_tabs);
		var _tab_h = __theme.tab_height;
		var _pad_x = __theme.tab_padding_x;
		var _close_size = __theme.close_size;
		
		for (var _i = 0; _i < _count; _i++) {
			var _left = __content_left + __tab_lefts_anim[_i];
			var _top = __content_top;
			var _right = _left + __theme.tab_width;
			var _bottom = _top + _tab_h;
			
			if (point_in_rectangle(_mx, _my, _left, _top, _right, _bottom)) {
				__hover_index = _i;
				
				// Check close button
				if (__tabs_closable && __tabs[_i].closable) {
					var _close_right = _right - _pad_x;
					var _close_left = _close_right - _close_size;
					if (_mx >= _close_left && _mx <= _close_right) {
						__hover_on_close = true;
					}
				}
				
				break;
			}
		}
	};
	
	#region jsDoc
	/// @func __find_target_bar(_mx, _my)
	/// @desc Finds the topmost visible tab bar under the mouse using the weak registry.
	///       Filters out invalid transfer targets (disabled transfer or group mismatch).
	/// @param {Real} _mx Mouse X
	/// @param {Real} _my Mouse Y
	/// @returns {Struct.ReflexTabBar|Undefined}
	#endregion
	static __find_target_bar = function(_mx, _my)
	{
		var _registry = __shared.__bar_registry;
		if (_registry == undefined) return undefined;

		var _origin = __shared.origin;

		for (var _i = array_length(_registry) - 1; _i >= 0; _i--)
		{
			var _ref = _registry[_i];
			if (!weak_ref_alive(_ref))
			{
				array_delete(_registry, _i, 1);
				continue;
			}

			var _bar = _ref.ref;
			if (_bar == undefined)
			{
				array_delete(_registry, _i, 1);
				continue;
			}

			// Declarative visibility gate
			if (!_bar.get_visible()) continue;

			var _vp = _bar.get_viewport();
			var _left = _vp.get_layout_left();
			var _top = _vp.get_layout_top();
			var _width = _vp.get_layout_width();
			var _height = _vp.get_layout_height();

			// Hit test
			if (!(_mx >= _left && _mx < _left + _width && _my >= _top && _my < _top + _height))
			{
				continue;
			}

			// If dragging, filter invalid transfer targets
			// Origin bar is always valid as a target
			if (__shared.drag_active && __shared.drag_threshold_met && _origin != undefined && _bar != _origin)
			{
				// Transfer disabled on destination bar
				if (!_bar.__drag_reorder_enabled)
				{
					continue;
				}

				// Group validation (origin defines the rule)
				if (!_origin.__validate_group_transfer(_bar))
				{
					continue;
				}
			}

			return _bar;
		}

		return undefined;
	};
	
	#region jsDoc
	/// @func __validate_group_transfer(_dst_bar)
	/// @desc Checks if transfer to destination bar is allowed based on group policy.
	/// @param {Struct.ReflexTabBar|Undefined} _dst_bar
	/// @returns {Bool}
	#endregion
	static __validate_group_transfer = function(_dst_bar)
	{
		if (_dst_bar == undefined) return false;
		if (_dst_bar == self) return true;  // Same bar always allowed
		
		// Group 0 means no cross-bar transfers
		if (__rearrange_group == 0) return false;
		
		// Groups must match
		if (_dst_bar.get_rearrange_group() != __rearrange_group) return false;
		
		return true;
	};
	
	#region jsDoc
	/// @func __begin_drag(_index, _mx, _my)
	/// @desc Begins drag for a tab index.
	/// @param {Real} _index Tab index
	/// @param {Real} _mx Mouse X
	/// @param {Real} _my Mouse Y
	#endregion
	static __begin_drag = function(_index, _mx, _my)
	{
		__register();

		__drag_active = true;
		__drag_index = _index;
		__drag_start_mouse_x = _mx;
		__drag_start_mouse_y = _my;
		__drag_threshold_met = false;
		__drag_lifted = false;
		__drag_outside = false;

		__shared.drag_active = true;
		__shared.drag_threshold_met = false;

		__shared.source = self;
		__shared.origin = self;
		__shared.dst = self;

		__shared.origin_index = _index;

		__shared.tab_struct = __tabs[_index];
		__shared.tab_id = __tabs[_index].tab_id;
		__shared.group = __rearrange_group;

		__shared.mouse_x = _mx;
		__shared.mouse_y = _my;

		// Per-bar width support
		var _origin_width = __theme.tab_width;
		__shared.origin_tab_width = _origin_width;

		// Grab offset in origin bar pixels, then normalize to 0-1
		var _left_anim = __content_left + __tab_lefts_anim[_index];
		__drag_grab_offset_x = _mx - _left_anim;

		__shared.grab_offset_norm = __drag_grab_offset_x / _origin_width;

		// Initial insertion index is array_insert style for the origin bar (tab not lifted yet)
		__shared.index = _index;

		// Ghost position smoothing (still local to source)
		__drag_ghost_left = _left_anim;
		__drag_ghost_left_target = _left_anim;
	};
	
	#region jsDoc
	/// @func __update_drag(_mx, _my)
	/// @desc Updates drag ghost and hover destination.
	/// @param {Real} _mx Mouse X
	/// @param {Real} _my Mouse Y
	#endregion
	static __update_drag = function(_mx, _my)
	{
		// Threshold
		if (!__drag_threshold_met)
		{
			var _dist = point_distance(__drag_start_mouse_x, __drag_start_mouse_y, _mx, _my);
			if (_dist >= __drag_threshold)
			{
				__drag_threshold_met = true;
				__shared.drag_threshold_met = true;
			}
			else
			{
				return;
			}
		}

		__shared.mouse_x = _mx;
		__shared.mouse_y = _my;

		// Lift once (origin/source bar only)
		if (!__drag_lifted)
		{
			__drag_lifted = true;

			var _lift_index = __drag_index;
			var _count_before = array_length(__tabs);

			if (_lift_index >= 0 && _lift_index < _count_before)
			{
				array_delete(__tabs, _lift_index, 1);

				if (array_length(__tab_lefts_anim) == _count_before)
				{
					array_delete(__tab_lefts_anim, _lift_index, 1);
				}

				if (__current_index == _lift_index) __current_index = -1;
				else if (__current_index > _lift_index) __current_index--;

				__hover_index = -1;
				__hover_on_close = false;

				__layout_dirty = true;
			}
		}

		// Destination bar selection
		var _dst_bar = __find_target_bar(_mx, _my);
		if (_dst_bar == undefined) _dst_bar = __shared.origin;

		__shared.dst = _dst_bar;

		if (_dst_bar.__layout_dirty) _dst_bar.__compute_layout();

		var _dst_count = array_length(_dst_bar.__tabs);

		// Destination-width aware ghost math
		var _dst_width = _dst_bar.__theme.tab_width;
		var _ghost_left = _mx - (__shared.grab_offset_norm * _dst_width);
		var _ghost_center = _ghost_left + (_dst_width * 0.5);

		// Edge snap using destination viewport
		var _vp = _dst_bar.get_viewport();
		var _vp_left = _vp.get_layout_left();
		var _vp_top = _vp.get_layout_top();
		var _vp_width = _vp.get_layout_width();
		var _vp_height = _vp.get_layout_height();

		var _edge_snap = _dst_width * 0.35;

		if (_mx >= _vp_left && _mx < _vp_left + _vp_width && _my >= _vp_top && _my < _vp_top + _vp_height)
		{
			if (_mx <= _vp_left + _edge_snap)
			{
				__shared.index = 0;
			}
			else if (_mx >= (_vp_left + _vp_width) - _edge_snap)
			{
				__shared.index = _dst_count;
			}
			else
			{
				__shared.index = clamp(floor((_ghost_center - _dst_bar.__content_left) / _dst_width), 0, _dst_count);
			}
		}
		else
		{
			__shared.index = clamp(floor((_ghost_center - _dst_bar.__content_left) / _dst_width), 0, _dst_count);
		}

		// Local ghost smoothing (still ok - but compute target from destination-width math)
		__drag_ghost_left_target = _ghost_left;
	};
	
	#region jsDoc
	/// @func __end_drag()
	/// @desc Ends drag and applies reorder or transfer.
	/// @returns {Undefined}
	#endregion
	static __end_drag = function()
	{
		if (!__drag_active) return;

		if (!__drag_threshold_met)
		{
			__drag_active = false;
			__shared.drag_active = false;
			__shared.drag_threshold_met = false;
			return;
		}

		var _origin_bar = __shared.origin;
		var _dst_bar = __shared.dst;
		var _insert_index = __shared.index;
		var _tab_id = __shared.tab_id;
		var _tab_struct = __shared.tab_struct;

		if (_dst_bar == undefined) _dst_bar = _origin_bar;

		// Compute ghost left local for origin bar (for restore/reorder seeding)
		var _origin_width = _origin_bar.__theme.tab_width;
		var _ghost_left_origin = __shared.mouse_x - (__shared.grab_offset_norm * _origin_width);
		var _ghost_left_origin_local = _ghost_left_origin - _origin_bar.__content_left;

		if (_dst_bar == _origin_bar)
		{
			var _count = array_length(_origin_bar.__tabs);
			var _clamped = clamp(_insert_index, 0, _count);

			_origin_bar.insert_tab(_clamped, _tab_struct, false);
			_origin_bar.set_current_index(_clamped);

			_origin_bar.__layout_dirty = true;
			_origin_bar.__compute_layout();

			if (_clamped >= 0 && _clamped < array_length(_origin_bar.__tab_lefts_anim))
			{
				_origin_bar.__tab_lefts_anim[_clamped] = _ghost_left_origin_local;
			}

			var _original = clamp(__shared.origin_index, 0, _count);
			if (_clamped != _original)
			{
				_origin_bar.__trigger_event(events.reorder_requested, { from_index: __shared.origin_index, to_index: _clamped, tab_id: _tab_id });
			}
		}
		else
		{
			if (_origin_bar.__validate_group_transfer(_dst_bar))
			{
				// Insert into destination
				var _dst_count = array_length(_dst_bar.__tabs);
				var _dst_clamped = clamp(_insert_index, 0, _dst_count);

				_dst_bar.insert_tab(_dst_clamped, _tab_struct, true);

				// Seed destination anim from destination-local ghost position
				_dst_bar.__layout_dirty = true;
				_dst_bar.__compute_layout();

				var _dst_width = _dst_bar.__theme.tab_width;
				var _ghost_left_dst = __shared.mouse_x - (__shared.grab_offset_norm * _dst_width);
				var _ghost_left_dst_local = _ghost_left_dst - _dst_bar.__content_left;

				if (_dst_clamped >= 0 && _dst_clamped < array_length(_dst_bar.__tab_lefts_anim))
				{
					_dst_bar.__tab_lefts_anim[_dst_clamped] = _ghost_left_dst_local;
				}

				_origin_bar.__trigger_event(events.transfer_requested, {
					tab_id: _tab_id,
					from_bar: _origin_bar,
					to_bar: _dst_bar,
					to_index: _dst_clamped
				});
			}
			else
			{
				// Restore to origin at current insertion index (dst invalid)
				var _count = array_length(_origin_bar.__tabs);
				var _clamped = clamp(_insert_index, 0, _count);

				_origin_bar.insert_tab(_clamped, _tab_struct, false);
				_origin_bar.set_current_index(_clamped);

				_origin_bar.__layout_dirty = true;
				_origin_bar.__compute_layout();

				if (_clamped >= 0 && _clamped < array_length(_origin_bar.__tab_lefts_anim))
				{
					_origin_bar.__tab_lefts_anim[_clamped] = _ghost_left_origin_local;
				}
			}
		}

		__drag_active = false;
		__drag_lifted = false;

		__shared.drag_active = false;
		__shared.drag_threshold_met = false;
	};
	
	static __cancel_drag = function()
	{
		if (!__drag_active)
		{
			__shared.drag_active = false;
			return;
		}
	
		if (__drag_threshold_met && __drag_lifted)
		{
			var _tab_struct = __shared.tab_struct;
			var _ghost_left_local = __drag_ghost_left - __content_left;
		
			var _count = array_length(__tabs);
			var _restore_idx = clamp(__drag_index, 0, _count);
			insert_tab(_restore_idx, _tab_struct, false);
			set_current_index(_restore_idx);
		
			__layout_dirty = true;
			__compute_layout();
			if (_restore_idx >= 0 && _restore_idx < array_length(__tab_lefts_anim))
			{
				__tab_lefts_anim[_restore_idx] = _ghost_left_local;
			}
		}
	
		__drag_active = false;
		__drag_lifted = false;
		__shared.drag_active = false;
	};
	
	// =========================================================================
	// STEP AND DRAW LOGIC
	// =========================================================================
	
	__canvas.set_step(method(self, function()
	{
		__register();

		// Update metrics
		__update_metrics();

		// Recompute layout if needed
		if (__layout_dirty) __compute_layout();

		// Mouse
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);

		// Hover
		if (!__drag_active || __shared.source != self)
		{
			__update_hover(_mx, _my);
		}
		else
		{
			__hover_index = -1;
			__hover_on_close = false;
		}

		// Drag handling only from source bar
		if (__drag_active && __shared.source == self)
		{
			__update_drag(_mx, _my);

			if (mouse_check_button_released(mb_left))
			{
				__end_drag();
			}
			else if (keyboard_check_pressed(vk_escape))
			{
				__cancel_drag();
			}
		}
		else
		{
			// Click handling
			if (mouse_check_button_pressed(mb_left))
			{
				if (__hover_index >= 0)
				{
					if (__hover_on_close)
					{
						var _close_index = __hover_index;
						var _removed = remove_tab_by_index(_close_index);
						if (_removed != undefined)
						{
							__trigger_event(events.close_requested, { index: _close_index, tab_id: _removed.tab_id });
						}
					}
					else
					{
						if (__hover_index == __current_index && __deselect_enabled)
						{
							set_current_index(-1);
							__trigger_event(events.tab_requested, { index: -1, tab_id: -1 });
						}
						else
						{
							set_current_index(__hover_index);
							var _tab_id = __tabs[__hover_index].tab_id;
							__trigger_event(events.tab_requested, { index: __hover_index, tab_id: _tab_id });
						}

						if (__drag_reorder_enabled && __hover_index >= 0)
						{
							__begin_drag(__hover_index, _mx, _my);
						}
					}
				}
			}
		}

		// Animation
		var _count = array_length(__tabs);
		var _speed = __theme.anim_speed;
		var _gap = __theme.tab_gap;
		var _width = __theme.tab_width;
		var _pitch = _width + _gap;

		var _shared = __shared;

		// Origin gap (always for the source bar)
		var _is_origin_gap = false;
		var _origin_index = 0;

		// Destination gap (for hovered destination bar when different from source)
		var _is_dst_gap = false;
		var _dst_index = 0;
		var _dst_ghost_width = 0;

		if (_shared.drag_active && _shared.drag_threshold_met)
		{
			// Origin gap: only the origin bar renders it
			if (_shared.origin == self)
			{
				_is_origin_gap = true;

				// Origin gap follows insertion index when hovering origin; otherwise stays at lift location
				if (_shared.dst == self) _origin_index = _shared.index;
				else _origin_index = _shared.origin_index;
			}

			// Destination gap: only render when dst is this bar and not the origin
			if (_shared.dst == self && _shared.origin != self)
			{
				_is_dst_gap = true;
				_dst_index = _shared.index;
				_dst_ghost_width = _width;
			}
		}

		for (var _i = 0; _i < _count; _i++)
		{
			var _target_left = _i * _pitch;

			if (_is_origin_gap)
			{
				if (_i >= _origin_index)
				{
					_target_left += _width + _gap;
				}
			}

			if (_is_dst_gap)
			{
				if (_i >= _dst_index)
				{
					_target_left += _dst_ghost_width + _gap;
				}
			}

			var _current = __tab_lefts_anim[_i];
			__tab_lefts_anim[_i] = _current + ((_target_left - _current) * _speed);
		}

		// Ghost lerp
		if (__drag_active && __shared.source == self && __drag_threshold_met)
		{
			var _ghost_speed = 0.5;
			__drag_ghost_left = lerp(__drag_ghost_left, __drag_ghost_left_target, _ghost_speed);
		}
	}));
	__canvas.set_draw(method(self, function()
	{
		// Set font
		if (__theme.font_asset != -1) draw_set_font(__theme.font_asset);

		var _tabs = __tabs;
		var _count = array_length(_tabs);
		var _tab_h = __theme.tab_height;
		var _pad_x = __theme.tab_padding_x;
		var _gap = __theme.tab_gap;
		var _pitch = __theme.tab_width + _gap;
		var _close_size = __theme.close_size;

		// Draw background using viewport width (prevents bleed-through when content width changes)
		var _view_left = __vp_left;
		var _view_top = __vp_top;
		var _view_right = __vp_left + __vp_width;
		var _view_bottom = __vp_top + _tab_h;

		draw_set_color(__theme.color_bg);
		draw_set_alpha(1);
		draw_rectangle(_view_left, _view_top, _view_right, _view_bottom, false);

		// Shared snapshot
		var _shared = __shared;

		// Destination placeholder (cross-bar drag into this bar)
		if (_shared.drag_active && _shared.drag_threshold_met && _shared.dst == self && _shared.source != undefined && _shared.source != self)
		{
			var _dst_index = _shared.index;
			var _dst_width = __theme.tab_width;

			var _placeholder_left = __content_left + (_dst_index * _pitch);
			draw_set_color(__theme.color_ghost_outline);
			draw_set_alpha(0.3);
			draw_rectangle(_placeholder_left, __content_top, _placeholder_left + _dst_width, __content_top + _tab_h, false);
			draw_set_alpha(1);
			draw_rectangle(_placeholder_left, __content_top, _placeholder_left + _dst_width, __content_top + _tab_h, true);
		}

		// Draw tabs
		for (var _i = 0; _i < _count; _i++)
		{
			var _tabb = _tabs[_i];

			var _left = __content_left + __tab_lefts_anim[_i];
			var _right = _left + __theme.tab_width;
			var _top = __content_top;

			// Determine colors
			var _is_active = (_i == __current_index);
			var _is_hovered = (_i == __hover_index && !_shared.drag_active);

			var _bg_color = _is_active ? __theme.color_active : (_is_hovered ? __theme.color_hover : __theme.color_inactive);
			var _text_color = _is_active ? __theme.color_text_active : __theme.color_text_inactive;

			// Tab background + border
			draw_set_color(_bg_color);
			draw_set_alpha(1);
			draw_rectangle(_left, _top, _right, _top + _tab_h, false);

			draw_set_color(__theme.color_border);
			draw_rectangle(_left, _top, _right, _top + _tab_h, true);

			// Title
			draw_set_color(_text_color);
			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);

			var _text_x = _left + _pad_x;
			var _text_y = _top + (_tab_h * 0.5);
			var _text_max_w = __theme.tab_width - (_pad_x * 2);

			if (__tabs_closable && _tabb.closable)
			{
				_text_max_w -= _close_size;
			}
			_text_max_w += 2;

			var _text = _tabb.title;
			if (string_width(_text) > _text_max_w)
			{
				while (string_width(_text + "...") > _text_max_w && string_length(_text) > 0)
				{
					_text = string_copy(_text, 1, string_length(_text) - 1);
				}
				_text += "...";
			}
			draw_text(_text_x, _text_y, _text);

			// Close button (derived from animated left, no arrays)
			if (__tabs_closable && _tabb.closable)
			{
				var _close_right = _right - _pad_x;
				var _close_left = _close_right - _close_size;
				var _cy = _top + (_tab_h * 0.5);

				var _close_hovered = (_is_hovered && __hover_on_close);
				var _close_color = _close_hovered ? __theme.color_close_hover : __theme.color_close;

				draw_set_color(_close_color);
				var _cx = (_close_left + _close_right) * 0.5;
				var _half = _close_size * 0.3;
				draw_line_width(_cx - _half, _cy - _half, _cx + _half, _cy + _half, 2);
				draw_line_width(_cx - _half, _cy + _half, _cx + _half, _cy - _half, 2);
			}
		}

		// Draw ghost (dragged tab) from shared-held struct
		if (__shared.drag_active && __shared.drag_threshold_met && __shared.dst == self)
		{
			var _tabb = __shared.tab_struct;

			var _width = __theme.tab_width;
			var _left = __shared.mouse_x - (__shared.grab_offset_norm * _width);

			var _top = __content_top;
			var _tab_h = __theme.tab_height;
			var _pad_x = __theme.tab_padding_x;

			draw_set_color(__theme.color_active);
			draw_set_alpha(0.8);
			draw_rectangle(_left, _top, _left + _width, _top + _tab_h, false);

			draw_set_color(__theme.color_ghost_outline);
			draw_set_alpha(1);
			draw_rectangle(_left, _top, _left + _width, _top + _tab_h, true);
			draw_rectangle(_left + 1, _top + 1, _left + _width - 1, _top + _tab_h - 1, true);

			draw_set_color(__theme.color_text_active);
			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);
			draw_text(_left + _pad_x, _top + (_tab_h * 0.5), _tabb.title);

			draw_set_alpha(1);
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
		}

		// Reset draw state
		draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}));
}
