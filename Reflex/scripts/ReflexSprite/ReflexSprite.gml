function ReflexSprite(_sprite, _index = 0, _node_handle = 0) : ReflexLeaf(_node_handle) constructor {
    sprite_index = _sprite;
    image_index = _index;
    
    scale_x = 1;
    scale_y = 1;

    static on_measure = function(_w, _w_mode, _h, _h_mode) {
        // Get the base dimensions
        var _sw = sprite_get_width(sprite_index) * scale_x;
        var _sh = sprite_get_height(sprite_index) * scale_y;

        // Mode 1: Exactly 
        if (_w_mode == 1) _sw = _w; 
        // Mode 2: At Most 
        else if (_w_mode == 2) _sw = min(_sw, _w);

        if (_h_mode == 1) _sh = _h;
        else if (_h_mode == 2) _sh = min(_sh, _h);

        return { width: _sw, height: _sh };
    };
    
    static set_sprite = function(_spr, _ind = 0) {
        sprite_index = _spr;
        image_index = _ind;
        
        // Jiggle the style to force Yoga to re-measure the new sprite's size
        flexpanel_node_style_set_width(node_handle, 0, flexpanel_unit.point);
        flexpanel_node_style_set_width(node_handle, 0, flexpanel_unit.auto);
        
        request_reflow();
        return self;
    };
}