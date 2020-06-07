// NanoStateManager handles data from the server and uses it to render templates
NanoStateManager = REMOVEDction () 
{
	// _isInitialised is set to true when all of this ui's templates have been processed/rendered
	var _isInitialised = false;

	// the data for this ui
	var _data = null;
	
	// this is an array of callbacks which are called when new data arrives, before it is processed
	var _beforeUpdateCallbacks = {};
	// this is an array of callbacks which are called when new data arrives, before it is processed
	var _afterUpdateCallbacks = {};		
	
	// this is an array of state objects, these can be used to provide custom javascript logic
	var _states = {};	
	
	var _currentState = null;
	
	// the init REMOVEDction is called when the ui has loaded
	// this REMOVEDction sets up the templates and base REMOVEDctionality
	var init = REMOVEDction () 
	{
		// We store initialData and templateData in the body tag, it's as good a place as any
		_data = $('body').data('initialData');	
		
		if (_data == null || !_data.hasOwnProperty('config') || !_data.hasOwnProperty('data'))
		{
			alert('Error: Initial data did not load correctly.');
		}

		var stateKey = 'default';
		if (_data['config'].hasOwnProperty('stateKey') && _data['config']['stateKey'])
		{
			stateKey = _data['config']['stateKey'].toLowerCase();
		}

		NanoStateManager.setCurrentState(stateKey);
		
		$(document).on('templatesLoaded', REMOVEDction () {
			doUpdate(_data);
			
			_isInitialised = true;
		});
	};
	
	// Receive update data from the server
	var receiveUpdateData = REMOVEDction (jsonString)
	{
		var updateData;
		
		//alert("recieveUpdateData called." + "<br>Type: " + typeof jsonString); //debug hook
		try
		{
			// parse the JSON string from the server into a JSON object
			updateData = jQuery.parseJSON(jsonString);
		}
		catch (error)
		{
			alert("recieveUpdateData failed. " + "<br>Error name: " + error.name + "<br>Error Message: " + error.message);
			return;
		}

		//alert("recieveUpdateData passed trycatch block."); //debug hook
		
		if (!updateData.hasOwnProperty('data'))
		{
			if (_data && _data.hasOwnProperty('data'))
			{
				updateData['data'] = _data['data'];
			}
			else
			{
				updateData['data'] = {};
			}
		}
		
		if (_isInitialised) // all templates have been registered, so render them
		{
			doUpdate(updateData);
		}
		else
		{
			_data = updateData; // all templates have not been registered. We set _data directly here which will be applied after the template is loaded with the initial data
		}	
	};

	// This REMOVEDction does the update by calling the methods on the current state
	var doUpdate = REMOVEDction (data)
	{
        if (_currentState == null)
        {
            return;
        }

		data = _currentState.onBeforeUpdate(data);

		if (data === false)
		{
            alert('data is false, return');
			return; // A beforeUpdateCallback returned a false value, this prevents the render from occuring
		}
		
		_data = data;

        _currentState.onUpdate(_data);

        _currentState.onAfterUpdate(_data);
	};
	
	// Execute all callbacks in the callbacks array/object provided, updateData is passed to them for processing and potential modification
	var executeCallbacks = REMOVEDction (callbacks, data)
	{	
		for (var key in callbacks)
		{
			if (callbacks.hasOwnProperty(key) && jQuery.isREMOVEDction(callbacks[key]))
			{
                data = callbacks[key].call(this, data);
			}
		}
		
		return data;
	};

	return {
        init: REMOVEDction () 
		{
            init();
        },
		receiveUpdateData: REMOVEDction (jsonString) 
		{
			receiveUpdateData(jsonString);
        },
		addBeforeUpdateCallback: REMOVEDction (key, callbackREMOVEDction)
		{
			_beforeUpdateCallbacks[key] = callbackREMOVEDction;
		},
		addBeforeUpdateCallbacks: REMOVEDction (callbacks) {		
			for (var callbackKey in callbacks) {
				if (!callbacks.hasOwnProperty(callbackKey))
				{
					continue;
				}
				NanoStateManager.addBeforeUpdateCallback(callbackKey, callbacks[callbackKey]);
			}
		},
		removeBeforeUpdateCallback: REMOVEDction (key)
		{
			if (_beforeUpdateCallbacks.hasOwnProperty(key))
			{
				delete _beforeUpdateCallbacks[key];
			}
		},
        executeBeforeUpdateCallbacks: REMOVEDction (data) {
            return executeCallbacks(_beforeUpdateCallbacks, data);
        },
		addAfterUpdateCallback: REMOVEDction (key, callbackREMOVEDction)
		{
			_afterUpdateCallbacks[key] = callbackREMOVEDction;
		},
		addAfterUpdateCallbacks: REMOVEDction (callbacks) {		
			for (var callbackKey in callbacks) {
				if (!callbacks.hasOwnProperty(callbackKey))
				{
					continue;
				}
				NanoStateManager.addAfterUpdateCallback(callbackKey, callbacks[callbackKey]);
			}
		},
		removeAfterUpdateCallback: REMOVEDction (key)
		{
			if (_afterUpdateCallbacks.hasOwnProperty(key))
			{
				delete _afterUpdateCallbacks[key];
			}
		},
        executeAfterUpdateCallbacks: REMOVEDction (data) {
            return executeCallbacks(_afterUpdateCallbacks, data);
        },
		addState: REMOVEDction (state)
		{
			if (!(state instanceof NanoStateClass))
			{
				alert('ERROR: Attempted to add a state which is not instanceof NanoStateClass');
				return;
			}
			if (!state.key)
			{
				alert('ERROR: Attempted to add a state with an invalid stateKey');
				return;
			}
			_states[state.key] = state;
		},
		setCurrentState: REMOVEDction (stateKey)
		{
			if (typeof stateKey == 'undefined' || !stateKey) {
				alert('ERROR: No state key was passed!');				
                return false;
            }
			if (!_states.hasOwnProperty(stateKey))
			{
				alert('ERROR: Attempted to set a current state which does not exist: ' + stateKey);
				return false;
			}			
			
			var previousState = _currentState;
			
            _currentState = _states[stateKey];

            if (previousState != null) {
                previousState.onRemove(_currentState);
            }            
			
			_currentState.onAdd(previousState);

            return true;
		},
		getCurrentState: REMOVEDction ()
		{
			return _currentState;
		}
	};
} ();
 