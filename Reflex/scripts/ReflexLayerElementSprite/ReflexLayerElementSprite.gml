#region jsDoc
/// @desc
///		Sprite layer element descriptor.
///		Produces a struct compatible with a layerElements entry of type "Sprite".
///
#endregion
function ReflexLayerElementSprite() : ReflexLayerElementBase() constructor
{
	set_common("Sprite", 0.0, 0.0);

	// Sprite defaults (from your example)
	spriteIndex = spr_rect_round_all_8;
	spriteOffsetX = 0.0;
	spriteOffsetY = 0.0;

	spriteScaleX = 1.0;
	spriteScaleY = 1.0;

	spriteColour = -1.0;
	spriteAngle = 0.0;

	spriteImageSpeed = 1.0;
	spriteSpeedType = 0.0;
	spriteImageIndex = 0.0;

	#region jsDoc
	/// @func    set_sprite()
	/// @desc    Sets the sprite reference string (ex: "@ref sprite(spr_name)").
	/// @self    ReflexLayerElementSprite
	/// @param   {String} _sprite_ref
	/// @returns {Struct.ReflexLayerElementSprite}
	#endregion
	static set_sprite = function(_sprite_ref)
	{
		spriteIndex = _sprite_ref;
		return self;
	};

	#region jsDoc
	/// @func    set_image()
	/// @desc    Sets image index and speed.
	/// @self    ReflexLayerElementSprite
	/// @param   {Real} _image_index
	/// @param   {Real} _image_speed
	/// @param   {Real} _speed_type
	/// @returns {Struct.ReflexLayerElementSprite}
	#endregion
	static set_image = function(_image_index, _image_speed=1.0, _speed_type=0.0)
	{
		spriteImageIndex = _image_index;
		spriteImageSpeed = _image_speed;
		spriteSpeedType = _speed_type;
		return self;
	};

	#region jsDoc
	/// @func    set_colour()
	/// @desc    Sets sprite colour (packed integer, ex: -1.0 for white/default).
	/// @self    ReflexLayerElementSprite
	/// @param   {Real} _colour_value
	/// @returns {Struct.ReflexLayerElementSprite}
	#endregion
	static set_colour = function(_colour_value)
	{
		spriteColour = _colour_value;
		return self;
	};

	#region jsDoc
	/// @func    set_scale()
	/// @desc    Sets sprite scale.
	/// @self    ReflexLayerElementSprite
	/// @param   {Real} _scale_x
	/// @param   {Real} _scale_y
	/// @returns {Struct.ReflexLayerElementSprite}
	#endregion
	static set_scale = function(_scale_x, _scale_y)
	{
		spriteScaleX = _scale_x;
		spriteScaleY = _scale_y;
		return self;
	};

	#region jsDoc
	/// @func    set_offset()
	/// @desc    Sets sprite offset (local).
	/// @self    ReflexLayerElementSprite
	/// @param   {Real} _offset_x
	/// @param   {Real} _offset_y
	/// @returns {Struct.ReflexLayerElementSprite}
	#endregion
	static set_offset = function(_offset_x, _offset_y)
	{
		spriteOffsetX = _offset_x;
		spriteOffsetY = _offset_y;
		return self;
	};

	#region jsDoc
	/// @func    to_struct()
	/// @desc    Builds a "Sprite" layerElements struct.
	/// @self    ReflexLayerElementSprite
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		static __base_to_struct = ReflexLayerElementBase.to_struct;
		var _base_struct = __base_to_struct();
		
		_base_struct.spriteIndex = spriteIndex;
		_base_struct.spriteOffsetX = spriteOffsetX;
		_base_struct.spriteOffsetY = spriteOffsetY;
		
		_base_struct.spriteScaleX = spriteScaleX;
		_base_struct.spriteScaleY = spriteScaleY;
		
		_base_struct.spriteColour = spriteColour;
		_base_struct.spriteAngle = spriteAngle;
		
		_base_struct.spriteImageSpeed = spriteImageSpeed;
		_base_struct.spriteSpeedType = spriteSpeedType;
		_base_struct.spriteImageIndex = spriteImageIndex;
		
		return _base_struct;
	};
}
