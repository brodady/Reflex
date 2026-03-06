draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Helper: draw a filled panel behind a page area using that page's layout rect
// (No closures; just repeated blocks.)

var _demo_index = demo_tabs.get_current_tab();

// Title + controls
draw_set_color(c_white);
draw_text(12, 10, "Reflex TabContainer Demo (single window, feature pages)");
draw_text(12, 30, "Top-level tabs switch test areas. Drag tabs to reorder/transfer where applicable.");
draw_text(12, 50, "Global: [D] toggle debug overlay");

// Per-page instructions
if (_demo_index == 0) {
	draw_text(12, 80,
		"Basics:\n" +
		"  [1-6] select inner tab\n" +
		"  [Q] toggle deselect_enabled\n" +
		"  [X] close current inner tab\n"
	);
}
else if (_demo_index == 1) {
	draw_text(12, 80,
		"Overflow + Close Freeze:\n" +
		"  [R] toggle resize_tabs_enabled\n" +
		"  [F] toggle freeze_resize_after_close\n" +
		"  [X] close current tab (try rapid close while pointer stays over bar)\n" +
		"  Also test horizontal scroll when tabs exceed space.\n"
	);
}
else if (_demo_index == 2) {
	draw_text(12, 80,
		"Reorder:\n" +
		"  Drag tabs to reorder within the same container.\n" +
		"  [X] close current tab\n"
	);
}
else if (_demo_index == 3) {
	draw_text(12, 80,
		"Transfer:\n" +
		"  Drag tabs between left and right containers (when group enabled).\n" +
		"  [G] toggle group gating on/off\n" +
		"  [Z] close current left tab\n" +
		"  [C] close current right tab\n"
	);
}

// Draw colored content block for the currently selected nested page in each test
// Basics content
if (_demo_index == 0) {
	var _idx = basic_tabs.get_current_tab();
	if (_idx >= 0 && _idx < array_length(basic_pages)) {
		var _rect = basic_pages[_idx].get_layout_position();
		draw_set_alpha(0.25);
		draw_set_color(basic_colors[min(_idx, array_length(basic_colors) - 1)]);
		draw_rectangle(_rect.left, _rect.top, _rect.left + _rect.width, _rect.top + _rect.height, false);
		draw_set_alpha(1.0);
		draw_set_color(c_white);
		draw_text(_rect.left + 10, _rect.top + 10, "Basics Page Content: Tab " + string(_idx + 1));
	}
}

// Overflow content
if (_demo_index == 1) {
	var _idx = overflow_tabs.get_current_tab();
	if (_idx >= 0 && _idx < array_length(overflow_pages)) {
		var _rect = overflow_pages[_idx].get_layout_position();
		draw_set_alpha(0.20);
		draw_set_color(c_dkgray);
		draw_rectangle(_rect.left, _rect.top, _rect.left + _rect.width, _rect.top + _rect.height, false);
		draw_set_alpha(1.0);
		draw_set_color(c_white);
		draw_text(_rect.left + 10, _rect.top + 10,
			"Overflow Page: " + string(_idx + 1) + "\n"
		);
	}
}

// Reorder content
if (_demo_index == 2) {
	var _idx = reorder_tabs.get_current_tab();
	if (_idx >= 0 && _idx < array_length(reorder_pages)) {
		var _rect = reorder_pages[_idx].get_layout_position();
		draw_set_alpha(0.22);
		draw_set_color(reorder_colors[min(_idx, array_length(reorder_colors) - 1)]);
		draw_rectangle(_rect.left, _rect.top, _rect.left + _rect.width, _rect.left + _rect.width, false);
		draw_set_alpha(0.22);
		draw_rectangle(_rect.left, _rect.top, _rect.left + _rect.width, _rect.top + _rect.height, false);
		draw_set_alpha(1.0);
		draw_set_color(c_white);
		draw_text(_rect.left + 10, _rect.top + 10, "Reorder Page: " + string(_idx + 1) + " (drag tabs)");
	}
}

// Transfer content blocks (left and right)
if (_demo_index == 3) {
	var _idx_l = transfer_left.get_current_tab();
	if (_idx_l >= 0 && _idx_l < array_length(transfer_left_pages)) {
		var _rect = transfer_left_pages[_idx_l].get_layout_position();
		draw_set_alpha(0.22);
		draw_set_color(c_blue);
		draw_rectangle(_rect.left, _rect.top, _rect.left + _rect.width, _rect.top + _rect.height, false);
		draw_set_alpha(1.0);
		draw_set_color(c_white);
		draw_text(_rect.left + 10, _rect.top + 10, "Left: " + string(_idx_l + 1));
	}

	var _idx_r = transfer_right.get_current_tab();
	if (_idx_r >= 0 && _idx_r < array_length(transfer_right_pages)) {
		var _rect = transfer_right_pages[_idx_r].get_layout_position();
		draw_set_alpha(0.22);
		draw_set_color(c_orange);
		draw_rectangle(_rect.left, _rect.top, _rect.left + _rect.width, _rect.top + _rect.height, false);
		draw_set_alpha(1.0);
		draw_set_color(c_white);
		draw_text(_rect.left + 10, _rect.top + 10, "Right: " + string(_idx_r + 1));
	}

	draw_set_color(c_white);
	draw_text(12, 170,
		"Transfer group enabled: " + string(transfer_group_enabled) + "\n" +
		"Left group: " + string(transfer_left.get_tabs_rearrange_group()) + "\n" +
		"Right group: " + string(transfer_right.get_tabs_rearrange_group())
	);
}

// Debug overlay
if (show_debug) {
	demo_tabs.draw_debug(0, -1, true, true, true);
}