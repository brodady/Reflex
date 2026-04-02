#region jsDoc
/// @func ReflexLeafSprite(_sprite, _index)
/// @desc Specialized leaf node for native GameMaker sprite rendering.
/// @param {Asset.GMSprite} _sprite The sprite asset to assign.
/// @param {Real} [_index]=0 The initial subimage index.
/// @return {ReflexLeafSprite}
#endregion
function ReflexLeafSprite(_sprite=__spr_reflex, _index = 0) : ReflexLeaf() constructor 
{
    #region Setters
	
	#region jsDoc
	/// @func set_sprite_sprite(_spr, _ind)
	/// @desc Sets the sprite asset, optionally updating the initial frame. IDE: "Frame".
	/// @param {Asset.GMSprite} spr : Sprite asset.
	/// @param {Real} ind : Subimage index.
	/// @return {ReflexLeafSprite}
	#endregion
    static set_sprite_sprite = function(_spr, _ind=undefined) {
		if (spriteIndex == _spr) {
			if (_ind == undefined)
			&& (spriteImageIndex == 0) {
				return self;
			}
			if (spriteImageIndex == _ind) {
				return self;
			}
		}
		
		spriteIndex = _spr;
		spriteImageIndex = (_ind != undefined) ? _ind : 0;
		
		call_on_element_ready(function(_elem) {
			layer_sprite_change(elementId, spriteIndex);
			layer_sprite_index(elementId, spriteImageIndex);
		})

		return self;
	};
	
	///////////////////////////////////////////////////
	#region jsDoc
	/// @func set_sprite_offsets(_x, _y)
	/// @desc Sets sprite position offsets. IDE: "Position - X", "Position - Y".
	/// @param {Real} x : X value.
	/// @param {Real} y : Y value.
	/// @return {ReflexLeafSprite}
	#endregion
	static set_sprite_offsets = function(_x, _y) {
		if (spriteOffsetX == _x)
		&& (spriteOffsetY == _y) {
			return self;
		}
		
		spriteOffsetX = _x;
		spriteOffsetY = _y;
		
		// This does not keep relativity to flex panels, once set it becomes perminate
		call_on_element_ready(function(_elem) {
			layer_sprite_x(elementId, spriteOffsetX + get_layout_left());
			layer_sprite_y(elementId, spriteOffsetY + get_layout_top());
		})
		
		return self;
	};
	
	#region jsDoc
	/// @func set_sprite_scale(_x, _y)
	/// @desc Sets sprite scale. IDE: "Scale - X", "Scale - Y".
	/// @param {Real} x : X value.
	/// @param {Real} y : Y value.
	/// @return {ReflexLeafSprite}
	#endregion
	static set_sprite_scale = function(_x, _y = undefined) {
		if (spriteScaleX == _x) {
			if (_y == undefined)
			&& (spriteScaleY == _x) {
				return self;
			}
			if (spriteScaleY == _y) {
				return self;
			}
		}
		
		spriteScaleX = _x;
		spriteScaleY = (_y != undefined) ? _y : _x;
		
		call_on_element_ready(function(_elem) {
			layer_sprite_xscale(elementId, spriteScaleX);
			layer_sprite_yscale(elementId, spriteScaleY);
		})
		
		return self;
	};
	
	#region jsDoc
	/// @func set_sprite_rotation(_angle)
	/// @desc Sets sprite rotation in degrees. IDE: "Rotation".
	/// @param {Real} angle : Rotation angle in degrees.
	/// @return {ReflexLeafSprite}
	#endregion
	static set_sprite_rotation = function(_angle) {
		if (spriteAngle == _angle) { return self; }
		
		spriteAngle = _angle;
		
		call_on_element_ready(function(_elem) {
			layer_sprite_angle(elementId, spriteAngle);
		})
		
		return self;
	};
	
	#region jsDoc
	/// @func set_sprite_color(_col)
	/// @desc Sets sprite color tint. IDE: "Colour".
	/// @param {Int} col : Color value.
	/// @return {ReflexLeafSprite}
	#endregion
	static set_sprite_color = function(_col) {
		var _unsigned = (_col & 0x00FFFFFF) | 0xFF000000;
		_unsigned -= 0x100000000;
		_col = _unsigned
		
		if (spriteColour == _col) { return self; }
		
		spriteColour = _col;
		
		call_on_element_ready(function(_elem) {
			layer_sprite_blend(elementId, spriteColour);
		})
		
		return self;
	};
	static set_sprite_colour = set_sprite_color;
	
	#region jsDoc
	/// @func set_sprite_image(_index)
	/// @desc Sets the sprite frame (subimage). IDE: "Frame".
	/// @param {Real} index : Subimage index.
	/// @return {ReflexLeafSprite}
	#endregion
	static set_sprite_image = function(_index) {
		if (spriteImageIndex == _index) { return self; }
		
		spriteImageIndex = _index;
		
		call_on_element_ready(function(_elem) {
			layer_sprite_index(elementId, spriteImageIndex);
		})
		
		return self;
	};

	#region jsDoc
	/// @func set_sprite_speed(_spd, _speed_type)
	/// @desc Sets sprite animation speed, optionally overriding speed type. IDE: "Animation Speed".
	/// @param {Real} spd : Animation speed.
	/// @param {Real} speed_type : Speed type override.
	/// @return {ReflexLeafSprite}
	#endregion
	static set_sprite_speed = function(_spd, _speed_type=undefined) {
		if (spriteImageSpeed == _spd) { return self; }
		
		spriteImageSpeed = _spd;
		
		call_on_element_ready(function(_elem) {
			layer_sprite_speed(elementId, spriteImageSpeed);
		})
		
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
		
		ensure_node();
		
		return self;
	};
	
	#endregion
	
	#region Getters
	
	#region jsDoc
	/// @func get_sprite_sprite()
	/// @desc Gets the assigned sprite asset.
	/// @returns {Asset.GMSprite}
	#endregion
	static get_sprite_sprite = function() { return spriteIndex; };
	
	#region jsDoc
	/// @func get_sprite_image()
	/// @desc Gets the current subimage index.
	/// @returns {Real}
	#endregion
	static get_sprite_image = function() { return spriteImageIndex; };
	
	#region jsDoc
	/// @func get_sprite_offsets_x()
	/// @desc Gets the sprite X offset.
	/// @returns {Real}
	#endregion
	static get_sprite_offsets_x = function() { return spriteOffsetX; };
	
	#region jsDoc
	/// @func get_sprite_offsets_y()
	/// @desc Gets the sprite Y offset.
	/// @returns {Real}
	#endregion
	static get_sprite_offsets_y = function() { return spriteOffsetY; };
	
	#region jsDoc
	/// @func get_sprite_scale_x()
	/// @desc Gets the sprite X scale.
	/// @returns {Real}
	#endregion
	static get_sprite_scale_x = function() { return spriteScaleX; };
	
	#region jsDoc
	/// @func get_sprite_scale_y()
	/// @desc Gets the sprite Y scale.
	/// @returns {Real}
	#endregion
	static get_sprite_scale_y = function() { return spriteScaleY; };
	
	#region jsDoc
	/// @func get_sprite_rotation()
	/// @desc Gets the sprite rotation in degrees.
	/// @returns {Real}
	#endregion
	static get_sprite_rotation = function() { return spriteAngle; };
	
	#region jsDoc
	/// @func get_sprite_color()
	/// @desc Gets the sprite blend color (-1 means unset).
	/// @returns {Real}
	#endregion
	static get_sprite_color = function() { return spriteColour; };
	static get_sprite_colour = get_sprite_color;
	
	#region jsDoc
	/// @func get_sprite_speed()
	/// @desc Gets the sprite animation speed.
	/// @returns {Real}
	#endregion
	static get_sprite_speed = function() { return spriteImageSpeed; };
	
	#region jsDoc
	/// @func get_sprite_speed_type()
	/// @desc Gets the sprite speed type (-1 means infer from sprite).
	/// @returns {Real}
	#endregion
	static get_sprite_speed_type = function() { return spriteSpeedType; };
	
	#endregion
	
	
	#region Private
	
	#region Properties
	type = "Sprite";
	
	spriteIndex = _sprite; // -1 will prevent rebuilds until defiend
	
	spriteOffsetX = 0; // "Position - X"
	spriteOffsetY = 0; // "Position - Y"
	spriteScaleX = 1; // "Scale - X"
	spriteScaleY = 1; // "Scale - Y"
	spriteAngle = 0; // "Rotation"
	spriteColour = -1; // "Colour" -1 is used for unset, so it could adopt the current `draw_set_color`
	// THERE IS NO "FLIP", you must use Scale for this, this is also what the IDE actually does.
	spriteImageIndex = _index; // "Frame"
	spriteImageSpeed = sprite_get_speed(_sprite); // "Animation Speed"
	spriteSpeedType = sprite_get_speed_type(_sprite); // Not defined in IDE, a value of -1 will interpret from sprite on rebuild; 0 = fps, 1 = frames per gameframe
	#endregion
	
	#region jsDoc
	/// @func    to_struct()
	/// @desc    Builds a "Sprite" layerElements struct.
	/// @self    ReflexLayerElementSprite
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		static __base_to_struct = ReflexLeaf.to_struct;
		var _base_struct = __base_to_struct();
		
		//Sprite Specific Data
		_base_struct.spriteIndex = spriteIndex;
		_base_struct.spriteImageIndex = spriteImageIndex;
		
		_base_struct.spriteOffsetX = spriteOffsetX;
		_base_struct.spriteOffsetY = spriteOffsetY;
		
		_base_struct.spriteScaleX = spriteScaleX;
		_base_struct.spriteScaleY = spriteScaleY;
		
		_base_struct.spriteColour = spriteColour;
		_base_struct.spriteAngle = spriteAngle;
		
		_base_struct.spriteImageSpeed = spriteImageSpeed;
		_base_struct.spriteSpeedType = (spriteImageSpeed == -1) ? sprite_get_speed_type(spriteIndex) : spriteImageSpeed; // 0 = fps, 1 = frames per gameframe
		
		// The internal flex panel should do this, but not sure, leaving this hear if bugs arrise
		if (flexStretchWidth) { _base_struct.flexTileHorizontal = false; }
		if (flexStretchHeight) { _base_struct.flexTileVertical = false; }
		
		if (!flexVisible) {
			_base_struct.flexStretchWidth  = false;
			_base_struct.flexStretchHeight = false;
		}
		
		return _base_struct;
	};
	
	#endregion
}