#region jsDoc
/// @desc
///		ReflexHFlowContainer is a FlowContainer locked to horizontal (row) flow layout.
///
///		Godot-inspired behavior:
///		- Arranges children left->right and wraps to new rows.
///
#endregion
function ReflexHFlowContainer(_data=undefined) : ReflexFlowContainer(_data) constructor
{
	set_vertical(false);
}