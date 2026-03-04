#region jsDoc
/// @func ReflexHSplitContainer(_data)
/// @desc Horizontal split container (fixed orientation).
/// @param {Struct|String|Undefined} [_data]=undefined Optional flexpanel create struct or JSON.
/// @returns {Struct.ReflexHSplitContainer}
#endregion
function ReflexHSplitContainer(_data=undefined) : ReflexSplitContainer(_data) constructor
{
	// Lock orientation to horizontal
	__vertical = false;
	static __apply_orientation = ReflexSplitContainer.__apply_orientation;
	__apply_orientation();

	#region jsDoc
	/// @func set_vertical(_enabled)
	/// @desc Locked (no-op) for HSplitContainer.
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexHSplitContainer}
	#endregion
	static set_vertical = function(_enabled)
	{
		return self;
	};

	#region jsDoc
	/// @func is_vertical()
	/// @desc Always false for HSplitContainer.
	/// @returns {Bool}
	#endregion
	static is_vertical = function()
	{
		return false;
	};
}