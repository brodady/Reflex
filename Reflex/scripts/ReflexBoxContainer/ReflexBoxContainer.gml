#region jsDoc
/// @desc
///		ReflexBoxContainer arranges children in a single row or column.
///		This mirrors Godot's BoxContainer / HBoxContainer / VBoxContainer concepts.
///
///		Godot-inspired use cases:
///		- Toolbars (HBox): left -> right stacking
///		- Side panels (VBox): top -> bottom stacking
///		- Alignment modes for content packing: begin / center / end
///		- add_spacer() to push groups apart (common in Godot UI)
///
///		Implementation notes:
///		- flexDirection is set to row or column.
///		- alignment is mapped to justifyContent.
///		- separation is mapped to gap on the main axis (row gap for VBox, column gap for HBox).
///
#endregion
function ReflexBoxContainer(_data=undefined) : ReflexContainer(_data) constructor
{
	// -------------------------------------------------------------------------
	// Public API
	// -------------------------------------------------------------------------

	#region jsDoc
	/// @func    set_vertical()
	/// @desc    Sets whether this container arranges children vertically (true) or horizontally (false).
	/// @self    ReflexBoxContainer
	/// @param   {Bool} _value : If true, use column layout; if false, use row layout.
	/// @returns {Struct.ReflexBoxContainer}
	#endregion
	static set_vertical = function(_value)
	{
		__vertical = _value;
		__apply_box_layout();
		return self;
	};

	#region jsDoc
	/// @func    is_vertical()
	/// @desc    Returns true if this container is vertical (column layout).
	/// @self    ReflexBoxContainer
	/// @returns {Bool}
	#endregion
	static is_vertical = function()
	{
		return (__vertical == true);
	};
	
	#region jsDoc
	/// @func    set_alignment()
	/// @desc    Sets how children are packed along the main axis when there is extra space.
	///          0 = begin, 1 = center, 2 = end.
	/// @self    ReflexBoxContainer
	/// @param   {Real} _mode : Alignment mode (0 begin, 1 center, 2 end).
	/// @returns {Struct.ReflexBoxContainer}
	#endregion
	static set_alignment = function(_mode)
	{
		__alignment_mode = clamp(floor(_mode), 0, 2);
		__apply_box_layout();
		return self;
	};

	#region jsDoc
	/// @func    get_alignment()
	/// @desc    Returns the current alignment mode (0 begin, 1 center, 2 end).
	/// @self    ReflexBoxContainer
	/// @returns {Real}
	#endregion
	static get_alignment = function()
	{
		return __alignment_mode;
	};

	#region jsDoc
	/// @func    set_separation()
	/// @desc    Sets the spacing between children in pixels (main axis gap).
	/// @self    ReflexBoxContainer
	/// @param   {Real} _pixels : Gap size in pixels.
	/// @returns {Struct.ReflexBoxContainer}
	#endregion
	static set_separation = function(_pixels)
	{
		__separation = max(0, _pixels);
		__apply_box_layout();
		return self;
	};

	#region jsDoc
	/// @func    get_separation()
	/// @desc    Returns the spacing between children in pixels.
	/// @self    ReflexBoxContainer
	/// @returns {Real}
	#endregion
	static get_separation = function()
	{
		return __separation;
	};

	#region jsDoc
	/// @func    add_spacer()
	/// @desc    Adds a flexible spacer node that expands to fill remaining space.
	///          This is useful for pushing controls apart (Godot-style spacer).
	/// @self    ReflexBoxContainer
	/// @param   {Bool} _begin : If true, inserts at index 0; otherwise appends.
	/// @returns {Struct.ReflexUI}
	#endregion
	static add_spacer = function(_begin=false)
	{
		var _spacer = new ReflexUI();
		_spacer.set_name("Spacer");
		_spacer.set_flex_grow(1);
		_spacer.set_flex_shrink(1);
		_spacer.set_flex_basis(0);
		
		if (_begin == true) {
			insert(_spacer, 0);
		}
		else {
			insert(_spacer, -1);
		}
		
		return _spacer;
	};

	// -------------------------------------------------------------------------
	// Private helpers
	// -------------------------------------------------------------------------
	#region Private
	
	// -------------------------------------------------------------------------
	// State
	// -------------------------------------------------------------------------
	__vertical = false;			// false: horizontal (row), true: vertical (column)
	__alignment_mode = 0;		// 0 begin, 1 center, 2 end
	__separation = 4;

	// Defaults
	set_display(flexpanel_display.flex);
	set_align_items(flexpanel_align.stretch);
	set_flex_wrap(flexpanel_wrap.no_wrap);
	
	#region jsDoc
	/// @desc Applies flex settings based on vertical/alignment/separation state.
	/// @returns {Undefined}
	#endregion
	static __apply_box_layout = function()
	{
		switch (__vertical) {
			case true: set_flex_direction(flexpanel_flex_direction.column); break;
			case false: set_flex_direction(flexpanel_flex_direction.row); break;
		}
		
		switch (__alignment_mode) {
			case 0: set_justify_content(flexpanel_justify.start); break;
			case 1: set_justify_content(flexpanel_justify.center); break;
			case 2: set_justify_content(flexpanel_justify.flex_end); break;
		}
		
		switch (__vertical) {
			case true: set_gap(flexpanel_gutter.row, __separation); break;
			case false: set_gap(flexpanel_gutter.column, __separation); break;
		}
		
		request_reflow();
	};
	
	// Apply defaults once
	__apply_box_layout();
	
	#endregion
	
}