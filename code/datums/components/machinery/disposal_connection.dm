///Disposal connection component, allows an atom to recieve and send disposal packages if attached to a disposal trunk.
/datum/component/disposal_system_connection
	//The connected trunk. Also determines if we're linked already or not.
	var/obj/structure/disposalpipe/trunk/connected_trunk = null

	var/atom/disposal_owner
	/// The proc that the owner has that'll accept a list of items from recieved disposal packets.
	var/visible_connection

/datum/component/disposal_system_connection/Initialize(visibly_connects = TRUE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	if(isarea(parent))
		return COMPONENT_INCOMPATIBLE
	disposal_owner = parent
	visible_connection = visibly_connects

/datum/component/disposal_system_connection/Destroy()
	if(connected_trunk)
		UnregisterSignal(connected_trunk, COMSIG_DISPOSAL_SEND)
		connected_trunk = null
	. = ..()
	disposal_owner = null

/datum/component/disposal_system_connection/RegisterWithParent()
	RegisterSignal(disposal_owner, COMSIG_DISPOSAL_FLUSH, PROC_REF(on_flush))
	RegisterSignal(disposal_owner, COMSIG_DISPOSAL_LINK, PROC_REF(link_to_trunk))
	RegisterSignal(disposal_owner, COMSIG_DISPOSAL_UNLINK, PROC_REF(unlink_from_trunk))
	RegisterSignal(disposal_owner, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))


/datum/component/disposal_system_connection/UnregisterFromParent()
	UnregisterSignal(disposal_owner, COMSIG_DISPOSAL_FLUSH)
	UnregisterSignal(disposal_owner, COMSIG_DISPOSAL_LINK)
	UnregisterSignal(disposal_owner, COMSIG_DISPOSAL_UNLINK)
	UnregisterSignal(disposal_owner, COMSIG_ATOM_EXAMINE)


// Signal handling
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/proc/on_flush(datum/source, list/flushed_items, datum/gas_mixture/flush_gas)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	// Important note, the flush_gas will be passed to the disposal packet when it's made. Caller should make a fresh gasmix datum after flushing this one!
	return handle_flush(flushed_items, flush_gas)

/datum/component/disposal_system_connection/proc/link_to_trunk(datum/source, obj/structure/disposalpipe/trunk/trunk)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!trunk)
		return FALSE
	if(trunk.linked) //Already linked to something
		return FALSE
	connected_trunk = trunk
	trunk.linked = disposal_owner
	RegisterSignal(trunk, COMSIG_DISPOSAL_SEND, PROC_REF(on_recieve))

/datum/component/disposal_system_connection/proc/unlink_from_trunk(datum/source)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	if(connected_trunk)
		UnregisterSignal(connected_trunk, COMSIG_DISPOSAL_SEND)
		connected_trunk = null

/datum/component/disposal_system_connection/proc/on_recieve(datum/source, obj/structure/disposalholder/packet)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	return handle_expel(packet)

/datum/component/disposal_system_connection/proc/on_examine(datum/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER
	if(!visible_connection)
		return
	examine_texts += span_notice("It [connected_trunk ? "is connected" : "can be connected"] to a disposal pipe network.")

// Flush handling, can be override by subtypes but excepts parent proc to handle core logic
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/proc/handle_flush(list/flushed_items, datum/gas_mixture/flush_gas)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	var/obj/structure/disposalholder/packet = new()	// virtual holder object which actually travels through the pipes.
	packet.init(flushed_items, flush_gas)

	// if no trunk connected, expel immediately
	if(!connected_trunk)
		handle_expel(packet)
		return TRUE

	// start the holder processing movement
	packet.forceMove(connected_trunk)
	packet.active = TRUE
	packet.set_dir(DOWN)
	packet.move()
	return TRUE


// Expel handling, can be override by subtypes but excepts parent proc to handle core logic
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/proc/handle_expel(obj/structure/disposalholder/packet)
	// Returns true if our owner could handle this packet, used by our child procs to animate our owner.
	PROTECTED_PROC(TRUE)
	if(!packet || QDELETED(packet))
		return FALSE

	// We need to store the data in the packet to handle it with delays, then delete the packet so nothing else can handle it
	packet.active = FALSE // So it stops trying to move
	var/list/expelled_items = list()
	for(var/atom/movable/AM in packet)
		expelled_items += AM
		AM.forceMove(disposal_owner)
	var/datum/gas_mixture/gas = new()
	gas.copy_from(packet.gas)
	qdel(packet)
	SEND_SIGNAL(disposal_owner, COMSIG_DISPOSAL_RECEIVE, expelled_items, gas)
	return TRUE
