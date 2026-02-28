#region jsDoc
/// @func ReflexText(_text, _font)
/// @desc Specialized leaf node for native GameMaker text rendering.
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
    color   = c_white;
    sep     = -1;
    xscale  = 1;
    yscale  = 1;
    angle   = 0;
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
    static set_text = function(_str) {
        if (text == _str) return self;
        text = _str;
        __rebuild_node(__get_layer_element());
        return self;
    };

    static set_font = function(_font) { 
        font = _font; 
        __rebuild_node(__get_layer_element()); 
        return self; 
    };

    static set_scale = function(_x, _y = undefined) { 
        xscale = _x; 
        yscale = (_y == undefined) ? _x : _y; 
        __rebuild_node(__get_layer_element()); 
        return self; 
    };

    static set_color = function(_col) { 
        color = _col; 
        __rebuild_node(__get_layer_element()); 
        return self; 
    };
    
    static set_alignment = function(_halign) { 
        halign = _halign; 
        __rebuild_node(__get_layer_element()); 
        return self; 
    };

    static set_rotation = function(_angle) { 
        angle = _angle; 
        __rebuild_node(__get_layer_element()); 
        return self; 
    };
    #endregion

    // Seed Native Struct
    __rebuild_node(__get_layer_element());
}