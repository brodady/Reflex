#region jsDoc
/// @func    ReflexColorPickerButton()
/// @desc    Color picker button scaffold. Popup behavior is not fully wired yet.
/// @param   {String} _text_value
/// @returns {Struct.ReflexColorPickerButton}
#endregion
function ReflexColorPickerButton(_text_value = "Color") : ReflexButton(_text_value) constructor
{
	set_object_index(obj_reflex_color_picker_button)
}
