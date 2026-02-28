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
        static __draw_val = function(_cx, _cy, _val, _color) {
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
		
        var _layout = flexpanel_node_layout_get_position(node_handle, false);
        var _col_main = merge_color(c_blue, c_orange, min(_depth * 0.15, 1.0));
		
		var _x = _layout.left;
		var _y = _layout.top;
		var _w = (is_nan(_layout.width)) ? 0 : _layout.width;
		var _h = (is_nan(_layout.height)) ? 0 : _layout.height;
		
        // 1. Draw Margin & Padding (Line-based wireframes)
        if (_layout != undefined) {
            if (_margin) {
                draw_set_color(c_orange); draw_set_alpha(0.4);
                var _mx1 = _x - _layout.marginLeft, _my1 = _y - _layout.marginTop;
                var _mx2 = _x + _w + _layout.marginRight, _my2 = _y + _h + _layout.marginBottom;
                draw_rectangle(_mx1, _my1, _mx2, _my2, true);
                draw_line(_mx1, _my1, _x, _y); draw_line(_mx2, _my1, _x + _w, _y);
                draw_line(_mx1, _my2, _x, _y + _h); draw_line(_mx2, _my2, _x + _w, _y + _h);
                if (_show_labels) {
                    draw_set_alpha(1.0);
                    if (_layout.marginTop != 0)    __draw_val(_x + _w/2, _y - _layout.marginTop/2, _layout.marginTop, c_orange);
                    if (_layout.marginBottom != 0) __draw_val(_x + _w/2, _y + _h + _layout.marginBottom/2, _layout.marginBottom, c_orange);
                    if (_layout.marginLeft != 0)   __draw_val(_x - _layout.marginLeft/2, _y + _h/2, _layout.marginLeft, c_orange);
                    if (_layout.marginRight != 0)  __draw_val(_x + _w + _layout.marginRight/2, _y + _h/2, _layout.marginRight, c_orange);
                }
            }
            if (_padding) {
                draw_set_color(c_fuchsia); draw_set_alpha(0.4);
                var _px1 = _x + _layout.paddingLeft, _py1 = _y + _layout.paddingTop;
                var _px2 = _x + _w - _layout.paddingRight, _py2 = _y + _h - _layout.paddingBottom;
                draw_rectangle(_px1, _py1, _px2, _py2, true);
                draw_line(_x, _y, _px1, _py1); draw_line(_x + _w, _y, _px2, _py1);
                draw_line(_x, _y + _h, _px1, _py2); draw_line(_x + _w, _y + _h, _px2, _py2);
                if (_show_labels) {
                    draw_set_alpha(1.0);
                    if (_layout.paddingTop != 0)    __draw_val(_x + _w/2, _y + _layout.paddingTop/2, _layout.paddingTop, c_fuchsia);
                    if (_layout.paddingBottom != 0) __draw_val(_x + _w/2, _y + _h - _layout.paddingBottom/2, _layout.paddingBottom, c_fuchsia);
                    if (_layout.paddingLeft != 0)   __draw_val(_x + _layout.paddingLeft/2, _y + _h/2, _layout.paddingLeft, c_fuchsia);
                    if (_layout.paddingRight != 0)  __draw_val(_x + _w - _layout.paddingRight/2, _y + _h/2, _layout.paddingRight, c_fuchsia);
                }
            }
        }
		
        // 2. Main Box Fill & 2px Border
        draw_set_alpha(0.15); draw_set_color(_col_main);
        draw_rectangle(_x, _y, _x + _w, _y + _h, false);
        draw_set_alpha(0.8);
        draw_line_width(_x+1, _y+1, _x+_w-1, _y+1, 2);
        draw_line_width(_x+1, _y+_h-1, _x+_w-1, _y+_h-1, 2);
        draw_line_width(_x+1, _y+1, _x+1, _y+_h-1, 2);
        draw_line_width(_x+_w-1, _y+1, _x+_w-1, _y+_h-1, 2);
		
        // 3. Primary Node Tag & Hover Logic
        if (_show_labels) {
            var _name = get_name() ?? ("Node_" + string(__uuid));
            var _tw = string_width(_name) + 6, _th = string_height(_name);
            var _lx1 = _x + 2, _ly1 = _y + 2, _lx2 = _lx1 + _tw, _ly2 = _ly1 + _th;

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
	// Minimal forwarding surface
	// -------------------------------------------------------------------------
	#region jsDoc
	/// @func    add_to()
	/// @desc    Attaches this Reflex node to either:
	///          1) Another Reflex node (as a child), or
	///          2) The root Flex Panel Node of a UI layer (by name).
	///          If currently parented, this will detach first (from a Reflex parent or native flexpanel parent).
	/// @self    Reflex
	/// @param   {String|Struct.Reflex} _parent_or_ui_layer : UI layer name (String) or parent Reflex node.
	/// @returns {Bool}
	#endregion
	static add_to = function(_parent_or_ui_layer="ReflexLayer")
	{
		// Parent Reflex case
		if (is_instanceof(_parent_or_ui_layer, Reflex)) {
			// Detach first (handles both wrapper + UI layer parenting)
			remove_from((__parent == undefined) ? "ReflexLayer" : __parent);

			_parent_or_ui_layer.add(self);
			return true;
		}
		
		// UI layer case
		var _ui_root_node = layer_get_flexpanel_node(_parent_or_ui_layer);
		if (_ui_root_node == undefined) {
			return false;
		}

		// Detach from Reflex parent (wrapper + flexpanel)
		if (__parent != undefined) {
			__parent.remove(self);
		}
		else {
			// Detach from native flexpanel parent (UI layer or other owner)
			var _native_parent = flexpanel_node_get_parent(node_handle);
			if (_native_parent != undefined) {
				flexpanel_node_remove_child(_native_parent, node_handle);
			}
		}
		
		// Become a top-level wrapper node
		__parent = undefined;
		__root = self;
		
		// Insert into UI layer root as last child
		var _child_count = flexpanel_node_get_num_children(_ui_root_node);
		flexpanel_node_insert_child(_ui_root_node, node_handle, _child_count);
		
		return true;
	};


	#region jsDoc
	/// @func    remove_from()
	/// @desc    Detaches this Reflex node from either:
	///          1) A Reflex parent (if given a Reflex), or
	///          2) A UI layer root (if given a layer name String).
	///          If a Reflex parent is provided, this calls parent.remove(self).
	///          If a UI layer name is provided, this removes node_handle from that UI layer root.
	///          After detaching, this node becomes its own wrapper root (__parent=undefined, __root=self).
	/// @self    Reflex
	/// @param   {String|Struct.Reflex} _parent_or_ui_layer : Defaults to (__parent==undefined) ? "ReflexLayer" : __parent.
	/// @returns {Bool}
	#endregion
	static remove_from = function(_parent_or_ui_layer=(__parent == undefined) ? "ReflexLayer" : __parent)
	{
		// Reflex parent case
		if (is_instanceof(_parent_or_ui_layer, Reflex)) {
			_parent_or_ui_layer.remove(self);
			return true;
		}
		
		// UI layer case
		var _ui_root_node = layer_get_flexpanel_node(_parent_or_ui_layer);
		if (_ui_root_node == undefined) {
			return false;
		}
		
		// Attempt to remove from the specified UI layer root
		flexpanel_node_remove_child(_ui_root_node, node_handle);
		
		__parent = undefined;
		__root = self;
		
		return true;
	};
	
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
	///          Mirrors the change into the underlying flexpanel tree and requests reflow.
	/// @self    Reflex
	/// @param   {Struct.Reflex} node : Child node to insert.
	/// @param   {Real} index : Target index. If < 0, appends. Clamped to valid range.
	/// @returns {Undefined}
	#endregion
	static insert = function(_child_node, _index_value=-1)
	{
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
		
		// Flexpanel tree
		flexpanel_node_insert_child(node_handle, _child_node.node_handle, _insert_index);
	};
	
	#region jsDoc
	/// @func    remove()
	/// @desc    Removes a child node from this node.
	///          Clears wrapper links (child __parent becomes undefined),
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
		
		var _index = array_get_index(__children, _child_node);
		array_delete(__children, _index, 1);
		
		// Wrapper links
		_child_node.__parent = undefined;
		
		// Flexpanel tree
		flexpanel_node_remove_child(node_handle, _childnode_handle);
	};
	
	#region jsDoc
	/// @func    clear()
	/// @desc    Removes all children from this node.
	///          Detaches each child (clears __parent),
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
		}
		
		array_resize(__children, 0);

		flexpanel_node_remove_all_children(node_handle);
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
	
	#region jsDoc
	/// @func    get_parent()
	/// @desc    Returns the parent wrapper node, or undefined if this node is a root.
	/// @self    Reflex
	/// @returns {Struct.Reflex|Undefined}
	#endregion
	static get_parent = function()
	{
		return __parent;
	};

	#region jsDoc
	/// @func    get_child_count()
	/// @desc    Returns the number of direct children.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_child_count = function()
	{
		return array_length(__children);
	};

	#region jsDoc
	/// @func    get_child_at()
	/// @desc    Returns the child at the given index, or undefined if out of range.
	/// @self    Reflex
	/// @param   {Real} index : Zero-based child index.
	/// @returns {Struct.Reflex|Undefined}
	#endregion
	static get_child_at = function(_index)
	{
		var _index_value = floor(_index);
		if (_index_value < 0) { return undefined; }
		if (_index_value >= array_length(__children)) { return undefined; }
		return __children[_index_value];
	};

	#region jsDoc
	/// @func    get_children_array()
	/// @desc    Returns the internal children array. This is a live reference; modifying it directly
	///          will desync the wrapper tree from the flexpanel tree. Prefer add/insert/remove/clear.
	/// @self    Reflex
	/// @returns {Array}
	#endregion
	static get_children_array = function()
	{
		return __children;
	};

	#region jsDoc
	/// @func    contains()
	/// @desc    Returns whether the given node exists in this node's subtree.
	///          If recursive is false, checks only direct children.
	///          If recursive is true, checks the entire subtree using a reusable static stack.
	/// @self    Reflex
	/// @param   {Struct.Reflex} node : Node to search for.
	/// @param   {Bool} recursive : If true, searches the entire subtree; if false, only direct children.
	/// @returns {Bool}
	#endregion
	static contains = function(_target_node, _recursive=true)
	{
		if (_target_node == undefined) { return false; }

		if (array_contains(__children, _target_node)) { return true; }
		
		if (!_recursive) { return false; }
		
		static __stack_node = [];
		var _stack_node = __stack_node;
		
		array_push(_stack_node, self);
		
		while (array_length(_stack_node) > 0) {
			var _node = array_pop(_stack_node);
			
			if (array_contains(_node.__children, _target_node)) {
				array_resize(_stack_node, 0);
				return true;
			}
			else {
				var _child_count = array_length(_node.__children);
				if (_child_count > 0) {
					array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
				}
			}
		}
		
		return false;
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
	static set_measure_function = function(_measure_function) { flexpanel_node_set_measure_function(node_handle, _measure_function); return self; };
	#region jsDoc
	/// @func    set_align_content()
	/// @desc    Sets the alignment of the content of the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_justify} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_content = function(_align_value) { flexpanel_node_style_set_align_content(node_handle, _align_value); return self; };
	#region jsDoc
	/// @func    set_align_items()
	/// @desc    Sets the alignment of the items of the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_align} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_items = function(_align_value) { flexpanel_node_style_set_align_items(node_handle, _align_value); return self; };
	#region jsDoc
	/// @func    set_align_self()
	/// @desc    Sets the alignment of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_align} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_self = function(_align_value) { flexpanel_node_style_set_align_self(node_handle, _align_value); return self; };
	#region jsDoc
	/// @func    set_aspect_ratio()
	/// @desc    Sets the node's aspect ratio
	/// @self    Reflex
	/// @param   {Real} aspect_ratio : The value
	/// @returns {Struct.Reflex}
	#endregion
	static set_aspect_ratio = function(_aspect_ratio) { flexpanel_node_style_set_aspect_ratio(node_handle, _aspect_ratio); return self; };
	#region jsDoc
	/// @func    set_display()
	/// @desc    Sets the display setting of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_display} display_value : The selected display.
	/// @returns {Struct.Reflex}
	#endregion
	static set_display = function(_display_value) { flexpanel_node_style_set_display(node_handle, _display_value); return self; };
	#region jsDoc
	/// @func    set_flex()
	/// @desc    Sets the flex value of the selected node.
	/// @self    Reflex
	/// @param   {Real} flex_value : The flex value for this
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex = function(_flex_value) { flexpanel_node_style_set_flex(node_handle, _flex_value); return self; };
	#region jsDoc
	/// @func    set_flex_wrap()
	/// @desc    Sets the flex wrap of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_wrap} wrap_value : The selected wrap.
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_wrap = function(_wrap_value) { flexpanel_node_style_set_flex_wrap(node_handle, _wrap_value); return self; };
	#region jsDoc
	/// @func    set_flex_grow()
	/// @desc    Sets the flex grow of the selected node.
	/// @self    Reflex
	/// @param   {Real} grow_value : The selected grow factor
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_grow = function(_grow_value) { flexpanel_node_style_set_flex_grow(node_handle, _grow_value); return self; };
	#region jsDoc
	/// @func    set_flex_shrink()
	/// @desc    Sets the flex shrink of the selected node.
	/// @self    Reflex
	/// @param   {Real} shrink_value : The selected shrink factor
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_shrink = function(_shrink_value) { flexpanel_node_style_set_flex_shrink(node_handle, _shrink_value); return self; };
	#region jsDoc
	/// @func    set_flex_basis()
	/// @desc    Sets the flex basis of the selected node.
	/// @self    Reflex
	/// @param   {Real} value : The selected flex basis value
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_basis = function(_value, _unit_value) { flexpanel_node_style_set_flex_basis(node_handle, _value, _unit_value); return self; };
	#region jsDoc
	/// @func    set_flex_direction()
	/// @desc    Sets the flex direction of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_flex_direction} flex_direction_value : The selected direction.
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_direction = function(_flex_direction_value) { flexpanel_node_style_set_flex_direction(node_handle, _flex_direction_value); return self; };
	#region jsDoc
	/// @func    set_gap()
	/// @desc    Sets the gap of the selected node for the selected gutters.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_gutter} gutter_value : The selected gutter (column/row/all).
	/// @param   {Real} size_value : The selected gap size
	/// @returns {Struct.Reflex}
	#endregion
	static set_gap = function(_gutter_value, _size_value) { flexpanel_node_style_set_gap(node_handle, _gutter_value, _size_value); return self; };
	#region jsDoc
	/// @func    set_position()
	/// @desc    Sets an inset position on the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} value : The value
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_position = function(_edge_value, _value, _unit_value) { flexpanel_node_style_set_position(node_handle, _edge_value, _value, _unit_value); return self; };
	#region jsDoc
	/// @func    set_justify_content()
	/// @desc    Sets the node's contents justification
	/// @self    Reflex
	/// @param   {Enum.flexpanel_justify} justify_value : The justification to use
	/// @returns {Struct.Reflex}
	#endregion
	static set_justify_content = function(_justify_value) { flexpanel_node_style_set_justify_content(node_handle, _justify_value); return self; };
	#region jsDoc
	/// @func    set_direction()
	/// @desc    Sets the layout direction of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_direction} direction_value : The selected direction.
	/// @returns {Struct.Reflex}
	#endregion
	static set_direction = function(_direction_value) { flexpanel_node_style_set_direction(node_handle, _direction_value); return self; };
	#region jsDoc
	/// @func    set_margin()
	/// @desc    Sets the margin of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected padding size
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_margin = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { flexpanel_node_style_set_margin(node_handle, _edge_value, _size_value, _unit_value); return self; };
	#region jsDoc
	/// @func    set_padding()
	/// @desc    Sets the padding of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected padding size
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_padding = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { flexpanel_node_style_set_padding(node_handle, _edge_value, _size_value, _unit_value); return self; };
	#region jsDoc
	/// @func    set_border()
	/// @desc    Sets the border of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected border size
	/// @returns {Struct.Reflex}
	#endregion
	static set_border = function(_edge_value, _size_value) { flexpanel_node_style_set_border(node_handle, _edge_value, _size_value); return self; };
	#region jsDoc
	/// @func    set_position_type()
	/// @desc    Sets the node's position type.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_position_type} position_type_value : The position type to use
	/// @returns {Struct.Reflex}
	#endregion
	static set_position_type = function(_position_type_value) { flexpanel_node_style_set_position_type(node_handle, _position_type_value); return self; };
	#region jsDoc
	/// @func    set_min_width()
	/// @desc    Sets the node's minimum width
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_min_width = function(_value, _unit_value) { flexpanel_node_style_set_min_width(node_handle, _value, _unit_value); return self; };
	#region jsDoc
	/// @func    set_max_width()
	/// @desc    Sets the node's maximum width
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_max_width = function(_value, _unit_value) { flexpanel_node_style_set_max_width(node_handle, _value, _unit_value); return self; };
	#region jsDoc
	/// @func    set_min_height()
	/// @desc    Sets the node's minimum height
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_min_height = function(_value, _unit_value) { flexpanel_node_style_set_min_height(node_handle, _value, _unit_value); return self; };
	#region jsDoc
	/// @func    set_max_height()
	/// @desc    Sets the node's maximum height
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_max_height = function(_value, _unit_value) { flexpanel_node_style_set_max_height(node_handle, _value, _unit_value); return self; };
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
	static get_layout_position = function()	{ return flexpanel_node_layout_get_position(node_handle, false); };
	#region jsDoc
	/// @func    get_layout_struct()
	/// @desc    Alias of get_layout_position(). Returns the cached flexpanel layout struct (or undefined).
	/// @self    Reflex
	/// @returns {Struct|Undefined}
	#endregion
	static get_layout_struct = function() { return flexpanel_node_get_struct(node_handle); };
	#region jsDoc
	/// @func    get_layout_left()
	/// @desc    Returns the cached layout left offset (relative to the reflow origin). Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_left = function() { return flexpanel_node_layout_get_position(node_handle, false).left; };
	#region jsDoc
	/// @func    get_layout_top()
	/// @desc    Returns the cached layout top offset (relative to the reflow origin). Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_top = function() { return flexpanel_node_layout_get_position(node_handle, false).top; };
	#region jsDoc
	/// @func    get_layout_right()
	/// @desc    Returns the cached layout right value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_right = function() { return flexpanel_node_layout_get_position(node_handle, false).right; };
	#region jsDoc
	/// @func    get_layout_bottom()
	/// @desc    Returns the cached layout bottom value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_bottom = function() { return flexpanel_node_layout_get_position(node_handle, false).bottom; };
	#region jsDoc
	/// @func    get_layout_padding_left()
	/// @desc    Returns the cached layout paddingLeft value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_padding_left = function() { return flexpanel_node_layout_get_position(node_handle, false).paddingLeft; };
	#region jsDoc
	/// @func    get_layout_padding_right()
	/// @desc    Returns the cached layout paddingRight value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_padding_right = function() { return flexpanel_node_layout_get_position(node_handle, false).paddingRight; };
	#region jsDoc
	/// @func    get_layout_padding_top()
	/// @desc    Returns the cached layout paddingTop value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_padding_top = function() { return flexpanel_node_layout_get_position(node_handle, false).paddingTop; };
	#region jsDoc
	/// @func    get_layout_padding_bottom()
	/// @desc    Returns the cached layout paddingBottom value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_padding_bottom = function() { return flexpanel_node_layout_get_position(node_handle, false).paddingBottom; };
	#region jsDoc
	/// @func    get_layout_margin_left()
	/// @desc    Returns the cached layout marginLeft value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_margin_left = function() { return flexpanel_node_layout_get_position(node_handle, false).marginLeft; };
	#region jsDoc
	/// @func    get_layout_margin_right()
	/// @desc    Returns the cached layout marginRight value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_margin_right = function() { return flexpanel_node_layout_get_position(node_handle, false).marginRight; };
	#region jsDoc
	/// @func    get_layout_margin_top()
	/// @desc    Returns the cached layout marginTop value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_margin_top = function() { return flexpanel_node_layout_get_position(node_handle, false).marginTop; };
	#region jsDoc
	/// @func    get_layout_margin_bottom()
	/// @desc    Returns the cached layout marginBottom value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_margin_bottom = function() { return flexpanel_node_layout_get_position(node_handle, false).marginBottom; };
	#region jsDoc
	/// @func    get_layout_direction()
	/// @desc    Returns the cached layout direction value. Returns 0 if no layout is cached.
	/// @self    Reflex
	/// @returns {Real}
	#endregion
	static get_layout_direction = function() { return flexpanel_node_layout_get_position(node_handle, false).direction; };
	#region jsDoc
	/// @func    get_layout_had_overflow()
	/// @desc    Returns whether the cached layout reported overflow. Returns false if no layout is cached.
	/// @self    Reflex
	/// @returns {Bool}
	#endregion
	static get_layout_had_overflow = function() { return flexpanel_node_layout_get_position(node_handle, false).hadOverflow; };
	#endregion
	
	#region jsDoc
	/// @func    get_data()
	/// @desc    Returns the data struct of the flexpanel node.
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_data = function()	{
		return flexpanel_node_get_data(node_handle);
	};
	#region jsDoc
	/// @func    get_struct()
	/// @desc    Returns the layout data of the given node as a struct. This is the same data that can be passed into `new Reflex(_data)`.
	/// @self    Reflex
	/// @returns {Struct}
	#endregion
	static get_struct = function()	{
		return flexpanel_node_get_struct(node_handle);
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
	/// @func    get_parent_node()
	/// @desc    Returns the flexpanel parent of the given node, undefined if no parent.
	/// @self    Reflex
	/// @returns {Pointer.FlexpanelNode}
	#endregion
	static get_parent_node = function()	{ return flexpanel_node_get_parent(node_handle); };
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
	
	__parent = undefined;
	__children = [];
	
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


