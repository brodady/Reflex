#region jsDoc
/// @func ReflexSprite(_sprite, _index)
/// @desc Specialized leaf node for sprites. Native layerElement compatible.
/// @param {Asset.GMSprite} _sprite The sprite asset to assign.
/// @param {Real} [_index]=0 The initial subimage index.
/// @return {Struct.ReflexSprite}
#endregion
function ReflexSprite(_sprite, _index = 0) : ReflexLeaf() constructor 
{
    #region Properties
    image_xscale    = 1;
    image_yscale    = 1;
    image_alpha     = 1;
    image_angle     = 0;
    image_blend     = c_white;
    image_speed     = 1;
    
    maintain_aspect = true;
    anchor_x = 0; 
    anchor_y = 0;
    #endregion

    #region Native Data Generator
    #region jsDoc
    /// @func __get_layer_element()
    /// @desc Generates the exact native GameMaker layer element struct for this sprite.
    /// @return {Struct}
    #endregion
    static __get_layer_element = function() {
        return {
            elementOrder : 10, 
            spriteScaleX : image_xscale, 
            spriteScaleY : image_yscale, 
            spriteColour : (image_blend == c_white) ? -1 : image_blend, 
            spriteImageSpeed : image_speed, 
            spriteSpeedType : 0, 
            spriteImageIndex : image_index, 
            spriteAngle : image_angle, 
            spriteOffsetX : 0, 
            elementId : __uuid, 
            spriteOffsetY : 0, 
            spriteIndex : sprite_index, 
            type : "Sprite", 
            flexVisible : 1, 
            flexAnchor : "TopLeft", 
            
            flexStretchWidth : 0, 
            flexStretchHeight : 0, 
            flexTileHorizontal : 0, 
            flexTileVertical : 0, 
            flexStretchKeepAspect : maintain_aspect ? 1 : 0
        };
    };
    #endregion

    #region Setters
    #region jsDoc
    /// @func set_sprite(_spr, _ind)
    /// @desc Updates the sprite asset, recalculates internal dimensions/speed, and triggers a layout reflow.
    /// @param {Asset.GMSprite} _spr The sprite asset to use.
    /// @param {Real} [_ind]=0 The subimage index.
    /// @return {Struct.ReflexSprite}
    #endregion
    static set_sprite = function(_spr, _ind = 0) {
        sprite_index = _spr;
        image_index  = _ind;
        
        var _info = sprite_get_info(_spr);
        sprite_height  = _info.height;
        sprite_width   = _info.width;
        sprite_xoffset = _info.xoffset;
        sprite_yoffset = _info.yoffset;
        image_number   = _info.num_subimages;
        
        image_speed = (_info.frame_type == spritespeed_framespersecond) 
            ? (_info.frame_speed / game_get_speed(gamespeed_fps)) 
            : _info.frame_speed;
            
        anim_start_timer = get_timer();
        anim_start_index = image_index;
        
        if (maintain_aspect) set_aspect_ratio(sprite_width / sprite_height);
        
        __rebuild_node(__get_layer_element());
        return self;
    };

    #region jsDoc
    /// @func set_scale(_x, _y)
    /// @desc Sets the sprite scale and triggers a layout reflow.
    /// @param {Real} _x The horizontal scale.
    /// @param {Real} [_y] The vertical scale (defaults to _x).
    /// @return {Struct.ReflexSprite}
    #endregion
    static set_scale = function(_x, _y = undefined) {
        image_xscale = _x;
        image_yscale = (_y == undefined) ? _x : _y;
        __rebuild_node(__get_layer_element());
        return self;
    };

    #region jsDoc
    /// @func set_maintain_aspect(_val)
    /// @desc Toggles whether the node should force the aspect ratio of the assigned sprite.
    /// @param {Bool} _val Whether to maintain aspect ratio.
    /// @return {Struct.ReflexSprite}
    #endregion
    static set_maintain_aspect = function(_val) {
        maintain_aspect = _val;
        if (_val && sprite_index != -1) set_aspect_ratio(sprite_width / sprite_height);
        else set_aspect_ratio(0);
        __rebuild_node(__get_layer_element());
        return self;
    };

    #region jsDoc
    /// @func set_rotation(_angle)
    /// @desc Sets the sprite drawing angle.
    /// @param {Real} _angle Angle in degrees.
    /// @return {Struct.ReflexSprite}
    #endregion
    static set_rotation = function(_angle) { image_angle = _angle; return self; };

    #region jsDoc
    /// @func set_color(_col)
    /// @desc Sets the sprite blend color.
    /// @param {Constant.Color} _col The color to assign.
    /// @return {Struct.ReflexSprite}
    #endregion
    static set_color    = function(_col)   { image_blend = _col; return self; };

    #region jsDoc
    /// @func set_alpha(_alpha)
    /// @desc Sets the sprite transparency.
    /// @param {Real} _alpha Alpha value (0.0 to 1.0).
    /// @return {Struct.ReflexSprite}
    #endregion
    static set_alpha    = function(_alpha) { image_alpha = _alpha; return self; };

    #region jsDoc
    /// @func set_speed(_spd)
    /// @desc Sets the animation speed (FPS).
    /// @param {Real} _spd The speed value.
    /// @return {Struct.ReflexSprite}
    #endregion
    static set_speed    = function(_spd)   { image_speed = _spd; return self; };

    #region jsDoc
    /// @func set_anchor(_ax, _ay)
    /// @desc Sets the draw anchor point within the flex node bounds.
    /// @param {Real} _ax Horizontal anchor.
    /// @param {Real} _ay Vertical anchor.
    /// @return {Struct.ReflexSprite}
    #endregion
    static set_anchor   = function(_ax, _ay) { anchor_x = _ax; anchor_y = _ay; return self; };
    #endregion

    #region Rendering
    #region jsDoc
    /// @func draw_this()
    /// @desc Renders the sprite using manual animation timing and flex-calculated positions.
    #endregion
    static draw_this = function() {
        if (sprite_index == -1) return;

        var _sub = image_index;
        if (image_number > 1 && image_speed != 0) {
            var _elapsed = (get_timer() - anim_start_timer) / 1000000.0;
            _sub = (anim_start_index + floor(_elapsed * image_speed)) mod image_number;
        }

        var _draw_x = x + (width * anchor_x);
        var _draw_y = y + (height * anchor_y);
        var _ox = sprite_xoffset * image_xscale;
        var _oy = sprite_yoffset * image_yscale;

        draw_sprite_ext(
            sprite_index, _sub, 
            _draw_x - _ox + ( (sprite_width * image_xscale) * -anchor_x ), 
            _draw_y - _oy + ( (sprite_height * image_yscale) * -anchor_y ), 
            image_xscale, image_yscale, image_angle, image_blend, image_alpha
        );
    };
    #endregion

    // Init
    sprite_index = -1; 
    set_sprite(_sprite, _index);
}