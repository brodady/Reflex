#region jsDoc
/// @func ReflexText(_text, _font)
/// @desc Specialized leaf node for native GameMaker text rendering.
/// @param {String} [_text]="" The initial text string.
/// @param {Asset.GMFont} [_font]=-1 The font asset to use.
/// @return {ReflexText}
#endregion
function ReflexText(_text = "", _font = -1) : ReflexLeaf() constructor 
{
    #region Setters
	#region jsDoc
	/// @func set_text_font(_font)
	/// @desc Sets the font asset used for rendering.
	/// @param {Asset.GMFont} font : Font asset.
	/// @return {ReflexText}
	#endregion
    static set_text_font = function(_font) { 
		if (textFontIndex == _font) return self;
		textFontIndex = _font;
        rebuild_node(to_struct()); 
        return self; 
    };
	
	///////////////////////////////////////////////////
	#region jsDoc
	/// @func set_text_offsets(_x, _y)
	/// @desc Sets text position offsets relative to the origin. IDE: "Position - X", "Position - Y".
	/// @param {Real} x : X value.
	/// @param {Real} y : Y value.
	/// @return {ReflexText}
	#endregion
	static set_text_offsets = function(_x, _y) {
		if (textOffsetX == _x)
        && (textOffsetY == _y) {
			return self;
		}
		
		textOffsetX = _x;
		textOffsetY = _y;
		
		rebuild_node(to_struct());
        return self;
	}
	
	#region jsDoc
	/// @func set_text_scale(_x, _y)
	/// @desc Sets text scale. IDE: "Scale - X", "Scale - Y".
	/// @param {Real} x : X value.
	/// @param {Real} y : Y value.
	/// @return {ReflexText}
	#endregion
	static set_text_scale = function(_x, _y = undefined) { 
        _y = (_y == undefined) ? _x : _y;
		
		if (textScaleX == _x)
        && (textScaleX == _y) {
			return self;
		}
		
		textScaleX = _x; 
        textScaleY = _y;
		rebuild_node(to_struct()); 
        return self; 
    };
	
	#region jsDoc
	/// @func set_text_rotation(_angle)
	/// @desc Sets text rotation in degrees. IDE: "Rotation".
	/// @param {Real} angle : Rotation angle in degrees.
	/// @return {ReflexText}
	#endregion
	static set_text_rotation = function(_angle) { 
        if (textAngle == _angle) return self;
        textAngle = _angle;
        rebuild_node(to_struct()); 
        return self; 
    };
	
	#region jsDoc
	/// @func set_text_color(_col)
	/// @desc Sets text color tint. IDE: "Colour".
	/// @param {Int} col : Color value.
	/// @return {ReflexText}
	#endregion
	static set_text_color = function(_col) { 
		var _unsigned = (_col & 0x00FFFFFF) | 0xFF000000;
		_unsigned -= 0x100000000;
		
		if (textColour == _unsigned) return self;
        textColour = _unsigned;
        rebuild_node(to_struct()); 
        return self; 
    };
    static set_text_colour = set_text_color;
	
	#region jsDoc
	/// @func set_text_text(_str)
	/// @desc Sets the rendered text string. IDE: "Text".
	/// @param {String} str : Text string.
	/// @return {ReflexText}
	#endregion
	static set_text_text = function(_str) {
        if (textText == _str) return self;
        textText = _str;
        rebuild_node(to_struct());
        return self;
    };
	
    ///////////////////////////////////////////////////
	#region jsDoc
	/// @func set_text_justification(_halign, _valign)
	/// @desc Sets text justification alignment. IDE: "Justification".
	/// @param {Int} halign : Horizontal alignment value.
	/// @param {Int} valign : Vertical alignment value.
	/// @return {ReflexText}
	#endregion
    static set_text_justification = function(_halign, _valign) {
		// a value of _halign = -1 or 4 will result in a justification span horz.
		// i see no visual changes to this, but exposing anyways.
		var _just_val = 0;
		switch(_valign) {
			case fa_top   : _just_val += 0; break;
			case fa_middle: _just_val += 256; break;
			case fa_bottom: _just_val += 512; break;
		}
		switch(_halign) {
			case fa_left  : _just_val += 0; break;
			case fa_center: _just_val += 1; break;
			case fa_right : _just_val += 2; break;
			default: _just_val += 3; break;
		}
		
		rebuild_node(to_struct());
        return self;
	}
    
	#region jsDoc
	/// @func set_text_origin(_halign, _valign)
	/// @desc Sets the frame origin preset. IDE: "Frame Origin".
	/// @param {Int} halign : Horizontal alignment value.
	/// @param {Int} valign : Vertical alignment value.
	/// @return {ReflexText}
	#endregion
	static set_text_origin = function(_halign, _valign) {
		// These values are hard to read, but imagine they are like a book 0 = top left; 8 = bottoms right
		// 0 1 2
		// 3 4 5
		// 6 7 8
		// This is just what YYG decided was best.
		
        switch(_valign) {
			case fa_top:{
				switch(_halign) {
					case fa_left  : flexAnchor = 0; break;
					case fa_center: flexAnchor = 1; break;
					case fa_right : flexAnchor = 2; break;
				}
			break;}
			case fa_middle:{
				switch(_halign) {
					case fa_left  : flexAnchor = 3; break;
					case fa_center: flexAnchor = 4; break;
					case fa_right : flexAnchor = 5; break;
				}
			break;}
			case fa_bottom:{
				switch(_halign) {
					case fa_left  : flexAnchor = 6; break;
					case fa_center: flexAnchor = 7; break;
					case fa_right : flexAnchor = 8; break;
				}
			break;}
		}
		
		rebuild_node(to_struct());
        return self;
    };
	
	#region jsDoc
	/// @func set_text_origin_offsets(_x, _y)
	/// @desc Sets origin offsets, used to offset rotation pivot. IDE: "Origin Offset - X", "Origin Offset - Y".
	/// @param {Real} x : X value.
	/// @param {Real} y : Y value.
	/// @return {ReflexText}
	#endregion
	static set_text_origin_offsets = function(_x, _y) {
		textOriginX = _x;
		textOriginY = _y;
		
		rebuild_node(to_struct());
        return self;
	}
	
	#region jsDoc
	/// @func set_text_character_spacing(_sep)
	/// @desc Sets additional spacing between characters. IDE: "Character Spacing".
	/// @param {Real} sep : Spacing value.
	/// @return {ReflexText}
	#endregion
    static set_text_character_spacing = function(_sep) {
		if (textCharacterSpacing == _sep) return self;
        textCharacterSpacing = _sep;
        rebuild_node(to_struct()); 
        return self; 
    };
	
	#region jsDoc
	/// @func set_text_line_spacing(_sep)
	/// @desc Sets additional spacing between lines. IDE: "Line Spacing".
	/// @param {Real} sep : Spacing value.
	/// @return {ReflexText}
	#endregion
	static set_text_line_spacing = function(_sep) {
		if (textLineSpacing == _sep) return self;
        textLineSpacing = _sep;
        rebuild_node(to_struct()); 
        return self; 
    };
	
	#region jsDoc
	/// @func set_text_paragraph_spacing(_sep)
	/// @desc Sets additional spacing between paragraphs. IDE: "Paragraph Spacing".
	/// @param {Real} sep : Spacing value.
	/// @return {ReflexText}
	#endregion
	static set_text_paragraph_spacing = function(_sep) {
		if (textParagraphSpacing == _sep) return self;
        textParagraphSpacing = _sep;
        rebuild_node(to_struct()); 
        return self; 
    };
	
	///////////////////////////////////////////////////
	#region jsDoc
	/// @func set_text_frame(_width, _height)
	/// @desc Sets the text frame size. IDE: "Frame - W", "Frame - H".
	/// @param {Bool} width : Whether width stretches.
	/// @param {Bool} height : Whether height stretches.
	/// @return {ReflexText}
	#endregion
	static set_text_frame = function(_width, _height) {
		if (textFrameWidth  == _width)
		&& (textFrameHeight == _height) {
			return self;
		}
		
		textFrameWidth  = _width;
		textFrameHeight = _height;
		
        rebuild_node(to_struct()); 
        return self; 
    };
	
	#region jsDoc
	/// @func set_text_wrap(_bool)
	/// @desc Sets whether wrapping is enabled. IDE: "Wrap".
	/// @param {Bool} bool : Enabled state.
	/// @return {ReflexText}
	#endregion
	static set_text_wrap = function(_bool) {
		if (textWrap == _bool) return self;
        textWrap = _bool;
        rebuild_node(to_struct()); 
        return self; 
    };
	
	#region jsDoc
	/// @func set_text_split_words(_bool)
	/// @desc Sets wrap mode for splitting words. IDE: "Split words".
	/// @param {Bool} bool : Enabled state.
	/// @return {ReflexText}
	#endregion
	static set_text_split_words = function(_bool) {
		if (textWrapMode == _bool) return self;
        textWrapMode = _bool;
        rebuild_node(to_struct()); 
        return self; 
    };
	
	#endregion
	
	#region Getters
	
	#region jsDoc
	/// @func get_text_font()
	/// @desc Gets the font asset used for this text element.
	/// @returns {Asset.GMFont}
	#endregion
	static get_text_font = function() { return textFontIndex; };
	
	#region jsDoc
	/// @func get_text_offsets_x()
	/// @desc Gets the text X offset.
	/// @returns {Real}
	#endregion
	static get_text_offsets_x = function() { return textOffsetX; };
	
	#region jsDoc
	/// @func get_text_offsets_y()
	/// @desc Gets the text Y offset.
	/// @returns {Real}
	#endregion
	static get_text_offsets_y = function() { return textOffsetY; };
	
	#region jsDoc
	/// @func get_text_scale_x()
	/// @desc Gets the text X scale.
	/// @returns {Real}
	#endregion
	static get_text_scale_x = function() { return textScaleX; };
	
	#region jsDoc
	/// @func get_text_scale_y()
	/// @desc Gets the text Y scale.
	/// @returns {Real}
	#endregion
	static get_text_scale_y = function() { return textScaleY; };
	
	#region jsDoc
	/// @func get_text_rotation()
	/// @desc Gets the text rotation in degrees.
	/// @returns {Real}
	#endregion
	static get_text_rotation = function() { return textAngle; };
	
	#region jsDoc
	/// @func get_text_color()
	/// @desc Gets the text color (-1 means unset).
	/// @returns {Real}
	#endregion
	static get_text_color = function() { return textColour; };
	static get_text_colour = get_text_color;
	
	#region jsDoc
	/// @func get_text_text()
	/// @desc Gets the current text string.
	/// @returns {String}
	#endregion
	static get_text_text = function() { return textText; };
	
	#region jsDoc
	/// @func get_text_justification()
	/// @desc Gets the packed justification value.
	/// @returns {Real}
	#endregion
	static get_text_justification = function() { return textAlignment; };
	
	#region jsDoc
	/// @func get_text_origin()
	/// @desc Gets the origin enum value (0-8).
	/// @returns {Real}
	#endregion
	static get_text_origin = function() { return textOrigin; };
	
	#region jsDoc
	/// @func get_text_origin_offsets_x()
	/// @desc Gets the origin X offset.
	/// @returns {Real}
	#endregion
	static get_text_origin_offsets_x = function() { return textOriginX; };
	
	#region jsDoc
	/// @func get_text_origin_offsets_y()
	/// @desc Gets the origin Y offset.
	/// @returns {Real}
	#endregion
	static get_text_origin_offsets_y = function() { return textOriginY; };
	
	#region jsDoc
	/// @func get_text_character_spacing()
	/// @desc Gets the character spacing.
	/// @returns {Real}
	#endregion
	static get_text_character_spacing = function() { return textCharacterSpacing; };
	
	#region jsDoc
	/// @func get_text_line_spacing()
	/// @desc Gets the line spacing.
	/// @returns {Real}
	#endregion
	static get_text_line_spacing = function() { return textLineSpacing; };
	
	#region jsDoc
	/// @func get_text_paragraph_spacing()
	/// @desc Gets the paragraph spacing.
	/// @returns {Real}
	#endregion
	static get_text_paragraph_spacing = function() { return textParagraphSpacing; };
	
	#region jsDoc
	/// @func get_text_frame_width()
	/// @desc Gets the frame width.
	/// @returns {Real}
	#endregion
	static get_text_frame_width = function() { return textFrameWidth; };
	
	#region jsDoc
	/// @func get_text_frame_height()
	/// @desc Gets the frame height.
	/// @returns {Real}
	#endregion
	static get_text_frame_height = function() { return textFrameHeight; };
	
	#region jsDoc
	/// @func get_text_wrap()
	/// @desc Gets whether wrapping is enabled.
	/// @returns {Bool}
	#endregion
	static get_text_wrap = function() { return textWrap; };
	
	#region jsDoc
	/// @func get_text_split_words()
	/// @desc Gets the split-words wrap mode value.
	/// @returns {Real}
	#endregion
	static get_text_split_words = function() { return textWrapMode; };
	
	#endregion
	
	
    #region Private
	
	#region Properties
	type = "Text";
    
	textFontIndex    = _font;
	
	textOffsetX = 0;  // "Position - X" Used to position based off the Origin x/y
	textOffsetY = 0;  // "Position - Y" Used to position based off the Origin x/y
	textScaleX = 1;   // "Scale - X"
    textScaleY = 1;   // "Scale - Y"
    textAngle = 0;    // "Rotation"
	textColour = -1;  // "Colour" -1 is used for unset, so it could adopt the current `draw_set_color`
    textText = _text; // "Text"
    
	textAlignment  = 0;       // "Justification"
    textOrigin = 0;           // "Frame Origin" please see `set_alignment`
    textOriginX = 0;          // "Origin Offset - X" Used to offset the rotation
	textOriginY = 0;          // "Origin Offset - Y" Used to offset the rotation
	textCharacterSpacing = 0; // "Character Spacing"
	textLineSpacing = 0;      // "Line Spacing"
	textParagraphSpacing = 0; // "Paragraph Spacing"
	
	textFrameWidth = 0;  // "Frame - W"
	textFrameHeight = 0; // "Frame - H"
	textWrap = false;    // "Wrap"
    textWrapMode = 0.0;  // "Split words"
    
    #endregion
	
	#region jsDoc
	/// @func    to_struct()
	/// @desc    Builds a "Sprite" layerElements struct.
	/// @self    ReflexLayerElementSprite
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		static __base_to_struct = ReflexLeaf.to_struct;
		var _base_struct = __base_to_struct();
		
		//Sprite Specific Data
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
	
	// Seed Native Struct
    rebuild_node(to_struct());
	#endregion
}