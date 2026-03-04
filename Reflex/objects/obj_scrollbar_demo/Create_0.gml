ui_root = new ReflexUI();
ui_root.add_to("ReflexLayer");

// Root layout: column (content row on top, hbar on bottom)
ui_root.set_flex_direction(flexpanel_flex_direction.column);
ui_root.set_width("100%");
ui_root.set_height("100%");
ui_root.set_gap(flexpanel_gutter.all_gutters, 0);

// Top row: viewport + vbar
ui_row_top = new ReflexUI();
ui_row_top.set_flex_direction(flexpanel_flex_direction.row);
ui_row_top.set_flex_grow(1);
ui_row_top.set_gap(flexpanel_gutter.all_gutters, 0);
ui_root.add(ui_row_top);

// Viewport container (must grow to take remaining width)
ui_viewport = new ReflexUI();
ui_viewport.set_flex_direction(flexpanel_flex_direction.row);
ui_viewport.set_flex_grow(1);
ui_row_top.add(ui_viewport);

// Vertical scrollbar (fixed width)
vbar = new ReflexVScrollBar();
vbar.set_width(16);
vbar.set_min(0);
vbar.set_step(1);
vbar.set_value_no_signal(0);
ui_row_top.add(vbar);

// Horizontal scrollbar (fixed height)
hbar = new ReflexHScrollBar();
hbar.set_height(16);
hbar.set_min(0);
hbar.set_step(1);
hbar.set_value_no_signal(0);
ui_root.add(hbar);

// Demo content
content = new ReflexLeafSprite(spr_test, 0);
content.set_anchor(fa_left, fa_top);
content.set_stretch(false, false);
content.set_keep_aspect(false);
content.set_tiling(false, false);
ui_viewport.add(content);

// Content "world" size (bigger than viewport)
content_width = 1200;
content_height = 900;

scroll_x_last = -999999;
scroll_y_last = -999999;

view_w_last = -999999;
view_h_last = -999999;