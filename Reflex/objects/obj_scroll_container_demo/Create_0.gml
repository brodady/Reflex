ui_root = new ReflexUI();
ui_root.add_to("ReflexLayer");
ui_root.set_flex_direction(flexpanel_flex_direction.column);
ui_root.set_width("100%");
ui_root.set_height("100%");
ui_root.set_gap(flexpanel_gutter.all_gutters, 0);

scroll = new ReflexScrollContainer();
scroll.set_flex_grow(1);
ui_root.add(scroll);

// Optional: make bars thicker so you can see them easier
scroll.set_scrollbar_size(16);

// Add content into the container's content node
content_root = scroll.get_content();

sprite_a = new ReflexLeafSprite(spr_test, 0);
sprite_a.set_anchor(fa_left, fa_top);
sprite_a.set_stretch(false, false);
sprite_a.set_keep_aspect(false);
sprite_a.set_tiling(false, false);
content_root.add(sprite_a);

// Add a second sprite as a visual reference point (lower-right)
sprite_b = new ReflexLeafSprite(spr_test, 0);
sprite_b.set_anchor(fa_left, fa_top);
sprite_b.set_sprite_offsets(900, 650);
sprite_b.set_stretch(false, false);
sprite_b.set_keep_aspect(false);
sprite_b.set_tiling(false, false);
content_root.add(sprite_b);

// IMPORTANT: intentionally do NOT set content size yet
// This is the "try it out and see the problems" part.
scroll.set_content_size(1200, 900);

size_set = false;
content_w = 1200;
content_h = 900;

gui_w_last = -1;
gui_h_last = -1;