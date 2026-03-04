//*
// Toggle explorer panel
if (keyboard_check_pressed(vk_space)) {
	var _collapsed = left_split.is_collapsed();
	left_split.set_collapsed(!_collapsed, ReflexSplitContainerCollapseSide.COLLAPSE_A);
}

// Toggle console
if (keyboard_check_pressed(ord("C"))) {
	var _collapsed = center_split.is_collapsed();
	center_split.set_collapsed(!_collapsed, ReflexSplitContainerCollapseSide.COLLAPSE_B);
}

// Toggle properties panel
if (keyboard_check_pressed(ord("P"))) {
	var _collapsed = right_split.is_collapsed();
	right_split.set_collapsed(!_collapsed, ReflexSplitContainerCollapseSide.COLLAPSE_B);
}

// Toggle debug visualization
if (keyboard_check_pressed(ord("D"))) {
	show_debug = !show_debug;
	show_debug_message("Debug view: " + (show_debug ? "ON" : "OFF"));
}

// Reset to defaults
if (keyboard_check_pressed(ord("R"))) {
	left_split.set_split_offset(250);
	right_split.set_split_ratio(0.7);
	center_split.set_split_ratio(0.75);
	left_split.set_collapsed(false);
	center_split.set_collapsed(false);
	right_split.set_dragger_visibility(ReflexSplitContainerDraggerVisibility.DRAGGER_VISIBLE);
	show_debug_message("Reset to defaults");
}