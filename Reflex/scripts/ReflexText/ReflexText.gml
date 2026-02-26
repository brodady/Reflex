function ReflexText(_text = "", _font = -1, _node_handle = 0) : ReflexLeaf(_node_handle) constructor {
    text = _text;
    font = _font;

    static on_measure = function(_w, _w_mode, _h, _h_mode) {
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
    
        return { width: _tw, height: _th };
    }

    #region jsDoc
    /// @desc Updates the text and forces a Yoga re-measurement.
    #endregion
    static set_text = function(_str) {
        if (text == _str) return self;
        text = _str;
    
        flexpanel_node_style_set_width(node_handle, 0, flexpanel_unit.point); 
        flexpanel_node_style_set_width(node_handle, 0, flexpanel_unit.auto);
    
        request_reflow();
        return self;
    };
}