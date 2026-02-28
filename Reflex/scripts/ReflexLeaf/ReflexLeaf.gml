#region jsDoc
/// @func ReflexLeaf()
/// @desc Base wrapper for native layerElement leaf nodes. Prohibits children.
/// @return {ReflexLeaf}
#endregion
function ReflexLeaf() : Reflex() constructor 
{
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

    #region Native Node Recreation
    #region jsDoc
    /// @func __rebuild_node(_element_struct)
    /// @desc Recreates the native Flexpanel node to apply layerElement changes.
    /// @param {Struct} _element_struct The layerElements struct defining the type (Sprite/Text).
    #endregion
    static __rebuild_node = function(_element_struct) {
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
    #endregion
}