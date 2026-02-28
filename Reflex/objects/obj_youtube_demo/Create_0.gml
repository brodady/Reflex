// Root
layout_root = new Reflex();
layout_root.set_name("root");
layout_root.set_flex_direction(flexpanel_flex_direction.column);
layout_root.set_width(100, flexpanel_unit.percent);
layout_root.set_height(100, flexpanel_unit.percent);
layout_root.set_align_items(flexpanel_align.stretch);
layout_root.set_align_content(flexpanel_align.stretch);
layout_root.add_to("ReflexLayer");

// Masthead
layout_masthead = new Reflex();
layout_masthead.set_name("masthead");
layout_masthead.set_width(100, flexpanel_unit.percent);
layout_masthead.set_height(56, flexpanel_unit.point);
layout_masthead.set_flex_grow(0);
layout_masthead.set_flex_shrink(0);

// Body
layout_body = new Reflex();
layout_body.set_name("body");
layout_body.set_flex_direction(flexpanel_flex_direction.row);
layout_body.set_width(100, flexpanel_unit.percent);
layout_body.set_flex_grow(1);
layout_body.set_flex_shrink(1);
layout_body.set_align_items(flexpanel_align.stretch);

// Guide (left pane)
layout_guide = new Reflex();
layout_guide.set_name("guide");
layout_guide.set_width(240, flexpanel_unit.point);
layout_guide.set_height(100, flexpanel_unit.percent);
layout_guide.set_flex_grow(0);
layout_guide.set_flex_shrink(0);
layout_guide.set_flex_direction(flexpanel_flex_direction.column);
layout_guide.set_gap(flexpanel_gutter.all_gutters, 8);

// Main (content)
layout_main = new Reflex();
layout_main.set_name("main");
layout_main.set_flex_direction(flexpanel_flex_direction.column);
layout_main.set_flex_grow(1);
layout_main.set_flex_shrink(1);
layout_main.set_width(100, flexpanel_unit.percent);
layout_main.set_height(100, flexpanel_unit.percent);
layout_main.set_align_items(flexpanel_align.stretch);
layout_main.set_gap(flexpanel_gutter.all_gutters, 8);
layout_main.set_margin(flexpanel_edge.all_edges, 16);

// Chipbar
layout_chipbar = new Reflex();
layout_chipbar.set_name("chipbar");
layout_chipbar.set_width(100, flexpanel_unit.percent);
layout_chipbar.set_height(48, flexpanel_unit.point);
layout_chipbar.set_flex_grow(0);
layout_chipbar.set_flex_shrink(0);

// Content area (scroll region placeholder)
layout_content = new Reflex();
layout_content.set_name("content");
layout_content.set_width(100, flexpanel_unit.percent);
layout_content.set_flex_grow(1);
layout_content.set_flex_shrink(1);
layout_content.set_flex_direction(flexpanel_flex_direction.column);
layout_content.set_gap(flexpanel_gutter.all_gutters, 16);

// Video grid container
layout_grid = new Reflex();
layout_grid.set_name("video_grid");
layout_grid.set_width(100, flexpanel_unit.percent);
layout_grid.set_flex_grow(1);
layout_grid.set_flex_shrink(1);
layout_grid.set_flex_direction(flexpanel_flex_direction.row);
layout_grid.set_flex_wrap(flexpanel_wrap.wrap);
layout_grid.set_gap(flexpanel_gutter.all_gutters, 16);
layout_grid.set_align_items(flexpanel_align.stretch);
layout_grid.set_padding(flexpanel_edge.all_edges, 32);
layout_grid.set_margin(flexpanel_edge.all_edges, 4);

// Build tree
layout_root.add(layout_masthead);
layout_root.add(layout_body);

layout_body.add(layout_guide);
layout_body.add(layout_main);

layout_main.add(layout_chipbar);
layout_main.add(layout_content);

layout_content.add(layout_grid);

// ---------------------------------------------------------------------
// Populate left guide with repeated "subscription" rows
// ---------------------------------------------------------------------
var _subs_count = 10;
guide_subs = array_create(_subs_count);

for (var i = 0; i < _subs_count; i++)
{
	var _subs_item = new Reflex();
	_subs_item.set_name("sub_" + string(i));
	_subs_item.set_width(100, flexpanel_unit.percent);
	_subs_item.set_height(32, flexpanel_unit.point);
	_subs_item.set_flex_grow(0);
	_subs_item.set_flex_shrink(0);

	layout_guide.add(_subs_item);
	guide_subs[i] = _subs_item;
}

// ---------------------------------------------------------------------
// Populate main grid with repeated "video" tiles
// Use fixed tile width so wrap produces columns.
// ---------------------------------------------------------------------
var _video_count = 16;
grid_videos = array_create(_video_count);

for (var j = 0; j < _video_count; j++)
{
	var _tile = new Reflex();
	_tile.set_name("vid_" + string(j));
	_tile.set_width(320, flexpanel_unit.point);
	_tile.set_height(220, flexpanel_unit.point);
	_tile.set_flex_grow(0);
	_tile.set_flex_shrink(0);

	layout_grid.add(_tile);
	grid_videos[j] = _tile;
}