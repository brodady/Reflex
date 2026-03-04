#region jsDoc
/// @func ReflexScrollContainer()
/// @desc ScrollContainer-style control built from ReflexUI + ReflexScrollBars.
///       - Internal clipped viewport
///       - Content is positioned absolute and offset via left/top
///       - Scrollbars auto-hide when not needed
///       - Adds a bottom-right "nub" so hbar does not run under vbar
///       
///       ENHANCED with comprehensive interaction support:
///       - Drag-to-scroll with mouse/touch
///       - Momentum/inertia scrolling (iOS-style)
///       - Mouse wheel scrolling
///       - Keyboard navigation
///       - Multi-touch support
///       - Overscroll behavior (bounce/resistance)
///       - Smooth scroll animations
///       - Focus management
/// @return {Struct.ReflexScrollContainer}
#endregion
function ReflexScrollContainer() : ReflexUI() constructor
{
	#region Setters

	#region jsDoc
	/// @func set_scrollbar_size(_size)
	/// @desc Sets the thickness of both scrollbars (pixels).
	/// @param {Real} _size
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_scrollbar_size = function(_size)
	{
		scrollbar_size = _size;

		v_scroll.set_width(scrollbar_size);
		v_scroll.set_min_width(scrollbar_size);
		v_scroll.set_max_width(scrollbar_size);
		v_scroll.set_flex_shrink(0);

		h_scroll.set_height(scrollbar_size);
		h_scroll.set_min_height(scrollbar_size);
		h_scroll.set_max_height(scrollbar_size);
		h_scroll.set_flex_shrink(0);

		nub.set_width(scrollbar_size);
		nub.set_min_width(scrollbar_size);
		nub.set_max_width(scrollbar_size);
		nub.set_height(scrollbar_size);
		nub.set_min_height(scrollbar_size);
		nub.set_max_height(scrollbar_size);
		nub.set_flex_shrink(0);

		bottom_row.set_height(scrollbar_size);
		bottom_row.set_min_height(scrollbar_size);
		bottom_row.set_max_height(scrollbar_size);
		bottom_row.set_flex_shrink(0);

		__sync_layout();
		return self;
	};

	#region jsDoc
	/// @func set_content_size(_width, _height)
	/// @desc Sets the scrollable content size in layout units (pixels).
	/// @param {Real} _width
	/// @param {Real} _height
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_content_size = function(_width, _height)
	{
		content_width = _width;
		content_height = _height;

		if (content_width < 0) { content_width = 0; }
		if (content_height < 0) { content_height = 0; }

		content.set_width(content_width);
		content.set_height(content_height);

		__sync_layout();
		return self;
	};

	#region jsDoc
	/// @func set_scroll_x(_value)
	/// @desc Sets horizontal scroll position.
	/// @param {Real} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_scroll_x = function(_value)
	{
		h_scroll.set_value(_value);
		return self;
	};

	#region jsDoc
	/// @func set_scroll_y(_value)
	/// @desc Sets vertical scroll position.
	/// @param {Real} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_scroll_y = function(_value)
	{
		v_scroll.set_value(_value);
		return self;
	};

	#region jsDoc
	/// @func set_scroll(_x, _y)
	/// @desc Sets both scroll positions.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_scroll = function(_x, _y)
	{
		h_scroll.set_value(_x);
		v_scroll.set_value(_y);
		return self;
	};

	#region jsDoc
	/// @func set_enable_momentum(_value)
	/// @desc Enable/disable momentum (inertia) scrolling on drag release.
	/// @param {Bool} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_enable_momentum = function(_value)
	{
		enable_momentum = _value;
		return self;
	};

	#region jsDoc
	/// @func set_momentum_friction(_value)
	/// @desc Set deceleration rate for momentum (0.0-1.0). Default: 0.95 (iOS standard).
	/// @param {Real} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_momentum_friction = function(_value)
	{
		momentum_friction = clamp(_value, 0.0, 1.0);
		return self;
	};

	#region jsDoc
	/// @func set_overscroll_mode(_mode)
	/// @desc Set behavior at content boundaries: "none", "bounce", "resistance".
	/// @param {String} _mode
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_overscroll_mode = function(_mode)
	{
		overscroll_mode = _mode;
		return self;
	};

	#region jsDoc
	/// @func set_enable_drag_scroll(_value)
	/// @desc Enable/disable drag-to-scroll with mouse/touch.
	/// @param {Bool} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_enable_drag_scroll = function(_value)
	{
		enable_drag_scroll = _value;
		return self;
	};

	#region jsDoc
	/// @func set_enable_mouse_wheel(_value)
	/// @desc Enable/disable mouse wheel scrolling.
	/// @param {Bool} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_enable_mouse_wheel = function(_value)
	{
		enable_mouse_wheel = _value;
		return self;
	};

	#region jsDoc
	/// @func set_enable_keyboard(_value)
	/// @desc Enable/disable keyboard navigation when focused.
	/// @param {Bool} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_enable_keyboard = function(_value)
	{
		enable_keyboard = _value;
		return self;
	};

	#region jsDoc
	/// @func set_enable_touch(_value)
	/// @desc Enable/disable touch scrolling.
	/// @param {Bool} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_enable_touch = function(_value)
	{
		enable_touch = _value;
		return self;
	};

	#region jsDoc
	/// @func set_focusable(_value)
	/// @desc Set whether container can receive keyboard focus.
	/// @param {Bool} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_focusable = function(_value)
	{
		is_focusable = _value;
		return self;
	};

	#region jsDoc
	/// @func set_mouse_wheel_speed(_value)
	/// @desc Set scroll amount per mouse wheel tick (pixels). Default: 30.
	/// @param {Real} _value
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static set_mouse_wheel_speed = function(_value)
	{
		mouse_wheel_speed = _value;
		return self;
	};

	#endregion

	#region Getters

	#region jsDoc
	/// @func get_viewport()
	/// @desc Returns the internal viewport ReflexUI node.
	/// @return {Struct.ReflexUI}
	#endregion
	static get_viewport = function() { return viewport; };

	#region jsDoc
	/// @func get_content()
	/// @desc Returns the internal content ReflexUI node (children should be added here).
	/// @return {Struct.ReflexUI}
	#endregion
	static get_content = function() { return content; };

	#region jsDoc
	/// @func get_h_scrollbar()
	/// @desc Returns the horizontal scrollbar.
	/// @return {Struct.ReflexHScrollBar}
	#endregion
	static get_h_scrollbar = function() { return h_scroll; };

	#region jsDoc
	/// @func get_v_scrollbar()
	/// @desc Returns the vertical scrollbar.
	/// @return {Struct.ReflexVScrollBar}
	#endregion
	static get_v_scrollbar = function() { return v_scroll; };

	#region jsDoc
	/// @func get_scroll_x()
	/// @desc Returns current horizontal scroll value.
	/// @return {Real}
	#endregion
	static get_scroll_x = function() { return h_scroll.get_value(); };

	#region jsDoc
	/// @func get_scroll_y()
	/// @desc Returns current vertical scroll value.
	/// @return {Real}
	#endregion
	static get_scroll_y = function() { return v_scroll.get_value(); };

	#region jsDoc
	/// @func is_scrolling()
	/// @desc Returns true if currently scrolling (drag or momentum).
	/// @return {Bool}
	#endregion
	static is_scrolling = function()
	{
		return __is_dragging || __is_momentum_active;
	};

	#region jsDoc
	/// @func is_focused()
	/// @desc Returns true if container has keyboard focus.
	/// @return {Bool}
	#endregion
	static is_focused = function()
	{
		return __has_focus;
	};

	#region jsDoc
	/// @func get_scroll_position()
	/// @desc Returns current scroll position as {x, y}.
	/// @return {Struct}
	#endregion
	static get_scroll_position = function()
	{
		return {
			x: h_scroll.get_value(),
			y: v_scroll.get_value()
		};
	};

	#region jsDoc
	/// @func get_scroll_ratio()
	/// @desc Returns scroll position as ratios {x: 0-1, y: 0-1}.
	/// @return {Struct}
	#endregion
	static get_scroll_ratio = function()
	{
		var _max_x = max(h_scroll.get_max(), 1);
		var _max_y = max(v_scroll.get_max(), 1);
		
		return {
			x: h_scroll.get_value() / _max_x,
			y: v_scroll.get_value() / _max_y
		};
	};

	#endregion
	
	#region Programmatic Scrolling

	#region jsDoc
	/// @func scroll_to(_x, _y, _animated)
	/// @desc Scroll to specific coordinates, optionally animated.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Bool} _animated
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static scroll_to = function(_x, _y, _animated=true)
	{
		if (_animated) {
			__start_smooth_scroll(_x, _y);
		}
		else {
			h_scroll.set_value(_x);
			v_scroll.set_value(_y);
		}
		return self;
	};

	#region jsDoc
	/// @func scroll_by(_delta_x, _delta_y)
	/// @desc Scroll by relative amount.
	/// @param {Real} _delta_x
	/// @param {Real} _delta_y
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static scroll_by = function(_delta_x, _delta_y)
	{
		h_scroll.set_value(h_scroll.get_value() + _delta_x);
		v_scroll.set_value(v_scroll.get_value() + _delta_y);
		return self;
	};

	#region jsDoc
	/// @func scroll_to_top(_animated)
	/// @desc Scroll to top of content.
	/// @param {Bool} _animated
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static scroll_to_top = function(_animated=true)
	{
		return scroll_to(h_scroll.get_value(), 0, _animated);
	};

	#region jsDoc
	/// @func scroll_to_bottom(_animated)
	/// @desc Scroll to bottom of content.
	/// @param {Bool} _animated
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static scroll_to_bottom = function(_animated=true)
	{
		return scroll_to(h_scroll.get_value(), v_scroll.get_max(), _animated);
	};

	#endregion

	#region Events

	events.scroll = variable_get_hash("scroll");
	events.scroll_start = variable_get_hash("scroll_start");
	events.scroll_end = variable_get_hash("scroll_end");
	events.momentum_start = variable_get_hash("momentum_start");
	events.momentum_end = variable_get_hash("momentum_end");

	#region jsDoc
	/// @func on_scroll(_func)
	/// @desc Called during scrolling. Data: {scroll_x, scroll_y, scroll_x_ratio, scroll_y_ratio}.
	/// @param {Function} _func
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static on_scroll = function(_func)
	{
		__add_event_listener(events.scroll, _func);
		return self;
	};

	#region jsDoc
	/// @func on_scroll_start(_func)
	/// @desc Called when scrolling begins.
	/// @param {Function} _func
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static on_scroll_start = function(_func)
	{
		__add_event_listener(events.scroll_start, _func);
		return self;
	};

	#region jsDoc
	/// @func on_scroll_end(_func)
	/// @desc Called when scrolling stops (including momentum).
	/// @param {Function} _func
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static on_scroll_end = function(_func)
	{
		__add_event_listener(events.scroll_end, _func);
		return self;
	};

	#region jsDoc
	/// @func on_momentum_start(_func)
	/// @desc Called when momentum scrolling begins.
	/// @param {Function} _func
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static on_momentum_start = function(_func)
	{
		__add_event_listener(events.momentum_start, _func);
		return self;
	};

	#region jsDoc
	/// @func on_momentum_end(_func)
	/// @desc Called when momentum scrolling ends.
	/// @param {Function} _func
	/// @return {Struct.ReflexScrollContainer}
	#endregion
	static on_momentum_end = function(_func)
	{
		__add_event_listener(events.momentum_end, _func);
		return self;
	};

	#endregion
	
	// ------------------------------------------------------------
	// ScrollContainer child API forwarding
	// ------------------------------------------------------------
	#region jsDoc
	/// @func    add()
	/// @desc    Appends a child node to the end of the content node's children list.
	///          Equivalent to insert(_child_node, -1).
	/// @self    ReflexScrollContainer
	/// @param   {Struct.Reflex} node : Child node to append (added to content).
	/// @returns {Undefined}
	#endregion
	static add = function(_child_node) {
		content.insert(_child_node, -1);
	};

	#region jsDoc
	/// @func    insert()
	/// @desc    Inserts a child node into the content node at the given index (or appends if index < 0).
	/// @self    ReflexScrollContainer
	/// @param   {Struct.Reflex} node : Child node to insert (added to content).
	/// @param   {Real} index : Target index. If < 0, appends. Clamped to valid range by content.
	/// @returns {Undefined}
	#endregion
	static insert = function(_child_node, _index_value=-1) {
		content.insert(_child_node, _index_value);
	};

	#region jsDoc
	/// @func    remove()
	/// @desc    Removes a child node from the content node.
	/// @self    ReflexScrollContainer
	/// @param   {Struct.Reflex} node : Child node to remove (removed from content).
	/// @returns {Undefined}
	#endregion
	static remove = function(_child_node) {
		content.remove(_child_node);
	};

	#region jsDoc
	/// @func    clear()
	/// @desc    Removes all children from the content node.
	/// @self    ReflexScrollContainer
	/// @returns {Undefined}
	#endregion
	static clear = function() {
		content.clear();
	};

	#region jsDoc
	/// @func    find_by_name()
	/// @desc    Searches for a child component by name within the content node.
	/// @self    ReflexScrollContainer
	/// @param   {String} name : Name to search for (compared against get_name()).
	/// @param   {Bool} recursive : If true, searches the entire subtree; if false, only direct children.
	/// @returns {Struct.Reflex|Undefined}
	#endregion
	static find_by_name = function(_name_value, _recursive=false) {
		return content.find_by_name(_name_value, _recursive);
	};

	#region jsDoc
	/// @func    get_child_count()
	/// @desc    Returns the number of direct children of the content node.
	/// @self    ReflexScrollContainer
	/// @returns {Real}
	#endregion
	static get_child_count = function() {
		return content.get_child_count();
	};

	#region jsDoc
	/// @func    get_child_at()
	/// @desc    Returns the child at the given index from the content node.
	/// @self    ReflexScrollContainer
	/// @param   {Real} index : Zero-based child index.
	/// @returns {Struct.Reflex|Undefined}
	#endregion
	static get_child_at = function(_index) {
		return content.get_child_at(_index);
	};

	#region jsDoc
	/// @func    get_children_array()
	/// @desc    Returns the content node's internal children array.
	/// @self    ReflexScrollContainer
	/// @returns {Array}
	#endregion
	static get_children_array = function() {
		return content.get_children_array();
	};

	#region jsDoc
	/// @func    contains()
	/// @desc    Returns whether the given node exists in the content node's subtree.
	/// @self    ReflexScrollContainer
	/// @param   {Struct.Reflex} node : Node to search for.
	/// @param   {Bool} recursive : If true, searches the entire subtree; if false, only direct children.
	/// @returns {Bool}
	#endregion
	static contains = function(_target_node, _recursive=true) {
		return content.contains(_target_node, _recursive);
	};
	
	#region Private

	scrollbar_size = 16;

	content_width = 0;
	content_height = 0;

	__need_h = false;
	__need_v = false;

	enable_momentum = true;
	momentum_friction = 0.95; // iOS standard
	overscroll_mode = "resistance"; // "none", "bounce", "resistance"
	enable_drag_scroll = true;
	enable_mouse_wheel = true;
	enable_keyboard = true;
	enable_touch = true;
	is_focusable = true;
	mouse_wheel_speed = 30;
	
	// Scroll State
	__velocity_x = 0.0;
	__velocity_y = 0.0;
	__is_momentum_active = false;
	__momentum_stop_threshold = 0.5;

	// Drag State
	__is_dragging = false;
	__drag_start_x = 0;
	__drag_start_y = 0;
	__drag_start_scroll_x = 0;
	__drag_start_scroll_y = 0;
	__last_drag_time = 0;
	__last_drag_x = 0;
	__last_drag_y = 0;
	__drag_device = -1;

	// Focus State
	__has_focus = false;
	__was_scrolling = false;

	// Smooth Scroll Animation
	__smooth_scroll_active = false;
	__smooth_scroll_start_x = 0;
	__smooth_scroll_start_y = 0;
	__smooth_scroll_target_x = 0;
	__smooth_scroll_target_y = 0;
	__smooth_scroll_duration = 0.3;
	__smooth_scroll_timer = 0;
	
	set_flex_direction(flexpanel_flex_direction.column);
	set_gap(flexpanel_gutter.all_gutters, 0);
	
	// Top row: viewport + vbar
	row_top = new ReflexUI();
	row_top.set_flex_direction(flexpanel_flex_direction.row);
	row_top.set_flex_grow(1);
	row_top.set_gap(flexpanel_gutter.all_gutters, 0);
	__base_add(row_top);
	
	viewport = new ReflexUI();
	viewport.set_flex_direction(flexpanel_flex_direction.row);
	viewport.set_flex_grow(1);
	viewport.set_gap(flexpanel_gutter.all_gutters, 0);
	row_top.add(viewport);
	
	viewport.set_clip_content(true);
	
	content = new ReflexUI();
	content.set_position_type(flexpanel_position_type.absolute);
	content.set_position(flexpanel_edge.left, 0);
	content.set_position(flexpanel_edge.top, 0);
	content.set_width(0);
	content.set_height(0);
	viewport.add(content);
	
	v_scroll = new ReflexVScrollBar();
	v_scroll.set_width(scrollbar_size);
	v_scroll.set_min_width(scrollbar_size);
	v_scroll.set_max_width(scrollbar_size);
	v_scroll.set_flex_shrink(0);
	row_top.add(v_scroll);
	
	// Bottom row: hbar + nub
	bottom_row = new ReflexUI();
	bottom_row.set_flex_direction(flexpanel_flex_direction.row);
	bottom_row.set_gap(flexpanel_gutter.all_gutters, 0);
	bottom_row.set_height(scrollbar_size);
	bottom_row.set_min_height(scrollbar_size);
	bottom_row.set_max_height(scrollbar_size);
	bottom_row.set_flex_shrink(0);
	__base_add(bottom_row);
	
	h_scroll = new ReflexHScrollBar();
	h_scroll.set_flex_grow(1);
	h_scroll.set_height(scrollbar_size);
	h_scroll.set_min_height(scrollbar_size);
	h_scroll.set_max_height(scrollbar_size);
	h_scroll.set_flex_shrink(0);
	bottom_row.add(h_scroll);
	
	// Nub is just an empty ReflexUI box sized to scrollbar_size
	nub = new ReflexUI();
	nub.set_width(scrollbar_size);
	nub.set_min_width(scrollbar_size);
	nub.set_max_width(scrollbar_size);
	nub.set_height(scrollbar_size);
	nub.set_min_height(scrollbar_size);
	nub.set_max_height(scrollbar_size);
	nub.set_flex_shrink(0);
	bottom_row.add(nub);
	
	// Range defaults
	v_scroll.set_min(0);
	v_scroll.set_step(1);
	v_scroll.set_value_no_signal(0);
	
	h_scroll.set_min(0);
	h_scroll.set_step(1);
	h_scroll.set_value_no_signal(0);
	
	// Hook scroll changes to apply offsets (no closures)
	v_scroll.on_value_changed(method(self, __on_scroll_changed));
	h_scroll.on_value_changed(method(self, __on_scroll_changed));
	
	// Helper logic node to keep ranges and visibility in sync
	__logic = new ReflexLeafLogic();
	__logic.set_visible(false);
	__logic.set_step(method(self, __logic_step));
	__base_add(__logic);
	
	// Input Handler for Enhanced Scrolling
	__input_handler = new ReflexLeafLogic();
	__input_handler.set_visible(false);
	__input_handler.set_step(method(self, __handle_input));
	viewport.add(__input_handler);
	
	static __base_add = function(_child_node) {
		__base_insert(_child_node, -1);
	};
	static __base_insert = ReflexUI.insert;
	static __base_remove = ReflexUI.remove;
	static __base_clear = ReflexUI.clear;
	static __base_find_by_name = ReflexUI.find_by_name;
	static __base_get_child_count = ReflexUI.get_child_count;
	static __base_get_child_at = ReflexUI.get_child_at;
	static __base_get_children_array = ReflexUI.get_children_array;
	static __base_contains = ReflexUI.contains;

	
	#region jsDoc
	/// @func __on_scroll_changed(_value)
	/// @desc Called when either scrollbar value changes.
	/// @param {Real} _value
	#endregion
	static __on_scroll_changed = function(_value) {
		__apply_scroll_from_ranges();
		
		// Emit scroll event
		var _ratio = get_scroll_ratio();
		__trigger_event(events.scroll, {
			scroll_x: h_scroll.get_value(),
			scroll_y: v_scroll.get_value(),
			scroll_x_ratio: _ratio.x,
			scroll_y_ratio: _ratio.y
		});
	};

	#region jsDoc
	/// @func __logic_step()
	/// @desc Keeps visibility + page/max synced from viewport and content size.
	#endregion
	static __logic_step = function() {
		__sync_layout();
	};

	// Enhanced Input Handling

	#region jsDoc
	/// @func __handle_input()
	/// @desc Main input handler for drag, momentum, wheel, touch, and keyboard.
	#endregion
	static __handle_input = function()
	{
		var _dt = delta_time / 1000000; // Convert to seconds
		
		// Get viewport bounds
		var _vp_x = viewport.get_layout_left();
		var _vp_y = viewport.get_layout_top();
		var _vp_w = viewport.get_layout_width();
		var _vp_h = viewport.get_layout_height();
		
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
		var _viewport_hot = point_in_rectangle(_mx, _my, _vp_x, _vp_y, _vp_x + _vp_w, _vp_y + _vp_h);
		
		// === SMOOTH SCROLL ANIMATION ===
		if (__smooth_scroll_active) {
			__smooth_scroll_timer += _dt;
			var _progress = min(__smooth_scroll_timer / __smooth_scroll_duration, 1.0);
			
			// Ease out cubic
			var _ease = 1 - power(1 - _progress, 3);
			
			var _new_x = lerp(__smooth_scroll_start_x, __smooth_scroll_target_x, _ease);
			var _new_y = lerp(__smooth_scroll_start_y, __smooth_scroll_target_y, _ease);
			
			h_scroll.set_value(_new_x);
			v_scroll.set_value(_new_y);
			
			if (_progress >= 1.0) {
				__smooth_scroll_active = false;
			}
			
			return; // Don't process other inputs during smooth scroll
		}
		
		// === MOMENTUM UPDATE ===
		if (__is_momentum_active && !__is_dragging) {
			// Apply friction
			__velocity_x *= momentum_friction;
			__velocity_y *= momentum_friction;
			
			// Apply velocity (normalized to 60fps)
			var _delta_x = __velocity_x * _dt * 60;
			var _delta_y = __velocity_y * _dt * 60;
			
			// Update scroll position
			var _new_x = h_scroll.get_value() + _delta_x;
			var _new_y = v_scroll.get_value() + _delta_y;
			
			__apply_scroll_with_overscroll(_new_x, _new_y);
			
			// Check if velocity has fallen below threshold
			if (abs(__velocity_x) < __momentum_stop_threshold && abs(__velocity_y) < __momentum_stop_threshold) {
				__is_momentum_active = false;
				__velocity_x = 0;
				__velocity_y = 0;
				__trigger_event(events.momentum_end);
				__trigger_event(events.scroll_end);
			}
		}
		
		// === MOUSE/TOUCH DRAG INTERACTION ===
		if (enable_drag_scroll) {
			// Mouse release
			if (mouse_check_button_released(mb_left)) {
				if (__is_dragging && __drag_device == -1) {
					__end_drag();
				}
			}
			
			// Mouse press
			else if (mouse_check_button_pressed(mb_left) && _viewport_hot) {
				// Don't start drag if clicking on scrollbar
				if (!__is_over_scrollbar(_mx, _my)) {
					__start_drag(_mx, _my, -1);
				}
			}
			
			// Mouse drag
			else if (mouse_check_button(mb_left) && __is_dragging && __drag_device == -1) {
				__update_drag(_mx, _my);
			}
			
			// === TOUCH INPUT ===
			if (enable_touch) {
				for (var _device = 0; _device < 4; _device++) {
					if (device_mouse_check_button_released(_device, mb_left)) {
						if (__is_dragging && __drag_device == _device) {
							__end_drag();
						}
					}
					else if (device_mouse_check_button_pressed(_device, mb_left)) {
						var _touch_x = device_mouse_x_to_gui(_device);
						var _touch_y = device_mouse_y_to_gui(_device);
						var _touch_hot = point_in_rectangle(_touch_x, _touch_y, _vp_x, _vp_y, _vp_x + _vp_w, _vp_y + _vp_h);
						
						if (_touch_hot && !__is_dragging) {
							// Touch-to-stop during momentum
							if (__is_momentum_active) {
								__is_momentum_active = false;
								__velocity_x = 0;
								__velocity_y = 0;
								__trigger_event(events.momentum_end);
							}
							
							if (!__is_over_scrollbar(_touch_x, _touch_y)) {
								__start_drag(_touch_x, _touch_y, _device);
							}
						}
					}
					else if (device_mouse_check_button(_device, mb_left) && __is_dragging && __drag_device == _device) {
						var _touch_x = device_mouse_x_to_gui(_device);
						var _touch_y = device_mouse_y_to_gui(_device);
						__update_drag(_touch_x, _touch_y);
					}
				}
			}
		}
		
		// === MOUSE WHEEL ===
		if (enable_mouse_wheel && _viewport_hot && !__is_dragging) {
			var _wheel_delta_y = 0;
			var _wheel_delta_x = 0;
			
			if (mouse_wheel_up()) {
				_wheel_delta_y = -mouse_wheel_speed;
			}
			else if (mouse_wheel_down()) {
				_wheel_delta_y = mouse_wheel_speed;
			}
			
			// Shift + wheel = horizontal scroll
			if (keyboard_check(vk_shift)) {
				_wheel_delta_x = _wheel_delta_y;
				_wheel_delta_y = 0;
			}
			
			if (_wheel_delta_x != 0 || _wheel_delta_y != 0) {
				h_scroll.set_value(h_scroll.get_value() + _wheel_delta_x);
				v_scroll.set_value(v_scroll.get_value() + _wheel_delta_y);
			}
		}
		
		// === KEYBOARD NAVIGATION ===
		if (enable_keyboard && __has_focus && !__is_dragging) {
			var _key_delta_x = 0;
			var _key_delta_y = 0;
			var _step_size = 20;
			
			// Arrow keys
			if (keyboard_check_pressed(vk_left)) _key_delta_x = -_step_size;
			if (keyboard_check_pressed(vk_right)) _key_delta_x = _step_size;
			if (keyboard_check_pressed(vk_up)) _key_delta_y = -_step_size;
			if (keyboard_check_pressed(vk_down)) _key_delta_y = _step_size;
			
			// Page keys
			if (keyboard_check_pressed(vk_pageup)) {
				_key_delta_y = -_vp_h * 0.9;
			}
			if (keyboard_check_pressed(vk_pagedown) || keyboard_check_pressed(vk_space)) {
				_key_delta_y = _vp_h * 0.9;
			}
			
			// Home/End
			if (keyboard_check_pressed(vk_home)) {
				v_scroll.set_value(0);
			}
			if (keyboard_check_pressed(vk_end)) {
				v_scroll.set_value(v_scroll.get_max());
			}
			
			if (_key_delta_x != 0 || _key_delta_y != 0) {
				h_scroll.set_value(h_scroll.get_value() + _key_delta_x);
				v_scroll.set_value(v_scroll.get_value() + _key_delta_y);
			}
		}
		
		// === FOCUS MANAGEMENT ===
		if (is_focusable) {
			if (mouse_check_button_pressed(mb_left)) {
				if (_viewport_hot) {
					if (!__has_focus) {
						__has_focus = true;
					}
				}
				else {
					if (__has_focus) {
						__has_focus = false;
					}
				}
			}
		}
		
		// === SCROLL START/END EVENTS ===
		var _is_scrolling_now = __is_dragging || __is_momentum_active;
		if (_is_scrolling_now && !__was_scrolling) {
			__trigger_event(events.scroll_start);
		}
		else if (!_is_scrolling_now && __was_scrolling) {
			__trigger_event(events.scroll_end);
		}
		__was_scrolling = _is_scrolling_now;
	};

	#region jsDoc
	/// @func __is_over_scrollbar(_x, _y)
	/// @desc Check if point is over a visible scrollbar.
	#endregion
	static __is_over_scrollbar = function(_x, _y)
	{
		if (v_scroll.get_visible()) {
			var _vsx = v_scroll.get_layout_left();
			var _vsy = v_scroll.get_layout_top();
			var _vsw = v_scroll.get_layout_width();
			var _vsh = v_scroll.get_layout_height();
			if (point_in_rectangle(_x, _y, _vsx, _vsy, _vsx + _vsw, _vsy + _vsh)) {
				return true;
			}
		}
		
		if (h_scroll.get_visible()) {
			var _hsx = h_scroll.get_layout_left();
			var _hsy = h_scroll.get_layout_top();
			var _hsw = h_scroll.get_layout_width();
			var _hsh = h_scroll.get_layout_height();
			if (point_in_rectangle(_x, _y, _hsx, _hsy, _hsx + _hsw, _hsy + _hsh)) {
				return true;
			}
		}
		
		return false;
	};

	#region jsDoc
	/// @func __start_drag(_x, _y, _device)
	/// @desc Begin drag scrolling.
	#endregion
	static __start_drag = function(_x, _y, _device)
	{
		__is_dragging = true;
		__drag_start_x = _x;
		__drag_start_y = _y;
		__drag_start_scroll_x = h_scroll.get_value();
		__drag_start_scroll_y = v_scroll.get_value();
		__drag_device = _device;
		__last_drag_x = _x;
		__last_drag_y = _y;
		__last_drag_time = current_time;
		
		// Stop momentum
		if (__is_momentum_active) {
			__is_momentum_active = false;
			__velocity_x = 0;
			__velocity_y = 0;
		}
	};

	#region jsDoc
	/// @func __update_drag(_x, _y)
	/// @desc Update scroll position during drag.
	#endregion
	static __update_drag = function(_x, _y)
	{
		var _delta_x = _x - __drag_start_x;
		var _delta_y = _y - __drag_start_y;
		
		// Invert drag direction (dragging down = scroll up)
		var _new_x = __drag_start_scroll_x - _delta_x;
		var _new_y = __drag_start_scroll_y - _delta_y;
		
		__apply_scroll_with_overscroll(_new_x, _new_y);
		
		// Track velocity for momentum
		if (enable_momentum) {
			var _time_delta = (current_time - __last_drag_time) / 1000;
			if (_time_delta > 0) {
				__velocity_x = -(_x - __last_drag_x) / _time_delta; // Invert for natural scrolling
				__velocity_y = -(_y - __last_drag_y) / _time_delta;
			}
		}
		
		__last_drag_x = _x;
		__last_drag_y = _y;
		__last_drag_time = current_time;
	};

	#region jsDoc
	/// @func __end_drag()
	/// @desc End drag and potentially start momentum.
	#endregion
	static __end_drag = function()
	{
		__is_dragging = false;
		__drag_device = -1;
		
		// Start momentum if velocity is sufficient
		if (enable_momentum && (abs(__velocity_x) > 50 || abs(__velocity_y) > 50)) {
			__is_momentum_active = true;
			__trigger_event(events.momentum_start);
		}
		else {
			__velocity_x = 0;
			__velocity_y = 0;
		}
	};

	#region jsDoc
	/// @func __apply_scroll_with_overscroll(_x, _y)
	/// @desc Apply scroll with overscroll behavior.
	#endregion
	static __apply_scroll_with_overscroll = function(_x, _y)
	{
		var _max_x = h_scroll.get_max();
		var _max_y = v_scroll.get_max();
		
		if (overscroll_mode == "none") {
			h_scroll.set_value(clamp(_x, 0, _max_x));
			v_scroll.set_value(clamp(_y, 0, _max_y));
		}
		else if (overscroll_mode == "resistance") {
			// Allow overscroll with resistance
			if (_x < 0) {
				h_scroll.set_value(_x * 0.3);
			}
			else if (_x > _max_x) {
				h_scroll.set_value(_max_x + (_x - _max_x) * 0.3);
			}
			else {
				h_scroll.set_value(_x);
			}
			
			if (_y < 0) {
				v_scroll.set_value(_y * 0.3);
			}
			else if (_y > _max_y) {
				v_scroll.set_value(_max_y + (_y - _max_y) * 0.3);
			}
			else {
				v_scroll.set_value(_y);
			}
		}
		else { // bounce
			h_scroll.set_value(_x);
			v_scroll.set_value(_y);
		}
	};

	#region jsDoc
	/// @func __start_smooth_scroll(_target_x, _target_y)
	/// @desc Begin smooth scroll animation.
	#endregion
	static __start_smooth_scroll = function(_target_x, _target_y)
	{
		__smooth_scroll_active = true;
		__smooth_scroll_start_x = h_scroll.get_value();
		__smooth_scroll_start_y = v_scroll.get_value();
		__smooth_scroll_target_x = _target_x;
		__smooth_scroll_target_y = _target_y;
		__smooth_scroll_timer = 0;
	};

	#region jsDoc
	/// @func __sync_layout()
	/// @desc Determines which scrollbars are needed (including coupled axis cases),
	///       toggles visibility, updates page/max, clamps values, and applies offsets.
	#endregion
	static __sync_layout = function() {
		// Outer available size for this container (as laid out by its parent)
		var _outer_w = get_layout_width();
		var _outer_h = get_layout_height();

		if (_outer_w < 1) { _outer_w = 1; }
		if (_outer_h < 1) { _outer_h = 1; }

		// Stabilize needed bars (2 passes handles the coupling)
		var _need_h0 = false;
		var _need_v0 = false;

		var _pass = 0;
		repeat (2)
		{
			var _view_w = _outer_w - ((_need_v0) ? scrollbar_size : 0);
			var _view_h = _outer_h - ((_need_h0) ? scrollbar_size : 0);

			if (_view_w < 1) { _view_w = 1; }
			if (_view_h < 1) { _view_h = 1; }

			var _need_h1 = (content_width > _view_w);
			var _need_v1 = (content_height > _view_h);

			if ((_need_h1 == _need_h0) && (_need_v1 == _need_v0))
			{
				break;
			}

			_need_h0 = _need_h1;
			_need_v0 = _need_v1;

			_pass += 1;
		}

		__need_h = _need_h0;
		__need_v = _need_v0;

		// Apply visibility
		h_scroll.set_visible(__need_h);
		bottom_row.set_visible(__need_h);
		
		v_scroll.set_visible(__need_v);

		// Nub only when both are visible
		nub.set_visible(__need_h && __need_v);

		// Final viewport size after deciding bars
		var _final_w = _outer_w - ((__need_v) ? scrollbar_size : 0);
		var _final_h = _outer_h - ((__need_h) ? scrollbar_size : 0);

		if (_final_w < 1) { _final_w = 1; }
		if (_final_h < 1) { _final_h = 1; }

		// Update range pages
		h_scroll.set_page(_final_w);
		v_scroll.set_page(_final_h);

		// Update max (scrollable span)
		var _max_x = content_width - _final_w;
		var _max_y = content_height - _final_h;

		if (_max_x < 0) { _max_x = 0; }
		if (_max_y < 0) { _max_y = 0; }

		h_scroll.set_max(_max_x);
		v_scroll.set_max(_max_y);

		// Clamp without emitting value_changed
		h_scroll.set_value_no_signal(h_scroll.get_value());
		v_scroll.set_value_no_signal(v_scroll.get_value());

		__apply_scroll_from_ranges();
	};

	#region jsDoc
	/// @func __apply_scroll_from_ranges()
	/// @desc Applies scroll values to content positioning.
	#endregion
	static __apply_scroll_from_ranges = function() {
		var _sx = h_scroll.get_value();
		var _sy = v_scroll.get_value();

		content.set_position(flexpanel_edge.left, -_sx);
		content.set_position(flexpanel_edge.top, -_sy);
	};

	#endregion
}
