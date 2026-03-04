#region jsDoc
/// @desc
///		ReflexFlowContainer arranges children horizontally or vertically and wraps them
///		when they reach the container boundary, similar to Godot's FlowContainer.
///
///		Core behavior:
///		- Horizontal flow: children laid out left->right, wrap to next row.
///		- Vertical flow: children laid out top->bottom, wrap to next column.
///
///		Flexpanel implementation:
///		- flexDirection controls horizontal vs vertical.
///		- flexWrap controls wrapping (wrap vs reverse).
///		- alignment maps to justifyContent.
///		- separation maps to gapColumn (horizontal) and gapRow (vertical).
///
///		Godot properties mapped:
///		- vertical: sets flexDirection (row/column)
///		- alignment: maps to justifyContent (start/center/flex_end)
///		- reverse_fill: maps to reverse
///
///		Godot property not directly representable in flex:
///		- last_wrap_alignment: stored but not applied (no per-last-line alignment control).
///
#endregion
function ReflexFlowContainer(_data=undefined) : ReflexUI(_data) constructor
{
	#region Setters
	
	#region jsDoc
	/// @func    set_vertical()
	/// @desc    Sets whether this container arranges children vertically (true) or horizontally (false).
	/// @self    ReflexFlowContainer
	/// @param   {Bool} _value : If true, use column layout; if false, use row layout.
	/// @returns {Struct.ReflexFlowContainer}
	#endregion
	static set_vertical = function(_value)
	{
		__vertical = _value;
		__apply_flow_layout();
		return self;
	};

	#region jsDoc
	/// @func    set_alignment()
	/// @desc    Sets how children are packed along the main axis when there is extra space.
	///          0 = begin, 1 = center, 2 = end.
	/// @self    ReflexFlowContainer
	/// @param   {Real} _mode : Alignment mode (0 begin, 1 center, 2 end).
	/// @returns {Struct.ReflexFlowContainer}
	#endregion
	static set_alignment = function(_mode)
	{
		__alignment_mode = clamp(floor(_mode), 0, 2);
		__apply_flow_layout();
		return self;
	};

	#region jsDoc
	/// @func    set_last_wrap_alignment()
	/// @desc    Sets how the last partially-filled line should align.
	///          Stored for parity with Godot, but not applied due to missing flex equivalent.
	///          0 = inherit, 1 = begin, 2 = center, 3 = end.
	/// @self    ReflexFlowContainer
	/// @param   {Real} _mode : Last wrap alignment mode.
	/// @returns {Struct.ReflexFlowContainer}
	#endregion
	static set_last_wrap_alignment = function(_mode)
	{
		__last_wrap_alignment = clamp(floor(_mode), 0, 3);
		return self;
	};

	#region jsDoc
	/// @func    set_reverse_fill()
	/// @desc    If true, reverses fill direction for wrapped lines:
	///          - Horizontal flow: rows fill bottom->top (reverse).
	///          - Vertical flow: columns fill right->left (reverse).
	/// @self    ReflexFlowContainer
	/// @param   {Bool} _value : Reverse fill toggle.
	/// @returns {Struct.ReflexFlowContainer}
	#endregion
	static set_reverse_fill = function(_value)
	{
		__reverse_fill = _value;
		__apply_flow_layout();
		return self;
	};

	#region jsDoc
	/// @func    set_h_separation()
	/// @desc    Sets horizontal separation (gapColumn) in pixels.
	/// @self    ReflexFlowContainer
	/// @param   {Real} _pixels : Horizontal gap in pixels.
	/// @returns {Struct.ReflexFlowContainer}
	#endregion
	static set_h_separation = function(_pixels)
	{
		__h_separation = max(0, _pixels);
		__apply_flow_layout();
		return self;
	};

	#region jsDoc
	/// @func    set_v_separation()
	/// @desc    Sets vertical separation (gapRow) in pixels.
	/// @self    ReflexFlowContainer
	/// @param   {Real} _pixels : Vertical gap in pixels.
	/// @returns {Struct.ReflexFlowContainer}
	#endregion
	static set_v_separation = function(_pixels)
	{
		__v_separation = max(0, _pixels);
		__apply_flow_layout();
		return self;
	};

	#region jsDoc
	/// @func    set_separation()
	/// @desc    Convenience: sets both horizontal and vertical separation.
	/// @self    ReflexFlowContainer
	/// @param   {Real} _pixels : Gap in pixels.
	/// @returns {Struct.ReflexFlowContainer}
	#endregion
	static set_separation = function(_pixels)
	{
		__h_separation = max(0, _pixels);
		__v_separation = __h_separation;
		__apply_flow_layout();
		return self;
	};
	
	#endregion
	
	#region Getters
	
	#region jsDoc
	/// @func    is_vertical()
	/// @desc    Returns true if this container is vertical (column layout).
	/// @self    ReflexFlowContainer
	/// @returns {Bool}
	#endregion
	static is_vertical = function()
	{
		return __vertical;
	};

	#region jsDoc
	/// @func    get_alignment()
	/// @desc    Returns the current alignment mode (0 begin, 1 center, 2 end).
	/// @self    ReflexFlowContainer
	/// @returns {Real}
	#endregion
	static get_alignment = function()
	{
		return __alignment_mode;
	};

	#region jsDoc
	/// @func    get_last_wrap_alignment()
	/// @desc    Returns the stored last wrap alignment mode.
	/// @self    ReflexFlowContainer
	/// @returns {Real}
	#endregion
	static get_last_wrap_alignment = function()
	{
		return __last_wrap_alignment;
	};

	#region jsDoc
	/// @func    is_reverse_fill()
	/// @desc    Returns whether reverse fill is enabled.
	/// @self    ReflexFlowContainer
	/// @returns {Bool}
	#endregion
	static is_reverse_fill = function()
	{
		return __reverse_fill;
	};

	#region jsDoc
	/// @func    get_h_separation()
	/// @desc    Returns horizontal separation (gapColumn).
	/// @self    ReflexFlowContainer
	/// @returns {Real}
	#endregion
	static get_h_separation = function()
	{
		return __h_separation;
	};

	#region jsDoc
	/// @func    get_v_separation()
	/// @desc    Returns vertical separation (gapRow).
	/// @self    ReflexFlowContainer
	/// @returns {Real}
	#endregion
	static get_v_separation = function()
	{
		return __v_separation;
	};

	#region jsDoc
	/// @func    get_line_count()
	/// @desc    Returns an estimated line count based on current child layout positions.
	///          Horizontal flow counts distinct row tops; vertical flow counts distinct column lefts.
	///          Returns 0 if no children or if layout is not available yet.
	/// @self    ReflexFlowContainer
	/// @returns {Real}
	#endregion
	static get_line_count = function()
	{
		var _children = get_children_array();
		var _count = array_length(_children);
		if (_count <= 0) { return 0; }

		static __lines = [];
		var _lines = __lines;
		array_resize(_lines, 0);

		var _epsilon = 0.5;

		for (var i = 0; i < _count; i += 1)
		{
			var _child = _children[i];

			var _pos = (__vertical) ? _child.get_layout_left() : _child.get_layout_top();

			var _found = false;
			var _ln_count = array_length(_lines);
			for (var j = 0; j < _ln_count; j += 1)
			{
				if (abs(_lines[j] - _pos) <= _epsilon)
				{
					_found = true;
					break;
				}
			}

			if (!_found)
			{
				array_push(_lines, _pos);
			}
		}

		return array_length(_lines);
	};
	
	#endregion
	
	// -------------------------------------------------------------------------
	// Private
	// -------------------------------------------------------------------------
	#region Private

	__vertical = false;
	__alignment_mode = 0;			// 0 begin, 1 center, 2 end
	__last_wrap_alignment = 0;		// 0 inherit, 1 begin, 2 center, 3 end (stored only)
	__reverse_fill = false;

	__h_separation = 4;
	__v_separation = 4;

	// Defaults
	set_display(flexpanel_display.flex);
	set_align_items(flexpanel_align.stretch);

	#region jsDoc
	/// @desc Applies flex settings based on vertical/alignment/separation/reverse state.
	/// @returns {Undefined}
	#endregion
	static __apply_flow_layout = function()
	{
		switch (__vertical)
		{
			case true: set_flex_direction(flexpanel_flex_direction.column); break;
			case false: set_flex_direction(flexpanel_flex_direction.row); break;
		}

		switch (__alignment_mode)
		{
			case 0: set_justify_content(flexpanel_justify.start); break;
			case 1: set_justify_content(flexpanel_justify.center); break;
			case 2: set_justify_content(flexpanel_justify.flex_end); break;
		}

		if (__reverse_fill)
		{
			set_flex_wrap(flexpanel_wrap.reverse);
		}
		else
		{
			set_flex_wrap(flexpanel_wrap.wrap);
		}

		set_gap(flexpanel_gutter.column, __h_separation);
		set_gap(flexpanel_gutter.row, __v_separation);
	};

	__apply_flow_layout();

	#endregion
}