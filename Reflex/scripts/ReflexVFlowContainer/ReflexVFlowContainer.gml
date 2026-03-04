#region jsDoc
/// @desc
///		ReflexVFlowContainer is a FlowContainer locked to vertical (column) flow layout.
///
///		Godot-inspired behavior:
///		- Arranges children top->bottom and wraps to new columns.
///
#endregion
function ReflexVFlowContainer(_data=undefined) : ReflexFlowContainer(_data) constructor
{
	set_vertical(true);
}