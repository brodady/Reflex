#region jsDoc
/// @func ReflexVSplitContainer(_data)
/// @desc Vertical split container (fixed orientation).
/// @param {Struct|String|Undefined} [_data]=undefined Optional flexpanel create struct or JSON.
/// @returns {Struct.ReflexVSplitContainer}
#endregion
function ReflexVSplitContainer(_data=undefined) : ReflexSplitContainer(_data) constructor
{
	// Lock orientation to vertical
	__vertical = true;
	static __apply_orientation = ReflexSplitContainer.__apply_orientation;
	__apply_orientation();

	#region jsDoc
	/// @func set_vertical(_enabled)
	/// @desc Locked (no-op) for VSplitContainer.
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexVSplitContainer}
	#endregion
	static set_vertical = function(_enabled)
	{
		return self;
	};

	#region jsDoc
	/// @func is_vertical()
	/// @desc Always true for VSplitContainer.
	/// @returns {Bool}
	#endregion
	static is_vertical = function()
	{
		return true;
	};
}