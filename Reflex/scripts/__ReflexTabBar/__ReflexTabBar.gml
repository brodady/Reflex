#region jsDoc
/// @func __ReflexTabBar(_owner)
/// @desc
///		Private tab strip element used by ReflexTabContainer.
///		Responsibilities:
///		- Tab hit testing (tab, close button)
///		- Drag reorder inside container
///		- Cross-container drag transfer gated by rearrange group
///		- Overflow policy: shrink-to-min then scroll (uses owner's ScrollContainer)
///		- Resize freeze after close while pointer is inside the bar
///
///		Prior art references:
///		- Godot TabContainer exposes reorder + rearrange group concepts:
///			https://docs.godotengine.org/en/stable/classes/class_tabcontainer.html
///		- GTK detachable and group-based interchange:
///			https://docs.gtk.org/gtk4/method.Notebook.set_tab_detachable.html
///		- WinUI drag lifecycle events (design reference):
///			https://learn.microsoft.com/en-us/windows/winui/api/microsoft.ui.xaml.controls.tabview.tabdragstarting
///		- Qt close requested pattern:
///			https://doc.qt.io/qt-6/qtabbar.html
///
/// @param {Struct.ReflexTabContainer} _owner
/// @returns {Struct.__ReflexTabBar}
#endregion
function __ReflexTabBar(_owner) : ReflexLeafLogic() constructor
{
	// Owner
	__owner = _owner;

	// Geometry cache per tab (computed each layout update)
	__tab_rects = [];
	__close_rects = [];
	__total_width = 0;

	// Hover state
	__hover_tab = -1;
	__hover_close = -1;

	// Drag state (mouse or touch)
	__drag_active = false;
	__drag_from = -1;
	__drag_to = -1;
	__drag_start_x = 0;
	__drag_pointer_id = -1;
	__drag_pointer_is_touch = false;

	// Cross-container drag
	__drag_over_container = undefined;
	__drag_over_index = -1;

	// Close UX: freeze resizing after close while pointer remains in bar
	__resize_frozen = false;
	__resize_frozen_after_close = false;

	// ---------------------------------------------------------------------
	// Private helpers
	// ---------------------------------------------------------------------

	#region jsDoc
	/// @func __get_mouse_gui_x()
	/// @desc Returns GUI-space mouse X.
	/// @returns {Real}
	#endregion
	static __get_mouse_gui_x = function()
	{
		return device_mouse_x_to_gui(0);
	};

	#region jsDoc
	/// @func __get_mouse_gui_y()
	/// @desc Returns GUI-space mouse Y.
	/// @returns {Real}
	#endregion
	static __get_mouse_gui_y = function()
	{
		return device_mouse_y_to_gui(0);
	};

	#region jsDoc
	/// @func __get_touch_gui_x(_device_id)
	/// @desc Returns GUI-space touch X for the given device id.
	/// @param {Real} _device_id
	/// @returns {Real}
	#endregion
	static __get_touch_gui_x = function(_device_id)
	{
		return device_mouse_x_to_gui(_device_id);
	};

	#region jsDoc
	/// @func __get_touch_gui_y(_device_id)
	/// @desc Returns GUI-space touch Y for the given device id.
	/// @param {Real} _device_id
	/// @returns {Real}
	#endregion
	static __get_touch_gui_y = function(_device_id)
	{
		return device_mouse_y_to_gui(_device_id);
	};

	#region jsDoc
	/// @func __point_in_rect(_x, _y, _rect)
	/// @desc Returns true if point is inside rect struct {left, top, width, height}.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Struct} _rect
	/// @returns {Bool}
	#endregion
	static __point_in_rect = function(_x, _y, _rect)
	{
		return (_x >= _rect.left)
			&& (_x < _rect.left + _rect.width)
			&& (_y >= _rect.top)
			&& (_y < _rect.top + _rect.height);
	};

	#region jsDoc
	/// @func __get_bar_rect()
	/// @desc Returns layout rect of this bar element.
	/// @returns {Struct}
	#endregion
	static __get_bar_rect = function()
	{
		return flexpanel_node_layout_get_position(node_handle, false);
	};

	#region jsDoc
	/// @func __is_pointer_in_bar(_x, _y)
	/// @desc
	///		Returns whether pointer is inside the tab bar VIEWPORT region.
	///		Important: the bar content moves with scroll offset, so we must test the scroller viewport,
	///		not the bar content rect, otherwise freeze can clear spuriously.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @returns {Bool}
	#endregion
	static __is_pointer_in_bar = function(_x, _y)
	{
		var _viewport = __owner.__tab_scroller.get_viewport();
		var _rect = _viewport.get_layout_position();
		return __point_in_rect(_x, _y, _rect);
	};

	#region jsDoc
	/// @func __compute_layout()
	/// @desc Computes tab rects and total width using owner's policies and theme.
	#endregion
	static __compute_layout = function()
	{
		var _owner = __owner;
		var _tabs = _owner.__tabs;
		var _count = array_length(_tabs);

		__tab_rects = array_create(_count);
		__close_rects = array_create(_count);

		var _bar = __get_bar_rect();
		
		// Available width must be the SCROLLER viewport width, not the content width
		var _viewport = __owner.__tab_scroller.get_viewport();
		var _avail_w = _viewport.get_layout_width();
		
		// Theme + sizing
		var _pad_x = _owner.__theme.tab_padding_x;
		var _pad_y = _owner.__theme.tab_padding_y;
		var _gap = _owner.__theme.tab_gap;
		var _close_size = _owner.__theme.close_size;
		var _close_pad = _owner.__theme.close_padding;
		var _min_w = _owner.__min_tab_width;
		var _tab_h = _owner.__theme.tab_height;

		// Measure preferred widths
		var _pref_widths = array_create(_count);
		var _sum_pref = 0;

		draw_set_font(_owner.__theme.font_asset);

		for (var _i = 0; _i < _count; _i++) {
			var _tab = _tabs[_i];
			var _title = _tab.title;

			var _text_w = string_width(_title);
			var _w = _text_w + (_pad_x * 2);

			// Reserve close button area if closable
			if (_owner.__tabs_closable && _tab.closable) {
				_w += _close_pad + _close_size + _close_pad;
			}

			_pref_widths[_i] = _w;
			_sum_pref += _w;

			if (_i < _count - 1) {
				_sum_pref += _gap;
			}
		}

		// Decide overflow strategy:
		// - If resize enabled: shrink to min width, then scroll if still too large.
		// - If resize disabled: keep pref widths, rely on scroll.
		var _use_shrink = _owner.__resize_tabs_enabled;
		var _widths = array_create(_count);

		if (_use_shrink && _count > 0) {
			var _sum_min = 0;
			for (var _i = 0; _i < _count; _i++) {
				_sum_min += max(_min_w, _pref_widths[_i]);
				if (_i < _count - 1) { _sum_min += _gap; }
			}

			// If pref already fits, keep pref. If not, shrink proportionally down to min.
			if (_sum_pref <= _avail_w) {
				for (var _i = 0; _i < _count; _i++) {
					_widths[_i] = _pref_widths[_i];
				}
			} else {
				// Shrink proportionally with clamp to min
				var _space_for_tabs = max(0, _avail_w - (_gap * max(0, _count - 1)));
				var _sum_pref_only = max(1, _sum_pref - (_gap * max(0, _count - 1)));
				var _scale = _space_for_tabs / _sum_pref_only;

				for (var _i = 0; _i < _count; _i++) {
					var _w = _pref_widths[_i] * _scale;
					_widths[_i] = max(_min_w, _w);
				}
			}
		} else {
			for (var _i = 0; _i < _count; _i++) {
				_widths[_i] = _pref_widths[_i];
			}
		}

		// Build rects
		var _x = 0;
		var _y = 0;
		__total_width = 0;

		for (var _i = 0; _i < _count; _i++) {
			var _w = _widths[_i];

			var _rect = {
				left: _bar.left + _x,
				top: _bar.top + _y,
				width: _w,
				height: _tab_h
			};
			__tab_rects[_i] = _rect;

			// Close rect (if closable)
			var _close_rect = { left: 0, top: 0, width: 0, height: 0 };
			if (_owner.__tabs_closable && _tabs[_i].closable) {
				var _cx = _rect.left + _rect.width - _close_pad - _close_size;
				var _cy = _rect.top + ((_rect.height - _close_size) * 0.5);
				_close_rect = {
					left: _cx,
					top: _cy,
					width: _close_size,
					height: _close_size
				};
			}
			__close_rects[_i] = _close_rect;

			_x += _w + _gap;
			__total_width = _x;
		}

		// Inform scroll container content width
		_owner.__tab_scroller.set_content_size(__total_width, _tab_h);
	};

	#region jsDoc
	/// @func __hit_test(_x, _y)
	/// @desc Updates hover indices based on pointer position.
	/// @param {Real} _x
	/// @param {Real} _y
	#endregion
	static __hit_test = function(_x, _y)
	{
		__hover_tab = -1;
		__hover_close = -1;

		var _owner = __owner;
		var _tabs = _owner.__tabs;
		var _count = array_length(_tabs);

		for (var _i = 0; _i < _count; _i++) {
			var _tab_rect = __tab_rects[_i];

			if (__point_in_rect(_x, _y, _tab_rect)) {
				__hover_tab = _i;

				var _close_rect = __close_rects[_i];
				if (_owner.__tabs_closable && _tabs[_i].closable) {
					if (_close_rect.width > 0 && __point_in_rect(_x, _y, _close_rect)) {
						__hover_close = _i;
					}
				}
				break;
			}
		}
	};

	#region jsDoc
	/// @func __begin_drag(_is_touch, _pointer_id, _start_x)
	/// @desc Starts dragging the hovered tab.
	/// @param {Bool} _is_touch
	/// @param {Real} _pointer_id
	/// @param {Real} _start_x
	#endregion
	static __begin_drag = function(_is_touch, _pointer_id, _start_x)
	{
		if (!__owner.__drag_to_rearrange_enabled) { return; }
		if (__hover_tab < 0) { return; }

		__drag_active = true;
		__drag_from = __hover_tab;
		__drag_to = __hover_tab;
		__drag_start_x = _start_x;
		__drag_pointer_is_touch = _is_touch;
		__drag_pointer_id = _pointer_id;

		__drag_over_container = __owner;
		__drag_over_index = __hover_tab;

		// DEBUG
		var _src_id = string(__owner.__uuid);
		var _tab_count = string(array_length(__owner.__tabs));
		
		show_debug_message("[TabBar] begin_drag");
		show_debug_message("  owner_id=" + _src_id + " tab_count=" + _tab_count);
		show_debug_message("  from=" + string(__drag_from) + " to=" + string(__drag_over_index));
		show_debug_message("  touch=" + string(_is_touch) + " pointer_id=" + string(_pointer_id) + " start_x=" + string(floor(_start_x)));
	};

#region jsDoc
/// @func __end_drag()
/// @desc Completes drag, applying reorder or transfer.
#endregion
static __end_drag = function()
{
	if (!__drag_active) { return; }

	var _src_owner = __owner;
	var _dst_owner = __drag_over_container;
	var _from = __drag_from;
	var _to = __drag_over_index;

	// DEBUG (before reset)
	var _src_id = string(_src_owner.__uuid);
	var _src_group = string(_src_owner.__tabs_rearrange_group);
	var _src_count = string(array_length(_src_owner.__tabs));

	show_debug_message("[TabBar] end_drag");
	show_debug_message("  src_id=" + _src_id + " src_group=" + _src_group + " src_count=" + _src_count + " from=" + string(_from));

	if (_dst_owner == undefined) {
		show_debug_message("  dst=none to=" + string(_to) + " action=none");
	} else {
		var _dst_id = string(_dst_owner.__uuid);
		var _dst_group = string(_dst_owner.__tabs_rearrange_group);
		var _dst_count = string(array_length(_dst_owner.__tabs));

		show_debug_message("  dst_id=" + _dst_id + " dst_group=" + _dst_group + " dst_count=" + _dst_count + " to=" + string(_to));
	}

	// Reset drag state first
	__drag_active = false;
	__drag_pointer_is_touch = false;
	__drag_pointer_id = -1;

	__drag_from = -1;
	__drag_to = -1;

	if (_dst_owner == undefined) {
		show_debug_message("  action=none (no destination)");
		__drag_over_container = undefined;
		__drag_over_index = -1;
		return;
	}

	// Intra-container reorder
	if (_dst_owner == _src_owner) {
		if (_from >= 0 && _to >= 0 && _from != _to) {
			show_debug_message("  action=reorder");
			_src_owner.__request_reorder(_from, _to);
		} else {
			show_debug_message("  action=none (no-op reorder)");
		}
	}
	// Cross-container transfer
	else {
		if (_from >= 0 && _to >= 0) {
			show_debug_message("  action=transfer");
			_src_owner.__request_transfer(_dst_owner, _from, _to);
		} else {
			show_debug_message("  action=none (invalid transfer indices)");
		}
	}

	__drag_over_container = undefined;
	__drag_over_index = -1;
};

	#region jsDoc
	/// @func __update_drag_target(_x, _y)
	/// @desc Updates insertion target index and potential destination container.
	/// @param {Real} _x
	/// @param {Real} _y
	#endregion
	static __update_drag_target = function(_x, _y)
	{
		// Find destination container under pointer, using global registry.
		var _dst_owner = __owner.__find_container_under_point(_x, _y);

		// DEBUG
		var _src_id = string(__owner.__uuid);
		var _src_group = string(__owner.__tabs_rearrange_group);
		var _src_count = string(array_length(__owner.__tabs));

		show_debug_message("[TabBar] update_drag_target");
		show_debug_message("  src_id=" + _src_id + " src_group=" + _src_group + " src_count=" + _src_count + " x=" + string(floor(_x)) + " y=" + string(floor(_y)));
		show_debug_message("  drag_active=" + string(__drag_active) + " drag_from=" + string(__drag_from) + " drag_over_index=" + string(__drag_over_index));

		if (_dst_owner == undefined) {
			show_debug_message("  dst=none (outside all tab bars) - future window detach entry point");
			__drag_over_container = undefined;
			__drag_over_index = -1;
			return;
		}

		var _dst_id = string(_dst_owner.__uuid);
		var _dst_group = string(_dst_owner.__tabs_rearrange_group);
		var _dst_count = string(array_length(_dst_owner.__tabs));

		show_debug_message("  dst_id=" + _dst_id + " dst_group=" + _dst_group + " dst_count=" + _dst_count);

		__drag_over_container = _dst_owner;

		// Determine insertion index based on destination tab rects
		var _bar = _dst_owner.__tab_bar;
		var _count = array_length(_dst_owner.__tabs);

		// Default append
		var _best = _count;

		for (var _i = 0; _i < _count; _i++) {
			var _rect = _bar.__tab_rects[_i];
			var _mid = _rect.left + (_rect.width * 0.5);

			if (_x < _mid) {
				_best = _i;
				break;
			}
		}

		__drag_over_index = _best;

		// DEBUG
		show_debug_message("  insert_index=" + string(__drag_over_index) + " (dst_count=" + string(_count) + ")");
	};

	#region jsDoc
	/// @func __apply_resize_freeze_rules(_x, _y)
	/// @desc Clears resize freeze when pointer leaves bar.
	/// @param {Real} _x
	/// @param {Real} _y
	#endregion
	static __apply_resize_freeze_rules = function(_x, _y)
	{
		if (!__resize_frozen) { return; }
		if (__is_pointer_in_bar(_x, _y)) { return; }

		__resize_frozen = false;
		__resize_frozen_after_close = false;

		// Recompute layout once unfrozen
		__compute_layout();
	};

	#region jsDoc
	/// @func notify_closed_while_resizable()
	/// @desc Called by owner when a close has occurred and resizing is enabled.
	#endregion
	static notify_closed_while_resizable = function()
	{
		if (!__owner.__resize_tabs_enabled) { return; }
		if (!__owner.__freeze_resize_after_close) { return; }

		__resize_frozen = true;
		__resize_frozen_after_close = true;
	};

	// ---------------------------------------------------------------------
	// Step and draw
	// ---------------------------------------------------------------------

	#region jsDoc
	/// @func __step_impl()
	/// @desc Main step loop: compute layout, hover, handle clicks and dragging.
	#endregion
	static __step_impl = function()
	{
		// Compute layout unless frozen
		if (!__resize_frozen) {
			__compute_layout();
		}

		// Pointer positions
		var _mx = __get_mouse_gui_x();
		var _my = __get_mouse_gui_y();

		// Clear freeze when mouse leaves bar
		__apply_resize_freeze_rules(_mx, _my);

		// Hover
		__hit_test(_mx, _my);

		// Close click (mouse)
		if (__hover_close >= 0 && mouse_check_button_pressed(mb_left)) {
			__owner.__request_close(__hover_close);
			return;
		}

		// Select click (mouse)
		if (__hover_tab >= 0 && mouse_check_button_pressed(mb_left)) {
			__owner.__request_select(__hover_tab);
		}

		// Drag begin (mouse): only after slight motion threshold while button held
		if (!__drag_active) {
			if (__owner.__drag_to_rearrange_enabled && __hover_tab >= 0) {
				if (mouse_check_button_pressed(mb_left)) {
					__begin_drag(false, 0, _mx);
				}
			}
		} else {
			// Drag update (mouse)
			if (!__drag_pointer_is_touch) {
				if (mouse_check_button(mb_left)) {
					__update_drag_target(_mx, _my);
				} else {
					__end_drag();
				}
			}
		}

		// Touch begin: mirror scrollbar patterns by using device ids
		// Minimal: treat any "mouse" device id > 0 as touch pointer.
		for (var _device = 1; _device < 8; _device++) {
			if (!__drag_active) {
				if (mouse_check_button_pressed(mb_left)) { break; }
				// Use touch presses if available by device
				if (device_mouse_check_button_pressed(_device, mb_left)) {
					var _tx = __get_touch_gui_x(_device);
					var _ty = __get_touch_gui_y(_device);

					__apply_resize_freeze_rules(_tx, _ty);
					__hit_test(_tx, _ty);

					if (__hover_close >= 0) {
						__owner.__request_close(__hover_close);
						break;
					}

					if (__hover_tab >= 0) {
						__owner.__request_select(__hover_tab);
						__begin_drag(true, _device, _tx);
						break;
					}
				}
			} else {
				// Touch drag update
				if (__drag_pointer_is_touch && __drag_pointer_id == _device) {
					if (device_mouse_check_button(_device, mb_left)) {
						var _tx = __get_touch_gui_x(_device);
						var _ty = __get_touch_gui_y(_device);
						__update_drag_target(_tx, _ty);
					} else {
						__end_drag();
					}
				}
			}
		}
	};

	#region jsDoc
	/// @func __draw_impl()
	/// @desc Draws tab strip using owner theme and computed rects.
	#endregion
	static __draw_impl = function()
	{
		var _owner = __owner;
		var _tabs = _owner.__tabs;
		var _count = array_length(_tabs);

		var _theme = _owner.__theme;
		draw_set_font(_theme.font_asset);
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);

		// Background
		var _bar = __get_bar_rect();
		draw_set_alpha(_theme.bar_alpha);
		draw_set_color(_theme.bar_color);
		draw_rectangle(_bar.left, _bar.top, _bar.left + _bar.width, _bar.top + _bar.height, false);

		// Tabs
		for (var _i = 0; _i < _count; _i++) {
			var _tab = _tabs[_i];
			var _rect = __tab_rects[_i];

			// Skip invisible tabs (if supported)
			if (!_tab.visible) { continue; }

			var _is_active = (_i == _owner.__current_tab);
			var _is_hover = (_i == __hover_tab);

			// Tab background
			if (!_tab.enabled) {
				draw_set_alpha(_theme.tab_disabled_alpha);
				draw_set_color(_theme.tab_disabled_color);
			} else if (_is_active) {
				draw_set_alpha(_theme.tab_active_alpha);
				draw_set_color(_theme.tab_active_color);
			} else if (_is_hover) {
				draw_set_alpha(_theme.tab_hover_alpha);
				draw_set_color(_theme.tab_hover_color);
			} else {
				draw_set_alpha(_theme.tab_alpha);
				draw_set_color(_theme.tab_color);
			}

			draw_rectangle(_rect.left, _rect.top, _rect.left + _rect.width, _rect.top + _rect.height, false);

			// Title (truncate by width: minimal approach - draw text clipped by bar clipping)
			draw_set_alpha(1.0);
			if (!_tab.enabled) {
				draw_set_color(_theme.text_disabled_color);
			} else if (_is_active) {
				draw_set_color(_theme.text_active_color);
			} else {
				draw_set_color(_theme.text_color);
			}

			var _tx = _rect.left + _theme.tab_padding_x;
			var _ty = _rect.top + (_rect.height * 0.5);
			draw_text(_tx, _ty, _tab.title);

			// Close button (simple X)
			if (_owner.__tabs_closable && _tab.closable) {
				var _cr = __close_rects[_i];
				if (_cr.width > 0) {
					var _is_close_hover = (_i == __hover_close);

					draw_set_alpha(1.0);
					if (_is_close_hover) {
						draw_set_color(_theme.close_hover_color);
					} else {
						draw_set_color(_theme.close_color);
					}

					// X glyph
					var _x1 = _cr.left;
					var _y1 = _cr.top;
					var _x2 = _cr.left + _cr.width;
					var _y2 = _cr.top + _cr.height;
					draw_line(_x1, _y1, _x2, _y2);
					draw_line(_x1, _y2, _x2, _y1);
				}
			}
		}

		// Drag insertion indicator
		if (__drag_active && __drag_over_container != undefined) {
			var _dst = __drag_over_container;
			var _bar_dst = _dst.__tab_bar;

			// Only draw if destination is same group or same container
			var _idx = __drag_over_index;
			if (_idx >= 0) {
				var _line_x = 0;

				if (_idx == 0) {
					_line_x = _bar_dst.__tab_rects[0].left;
				} else if (_idx >= array_length(_dst.__tabs)) {
					var _last = array_length(_dst.__tabs) - 1;
					if (_last >= 0) {
						var _r = _bar_dst.__tab_rects[_last];
						_line_x = _r.left + _r.width;
					}
				} else {
					_line_x = _bar_dst.__tab_rects[_idx].left;
				}

				var _bar_r = _bar_dst.__get_bar_rect();
				draw_set_alpha(1.0);
				draw_set_color(_theme.insert_marker_color);
				draw_line(_line_x, _bar_r.top + 2, _line_x, _bar_r.top + _bar_r.height - 2);
			}
		}
	};

	// Hook up callbacks (methods, no captured locals)
	set_step(method(self, __step_impl));
	set_draw(method(self, __draw_impl));
}