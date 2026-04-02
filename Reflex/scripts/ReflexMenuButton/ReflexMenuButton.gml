#region jsDoc
/// @func    ReflexMenuButton()
/// @desc    Menu button scaffold. Popup behavior is not fully wired yet.
/// @param   {String} _text_value
/// @returns {Struct.ReflexMenuButton}
#endregion
function ReflexMenuButton(_text_value = "Menu") : ReflexButton(_text_value) constructor
{
	set_object_index(obj_reflex_menu_button)
}
