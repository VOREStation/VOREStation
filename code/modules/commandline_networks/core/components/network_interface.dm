	//when added to an item or object will:
	// * do fucking nothing without a local commandline network
	// * enable connecting networks upon clicking on someone with an object
	// * enable TGUI on item use
	//
	//
	// Upon connecting to a network:
	// * Add listeners to both the network target & src for any sort of movement
	// * Network disconnect upon moving
/datum/component/commandline_network_interface
	var/datum/component/commandline_network/localhost
	var/datum/component/commandline_network/remotehost

	var/datum/tgui_module/commandline_network_display/UI

	var/name = "DataJack"
	/*
	TODO:
	var/connect_do_after = 0
	var/connect_noise
	var/disconnect_noise

	var/connect_damage
	var/connect_damage_type //do it hurt, do it burn, etc


	*/

/datum/component/commandline_network_interface/Initialize(var/nameof)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	localhost = parent.GetComponent(/datum/component/commandline_network/)
	if(!localhost)
		return COMPONENT_INCOMPATIBLE

	if(nameof)
		name = nameof

	UI = new
	UI.name = src.name

	RegisterSignal(parent,COMSIG_ITEM_PRE_ATTACK,PROC_REF(item_preattack))
	RegisterSignal(parent,COMSIG_ITEM_ATTACK_SELF,PROC_REF(openInterface))

/datum/component/commandline_network_interface/proc/item_preattack(obj/item/weapon, atom/target, mob/user, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER//TODO: remove, debug.
	to_chat(user,"PREATTACK: [attack_modifiers] | [modifiers] | [target]")

	remotehost = target.GetComponent(/datum/component/commandline_network)
	if(remotehost)
		to_chat(user,"CONNECTION FOUND")
		localhost.network.connect_to(remotehost.network)
		RegisterSignal(parent,COMSIG_MOVABLE_MOVED,PROC_REF(either_end_moved))
		RegisterSignal(remotehost.parent,COMSIG_MOVABLE_MOVED,PROC_REF(either_end_moved))
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/commandline_network_interface/proc/either_end_moved()
	SIGNAL_HANDLER
	UnregisterSignal(remotehost.parent,COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent,COMSIG_MOVABLE_MOVED)
	localhost.network.disconnect_from(remotehost.network)
	remotehost = null

/datum/component/commandline_network_interface/proc/openInterface(var/mob/user)
	SIGNAL_HANDLER
	to_chat(user,"FSDFSDFSD")
	UI.tgui_interact(user)
