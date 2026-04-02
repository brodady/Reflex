#region jsDoc
/// @func    ReflexButton()
/// @desc    Standard boxed Reflex button.
/// @param   {String} _text_value
/// @returns {Struct.ReflexButton}
#endregion
function ReflexButton(_text_value = "Button") : ReflexBaseButton(_text_value) constructor
{
	#region jsDoc
	/// @func    set_flat()
	/// @desc    Sets whether the standard frame should be drawn flat.
	/// @self    ReflexButton
	/// @param   {Bool} _flat_value
	/// @returns {Struct.ReflexButton}
	#endregion
	static set_flat = function(_flat_value)
	{
		set_variable("flat", _flat_value);
		return self;
	};

	set_flat(false);
}
