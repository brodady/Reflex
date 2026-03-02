#region jsDoc
/// @func ReflexLeafObject(_object)
/// @desc Specialized leaf node for native GameMaker instance rendering ("Instance" layer element).
/// @param {Asset.GMObject} [_object]=noone Object asset to assign.
/// @return {ReflexLeafObject}
#endregion
function ReflexLeafObject(_object=noone) : ReflexLeaf() constructor 
{
	#region Setters
	
	#region jsDoc
	/// @func set_instance_object(_obj)
	/// @desc Sets the instance object asset. IDE: "Object".
	/// @param {Asset.GMObject} _obj Object asset.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_object = function(_obj) {
		if (instanceObjectIndex == _obj) { return self; }
		
		instanceObjectIndex = _obj;
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
		rebuild_node(to_struct());
		return self;
	};
	
	#region jsDoc
	/// @func set_instance_offsets(_x, _y)
	/// @desc Sets instance position offsets. IDE: "Position - X", "Position - Y".
	/// @param {Real} _x X value.
	/// @param {Real} _y Y value.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_offsets = function(_x, _y) {
		if (instanceOffsetX == _x)
		&& (instanceOffsetY == _y) {
			return self;
		}
		
		instanceOffsetX = _x;
		instanceOffsetY = _y;
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
		rebuild_node(to_struct());
		return self;
	};
	
	#region jsDoc
	/// @func set_instance_scale(_x, _y)
	/// @desc Sets instance scale. IDE: "Scale - X", "Scale - Y".
	/// @param {Real} _x X value.
	/// @param {Real} [_y]=undefined Y value. If undefined, uses _x.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_scale = function(_x, _y=undefined) {
		if (instanceScaleX == _x) {
			if (_y == undefined)
			&& (instanceScaleY == _x) {
				return self;
			}
			if (instanceScaleY == _y) {
				return self;
			}
		}
		
		instanceScaleX = _x;
		instanceScaleY = (_y != undefined) ? _y : _x;
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
		rebuild_node(to_struct());
		return self;
	};
	
	#region jsDoc
	/// @func set_instance_image_speed(_spd)
	/// @desc Sets instance animation speed. IDE: "Animation Speed".
	/// @param {Real} _spd Animation speed.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_image_speed = function(_spd) {
		if (instanceImageSpeed == _spd) { return self; }
		
		instanceImageSpeed = _spd;
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
		rebuild_node(to_struct());
		return self;
	};
	
	#region jsDoc
	/// @func set_instance_image_index(_ind)
	/// @desc Sets instance image index (frame). IDE: "Frame".
	/// @param {Real} _ind Image index.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_image_index = function(_ind) {
		if (instanceImageIndex == _ind) { return self; }
		
		instanceImageIndex = _ind;
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
		rebuild_node(to_struct());
		return self;
	};
	
	#region jsDoc
	/// @func set_instance_colour(_col)
	/// @desc Sets instance color tint. IDE: "Colour".
	/// @param {Int} _col Color value.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_colour = function(_col) {
		var _unsigned = (_col & 0x00FFFFFF) | 0xFF000000;
		_unsigned -= 0x100000000;
		
		if (instanceColour == _unsigned) { return self; }
		
		instanceColour = _unsigned;
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
		rebuild_node(to_struct());
		return self;
	};
	static set_instance_color = set_instance_colour;
	
	#region jsDoc
	/// @func set_instance_angle(_ang)
	/// @desc Sets instance angle in degrees. IDE: "Rotation".
	/// @param {Real} _ang Angle in degrees.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_angle = function(_ang) {
		if (instanceAngle == _ang) { return self; }
		
		instanceAngle = _ang;
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
		rebuild_node(to_struct());
		return self;
	};
	
	#region jsDoc
	/// @func set_instance_id(_id)
	/// @desc Sets the instance id reference value. IDE: "Instance".
	/// @param {Real} _id Instance id.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_id = function(_id) {
		if (instanceId == _id) { return self; }
		
		if (instance_exists(instanceId)) {
			instance_destroy(instanceId);
		}
		
		instanceId = _id;
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
		rebuild_node(to_struct());
		return self;
	};
	
	#endregion
	
	#region Getters
	
	#region jsDoc
	/// @func get_instance_object()
	/// @desc Gets the assigned instance object asset.
	/// @returns {Asset.GMObject}
	#endregion
	static get_instance_object = function() { return instanceObjectIndex; };
	
	#region jsDoc
	/// @func get_instance_variables()
	/// @desc Gets the instanceVariables struct (no setter helpers provided).
	/// @returns {Struct}
	#endregion
	static get_instance_variables = function() { return instanceVariables; };
	
	#region jsDoc
	/// @func get_instance_offsets_x()
	/// @desc Gets the instance X offset.
	/// @returns {Real}
	#endregion
	static get_instance_offsets_x = function() { return instanceOffsetX; };
	
	#region jsDoc
	/// @func get_instance_offsets_y()
	/// @desc Gets the instance Y offset.
	/// @returns {Real}
	#endregion
	static get_instance_offsets_y = function() { return instanceOffsetY; };
	
	#region jsDoc
	/// @func get_instance_scale_x()
	/// @desc Gets the instance X scale.
	/// @returns {Real}
	#endregion
	static get_instance_scale_x = function() { return instanceScaleX; };
	
	#region jsDoc
	/// @func get_instance_scale_y()
	/// @desc Gets the instance Y scale.
	/// @returns {Real}
	#endregion
	static get_instance_scale_y = function() { return instanceScaleY; };
	
	#region jsDoc
	/// @func get_instance_image_speed()
	/// @desc Gets the instance image speed.
	/// @returns {Real}
	#endregion
	static get_instance_image_speed = function() { return instanceImageSpeed; };
	
	#region jsDoc
	/// @func get_instance_image_index()
	/// @desc Gets the instance image index.
	/// @returns {Real}
	#endregion
	static get_instance_image_index = function() { return instanceImageIndex; };
	
	#region jsDoc
	/// @func get_instance_colour()
	/// @desc Gets the instance color value.
	/// @returns {Real}
	#endregion
	static get_instance_colour = function() { return instanceColour; };
	static get_instance_color = get_instance_colour;
	
	#region jsDoc
	/// @func get_instance_angle()
	/// @desc Gets the instance angle in degrees.
	/// @returns {Real}
	#endregion
	static get_instance_angle = function() { return instanceAngle; };
	
	#region jsDoc
	/// @func get_instance_id()
	/// @desc Gets the instance id.
	/// @returns {Real}
	#endregion
	static get_instance_id = function() { return instanceId; };
	
	#endregion
	
	
	#region Private
	
	#region Properties
	type = "Instance";
	
	// Instance element specific
	instanceObjectIndex = noone; // "Object"
	instanceVariables = {}; // "Variables" - instance variable overrides are stored here
	
	instanceOffsetX = 0.0; // "Position - X"
	instanceOffsetY = 0.0; // "Position - Y"
	
	instanceScaleX = 1.0; // "Scale - X"
	instanceScaleY = 1.0; // "Scale - Y"
	
	instanceImageSpeed = 1.0; // "Animation Speed"
	instanceImageIndex = 0.0; // "Frame"
	
	instanceColour = -1.0; // "Colour" -1 is used for unset, so it could adopt the current draw state
	instanceAngle = 0.0; // "Rotation"
	
	instanceId = noone; // "Instance"
	
	#endregion
	
	#region jsDoc
	/// @func    to_struct()
	/// @desc    Builds an "Instance" layerElements struct.
	/// @self    ReflexLayerElementInstance
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		static __base_to_struct = ReflexLeaf.to_struct;
		var _base_struct = __base_to_struct();
		
		// Instance Specific Data
		_base_struct.instanceObjectIndex = instanceObjectIndex;
		_base_struct.instanceVariables = instanceVariables;
		
		_base_struct.instanceOffsetX = instanceOffsetX;
		_base_struct.instanceOffsetY = instanceOffsetY;
		
		_base_struct.instanceScaleX = instanceScaleX;
		_base_struct.instanceScaleY = instanceScaleY;
		
		_base_struct.instanceImageSpeed = instanceImageSpeed;
		_base_struct.instanceImageIndex = instanceImageIndex;
		
		_base_struct.instanceColour = instanceColour;
		_base_struct.instanceAngle = instanceAngle;
		
		_base_struct.instanceId = instanceId;
		
		return _base_struct;
	};
	
	#region jsDoc
    /// @func rebuild_node(_element_struct)
    /// @desc Recreates the native Flexpanel node to apply layerElement changes.
    /// @param {Struct} _element_struct The layerElements struct defining the type (Sprite/Text).
    #endregion
    static rebuild_node = function(_element_struct) {
		// NOTE: After importing lookup to check for memory leaks, it appears this code wasnt needed after all
		//var _s = flexpanel_node_get_struct(node_handle);
		//if (struct_exists(_s,  "layerElements") && is_array(_s.layerElements)) {
		//	var _elem = _s.layerElements[0]
		//
		//	if (_elem.instanceId == -1)
		//	&& (instance_exists(_elem.instanceId)) {
		//		instance_destroy(_elem.instanceId);
		//		if (instance_exists(_elem.instanceId)) {
		//			show_debug_message("still exists")
		//		}
		//	}
		//}
		
		static __base_rebuild_node = ReflexLeaf.rebuild_node;
		__base_rebuild_node(_element_struct);
		
		// Fetch the instance id, and set our value
		var _s = flexpanel_node_get_struct(node_handle);
		var _elem = _s.layerElements[0]
		//if (instanceId != _elem.instanceId) {
		//	show_debug_message($"Instance changed from [{instanceId}] to [{_elem.instanceId}]")
		//}
		
		// instance id gets changed every single rebuild, there is currently no way around this.
		instanceId = _elem.instanceId;
		
		if (instanceId == -1) {
			call_later(1, time_source_units_frames, function(){
				rebuild_node(to_struct());
			}, false)
		}
	}
	
	// Init
	//instanceObjectIndex = _object;
	//set_instance_id(instance_create_depth(0, 0, 0, _object));
	set_instance_object(_object);
	#endregion
}
