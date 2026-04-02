#region jsDoc
/// @func    ReflexOptionButton()
/// @desc    Option button scaffold. Popup behavior is not fully wired yet.
/// @param   {String} _text_value
/// @returns {Struct.ReflexOptionButton}
#endregion
function ReflexOptionButton(_text_value = "Option") : ReflexButton(_text_value) constructor
{
	set_object_index(obj_reflex_option_button)
}
