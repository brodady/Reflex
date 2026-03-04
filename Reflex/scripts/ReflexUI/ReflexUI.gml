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
		static __base_add_to = Reflex.add_to;
		var _value = __base_add_to(_parent_or_ui_layer);
		
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
	static remove_from = function(_parent_or_ui_layer)
	{
		static __base_remove_from = Reflex.remove_from;
		var _value = __base_remove_from(_parent_or_ui_layer);
		
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
		
		return _value;
	}
	
	#region jsDoc
	/// @func    insert()
	/// @desc    Inserts a child node at the given index (or appends if index < 0).
	///          Also rewires wrapper links:
	///          - Detaches from the old parent if needed
	///          - Sets child's __parent to this node
	///          - Sets child's __root to this node's root
	///          Mirrors the change into the underlying flexpanel tree.
	/// @self    Reflex
	/// @param   {Struct.Reflex} node : Child node to insert.
	/// @param   {Real} index : Target index. If < 0, appends. Clamped to valid range.
	/// @returns {Undefined}
	#endregion
	static insert = function(_child_node, _index_value=-1)
	{
		static __base_insert = Reflex.insert;
		__base_insert(_child_node, _index_value);
		
		// Recursive update root and parent
		static __stack_node = [];
		var _stack_node = __stack_node;
		array_push(_stack_node, _child_node);
		
		var _root = __root;
		while (array_length(_stack_node) > 0)
		{
			var _node = array_pop(_stack_node);
			_node.__root = _root;
			
			var _child_count = array_length(_node.__children);
			if (_child_count > 0) {
				array_copy(_stack_node, array_length(_stack_node), _node.__children, 0, _child_count);
			}
		}
		
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
		static __base_remove = Reflex.remove;
		__base_remove(_child_node);
		
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
		
		
		static __base_clear = Reflex.clear;
		__base_clear();
		
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




