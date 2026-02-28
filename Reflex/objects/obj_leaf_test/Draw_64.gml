#region jsDoc
/// @desc Demo Draw event.
///        Draws simple debug text so you can see current phase/anchor and confirm cycling is active.
///        Leaf nodes render through the UI layer system, not this draw call.
#endregion

draw_set_font(demo_debug_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _anchor_horz = demo_anchor_horz[ demo_anchor_index mod 3 ];
var _anchor_vert = demo_anchor_vert[ (demo_anchor_index div 3) mod 3 ];

var _anchr_name = "";
switch (_anchor_vert) {
	case fa_top: _anchr_name = "Top"; break;
	case fa_middle: _anchr_name = "Middle"; break;
	case fa_bottom: _anchr_name = "Bottom"; break;
}
switch (_anchor_horz) {
	case fa_left: _anchr_name += "Left"; break;
	case fa_center: _anchr_name += "Centre"; break;
	case fa_right: _anchr_name += "Right"; break;
}

var _phas_name = "";
switch (demo_phase_index) {
	case 0: _phas_name = "Stretch: Width only (keep aspect)"; break;
	case 1: _phas_name = "Stretch: Height only (keep aspect)"; break;
	case 2: _phas_name = "Stretch: Both (keep aspect)"; break;
	default: _phas_name = "Stretch: Off"; break;
}

draw_set_color(c_white);

draw_text(16, 16, "Reflex Leaf Demo");
draw_text(16, 36, _phas_name);
draw_text(16, 56, "Anchor: " + _anchr_name);
draw_text(16, 76, "Visible toggle: " + string(demo_visible_toggle));
draw_text(16, 96, "Tile toggle: " + string(demo_tile_toggle));

draw_text(16, 116, "Depth test: elementOrder is cycling (sprite,text,instance offset by +0,+10,+20).");
draw_text(16, 136, "Also sets instance.depth when instanceId exists (to detect UI layer behavior).");

// --- DEBUG OVERLAY ---
//ui_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));