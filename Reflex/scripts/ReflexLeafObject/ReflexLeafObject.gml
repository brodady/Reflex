#region jsDoc
/// @func ReflexLeafObject()
/// @desc Specialized leaf node for native GameMaker instance rendering ("Instance" layer element).
/// @return {ReflexLeafObject}
#endregion
function ReflexLeafObject() : ReflexLeaf() constructor 
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
		
		ensure_node();
		
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
		
		//i dont care to learn how x/y works on various ui layers depending on gui scaling, and viewports, this just resolves it all with little headache
		ensure_node();
		
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
		
		if (__inst_valid) {
			_inst.image_xscale = instanceScaleX;
			_inst.image_yscale = instanceScaleY;
		};
		
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
		
		if (__inst_valid) {
			_inst.image_speed = _spd;
		};
		
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
		
		if (__inst_valid) {
			_inst.image_index = _ind;
		};
		
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
		
		if (__inst_valid) {
			instanceId.image_blend = _col;
		};
		
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
		
		if (__inst_valid) {
			instanceId.image_angle = _ang;
		}
		
		return self;
	};
	
	#region jsDoc
	/// @func    set_variable(_name, _value)
	/// @desc    Writes an instance variable definition to the wrapped ReflexLeafObject.
	///          If the runtime instance already exists, the live instance value is updated too.
	/// @self    ReflexLeafObject
	/// @param   {String} _name
	/// @param   {Any} _value
	/// @returns {Struct.ReflexLeafObject}
	#endregion
	static set_variable = function(_name, _value) {
		
		// https://github.com/YoYoGames/GameMaker-Bugs/issues/14272
		if (__is_settable_var(_name)) {
			_name = _name + "__";
		}
		else if (__is_gettable_var(_name)) {
			throw $"\n\n\nReflex :: Unable to set variable `{_name}`, this is a read only variable.\n\n"
		}
		
		instanceVariables[$ _name] = _value;
		
		if (__is_built) {
			if (__inst_valid) {
				instanceId[$ _name] = _value;
			}
			else {
				var _self = self;
				call_on_instance_ready(method({_self, _name, _value}, function(){
					_self.instanceId[$ _name] = _value;
				}))
			}
		}
		
		return self;
	};
	

	#region Built in Variables
	
	#region General Variables
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
		
		set_variable("visible", _enabled)
		
		return self;
	};
	static set_solid = function(_solid) {
		set_variable("solid", _solid)
		return self;
	}
	static set_persistent = function(_persistent) {
		set_variable("persistent", _persistent)
		return self;
	}
	static set_depth = function(_depth) {
		set_variable("depth", _depth)
		return self;
	}
	static set_layer = function(_layer) {
		set_variable("layer", _layer)
		return self;
	}
	static set_collision_space = function(_collision_space) {
		set_variable("collision_space", _collision_space)
		return self;
	}
	static set_alarm = function(_index, _count) {
		if (__inst_valid) {
			instanceId.alarm[_index] = _count;
		}
		else {
			call_on_instance_ready(method({_index, _count}, function(_inst) {
				_inst.alarm[_index] = _count;
			}))
		}
		return self;
	}
	#endregion
	
	#region Movement And Position
	// ReflexUI will not support movement setters.
	#endregion 
	
	#region Object Properties
	static set_object_index = set_instance_object;
	#endregion 
	
	#region Sprite Properties
	static set_sprite_index = function(_sprite_index) {
		set_variable("sprite_index", _sprite_index)
		set_variable("mask_index", _sprite_index)
		return self;
	}
	static set_image_alpha = function(_image_alpha) {
		set_variable("image_alpha", _image_alpha)
		return self;
	}
	static set_image_angle = set_instance_angle;
	static set_image_blend = set_instance_color;
	static set_image_index = set_instance_image_index;
	static set_image_number = function(_image_number) {
		set_variable("image_number", _image_number)
		return self;
	}
	static set_image_speed = set_instance_image_speed;
	static set_image_xscale = function(_image_xscale) {
		set_variable("image_xscale", _image_xscale)
		return self;
	}
	static set_image_yscale = function(_image_yscale) {
		set_variable("image_yscale", _image_yscale)
		return self;
	}
	#endregion
	
	#endregion
	
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
	/// @func get_instance_color()
	/// @desc Gets the instance color value.
	/// @returns {Real}
	#endregion
	static get_instance_color = function() { return instanceColour; };
	static get_instance_colour = get_instance_color;
	
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
	
	#region jsDoc
	/// @func    get_variable(_name)
	/// @desc    Gets an instance variable definition to the wrapped ReflexLeafObject.
	///          If the runtime instance doesnt exists, undefined is returned instead.
	/// @self    ReflexLeafObject
	/// @param   {String} _name
	/// @param   {Any} _value
	/// @returns {Struct.ReflexLeafObject}
	#endregion
	static get_variable = function(_name) {
		if (__is_settable_var(_name)) {
			_name = string_replace(_name, "__", "");
		}
		
		if (__inst_valid) {
			return instanceId[$ _name];
		}
		else {
			return undefined
		}
	};
	
	#region Built in Variables
	
	#region General Variables
	//static get_visible SEE:: Reflex.get_visible
	static get_id = get_instance_id;
	static get_solid = function() { return get_variable("solid"); }
	static get_persistent = function() { return get_variable("persistent"); }
	static get_depth = function() { return get_variable("depth"); }
	static get_layer = function() { return get_variable("layer"); }
	static get_on_ui_layer = function() { return get_variable("on_ui_layer"); }
	static get_collision_space = function() { return get_variable("collision_space"); }
	static get_alarm = function() { return get_variable("alarm"); }
	#endregion
	
	#region Movement And Position
	static get_direction = function() { return get_variable("direction"); }
	static get_friction = function() { return get_variable("friction"); }
	static get_gravity = function() { return get_variable("gravity"); }
	static get_gravity_direction = function() { return get_variable("gravity_direction"); }
	static get_hspeed = function() { return get_variable("hspeed"); }
	static get_vspeed = function() { return get_variable("vspeed"); }
	static get_speed = function() { return get_variable("speed"); }
	static get_xstart = function() { return get_variable("xstart"); }
	static get_ystart = function() { return get_variable("ystart"); }
	static get_x = function() { return get_variable("x"); }
	static get_y = function() { return get_variable("y"); }
	static get_xprevious = function() { return get_variable("xprevious"); }
	static get_yprevious = function() { return get_variable("yprevious"); }
	#endregion 
	
	#region Object Properties
	static get_object_index = function() { return get_variable("object_index"); }
	#endregion 
	
	#region Sprite Properties
	static get_sprite_index = function() { return get_variable("sprite_index"); }
	static get_sprite_width = function() { return get_variable("sprite_width"); }
	static get_sprite_height = function() { return get_variable("sprite_height"); }
	static get_sprite_xoffset = function() { return get_variable("sprite_xoffset"); }
	static get_sprite_yoffset = function() { return get_variable("sprite_yoffset"); }
	static get_image_alpha = function() { return get_variable("image_alpha"); }
	static get_image_angle = get_instance_angle;
	static get_image_blend = get_instance_color;
	static get_image_index = get_instance_image_index;
	static get_image_number = function() { return get_variable("image_number"); }
	static get_image_speed = get_instance_image_speed;
	static get_image_xscale = get_instance_scale_x;
	static get_image_yscale = get_instance_scale_y;
	#endregion
	
	#endregion
	
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
	instanceVariables = {
		
		// The reason we prefix everything with underscores here is specifically because built in variables are ignored by `flexpanel_create_node`... for some reason...
		// https://github.com/YoYoGames/GameMaker-Bugs/issues/14272
		
		#region Built in Variables
	
		#region General Variables
		//id = ref instance 100001; Can fetch this, but cant set
		//visible = 1; SEE:: `Reflex.visible`
		__solid: 0,
		__persistent: 0,
		__depth: 0,
		__layer: -1,
		//on_ui_layer = 1; Can fetch this, but cant set (also should always be true)
		__collision_space: colspace.ui_display, // ideally will always be colspace.ui_display
		//alarm = -1; Can fetch this, but cant set before instance exists
		#endregion

		#region Movement And Position
		//Can fetch these, but wont support setting
		//direction = 0,
		//friction = 0,
		//gravity = 0,
		//gravity_direction = 270,
		//hspeed = 0,
		//vspeed = 0,
		//speed = 0,
		//xstart = 0,
		//ystart = 0,
		//x = 0,
		//y = 0,
		//xprevious = 0,
		//yprevious = 0,
		#endregion 

		#region Object Properties
		//object_index = ref object Object4; SEE:: instanceObjectIndex
		#endregion 

		#region Sprite Properties
		__sprite_index: -1,
		//sprite_width = 0, Can fetch this, but cant set
		//sprite_height = 0, Can fetch this, but cant set
		//sprite_xoffset = 0, Can fetch these, but cant set them
		//sprite_yoffset = 0, Can fetch these, but cant set them
		__image_alpha: 1,
		//image_angle = 0, SEE:: instanceAngle
		//image_blend = c_white, SEE:: instanceColour
		//image_index = 0, SEE:: instanceImageIndex
		__image_number: 1,
		//image_speed = 1, SEE:: instanceImageSpeed
		//image_xscale = 5, SEE:: instanceScaleX
		//image_yscale = 5, SEE:: instanceScaleY
		#endregion
	
		#endregion
		
	}; // "Variables" - instance variable overrides are stored here
	
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
		_base_struct.instanceObjectIndex = (instanceObjectIndex == noone) ? __obj_reflex_null_object : instanceObjectIndex;
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
	static rebuild_node = function(_element_struct=to_struct())
	{
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
	static __ensure_inst_polling = function() {
		// ensure that we have done our first build, as some functions directly use rebuild,
		// while others attempt to simply set an instance or layer value
		var _s = flexpanel_node_get_struct(node_handle);
		if (!variable_struct_exists(_s, "layerElements"))
		|| (!is_array(_s.layerElements))
		|| (array_length(_s.layerElements) == 0) {
			rebuild_node();
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
		if (!instance_exists(_inst))
		|| (_inst == -1)
		|| (_inst == noone)
		|| (_inst.object_index == __obj_reflex_null_object) // flexpanels cant take in `noone` so we use a null object ref
		{ return; }
		
		
		instanceId = _inst;
		__inst_valid = true;
		__is_polling_inst = false;
		
		if (__inst_timesource != undefined) {
			if (time_source_exists(__inst_timesource)) {
				time_source_stop(__inst_timesource);
				time_source_destroy(__inst_timesource);
			}
			__inst_timesource = undefined;
		}
		
		array_reverse(__call_on_inst_exist);
		repeat (array_length(__call_on_inst_exist)) {
			var _fn = array_pop(__call_on_inst_exist);
			_fn(_inst);
		}
		
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
	
	static __is_gm_built_in_var = function(_name)
	{
		return (__is_settable_var(_name) || __is_gettable_var(_name))
	}
	static __is_settable_var = function(_name)
	{
		static __set_vars = ["alarm", "depth", "direction", "friction", "gravity", "gravity_direction", "hspeed", "layer", "persistent", "solid", "speed", "vspeed", "x", "xprevious", "xstart", "y", "yprevious", "ystart", "path_endaction", "path_orientation", "path_position", "path_positionprevious", "path_scale", "path_speed", "in_sequence", "drawn_by_sequence", "image_alpha", "image_angle", "image_blend", "image_index", "image_speed", "image_xscale", "image_yscale", "mask_index", "sprite_index", "timeline_index", "timeline_loop", "timeline_position", "timeline_running", "timeline_speed", "phy_active", "phy_angular_damping", "phy_angular_velocity", "phy_bullet", "phy_fixed_rotation", "phy_linear_damping", "phy_linear_velocity_x", "phy_linear_velocity_y", "phy_position_x", "phy_position_y", "phy_rotation", "phy_speed_x", "phy_speed_y"]
		return (array_get_index(__set_vars, _name) != -1);
		//return array_contains(__set_vars, _name);
	}
	static __is_gettable_var = function(_name)
	{
		static __get_vars = ["id", "on_ui_layer", "object_index", "event_number", "event_object", "event_type", "sequence_instance", "bbox_bottom", "bbox_left", "bbox_right", "bbox_top", "collision_space", "image_number", "sprite_height", "sprite_width", "sprite_xoffset", "sprite_yoffset", "phy_collision_points", "phy_collision_x", "phy_collision_y", "phy_col_normal_x", "phy_col_normal_y", "phy_com_x", "phy_com_y", "phy_dynamic", "phy_inertia", "phy_kinematic", "phy_mass", "phy_position_xprevious", "phy_position_yprevious", "phy_sleeping", "phy_speed", "in_collision_tree", "player_id", "player_local", "player_avatar_url", "player_avatar_sprite", "player_type", "player_user_id"];
		return (array_get_index(__get_vars, _name) != -1);
		//return array_contains(__get_vars, _name);
	}
	
	#endregion
}


