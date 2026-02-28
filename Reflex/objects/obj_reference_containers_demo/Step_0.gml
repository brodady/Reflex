// 1: toggle CenterContainer mode
if (keyboard_check_pressed(ord("1"))) {
	demo_center_top_left = !demo_center_top_left;
	center_wrap.set_use_top_left(demo_center_top_left);
}

// 2: cycle inner inset (PaddingContainer -> padding)
if (keyboard_check_pressed(ord("2"))) {
	demo_padding_index += 1;
	if (demo_padding_index >= array_length(demo_padding_list)) demo_padding_index = 0;

	var _pad = demo_padding_list[demo_padding_index];
	padding_box.set_padding_all(_pad);
}

// 3: cycle outer spacing (MarginContainer -> margin)
if (keyboard_check_pressed(ord("3"))) {
	demo_margin_index += 1;
	if (demo_margin_index >= array_length(demo_margin_list)) demo_margin_index = 0;

	var _mar = demo_margin_list[demo_margin_index];
	margin_box.set_margin_all(_mar);
}

// 4: cycle aspect stretch_mode
if (keyboard_check_pressed(ord("4"))) {
	demo_stretch_mode += 1;
	if (demo_stretch_mode > 3) demo_stretch_mode = 0;

	aspect_wrap.set_stretch_mode(demo_stretch_mode);
}

// 5: cycle aspect horizontal alignment
if (keyboard_check_pressed(ord("5"))) {
	demo_align_h += 1;
	if (demo_align_h > 2) demo_align_h = 0;

	aspect_wrap.set_alignment_horizontal(demo_align_h);
}

// 6: cycle aspect vertical alignment
if (keyboard_check_pressed(ord("6"))) {
	demo_align_v += 1;
	if (demo_align_v > 2) demo_align_v = 0;

	aspect_wrap.set_alignment_vertical(demo_align_v);
}

// Important: AspectRatioContainer needs a sync after layout is available.
// Calling it every step is fine for the demo.
aspect_wrap.sync_layout();