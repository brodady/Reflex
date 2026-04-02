#region jsDoc
/// @func    ReflexCheckBox()
/// @desc    Checkbox style toggle button.
/// @param   {String} _text_value
/// @returns {Struct.ReflexCheckBox}
#endregion
function ReflexCheckBox(_text_value = "CheckBox") : ReflexButton(_text_value) constructor
{
	set_object_index(obj_reflex_check_box)
	set_toggle_mode(true);
}
