show_debug_overlay(true);
//call_later(1, time_source_units_seconds, function(){
root = new Reflex();
root.set_max_width(400);
root.set_max_height(200);
root.add_to("ReflexLayer");

demo_sprite_asset = spr_test; // replace
demo_font_asset = fnt_lbl; // replace
demo_object_asset = obj_demo; // replace

// Create leaf nodes
demo_leaf_sprite = new ReflexLeafSprite(demo_sprite_asset, 0);
demo_leaf_text = new ReflexLeafText("Reflex Demo", demo_font_asset);
demo_leaf_object = new ReflexLeafObject(demo_object_asset);

// Add them to the root in a known order
root.add(demo_leaf_sprite);
root.add(demo_leaf_text);
root.add(demo_leaf_object);

// Initial shared state
demo_leaf_sprite.set_visible(true);
demo_leaf_text.set_visible(true);
demo_leaf_object.set_visible(true);

demo_leaf_sprite.set_keep_aspect(true);
demo_leaf_text.set_keep_aspect(true);
demo_leaf_object.set_keep_aspect(true);

demo_leaf_sprite.set_stretch(false, true);
demo_leaf_text.set_stretch(false, true);
demo_leaf_object.set_stretch(false, true);

demo_leaf_sprite.set_tiling(true, true);
demo_leaf_text.set_tiling(true, true);
demo_leaf_object.set_tiling(true, true);

demo_leaf_sprite.set_anchor(fa_left, fa_top);
demo_leaf_text.set_anchor(fa_center, fa_middle);
demo_leaf_object.set_anchor(fa_right, fa_bottom);

// Initial per-leaf state
demo_leaf_sprite.set_sprite_offsets(0, 0);
demo_leaf_sprite.set_sprite_scale(1, 1);
demo_leaf_sprite.set_sprite_rotation(0);
demo_leaf_sprite.set_sprite_color(c_white);
demo_leaf_sprite.set_sprite_image(0);
demo_leaf_sprite.set_sprite_speed(1);

demo_leaf_text.set_text_offsets(0, 0);
demo_leaf_text.set_text_scale(1, 1);
demo_leaf_text.set_text_rotation(0);
demo_leaf_text.set_text_color(c_white);

demo_leaf_object.set_instance_offsets(0, 0);
demo_leaf_object.set_instance_scale(1, 1);
demo_leaf_object.set_instance_angle(0);
demo_leaf_object.set_instance_color(c_white);
demo_leaf_object.set_instance_image_index(0);
demo_leaf_object.set_instance_image_speed(1);

// Demo control
demo_time_frames = 0;
demo_phase_index = 0;
demo_phase_frames = 240; // frames per phase
demo_cycle_frames = 30; // property cycle step

// Anchor cycling (3x3)
demo_anchor_horz = [ fa_left, fa_center, fa_right ];
demo_anchor_vert = [ fa_top, fa_middle, fa_bottom ];
demo_anchor_index = 0;

// Shared toggles cycling
demo_visible_toggle = true;
demo_tile_toggle = false;

// Depth sorting test
demo_order_base = 0.0;
demo_order_span = 30.0;

// For debug text
demo_debug_font = demo_font_asset;

_time = 0;
_amp = 300;

//}, false)