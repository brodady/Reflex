function ReflexLeaf() : Reflex() constructor {
    // Prohibit children for leaf nodes
    static add = function() { throw("ReflexLeaf: Cannot add children to a leaf node."); };
    static insert = function() { throw("ReflexLeaf: Cannot insert children into a leaf node."); };
    
    // Internal state for content
    content_width = 0;
    content_height = 0;

    /// @desc Internal bridge for Yoga. Do not call directly.
    static __measure_bridge = function(_w, _wm, _h, _hm) {
        return on_measure(_w, _wm, _h, _hm);
    };

    /// @desc Override this in specialized leaves
    static on_measure = function(_w, _wm, _h, _hm) {
        return { width: content_width, height: content_height };
    };

    // Bind the bridge to the native handle
    flexpanel_node_set_measure_function(node_handle, method(self, __measure_bridge));
}