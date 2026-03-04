#region jsDoc
/// @func __ReflexScrollBar()
/// @desc Abstract scrollbar base (range + input + rendering via ReflexLeafLogic helper).
///       Provides grabber sizing using page and supports custom_step.
/// @return {Struct.__ReflexScrollBar}
#endregion
function __ReflexScrollBar() : __ReflexRange() constructor
{
	#region Setters

	#region jsDoc
	/// @func set_custom_step(_value)
	/// @desc Overrides the step used for button clicks / key nudges (if implemented).
	/// @param {Real} _value
	/// @return {Struct.__ReflexScrollBar}
	#endregion
	static set_custom_step = function(_value)
	{
		if (custom_step == _value) { return self; }
		custom_step = _value;
		__changed();
		return self;
	};

	#region jsDoc
	/// @func set_thumb_min_size(_value)
	/// @desc Sets a minimum thumb size in pixels (for visibility).
	/// @param {Real} _value
	/// @return {Struct.__ReflexScrollBar}
	#endregion
	static set_thumb_min_size = function(_value)
	{
		thumb_min_size = _value;
		return self;
	};

	#endregion

	#region Getters

	#region jsDoc
	/// @func get_custom_step()
	/// @desc Returns custom_step.
	/// @return {Real}
	#endregion
	static get_custom_step = function() { return custom_step; };

	#region jsDoc
	/// @func is_scrolling()
	/// @desc Returns whether the scrollbar is currently being dragged.
	/// @return {Bool}
	#endregion
	static is_scrolling = function() { return __drag_active; };

	#endregion

	#region Events
	
	events.scrolling = variable_get_hash("scrolling");
	
	#region jsDoc
	/// @func    on_scrolling(_func)
	/// @desc    Adds a listener for when the scrollbar is being scrolled (drag active).
	/// @self    __ReflexScrollBar
	/// @param   {Function} _func
	/// @returns {Struct.__ReflexScrollBar}
	#endregion
	static on_scrolling = function(_func)
	{
		__add_event_listener(events.scrolling, _func);
		return self;
	};
	
	#region Hooks

	#region jsDoc
	/// @func _value_changed(_new_value)
	/// @desc Range hook - triggers reflow and emits scrolling while dragging.
	/// @param {Real} _new_value
	#endregion
	static _value_changed = function(_new_value)
	{
		if (__drag_active) {
			__trigger_event(events.scrolling);
		}
	};

	#endregion

	#region Private

	// ScrollBar overrides Range.step default
	step = 0.0;
	custom_step = -1.0;
	thumb_min_size = 10.0;
	mouse_wheel_sensitivity = 0.1 // 10% of the page size.
	
	// 0 = horizontal, 1 = vertical
	__axis = 0;

	__track_pad_a = 0.0;
	__track_pad_b = 0.0;
	
	__logic_leaf = new ReflexLeafLogic();
	__logic_leaf.set_stretch(true, true);
	__logic_leaf.set_keep_aspect(false);
	__logic_leaf.set_tiling(false, false);
	__logic_leaf.set_visible(true);
	__logic_leaf.set_step(function() {
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		
		var _thumb = __calc_thumb_rect();
		var _track = __calc_track_rect();
		
		// Check if mouse is over thumb or track
		__thumb_hot = point_in_rectangle(_mx, _my, _thumb.x, _thumb.y, _thumb.x + _thumb.w, _thumb.y + _thumb.h);
		__track_hot = point_in_rectangle(_mx, _my, _track.x, _track.y, _track.x + _track.w, _track.y + _track.h);
		
		if (mouse_check_button_released(mb_left)) {
			__drag_active = false;
		}
		
		// Handle mouse button press
		else if (mouse_check_button_pressed(mb_left)) {
			if (__thumb_hot) {
				// Start dragging thumb
				__drag_active = true;
				__drag_offset = (__axis == 0) ? (_mx - _thumb.x) : (_my - _thumb.y);
				
				// Gain focus on click
				if (!__has_focus) {
					__has_focus = true;
					__trigger_event(events.focus_gained);
				}
			}
			else if (__track_hot) {
				// Click on tray - page scroll
				var _click_pos = (__axis == 0) ? _mx : _my;
				var _thumb_center = (__axis == 0) ? (_thumb.x + _thumb.w / 2) : (_thumb.y + _thumb.h / 2);
				
				// Determine page direction
				var _page_amount = (page > 0) ? page : (max_value - min_value) * 0.1;
				if (_click_pos < _thumb_center) {
					// Page up/left
					set_value(value - _page_amount);
				}
				else {
					// Page down/right
					set_value(value + _page_amount);
				}
				
				// Gain focus on click
				if (!__has_focus) {
					__has_focus = true;
					__trigger_event(events.focus_gained);
				}
			}
			else if (!__track_hot && __has_focus) {
				// Lost focus - clicked outside
				__has_focus = false;
				__trigger_event(events.focus_lost);
			}
		}
		
		// Handle dragging
		else if (mouse_check_button(mb_left) && __drag_active) {
			__apply_drag(_mx, _my);
			__trigger_event(events.scrolling);
		}
		
		// --- MOUSE WHEEL SUPPORT ---
		if (__track_hot) {
			var _wheel_delta = 0;
			
			if (mouse_wheel_up()) {
				_wheel_delta = -1;
			}
			else if (mouse_wheel_down()) {
				_wheel_delta = 1;
			}
			
			if (_wheel_delta != 0) {
				// Calculate scroll amount
				var _scroll_amount = 0;
				if (page > 0) {
					_scroll_amount = page * mouse_wheel_sensitivity;
				}
				else if (custom_step > 0) {
					_scroll_amount = custom_step;
				}
				else {
					_scroll_amount = (max_value - min_value) * 0.05; // 5% of range
				}
				
				set_value(value + (_wheel_delta * _scroll_amount));
			}
		}
		
		// --- TOUCH SUPPORT ---
		// Check for touch input on multiple devices (0-3 supports up to 4 touches)
		var _max_touch_devices = 4;
		for (var _device = 0; _device < _max_touch_devices; _device++) {
			if (device_mouse_check_button_released(_device, mb_left)) {
				if (__drag_device == _device) {
					__drag_active = false;
					__drag_device = -1;
				}
			}
			else if (device_mouse_check_button_pressed(_device, mb_left)) {
				var _touch_x = device_mouse_x_to_gui(_device);
				var _touch_y = device_mouse_y_to_gui(_device);
				
				var _touch_on_thumb = point_in_rectangle(_touch_x, _touch_y, _thumb.x, _thumb.y, _thumb.x + _thumb.w, _thumb.y + _thumb.h);
				var _touch_on_track = point_in_rectangle(_touch_x, _touch_y, _track.x, _track.y, _track.x + _track.w, _track.y + _track.h);
				
				if (_touch_on_thumb) {
					// Start dragging thumb with this touch
					__drag_active = true;
					__drag_device = _device;
					__drag_offset = (__axis == 0) ? (_touch_x - _thumb.x) : (_touch_y - _thumb.y);
				}
				else if (_touch_on_track) {
					// Touch on tray - page scroll
					var _touch_pos = (__axis == 0) ? _touch_x : _touch_y;
					var _thumb_center = (__axis == 0) ? (_thumb.x + _thumb.w / 2) : (_thumb.y + _thumb.h / 2);
					
					var _page_amount = (page > 0) ? page : (max_value - min_value) * 0.1;
					if (_touch_pos < _thumb_center) {
						set_value(value - _page_amount);
					}
					else {
						set_value(value + _page_amount);
					}
				}
			}
			else if (device_mouse_check_button(_device, mb_left) && __drag_active && __drag_device == _device) {
				// Continue dragging with touch
				var _touch_x = device_mouse_x_to_gui(_device);
				var _touch_y = device_mouse_y_to_gui(_device);
				__apply_drag(_touch_x, _touch_y);
				__trigger_event(events.scrolling);
			}
		}
		
		// --- KEYBOARD SUPPORT ---
		if (__has_focus) {
			var _key_delta = 0;
			var _key_step = 0;
			
			// Determine step amount
			if (custom_step > 0) {
				_key_step = custom_step;
			}
			else if (page > 0) {
				_key_step = page * 0.05; // 5% of page per key press
			}
			else {
				_key_step = (max_value - min_value) * 0.01; // 1% of range
			}
			
			// Arrow keys - small increments
			if (__axis == 0) {
				// Horizontal scrollbar
				if (keyboard_check_pressed(vk_left)) {
					_key_delta = -_key_step;
				}
				else if (keyboard_check_pressed(vk_right)) {
					_key_delta = _key_step;
				}
			}
			else {
				// Vertical scrollbar
				if (keyboard_check_pressed(vk_up)) {
					_key_delta = -_key_step;
				}
				else if (keyboard_check_pressed(vk_down)) {
					_key_delta = _key_step;
				}
			}
			
			// Page Up/Down - large increments
			if (keyboard_check_pressed(vk_pageup)) {
				if (page > 0) {
					_key_delta = -page;
				}
				else {
					_key_delta = -(max_value - min_value) * 0.1;
				}
			}
			else if (keyboard_check_pressed(vk_pagedown)) {
				if (page > 0) {
					_key_delta = page;
				}
				else {
					_key_delta = (max_value - min_value) * 0.1;
				}
			}
			
			// Home/End - jump to extremes
			if (keyboard_check_pressed(vk_home)) {
				set_value(min_value);
			}
			else if (keyboard_check_pressed(vk_end)) {
				set_value(max_value);
			}
			
			// Apply key delta
			if (_key_delta != 0) {
				set_value(value + _key_delta);
			}
		}
		
	});
	__logic_leaf.set_draw(function() {
		var _track = __calc_track_rect();
		draw_set_alpha(1);
		draw_set_color(__track_hot ? theme.track_hot_color : theme.track_color);
		draw_rectangle(_track.x, _track.y, _track.x + _track.w, _track.y + _track.h, false);
		
		var _thumb = __calc_thumb_rect();
		
		var _col = theme.thumb_color;
		if (__drag_active) { _col = theme.thumb_hold_color; }
		else if (__thumb_hot) { _col = theme.thumb_hot_color; }
		
		draw_set_color(_col);
		draw_rectangle(_thumb.x, _thumb.y, _thumb.x + _thumb.w, _thumb.y + _thumb.h, false);
	});
	
	add(__logic_leaf);

	__drag_active = false;
	__drag_offset = 0.0;
	__has_focus = false;
	__drag_device = -1; // Which touch device is currently dragging (-1 = none)
	
	theme = {
		track_color: #202020,
		track_hot_color: #282828,
		thumb_color: #C0C0C0,
		thumb_hot_color: #E0E0E0,
		thumb_hold_color: #FFFFFF
	};

	__thumb_hot = false;
	
	#region jsDoc
	/// @func __calc_track_rect()
	/// @desc Returns track rectangle based on axis and padding.
	/// @return {Struct}
	#endregion
	static __calc_track_rect = function()
	{
		static __struct = {};
		
		var _x = get_layout_left();
		var _y = get_layout_top();
		var _w = get_layout_width();
		var _h = get_layout_height();
		
		if (__axis == 0) {
			_y += __track_pad_a;
			_h -= (__track_pad_a + __track_pad_b);
		}
		else {
			_x += __track_pad_a;
			_w -= (__track_pad_a + __track_pad_b);
		}
		
		if (_w < 0) _w = 0;
		if (_h < 0) _h = 0;
		
		__struct.x = _x;
		__struct.y = _y;
		__struct.w = _w;
		__struct.h = _h;
		return __struct;
	};

	#region jsDoc
	/// @func __calc_thumb_rect()
	/// @desc Returns thumb rectangle from current range + page.
	/// @return {Struct}
	#endregion
	static __calc_thumb_rect = function()
	{
		static __struct = {};
		
		var _track = __calc_track_rect();
		
		var _len = (__axis == 0) ? _track.w : _track.h;
		if (_len < 1.0) { _len = 1.0; }
		
		var _span = max_value - min_value;
		if (_span < 0.0) { _span = 0.0; }
		
		var _page = page;
		if (_page < 0.0) { _page = 0.0; }
		
		var _den = _span + _page;
		var _frac = 1.0;
		if (_den > 0.0) {
			_frac = _page / _den;
			if (_frac < 0.0) { _frac = 0.0; }
			if (_frac > 1.0) { _frac = 1.0; }
		}
		
		var _thumb_len = _len * _frac;

		if (_thumb_len < thumb_min_size) { _thumb_len = thumb_min_size; }
		if (_thumb_len > _len) { _thumb_len = _len; }

		var _ratio = get_as_ratio();
		var _travel = _len - _thumb_len;
		if (_travel < 0.0) { _travel = 0.0; }

		var _pos = _ratio * _travel;

		if (__axis == 0) {
			__struct.x = _track.x + _pos;
			__struct.y = _track.y;
			__struct.w = _thumb_len;
			__struct.h = _track.h;
			return __struct;
		}
		else {
			__struct.x = _track.x;
			__struct.y = _track.y + _pos;
			__struct.w = _track.w;
			__struct.h = _thumb_len;
			return __struct;
		}
	};

	#region jsDoc
	/// @func __apply_drag(_mx, _my)
	/// @desc Converts mouse position to ratio and applies value while dragging.
	/// @param {Real} _mx
	/// @param {Real} _my
	#endregion
	static __apply_drag = function(_mx, _my)
	{
		var _track = __calc_track_rect();
		
		var _len = (__axis == 0) ? _track.w : _track.h;
		if (_len < 1.0) { _len = 1.0; }
		
		var _thumb = __calc_thumb_rect();
		var _thumb_len = (__axis == 0) ? _thumb.w : _thumb.h;
		
		var _travel = _len - _thumb_len;
		if (_travel < 1.0) { _travel = 1.0; }
		
		var _pos = (__axis == 0) ? (_mx - _track.x - __drag_offset) : (_my - _track.y - __drag_offset);
		var _ratio = _pos / _travel;
		_ratio = __clamp01(_ratio);
		
		set_as_ratio(_ratio);
	};

	#endregion
}