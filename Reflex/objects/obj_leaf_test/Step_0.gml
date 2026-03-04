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
anchor_horz = demo_anchor_horz[ demo_anchor_index mod 3 ];
anchor_vert = demo_anchor_vert[ (demo_anchor_index div 3) mod 3 ];

// Shared visible toggle (all together)
demo_leaf_sprite.set_visible(demo_visible_toggle);
demo_leaf_text.set_visible(demo_visible_toggle);
demo_leaf_object.set_visible(demo_visible_toggle);

// Shared tiling toggle (sprites/instances should show this most clearly)
demo_leaf_sprite.set_tiling(demo_tile_toggle, demo_tile_toggle);
demo_leaf_text.set_tiling(demo_tile_toggle, demo_tile_toggle);
demo_leaf_object.set_tiling(demo_tile_toggle, demo_tile_toggle);

// Stretch + keep-aspect demos
// Phase 0: stretch width only (keep aspect true) -> height should follow width
// Phase 1: stretch height only (keep aspect true) -> width should follow height
// Phase 2: stretch both (keep aspect true)
// Phase 3: stretch off (baseline)
stretch_width = false;
stretch_height = false;

switch (demo_phase_index) {
	case 0:
		stretch_width = true;
		stretch_height = false;
		break;
	case 1:
		stretch_width = false;
		stretch_height = true;
		break;
	case 2:
		stretch_width = true;
		stretch_height = true;
		break;
	default:
		stretch_width = false;
		stretch_height = false;
		break;
}

demo_leaf_sprite.set_keep_aspect(true);
demo_leaf_text.set_keep_aspect(true);
demo_leaf_object.set_keep_aspect(true);

demo_leaf_sprite.set_stretch(stretch_width, stretch_height);
demo_leaf_text.set_stretch(stretch_width, stretch_height);
demo_leaf_object.set_stretch(true, false);

// Per-leaf transforms cycling (offset/scale/angle/color)
time_seconds = demo_time_frames / room_speed;

offsx = round(32 * sin(time_seconds * 1.10));
offsy = round(24 * cos(time_seconds * 1.25));

scalx = 1 + 0.25 * sin(time_seconds * 0.90);
scaly = 1 + 0.25 * cos(time_seconds * 0.80);

angl = (demo_time_frames * 0.5) mod 360;

// Color cycling (simple HSV-like using make_color_hsv)
huev = (demo_time_frames * 2) mod 255;
colr = make_color_hsv(huev, 200, 255);

// Sprite leaf
demo_leaf_sprite.set_sprite_offsets(offsx, offsy);
demo_leaf_sprite.set_sprite_scale(scalx, scaly);
demo_leaf_sprite.set_sprite_rotation(angl);
demo_leaf_sprite.set_sprite_color(colr);

// Text leaf
demo_leaf_text.set_text_offsets(offsx, offsy);
demo_leaf_text.set_text_scale(scalx, scaly);
demo_leaf_text.set_text_rotation(angl);
demo_leaf_text.set_text_color(colr);

// Instance leaf
demo_leaf_object.set_instance_offsets(offsx, offsy);
demo_leaf_object.set_instance_scale(scalx, scaly);
demo_leaf_object.set_instance_angle(angl);
demo_leaf_object.set_instance_color(colr);

