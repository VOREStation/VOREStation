/datum/tgui_module/commandline_network_display
	name = "COMMANDLINE_NETWORK"
	tgui_id = "CommandlineTerminal"

	var/datum/commandline_network/network //source network
	var/datum/commandline_network_node/source_node //what we send commands from

	var/cooldown //anti-spam, 1 command a second max

/datum/tgui_module/commandline_network_display/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()

	to_chat(world,"TGUI ACT: [action] | PARAMS: [params]")
	if(action == "sendCommand")
		to_chat(world,"SENDING COMMAND: [json_encode(params)]")
		var/command = params["command"]
		network.do_command(source_node,command,TRUE)
		return TRUE


/datum/tgui_module/commandline_network_display/tgui_close()
	. = ..()
	//TODO

/datum/tgui_module/commandline_network_display/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/commandline_backgrounds))


/datum/tgui_module/commandline_network_display/tgui_interact(mob/user, datum/tgui/ui = null, datum/tgui/parent_ui = null, datum/tgui_state/custom_state)
	if(!network)
		to_chat(user,"NO NETWORK")
		return
	if(user)
		return ..()

/datum/tgui_module/commandline_network_display/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = network?.export_tgui_data()
	data["userName"] = user.name

	if(source_node)
		data["homeNode"] = "\ref[source_node]"
		data["macros"] = source_node.macros
	else
		data["homeNode"] = null
		data["macros"] = list()

	return data
