#region jsDoc
/// @desc
///		ReflexAspectRatioContainer preserves a target aspect ratio for its primary child.
///
///		This container uses fit_child_in_rect() to force the first child into a computed rect.
///		It does not override attempt_reflow(). Instead, call sync_layout() after layout is available
///		(typically once per frame in Step or Draw GUI).
///
///		Supported stretch modes (Godot-inspired):
///		0 STRETCH_WIDTH_CONTROLS_HEIGHT
///		1 STRETCH_HEIGHT_CONTROLS_WIDTH
///		2 STRETCH_FIT
///		3 STRETCH_COVER
///
///		Supported alignment modes:
///		0 BEGIN, 1 CENTER, 2 END
///
#endregion
function ReflexAspectRatioContainer(_data=undefined) : ReflexContainer(_data) constructor
{
	
	#region jsDoc
	/// @func    set_ratio()
	/// @desc    Sets the aspect ratio (width / height) to enforce.
	/// @self    ReflexAspectRatioContainer
	/// @param   {Real} _value : Aspect ratio (width / height). Clamped to > 0.
	/// @returns {Struct.ReflexAspectRatioContainer}
	#endregion
	static set_ratio = function(_value)
	{
		__ratio = max(0.000001, _value);
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @func    get_ratio()
	/// @desc    Returns the current aspect ratio (width / height).
	/// @self    ReflexAspectRatioContainer
	/// @returns {Real}
	#endregion
	static get_ratio = function()
	{
		return __ratio;
	};

	#region jsDoc
	/// @func    set_stretch_mode()
	/// @desc    Sets the stretch mode (0..3).
	/// @self    ReflexAspectRatioContainer
	/// @param   {Real} _mode : 0 width->height, 1 height->width, 2 fit, 3 cover.
	/// @returns {Struct.ReflexAspectRatioContainer}
	#endregion
	static set_stretch_mode = function(_mode)
	{
		__stretch_mode = clamp(floor(_mode), 0, 3);
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @func    get_stretch_mode()
	/// @desc    Returns the stretch mode (0..3).
	/// @self    ReflexAspectRatioContainer
	/// @returns {Real}
	#endregion
	static get_stretch_mode = function()
	{
		return __stretch_mode;
	};

	#region jsDoc
	/// @func    set_alignment_horizontal()
	/// @desc    Sets horizontal alignment (0 begin, 1 center, 2 end) for the fitted rect.
	/// @self    ReflexAspectRatioContainer
	/// @param   {Real} _mode : 0 begin, 1 center, 2 end.
	/// @returns {Struct.ReflexAspectRatioContainer}
	#endregion
	static set_alignment_horizontal = function(_mode)
	{
		__align_horz = clamp(floor(_mode), 0, 2);
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @func    set_alignment_vertical()
	/// @desc    Sets vertical alignment (0 begin, 1 center, 2 end) for the fitted rect.
	/// @self    ReflexAspectRatioContainer
	/// @param   {Real} _mode : 0 begin, 1 center, 2 end.
	/// @returns {Struct.ReflexAspectRatioContainer}
	#endregion
	static set_alignment_vertical = function(_mode)
	{
		__align_vert = clamp(floor(_mode), 0, 2);
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @func    get_alignment_horizontal()
	/// @desc    Returns horizontal alignment (0..2).
	/// @self    ReflexAspectRatioContainer
	/// @returns {Real}
	#endregion
	static get_alignment_horizontal = function()
	{
		return __align_horz;
	};

	#region jsDoc
	/// @func    get_alignment_vertical()
	/// @desc    Returns vertical alignment (0..2).
	/// @self    ReflexAspectRatioContainer
	/// @returns {Real}
	#endregion
	static get_alignment_vertical = function()
	{
		return __align_vert;
	};

	#region jsDoc
	/// @func    get_primary_child()
	/// @desc    Returns the first child node, or undefined if there are no children.
	/// @self    ReflexAspectRatioContainer
	/// @returns {Struct.ReflexUI|Undefined}
	#endregion
	static get_primary_child = function()
	{
		if (array_length(__children) <= 0) { return undefined; }
		return __children[0];
	};

	#region jsDoc
	/// @func    sync_layout()
	/// @desc    Fits the primary child into a rect computed from this container's current layout.
	///          Call after layout is available (after UI layer updates, or after attempt_reflow()).
	/// @self    ReflexAspectRatioContainer
	/// @returns {Bool}
	#endregion
	static sync_layout = function()
	{
		var _child = get_primary_child();
		if (_child == undefined) { return false; }
		
		var _cw = max(0, w);
		var _ch = max(0, h);
		if (_cw <= 0 || _ch <= 0) { return false; }
		
		var _target_w = _cw;
		var _target_h = _ch;
		
		switch (__stretch_mode) {
			case 0: {
				// width controls height
				_target_w = _cw;
				_target_h = _target_w / __ratio;
			break;}
			case 1: {
				// height controls width
				_target_h = _ch;
				_target_w = _target_h * __ratio;
			break;}
			case 2: {
				// fit inside
				var _fit_w = _cw;
				var _fit_h = _fit_w / __ratio;

				if (_fit_h > _ch) {
					_fit_h = _ch;
					_fit_w = _fit_h * __ratio;
				}

				_target_w = _fit_w;
				_target_h = _fit_h;
			break; }
			case 3: {
				// cover
				var _cov_w = _cw;
				var _cov_h = _cov_w / __ratio;

				if (_cov_h < _ch) {
					_cov_h = _ch;
					_cov_w = _cov_h * __ratio;
				}

				_target_w = _cov_w;
				_target_h = _cov_h;
			}
		}
		
		var _off_x = 0;
		var _off_y = 0;
		
		if (__align_horz == 1) { _off_x = (_cw - _target_w) * 0.5; }
		else if (__align_horz == 2) { _off_x = (_cw - _target_w); }
		
		if (__align_vert == 1) { _off_y = (_ch - _target_h) * 0.5; }
		else if (__align_vert == 2) { _off_y = (_ch - _target_h); }
		
		var _rect = {
			x: _off_x,
			y: _off_y,
			w: _target_w,
			h: _target_h
		};

		fit_child_in_rect(_child, _rect);
		return true;
	};
	
	#region Private
	
	__ratio = 1.0;
	__stretch_mode = 2;

	__align_horz = 1;
	__align_vert = 1;

	set_display(flexpanel_display.flex);
	
	#endregion
}