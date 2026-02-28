#region jsDoc
/// @desc
///		ReflexHBoxContainer is a BoxContainer locked to horizontal (row) layout.
///
///		Godot-inspired use cases:
///		- Toolbars
///		- Button rows
///		- Label + input rows
///
#endregion
function ReflexHBoxContainer(_data=undefined) : ReflexBoxContainer(_data) constructor
{
	set_vertical(false);
}