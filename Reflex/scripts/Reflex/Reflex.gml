#region jsDoc
/// @desc
///		Flex Panel node wrapper with:
///		- owned node handle
///		- x/y/w/h/width/height mirrors
///		- call-side caching to avoid redundant API calls
///		- reflow directive (dirty flag + optional bound reflow function)
///
/// @param {Real|Pointer} _node_handle
///		Existing flexpanel node handle/id to wrap. If you want the wrapper to create the node,
///		pass 0 and call set_node_handle() later after you create it externally.
///
/// @example
///		var _wrap = new WWFlexNode(_some_node);
///		_wrap.set_rect(10, 10, 200, 40);
///		_wrap.style_set_cached("padding", 6);
///		_wrap.request_reflow();
///		_wrap.flush();
#endregion
function Reflex(_node_handle) constructor
{
	// -------------------------------------------------------------------------
	// Owned node handle
	// -------------------------------------------------------------------------
	node_handle = flexpanel_create_node();

	// -------------------------------------------------------------------------
	// Required mirrors (initialize all to 0)
	// -------------------------------------------------------------------------
	x = 0;
	y = 0;
	w = 0;
	h = 0;
	width = 0;
	height = 0;
	
	#region Private
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
        if (is_real(_val)) return { value: _val, unit: flexpanel_unit.point };
        if (is_string(_val)) {
            if (_val == "auto") return { value: 0, unit: flexpanel_unit.auto };
            var _len = string_length(_val);
            if (string_char_at(_val, _len) == "%") {
                return { value: real(string_copy(_val, 1, _len - 1)), unit: flexpanel_unit.percent };
            }
        }
        return { value: 0, unit: flexpanel_unit.point };
    };
	#endregion
	
	#region jsDoc
	/// @desc
	///		Draws a debug visualization for this flex node and its subtree.
	///		Draws the node rect (x/y/width/height) and then recurses through children.
	///		Requires that a reflow has been performed so x/y/width/height are valid.
	///
	/// @param {Real} _depth
	///		Internal recursion depth. Leave as default.
	/// @param {Real} _max_depth
	///		Stops recursion after this depth. Leave default for unlimited (-1).
	#endregion
	static draw_debug = function(_depth=0, _max_depth=-1)
	{
		// Stop conditions
		if (_max_depth >= 0 && _depth > _max_depth) { return; }

		// Vary alpha by depth; keep it simple and deterministic
		var _alpha_value = 0.35;
		if (_depth > 0) {
			_alpha_value = 0.35 / (_depth + 1);
		}

		// Outline
		draw_set_alpha(_alpha_value);
		draw_set_color(c_lime);
		draw_rectangle(x, y, x + width, y + height, true);

		// Optional label
		draw_set_alpha(1);
		draw_set_color(c_white);
		//Please dont set font here otherwise its not easily exportable as a standalone script
		// draw_set_font(fnt_lbl);
		//////////////////////////
		var _name_value = get_name() ?? ""
		draw_text(x + 2, y + 2, _name_value);

		// Children
		var _count = array_length(__children);
		for (var i = 0; i < _count; i++)
		{
			__children[i].draw_debug(_depth + 1, _max_depth);
		}
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
	static attempt_reflow = function(_x=0, _y=0, _w=display_get_width(), _h=display_get_height(), _d=flexpanel_direction.LTR, _force=false)
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
		
		// Self-only refreshes, if you still want them on reflow
		__cache_data = flexpanel_node_get_data(node_handle);
		__cache_struct = flexpanel_node_get_struct(node_handle);
		
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
	
	// -------------------------------------------------------------------------
	// Static binding surface (lets you map to the real flexpanel API without us
	// guessing function names/signatures from memory)
	// -------------------------------------------------------------------------
	#region Setters
	static set_name = function(_name_value) { flexpanel_node_set_name(node_handle, _name_value); };
	static set_measure_function = function(_measure_function) { flexpanel_node_set_measure_function(node_handle, _measure_function); };
	static set_align_content = function(_align_value) { flexpanel_node_style_set_align_content(node_handle, _align_value); };
	static set_align_items = function(_align_value) { flexpanel_node_style_set_align_items(node_handle, _align_value); };
	static set_align_self = function(_align_value) { flexpanel_node_style_set_align_self(node_handle, _align_value); };
	static set_aspect_ratio = function(_aspect_ratio) { flexpanel_node_style_set_aspect_ratio(node_handle, _aspect_ratio); };
	static set_display = function(_display_value) { flexpanel_node_style_set_display(node_handle, _display_value); };
	static set_flex = function(_flex_value) { flexpanel_node_style_set_flex(node_handle, _flex_value); };
	static set_flex_wrap = function(_wrap_value) { flexpanel_node_style_set_flex_wrap(node_handle, _wrap_value); };
	static set_flex_grow = function(_grow_value) { flexpanel_node_style_set_flex_grow(node_handle, _grow_value); };
	static set_flex_shrink = function(_shrink_value) { flexpanel_node_style_set_flex_shrink(node_handle, _shrink_value); };
	static set_flex_basis = function(_value, _unit_value) { flexpanel_node_style_set_flex_basis(node_handle, _value, _unit_value); };
	static set_flex_direction = function(_flex_direction_value) { flexpanel_node_style_set_flex_direction(node_handle, _flex_direction_value); };
	static set_gap = function(_gutter_value, _size_value) { flexpanel_node_style_set_gap(node_handle, _gutter_value, _size_value); };
	static set_position = function(_edge_value, _value, _unit_value) { flexpanel_node_style_set_position(node_handle, _edge_value, _value, _unit_value); };
	static set_justify_content = function(_justify_value) { flexpanel_node_style_set_justify_content(node_handle, _justify_value); };
	static set_direction = function(_direction_value) { flexpanel_node_style_set_direction(node_handle, _direction_value); };
	static set_margin = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { flexpanel_node_style_set_margin(node_handle, _edge_value, _size_value, _unit_value); };
	static set_padding = function(_edge_value, _size_value, _unit_value=flexpanel_unit.point) { flexpanel_node_style_set_padding(node_handle, _edge_value, _size_value, _unit_value); };
	static set_border = function(_edge_value, _size_value) { flexpanel_node_style_set_border(node_handle, _edge_value, _size_value); };
	static set_position_type = function(_position_type_value) { flexpanel_node_style_set_position_type(node_handle, _position_type_value); };
	static set_min_width = function(_value, _unit_value) { flexpanel_node_style_set_min_width(node_handle, _value, _unit_value); };
	static set_max_width = function(_value, _unit_value) { flexpanel_node_style_set_max_width(node_handle, _value, _unit_value); };
	static set_min_height = function(_value, _unit_value) { flexpanel_node_style_set_min_height(node_handle, _value, _unit_value); };
	static set_max_height = function(_value, _unit_value) { flexpanel_node_style_set_max_height(node_handle, _value, _unit_value); };
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

	
	static get_data = function()	{ return __cache_data; };
	static get_struct = function()	{ return __cache_struct; };

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
	    
}

