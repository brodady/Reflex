// Toggle attach/detach
if (keyboard_check_pressed(ord("A")))
{
	if (demo_attached)
	{
		leaf_host.remove_from("ReflexLayer");
		demo_attached = false;
	}
	else
	{
		leaf_host.add_to("ReflexLayer");
		demo_attached = true;
	}
}

// 1: Add Sprite
if (keyboard_check_pressed(ord("1")))
{
	var _elem = new ReflexLayerElementSprite();
	_elem.set_common("Sprite", demo_element_id, demo_element_order);

	// Replace with your sprite ref
	_elem.set_sprite(spr_test);
	_elem.set_flex_flags(true, "TopLeft", false, false, false, false, false);

	// Offset so multiple elements don’t all stack perfectly
	_elem.set_offset(16.0 * (demo_element_id - 1.0), 0.0);

	leaf_host.add_element(_elem);

	demo_element_id += 1.0;
	demo_element_order += 10.0;
}

// 2: Add Text
if (keyboard_check_pressed(ord("2")))
{
	var _elem = new ReflexLayerElementText();
	_elem.set_common("Text", demo_element_id, demo_element_order);

	_elem.set_text("Hello " + string(demo_element_id));
	_elem.set_font(fnt_lbl);
	_elem.set_flex_flags(true, "TopLeft", false, false, false, false, false);

	// Offset down per added element
	_elem.set_offset(0.0, 20.0 * (demo_element_id - 1.0));

	leaf_host.add_element(_elem);

	demo_element_id += 1.0;
	demo_element_order += 10.0;
}

// 3: Add Instance
if (keyboard_check_pressed(ord("3")))
{
	var _elem = new ReflexLayerElementInstance();
	_elem.set_common("Instance", demo_element_id, demo_element_order);

	// Replace with your object ref
	_elem.set_object(obj_leaf);
	_elem.set_flex_flags(true, "TopLeft", false, false, false, false, false);

	// Stagger instances diagonally
	_elem.set_transform(24.0 * (demo_element_id - 1.0), 24.0 * (demo_element_id - 1.0), 1.0, 1.0, 0.0);

	leaf_host.add_element(_elem);

	demo_element_id += 1.0;
	demo_element_order += 10.0;
}

// 4: Remove last
if (keyboard_check_pressed(ord("4")))
{
	var _count = leaf_host.get_element_count();
	if (_count > 0)
	{
		var _elem = leaf_host.get_element_at(_count - 1);
		leaf_host.remove_element(_elem);
	}
}

// 5: Clear all
if (keyboard_check_pressed(ord("5")))
{
	leaf_host.clear_elements();
}