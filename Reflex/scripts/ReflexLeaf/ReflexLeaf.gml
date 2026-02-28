#region jsDoc
/// @func ReflexLeaf()
/// @desc Base wrapper for native layerElement leaf nodes. Prohibits children.
/// @return {ReflexLeaf}
#endregion
function ReflexLeaf() : Reflex() constructor 
{
	#region Setters
	
	#region jsDoc
	/// @func set_visible(_visable)
	/// @desc Sets element visibility. IDE: "Visible".
	/// @param {Bool} visable : Whether the element is visible.
	/// @return {ReflexLeaf}
	#endregion
	static set_visible = function(_visable) {
		flexVisible = _visable;
		
		rebuild_node(to_struct());
        return self;
    };
	
	#region jsDoc
	/// @func set_anchor(_halign, _valign)
	/// @desc Sets the anchor preset. IDE: "Anchor".
	/// @param {Int} halign : Horizontal alignment value.
	/// @param {Int} valign : Vertical alignment value.
	/// @return {ReflexLeaf}
	#endregion
	static set_anchor = function(_halign, _valign) {
		var hstr, vstr;
		
		switch(_valign) {
			case fa_top    : vstr = "Top";    break;
			case fa_middle : vstr = "Middle"; break;
			case fa_bottom : vstr = "Bottom"; break;
		}
		switch(_halign) {
			case fa_left   : hstr = "Left";   break;
			case fa_center : hstr = "Centre"; break;
			case fa_right  : hstr = "Right";  break;
		}
		
		flexAnchor = vstr + hstr;
		
		rebuild_node(to_struct());
        return self;
    };
	
	#region jsDoc
	/// @func set_stretch(_width, _height)
	/// @desc Sets stretch behavior for width and height. IDE: "Stretch - Width" and "Stretch - Height".
	/// @param {Bool} width : Whether width stretches.
	/// @param {Bool} height : Whether height stretches.
	/// @return {ReflexLeaf}
	#endregion
	static set_stretch = function(_width, _height) {
		flexStretchWidth = _width;
		flexStretchHeight = _height;
		
		rebuild_node(to_struct());
        return self;
    };
	
	#region jsDoc
	/// @func set_keep_aspect(_bool)
	/// @desc Sets whether stretch keeps aspect ratio. IDE: "Keep Aspect".
	/// @param {Bool} bool : Enabled state.
	/// @return {ReflexLeaf}
	#endregion
    static set_keep_aspect = function(_bool) {
		flexStretchKeepAspect = _bool;
		
		rebuild_node(to_struct());
        return self;
    };
	
	#region jsDoc
	/// @func set_tiling(_horz, _vert)
	/// @desc Sets tiling behavior for width and height. IDE: "Tile - Horizontal" and "Tile - Vertical".
	/// @param {Bool} horz : Whether horizontal tiling is enabled.
	/// @param {Bool} vert : Whether vertical tiling is enabled.
	/// @return {ReflexLeaf}
	#endregion
	static set_tiling = function(_horz, _vert) {
		flexTileHorizontal = _horz;
		flexTileVertical = _vert;
		
		rebuild_node(to_struct());
        return self;
    };
	
	#endregion
	
	#region Getters
	
	#region jsDoc
	/// @func get_type()
	/// @desc Gets the layerElement type string for this leaf.
	/// @returns {String}
	#endregion
	static get_type = function() { return type; };
	
	#region jsDoc
	/// @func get_element_id()
	/// @desc Gets the unique elementId assigned to this leaf.
	/// @returns {String}
	#endregion
	static get_element_id = function() { return elementId; };
	
	#region jsDoc
	/// @func get_element_order()
	/// @desc Gets elementOrder which is used similarly to depth.
	/// @returns {Real}
	#endregion
	static get_element_order = function() { return elementOrder; };
	
	#region jsDoc
	/// @func get_visible()
	/// @desc Gets whether this leaf is visible in the flex panel.
	/// @returns {Bool}
	#endregion
	static get_visible = function() { return flexVisible; };
	
	#region jsDoc
	/// @func get_anchor()
	/// @desc Gets the flex anchor string (ex: "TopLeft").
	/// @returns {String}
	#endregion
	static get_anchor = function() { return flexAnchor; };
	
	#region jsDoc
	/// @func get_stretch_width()
	/// @desc Gets whether width stretching is enabled.
	/// @returns {Bool}
	#endregion
	static get_stretch_width = function() { return flexStretchWidth; };
	
	#region jsDoc
	/// @func get_stretch_height()
	/// @desc Gets whether height stretching is enabled.
	/// @returns {Bool}
	#endregion
	static get_stretch_height = function() { return flexStretchHeight; };
	
	#region jsDoc
	/// @func get_keep_aspect()
	/// @desc Gets whether stretching keeps aspect ratio.
	/// @returns {Bool}
	#endregion
	static get_keep_aspect = function() { return flexStretchKeepAspect; };
	
	#region jsDoc
	/// @func get_tile_horizontal()
	/// @desc Gets whether horizontal tiling is enabled.
	/// @returns {Bool}
	#endregion
	static get_tile_horizontal = function() { return flexTileHorizontal; };
	
	#region jsDoc
	/// @func get_tile_vertical()
	/// @desc Gets whether vertical tiling is enabled.
	/// @returns {Bool}
	#endregion
	static get_tile_vertical = function() { return flexTileVertical; };
	
	#endregion
	
	#region jsDoc
    /// @func rebuild_node(_element_struct)
    /// @desc Recreates the native Flexpanel node to apply layerElement changes.
    /// @param {Struct} _element_struct The layerElements struct defining the type (Sprite/Text).
    #endregion
    static rebuild_node = function(_element_struct) {
        var _s = flexpanel_node_get_struct(node_handle);
        
        // Ensure the array exists before assignment
        if (!variable_struct_exists(_s, "layerElements") || !is_array(_s.layerElements)) {
            _s.layerElements = [];
        }
        _s.layerElements[0] = _element_struct;
        
        var _new_handle = flexpanel_create_node(_s);
        
        // Swap handles in the parent's native tree
        if (__parent != undefined) {
            var _idx = array_get_index(__parent.__children, self);
            if (_idx != -1) {
                flexpanel_node_remove_child(__parent.node_handle, node_handle);
                flexpanel_node_insert_child(__parent.node_handle, _new_handle, _idx);
            }
        }
        
        flexpanel_delete_node(node_handle);
        node_handle = _new_handle;
    };
    
	#region Private
	
	#region Properties
	
	// Shared
	type = "";
	elementId = __uuid;
	elementOrder = 0.0; // Essentiall acts as depth
	
	flexVisible = true;
	flexAnchor = "TopLeft";
	
	flexStretchWidth = false;
	flexStretchHeight = false;
	flexTileHorizontal = false;
	flexTileVertical = false;
	flexStretchKeepAspect = false;
	
	#endregion
	
	#region Child Prohibition
	
    #region jsDoc
    /// @func add()
    /// @desc Prohibited on leaf nodes.
    #endregion
    static add = function() { throw("ReflexLeaf: Cannot add children to a leaf node."); };
	
    #region jsDoc
    /// @func insert()
    /// @desc Prohibited on leaf nodes.
    #endregion
    static insert = function() { throw("ReflexLeaf: Cannot insert children into a leaf node."); };
    
	#endregion
	
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
	
	#endregion
}