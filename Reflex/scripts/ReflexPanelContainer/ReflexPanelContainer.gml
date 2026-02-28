#region jsDoc
/// @desc
///		ReflexPanelContainer provides a background panel behind its children.
///		Layout-wise it is a normal container; rendering is handled by a private ReflexSprite.
///
///		Implementation:
///		- A private ReflexSprite child is inserted at index 0 and set to absolute fill.
///		- All user children appear above it.
///
#endregion
function ReflexPanelContainer(_data=undefined) : ReflexContainer(_data) constructor
{
	
	#region jsDoc
	/// @func    set_panel_sprite()
	/// @desc    Sets the background panel sprite.
	/// @self    ReflexPanelContainer
	/// @param   {Asset.GMSprite} _sprite : Sprite asset (or noone to clear).
	/// @param   {Real} _index : Subimage index.
	/// @returns {Struct.ReflexPanelContainer}
	#endregion
	static set_panel_sprite = function(_sprite, _index=0)
	{
		__panel_sprite.set_sprite(_sprite, _index);
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @func    get_panel_sprite_node()
	/// @desc    Returns the internal ReflexSprite used for the panel background.
	/// @self    ReflexPanelContainer
	/// @returns {Struct.ReflexSprite}
	#endregion
	static get_panel_sprite_node = function()
	{
		return __panel_sprite;
	};

	#region jsDoc
	/// @func    set_panel_maintain_aspect()
	/// @desc    Controls whether the panel sprite maintains its aspect ratio while filling.
	/// @self    ReflexPanelContainer
	/// @param   {Bool} _enabled : Maintain aspect ratio if true.
	/// @returns {Struct.ReflexPanelContainer}
	#endregion
	static set_panel_maintain_aspect = function(_enabled)
	{
		__panel_sprite.set_maintain_aspect(_enabled == true);
		return self;
	};
	
	#region Private
	
	set_display(flexpanel_display.flex);
	
	// Background sprite node
	__panel_sprite = new ReflexSprite();
	__panel_sprite.set_name("PanelSprite" + string(__panel_sprite.__uuid));
	insert(__panel_sprite, 0);
	
	// Fill parent
	__panel_sprite.set_position_type(flexpanel_position_type.absolute);
	__panel_sprite.set_position(flexpanel_edge.left, 0, flexpanel_unit.point);
	__panel_sprite.set_position(flexpanel_edge.top, 0, flexpanel_unit.point);
	__panel_sprite.set_width(100, flexpanel_unit.percent);
	__panel_sprite.set_height(100, flexpanel_unit.percent);
	
	// Default: preserve sprite aspect if desired (caller can change)
	__panel_sprite.set_maintain_aspect(false);
	
	#endregion
}