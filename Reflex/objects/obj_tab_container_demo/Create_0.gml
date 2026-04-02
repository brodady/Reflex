// Root demo tabs
demo_tabs = new ReflexTabContainer()
	.set_width("65%")
	.set_height("65%")
	.set_min_width(300)
	.set_min_height(200)
	.set_deselect_enabled(false)
demo_tabs.add_to("ReflexLayer")

// Pages (top-level demo sections)
page_basics = new ReflexUI();
page_overflow = new ReflexUI();
page_reorder = new ReflexUI();
page_transfer = new ReflexUI();

demo_tabs.add_tab("Basics", page_basics, false);
demo_tabs.add_tab("Overflow + Close Freeze", page_overflow, false);
demo_tabs.add_tab("Reorder", page_reorder, false);
demo_tabs.add_tab("Transfer", page_transfer, false);

// -----------------------------------------------------------------------------
// Basics page: nested TabContainer with a few colored pages
// -----------------------------------------------------------------------------
basic_tabs = new ReflexTabContainer()
	.set_width("100%")
	.set_height("100%")
	.set_deselect_enabled(true)
	.set_tabs_rearrange_group(0)
basic_tabs.add_to(page_basics)

basic_pages = [];
basic_colors = [c_red, c_orange, c_yellow, c_green, c_aqua, c_blue];

for (var _i = 0; _i < 6; _i++) {
	var _page = new ReflexUI();
	_page.set_name("basic_page_" + string(_i + 1));
	array_push(basic_pages, _page);
	basic_tabs.add_tab("Tab " + string(_i + 1), _page, true);
}
basic_tabs.set_current_tab(0);

// -----------------------------------------------------------------------------
// Overflow page: many tabs to force shrink + scroll and test close-freeze
// -----------------------------------------------------------------------------
overflow_tabs = new ReflexTabContainer()
	.set_width("100%")
	.set_height("100%")
	.set_deselect_enabled(false)
	.set_tabs_rearrange_group(0)
overflow_tabs.add_to(page_overflow);

overflow_pages = [];
for (var _i = 0; _i < 40; _i++) {
	var _page = new ReflexUI();
	_page.set_name("overflow_page_" + string(_i + 1));
	array_push(overflow_pages, _page);
	overflow_tabs.add_tab("File " + string(_i + 1), _page, true);
}
overflow_tabs.set_current_tab(0);

// -----------------------------------------------------------------------------
// Reorder page: moderate number of tabs to drag reorder within container
// -----------------------------------------------------------------------------
reorder_tabs = new ReflexTabContainer()
	.set_width("100%")
	.set_height("100%")
	.set_deselect_enabled(false)
	.set_tabs_rearrange_group(0)
reorder_tabs.add_to(page_reorder);

reorder_pages = [];
reorder_colors = [c_lime, c_teal, c_navy, c_purple, c_fuchsia, c_maroon, c_olive, c_gray, c_silver, c_white];

for (var _i = 0; _i < 10; _i++) {
	var _page = new ReflexUI();
	_page.set_name("reorder_page_" + string(_i + 1));
	array_push(reorder_pages, _page);
	reorder_tabs.add_tab("Item " + string(_i + 1), _page, true);
}
reorder_tabs.set_current_tab(0);

// -----------------------------------------------------------------------------
// Transfer page: two containers side by side, group-gated transfer
// -----------------------------------------------------------------------------
transfer_group_enabled = true;
transfer_group_id = 1;

transfer_row = new ReflexHBoxContainer()
	.set_width("100%")
	.set_height("100%")
transfer_row.add_to(page_transfer);

transfer_left = new ReflexTabContainer()
	.set_flex_grow(1)
	.set_tabs_rearrange_group(transfer_group_id);
transfer_right = new ReflexTabContainer()
	.set_flex_grow(1)
	.set_tabs_rearrange_group(transfer_group_id);

transfer_left.add_to(transfer_row);
transfer_right.add_to(transfer_row);

transfer_left_pages = [];
transfer_right_pages = [];

for (var _i = 0; _i < 8; _i++) {
	var _page = new ReflexUI();
	_page.set_name("left_page_" + string(_i + 1));
	array_push(transfer_left_pages, _page);
	transfer_left.add_tab("Left " + string(_i + 1), _page, true);
}

for (var _i = 0; _i < 6; _i++) {
	var _page = new ReflexUI();
	_page.set_name("right_page_" + string(_i + 1));
	array_push(transfer_right_pages, _page);
	transfer_right.add_tab("Right " + string(_i + 1), _page, true);
}

transfer_left.set_current_tab(0);
transfer_right.set_current_tab(0);

// -----------------------------------------------------------------------------
// Demo presentation toggles
// -----------------------------------------------------------------------------
show_debug = false;

// Helpful log
show_debug_message("TabContainer demo loaded.");
show_debug_message("Top tabs: Basics, Overflow + Close Freeze, Reorder, Transfer");
show_debug_message("Press D to toggle debug overlay.");