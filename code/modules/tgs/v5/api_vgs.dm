// We currently isolate ourselves in a different variable so that only the specific APIs we choose will be active.
// Eventually it would be good to handle all the TGS Apis properly and we can use the same.
GLOBAL_DATUM(vgs, /datum/tgs_api)

// Supply our own New functionality so we can read from config instead of world params
/world/proc/VgsNew(datum/tgs_event_handler/event_handler)
	var/current_api = GLOB.vgs
	if(current_api)
		TGS_ERROR_LOG("API datum already set (\ref[current_api] ([current_api]))! Was TgsNew() called more than once?")
		return

	// If we don't have a configured access identifier we aren't meant to use VGS
	if(!CONFIG_GET(string/vgs_access_identifier))
		TGS_INFO_LOG("Skipping VGS: No access identifier configured")
		return

	var/datum/tgs_api/api_datum = /datum/tgs_api/v5/vgs1
	TGS_INFO_LOG("Activating API for version [api_datum]")

	if(event_handler && !istype(event_handler))
		TGS_ERROR_LOG("Invalid parameter for event_handler: [event_handler]")
		event_handler = null

	var/datum/tgs_api/new_api = new api_datum(event_handler)
	GLOB.vgs = new_api

	var/result = new_api.OnWorldNew()
	if(!result || result == TGS_UNIMPLEMENTED)
		GLOB.vgs = null
		TGS_ERROR_LOG("Failed to activate API!")

/world/proc/VgsTopic(T)
	var/datum/tgs_api/api = GLOB.vgs
	if(api)
		var/result = api.OnTopic(T)
		if(result != TGS_UNIMPLEMENTED)
			return result

/world/TgsReboot()
	var/datum/tgs_api/api = GLOB.vgs
	if(api)
		api.OnReboot()
	else
		return ..()

/world/TgsInitializationComplete()
	var/datum/tgs_api/api = GLOB.vgs
	if(api)
		api.OnInitializationComplete()
	else
		return ..()

/world/proc/VgsAddMemberRole(chat_user_id)
	var/datum/tgs_api/v5/vgs1/api = GLOB.vgs
	if(api)
		api.AddMemberRole(chat_user_id)

/datum/tgs_api/v5/vgs1
	server_port = 8080  // Default port

// Override to prevent error messages from the lack of revision/test_merge information, and to use config isntead of params.
/datum/tgs_api/v5/vgs1/OnWorldNew()
	if(CONFIG_GET(number/vgs_server_port))
		server_port = CONFIG_GET(number/vgs_server_port)
	access_identifier = CONFIG_GET(string/vgs_access_identifier)

	var/list/bridge_response = Bridge(DMAPI5_BRIDGE_COMMAND_STARTUP, list(DMAPI5_BRIDGE_PARAMETER_CUSTOM_COMMANDS = ListCustomCommands()))
	if(!istype(bridge_response))
		TGS_ERROR_LOG("Failed initial bridge request!")
		return FALSE

	var/list/runtime_information = bridge_response[DMAPI5_BRIDGE_RESPONSE_RUNTIME_INFORMATION]
	if(!istype(runtime_information))
		TGS_ERROR_LOG("Failed to decode runtime information from bridge response: [json_encode(bridge_response)]!")
		return FALSE

	version = new /datum/tgs_version(runtime_information[DMAPI5_RUNTIME_INFORMATION_SERVER_VERSION])
	instance_name = runtime_information[DMAPI5_RUNTIME_INFORMATION_INSTANCE_NAME]

	chat_channels = list()
	DecodeChannels(runtime_information)

	return TRUE

/datum/tgs_api/v5/vgs1/proc/AddMemberRole(chat_user_id)
	Bridge(DMAPI5_BRIDGE_COMMAND_ADD_MEMBER_ROLE, list(DMAPI5_BRIDGE_PARAMETER_CHAT_USER_ID = chat_user_id))

// /datum/tgs_api/v5/vgs1/RequireInitialBridgeResponse()
// 	while(!instance_name)
// 		sleep(1)
