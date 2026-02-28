#region jsDoc
/// @desc
///		Text layer element descriptor.
///		Produces a struct compatible with a layerElements entry of type "Text".
///
#endregion
function ReflexLayerElementText() : ReflexLayerElementBase() constructor
{
	set_common("Text", 0.0, 0.0);

	// Text defaults (from your example)
	textScaleX = 1.0;
	textScaleY = 1.0;
	textAngle = 0.0;
	textColour = c_white;

	textOriginX = 0.0;
	textOriginY = 0.0;
	textOrigin = 0.0;

	textText = "";
	textAlignment = 0.0;

	textCharacterSpacing = 0.0;
	textLineSpacing = 0.0;
	textParagraphSpacing = 0.0;

	textFrameWidth = 0.0;
	textFrameHeight = 0.0;

	textWrap = false;
	textWrapMode = false;

	textFontIndex = fnt_lbl;

	textOffsetX = 0.0;
	textOffsetY = 0.0;
	
	#region Setters
    
    static set_alignment = function(_halign) { 
        textAlignment = _halign;
        return self; 
    };

    static set_rotation = function(_angle) { 
        textAngle = _angle; 
        return self; 
    };
    #endregion
	
	
	#region jsDoc
	/// @func    set_text()
	/// @desc    Sets the text string.
	/// @self    ReflexLayerElementText
	/// @param   {String} _text_value
	/// @returns {Struct.ReflexLayerElementText}
	#endregion
	static set_text = function(_str)
	{
		if (textText == _str) return self;
		textText = _str;
		return self;
	};

	#region jsDoc
	/// @func    set_font()
	/// @desc    Sets the font.
	/// @self    ReflexLayerElementText
	/// @param   {String} _font_ref
	/// @returns {Struct.ReflexLayerElementText}
	#endregion
	static set_font = function(_font)
	{
		textFontIndex = _font;
		return self;
	};

	#region jsDoc
	/// @func    set_colour()
	/// @desc    Sets text colour (packed integer, ex: -1.0 for white/default).
	/// @self    ReflexLayerElementText
	/// @param   {Real} _colour_value
	/// @returns {Struct.ReflexLayerElementText}
	#endregion
	static set_colour = function(_colour_value)
	{
		textColour = _colour_value;
		return self;
	};

	#region jsDoc
	/// @func    set_scale()
	/// @desc    Sets text scale.
	/// @self    ReflexLayerElementText
	/// @param   {Real} _scale_x
	/// @param   {Real} _scale_y
	/// @returns {Struct.ReflexLayerElementText}
	#endregion
	static set_scale = function(_scale_x, _scale_y)
	{
		textScaleX = _scale_x;
		textScaleY = (_scale_y == undefined) ? _scale_x : _scale_y;
		return self;
	};
	
	#region jsDoc
	/// @func    set_offset()
	/// @desc    Sets text offset (local).
	/// @self    ReflexLayerElementText
	/// @param   {Real} _offset_x
	/// @param   {Real} _offset_y
	/// @returns {Struct.ReflexLayerElementText}
	#endregion
	static set_offset = function(_offset_x, _offset_y)
	{
		textOffsetX = _offset_x;
		textOffsetY = _offset_y;
		return self;
	};

	#region jsDoc
	/// @func    to_struct()
	/// @desc    Builds a "Text" layerElements struct.
	/// @self    ReflexLayerElementText
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		static __base_to_struct = ReflexLayerElementBase.to_struct;
		var _base_struct = __base_to_struct();
		
		_base_struct.textScaleX = textScaleX;
		_base_struct.textScaleY = textScaleY;
		_base_struct.textAngle = textAngle;
		_base_struct.textColour = textColour;
		
		_base_struct.textOriginX = textOriginX;
		_base_struct.textOriginY = textOriginY;
		_base_struct.textOrigin = textOrigin;
		
		_base_struct.textText = textText;
		_base_struct.textAlignment = textAlignment;
		
		_base_struct.textCharacterSpacing = textCharacterSpacing;
		_base_struct.textLineSpacing = textLineSpacing;
		_base_struct.textParagraphSpacing = textParagraphSpacing;
		
		_base_struct.textFrameWidth = textFrameWidth;
		_base_struct.textFrameHeight = textFrameHeight;
		
		_base_struct.textWrap = textWrap;
		_base_struct.textWrapMode = textWrapMode;
		
		_base_struct.textFontIndex = textFontIndex;
		
		_base_struct.textOffsetX = textOffsetX;
		_base_struct.textOffsetY = textOffsetY;
		
		return _base_struct;
	};
}
