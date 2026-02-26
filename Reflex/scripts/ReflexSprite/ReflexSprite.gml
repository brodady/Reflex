function ReflexSprite(_sprite, _index = 0) : ReflexLeaf() constructor {
	
	set_sprite(_sprite, _index);
	
    static on_measure = function(_w, _w_mode, _h, _h_mode) {
		//prevent producing unneeded extra garbage
		// NOTE: This /might/ break how flex panels work internally,
		//   if it does we can go back to producing a bunch of garbage
		//   for the collector to handle.
		static __struct= {};
		
        // Get the base dimensions
		// This doubles as Mode 0: Undefined
        var _sw = sprite_get_width(sprite_index)  * image_xscale;
        var _sh = sprite_get_height(sprite_index) * image_yscale;
		
		// These amgic numbers are actually what the documentation suggests, there is no enum for these in gml
		// https://manual.gamemaker.io/beta/en/GameMaker_Language/GML_Reference/Flex_Panels/Function_Reference/flexpanel_node_set_measure_function.htm
		
        // Mode 1: Exactly
        if (_w_mode == 1) _sw = _w;
        // Mode 2: At Most
        else if (_w_mode == 2) _sw = min(_sw, _w);
		
		// Mode 1: Exactly
        if (_h_mode == 1) _sh = _h;
		// Mode 2: At Most
        else if (_h_mode == 2) _sh = min(_sh, _h);
		
		__struct.width  = _sw;
		__struct.height = _sh;
		return __struct;
    };
    
    static set_sprite = function(_spr, _ind = 0) {
        // Params
		sprite_index = _spr;
	    image_index = _ind;
    
		// Defaults
		image_alpha = 1;
		image_angle = 0;
		image_blend = c_white;
		image_xscale = 1;
		image_yscale = 1;
    
		// Data
		var _info = sprite_get_info(_spr);
		sprite_index   = _spr;
		sprite_height  = _info.height;
		sprite_width   = _info.width;
		sprite_xoffset = _info.xoffset;
		sprite_yoffset = _info.yoffset;
				
		image_number = _info.num_subimages;
		image_speed = (_info.frame_type == spritespeed_framespersecond) ? (_info.frame_speed / game_get_speed(gamespeed_fps)) : _info.frame_speed;
		anim_start_timer = get_timer();
		anim_start_index = image_index;
		
        request_reflow();
        return self;
    };
	
	static draw_this = function() {
		// If single frame or no speed, just draw current frame
		if (image_number <= 1 || image_speed == 0) {
			draw_sprite_ext(
				sprite_index,
				image_index,
				x - sprite_xoffset * image_xscale,
				y - sprite_yoffset * image_yscale,
				image_xscale,
				image_yscale,
				image_angle,
				image_blend,
				image_alpha
			);
			return;
		}

		// Time-based frame selection
		var _elapsed_usec = get_timer() - anim_start_timer;
		var _elapsed_sec = _elapsed_usec / 1000000.0;

		var _frame_float = _elapsed_sec * image_speed;
		var _frame_index = floor(_frame_float);

		// Wrap within [0, image_number)
		var _subimage = (anim_start_index + _frame_index) mod image_number;

		draw_sprite_ext(
			sprite_index,
			_subimage,
			x - sprite_xoffset * image_xscale,
			y - sprite_yoffset * image_yscale,
			image_xscale,
			image_yscale,
			image_angle,
			image_blend,
			image_alpha
		);
	};
	
}

