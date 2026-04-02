#region jsDoc
/// @func    ReflexBaseButton()
/// @desc    Base constructor for all Reflex button widgets.
/// @param   {String} _text_value
/// @returns {Struct.ReflexBaseButton}
#endregion
function ReflexBaseButton(_text_value = "Button") : ReflexLeafObject() constructor
{
	enum ActionMode{
		RELEASE,
		PRESS
	};

	#region jsDoc
	/// @func    set_text()
	/// @desc    Sets the button text.
	/// @self    ReflexBaseButton
	/// @param   {String} _text_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_text = function(_text_value)
	{
		set_variable("text", _text_value);
		return self;
	};

	#region jsDoc
	/// @func    set_size()
	/// @desc    Sets the button size using built-in image scales.
	/// @self    ReflexBaseButton
	/// @param   {Real} _width_value
	/// @param   {Real} _height_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_size = function(_width_value, _height_value)
	{
		set_width(_width_value)
		set_height(_height_value)
		return self;
	};

	#region jsDoc
	/// @func    set_disabled()
	/// @desc    Sets whether the button is disabled.
	/// @self    ReflexBaseButton
	/// @param   {Bool} _disabled_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_disabled = function(_disabled_value)
	{
		set_variable("disabled", _disabled_value);
		return self;
	};

	#region jsDoc
	/// @func    set_toggle_mode()
	/// @desc    Sets whether the button toggles.
	/// @self    ReflexBaseButton
	/// @param   {Bool} _toggle_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_toggle_mode = function(_toggle_value)
	{
		set_variable("toggle_mode", _toggle_value);
		return self;
	};

	#region jsDoc
	/// @func    set_button_pressed()
	/// @desc    Sets the current toggle state.
	/// @self    ReflexBaseButton
	/// @param   {Bool} _pressed_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_button_pressed = function(_pressed_value)
	{
		set_variable("button_pressed", _pressed_value);
		return self;
	};

	#region jsDoc
	/// @func    set_action_mode()
	/// @desc    Sets whether activation happens on release or press.
	/// @self    ReflexBaseButton
	/// @param   {Real} _action_mode_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_action_mode = function(_action_mode_value)
	{
		set_variable("action_mode", _action_mode_value);
		return self;
	};

	#region jsDoc
	/// @func    set_keep_pressed_outside()
	/// @desc    Sets whether release outside still activates the button.
	/// @self    ReflexBaseButton
	/// @param   {Bool} _keep_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_keep_pressed_outside = function(_keep_value)
	{
		set_variable("keep_pressed_outside", _keep_value);
		return self;
	};

	#region jsDoc
	/// @func    set_theme()
	/// @desc    Sets the theme struct for this button instance.
	/// @self    ReflexBaseButton
	/// @param   {Struct} _theme_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_theme = function(_theme_value)
	{
		set_variable("theme", _theme_value);
		return self;
	};

	#region jsDoc
	/// @func    set_on_pressed()
	/// @desc    Sets the callback invoked when the button activates.
	/// @self    ReflexBaseButton
	/// @param   {Function} _callback_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_on_pressed = function(_callback_value)
	{
		set_variable("on_pressed", _callback_value);
		return self;
	};

	#region jsDoc
	/// @func    set_on_toggled()
	/// @desc    Sets the callback invoked when the toggle state changes.
	/// @self    ReflexBaseButton
	/// @param   {Function} _callback_value
	/// @returns {Struct.ReflexBaseButton}
	#endregion
	static set_on_toggled = function(_callback_value)
	{
		set_variable("on_toggled", _callback_value);
		return self;
	};
	
	set_instance_object(obj_reflex_base_button)
	set_text(_text_value);
	set_size(96, 28);
	//set_sprite_index(spr_reflex_pixel);
	set_disabled(false);
	set_toggle_mode(false);
	set_button_pressed(false);
	set_action_mode(ActionMode.RELEASE);
	set_keep_pressed_outside(false);
}
