#region jsDoc
/// @func    ReflexTextureButton()
/// @desc    Texture driven button.
/// @param   {String} _text_value
/// @returns {Struct.ReflexTextureButton}
#endregion
function ReflexTextureButton(_text_value = "") : ReflexBaseButton(_text_value) constructor
{
	#region jsDoc
	/// @func    set_sprites()
	/// @desc    Sets the per-state sprite indices.
	/// @self    ReflexTextureButton
	/// @param   {Real} _idle_sprite
	/// @param   {Real} _hover_sprite
	/// @param   {Real} _pressed_sprite
	/// @param   {Real} _disabled_sprite
	/// @param   {Real} _checked_sprite
	/// @returns {Struct.ReflexTextureButton}
	#endregion
	static set_sprites = function(_idle_sprite, _hover_sprite, _pressed_sprite, _disabled_sprite, _checked_sprite)
	{
		var _instance_id = get_instance_id();
		if (_instance_id == undefined)
		{
			set_variable("sprite_idle", _idle_sprite);
			set_variable("sprite_hover", _hover_sprite);
			set_variable("sprite_pressed", _pressed_sprite);
			set_variable("sprite_disabled", _disabled_sprite);
			set_variable("sprite_checked", _checked_sprite);
		}
		else
		{
			_instance_id.sprite_idle = _idle_sprite;
			_instance_id.sprite_hover = _hover_sprite;
			_instance_id.sprite_pressed = _pressed_sprite;
			_instance_id.sprite_disabled = _disabled_sprite;
			_instance_id.sprite_checked = _checked_sprite;
		}
		return self;
	};
	
	
	set_object_index(obj_reflex_texture_button)
}
