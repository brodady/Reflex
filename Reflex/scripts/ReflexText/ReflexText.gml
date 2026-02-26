function ReflexText(_text = "", _font = -1) : ReflexLeaf() constructor {
    
	text = _text;
    font = _font;
	halign = fa_left;
	valign = fa_top;
	color = c_white;
	sep = 2; // if i remember correctly this is the default seperation size, but unsure from memory, once confirmed please remove this
	xscale = 1;
	yscale = 1;
	angle = 0;
	alpha = 1;
	
    static on_measure = function(_w, _w_mode, _h, _h_mode) {
        static __struct = {};
		
		if (font != -1) draw_set_font(font);
        
        var _tw = string_width(text);
        var _th = string_height(text);
    
        // Mode 2: "At Most" 
        if (_w_mode == 2) {
            if (_tw > _w) {
                _tw = _w; // Clamp to parent width
                _th = string_height_ext(text, -1, _w); // Calculate wrapped height
            }
        }
        
        // Mode 1: "Exactly"
        if (_w_mode == 1) {
            _tw = _w;
            _th = string_height_ext(text, -1, _w);
        }
		
		__struct.width = _tw;
		__struct.height = _th;
        return __struct;
    }

    #region jsDoc
    /// @desc Updates the text and forces a Yoga re-measurement.
    #endregion
    static set_text = function(_str) {
        if (text == _str) return self;
        text = _str;
		
        request_reflow();
        return self;
    };
	
	static draw_this = function() {
		//cache
		var _pre_font = draw_get_font();
		var _pre_halign = draw_get_halign();
		var _pre_valign = draw_get_valign();
		//set
		draw_set_font(font);
		draw_set_halign(halign);
		draw_set_valign(valign);
		//draw
		draw_text_ext_transformed_colour(
			x,
			y,
			text,
			sep,
			width,
			xscale,
			yscale,
			angle,
			color,
			color,
			color,
			color,
			alpha
		)
		//reset
		draw_set_font(_pre_font);
		draw_set_halign(_pre_halign);
		draw_set_valign(_pre_valign);
	};
}