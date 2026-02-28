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
	
	// Background sprite element (not a child node)
	__panel_sprite = new ReflexLayerElementSprite();
	__panel_sprite.set_common("Sprite", 1.0, 0.0); // elementId/elementOrder are your call

	// Make it behave like a full-background
	__panel_sprite.set_flex_flags(
		true,			// flexVisible
		"TopLeft",		// flexAnchor
		true,			// flexStretchWidth
		true,			// flexStretchHeight
		false,			// flexTileHorizontal
		false,			// flexTileVertical
		false			// flexStretchKeepAspect (default false)
	);

	// Insert as the first element so it draws behind other elements (order 0)
	insert_element(__panel_sprite, 0);
	
	#endregion
}