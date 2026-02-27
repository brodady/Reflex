#region jsDoc
/// @desc
///		Flex Panel node wrapper with:
///		- owned node handle
///		- x/y/w/h/width/height mirrors
///		- call-side caching to avoid redundant API calls
///		- reflow directive (dirty flag + optional bound reflow function)
///
/// @example
///		var _wrap = new WWFlexNode();
///		_wrap.set_rect(10, 10, 200, 40);
///		_wrap.style_set_cached("padding", 6);
///		_wrap.request_reflow();
///		_wrap.flush();
#endregion
function Reflex() constructor
{
	// -------------------------------------------------------------------------
	// Variables
	// -------------------------------------------------------------------------
	// Owned node handle
	node_handle = flexpanel_create_node();

	// Required mirrors (initialize all to 0)
	x = 0; // setting these does nothing
	y = 0; // setting these does nothing
	w = 0; // setting these does nothing // same thing as width, just easier to type.
	h = 0; // setting these does nothing // same thing as height, just easier to type.
	width = 0;  // setting these does nothing
	height = 0; // setting these does nothing
	
	// -------------------------------------------------------------------------
	// Drawing
	// -------------------------------------------------------------------------
	#region jsDoc
    /// @desc Draws a contextual debug visualization with interactive label popovers.
    /// @param {Real} _depth Internal recursion depth.
    /// @param {Real} _max_depth Stops recursion after this depth.
    /// @param {Bool} _padding Whether to visualize padding via diagonal lines.
    /// @param {Bool} _margin Whether to visualize margin via diagonal lines.
    /// @param {Bool} _show_labels Whether to draw names and numeric pixel values.
    #endregion
    static draw_debug = function(_depth=0, _max_depth=-1, _padding=false, _margin=false, _show_labels=true)
    {
        if (_max_depth >= 0 && _depth > _max_depth) return;

        // --- Internal Helper ---
        var __draw_val = function(_cx, _cy, _val, _color) {
            var _s = string(_val);
            var _tw = string_width(_s) + 4;
            var _th = string_height(_s);
            var _rx1 = _cx - _tw/2;
            var _ry1 = _cy - _th/2;
            draw_set_color(c_black);
            draw_rectangle(_rx1, _ry1, _rx1 + _tw, _ry1 + _th, false);
            draw_set_color(_color);
            draw_text(_rx1 + 2, _ry1, _s);
        };

        // --- Static Hover Management ---
        static __hover_stack = [];
        if (_depth == 0) array_resize(__hover_stack, 0); 

        var _layout = __cache_layout;
        var _col_main = merge_color(c_blue, c_orange, min(_depth * 0.15, 1.0));

        // 1. Draw Margin & Padding (Line-based wireframes)
        if (_layout != undefined) {
            if (_margin) {
                draw_set_color(c_orange); draw_set_alpha(0.4);
                var _mx1 = x - _layout.marginLeft, _my1 = y - _layout.marginTop;
                var _mx2 = x + width + _layout.marginRight, _my2 = y + height + _layout.marginBottom;
                draw_rectangle(_mx1, _my1, _mx2, _my2, true);
                draw_line(_mx1, _my1, x, y); draw_line(_mx2, _my1, x + width, y);
                draw_line(_mx1, _my2, x, y + height); draw_line(_mx2, _my2, x + width, y + height);
                if (_show_labels) {
                    draw_set_alpha(1.0);
                    if (_layout.marginTop != 0)    __draw_val(x + width/2, y - _layout.marginTop/2, _layout.marginTop, c_orange);
                    if (_layout.marginBottom != 0) __draw_val(x + width/2, y + height + _layout.marginBottom/2, _layout.marginBottom, c_orange);
                    if (_layout.marginLeft != 0)   __draw_val(x - _layout.marginLeft/2, y + height/2, _layout.marginLeft, c_orange);
                    if (_layout.marginRight != 0)  __draw_val(x + width + _layout.marginRight/2, y + height/2, _layout.marginRight, c_orange);
                }
            }
            if (_padding) {
                draw_set_color(c_fuchsia); draw_set_alpha(0.4);
                var _px1 = x + _layout.paddingLeft, _py1 = y + _layout.paddingTop;
                var _px2 = x + width - _layout.paddingRight, _py2 = y + height - _layout.paddingBottom;
                draw_rectangle(_px1, _py1, _px2, _py2, true);
                draw_line(x, y, _px1, _py1); draw_line(x + width, y, _px2, _py1);
                draw_line(x, y + height, _px1, _py2); draw_line(x + width, y + height, _px2, _py2);
                if (_show_labels) {
                    draw_set_alpha(1.0);
                    if (_layout.paddingTop != 0)    __draw_val(x + width/2, y + _layout.paddingTop/2, _layout.paddingTop, c_fuchsia);
                    if (_layout.paddingBottom != 0) __draw_val(x + width/2, y + height - _layout.paddingBottom/2, _layout.paddingBottom, c_fuchsia);
                    if (_layout.paddingLeft != 0)   __draw_val(x + _layout.paddingLeft/2, y + height/2, _layout.paddingLeft, c_fuchsia);
                    if (_layout.paddingRight != 0)  __draw_val(x + width - _layout.paddingRight/2, y + height/2, _layout.paddingRight, c_fuchsia);
                }
            }
        }

        // 2. Main Box Fill & 2px Border
        draw_set_alpha(0.15); draw_set_color(_col_main);
        draw_rectangle(x, y, x + width, y + height, false);
        draw_set_alpha(0.8);
        draw_line_width(x+1, y+1, x+width-1, y+1, 2);
        draw_line_width(x+1, y+height-1, x+width-1, y+height-1, 2);
        draw_line_width(x+1, y+1, x+1, y+height-1, 2);
        draw_line_width(x+width-1, y+1, x+width-1, y+height-1, 2);

        // 3. Primary Node Tag & Hover Logic
        if (_show_labels) {
            var _name = get_name() ?? ("Node_" + string(__uuid));
            var _tw = string_width(_name) + 6, _th = string_height(_name);
            var _lx1 = x + 2, _ly1 = y + 2, _lx2 = _lx1 + _tw, _ly2 = _ly1 + _th;

            // Check Hover (GUI space)
            var _mx = device_mouse_x_to_gui(0), _my = device_mouse_y_to_gui(0);
            if (_mx >= _lx1 && _mx <= _lx2 && _my >= _ly1 && _my <= _ly2) {
                array_push(__hover_stack, { name: _name, col: _col_main, depth: _depth });
            }

            draw_set_alpha(1.0); draw_set_color(c_black);
            draw_rectangle(_lx1, _ly1, _lx2, _ly2, false);
            draw_set_color(c_white);
            draw_text(_lx1 + 3, _ly1, _name);
        }

        // 4. Recurse
        var _count = array_length(__children);
        for (var i = 0; i < _count; i++) {
            __children[i].draw_debug(_depth + 1, _max_depth, _padding, _margin, _show_labels);
        }

        // 5. Render Popover (Root only)
        if (_depth == 0 && array_length(__hover_stack) > 1) {
            var _px = device_mouse_x_to_gui(0) + 12, _py = device_mouse_y_to_gui(0) + 12;
            var _p_count = array_length(__hover_stack);
            var _p_th = string_height("M") + 4;
            var _p_tw = 120;
            
            for(var i=0; i<_p_count; i++) _p_tw = max(_p_tw, string_width(__hover_stack[i].name) + 24);

            draw_set_alpha(0.95); draw_set_color(c_black);
            draw_rectangle(_px, _py, _px + _p_tw, _py + (_p_count * _p_th) + 4, false);
            draw_set_color(c_dkgray);
            draw_rectangle(_px, _py, _px + _p_tw, _py + (_p_count * _p_th) + 4, true);

            for (var i = 0; i < _p_count; i++) {
                var _item = __hover_stack[i];
                var _iy = _py + 2 + (i * _p_th);
                draw_set_color(_item.col);
                draw_rectangle(_px + 4, _iy + 4, _px + 8, _iy + _p_th - 4, false);
                draw_set_color(c_white);
                draw_text(_px + 14, _iy, _item.name);
            }
        }
        draw_set_alpha(1.0);
    };
	
	// -------------------------------------------------------------------------
	// Reflow directive
	// -------------------------------------------------------------------------
	#region jsDoc
	/// @desc Marks this node as needing layout/reflow. Does not immediately call reflow.
	#endregion
	static request_reflow = function()
	{
		__root.__reflow_dirty = true;
	};
	
	#region jsDoc
	/// @desc
	///		Does reflow if dirty, and refreshes cached layout for this node + all children.
	///		Uses static stacks (no per-entry structs).
	///		x/y are absolute (accumulated parent offsets), width/height are local.
	///		Returns true if reflow happened.
	#endregion
	static attempt_reflow = function(_x=0, _y=0, _w=camera_get_view_width(view_camera[0]), _h=camera_get_view_height(view_camera[0]), _d=flexpanel_direction.LTR, _force=false)
	{
		// Avoid Rebuild
		if (!__reflow_dirty)
		&& (!_force)
		&& (__reflow_last_x == _x)
		&& (__reflow_last_y == _y)
		&& (__reflow_last_w == _w)
		&& (__reflow_last_h == _h)
		&& (__reflow_last_d == _d)
		{
			return false;
		}
		
		__reflow_dirty = false;
		__reflow_last_x = _x;
		__reflow_last_y = _y;
		__reflow_last_w = _w;
		__reflow_last_h = _h;
		__reflow_last_d = _d;
		
		// reflow the layout
		flexpanel_calculate_layout(node_handle, _w,  _h, _d);
		
		// Static stacks reused across calls (no per-call allocations once warmed)
		static __stack_node = [];
		static __stack_x = [];
		static __stack_y = [];
		var _stack_node = __stack_node;
		var _stack_x = __stack_x;
		var _stack_y = __stack_y;
		
		array_push(_stack_node, self);
		array_push(_stack_x, _x);
		array_push(_stack_y, _y);
		
		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);
			var _absx_parent = array_pop(_stack_x);
			var _absy_parent = array_pop(_stack_y);
			
			var _layout = flexpanel_node_layout_get_position(_node.node_handle, true);
			_node.__cache_layout = _layout;
			
			_node.x = _absx_parent + _layout.left;
			_node.y = _absy_parent + _layout.top;
			
			_node.w = _layout.width;
			_node.h = _layout.height;
			_node.width = _layout.width;
			_node.height = _layout.height;
			
			var _count = array_length(_node.__children);
			if (_count > 0)
			{
				for (var i = 0; i < _count; i++)
				{
					var _child = _node.__children[i];
					array_push(_stack_node, _child);
					array_push(_stack_x, _node.x);
					array_push(_stack_y, _node.y);
				}
			}
		}
		
		__cache_data = undefined;
		__cache_struct = undefined;
		
		return true;
	};
	
	// -------------------------------------------------------------------------
	// Minimal forwarding surface
	// -------------------------------------------------------------------------
	#region jsDoc
	/// @desc Adds a child node (append). Also wires wrapper links: parent + root.
	/// @param {Reflex} _child_node
	#endregion
	static add = function(_child_node)
	{
		insert(_child_node, -1);
	};
	
	#region jsDoc
	/// @desc Inserts a child node at an index (or append if index < 0).
	///       Also wires wrapper links: parent + root.
	/// @param {Reflex} _child_node
	/// @param {Real} _index_value
	#endregion
	static insert = function(_child_node, _index_value=-1)
	{
		if (_child_node == undefined) { return; }
		if (_child_node == self) { return; }

		// Detach from old parent (wrapper side)
		if (_child_node.__parent != undefined)
		{
			_child_node.__parent.remove(_child_node);
		}

		// Choose insertion index
		var _insert_index = _index_value;
		if (_insert_index < 0) { _insert_index = array_length(__children); }
		if (_insert_index > array_length(__children)) { _insert_index = array_length(__children); }

		// Wrapper links
		_child_node.__parent = self;
		_child_node.__root = __root;

		// Wrapper child list
		array_insert(__children, _insert_index, _child_node);

		// Flexpanel tree
		flexpanel_node_insert_child(node_handle, _child_node.node_handle, _insert_index);

		request_reflow();
	};
	
	#region jsDoc
	/// @desc Removes a child node. Also clears wrapper links.
	/// @param {Reflex} _child_node
	#endregion
	static remove = function(_child_node)
	{
		if (_child_node == undefined) { return; }
		if (_child_node.__parent != self) { return; }

		// Wrapper child list removal
		var _count = array_length(__children);
		for (var i = 0; i < _count; i++)
		{
			if (__children[i] == _child_node)
			{
				array_delete(__children, i, 1);
				break;
			}
		}

		// Wrapper links
		_child_node.__parent = undefined;
		_child_node.__root = _child_node;

		// Flexpanel tree
		flexpanel_node_remove_child(node_handle, _child_node.node_handle);

		request_reflow();
	};
	
	#region jsDoc
	/// @desc Removes all children nodes. Also clears wrapper links.
	/// @param {Bool} _keep_nodes
	///     If true, does not delete nodes, only detaches them from this parent.
	///     This wrapper currently only detaches in all cases.
	#endregion
	static clear = function(_keep_nodes=true)
	{
		var _count = array_length(__children);
		for (var i = 0; i < _count; i++)
		{
			var _child_node = __children[i];
			_child_node.__parent = undefined;
			_child_node.__root = _child_node;
		}

		__children = [];

		flexpanel_node_remove_all_children(node_handle);

		request_reflow();
	};
	
	#region jsDoc
	/// @desc
	///		Searches for a child component by name.
	///		Uses a static stack (no per-entry structs) when recursive.
	///		By default, only searches direct children.
	///
	/// @param {String} _name_value
	/// @param {Bool} _recursive
	///		If true, searches the entire subtree; if false, only direct children.
	/// @returns {reflex|Undefined}
	#endregion
	static find_by_name = function(_name_value, _recursive=false)
	{
		if (!_recursive)
		{
			var _count = array_length(__children);
			for (var i = 0; i < _count; i++)
			{
				var _child = __children[i];
				if (_child.get_name() == _name_value)
				{
					return _child;
				}
			}

			return undefined;
		}

		// Recursive (stack-based)
		static __stack_node = [];
		var _stack_node = __stack_node;

		array_push(_stack_node, self);

		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);

			if (_node.get_name() == _name_value)
			{
				return _node;
			}

			var _child_count = array_length(_node.__children);
			if (_child_count > 0)
			{
				for (var j = 0; j < _child_count; j++)
				{
					array_push(_stack_node, _node.__children[j]);
				}
			}
		}

		return undefined;
	};
	
	// -------------------------------------------------------------------------
	// Flexpanel API
	// -------------------------------------------------------------------------
	#region Setters
	static set_name = function(_name_value) { flexpanel_node_set_name(node_handle, _name_value); return self; };
	static set_measure_function = function(_measure_function) { flexpanel_node_set_measure_function(node_handle, _measure_function); request_reflow(); return self; };
	static set_align_content = function(_align_value) { flexpanel_node_style_set_align_content(node_handle, _align_value); request_reflow(); return self; };
	static set_align_items = function(_align_value) { flexpanel_node_style_set_align_items(node_handle, _align_value); request_reflow(); return self; };
	static set_align_self = function(_align_value) { flexpanel_node_style_set_align_self(node_handle, _align_value); request_reflow(); return self; };
	static set_aspect_ratio = function(_aspect_ratio) { flexpanel_node_style_set_aspect_ratio(node_handle, _aspect_ratio); request_reflow(); return self; };
	static set_display = function(_display_value) { flexpanel_node_style_set_display(node_handle, _display_value); request_reflow(); return self; };
	static set_flex = function(_flex_value) { flexpanel_node_style_set_flex(node_handle, _flex_value); request_reflow(); return self; };
	static set_flex_wrap = function(_wrap_value) { flexpanel_node_style_set_flex_wrap(node_handle, _wrap_value); request_reflow(); return self; };
	static set_flex_grow = function(_grow_value) { flexpanel_node_style_set_flex_grow(node_handle, _grow_value); request_reflow(); return self; };
	static set_flex_shrink = function(_shrink_value) { flexpanel_node_style_set_flex_shrink(node_handle, _shrink_value); request_reflow(); return self; };
	static set_flex_basis = function(_value, _unit_value) { flexpanel_node_style_set_flex_basis(node_handle, _value, _unit_value); request_reflow(); return self; };
	static set_flex_direction = function(_flex_direction_value) { flexpanel_node_style_set_flex_direction(node_handle, _flex_direction_value); request_reflow(); return self; };
	static set_gap = function(_gutter_value, _size_value) { flexpanel_node_style_set_gap(node_handle, _gutter_value, _size_value); request_reflow(); return self; };
	static set_position = function(_edge_value, _value, _unit_value) { flexpanel_node_style_set_position(node_handle, _edge_value, _value, _unit_value); request_reflow(); return self; };
	static set_justify_content = function(_justify_value) { flexpanel_node_style_set_justify_content(node_handle, _justify_value); request_reflow(); return self; };
	static set_direction = function(_direction_value) { flexpanel_node_style_set_direction(node_handle, _direction_value); request_reflow(); return self; };
	static set_margin = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { flexpanel_node_style_set_margin(node_handle, _edge_value, _size_value, _unit_value); request_reflow(); return self; };
	static set_padding = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { flexpanel_node_style_set_padding(node_handle, _edge_value, _size_value, _unit_value); request_reflow(); return self; };
	static set_border = function(_edge_value, _size_value) { flexpanel_node_style_set_border(node_handle, _edge_value, _size_value); request_reflow(); return self; };
	static set_position_type = function(_position_type_value) { flexpanel_node_style_set_position_type(node_handle, _position_type_value); request_reflow(); return self; };
	static set_min_width = function(_value, _unit_value) { flexpanel_node_style_set_min_width(node_handle, _value, _unit_value); request_reflow(); return self; };
	static set_max_width = function(_value, _unit_value) { flexpanel_node_style_set_max_width(node_handle, _value, _unit_value); request_reflow(); return self; };
	static set_min_height = function(_value, _unit_value) { flexpanel_node_style_set_min_height(node_handle, _value, _unit_value); request_reflow(); return self; };
	static set_max_height = function(_value, _unit_value) { flexpanel_node_style_set_max_height(node_handle, _value, _unit_value); request_reflow(); return self; };
	static set_width = function(_val, _unit_value) {
        if (_unit_value == undefined) {
			var _res = __resolve_unit(_val);
			_val = _res.value;
			_unit_value = _res.unit
		}
		
		flexpanel_node_style_set_width(node_handle, _val, _unit_value);
        request_reflow();
        return self;
    };
    static set_height = function(_val, _unit_value) {
        if (_unit_value == undefined) {
			var _res = __resolve_unit(_val);
			_val = _res.value;
			_unit_value = _res.unit
		}
		
		flexpanel_node_style_set_height(node_handle, _val, _unit_value);
		request_reflow();
        return self;
    };
	#endregion
	
	#region Getters
	
	#region Layout (Output after reflow)
	static get_layout_position = function()	{ return __cache_layout; };
	static get_layout_struct = function() { return __cache_layout; };
	static get_layout_left = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.left; };
	static get_layout_top = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.top; };
	static get_layout_right = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.right; };
	static get_layout_bottom = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.bottom; };
	static get_layout_padding_left = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.paddingLeft; };
	static get_layout_padding_right = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.paddingRight; };
	static get_layout_padding_top = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.paddingTop; };
	static get_layout_padding_bottom = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.paddingBottom; };
	static get_layout_margin_left = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.marginLeft; };
	static get_layout_margin_right = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.marginRight; };
	static get_layout_margin_top = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.marginTop; };
	static get_layout_margin_bottom = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.marginBottom; };
	static get_layout_direction = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.direction; };
	static get_layout_had_overflow = function() { return (__cache_layout == undefined) ? false : __cache_layout.hadOverflow; };
	static get_layout_x = function() { return x; };
	static get_layout_y = function() { return y; };
	static get_layout_width = function() { return width; };
	static get_layout_height = function() { return height; };
	#endregion

	
	static get_data = function()	{
		__cache_data ??= flexpanel_node_get_data(node_handle);
		return __cache_data;
	};
	static get_struct = function()	{
		__cache_struct ??= flexpanel_node_get_struct(node_handle);
		return __cache_struct;
	};

	// Style getters are live (since style is no longer refreshed during reflow)
	static get_width = function()	{ return flexpanel_node_style_get_width(node_handle); };
	static get_height = function()	{ return flexpanel_node_style_get_height(node_handle); };
	static get_min_width = function()	{ return flexpanel_node_style_get_min_width(node_handle); };
	static get_max_width = function()	{ return flexpanel_node_style_get_max_width(node_handle); };
	static get_min_height = function()	{ return flexpanel_node_style_get_min_height(node_handle); };
	static get_max_height = function()	{ return flexpanel_node_style_get_max_height(node_handle); };
	static get_flex_basis = function()	{ return flexpanel_node_style_get_flex_basis(node_handle); };

	static get_margin = function(_edge_value)	{ return flexpanel_node_style_get_margin(node_handle, _edge_value); };
	static get_padding = function(_edge_value)	{ return flexpanel_node_style_get_padding(node_handle, _edge_value); };
	static get_border = function(_edge_value)	{ return flexpanel_node_style_get_border(node_handle, _edge_value); };
	static get_position = function(_edge_value)	{ return flexpanel_node_style_get_position(node_handle, _edge_value); };

	static get_align_content = function()	{ return flexpanel_node_style_get_align_content(node_handle); };
	static get_align_items = function()	{ return flexpanel_node_style_get_align_items(node_handle); };
	static get_align_self = function()	{ return flexpanel_node_style_get_align_self(node_handle); };
	static get_aspect_ratio = function()	{ return flexpanel_node_style_get_aspect_ratio(node_handle); };
	static get_display = function()	{ return flexpanel_node_style_get_display(node_handle); };
	static get_flex = function()	{ return flexpanel_node_style_get_flex(node_handle); };
	static get_flex_wrap = function()	{ return flexpanel_node_style_get_flex_wrap(node_handle); };
	static get_flex_grow = function()	{ return flexpanel_node_style_get_flex_grow(node_handle); };
	static get_flex_shrink = function()	{ return flexpanel_node_style_get_flex_shrink(node_handle); };
	static get_flex_direction = function()	{ return flexpanel_node_style_get_flex_direction(node_handle); };
	static get_justify_content = function()	{ return flexpanel_node_style_get_justify_content(node_handle); };
	static get_direction = function()	{ return flexpanel_node_style_get_direction(node_handle); };
	static get_position_type = function()	{ return flexpanel_node_style_get_position_type(node_handle); };
	static get_gap = function(_gutter_value) { return flexpanel_node_style_get_gap(node_handle, _gutter_value); };

	// Tree/node info getters stay live
	static get_num_children = function()	{ return flexpanel_node_get_num_children(node_handle); };
	static get_child = function(_index_or_name)	{ return flexpanel_node_get_child(node_handle, _index_or_name); };
	static get_child_hash = function(_hash_or_name)	{ return flexpanel_node_get_child_hash(node_handle, _hash_or_name); };
	static get_parent = function()	{ return flexpanel_node_get_parent(node_handle); };
	static get_name = function()	{ return flexpanel_node_get_name(node_handle); };
	static get_measure_function = function()	{ return flexpanel_node_get_measure_function(node_handle); };
	#endregion
	
	// -------------------------------------------------------------------------
	// PRIVITE
	// -------------------------------------------------------------------------
	#region Private
	//keep an on running count
	static __global_uuid = 0;
	__global_uuid++;
	
	__uuid = __global_uuid;
	
	__root = self;
	__parent = undefined;
	__children = [];

	__reflow_dirty = false;
	__reflow_last_x = 0;
	__reflow_last_y = 0;
	__reflow_last_w = 0;
	__reflow_last_h = 0;
	__reflow_last_d = -1;
	
	// -------------------------------------------------------------------------
	// Cached returns (struct/array only)
	// -------------------------------------------------------------------------

	// flexpanel_node_layout_get_position(node, [relative]) -> Struct
	__cache_layout = undefined;

	// flexpanel_node_get_data(node) -> Struct
	__cache_data = undefined;

	// flexpanel_node_get_struct(node) -> Struct
	__cache_struct = undefined;
     
    // -------------------------------------------------------------------------
	// Helpers
	// -------------------------------------------------------------------------
    
    /// @ignore Internal Unit Resolver
    static __resolve_unit = function(_val) {
		//avoid garbage collecter
		static __struct = {};
		
        if (is_real(_val)) {
			__struct.value = _val;
	        __struct.unit = flexpanel_unit.point;
			return __struct;
		}
        if (is_string(_val)) {
            if (_val == "auto") {
				__struct.value = 0;
		        __struct.unit = flexpanel_unit.auto;
				return __struct;
			}
			
            if (string_ends_with(_val, "%")) {
				__struct.value = real(string_copy(_val, 1, string_length(_val) - 1));
		        __struct.unit = flexpanel_unit.percent;
				return __struct;
            }
        }
        
		__struct.value = 0;
        __struct.unit = flexpanel_unit.point;
		return __struct;
    };
	
	#region Garbage Collection
	
	////////////////////////////////////////////////////////////////////////////////
	// This is all really complicated code to efficiently garbage collect lost data
	//   structures like ds_list, ds_maps, and in this case flexpanels.
	// Dont worry about reading or understanding any of it, its all self contained.
	////////////////////////////////////////////////////////////////////////////////
	
	#region Dont Bother
	enum __REFLEX_DESTRUCTOR { TTL = 0, REF = 1, }
	static __gc = {
		grid: ds_grid_create(2, 0),
		used_rows: 0,
		time_source: undefined,
		collection_rate: 0,
		min_true_rows: 256,
	};

	//init
	if (__gc.time_source == undefined) {
		__gc.time_source = time_source_create(time_source_global, 1, time_source_units_frames,
			function() {
				static __gc = Reflex.__gc;
				var _grid = __gc.grid;
				var _used_rows = __gc.used_rows;
				var _used_rows_start = _used_rows;
				var _tru_rows = ds_grid_height(_grid);
				
				// Decrement TTL for logical rows only.
				if (_used_rows > 0) {
					ds_grid_add_region(_grid, __REFLEX_DESTRUCTOR.TTL, 0, __REFLEX_DESTRUCTOR.TTL, _used_rows - 1, -1);
				}
				
				// sort all objects by TTL ascending (expired float to the top half)
				ds_grid_sort(_grid, __REFLEX_DESTRUCTOR.TTL, true);
				
				// Sweep top for expired items (TTL <= 0)
				var _i = 0;
				repeat (_used_rows) {
					if (_grid[# __REFLEX_DESTRUCTOR.TTL, _i]) {
						break;
					}
					else {
						var _ref = _grid[# __REFLEX_DESTRUCTOR.REF, _i];
						if (weak_ref_alive(_ref)) {
							_grid[# __REFLEX_DESTRUCTOR.TTL, _i] = __gc.collection_rate;
						} else {
							flexpanel_delete_node(_ref.value);
							_grid[# __REFLEX_DESTRUCTOR.TTL, _i] = infinity; // large positive sentinel
							_grid[# __REFLEX_DESTRUCTOR.REF, _i] = undefined;
							_used_rows--
						}
					}
					_i++;
				}
				
				if (_used_rows < _used_rows_start) {
					// Optional hysteresis shrink of capacity to avoid ping-pong:
					// If logical size is much smaller than capacity, shrink capacity by half, but never below a floor.
					var _min_tru_rows = __gc.min_true_rows;
					if (_tru_rows > _min_tru_rows) {
						if (_used_rows <= (_tru_rows >> 2)) {
							var _new_tru_rows = (_tru_rows >> 1);
							if (_new_tru_rows < _min_tru_rows) _new_tru_rows = _min_tru_rows;
							if (_new_tru_rows < _tru_rows && _new_tru_rows >= _used_rows) {
								ds_grid_sort(_grid, __REFLEX_DESTRUCTOR.TTL, true);
								ds_grid_resize(_grid, 2, _new_tru_rows);
								_tru_rows = _new_tru_rows;
							}
						}
					}
				}
				
				__gc.used_rows = _used_rows;
				
		    }, [], -1);
		time_source_start(__gc.time_source);
	}
	
	//register
	with(weak_ref_create(self)) {
		value = other.node_handle;
		var _grid = __gc.grid;
	    var _used_rows = __gc.used_rows;
	    var _tru_rows = ds_grid_height(_grid);
		
		// If we are at capacity, grow geometrically (x2) and initialize slack rows.
		if (_used_rows >= _tru_rows) {
			var _new_tru_rows = (_tru_rows < 4) ? 4 : (_tru_rows << 1);
			ds_grid_resize(_grid, 2, _new_tru_rows);
			
			// Initialize newly added rows to sentinel values so they never get decremented or processed.
			var _y = _tru_rows;
			var _limit = _new_tru_rows - 1;
			while (_y <= _limit) {
				_grid[# __REFLEX_DESTRUCTOR.TTL, _y] = infinity; // large positive sentinel
				_grid[# __REFLEX_DESTRUCTOR.REF, _y] = undefined;
				_y += 1;
			}
			_tru_rows = _new_tru_rows;
		}
		
		_grid[# __REFLEX_DESTRUCTOR.TTL, _used_rows] = irandom(15)+__gc.collection_rate;
	    _grid[# __REFLEX_DESTRUCTOR.REF, _used_rows] = self;

	    // Advance logical size without touching capacity.
	    __gc.used_rows = _used_rows + 1;
	}
	#endregion
	
	#endregion
	
	#endregion
	
}

