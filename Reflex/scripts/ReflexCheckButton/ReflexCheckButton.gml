#region jsDoc
/// @func    ReflexCheckButton()
/// @desc    Check button style toggle button.
/// @param   {String} _text_value
/// @returns {Struct.ReflexCheckButton}
#endregion
function ReflexCheckButton(_text_value = "CheckButton") : ReflexButton(_text_value) constructor
{
	set_object_index(obj_reflex_check_button);
	set_toggle_mode(true);
}
