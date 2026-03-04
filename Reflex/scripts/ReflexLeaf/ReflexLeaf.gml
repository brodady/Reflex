#region jsDoc
/// @func ReflexLeaf()
/// @desc Base wrapper for native layerElement leaf nodes. Prohibits children.
/// @return {ReflexLeaf}
#endregion
function ReflexLeaf() : Reflex() constructor 
{
	#region Setters
	
	#region jsDoc
	/// @func set_anchor(halign_or_preset, valign=undefined)
	/// @desc Sets the layerElement anchor preset for this leaf.
	///         This maps to the layerElements field "flexAnchor" (String) in the Flex Panel Struct Members.
	///         Valid preset strings:
	///         - "TopLeft", "TopCentre", "TopRight"
	///         - "MiddleLeft", "MiddleCentre", "MiddleRight"
	///         - "BottomLeft", "BottomCentre", "BottomRight"
	///        Overloads:
	///         1) set_anchor(_preset_string)
	///            - If only one argument is provided, it is treated as the preset string.
	///         2) set_anchor(Valign, Halign)
	///            - Valign: fa_top, fa_middle, fa_bottom
	///            - Halign: fa_left, fa_center, fa_right
	///        Notes:
	///         - This is a layerElements struct member, not a node style, so it currently requires rebuilding the leaf node.
	/// @param {Constant.Valign|String} valign_or_preset : Vertical alignment constant OR preset string.
	/// @param {Constant.Halign|Undefined} halign : Horizontal alignment constant (required when using constants).
	/// @return {ReflexLeaf}
	#endregion
	static set_anchor = function(_valign_or_preset, _halign=undefined)
	{
		var _preset = _valign_or_preset;
		
		if (_halign != undefined) {
			var _hstr = "";
			var _vstr = "";
			switch (_valign_or_preset) {
				case fa_top:    _vstr = "Top"; break;
				case fa_middle: _vstr = "Middle"; break;
				case fa_bottom: _vstr = "Bottom"; break;
			}
			switch (_halign) {
				case fa_left:   _hstr = "Left"; break;
				case fa_center: _hstr = "Centre"; break;
				case fa_right:  _hstr = "Right"; break;
			}

			_preset = _vstr + _hstr;
		}

		if (flexAnchor == _preset) { return self; }

		flexAnchor = _preset;

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
		if (flexStretchWidth = _width)
		&& (flexStretchHeight = _height) {
			return self;
		}
		
		flexStretchWidth = _width;
		flexStretchHeight = _height;
		
		rebuild_node(to_struct());
        return self;
    };
	
	#region jsDoc
	/// @func set_keep_aspect(_enabled)
	/// @desc Sets the layerElement "flexStretchKeepAspect" flag.
	///        This is an element-level stretch behavior and currently requires rebuilding the leaf node.
	/// @param {Bool} _enabled
	/// @return {ReflexLeaf}
	#endregion
	static set_keep_aspect = function(_enabled) {
		if (flexStretchKeepAspect == _enabled) { return self; }
		flexStretchKeepAspect = _enabled;
		
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
		if (flexTileHorizontal == _horz)
		&& (flexTileVertical == _vert) {
			return self;
		}
		
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
	/// @desc Gets the unique elementId assigned to this leaf. Will return -1 if element doesnt exist yet
	/// @returns {Real}
	#endregion
	static get_element_id = function() {
		return elementId;
	};
	
	#region jsDoc
	/// @func get_element_order()
	/// @desc Gets elementOrder which is used similarly to depth.
	/// @returns {Real}
	#endregion
	static get_element_order = function() { return elementOrder; };
	
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
	
	#region Functions
	
	#region jsDoc
	/// @func    call_on_element_ready()
	/// @desc    Registers a callback to run once the UI layer has created its backing element.
	///
	///          - If the element already exists, the callback runs immediately.
	///          - If it does not exist yet, the callback is queued and will run automatically the first
	///            frame the element exists.
	///          - This is intended for initialization that must touch element variables without requiring the caller to manually poll.
	///
	///          Note:
	///          - The callback is invoked as _fn(_element_id) where _element_id is the asset layer id of the element.
	/// @self    ReflexObject
	/// @param   {Method|Function} _fn : Function to run when the instance exists. Called as _fn(_element_id).
	/// @returns {Struct.ReflexObject}
	#endregion
	static call_on_element_ready = function(_fn){
		if (elementId == -1) {
			__ensure_elem_polling();
			array_push(__call_on_elem_exist, _fn);
		}
		else {
			_fn(elementId);
		}
		return self;
	}
	
	#region jsDoc
	/// @func    add_to()
	/// @desc    Attaches this Reflex node to either:
	///          1) Another Reflex node (as a child), or
	///          2) The root Flex Panel Node of a UI layer (by name).
	///          If currently parented, this will detach first (from a Reflex parent or native flexpanel parent).
	/// @self    Reflex
	/// @param   {String|Struct.Reflex} _parent_or_ui_layer : UI layer name (String) or parent Reflex node.
	/// @returns {Bool}
	#endregion
	static add_to = function(_parent_or_ui_layer="ReflexLayer")
	{
		static __base_add_to = Reflex.add_to;
		var _value = __base_add_to(_parent_or_ui_layer);
		__ensure_elem_polling();
		return _value;
	}
	
	#region jsDoc
	/// @func    remove_from()
	/// @desc    Detaches this Reflex node from either:
	///          1) A Reflex parent (if given a Reflex), or
	///          2) A UI layer root (if given a layer name String).
	///          If a Reflex parent is provided, this calls parent.remove(self).
	///          If a UI layer name is provided, this removes node_handle from that UI layer root.
	///          After detaching, this node becomes its own wrapper root (__parent=undefined, __root=self).
	/// @self    Reflex
	/// @param   {String|Struct.Reflex} _parent_or_ui_layer : Defaults to (__parent==undefined) ? "ReflexLayer" : __parent.
	/// @returns {Bool}
	#endregion
	static remove_from = function(_parent_or_ui_layer=(__parent == undefined) ? "ReflexLayer" : __parent)
	{
		static __base_remove_from = Reflex.remove_from;
		var _value = __base_remove_from(_parent_or_ui_layer);
		__invalidate_elem();
		return _value;
	}
	
	#region jsDoc
	/// @func rebuild_node(_element_struct)
	/// @desc Recreates the native Flexpanel node to apply layerElement changes.
	///        Important:
	///        - Does not write elementId.
	///        - Invalidates element and restarts polling.
	/// @param {Struct} _element_struct
	#endregion
	static rebuild_node = function(_element_struct)
	{
		//if (__parent == undefined && __in_ui_layer = false) {
		//	__invalidate_elem();
		//	return;
		//}
		
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

		flexpanel_delete_node(node_handle, false);
		node_handle = _new_handle;
		
		//invalidate elementId and re-poll for existance again
		var _s = flexpanel_node_get_struct(node_handle);
		var _elem = _s.layerElements[0].elementId;
		
		if (_elem == -1) {
			__invalidate_elem();
			__ensure_elem_polling();
		}
		else {
			__validate_elem(_elem);
		}
	};
	
	#endregion
	
	#region Private
	
	#region Properties
	
	// Shared
	type = "";
	elementId = -1; // This should be undefined anytime the asset has not finished building
	elementOrder = 0.0; // Essentiall acts as depth
	
	flexVisible = true;
	flexAnchor = "TopLeft";
	
	flexStretchWidth = false;
	flexStretchHeight = false;
	flexTileHorizontal = false;
	flexTileVertical = false;
	flexStretchKeepAspect = false;
	
	#endregion
	
	//array used to allow for calling when the instance finally exists.
	__elem_timesource = undefined;
	__is_polling_elem = false;
	__call_on_elem_exist = [];
	__elem_valid = false;
	__in_ui_layer = false;
	
	
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
	static to_struct = function(){
		var _struct = {
			type: type,
			//elementId: elementId,
			elementOrder: elementOrder,
			
			flexVisible: flexVisible,
			flexAnchor: flexAnchor,
			
			flexStretchWidth: flexStretchWidth,
			flexStretchHeight: flexStretchHeight,
			flexTileHorizontal: flexTileHorizontal,
			flexTileVertical: flexTileVertical,
			flexStretchKeepAspect: flexStretchKeepAspect
		};
		return _struct;
	};
	
	#region jsDoc
	/// @func __ensure_elem_polling()
	/// @desc Ensures a one-frame polling loop exists until elementId becomes valid.
	/// @returns {Undefined}
	#endregion
	static __ensure_elem_polling = function() {
		if (__elem_valid) { return; }
		if (__is_polling_elem) { return; }
		
		// ensure that we have done our first build, as some functions directly use rebuild,
		// while others attempt to simply set an instance or layer value
		var _s = flexpanel_node_get_struct(node_handle);
		if (!variable_struct_exists(_s, "layerElements"))
		|| (!is_array(_s.layerElements))
		|| (array_length(_s.layerElements) == 0) {
			rebuild_node(to_struct());
			return;
		}
		
		__is_polling_elem = true;
		
		__elem_timesource ??= call_later(
			1,
			time_source_units_frames,
			function() {
				var _s = flexpanel_node_get_struct(node_handle);
				var _elem = _s.layerElements[0].elementId;
			
				if (_elem == -1) { return -1; }
				
				__validate_elem(_elem);
				
				return elementId;
			},
			true
		);
	};
	
	#region jsDoc
	/// @func __validate_elem()
	/// @desc Marks element id valid changing elementId.
	///        elementId is only written by __poll_elem().
	/// @returns {Undefined}
	#endregion
	static __validate_elem = function(_elem)
	{
		elementId = _elem;
		__elem_valid = true;
		__is_polling_elem = false;

		if (__elem_timesource != undefined) {
			if (time_source_exists(__elem_timesource)) {
				time_source_stop(__elem_timesource);
				time_source_destroy(__elem_timesource);
			}
			__elem_timesource = undefined;
		}
		
		array_reverse(__call_on_elem_exist);
		repeat (array_length(__call_on_elem_exist)) {
			var _fn = array_pop(__call_on_elem_exist);
			_fn(_elem);
		}
	};
	
	#region jsDoc
	/// @func __invalidate_elem()
	/// @desc Marks element id invalid without changing elementId.
	///        elementId is only written by __poll_elem().
	/// @returns {Undefined}
	#endregion
	static __invalidate_elem = function()
	{
		elementId = -1;
		__elem_valid = false;
		__is_polling_elem = false;

		if (__elem_timesource != undefined)
		{
			if (time_source_exists(__elem_timesource))
			{
				time_source_stop(__elem_timesource);
				time_source_destroy(__elem_timesource);
			}
			__elem_timesource = undefined;
		}
	};
	
	#endregion
}


