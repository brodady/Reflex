#region jsDoc
/// @func Reflex
/// @desc
///		A lightweight wrapper around a flexpanel node.
///		It owns a node handle, maintains a parent/child wrapper tree, and exposes a small,
///		public API for styling, layout, and debug visualization.
///		.
///		After attempt_reflow(), each node caches its layout struct and updates x/y/width/height
///		for fast access during drawing and interaction.
///
#endregion
function Reflex(_data=undefined) constructor
{
	// -------------------------------------------------------------------------
	// Variables
	// -------------------------------------------------------------------------
	// Owned node handle
	node_handle = (_data == undefined) ? flexpanel_create_node() : flexpanel_create_node(_data);
	
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
	/// @func    draw_debug()
	/// @desc    Draws a debug visualization for this node and its subtree.
	///          Can visualize padding and margin regions, and can show label popovers when hovering
	///          node name tags. Intended for use in Draw GUI.
	/// @self    Reflex
	/// @param   {Real} depth : Internal recursion depth (caller should leave at default).
	/// @param   {Real} max_depth : Stops recursion after this depth. Use -1 for unlimited.
	/// @param   {Bool} padding : If true, draws the padding region and padding value labels.
	/// @param   {Bool} margin : If true, draws the margin region and margin value labels.
	/// @param   {Bool} show_labels : If true, draws name tags and numeric margin/padding labels.
	/// @returns {Undefined}
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
	/// @func    request_reflow()
	/// @desc    Marks the root node as needing layout reflow.
	///          This does not calculate layout immediately - it only sets a dirty flag.
	/// @self    Reflex
	/// @returns {Undefined}
	#endregion
	static request_reflow = function()
	{
		__root.__reflow_dirty = true;
	};
	
	#region jsDoc
	/// @func    attempt_reflow()
	/// @desc    Calculates flexpanel layout if needed, then refreshes cached layout values for
	///          this node and its children. Updates:
	///          - __cache_layout (raw flexpanel layout struct)
	///          - x, y (absolute GUI positions using passed _x/_y as origin)
	///          - w, h, width, height (layout sizes)
	///          Returns true only when a reflow actually occurred.
	/// @self    Reflex
	/// @param   {Real} x : Origin x used as the absolute offset for all computed node positions.
	/// @param   {Real} y : Origin y used as the absolute offset for all computed node positions.
	/// @param   {Real} w : Width of the layout space passed to flexpanel_calculate_layout().
	/// @param   {Real} h : Height of the layout space passed to flexpanel_calculate_layout().
	/// @param   {Struct.flexpanel_direction} direction : Layout direction passed to flexpanel_calculate_layout().
	/// @param   {Bool} force : If true, forces layout calculation even when inputs match last reflow.
	/// @returns {Bool}
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
		var _stack_node = __stack_node;
		
		array_push(_stack_node, self);
		
		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);
			
			var _layout = flexpanel_node_layout_get_position(_node.node_handle, false);
			_node.__cache_layout = _layout;
			
			_node.x = _x + _layout.left;
			_node.y = _y + _layout.top;
			
			_node.w = _layout.width;
			_node.h = _layout.height;
			_node.width = _layout.width;
			_node.height = _layout.height;
			
			var _child_count = array_length(_node.__children);
			if (_child_count > 0) {
				array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
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
	/// @func    add()
	/// @desc    Appends a child node to the end of this node's children list.
	///          Equivalent to insert(_child_node, -1).
	/// @self    Reflex
	/// @param   {Struct.Reflex} node : Child node to append.
	/// @returns {Undefined}
	#endregion
	static add = function(_child_node)
	{
		insert(_child_node, -1);
	};
	
	#region jsDoc
	/// @func    insert()
	/// @desc    Inserts a child node at the given index (or appends if index < 0).
	///          Also rewires wrapper links:
	///          - Detaches from the old parent if needed
	///          - Sets child's __parent to this node
	///          - Sets child's __root to this node's root
	///          Mirrors the change into the underlying flexpanel tree and requests reflow.
	/// @self    Reflex
	/// @param   {Struct.Reflex} node : Child node to insert.
	/// @param   {Real} index : Target index. If < 0, appends. Clamped to valid range.
	/// @returns {Undefined}
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

		// Wrapper child list
		array_insert(__children, _insert_index, _child_node);
		
		_child_node.__parent = self;
		
		// Recursive update root and parent
		static __stack_node = [];
		var _stack_node = __stack_node;
		array_push(_stack_node, _child_node);
		
		var _root = __root;
		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);
			_node.__root = _root;
			
			var _child_count = array_length(_node.__children);
			if (_child_count > 0) {
				array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
			}
		}
		
		// Flexpanel tree
		flexpanel_node_insert_child(node_handle, _child_node.node_handle, _insert_index);

		request_reflow();
	};
	
	#region jsDoc
	/// @func    remove()
	/// @desc    Removes a child node from this node.
	///          Clears wrapper links (child __parent becomes undefined; child __root becomes itself),
	///          removes the child from the flexpanel tree, and requests reflow.
	///          Does nothing if the node is not a direct child of this node.
	/// @self    Reflex
	/// @param   {Struct.Reflex} node : Child node to remove.
	/// @returns {Undefined}
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
	/// @func    clear()
	/// @desc    Removes all children from this node.
	///          Detaches each child (clears __parent and resets __root to itself),
	///          removes all flexpanel children, and requests reflow.
	/// @self    Reflex
	/// @returns {Undefined}
	#endregion
	static clear = function()
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
	/// @func    find_by_name()
	/// @desc    Searches for a child component by name.
	///          If recursive is false, searches only direct children.
	///          If recursive is true, searches the entire subtree.
	/// @self    Reflex
	/// @param   {String} name : Name to search for (compared against get_name()).
	/// @param   {Bool} recursive : If true, searches the entire subtree; if false, only direct children.
	/// @returns {Struct.Reflex|Undefined}
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
			if (_child_count > 0) {
				array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
			}
		}

		return undefined;
	};
	
	// -------------------------------------------------------------------------
	// Flexpanel API
	// -------------------------------------------------------------------------
	#region Setters
	#region jsDoc
	/// @func    set_name()
	/// @desc    Sets the name of the node.
	/// @self    Reflex
	/// @param   {Pointer.FlexpanelNode} name_value : The node.
	/// @returns {Struct.Reflex}
	#endregion
	static set_name = function(_name_value) { flexpanel_node_set_name(node_handle, _name_value); return self; };
	#region jsDoc
	/// @func    set_measure_function()
	/// @desc    Sets the measure function of the node. When a layout is calculated and a measurement
	///          is required (there are various reasons why this may or may not happen, i.e. if parents
	///          have absolute widths and heights) then the given GML function will be called and it
	///          should return a struct with members `width` with the calculated width and/or `height`
	///          with the calculated height.
	/// @self    Reflex
	/// @param   {Pointer.FlexpanelNode} measure_function : The node.
	/// @returns {Struct.Reflex}
	#endregion
	static set_measure_function = function(_measure_function) { flexpanel_node_set_measure_function(node_handle, _measure_function); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_align_content()
	/// @desc    Sets the alignment of the content of the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_justify} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_content = function(_align_value) { flexpanel_node_style_set_align_content(node_handle, _align_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_align_items()
	/// @desc    Sets the alignment of the items of the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_align} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_items = function(_align_value) { flexpanel_node_style_set_align_items(node_handle, _align_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_align_self()
	/// @desc    Sets the alignment of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_align} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_self = function(_align_value) { flexpanel_node_style_set_align_self(node_handle, _align_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_aspect_ratio()
	/// @desc    Sets the node's aspect ratio
	/// @self    Reflex
	/// @param   {Real} aspect_ratio : The value
	/// @returns {Struct.Reflex}
	#endregion
	static set_aspect_ratio = function(_aspect_ratio) { flexpanel_node_style_set_aspect_ratio(node_handle, _aspect_ratio); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_display()
	/// @desc    Sets the display setting of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_display} display_value : The selected display.
	/// @returns {Struct.Reflex}
	#endregion
	static set_display = function(_display_value) { flexpanel_node_style_set_display(node_handle, _display_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex()
	/// @desc    Sets the flex value of the selected node.
	/// @self    Reflex
	/// @param   {Real} flex_value : The flex value for this
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex = function(_flex_value) { flexpanel_node_style_set_flex(node_handle, _flex_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_wrap()
	/// @desc    Sets the flex wrap of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_wrap} wrap_value : The selected wrap.
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_wrap = function(_wrap_value) { flexpanel_node_style_set_flex_wrap(node_handle, _wrap_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_grow()
	/// @desc    Sets the flex grow of the selected node.
	/// @self    Reflex
	/// @param   {Real} grow_value : The selected grow factor
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_grow = function(_grow_value) { flexpanel_node_style_set_flex_grow(node_handle, _grow_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_shrink()
	/// @desc    Sets the flex shrink of the selected node.
	/// @self    Reflex
	/// @param   {Real} shrink_value : The selected shrink factor
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_shrink = function(_shrink_value) { flexpanel_node_style_set_flex_shrink(node_handle, _shrink_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_basis()
	/// @desc    Sets the flex basis of the selected node.
	/// @self    Reflex
	/// @param   {Real} value : The selected flex basis value
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_basis = function(_value, _unit_value) { flexpanel_node_style_set_flex_basis(node_handle, _value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_direction()
	/// @desc    Sets the flex direction of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_flex_direction} flex_direction_value : The selected direction.
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_direction = function(_flex_direction_value) { flexpanel_node_style_set_flex_direction(node_handle, _flex_direction_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_gap()
	/// @desc    Sets the gap of the selected node for the selected gutters.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_gutter} gutter_value : The selected gutter (column/row/all).
	/// @param   {Real} size_value : The selected gap size
	/// @returns {Struct.Reflex}
	#endregion
	static set_gap = function(_gutter_value, _size_value) { flexpanel_node_style_set_gap(node_handle, _gutter_value, _size_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_position()
	/// @desc    Sets an inset position on the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} value : The value
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_position = function(_edge_value, _value, _unit_value) { flexpanel_node_style_set_position(node_handle, _edge_value, _value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_justify_content()
	/// @desc    Sets the node's contents justification
	/// @self    Reflex
	/// @param   {Enum.flexpanel_justify} justify_value : The justification to use
	/// @returns {Struct.Reflex}
	#endregion
	static set_justify_content = function(_justify_value) { flexpanel_node_style_set_justify_content(node_handle, _justify_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_direction()
	/// @desc    Sets the layout direction of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_direction} direction_value : The selected direction.
	/// @returns {Struct.Reflex}
	#endregion
	static set_direction = function(_direction_value) { flexpanel_node_style_set_direction(node_handle, _direction_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_margin()
	/// @desc    Sets the margin of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected padding size
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_margin = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { flexpanel_node_style_set_margin(node_handle, _edge_value, _size_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_padding()
	/// @desc    Sets the padding of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected padding size
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_padding = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { flexpanel_node_style_set_padding(node_handle, _edge_value, _size_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_border()
	/// @desc    Sets the border of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected border size
	/// @returns {Struct.Reflex}
	#endregion
	static set_border = function(_edge_value, _size_value) { flexpanel_node_style_set_border(node_handle, _edge_value, _size_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_position_type()
	/// @desc    Sets the node's position type.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_position_type} position_type_value : The position type to use
	/// @returns {Struct.Reflex}
	#endregion
	static set_position_type = function(_position_type_value) { flexpanel_node_style_set_position_type(node_handle, _position_type_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_min_width()
	/// @desc    Sets the node's minimum width
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_min_width = function(_value, _unit_value) { flexpanel_node_style_set_min_width(node_handle, _value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_max_width()
	/// @desc    Sets the node's maximum width
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_max_width = function(_value, _unit_value) { flexpanel_node_style_set_max_width(node_handle, _value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_min_height()
	/// @desc    Sets the node's minimum height
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_min_height = function(_value, _unit_value) { flexpanel_node_style_set_min_height(node_handle, _value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_max_height()
	/// @desc    Sets the node's maximum height
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_max_height = function(_value, _unit_value) { flexpanel_node_style_set_max_height(node_handle, _value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_width()
	/// @desc    Sets the width of the selected node.
	/// @self    Reflex
	/// @param   {Real} val : The selected width.
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
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
    #region jsDoc
    /// @func    set_height()
    /// @desc    Sets the height of the selected node.
    /// @self    Reflex
    /// @param   {Real} val : The selected height.
    /// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
    /// @returns {Struct.Reflex}
    #endregion
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
	#region jsDoc
	/// @func    get_layout_position()
	/// @desc    Returns the calculated node layout position as a struct: {left, top, width, height, bottom, right, hadOverflow, direction, paddingLeft, paddingRight, paddingTop, paddingBottom, marginLeft, marginRight, marginToip, marginBottom}.
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_layout_position = function()	{ return __cache_layout; };
	#region jsDoc
	/// @func    get_layout_struct()
	/// @desc    Alias of get_layout_position(). Returns the cached flexpanel layout struct (or undefined).
	/// @self    Reflex
	/// @returns {Struct|Undefined}
	#endregion
	static get_layout_struct = function() { return __cache_layout; };
	#region jsDoc
	/// @func    get_layout_left()
	/// @desc    Returns the cached layout left offset (relative to the reflow origin). Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_left = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.left; };
	#region jsDoc
	/// @func    get_layout_top()
	/// @desc    Returns the cached layout top offset (relative to the reflow origin). Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_top = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.top; };
	#region jsDoc
	/// @func    get_layout_right()
	/// @desc    Returns the cached layout right value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_right = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.right; };
	#region jsDoc
	/// @func    get_layout_bottom()
	/// @desc    Returns the cached layout bottom value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_bottom = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.bottom; };
	#region jsDoc
	/// @func    get_layout_padding_left()
	/// @desc    Returns the cached layout paddingLeft value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_padding_left = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.paddingLeft; };
	#region jsDoc
	/// @func    get_layout_padding_right()
	/// @desc    Returns the cached layout paddingRight value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_padding_right = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.paddingRight; };
	#region jsDoc
	/// @func    get_layout_padding_top()
	/// @desc    Returns the cached layout paddingTop value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_padding_top = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.paddingTop; };
	#region jsDoc
	/// @func    get_layout_padding_bottom()
	/// @desc    Returns the cached layout paddingBottom value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_padding_bottom = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.paddingBottom; };
	#region jsDoc
	/// @func    get_layout_margin_left()
	/// @desc    Returns the cached layout marginLeft value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_margin_left = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.marginLeft; };
	#region jsDoc
	/// @func    get_layout_margin_right()
	/// @desc    Returns the cached layout marginRight value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_margin_right = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.marginRight; };
	#region jsDoc
	/// @func    get_layout_margin_top()
	/// @desc    Returns the cached layout marginTop value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_margin_top = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.marginTop; };
	#region jsDoc
	/// @func    get_layout_margin_bottom()
	/// @desc    Returns the cached layout marginBottom value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_margin_bottom = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.marginBottom; };
	#region jsDoc
	/// @func    get_layout_direction()
	/// @desc    Returns the cached layout direction value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_direction = function() { return (__cache_layout == undefined) ? 0 : __cache_layout.direction; };
	#region jsDoc
	/// @func    get_layout_had_overflow()
	/// @desc    Returns whether the cached layout reported overflow. Returns false if no layout is cached.
	/// @self    Reflex
	/// @returns {Bool}
	#endregion
	static get_layout_had_overflow = function() { return (__cache_layout == undefined) ? false : __cache_layout.hadOverflow; };
	#region jsDoc
	/// @func    get_layout_x()
	/// @desc    Returns this node's absolute x position as set during the most recent reflow.
	///          This is computed as: reflow_origin_x + __cache_layout.left.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_x = function() { return x; };
	#region jsDoc
	/// @func    get_layout_y()
	/// @desc    Returns this node's absolute y position as set during the most recent reflow.
	///          This is computed as: reflow_origin_y + __cache_layout.top.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_y = function() { return y; };
	#region jsDoc
	/// @func    get_layout_width()
	/// @desc    Returns this node's width as set during the most recent reflow.
	///          This mirrors __cache_layout.width.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_width = function() { return width; };
	#region jsDoc
	/// @func    get_layout_height()
	/// @desc    Returns this node's height as set during the most recent reflow.
	///          This mirrors __cache_layout.height.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_height = function() { return height; };
	#endregion
	
	#region jsDoc
	/// @func    get_data()
	/// @desc    Returns the data struct of the flexpanel node.
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
		static get_data = function()	{
		__cache_data ??= flexpanel_node_get_data(node_handle);
		return __cache_data;
	};
	#region jsDoc
	/// @func    get_struct()
	/// @desc    Returns the layout data of the given node as a struct. This is the same data that can be passed into `new Reflex(_data)`.
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_struct = function()	{
		__cache_struct ??= flexpanel_node_get_struct(node_handle);
		return __cache_struct;
	};

	// Style getters are live (since style is no longer refreshed during reflow)
	#region jsDoc
	/// @func    get_width()
	/// @desc    Gets the width of the selected node.
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_width = function()	{ return flexpanel_node_style_get_width(node_handle); };
	#region jsDoc
	/// @func    get_height()
	/// @desc    Gets the height of the selected node.
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_height = function()	{ return flexpanel_node_style_get_height(node_handle); };
	#region jsDoc
	/// @func    get_min_width()
	/// @desc    Gets the node's minimum width
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_min_width = function()	{ return flexpanel_node_style_get_min_width(node_handle); };
	#region jsDoc
	/// @func    get_max_width()
	/// @desc    Gets the node's maximum width
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_max_width = function()	{ return flexpanel_node_style_get_max_width(node_handle); };
	#region jsDoc
	/// @func    get_min_height()
	/// @desc    Gets the node's minimum height
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_min_height = function()	{ return flexpanel_node_style_get_min_height(node_handle); };
	#region jsDoc
	/// @func    get_max_height()
	/// @desc    Gets the node's maximum height
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_max_height = function()	{ return flexpanel_node_style_get_max_height(node_handle); };
	#region jsDoc
	/// @func    get_flex_basis()
	/// @desc    Gets the flex basis of the selected node.
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_flex_basis = function()	{ return flexpanel_node_style_get_flex_basis(node_handle); };

	#region jsDoc
	/// @func    get_margin()
	/// @desc    Gets the margin of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @returns {Struct}
	#endregion
	static get_margin = function(_edge_value)	{ return flexpanel_node_style_get_margin(node_handle, _edge_value); };
	#region jsDoc
	/// @func    get_padding()
	/// @desc    Gets the padding of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @returns {Struct}
	#endregion
	static get_padding = function(_edge_value)	{ return flexpanel_node_style_get_padding(node_handle, _edge_value); };
	#region jsDoc
	/// @func    get_border()
	/// @desc    Gets the border of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @returns {Real}
	#endregion
	static get_border = function(_edge_value)	{ return flexpanel_node_style_get_border(node_handle, _edge_value); };
	#region jsDoc
	/// @func    get_position()
	/// @desc    Gets the node's style position.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @returns {Struct}
	#endregion
	static get_position = function(_edge_value)	{ return flexpanel_node_style_get_position(node_handle, _edge_value); };

	#region jsDoc
	/// @func    get_align_content()
	/// @desc    Gets the alignment of the content of the node.
	/// @self    Reflex
	/// @returns {Enum.flexpanel_justify}
	#endregion
	static get_align_content = function()	{ return flexpanel_node_style_get_align_content(node_handle); };
	#region jsDoc
	/// @func    get_align_items()
	/// @desc    Gets the alignment of the items of the node.
	/// @self    Reflex
	/// @returns {Enum.flexpanel_align}
	#endregion
	static get_align_items = function()	{ return flexpanel_node_style_get_align_items(node_handle); };
	#region jsDoc
	/// @func    get_align_self()
	/// @desc    Gets the alignment of the selected node.
	/// @self    Reflex
	/// @returns {Enum.flexpanel_align}
	#endregion
	static get_align_self = function()	{ return flexpanel_node_style_get_align_self(node_handle); };
	#region jsDoc
	/// @func    get_aspect_ratio()
	/// @desc    Gets the node's aspect ratio
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_aspect_ratio = function()	{ return flexpanel_node_style_get_aspect_ratio(node_handle); };
	#region jsDoc
	/// @func    get_display()
	/// @desc    Gets the display setting of the selected node.
	/// @self    Reflex
	/// @returns {Enum.flexpanel_display}
	#endregion
	static get_display = function()	{ return flexpanel_node_style_get_display(node_handle); };
	#region jsDoc
	/// @func    get_flex()
	/// @desc    Gets the flex value of the selected node.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_flex = function()	{ return flexpanel_node_style_get_flex(node_handle); };
	#region jsDoc
	/// @func    get_flex_wrap()
	/// @desc    Gets the flex wrap of the selected node.
	/// @self    Reflex
	/// @returns {Enum.flexpanel_wrap}
	#endregion
	static get_flex_wrap = function()	{ return flexpanel_node_style_get_flex_wrap(node_handle); };
	#region jsDoc
	/// @func    get_flex_grow()
	/// @desc    Gets the flex grow of the selected node.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_flex_grow = function()	{ return flexpanel_node_style_get_flex_grow(node_handle); };
	#region jsDoc
	/// @func    get_flex_shrink()
	/// @desc    Gets the flex shrink of the selected node.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_flex_shrink = function()	{ return flexpanel_node_style_get_flex_shrink(node_handle); };
	#region jsDoc
	/// @func    get_flex_direction()
	/// @desc    Gets the flex direction of the selected node.
	/// @self    Reflex
	/// @returns {Enum.flexpanel_flex_direction}
	#endregion
	static get_flex_direction = function()	{ return flexpanel_node_style_get_flex_direction(node_handle); };
	#region jsDoc
	/// @func    get_justify_content()
	/// @desc    Gets the node's contents justification
	/// @self    Reflex
	/// @returns {Enum.flexpanel_justify}
	#endregion
	static get_justify_content = function()	{ return flexpanel_node_style_get_justify_content(node_handle); };
	#region jsDoc
	/// @func    get_direction()
	/// @desc    Gets the direction of the selected node.
	/// @self    Reflex
	/// @returns {Enum.flexpanel_direction}
	#endregion
	static get_direction = function()	{ return flexpanel_node_style_get_direction(node_handle); };
	#region jsDoc
	/// @func    get_position_type()
	/// @desc    Gets the nodes position type
	/// @self    Reflex
	/// @returns {Enum.flexpanel_position_type}
	#endregion
	static get_position_type = function()	{ return flexpanel_node_style_get_position_type(node_handle); };
	#region jsDoc
	/// @func    get_gap()
	/// @desc    Gets the gap of the selected node on the selected side.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_gutter} gutter_value : The selected gutter (column/row/all).
	/// @returns {Real}
	#endregion
	static get_gap = function(_gutter_value) { return flexpanel_node_style_get_gap(node_handle, _gutter_value); };

	// Tree/node info getters stay live
	#region jsDoc
	/// @func    get_num_children()
	/// @desc    Returns the number of child nodes of the given node.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_num_children = function()	{ return flexpanel_node_get_num_children(node_handle); };
	#region jsDoc
	/// @func    get_child()
	/// @desc    Returns the child node of the given node either by index or name, undefined if out of
	///          range. If name is used then the search is done recursively through all the child nodes
	///          and the first matching node in a depth first traversal is returned.
	/// @self    Reflex
	/// @param   {Pointer.FlexpanelNode} index_or_name : The node.
	/// @returns {Pointer.FlexpanelNode}
	#endregion
	static get_child = function(_index_or_name)	{ return flexpanel_node_get_child(node_handle, _index_or_name); };
	#region jsDoc
	/// @func    get_child_hash()
	/// @desc    Returns the child node of the given node by its name or the hash of its name.
	/// @self    Reflex
	/// @param   {Pointer.FlexpanelNode} hash_or_name : The node.
	/// @returns {Pointer.FlexpanelNode}
	#endregion
	static get_child_hash = function(_hash_or_name)	{ return flexpanel_node_get_child_hash(node_handle, _hash_or_name); };
	#region jsDoc
	/// @func    get_parent()
	/// @desc    Returns the parent of the given node, undefined if no parent.
	/// @self    Reflex
	/// @returns {Pointer.FlexpanelNode}
	#endregion
	static get_parent = function()	{ return flexpanel_node_get_parent(node_handle); };
	#region jsDoc
	/// @func    get_name()
	/// @desc    Returns the name of the given node, undefined if no name is set.
	/// @self    Reflex
	/// @returns {String}
	#endregion
	static get_name = function()	{ return flexpanel_node_get_name(node_handle); };
	#region jsDoc
	/// @func    get_measure_function()
	/// @desc    Returns the measure function of the given node. `undefined` means that measure
	///          function is not set on this node.
	/// @self    Reflex
	/// @returns {Function}
	#endregion
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
    
    #region jsDoc
    /// @func    __resolve_unit()
    /// @desc    This function returns whether a given variable is a real number (single, double or
    ///          integer) or not.
    /// @self    Reflex
    /// @param   {Any} val : The argument to check.
    /// @returns {Bool}
    /// @ignore
	#endregion
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


