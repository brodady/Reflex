#region jsDoc
/// @desc
///		ReflexVBoxContainer is a BoxContainer locked to vertical (column) layout.
///
///		Godot-inspired use cases:
///		- Sidebars
///		- Menus
///		- Forms (stacked controls)
///
#endregion
function ReflexVBoxContainer(_data=undefined) : ReflexBoxContainer(_data) constructor
{
	set_vertical(true);
}