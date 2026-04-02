function ReflexUI(_data=undefined) : Reflex(_data) constructor
{
	// -------------------------------------------------------------------------
	// Minimal forwarding surface
	// -------------------------------------------------------------------------
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
	static add_to = function(_parent_or_ui_layer)
	{
		__core_add_to(_parent_or_ui_layer);
		
		return self;
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
	static remove_from = function(_parent_or_ui_layer)
	{
		__core_remove_from(_parent_or_ui_layer);
		
		// Recursive update root and parent
		static __stack_node = [];
		var _stack_node = __stack_node;
		array_push(_stack_node, self);
		
		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);
			_node.__root = self;
			
			var _child_count = array_length(_node.__children);
			if (_child_count > 0) {
				array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
			}
		}
		
		return self;
	}
	
	#region jsDoc
	/// @func    remove()
	/// @desc    Removes a child node from this node.
	///          Clears wrapper links (child __parent becomes undefined; child __root becomes itself),
	///          removes the child from the flexpanel tree.
	///          Does nothing if the node is not a direct child of this node.
	/// @self    Reflex
	/// @param   {Struct.Reflex} node : Child node to remove.
	/// @returns {Undefined}
	#endregion
	static remove = function(_child_node)
	{
		__core_remove(_child_node);
		
		// Recursive update root and parent
		static __stack_node = [];
		var _stack_node = __stack_node;
		array_push(_stack_node, _child_node);
		
		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);
			_node.__root = _child_node;
			
			var _child_count = array_length(_node.__children);
			if (_child_count > 0) {
				array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
			}
		}
		
		return self
	}
	
	#region jsDoc
	/// @func    clear()
	/// @desc    Removes all children from this node.
	///          Detaches each child (clears __parent and resets __root to itself),
	///          removes all flexpanel children.
	/// @self    Reflex
	/// @returns {Undefined}
	#endregion
	static clear = function()
	{
		// Recursive update root and parent
		static __stack_node = [];
		var _stack_node = __stack_node;
		
		var _count = array_length(__children);
		for (var i = 0; i < _count; i++)
		{
			var _child_node = __children[i];
			_child_node.__parent = undefined;
			_child_node.__root = _child_node;
			
			array_copy(_stack_node, 0, _child_node.__children, 0, array_length(_child_node.__children));
			while (array_length(_stack_node) > 0)
			{
				var _node = array_pop(_stack_node);
				_node.__root = _child_node;
			
				var _child_count = array_length(_node.__children);
				if (_child_count > 0) {
					array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
				}
			}
		
		}
		
		
		__core_clear();
		return self;
	}
	
	#region jsDoc
	/// @func    get_root()
	/// @desc    Returns the root wrapper node for this tree. For a detached node, this is itself.
	/// @self    Reflex
	/// @returns {Struct.Reflex}
	#endregion
	static get_root = function()
	{
		return __root;
	};
	
	#region Events
	events = {}; //All events must be a hash from `variable_get_hash()`
	
	events.focus_gained = variable_get_hash("focus_gained");
	events.focus_lost = variable_get_hash("focus_lost");
	
	#region jsDoc
	/// @func    on_focus_gained(_func)
	/// @desc    Adds a listener for when the scrollbar gains keyboard focus.
	/// @self    __ReflexScrollBar
	/// @param   {Function} _func
	/// @returns {Struct.__ReflexScrollBar}
	#endregion
	static on_focus_gained = function(_func)
	{
		__add_event_listener(events.focus_gained, _func);
		return self;
	};

	#region jsDoc
	/// @func    on_focus_lost(_func)
	/// @desc    Adds a listener for when the scrollbar loses keyboard focus.
	/// @self    __ReflexScrollBar
	/// @param   {Function} _func
	/// @returns {Struct.__ReflexScrollBar}
	#endregion
	static on_focus_lost = function(_func)
	{
		__add_event_listener(events.focus_lost, _func);
		return self;
	};
	#endregion
	
	#endregion
	
	
	// -------------------------------------------------------------------------
	// PRIVITE
	// -------------------------------------------------------------------------
	#region Private
	
	__root = self;
	
	#region Input Handling
	
	__input = {
		frame: -1,
		clip_left: 0,
		clip_top: 0,
		clip_right: 0,
		clip_bottom: 0,
		clip_valid: false,
		blocked: false
	};
	
	#region jsDoc
	/// @func    __input_bind_instance()
	/// @desc    Binds a wrapped instance to this Reflex node for input routing.
	///          Leaf nodes that own a real instance should call this whenever the
	///          instance is created or rebuilt.
	/// @self    ReflexUI
	/// @param   {Id.Instance} _instance_id
	/// @returns {Id.Instance}
	/// @ignore
	#endregion
	static __input_bind_instance = function(_instance_id)
	{
		if (!instance_exists(_instance_id)) {
			return undefined;
		}

		_instance_id.__reflex_node = self;
		_instance_id.__reflex_input = {
			frame: -1,
			clip_left: 0,
			clip_top: 0,
			clip_right: 0,
			clip_bottom: 0,
			clip_valid: false,
			blocked: false,
			hit_left: 0,
			hit_top: 0,
			hit_right: 0,
			hit_bottom: 0,
			hit_valid: false,
			priority: 0,
			popup: false,
			modal: false,
			keep_pressed_outside: false
		};

		return _instance_id;
	};

	#region jsDoc
	/// @func    __input_frame_begin()
	/// @desc    Runs the input propagation pass for this tree root for the current
	///          frame. This should be called on the root node.
	/// @self    ReflexUI
	/// @returns {Undefined}
	/// @ignore
	#endregion
	static __input_frame_begin = function()
	{
		var _manager = __reflex_input_frame_begin();
		if (__input.frame == _manager.frame_stamp) {
			return;
		}

		__input.frame = _manager.frame_stamp;
		__input_propagate(0, 0, display_get_gui_width(), display_get_gui_height(), true, false);
	};

	#region jsDoc
	/// @func    __input_propagate()
	/// @desc    Propagates logical input clip and blocked state through the Reflex
	///          tree and writes final input state to wrapped instances.
	/// @self    ReflexUI
	/// @param   {Real} _clip_left
	/// @param   {Real} _clip_top
	/// @param   {Real} _clip_right
	/// @param   {Real} _clip_bottom
	/// @param   {Bool} _clip_valid
	/// @param   {Bool} _blocked_value
	/// @returns {Undefined}
	/// @ignore
	#endregion
	static __input_propagate = function(_clip_left, _clip_top, _clip_right, _clip_bottom, _clip_valid, _blocked_value)
	{
		var _next_left = _clip_left;
		var _next_top = _clip_top;
		var _next_right = _clip_right;
		var _next_bottom = _clip_bottom;
		var _next_valid = _clip_valid;
		var _next_blocked = _blocked_value || __input_get_blocked();

		var _clip_rect = __input_get_clip_rect();
		if (_clip_rect != undefined && _next_valid)
		{
			_next_left = max(_next_left, _clip_rect.left);
			_next_top = max(_next_top, _clip_rect.top);
			_next_right = min(_next_right, _clip_rect.right);
			_next_bottom = min(_next_bottom, _clip_rect.bottom);

			if (_next_left >= _next_right || _next_top >= _next_bottom) {
				_next_valid = false;
			}
		}

		__input.clip_left = _next_left;
		__input.clip_top = _next_top;
		__input.clip_right = _next_right;
		__input.clip_bottom = _next_bottom;
		__input.clip_valid = _next_valid;
		__input.blocked = _next_blocked;

		var _instance_id = __input_get_wrapped_instance();
		if (_instance_id != undefined && instance_exists(_instance_id))
		{
			var _manager = __reflex_input_manager_get();
			_manager.order_index += 1;

			var _cache = _instance_id.__reflex_input;
			_cache.frame = _manager.frame_stamp;
			_cache.clip_left = _next_left;
			_cache.clip_top = _next_top;
			_cache.clip_right = _next_right;
			_cache.clip_bottom = _next_bottom;
			_cache.clip_valid = _next_valid && _instance_id.visible;
			_cache.blocked = _next_blocked;
			_cache.hit_left = max(_instance_id.bbox_left, _next_left);
			_cache.hit_top = max(_instance_id.bbox_top, _next_top);
			_cache.hit_right = min(_instance_id.bbox_right, _next_right);
			_cache.hit_bottom = min(_instance_id.bbox_bottom, _next_bottom);
			_cache.hit_valid =
				_cache.clip_valid &&
				(!_cache.blocked) &&
				(_cache.hit_left < _cache.hit_right) &&
				(_cache.hit_top < _cache.hit_bottom);
			_cache.priority = _manager.order_index + __input_get_priority_bias();
			_cache.popup = __input_is_popup();
			_cache.modal = __input_is_modal();
		}

		var _child_count = array_length(__children);
		for (var i = 0; i < _child_count; i++)
		{
			var _child_node = __children[i];
			_child_node.__input_propagate(_next_left, _next_top, _next_right, _next_bottom, _next_valid, _next_blocked);
		}
	};

	#region jsDoc
	/// @func    __input_get_wrapped_instance()
	/// @desc    Returns the wrapped instance for this node, or undefined if this
	///          node does not directly own one. Leaf object nodes should override
	///          this.
	/// @self    ReflexUI
	/// @returns {Id.Instance|Undefined}
	/// @ignore
	#endregion
	static __input_get_wrapped_instance = function()
	{
		return undefined;
	};

	#region jsDoc
	/// @func    __input_get_clip_rect()
	/// @desc    Returns the local clip rect for descendants, or undefined if this
	///          node does not clip its subtree. Clip containers should override
	///          this and return:
	///          { left, top, right, bottom }
	/// @self    ReflexUI
	/// @returns {Struct|Undefined}
	/// @ignore
	#endregion
	static __input_get_clip_rect = function()
	{
		return undefined;
	};

	#region jsDoc
	/// @func    __input_get_blocked()
	/// @desc    Returns whether this node blocks input for its subtree.
	/// @self    ReflexUI
	/// @returns {Bool}
	/// @ignore
	#endregion
	static __input_get_blocked = function()
	{
		return false;
	};

	#region jsDoc
	/// @func    __input_get_priority_bias()
	/// @desc    Returns an additional input priority bias for this node.
	/// @self    ReflexUI
	/// @returns {Real}
	/// @ignore
	#endregion
	static __input_get_priority_bias = function()
	{
		return 0;
	};

	#region jsDoc
	/// @func    __input_is_popup()
	/// @desc    Returns whether this node should be treated as popup-priority
	///          content.
	/// @self    ReflexUI
	/// @returns {Bool}
	/// @ignore
	#endregion
	static __input_is_popup = function()
	{
		return false;
	};

	#region jsDoc
	/// @func    __input_is_modal()
	/// @desc    Returns whether this node should be treated as modal content.
	/// @self    ReflexUI
	/// @returns {Bool}
	/// @ignore
	#endregion
	static __input_is_modal = function()
	{
		return false;
	};

	#endregion
	
	#region Event System
	__event_listeners = {}; //the struct which will contain all of the event listener functions to be called when an event is triggered
	
	#region jsDoc
	/// @func    __trigger_event()
	/// @desc    Run the callbacks for the given event lister id. 
	/// @self    ReflexUI
	/// @param   {String} event_id : One of the component's event IDs, see get_events for more info
	/// @param   {Struct} data : The data supplied from the struct, dependant on the component.
	/// @returns {Undefined}
	/// @ignore
	#endregion
	static __trigger_event = function(_event_id, _data=undefined) {
		static __depth = 0;
		static __queue = [];
		#region === Note ===
		///////////////////////////////////////////////////////////////////////////////
		//// NOTE: Depth and Queue are used to ensure one event finished
		//           before starting on a proceeding event
		///////////////////////////////////////////////////////////////////////////////
		//  Without queuing:
		//  Event A fires → calls handler → handler triggers Event B → 
		//    Event B fires → calls handler → handler triggers Event C → 
		//      Event C fires... (deeply nested)
		//  With queuing:
		//  Event A fires → handler triggers Event B (queued) → Event A completes
		//  Then: Event B fires → handler triggers Event C (queued) → Event B completes
		//  Then: Event C fires → completes
		///////////////////////////////////////////////////////////////////////////////
		#endregion
		
		// if the event doesnt exist for some reason throw a warning message and continue
		var _event_arr = struct_get_from_hash(__event_listeners, _event_id);
		if (_event_arr == undefined) {
			if (!code_is_compiled() && !struct_exists_from_hash(events, _event_id)) {
				show_debug_message($"Event hash '{_event_id}' not registered for component '{debug_name}'.\n{json_stringify(debug_get_callstack(5), true)}")
			}
					
			return;
		}
					
				
		// If we're in the middle of an event chain, queue this trigger rather than running it immediately.
		if (__depth > 0) {
			var _this = self;
			array_push(__queue, { event: _event_id, data: _data, this: _this });
			return;
		}
				
		__depth++;
		_depth = __depth;
				
		var _event_arr = struct_get_from_hash(__event_listeners, _event_id);
		if (_event_arr != undefined) {
			var _size = array_length(_event_arr);
			var _i = 0;
			repeat(_size) {
			    var _fn = _event_arr[_i];
			    _fn(_data);
			    _i += 1;
			}
		}
				
		__depth--;
				
		// If we're back at the root, process any queued events.
		if (__depth == 0 && array_length(__queue) > 0) {
			while (array_length(__queue) > 0) {
			    var queued = array_shift(__queue); // Remove the first queued event.
			    with (queued.this) trigger_event(queued.event, queued.data);
			}
		}
	};
	
	#region jsDoc
	/// @func    __add_event_listener()
	/// @desc    Add an event listener to the component,
	///          This function will be ran when the event is triggered
	/// @self    ReflexUI
	/// @param   {Real} event_id : The comonent's event you wish to bound this function to.
	/// @param   {Function} func : The function to run when the event is triggered
	/// @returns {Undefined}
	#endregion
	static __add_event_listener = function(_event_id, _func) {
		var _hash = _event_id;
		if (struct_get_from_hash(__event_listeners, _event_id) == undefined) {
			struct_set_from_hash(__event_listeners, _event_id, [])
		}
				
		var _arr = struct_get_from_hash(__event_listeners, _event_id)
		array_push(_arr, _func);
	}
	
	#endregion
}




