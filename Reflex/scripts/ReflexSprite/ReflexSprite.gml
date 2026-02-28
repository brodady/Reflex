#region jsDoc
/// @func ReflexSprite(_sprite, _index)
/// @desc Specialized leaf node for native GameMaker sprite rendering.
/// @param {Asset.GMSprite} _sprite The sprite asset to assign.
/// @param {Real} [_index]=0 The initial subimage index.
/// @return {ReflexSprite}
#endregion
function ReflexSprite(_sprite=-1, _index = 0) : ReflexLeaf() constructor 
{
    #region Properties
    sprite_index    = -1;
    image_index     = 0;
    image_xscale    = 1;
    image_yscale    = 1;
    image_angle     = 0;
    image_blend     = c_white;
    image_speed     = 1;
    maintain_aspect = true;
    #endregion

    #region Native Data Generator
    #region jsDoc
    /// @func __get_layer_element()
    /// @desc Generates the exact native GameMaker layer element struct for this sprite.
    /// @return {Struct}
    #endregion
    static __get_layer_element = function() {
        return {
            elementOrder : 10.0, 
            spriteScaleX : image_xscale, 
            spriteScaleY : image_yscale, 
            spriteColour : (image_blend == c_white) ? -1.0 : image_blend, 
            spriteImageSpeed : image_speed, 
            spriteSpeedType : 0.0, 
            spriteImageIndex : image_index, 
            spriteAngle : image_angle, 
            spriteOffsetX : 0.0, 
            elementId : __uuid, 
            spriteOffsetY : 0.0, 
            spriteIndex : sprite_index, 
            type : "Sprite", 
            flexVisible : 1.0, 
            flexAnchor : "TopLeft", 
            
            flexStretchWidth : maintain_aspect ? 1.0 : 0.0, 
            flexStretchHeight : maintain_aspect ? 1.0 : 0.0, 
            flexTileHorizontal : 0.0, 
            flexTileVertical : 0.0, 
            flexStretchKeepAspect : maintain_aspect ? 1.0 : 0.0 
        };
    };
    #endregion

    #region Setters
    static set_sprite = function(_spr, _ind = 0) {
		if (_spr = -1) { return self; }
		
        sprite_index = _spr;
        image_index  = _ind;
        
        var _info = sprite_get_info(_spr);
        if (_info != undefined) {
            image_speed = (_info.frame_type == spritespeed_framespersecond) 
                ? (_info.frame_speed / game_get_speed(gamespeed_fps)) 
                : _info.frame_speed;
                
            if (maintain_aspect) set_aspect_ratio(_info.width / _info.height);
        }
        
        //skip rebuilding because its not finished initializing yet.
        if (sprite_index = -1) { return self; }
		
		__rebuild_node(__get_layer_element());
        return self;
    };

    static set_scale = function(_x, _y = undefined) {
        image_xscale = _x;
        image_yscale = (_y == undefined) ? _x : _y;
        
		//skip rebuilding because its not finished initializing yet.
        if (sprite_index = -1) { return self; }
		
		__rebuild_node(__get_layer_element());
        return self;
    };

    static set_maintain_aspect = function(_val) {
        maintain_aspect = _val;
        if (_val && sprite_index != -1) {
            var _info = sprite_get_info(sprite_index);
            if (_info != undefined) set_aspect_ratio(_info.width / _info.height);
        } else {
            set_aspect_ratio(0);
        }
		
		//skip rebuilding because its not finished initializing yet.
        if (sprite_index = -1) { return self; }
		
        __rebuild_node(__get_layer_element());
        return self;
    };

    static set_rotation = function(_angle) { 
        image_angle = _angle; 
        
		//skip rebuilding because its not finished initializing yet.
        if (sprite_index = -1) { return self; }
		
		__rebuild_node(__get_layer_element()); 
        return self; 
    };

    static set_color = function(_col) { 
        image_blend = _col; 
        
		//skip rebuilding because its not finished initializing yet.
        if (sprite_index = -1) { return self; }
		
		__rebuild_node(__get_layer_element()); 
        return self; 
    };

    static set_speed = function(_spd) { 
        image_speed = _spd; 
        
		//skip rebuilding because its not finished initializing yet.
        if (sprite_index = -1) { return self; }
		
		__rebuild_node(__get_layer_element()); 
        return self; 
    };
    #endregion

    // Init
    set_sprite(_sprite, _index);
}