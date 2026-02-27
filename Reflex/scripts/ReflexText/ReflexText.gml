#region jsDoc
/// @func ReflexText(_text, _font)
/// @desc Specialized leaf node for text rendering. Native layerElement compatible.
/// @param {String} [_text]="" The initial text string.
/// @param {Asset.GMFont} [_font]=-1 The font asset to use.
/// @return {ReflexText}
#endregion
function ReflexText(_text = "", _font = -1) : ReflexLeaf() constructor 
{
    #region Properties
    text    = _text;
    font    = _font;
    halign  = fa_left;
    valign  = fa_top;
    color   = c_white;
    sep     = -1;
    xscale  = 1;
    yscale  = 1;
    angle   = 0;
    alpha   = 1;
    #endregion

    #region Native Data Generator
    #region jsDoc
    /// @func __get_layer_element()
    /// @desc Generates the exact native GameMaker layer element struct for this text.
    /// @return {Struct}
    #endregion
    static __get_layer_element = function() {
        return {
            textFontIndex: font, 
            textOffsetX: 0.0,
            textOffsetY: 0.0,
            textScaleX: xscale,
            textScaleY: yscale,
            textAngle: angle,
            textColour: (color == c_white) ? -1.0 : color,
            textOriginX: 0.0,
            textOriginY: 0.0,
            textOrigin: 0.0,
            textText: string(text),
            textAlignment: halign,
            textCharacterSpacing: 0.0,
            textLineSpacing: (sep == -1) ? 0.0 : sep,
            textParagraphSpacing: 0.0,
            textFrameWidth: 0.0,
            textFrameHeight: 0.0,
            textWrap: false, 
            textWrapMode: 0.0,
            elementOrder: 10.0,
            elementId: __uuid,
            type: "Text",
            flexVisible: true,
            flexAnchor: "TopLeft",
            flexStretchWidth: false,
            flexStretchHeight: false,
            flexTileHorizontal: false,
            flexTileVertical: false,
            flexStretchKeepAspect: false
        };
    };
    #endregion

    #region Setters
    #region jsDoc
    /// @func set_text(_str)
    /// @desc Updates the text content and forces a layout reflow.
    /// @param {String} _str The new text string.
    /// @return {ReflexText}
    #endregion
    static set_text = function(_str) {
        if (text == _str) return self;
        text = _str;
        __rebuild_node(__get_layer_element());
        return self;
    };

    #region jsDoc
    /// @func set_font(_font)
    /// @desc Sets the font asset and triggers a layout reflow.
    /// @param {Asset.GMFont} _font The font to assign.
    /// @return {ReflexText}
    #endregion
    static set_font = function(_font) { 
        font = _font; 
        __rebuild_node(__get_layer_element()); 
        return self; 
    };

    #region jsDoc
    /// @func set_scale(_x, _y)
    /// @desc Sets the text drawing scale and triggers a layout reflow.
    /// @param {Real} _x The horizontal scale.
    /// @param {Real} [_y] The vertical scale.
    /// @return {ReflexText}
    #endregion
    static set_scale = function(_x, _y = undefined) { 
        xscale = _x; 
        yscale = (_y == undefined) ? _x : _y; 
        __rebuild_node(__get_layer_element()); 
        return self; 
    };

    #region jsDoc
    /// @func set_color(_col)
    /// @desc Sets the text draw color.
    /// @param {Constant.Color} _col The color to assign.
    /// @return {ReflexText}
    #endregion
    static set_color = function(_col) { 
        color = _col; 
        __rebuild_node(__get_layer_element()); 
        return self; 
    };
    
    #region jsDoc
    /// @func set_alignment(_halign, _valign)
    /// @desc Sets text alignment constants.
    /// @param {Constant.HAlign} _halign Horizontal alignment.
    /// @param {Constant.VAlign} _valign Vertical alignment.
    /// @return {ReflexText}
    #endregion
    static set_alignment = function(_halign, _valign) { 
        halign = _halign; 
        valign = _valign; 
        return self; 
    };

    #region jsDoc
    /// @func set_alpha(_alpha)
    /// @desc Sets the text transparency.
    /// @param {Real} _alpha Alpha value (0.0 to 1.0).
    /// @return {ReflexText}
    #endregion
    static set_alpha = function(_alpha) { 
        alpha = _alpha; 
        return self; 
    };

    #region jsDoc
    /// @func set_rotation(_angle)
    /// @desc Sets the text draw angle.
    /// @param {Real} _angle Angle in degrees.
    /// @return {ReflexText}
    #endregion
    static set_rotation = function(_angle) { 
        angle = _angle; 
        return self; 
    };
    #endregion

    #region Rendering
    #region jsDoc
    /// @func draw_this()
    /// @desc Renders the text using flex-calculated positions and state properties.
    #endregion
    static draw_this = function() {
        var _pre_font = draw_get_font();
        var _pre_halign = draw_get_halign();
        var _pre_valign = draw_get_valign();
        
        draw_set_font(font); 
        draw_set_halign(halign); 
        draw_set_valign(valign);
        
        var _dx = x, _dy = y;
        if (halign == fa_center) _dx += width / 2;
        else if (halign == fa_right) _dx += width;
        if (valign == fa_middle) _dy += height / 2;
        else if (valign == fa_bottom) _dy += height;

        var _nat_w = string_width(text) * xscale;
        var _wrap_w = (width >= _nat_w - 0.5) ? -1 : (width / xscale);

        draw_text_ext_transformed_colour( 
            _dx, _dy, text, sep, _wrap_w, xscale, yscale, angle, 
            color, color, color, color, alpha
        );
        
        draw_set_font(_pre_font); 
        draw_set_halign(_pre_halign); 
        draw_set_valign(_pre_valign);
    };
    #endregion
    
    // Seed Native Struct
    __rebuild_node(__get_layer_element());
}