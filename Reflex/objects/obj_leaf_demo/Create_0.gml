// ============================================================================
// obj_reflex_leaf_demo
// Demonstrates ONLY leaf elements on a single Reflex/ReflexUI node:
//
// - ReflexLayerElementSprite
// - ReflexLayerElementText
// - ReflexLayerElementInstance
//
// Requirements:
// - UI layer named "ReflexLayer"
// - A node class that supports: add_to(), add_element(), insert_element(), remove_element(),
//   clear_elements(), get_element_count(), get_element_at()
// - spr_test (or change the sprite ref string below)
// - obj_test (or change the object ref string below)
//
// Controls:
//  1: Add Sprite element
//  2: Add Text element
//  3: Add Instance element
//  4: Remove last element
//  5: Clear all elements
//  A: Toggle attach/detach from "ReflexLayer"
// ============================================================================

demo_attached = false;
demo_element_id = 1.0;
demo_element_order = 10.0;

// Host node that will carry layerElements
leaf_host = new ReflexUI();
leaf_host.set_name("LeafHost");

// Give it a stable size so you can see elements in the UI layer
leaf_host.set_width(520, flexpanel_unit.point);
leaf_host.set_height(260, flexpanel_unit.point);

// Put it somewhere obvious
leaf_host.set_position_type(flexpanel_position_type.absolute);
leaf_host.set_position(flexpanel_edge.left, 64, flexpanel_unit.point);
leaf_host.set_position(flexpanel_edge.top, 64, flexpanel_unit.point);

// Attach to UI layer
leaf_host.add_to("ReflexLayer");
demo_attached = true;