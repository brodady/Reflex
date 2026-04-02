#region jsDoc
/// @func    ReflexUISprite(_sprite, _index)
/// @desc    ReflexUI wrapper around ReflexLeafSprite.
/// @param   {Asset.GMSprite} _sprite
/// @param   {Real} _index
/// @returns {Struct.ReflexUISprite}
#endregion
function ReflexUISprite(_sprite = __spr_reflex, _index = 0) : ReflexUI() constructor
{
	#region Setters
	
	#region jsDoc
	/// @func    set_anchor(_valign_or_preset, _halign)
	/// @desc    Forwards to the wrapped ReflexLeafSprite anchor setter.
	/// @self    ReflexUISprite
	/// @param   {Constant.Valign|String} _valign_or_preset
	/// @param   {Constant.Halign|Undefined} _halign
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_anchor = function(_valign_or_preset, _halign = undefined)
	{
		__leaf.set_anchor(_valign_or_preset, _halign);
		return self;
	};
	
	#region jsDoc
	/// @func    set_stretch(_width, _height)
	/// @desc    Forwards stretch flags to the wrapped ReflexLeafSprite.
	/// @self    ReflexUISprite
	/// @param   {Bool} _width
	/// @param   {Bool} _height
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_stretch = function(_width, _height)
	{
		__leaf.set_stretch(_width, _height);
		return self;
	};
	
	#region jsDoc
	/// @func    set_keep_aspect(_enabled)
	/// @desc    Forwards keep-aspect behavior to the wrapped ReflexLeafSprite.
	/// @self    ReflexUISprite
	/// @param   {Bool} _enabled
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_keep_aspect = function(_enabled)
	{
		__leaf.set_keep_aspect(_enabled);
		return self;
	};
	
	#region jsDoc
	/// @func    set_tiling(_horizontal, _vertical)
	/// @desc    Forwards tiling behavior to the wrapped ReflexLeafSprite.
	/// @self    ReflexUISprite
	/// @param   {Bool} _horizontal
	/// @param   {Bool} _vertical
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_tiling = function(_horizontal, _vertical)
	{
		__leaf.set_tiling(_horizontal, _vertical);
		return self;
	};
	
	#region jsDoc
	/// @func    set_visible(_enabled)
	/// @desc    Forwards visibility to the wrapped ReflexLeafSprite.
	/// @self    ReflexUISprite
	/// @param   {Bool} _enabled
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_visible = function(_enabled)
	{
		__leaf.set_visible(_enabled);
		return self;
	};
	
	#region jsDoc
	/// @func    set_sprite_sprite(_sprite, _index)
	/// @desc    Sets the wrapped sprite asset and optional subimage.
	/// @self    ReflexUISprite
	/// @param   {Asset.GMSprite} _sprite
	/// @param   {Real|Undefined} _index
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_sprite_sprite = function(_sprite, _index = undefined)
	{
		__leaf.set_sprite_sprite(_sprite, _index);
		return self;
	};
	
	#region jsDoc
	/// @func    set_sprite_offsets(_x, _y)
	/// @desc    Sets the wrapped sprite offsets.
	/// @self    ReflexUISprite
	/// @param   {Real} _x
	/// @param   {Real} _y
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_sprite_offsets = function(_x, _y)
	{
		__leaf.set_sprite_offsets(_x, _y);
		return self;
	};
	
	#region jsDoc
	/// @func    set_sprite_scale(_x, _y)
	/// @desc    Sets the wrapped sprite scale.
	/// @self    ReflexUISprite
	/// @param   {Real} _x
	/// @param   {Real|Undefined} _y
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_sprite_scale = function(_x, _y = undefined)
	{
		__leaf.set_sprite_scale(_x, _y);
		return self;
	};
	
	#region jsDoc
	/// @func    set_sprite_rotation(_angle)
	/// @desc    Sets the wrapped sprite angle.
	/// @self    ReflexUISprite
	/// @param   {Real} _angle
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_sprite_rotation = function(_angle)
	{
		__leaf.set_sprite_rotation(_angle);
		return self;
	};
	
	#region jsDoc
	/// @func    set_sprite_color(_color)
	/// @desc    Sets the wrapped sprite blend color.
	/// @self    ReflexUISprite
	/// @param   {Int} _color
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_sprite_color = function(_color)
	{
		__leaf.set_sprite_color(_color);
		return self;
	};
	static set_sprite_colour = set_sprite_color;
	
	#region jsDoc
	/// @func    set_sprite_image(_index)
	/// @desc    Sets the wrapped sprite subimage index.
	/// @self    ReflexUISprite
	/// @param   {Real} _index
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_sprite_image = function(_index)
	{
		__leaf.set_sprite_image(_index);
		return self;
	};
	
	#region jsDoc
	/// @func    set_sprite_speed(_speed, _speed_type)
	/// @desc    Sets the wrapped sprite animation speed.
	/// @self    ReflexUISprite
	/// @param   {Real} _speed
	/// @param   {Real|Undefined} _speed_type
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static set_sprite_speed = function(_speed, _speed_type = undefined)
	{
		__leaf.set_sprite_speed(_speed, _speed_type);
		return self;
	};
	
	#endregion
	
	#region Getters
	
	#region jsDoc
	/// @func    get_type()
	/// @desc    Gets the wrapped leaf type string.
	/// @self    ReflexUISprite
	/// @returns {String}
	#endregion
	static get_type = function()
	{
		return __leaf.get_type();
	};
	
	#region jsDoc
	/// @func    get_element_id()
	/// @desc    Gets the wrapped element id.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_element_id = function()
	{
		return __leaf.get_element_id();
	};
	
	#region jsDoc
	/// @func    get_element_order()
	/// @desc    Gets the wrapped element order.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_element_order = function()
	{
		return __leaf.get_element_order();
	};
	
	#region jsDoc
	/// @func    get_anchor()
	/// @desc    Gets the wrapped anchor preset.
	/// @self    ReflexUISprite
	/// @returns {String}
	#endregion
	static get_anchor = function()
	{
		return __leaf.get_anchor();
	};
	
	#region jsDoc
	/// @func    get_stretch_width()
	/// @desc    Gets the wrapped stretch width flag.
	/// @self    ReflexUISprite
	/// @returns {Bool}
	#endregion
	static get_stretch_width = function()
	{
		return __leaf.get_stretch_width();
	};
	
	#region jsDoc
	/// @func    get_stretch_height()
	/// @desc    Gets the wrapped stretch height flag.
	/// @self    ReflexUISprite
	/// @returns {Bool}
	#endregion
	static get_stretch_height = function()
	{
		return __leaf.get_stretch_height();
	};
	
	#region jsDoc
	/// @func    get_keep_aspect()
	/// @desc    Gets the wrapped keep-aspect flag.
	/// @self    ReflexUISprite
	/// @returns {Bool}
	#endregion
	static get_keep_aspect = function()
	{
		return __leaf.get_keep_aspect();
	};
	
	#region jsDoc
	/// @func    get_tile_horizontal()
	/// @desc    Gets the wrapped horizontal tile flag.
	/// @self    ReflexUISprite
	/// @returns {Bool}
	#endregion
	static get_tile_horizontal = function()
	{
		return __leaf.get_tile_horizontal();
	};
	
	#region jsDoc
	/// @func    get_tile_vertical()
	/// @desc    Gets the wrapped vertical tile flag.
	/// @self    ReflexUISprite
	/// @returns {Bool}
	#endregion
	static get_tile_vertical = function()
	{
		return __leaf.get_tile_vertical();
	};
	
	#region jsDoc
	/// @func    get_sprite_sprite()
	/// @desc    Gets the wrapped sprite asset.
	/// @self    ReflexUISprite
	/// @returns {Asset.GMSprite}
	#endregion
	static get_sprite_sprite = function()
	{
		return __leaf.get_sprite_sprite();
	};
	
	#region jsDoc
	/// @func    get_sprite_image()
	/// @desc    Gets the wrapped sprite image index.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_sprite_image = function()
	{
		return __leaf.get_sprite_image();
	};
	
	#region jsDoc
	/// @func    get_sprite_offsets_x()
	/// @desc    Gets the wrapped sprite X offset.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_sprite_offsets_x = function()
	{
		return __leaf.get_sprite_offsets_x();
	};
	
	#region jsDoc
	/// @func    get_sprite_offsets_y()
	/// @desc    Gets the wrapped sprite Y offset.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_sprite_offsets_y = function()
	{
		return __leaf.get_sprite_offsets_y();
	};
	
	#region jsDoc
	/// @func    get_sprite_scale_x()
	/// @desc    Gets the wrapped sprite X scale.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_sprite_scale_x = function()
	{
		return __leaf.get_sprite_scale_x();
	};
	
	#region jsDoc
	/// @func    get_sprite_scale_y()
	/// @desc    Gets the wrapped sprite Y scale.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_sprite_scale_y = function()
	{
		return __leaf.get_sprite_scale_y();
	};
	
	#region jsDoc
	/// @func    get_sprite_rotation()
	/// @desc    Gets the wrapped sprite rotation.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_sprite_rotation = function()
	{
		return __leaf.get_sprite_rotation();
	};
	
	#region jsDoc
	/// @func    get_sprite_color()
	/// @desc    Gets the wrapped sprite color.
	/// @self    ReflexUISprite
	/// @returns {Int}
	#endregion
	static get_sprite_color = function()
	{
		return __leaf.get_sprite_color();
	};
	static get_sprite_colour = get_sprite_color;
	
	#region jsDoc
	/// @func    get_sprite_speed()
	/// @desc    Gets the wrapped sprite speed.
	/// @self    ReflexUISprite
	/// @returns {Real}
	#endregion
	static get_sprite_speed = function()
	{
		return __leaf.get_sprite_speed();
	};
	
	#endregion
	
	#region Functions
	
	#region jsDoc
	/// @func    get_leaf()
	/// @desc    Gets the wrapped ReflexLeafSprite.
	/// @self    ReflexUISprite
	/// @returns {Struct.ReflexLeafSprite}
	#endregion
	static get_leaf = function()
	{
		return __leaf;
	};
	
	#region jsDoc
	/// @func    call_on_element_ready(_function)
	/// @desc    Forwards the element-ready callback to the wrapped ReflexLeafSprite.
	/// @self    ReflexUISprite
	/// @param   {Method|Function} _function
	/// @returns {Struct.ReflexUISprite}
	#endregion
	static call_on_element_ready = function(_function)
	{
		__leaf.call_on_element_ready(_function);
		return self;
	};
	
	#region jsDoc
	/// @func    to_struct()
	/// @desc    Gets the wrapped leaf layerElement struct.
	/// @self    ReflexUISprite
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		return __leaf.to_struct();
	};
	
	#endregion
	
	#region Events
	
	#endregion
	
	#region Private
	
	__leaf = new ReflexLeafSprite(_sprite, _index);
	add(__leaf);
	
	#endregion
}