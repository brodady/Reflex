/// @desc reflex_draw_debug(_node, _show_children)
function reflex_draw_debug(_node, _show_children = true) {
    if (_node == undefined) return;
        
    draw_set_color(c_lime);
    draw_rectangle(_node.x, _node.y, _node.x + _node.w - 1, _node.y + _node.h - 1, true);
    
    draw_set_font(fnt_lbl); 
    draw_set_color(c_white);
    var _name = _node.get_name() ?? "unnamed";
    draw_text(_node.x + 2, _node.y + 2, _name);

    if (_show_children) {
        var _count = array_length(_node.__children);
        for (var i = 0; i < _count; i++) {
            reflex_draw_debug(_node.__children[i], true);
        }
    }
}