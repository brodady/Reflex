#region jsDoc
/// @desc
///		Base "layerElements" descriptor used by ReflexUI leaf rendering.
///		This does NOT extend Reflex and does NOT own a flexpanel node.
///		It only builds a struct compatible with flexpanel_create_node({ layerElements: [...] }).
///
///		Shared fields:
///		- type
///		- elementId / elementOrder
///		- flexVisible
///		- flexAnchor (String, ex: "TopLeft")
///		- flexStretchWidth / flexStretchHeight
///		- flexTileHorizontal / flexTileVertical
///		- flexStretchKeepAspect
///
#endregion
function ReflexLayerElementBase() constructor
{
	// Shared
	type = "";
	elementId = 0.0;
	elementOrder = 0.0;

	flexVisible = true;
	flexAnchor = "TopLeft";

	flexStretchWidth = false;
	flexStretchHeight = false;
	flexTileHorizontal = false;
	flexTileVertical = false;
	flexStretchKeepAspect = false;

	#region jsDoc
	/// @func    set_common()
	/// @desc    Sets the common layer element fields used by all element types.
	/// @self    ReflexLayerElementBase
	/// @param   {String} _type_value
	/// @param   {Real} _element_id
	/// @param   {Real} _element_order
	/// @returns {Struct.ReflexLayerElementBase}
	#endregion
	static set_common = function(_type_value, _element_id, _element_order)
	{
		type = _type_value;
		elementId = _element_id;
		elementOrder = _element_order;
		return self;
	};

	#region jsDoc
	/// @func    set_flex_flags()
	/// @desc    Sets flex-visible and anchor/tiling/stretch flags shared across element types.
	/// @self    ReflexLayerElementBase
	/// @param   {Bool} _visible
	/// @param   {String} _anchor
	/// @param   {Bool} _stretch_w
	/// @param   {Bool} _stretch_h
	/// @param   {Bool} _tile_h
	/// @param   {Bool} _tile_v
	/// @param   {Bool} _keep_aspect
	/// @returns {Struct.ReflexLayerElementBase}
	#endregion
	static set_flex_flags = function(_visible, _anchor, _stretch_w, _stretch_h, _tile_h, _tile_v, _keep_aspect)
	{
		flexVisible = (_visible == true);
		flexAnchor = is_string(_anchor) ? _anchor : flexAnchor;

		flexStretchWidth = (_stretch_w == true);
		flexStretchHeight = (_stretch_h == true);
		flexTileHorizontal = (_tile_h == true);
		flexTileVertical = (_tile_v == true);
		flexStretchKeepAspect = (_keep_aspect == true);

		return self;
	};

	#region jsDoc
	/// @func    to_struct()
	/// @desc    Builds a plain struct suitable for insertion into a flexpanel node "layerElements" array.
	///          Derived types should call base_to_struct() then add their own fields.
	/// @self    ReflexLayerElementBase
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		return {
			type: type,
			elementId: elementId,
			elementOrder: elementOrder,
			
			flexVisible: flexVisible,
			flexAnchor: flexAnchor,
			
			flexStretchWidth: flexStretchWidth,
			flexStretchHeight: flexStretchHeight,
			flexTileHorizontal: flexTileHorizontal,
			flexTileVertical: flexTileVertical,
			flexStretchKeepAspect: flexStretchKeepAspect
		};
	};
}
