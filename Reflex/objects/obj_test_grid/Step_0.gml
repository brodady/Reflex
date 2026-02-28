demo_time += 1;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Root solve-space
grid_root.set_grid_size(_gui_w, _gui_h);

// Compute root cell size (2x2, 1 gap between columns and rows)
var _cell_w = max(0, (_gui_w - 16) * 0.5);
var _cell_h = max(0, (_gui_h - 16) * 0.5);

// Each subgrid solves within its parent cell
grid_inventory.set_grid_size(_cell_w, _cell_h);
grid_auto.set_grid_size(_cell_w, _cell_h);
grid_span.set_grid_size(_cell_w, _cell_h);
grid_mixed.set_grid_size(_cell_w, _cell_h);

// Auto grid stress: press A to add/remove one item (shows reshuffle)
if (keyboard_check_pressed(ord("A")))
{
	auto_toggle = !auto_toggle;

	if (auto_toggle)
	{
		var _new_node = new Reflex();
		grid_auto.add(_new_node);
	}
	else
	{
		// Remove last child if present
		var _count_auto = array_length(grid_auto.__children);
		if (_count_auto > 0)
		{
			grid_auto.remove(grid_auto.__children[_count_auto - 1]);
		}
	}
}

// Mixed grid stress: press C to clear/restore an obstacle cell
if (keyboard_check_pressed(ord("C")))
{
	mixed_toggle = !mixed_toggle;

	if (mixed_toggle)
	{
		// Free a locked cell and watch auto packing reflow
		grid_mixed.clear_cell(1, 1);
	}
	else
	{
		// Restore the lock
		grid_mixed.set_cell(1, 1, node_lock_a);
	}
}

// Single normal reflow path (no overrides in ReflexGridContainer)
grid_root.attempt_reflow(0, 0, _gui_w, _gui_h, flexpanel_direction.LTR, false);