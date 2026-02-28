show_debug_overlay(true)

grid_root = new ReflexGridContainer();
grid_root.set_grid_counts(2, 2);
grid_root.set_grid_gap(16, 16);
grid_root.set_cell_align("stretch", "stretch");

// -----------------------------------------------------------------------------
// Subgrid 1) 4x4 inventory grid
// -----------------------------------------------------------------------------
grid_inventory = new ReflexGridContainer();
grid_inventory.set_grid_counts(4, 4);
grid_inventory.set_grid_gap(6, 6);
grid_inventory.set_cell_align("stretch", "stretch");

// Add 16 items (order should map row-major)
for (var i = 0; i < 16; i++)
{
	var _item_node = new Reflex();
	grid_inventory.add(_item_node);
}

// -----------------------------------------------------------------------------
// Subgrid 2) auto grid (sqrt-based counts, reshuffles as child count changes)
// -----------------------------------------------------------------------------
grid_auto = new ReflexGridContainer();
grid_auto.set_auto_grid(true);
grid_auto.set_grid_gap(6, 6);
grid_auto.set_cell_align("stretch", "stretch");

// Start with a non-square count to show reshuffle later
for (var j = 0; j < 11; j++)
{
	var _auto_node = new Reflex();
	grid_auto.add(_auto_node);
}

// -----------------------------------------------------------------------------
// Subgrid 3) CSS-like span layout (header/left/body/right/footer)
// Using fixed cell anchors + spans.
// -----------------------------------------------------------------------------
grid_span = new ReflexGridContainer();
grid_span.set_grid_counts(4, 4);
grid_span.set_grid_gap(6, 6);
grid_span.set_cell_align("stretch", "stretch");

node_header = new Reflex();
node_left = new Reflex();
node_body = new Reflex();
node_right = new Reflex();
node_footer = new Reflex();

// Anchor + spans (inclusive coords)
grid_span.set_span(node_header, 0, 0, 3, 0);	// header spans full width
grid_span.set_span(node_left, 0, 1, 0, 2);		// left sidebar spans 2 rows
grid_span.set_span(node_body, 1, 1, 2, 2);		// body spans 2x2
grid_span.set_span(node_right, 3, 1, 3, 2);		// right sidebar spans 2 rows
grid_span.set_span(node_footer, 0, 3, 3, 3);	// footer spans full width

// -----------------------------------------------------------------------------
// Subgrid 4) WILD CARD: mixed explicit placement + auto packing around obstacles
// Tests:
// - set_cell / set_span reserved cells
// - auto placement skipping occupied cells
// - clear_cell at runtime to see re-pack
// -----------------------------------------------------------------------------
grid_mixed = new ReflexGridContainer();
grid_mixed.set_grid_counts(6, 4);
grid_mixed.set_grid_gap(6, 6);
grid_mixed.set_cell_align("stretch", "stretch");

// Obstacles
node_lock_a = new Reflex();
node_lock_b = new Reflex();
node_lock_c = new Reflex();

grid_mixed.set_cell(1, 1, node_lock_a);			// single-cell lock
grid_mixed.set_span(node_lock_b, 3, 0, 5, 0);	// top bar lock
grid_mixed.set_span(node_lock_c, 0, 3, 2, 3);	// bottom bar lock

// Auto-placed items (some with spans)
for (var k = 0; k < 10; k++)
{
	var _mix_node = new Reflex();
	grid_mixed.add(_mix_node);

	// Give every 3rd item a wider span to force packing behavior
	if ((k % 3) == 2)
	{
		grid_mixed.set_grid_span(_mix_node, 2, 1);
	}
}

// -----------------------------------------------------------------------------
// Place subgrids into the 2x2 root grid using explicit cells
// -----------------------------------------------------------------------------
grid_root.set_cell(0, 0, grid_inventory);
grid_root.set_cell(1, 0, grid_auto);
grid_root.set_cell(0, 1, grid_span);
grid_root.set_cell(1, 1, grid_mixed);

// Demo controls
demo_time = 0;
auto_toggle = false;
mixed_toggle = false;
