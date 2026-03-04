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
		
		// Skip rebuilding because its not finished initializing yet.
		if (instanceObjectIndex == noone) { return self; }
		
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
		
		call_on_instance_ready(function(_inst) {
			instanceId.x = instanceOffsetX;
			instanceId.y = instanceOffsetY;
		});
		
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
		
		call_on_instance_ready(function(_inst) {
			_inst.image_xscale = instanceScaleX;
			_inst.image_yscale = instanceScaleY;
		});
		
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
		
		call_on_instance_ready(function(_inst) {
			_inst.image_speed = instanceImageSpeed;
		});
		
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
		
		call_on_instance_ready(function(_inst) {
			_inst.image_index = instanceImageIndex;
		});
		
		return self;
	};

	#region jsDoc
	/// @func set_instance_color(_col)
	/// @desc Sets instance color tint. IDE: "Colour".
	/// @param {Int} _col Color value.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_color = function(_col) {
		var _unsigned = (_col & 0x00FFFFFF) | 0xFF000000;
		_unsigned -= 0x100000000;
		
		if (instanceColour == _unsigned) { return self; }
		
		instanceColour = _unsigned;
		image_blend = _col;
		
		call_on_instance_ready(function(_inst) {
			instanceId.image_blend = image_blend;
		});
		
		return self;
	};
	static set_instance_colour = set_instance_color;
	
	#region jsDoc
	/// @func set_instance_angle(_ang)
	/// @desc Sets instance angle in degrees. IDE: "Rotation".
	/// @param {Real} _ang Angle in degrees.
	/// @return {ReflexLeafObject}
	#endregion
	static set_instance_angle = function(_ang) {
		if (instanceAngle == _ang) { return self; }
		instanceAngle = _ang;
		
		call_on_instance_ready(function(_inst) {
			_inst.image_angle = instanceAngle;
		});
		
		return self;
	};
	
	/// TODO:
	/// GM BUG: This is disabled until one of the two following bugs are resolved by GM
	// https://github.com/YoYoGames/GameMaker-Bugs/issues/14199
	// https://github.com/YoYoGames/GameMaker-Bugs/issues/14200
	#region jsDoc
	/// @func set_visible(_enabled)
	/// @desc Enables/disables layout participation for this node by setting its flexpanel display.
	///        true  -> display flex
	///        false -> display none (removed from layout calculations)
	/// @param {Bool} _enabled
	/// @return {Struct.Reflex}
	#endregion
	static set_visible = function(_enabled) {
		if (flexVisible == _enabled) { return self; }
		
		static __base_set_visible = Reflex.set_visible;
		__base_set_visible(_enabled);
		
		call_on_instance_ready(function(_inst) {
			_inst.visible = flexVisible;
		});
		
		return self;
	};
	
	//#region jsDoc
	///// @func set_instance_id(_id)
	///// @desc Sets the instance id reference value. IDE: "Instance".
	///// @param {Real} _id Instance id.
	///// @return {ReflexLeafObject}
	//#endregion
	//static set_instance_id = function(_id) {
	//	if (instanceId == _id) { return self; }
		
	//	if (instance_exists(instanceId)) {
	//		instance_destroy(instanceId);
	//	}
		
	//	instanceId = _id;
		
	//	call_on_instance_ready(function(_inst) {
	//		_inst.x = instanceOffsetX;
	//		_inst.y = instanceOffsetY;

	//		_inst.image_xscale = instanceScaleX;
	//		_inst.image_yscale = instanceScaleY;

	//		_inst.image_speed = instanceImageSpeed;
	//		_inst.image_index = instanceImageIndex;

	//		_inst.image_blend = instanceColour;
	//		_inst.image_angle = instanceAngle;
	//	});
		
	//	return self;
	//};
	
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
	/// @func    get_instance_id()
	/// @desc    Returns the UI layer Instance element's instance id once it exists.
	///
	///          Important:
	///          - UI layer Instance elements may not create their backing instance on the first frame.
	///          - If the instance does not exist yet, this function schedules a one-frame retry and
	///            returns undefined.
	///          - When the instance becomes available, any callbacks registered via
	///            `call_on_instance_ready()` are executed (in original registration order),
	///            and the internal retry time source is cleaned up.
	///
	/// @self    ReflexObject
	/// @returns {Real|Undefined}
	#endregion
	static get_instance_id = function() { return instanceId; };
	
	#endregion
	
	#region Functions
	
	#region jsDoc
	/// @func    call_on_instance_ready()
	/// @desc    Registers a callback to run once the UI layer Instance element has created its backing instance.
	///
	///          - If the instance already exists, the callback runs immediately.
	///          - If it does not exist yet, the callback is queued and will run automatically the first
	///            time get_instance_id() observes a valid instance id.
	///          - This is intended for initialization that must touch instance variables (step/draw
	///            injection, input handlers, etc.) without requiring the caller to manually poll.
	///
	///          Note:
	///          - The callback is invoked as _fn(_instance_id) where _instance_id is the instance id.
	/// @self    ReflexObject
	/// @param   {Method|Function} _fn : Function to run when the instance exists. Called as _fn(_instance_id).
	/// @returns {Struct.ReflexObject}
	#endregion
	static call_on_instance_ready = function(_fn){
		if (__inst_valid) {
			_fn(instanceId);
			return self;
		}
		
		array_push(__call_on_inst_exist, _fn);
		__ensure_inst_polling();
		return self;
	};
	
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
	
	//array used to allow for calling when the instance finally exists.
	__inst_timesource = undefined;
	__is_polling_inst = false;
	__inst_valid = false;
	__inst_valid_delay = 10;
	__call_on_inst_exist = [];
	
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
	///        Important:
	///        - Does not write elementId or instanceId.
	///        - Invalidates instance and restarts polling.
	/// @param {Struct} _element_struct
	#endregion
	#endregion
	static rebuild_node = function(_element_struct)
	{
		//if (__parent == undefined && __in_ui_layer = false) {
		//	__invalidate_inst();
		//	return;
		//}
		
		static __base_rebuild_node = ReflexLeaf.rebuild_node;
		__base_rebuild_node(_element_struct);
		
		//invalidate elementId and re-poll for existance again
		var _s = flexpanel_node_get_struct(node_handle);
		var _inst = _s.layerElements[0].instanceId;
		
		if (!instance_exists(_inst) || _inst == -1) {
			__invalidate_inst();
			__ensure_inst_polling();
		}
		else {
			__validate_inst(_inst);
		}
		
		
	};
	
	#region jsDoc
	/// @func __ensure_inst_polling()
	/// @desc Ensures a one-frame polling loop exists until instanceId becomes valid.
	/// @returns {Undefined}
	#endregion
	#endregion
	static __ensure_inst_polling = function() {
		// ensure that we have done our first build, as some functions directly use rebuild,
		// while others attempt to simply set an instance or layer value
		var _s = flexpanel_node_get_struct(node_handle);
		if (!variable_struct_exists(_s, "layerElements"))
		|| (!is_array(_s.layerElements))
		|| (array_length(_s.layerElements) == 0) {
			rebuild_node(to_struct());
			return;
		}
		
		if (__inst_valid) { return; }
		if (__is_polling_inst) { return; }
		
		
		__is_polling_inst = true;
		
		__inst_timesource ??= call_later(
			1,
			time_source_units_frames,
			function() {
				var _s = flexpanel_node_get_struct(node_handle);
				var _inst = _s.layerElements[0].instanceId;
			
				if (_inst == -1 || _inst == noone) { return -1; }
				
				__validate_inst(_inst);
				
				return instanceId;
			},
			true
		);
	};
	
	#region jsDoc
	/// @func __validate_inst()
	/// @desc Marks element id valid changing instanceId.
	///        instanceId is only written by __poll_elem().
	/// @returns {Undefined}
	#endregion
	static __validate_inst = function(_inst)
	{
		if (!instance_exists(_inst) || _inst == -1 || _inst == noone) { return; }
		
		instanceId = _inst;
		__inst_valid = true;
		__is_polling_inst = false;
		
		if (__inst_timesource != undefined) {
			//if (time_source_exists(__inst_timesource)) {
			//	time_source_stop(__inst_timesource);
				time_source_destroy(__inst_timesource);
			//}
			__inst_timesource = undefined;
		}
		
		array_reverse(__call_on_inst_exist);
		repeat (array_length(__call_on_inst_exist)) {
			var _fn = array_pop(__call_on_inst_exist);
			_fn(_inst);
		}
		
		// TODO:
		// Ideally this wouldnt be needed,
		// but currently there is no way to disable visibility of an object,
		// please see linked bugs in set_visible in both this script and base Reflex script
		_inst.visible = flexVisible;
		
	};
	
	#region jsDoc
	/// @func __invalidate_inst()
	/// @desc Marks element id invalid without changing instanceId.
	///        instanceId is only written by __poll_elem().
	/// @returns {Undefined}
	#endregion
	static __invalidate_inst = function()
	{
		__inst_valid_delay = 10;
		instanceId = noone;
		__inst_valid = false;
		__is_polling_inst = false;

		if (__inst_timesource != undefined)
		{
			if (time_source_exists(__inst_timesource))
			{
				time_source_stop(__inst_timesource);
				time_source_destroy(__inst_timesource);
			}
			__inst_timesource = undefined;
		}
	};
	
	
	
	// Init
	instanceObjectIndex = _object;
	#endregion
}
