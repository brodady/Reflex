#region jsDoc
/// @func ReflexLeaf()
/// @desc Base wrapper for native layerElement leaf nodes.
/// @return {ReflexLeaf}
#endregion
function ReflexLeaf() : Reflex() constructor 
{
    static add = function() { throw("ReflexLeaf: Cannot add children to a leaf node."); };
    static insert = function() { throw("ReflexLeaf: Cannot insert children into a leaf node."); };

    #region jsDoc
    /// @func __rebuild_node(_element_struct)
    /// @desc Recreates the native Flexpanel node to apply layerElement changes.
    #endregion
    static __rebuild_node = function(_element_struct) {
        var _s = flexpanel_node_get_struct(node_handle);
        
        if (!variable_struct_exists(_s, "layerElements") || !is_array(_s.layerElements)) {
            _s.layerElements = [];
        }
        _s.layerElements[0] = _element_struct;
        
        var _new_handle = flexpanel_create_node(_s);
        
        if (__parent != undefined) {
            var _idx = array_get_index(__parent.__children, self);
            if (_idx != -1) {
                flexpanel_node_remove_child(__parent.node_handle, node_handle);
                flexpanel_node_insert_child(__parent.node_handle, _new_handle, _idx);
            }
        }
        
        flexpanel_delete_node(node_handle);
        node_handle = _new_handle;
        
        request_reflow();
    };
}