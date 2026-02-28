#region jsDoc
/// @desc Demo Step event for Reflex leaf nodes.
///        Cycles shared properties, per-leaf transforms, anchoring, stretch modes, and elementOrder.
///        Also tries to modify instance depth (if instanceId resolves to a real instance).
#endregion

demo_time_frames += 1;

// Phase switching controls stretch demonstrations
if ((demo_time_frames % demo_phase_frames) == 0) {
	demo_phase_index += 1;
	if (demo_phase_index >= 4) {
		demo_phase_index = 0;
	}
}

// Cycle shared toggles periodically
if ((demo_time_frames % demo_cycle_frames) == 0) {
	demo_visible_toggle = !demo_visible_toggle;
	demo_tile_toggle = !demo_tile_toggle;

	demo_anchor_index += 1;
	if (demo_anchor_index >= 9) {
		demo_anchor_index = 0;
	}
}

// Compute anchor (3x3)
var _anchor_horz = demo_anchor_horz[ demo_anchor_index mod 3 ];
var _anchor_vert = demo_anchor_vert[ (demo_anchor_index div 3) mod 3 ];

// Apply anchors to all three leaf nodes (same anchor so issues are obvious)
demo_leaf_sprite.set_anchor(_anchor_horz, _anchor_vert);
demo_leaf_text.set_anchor(_anchor_horz, _anchor_vert);
demo_leaf_object.set_anchor(_anchor_horz, _anchor_vert);

// Shared visible toggle (all together)
demo_leaf_sprite.set_visible(demo_visible_toggle);
demo_leaf_text.set_visible(demo_visible_toggle);
demo_leaf_object.set_visible(demo_visible_toggle);

// Shared tiling toggle (sprites/instances should show this most clearly)
demo_leaf_sprite.set_tiling(demo_tile_toggle, demo_tile_toggle);
demo_leaf_text.set_tiling(false, false);
demo_leaf_object.set_tiling(demo_tile_toggle, demo_tile_toggle);

// Stretch + keep-aspect demos
// Phase 0: stretch width only (keep aspect true) -> height should follow width
// Phase 1: stretch height only (keep aspect true) -> width should follow height
// Phase 2: stretch both (keep aspect true)
// Phase 3: stretch off (baseline)
var _stretch_width = false;
var _stretch_height = false;

switch (demo_phase_index) {
	case 0:
		_stretch_width = true;
		_stretch_height = false;
		break;
	case 1:
		_stretch_width = false;
		_stretch_height = true;
		break;
	case 2:
		_stretch_width = true;
		_stretch_height = true;
		break;
	default:
		_stretch_width = false;
		_stretch_height = false;
		break;
}

demo_leaf_sprite.set_keep_aspect(true);
demo_leaf_text.set_keep_aspect(true);
demo_leaf_object.set_keep_aspect(true);

demo_leaf_sprite.set_stretch(_stretch_width, _stretch_height);
demo_leaf_text.set_stretch(_stretch_width, _stretch_height);
demo_leaf_object.set_stretch(_stretch_width, _stretch_height);

// Per-leaf transforms cycling (offset/scale/angle/color)
var _time_seconds = demo_time_frames / room_speed;

var _offsx = round(32 * sin(_time_seconds * 1.10));
var _offsy = round(24 * cos(_time_seconds * 1.25));

var _scalx = 1 + 0.25 * sin(_time_seconds * 0.90);
var _scaly = 1 + 0.25 * cos(_time_seconds * 0.80);

var _angl = (demo_time_frames * 0.5) mod 360;

// Color cycling (simple HSV-like using make_color_hsv)
var _huev = (demo_time_frames * 2) mod 255;
var _colr = make_color_hsv(_huev, 200, 255);

// Sprite leaf
demo_leaf_sprite.set_sprite_offsets(_offsx, _offsy);
demo_leaf_sprite.set_sprite_scale(_scalx, _scaly);
demo_leaf_sprite.set_sprite_rotation(_angl);
demo_leaf_sprite.set_sprite_color(_colr);

// Sprite anim cycling
var _spr_ind = (demo_time_frames div 15) mod max(1, demo_leaf_sprite.get_sprite_image());
demo_leaf_sprite.set_sprite_image(_spr_ind);
demo_leaf_sprite.set_sprite_speed(1);

// Text leaf
demo_leaf_text.set_text_offsets(_offsx, _offsy);
demo_leaf_text.set_text_scale(_scalx, _scaly);
demo_leaf_text.set_text_rotation(_angl);
demo_leaf_text.set_text_color(_colr);

// Instance leaf
demo_leaf_object.set_instance_offsets(_offsx, _offsy);
demo_leaf_object.set_instance_scale(_scalx, _scaly);
demo_leaf_object.set_instance_angle(_angl);
demo_leaf_object.set_instance_colour(_colr);

// Object anim cycling
demo_leaf_object.set_instance_image_speed(1);
demo_leaf_object.set_instance_image_index((demo_time_frames div 12) mod 8);

// Depth sorting test: cycle elementOrder across the three nodes
// Note: ReflexLeaf does not have a setter for elementOrder, so we mutate and then rebuild via rebuild_node(to_struct()).
var _ordr_base = demo_order_base + demo_order_span * sin(_time_seconds * 0.60);

demo_leaf_sprite.elementOrder = _ordr_base + 0.0;
demo_leaf_text.elementOrder = _ordr_base + 10.0;
demo_leaf_object.elementOrder = _ordr_base + 20.0;

demo_leaf_sprite.rebuild_node(demo_leaf_sprite.to_struct());
demo_leaf_text.rebuild_node(demo_leaf_text.to_struct());
demo_leaf_object.rebuild_node(demo_leaf_object.to_struct());

// Also test instance depth if the instanceId points to a real instance
//var _inst_id = demo_leaf_object.get_instance_id();
//if (_inst_id != undefined && instance_exists(_inst_id)) {
//	_inst_id.depth = -round(_ordr_base * 10);
//}