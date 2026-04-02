#region jsDoc
/// @func    ReflexUIText(_text, _font)
/// @desc    ReflexUI wrapper around ReflexLeafText.
/// @param   {String} _text
/// @param   {Asset.GMFont|Real} _font
/// @returns {Struct.ReflexUIText}
#endregion
function ReflexUIText(_text = "", _font = -1) : ReflexUI() constructor
{
	#region Setters
	
	#region jsDoc
	/// @func    set_anchor(_valign_or_preset, _halign)
	/// @desc    Forwards to the wrapped ReflexLeafText anchor setter.
	/// @self    ReflexUIText
	/// @param   {Constant.Valign|String} _valign_or_preset
	/// @param   {Constant.Halign|Undefined} _halign
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_anchor = function(_valign_or_preset, _halign = undefined)
	{
		__leaf.set_anchor(_valign_or_preset, _halign);
		return self;
	};
	
	#region jsDoc
	/// @func    set_stretch(_width, _height)
	/// @desc    Forwards stretch flags to the wrapped ReflexLeafText.
	/// @self    ReflexUIText
	/// @param   {Bool} _width
	/// @param   {Bool} _height
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_stretch = function(_width, _height)
	{
		__leaf.set_stretch(_width, _height);
		return self;
	};
	
	#region jsDoc
	/// @func    set_keep_aspect(_enabled)
	/// @desc    Forwards keep-aspect behavior to the wrapped ReflexLeafText.
	/// @self    ReflexUIText
	/// @param   {Bool} _enabled
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_keep_aspect = function(_enabled)
	{
		__leaf.set_keep_aspect(_enabled);
		return self;
	};
	
	#region jsDoc
	/// @func    set_tiling(_horizontal, _vertical)
	/// @desc    Forwards tiling behavior to the wrapped ReflexLeafText.
	/// @self    ReflexUIText
	/// @param   {Bool} _horizontal
	/// @param   {Bool} _vertical
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_tiling = function(_horizontal, _vertical)
	{
		__leaf.set_tiling(_horizontal, _vertical);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_font(_font)
	/// @desc    Sets the wrapped text font asset.
	/// @self    ReflexUIText
	/// @param   {Asset.GMFont|Real} _font
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_font = function(_font)
	{
		__leaf.set_text_font(_font);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_offsets(_x, _y)
	/// @desc    Sets the wrapped text offsets.
	/// @self    ReflexUIText
	/// @param   {Real} _x
	/// @param   {Real} _y
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_offsets = function(_x, _y)
	{
		__leaf.set_text_offsets(_x, _y);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_scale(_x, _y)
	/// @desc    Sets the wrapped text scale.
	/// @self    ReflexUIText
	/// @param   {Real} _x
	/// @param   {Real|Undefined} _y
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_scale = function(_x, _y = undefined)
	{
		__leaf.set_text_scale(_x, _y);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_rotation(_angle)
	/// @desc    Sets the wrapped text angle.
	/// @self    ReflexUIText
	/// @param   {Real} _angle
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_rotation = function(_angle)
	{
		__leaf.set_text_rotation(_angle);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_color(_color)
	/// @desc    Sets the wrapped text color.
	/// @self    ReflexUIText
	/// @param   {Int} _color
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_color = function(_color)
	{
		__leaf.set_text_color(_color);
		return self;
	};
	static set_text_colour = set_text_color;
	
	#region jsDoc
	/// @func    set_text_text(_text)
	/// @desc    Sets the wrapped text string.
	/// @self    ReflexUIText
	/// @param   {String} _text
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_text = function(_text)
	{
		__leaf.set_text_text(_text);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_justification(_halign, _valign)
	/// @desc    Sets the wrapped text justification.
	/// @self    ReflexUIText
	/// @param   {Constant.Halign} _halign
	/// @param   {Constant.Valign} _valign
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_justification = function(_halign, _valign)
	{
		__leaf.set_text_justification(_halign, _valign);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_origin(_halign, _valign)
	/// @desc    Sets the wrapped text origin.
	/// @self    ReflexUIText
	/// @param   {Constant.Halign} _halign
	/// @param   {Constant.Valign} _valign
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_origin = function(_halign, _valign)
	{
		__leaf.set_text_origin(_halign, _valign);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_origin_offsets(_x, _y)
	/// @desc    Sets the wrapped text origin offsets.
	/// @self    ReflexUIText
	/// @param   {Real} _x
	/// @param   {Real} _y
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_origin_offsets = function(_x, _y)
	{
		__leaf.set_text_origin_offsets(_x, _y);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_character_spacing(_spacing)
	/// @desc    Sets the wrapped text character spacing.
	/// @self    ReflexUIText
	/// @param   {Real} _spacing
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_character_spacing = function(_spacing)
	{
		__leaf.set_text_character_spacing(_spacing);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_line_spacing(_spacing)
	/// @desc    Sets the wrapped text line spacing.
	/// @self    ReflexUIText
	/// @param   {Real} _spacing
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_line_spacing = function(_spacing)
	{
		__leaf.set_text_line_spacing(_spacing);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_paragraph_spacing(_spacing)
	/// @desc    Sets the wrapped text paragraph spacing.
	/// @self    ReflexUIText
	/// @param   {Real} _spacing
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_paragraph_spacing = function(_spacing)
	{
		__leaf.set_text_paragraph_spacing(_spacing);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_frame(_width, _height)
	/// @desc    Sets the wrapped text frame size.
	/// @self    ReflexUIText
	/// @param   {Real} _width
	/// @param   {Real} _height
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_frame = function(_width, _height)
	{
		__leaf.set_text_frame(_width, _height);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_wrap(_enabled)
	/// @desc    Sets the wrapped text wrapping flag.
	/// @self    ReflexUIText
	/// @param   {Bool} _enabled
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_wrap = function(_enabled)
	{
		__leaf.set_text_wrap(_enabled);
		return self;
	};
	
	#region jsDoc
	/// @func    set_text_split_words(_enabled)
	/// @desc    Sets the wrapped text split-words flag.
	/// @self    ReflexUIText
	/// @param   {Bool} _enabled
	/// @returns {Struct.ReflexUIText}
	#endregion
	static set_text_split_words = function(_enabled)
	{
		__leaf.set_text_split_words(_enabled);
		return self;
	};
	
	#endregion
	
	#region Getters
	
	#region jsDoc
	/// @func    get_type()
	/// @desc    Gets the wrapped leaf type string.
	/// @self    ReflexUIText
	/// @returns {String}
	#endregion
	static get_type = function()
	{
		return __leaf.get_type();
	};
	
	#region jsDoc
	/// @func    get_element_id()
	/// @desc    Gets the wrapped element id.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_element_id = function()
	{
		return __leaf.get_element_id();
	};
	
	#region jsDoc
	/// @func    get_element_order()
	/// @desc    Gets the wrapped element order.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_element_order = function()
	{
		return __leaf.get_element_order();
	};
	
	#region jsDoc
	/// @func    get_anchor()
	/// @desc    Gets the wrapped anchor preset.
	/// @self    ReflexUIText
	/// @returns {String}
	#endregion
	static get_anchor = function()
	{
		return __leaf.get_anchor();
	};
	
	#region jsDoc
	/// @func    get_stretch_width()
	/// @desc    Gets the wrapped stretch width flag.
	/// @self    ReflexUIText
	/// @returns {Bool}
	#endregion
	static get_stretch_width = function()
	{
		return __leaf.get_stretch_width();
	};
	
	#region jsDoc
	/// @func    get_stretch_height()
	/// @desc    Gets the wrapped stretch height flag.
	/// @self    ReflexUIText
	/// @returns {Bool}
	#endregion
	static get_stretch_height = function()
	{
		return __leaf.get_stretch_height();
	};
	
	#region jsDoc
	/// @func    get_keep_aspect()
	/// @desc    Gets the wrapped keep-aspect flag.
	/// @self    ReflexUIText
	/// @returns {Bool}
	#endregion
	static get_keep_aspect = function()
	{
		return __leaf.get_keep_aspect();
	};
	
	#region jsDoc
	/// @func    get_tile_horizontal()
	/// @desc    Gets the wrapped horizontal tile flag.
	/// @self    ReflexUIText
	/// @returns {Bool}
	#endregion
	static get_tile_horizontal = function()
	{
		return __leaf.get_tile_horizontal();
	};
	
	#region jsDoc
	/// @func    get_tile_vertical()
	/// @desc    Gets the wrapped vertical tile flag.
	/// @self    ReflexUIText
	/// @returns {Bool}
	#endregion
	static get_tile_vertical = function()
	{
		return __leaf.get_tile_vertical();
	};
	
	#region jsDoc
	/// @func    get_text_font()
	/// @desc    Gets the wrapped text font asset.
	/// @self    ReflexUIText
	/// @returns {Asset.GMFont|Real}
	#endregion
	static get_text_font = function()
	{
		return __leaf.get_text_font();
	};
	
	#region jsDoc
	/// @func    get_text_offsets_x()
	/// @desc    Gets the wrapped text X offset.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_offsets_x = function()
	{
		return __leaf.get_text_offsets_x();
	};
	
	#region jsDoc
	/// @func    get_text_offsets_y()
	/// @desc    Gets the wrapped text Y offset.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_offsets_y = function()
	{
		return __leaf.get_text_offsets_y();
	};
	
	#region jsDoc
	/// @func    get_text_scale_x()
	/// @desc    Gets the wrapped text X scale.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_scale_x = function()
	{
		return __leaf.get_text_scale_x();
	};
	
	#region jsDoc
	/// @func    get_text_scale_y()
	/// @desc    Gets the wrapped text Y scale.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_scale_y = function()
	{
		return __leaf.get_text_scale_y();
	};
	
	#region jsDoc
	/// @func    get_text_rotation()
	/// @desc    Gets the wrapped text rotation.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_rotation = function()
	{
		return __leaf.get_text_rotation();
	};
	
	#region jsDoc
	/// @func    get_text_color()
	/// @desc    Gets the wrapped text color.
	/// @self    ReflexUIText
	/// @returns {Int}
	#endregion
	static get_text_color = function()
	{
		return __leaf.get_text_color();
	};
	static get_text_colour = get_text_color;
	
	#region jsDoc
	/// @func    get_text_text()
	/// @desc    Gets the wrapped text string.
	/// @self    ReflexUIText
	/// @returns {String}
	#endregion
	static get_text_text = function()
	{
		return __leaf.get_text_text();
	};
	
	#region jsDoc
	/// @func    get_text_justification()
	/// @desc    Gets the wrapped text justification value.
	/// @self    ReflexUIText
	/// @returns {Any}
	#endregion
	static get_text_justification = function()
	{
		return __leaf.get_text_justification();
	};
	
	#region jsDoc
	/// @func    get_text_origin()
	/// @desc    Gets the wrapped text origin value.
	/// @self    ReflexUIText
	/// @returns {Any}
	#endregion
	static get_text_origin = function()
	{
		return __leaf.get_text_origin();
	};
	
	#region jsDoc
	/// @func    get_text_origin_offsets_x()
	/// @desc    Gets the wrapped text origin X offset.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_origin_offsets_x = function()
	{
		return __leaf.get_text_origin_offsets_x();
	};
	
	#region jsDoc
	/// @func    get_text_origin_offsets_y()
	/// @desc    Gets the wrapped text origin Y offset.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_origin_offsets_y = function()
	{
		return __leaf.get_text_origin_offsets_y();
	};
	
	#region jsDoc
	/// @func    get_text_character_spacing()
	/// @desc    Gets the wrapped text character spacing.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_character_spacing = function()
	{
		return __leaf.get_text_character_spacing();
	};
	
	#region jsDoc
	/// @func    get_text_line_spacing()
	/// @desc    Gets the wrapped text line spacing.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_line_spacing = function()
	{
		return __leaf.get_text_line_spacing();
	};
	
	#region jsDoc
	/// @func    get_text_paragraph_spacing()
	/// @desc    Gets the wrapped text paragraph spacing.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_paragraph_spacing = function()
	{
		return __leaf.get_text_paragraph_spacing();
	};
	
	#region jsDoc
	/// @func    get_text_frame_width()
	/// @desc    Gets the wrapped text frame width.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_frame_width = function()
	{
		return __leaf.get_text_frame_width();
	};
	
	#region jsDoc
	/// @func    get_text_frame_height()
	/// @desc    Gets the wrapped text frame height.
	/// @self    ReflexUIText
	/// @returns {Real}
	#endregion
	static get_text_frame_height = function()
	{
		return __leaf.get_text_frame_height();
	};
	
	#region jsDoc
	/// @func    get_text_wrap()
	/// @desc    Gets the wrapped text wrap flag.
	/// @self    ReflexUIText
	/// @returns {Bool}
	#endregion
	static get_text_wrap = function()
	{
		return __leaf.get_text_wrap();
	};
	
	#region jsDoc
	/// @func    get_text_split_words()
	/// @desc    Gets the wrapped text split-words flag.
	/// @self    ReflexUIText
	/// @returns {Bool}
	#endregion
	static get_text_split_words = function()
	{
		return __leaf.get_text_split_words();
	};
	
	#endregion
	
	#region Functions
	
	#region jsDoc
	/// @func    get_leaf()
	/// @desc    Gets the wrapped ReflexLeafText.
	/// @self    ReflexUIText
	/// @returns {Struct.ReflexLeafText}
	#endregion
	static get_leaf = function()
	{
		return __leaf;
	};
	
	#region jsDoc
	/// @func    call_on_element_ready(_function)
	/// @desc    Forwards the element-ready callback to the wrapped ReflexLeafText.
	/// @self    ReflexUIText
	/// @param   {Method|Function} _function
	/// @returns {Struct.ReflexUIText}
	#endregion
	static call_on_element_ready = function(_function)
	{
		__leaf.call_on_element_ready(_function);
		return self;
	};
	
	#region jsDoc
	/// @func    to_struct()
	/// @desc    Gets the wrapped leaf layerElement struct.
	/// @self    ReflexUIText
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
	
	__leaf = new ReflexLeafText(_text, _font);
	add(__leaf);
	
	#endregion
}