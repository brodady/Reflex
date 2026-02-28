function ReflexUI(_data=undefined) : Reflex(_data) constructor
{
	// Required mirrors (initialize all to 0)
	x = 0; // setting these does nothing
	y = 0; // setting these does nothing
	w = 0; // setting these does nothing // same thing as width, just easier to type.
	h = 0; // setting these does nothing // same thing as height, just easier to type.
	width = 0;  // setting these does nothing
	height = 0; // setting these does nothing
	
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
		static __base_add_to = Reflex.add_to;
		var _value = __base_add_to(_parent_or_ui_layer);
		request_reflow();
		return _value;
	}
	
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
		static __base_remove_from = Reflex.remove_from;
		var _value = __base_remove_from(_parent_or_ui_layer);
		
		// Recursive update root and parent
		static __stack_node = [];
		var _stack_node = __stack_node;
		array_push(_stack_node, self);
		
		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);
			_node.__root = self;
			
			var _child_count = array_length(_node.__children);
			if (_child_count > 0) {
				array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
			}
		}
		
		request_reflow();
		
		return _value;
	}
	
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
		static __base_insert = Reflex.insert;
		__base_insert(_child_node, _index_value);
		
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
		
		request_reflow();
	}
	
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
		static __base_remove = Reflex.remove;
		__base_remove(_child_node);
		
		// Recursive update root and parent
		static __stack_node = [];
		var _stack_node = __stack_node;
		array_push(_stack_node, _child_node);
		
		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);
			_node.__root = _child_node;
			
			var _child_count = array_length(_node.__children);
			if (_child_count > 0) {
				array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
			}
		}
		
		request_reflow();
	}
	
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
		// Recursive update root and parent
		static __stack_node = [];
		var _stack_node = __stack_node;
		
		var _count = array_length(__children);
		for (var i = 0; i < _count; i++)
		{
			var _child_node = __children[i];
			_child_node.__parent = undefined;
			_child_node.__root = _child_node;
			
			array_copy(_stack_node, 0, _child_node.__children, 0, array_length(_child_node.__children));
			while (array_length(_stack_node) > 0)
			{
				var _node = array_pop(_stack_node);
				_node.__root = _child_node;
			
				var _child_count = array_length(_node.__children);
				if (_child_count > 0) {
					array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
				}
			}
		
		}
		
		
		static __base_clear = Reflex.clear;
		__base_clear();
		
		request_reflow();
	}
	
	#region jsDoc
	/// @func    get_root()
	/// @desc    Returns the root wrapper node for this tree. For a detached node, this is itself.
	/// @self    Reflex
	/// @returns {Struct.Reflex}
	#endregion
	static get_root = function()
	{
		return __root;
	};
	
	// -------------------------------------------------------------------------
	// Flexpanel API
	// -------------------------------------------------------------------------
	#region Setters
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
	static set_measure_function = function(_measure_function) { static __base_set_measure_function = Reflex.set_measure_function; __base_set_measure_function(_measure_function); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_align_content()
	/// @desc    Sets the alignment of the content of the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_justify} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_content = function(_align_value) { static __base_set_align_content = Reflex.set_align_content; __base_set_align_content(_align_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_align_items()
	/// @desc    Sets the alignment of the items of the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_align} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_items = function(_align_value) { static __base_set_align_items = Reflex.set_align_items; __base_set_align_items(_align_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_align_self()
	/// @desc    Sets the alignment of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_align} align_value : The selected alignment.
	/// @returns {Struct.Reflex}
	#endregion
	static set_align_self = function(_align_value) { static __base_set_align_self = Reflex.set_align_self; __base_set_align_self(_align_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_aspect_ratio()
	/// @desc    Sets the node's aspect ratio
	/// @self    Reflex
	/// @param   {Real} aspect_ratio : The value
	/// @returns {Struct.Reflex}
	#endregion
	static set_aspect_ratio = function(_aspect_ratio) { static __base_set_aspect_ratio = Reflex.set_aspect_ratio; __base_set_aspect_ratio(_aspect_ratio); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_display()
	/// @desc    Sets the display setting of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_display} display_value : The selected display.
	/// @returns {Struct.Reflex}
	#endregion
	static set_display = function(_display_value) { static __base_set_display = Reflex.set_display; __base_set_display(_display_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex()
	/// @desc    Sets the flex value of the selected node.
	/// @self    Reflex
	/// @param   {Real} flex_value : The flex value for this
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex = function(_flex_value) { static __base_set_flex = Reflex.set_flex; __base_set_flex(_flex_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_wrap()
	/// @desc    Sets the flex wrap of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_wrap} wrap_value : The selected wrap.
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_wrap = function(_wrap_value) { static __base_set_flex_wrap = Reflex.set_flex_wrap; __base_set_flex_wrap(_wrap_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_grow()
	/// @desc    Sets the flex grow of the selected node.
	/// @self    Reflex
	/// @param   {Real} grow_value : The selected grow factor
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_grow = function(_grow_value) { static __base_set_flex_grow = Reflex.set_flex_grow; __base_set_flex_grow(_grow_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_shrink()
	/// @desc    Sets the flex shrink of the selected node.
	/// @self    Reflex
	/// @param   {Real} shrink_value : The selected shrink factor
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_shrink = function(_shrink_value) { static __base_set_flex_shrink = Reflex.set_flex_shrink; __base_set_flex_shrink(_shrink_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_basis()
	/// @desc    Sets the flex basis of the selected node.
	/// @self    Reflex
	/// @param   {Real} value : The selected flex basis value
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_basis = function(_value, _unit_value) { static __base_set_flex_basis = Reflex.set_flex_basis; __base_set_flex_basis(_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_flex_direction()
	/// @desc    Sets the flex direction of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_flex_direction} flex_direction_value : The selected direction.
	/// @returns {Struct.Reflex}
	#endregion
	static set_flex_direction = function(_flex_direction_value) { static __base_set_flex_direction = Reflex.set_flex_direction; __base_set_flex_direction(_flex_direction_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_gap()
	/// @desc    Sets the gap of the selected node for the selected gutters.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_gutter} gutter_value : The selected gutter (column/row/all).
	/// @param   {Real} size_value : The selected gap size
	/// @returns {Struct.Reflex}
	#endregion
	static set_gap = function(_gutter_value, _size_value) { static __base_set_gap = Reflex.set_gap; __base_set_gap(_gutter_value, _size_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_position()
	/// @desc    Sets an inset position on the node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} value : The value
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_position = function(_edge_value, _value, _unit_value) { static __base_set_position = Reflex.set_position; __base_set_position(_edge_value, _value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_justify_content()
	/// @desc    Sets the node's contents justification
	/// @self    Reflex
	/// @param   {Enum.flexpanel_justify} justify_value : The justification to use
	/// @returns {Struct.Reflex}
	#endregion
	static set_justify_content = function(_justify_value) { static __base_set_justify_content = Reflex.set_justify_content; __base_set_justify_content(_justify_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_direction()
	/// @desc    Sets the layout direction of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_direction} direction_value : The selected direction.
	/// @returns {Struct.Reflex}
	#endregion
	static set_direction = function(_direction_value) { static __base_set_direction = Reflex.set_direction; __base_set_direction(_direction_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_margin()
	/// @desc    Sets the margin of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected padding size
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_margin = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { static __base_set_margin = Reflex.set_margin; __base_set_margin(_edge_value, _size_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_padding()
	/// @desc    Sets the padding of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected padding size
	/// @param   {Enum.flexpanel_unit} unit_value : The units to be used
	/// @returns {Struct.Reflex}
	#endregion
	static set_padding = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { static __base_set_padding = Reflex.set_padding; __base_set_padding(_edge_value, _size_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_border()
	/// @desc    Sets the border of the selected node.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_edge} edge_value : The selected edge.
	/// @param   {Real} size_value : The selected border size
	/// @returns {Struct.Reflex}
	#endregion
	static set_border = function(_edge_value, _size_value) { static __base_set_border = Reflex.set_border; __base_set_border(_edge_value, _size_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_position_type()
	/// @desc    Sets the node's position type.
	/// @self    Reflex
	/// @param   {Enum.flexpanel_position_type} position_type_value : The position type to use
	/// @returns {Struct.Reflex}
	#endregion
	static set_position_type = function(_position_type_value) { static __base_set_position_type = Reflex.set_position_type; __base_set_position_type(_position_type_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_min_width()
	/// @desc    Sets the node's minimum width
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_min_width = function(_value, _unit_value) { static __base_set_min_width = Reflex.set_min_width; __base_set_min_width(_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_max_width()
	/// @desc    Sets the node's maximum width
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_max_width = function(_value, _unit_value) { static __base_set_max_width = Reflex.set_max_width; __base_set_max_width(_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_min_height()
	/// @desc    Sets the node's minimum height
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_min_height = function(_value, _unit_value) { static __base_set_min_height = Reflex.set_min_height; __base_set_min_height(_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_max_height()
	/// @desc    Sets the node's maximum height
	/// @self    Reflex
	/// @param   {Real} value : The value to use
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_max_height = function(_value, _unit_value) { static __base_set_max_height = Reflex.set_max_height; __base_set_max_height(_value, _unit_value); request_reflow(); return self; };
	#region jsDoc
	/// @func    set_width()
	/// @desc    Sets the width of the selected node.
	/// @self    Reflex
	/// @param   {Real} val : The selected width.
	/// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
	/// @returns {Struct.Reflex}
	#endregion
	static set_width = function(_val, _unit_value) { static __base_set_width = Reflex.set_width; __base_set_width(_val, _unit_value); request_reflow(); return self; };
    #region jsDoc
    /// @func    set_height()
    /// @desc    Sets the height of the selected node.
    /// @self    Reflex
    /// @param   {Real} val : The selected height.
    /// @param   {Enum.flexpanel_unit} unit_value : The units to use for the value
    /// @returns {Struct.Reflex}
    #endregion
    static set_height = function(_val, _unit_value) { static __base_set_height = Reflex.set_height; __base_set_height(_val, _unit_value); request_reflow(); return self; };
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
	
	#endregion
	
	// -------------------------------------------------------------------------
	// PRIVITE
	// -------------------------------------------------------------------------
	#region Private
	
	__root = self;
	
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
	
	#endregion
}




