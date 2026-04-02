// FoldableContainer demo (Create Event)
//
// Assumes ReflexLayer exists and Reflex system is initialized.

var _root = new ReflexVBoxContainer();
_root.add_to("ReflexLayer");
_root.set_width("70%");
_root.set_height("70%");
_root.set_min_width(420);
_root.set_min_height(260);
_root.set_padding_left(8);
_root.set_padding_top(8);
_root.set_padding_right(8);
_root.set_padding_bottom(8);
_root.set_separation(6);

// Helper to create a foldable with simple header text and a content panel
function _make_foldable(_title_text, _expanded)
{
	var _fold = new ReflexFoldableContainer();
	_fold.set_width("100%");
	_fold.set_flex_shrink(0);

	var _head = new ReflexUI();
	_head.set_height(24);
	_head.set_flex_grow(1);
	_head.set_flex_shrink(1);

	var _label = new ReflexLeafText(_title_text, __fnt_reflex);
	_label.add_to(_head);
	_label.set_text_offsets(0, 0);
	_label.set_text_justification(fa_left, fa_middle);
	_label.set_text_color(c_black);

	_fold.set_header(_head);

	var _body = new ReflexUI();
	_body.set_width("100%");
	_body.set_flex_grow(1);
	_body.set_flex_shrink(1);
	_body.set_padding_left(10);
	_body.set_padding_top(6);
	_body.set_padding_right(10);
	_body.set_padding_bottom(6);

	var _body_text = new ReflexLeafText("Content can be any subtree.", __fnt_reflex);
	_body_text.add_to(_body);
	_body_text.set_text_offsets(0, 0);
	_body_text.set_text_justification(fa_left, fa_top);
	_body_text.set_text_color(make_color_rgb(40, 40, 40));

	_fold.set_content(_body);
	_fold.set_expanded(_expanded, false);

	return _fold;
}

// Top foldable
var _fold_a = _make_foldable("Section A (animated)", true);
_fold_a.add_to(_root);
_fold_a.set_animation_enabled(true);
_fold_a.set_animation_duration(180);

// Nested foldable inside A content
var _inner = new ReflexFoldableContainer();
_inner.set_width("100%");
_inner.set_animation_enabled(true);
_inner.set_animation_duration(160);
_inner.set_toggle_mode("chevron");

var _inner_head = new ReflexUI();
_inner_head.set_height(24);
var _inner_label = new ReflexLeafText("Nested Section (chevron-only toggle)", __fnt_reflex);
_inner_label.add_to(_inner_head);
_inner_label.set_text_justification(fa_left, fa_middle);
_inner_label.set_text_color(c_black);

var _inner_body = new ReflexUI();
_inner_body.set_padding_left(10);
_inner_body.set_padding_top(6);
_inner_body.set_padding_right(10);
_inner_body.set_padding_bottom(6);

var _inner_body_text = new ReflexLeafText("Nested content.", __fnt_reflex);
_inner_body_text.add_to(_inner_body);
_inner_body_text.set_text_justification(fa_left, fa_top);

_inner.set_header(_inner_head);
_inner.set_content(_inner_body);
_inner.set_expanded(false, false);

// Insert nested into A's content
_fold_a.get_content().add(_inner);

// Grouped foldables (accordion mode)
var _group_row = new ReflexUI();
_group_row.set_width("100%");
_group_row.set_flex_shrink(0);
_group_row.set_padding_top(6);
_group_row.set_padding_bottom(0);
_group_row.add_to(_root);

var _fold_b = _make_foldable("Group 1", false);
_fold_b.set_foldable_group_id(1);
_fold_b.set_allow_fold_all(false);
_fold_b.add_to(_root);

var _fold_c = _make_foldable("Group 1 (second)", false);
_fold_c.set_foldable_group_id(1);
_fold_c.set_allow_fold_all(false);
_fold_c.add_to(_root);

show_debug_message("FoldableContainer demo loaded.");
