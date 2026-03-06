// Global debug overlay toggle
if (keyboard_check_pressed(ord("D"))) {
	show_debug = !show_debug;
}

// Route per-page controls based on selected top-level demo tab
var _demo_index = demo_tabs.get_current_tab();

// Basics page controls
if (_demo_index == 0) {
	// 1-6 select nested basic tab
	if (keyboard_check_pressed(ord("1"))) { basic_tabs.set_current_tab(0); }
	if (keyboard_check_pressed(ord("2"))) { basic_tabs.set_current_tab(1); }
	if (keyboard_check_pressed(ord("3"))) { basic_tabs.set_current_tab(2); }
	if (keyboard_check_pressed(ord("4"))) { basic_tabs.set_current_tab(3); }
	if (keyboard_check_pressed(ord("5"))) { basic_tabs.set_current_tab(4); }
	if (keyboard_check_pressed(ord("6"))) { basic_tabs.set_current_tab(5); }

	// Toggle deselect
	if (keyboard_check_pressed(ord("Q"))) {
		var _enabled = basic_tabs.__deselect_enabled;
		basic_tabs.set_deselect_enabled(!_enabled);
	}

	// Close current tab
	if (keyboard_check_pressed(ord("X"))) {
		var _idx = basic_tabs.get_current_tab();
		if (_idx >= 0) {
			basic_tabs.remove_tab(_idx);
		}
	}
}

// Overflow page controls
if (_demo_index == 1) {
	// Toggle resize
	if (keyboard_check_pressed(ord("R"))) {
		var _enabled = overflow_tabs.__resize_tabs_enabled;
		overflow_tabs.set_resize_tabs_enabled(!_enabled);
	}

	// Toggle freeze-after-close
	if (keyboard_check_pressed(ord("F"))) {
		var _enabled = overflow_tabs.__freeze_resize_after_close;
		overflow_tabs.set_freeze_resize_after_close(!_enabled);
	}

	// Close current tab
	if (keyboard_check_pressed(ord("X"))) {
		var _idx = overflow_tabs.get_current_tab();
		if (_idx >= 0) {
			overflow_tabs.remove_tab(_idx);
		}
	}
}

// Reorder page controls
if (_demo_index == 2) {
	// Close current tab
	if (keyboard_check_pressed(ord("X"))) {
		var _idx = reorder_tabs.get_current_tab();
		if (_idx >= 0) {
			reorder_tabs.remove_tab(_idx);
		}
	}
}

// Transfer page controls
if (_demo_index == 3) {
	// Toggle group gating
	if (keyboard_check_pressed(ord("G"))) {
		transfer_group_enabled = !transfer_group_enabled;

		if (transfer_group_enabled) {
			transfer_left.set_tabs_rearrange_group(transfer_group_id);
			transfer_right.set_tabs_rearrange_group(transfer_group_id);
		} else {
			transfer_left.set_tabs_rearrange_group(0);
			transfer_right.set_tabs_rearrange_group(0);
		}
	}

	// Close current on left
	if (keyboard_check_pressed(ord("Z"))) {
		var _idx = transfer_left.get_current_tab();
		if (_idx >= 0) {
			transfer_left.remove_tab(_idx);
		}
	}

	// Close current on right
	if (keyboard_check_pressed(ord("C"))) {
		var _idx = transfer_right.get_current_tab();
		if (_idx >= 0) {
			transfer_right.remove_tab(_idx);
		}
	}
}