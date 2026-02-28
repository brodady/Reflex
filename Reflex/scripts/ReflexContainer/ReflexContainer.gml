#region jsDoc
/// @desc
///		ReflexContainer is the base class for structural UI containers in ReflexUI.
///
///		This mirrors the spirit of Godot's Container:
///		- A Container is responsible for arranging its child controls.
///		- In ReflexUI, arrangement is primarily done by flexpanel properties, so most
///		  container types are thin presets over flex settings.
///
///		Key behaviors:
///		- queue_sort() maps to request_reflow().
///		- fit_child_in_rect() is provided as a helper for custom containers and
///		  absolute child placement cases.
///
/// @example
///		// Typical: subclass containers set flex properties, then you add children.
///		var _root = new ReflexContainer();
///		_root.add_to("ReflexLayer");
///
#endregion
function ReflexContainer(_data=undefined) : ReflexUI(_data) constructor
{
	// -------------------------------------------------------------------------
	// Public API
	// -------------------------------------------------------------------------

	#region jsDoc
	/// @func    fit_child_in_rect()
	/// @desc    Fits a child into a rectangle relative to this container.
	///          This is mainly a helper for custom container behaviors.
	///          The child is set to absolute positioning inside this container and given the
	///          rect's left/top/width/height in point units.
	///
	///          The rect may be a struct with:
	///          - x, y, w, h
	///          or
	///          - left, top, width, height
	///
	/// @self    ReflexContainer
	/// @param   {Struct.ReflexUI} _child : Child node to position.
	/// @param   {Struct} _rect : Rectangle struct (x/y/w/h or left/top/width/height).
	/// @returns {Undefined}
	#endregion
	static fit_child_in_rect = function(_child, _rect)
	{
		var _x = 0;
		var _y = 0;
		var _w = 0;
		var _h = 0;

		if (variable_struct_exists(_rect, "x")) { _x = _rect.x; }
		if (variable_struct_exists(_rect, "y")) { _y = _rect.y; }
		if (variable_struct_exists(_rect, "w")) { _w = _rect.w; }
		if (variable_struct_exists(_rect, "h")) { _h = _rect.h; }

		if (variable_struct_exists(_rect, "left")) { _x = _rect.left; }
		if (variable_struct_exists(_rect, "top")) { _y = _rect.top; }
		if (variable_struct_exists(_rect, "width")) { _w = _rect.width; }
		if (variable_struct_exists(_rect, "height")) { _h = _rect.height; }

		_child.set_position_type(flexpanel_position_type.absolute);
		_child.set_position(flexpanel_edge.left, _x, flexpanel_unit.point);
		_child.set_position(flexpanel_edge.top, _y, flexpanel_unit.point);
		_child.set_width(_w, flexpanel_unit.point);
		_child.set_height(_h, flexpanel_unit.point);

		request_reflow();
	};
}