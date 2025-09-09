///Disposal connection component, allows an atom to recieve and send disposal packages if attached to a disposal trunk.
/datum/component/disposal_system_connection
	VAR_PROTECTED/obj/disposal_owner = null
	VAR_PROTECTED/expel_on_recieve = TRUE

/datum/component/disposal_system_connection/Initialize()
	disposal_owner = parent
	RegisterSignal(disposal_owner, COMSIG_DISPOSAL_FLUSH, PROC_REF(on_flush))
	RegisterSignal(disposal_owner, COMSIG_DISPOSAL_RECEIVING, PROC_REF(on_recieve))

/datum/component/disposal_system_connection/Destroy()
	UnregisterSignal(disposal_owner, COMSIG_DISPOSAL_FLUSH)
	UnregisterSignal(disposal_owner, COMSIG_DISPOSAL_RECEIVING)
	disposal_owner = null
	. = ..()

// Signal handling
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/proc/on_flush(datum/source,datum/gas_mixture/flush_gas)
	SIGNAL_HANDLER
	if(!can_accept())
		return FALSE
	return handle_flush(flush_gas)

/datum/component/disposal_system_connection/proc/on_recieve(datum/source,obj/structure/disposalholder/packet)
	SIGNAL_HANDLER
	if(!can_accept())
		return FALSE
	return handle_expel(packet)

// Flush handling, can be override by subtypes but excepts parent proc to handle core logic
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/proc/handle_flush(datum/gas_mixture/flush_gas)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	var/obj/structure/disposalholder/packet = new()	// virtual holder object which actually travels through the pipes.
	var/list/flush_list = get_flushed_item_list()

	//Hacky test to get drones to mail themselves through disposals.
	var/wrapcheck = FALSE
	if(locate(/mob/living/silicon/robot/drone) in flush_list)
		wrapcheck = TRUE
	if(locate(/obj/item/smallDelivery) in flush_list)
		wrapcheck = TRUE
	packet.tomail = wrapcheck

	// Send it!
	packet.init(flush_list, flush_gas)
	finish_flush(packet)
	return TRUE

/datum/component/disposal_system_connection/proc/finish_flush(var/obj/structure/disposalholder/packet)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	// if no trunk connected, expel immediately
	var/obj/structure/disposalpipe/trunk/trunk = locate() in get_turf(disposal_owner)
	if(!trunk)
		handle_expel(packet)
		return

	// start the holder processing movement
	packet.forceMove(trunk)
	packet.active = TRUE
	packet.set_dir(DOWN)
	packet.move()

// Expel handling, can be override by subtypes but excepts parent proc to handle core logic
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/proc/handle_expel(obj/structure/disposalholder/packet, delay_time = 0)
	// Returns true if our owner could handle this packet, used by our child procs to animate our owner.
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
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

	// Handle expelling stuff, most things have a delay before ejecting.
	if(delay_time <= 0) // Someone is going to pass a negative, I just know it. No, BAD, cutting this off before it gets the chance.
		expel_finish(expelled_items, gas)
	else
		addtimer(CALLBACK(src, PROC_REF(expel_finish), expelled_items, gas), delay_time, TIMER_DELETE_ME)
	return TRUE

/datum/component/disposal_system_connection/proc/expel_finish(list/expelled_items,datum/gas_mixture/gas)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	// This proc has some checks just incase we have a subtype that wants to handle expelled items or if it vents gasses itself.
	// This way it can just pass nulls to this parent proc if it does it's own handling for those things.

	// Drop all those items
	if(expelled_items.len)
		var/turf/target = get_expel_target()
		for(var/atom/movable/AM in expelled_items)
			if(QDELETED(AM))
				continue
			AM.forceMove(get_turf(disposal_owner))
			AM.pipe_eject(disposal_owner.dir)
			if(istype(AM,/mob/living/silicon/robot/drone)) //Drones keep smashing windows from being fired out of chutes. Bad for the station. ~Z
				continue
			AM.throw_at(target, 3, 1)
		expelled_items.Cut()

	// vent gasses to turf
	if(gas)
		if(gas.return_pressure() > 0)
			playsound(disposal_owner, 'sound/machines/hiss.ogg', 50, 0, 0)
		var/turf/T = get_turf(disposal_owner)
		if(T)
			T.assume_air(gas)
		qdel(gas)

// Overridable procs for easily customizing subtypes
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Override this to add additional checks if an object can flush or accept incoming packets
/datum/component/disposal_system_connection/proc/can_accept()
	PROTECTED_PROC(TRUE)
	return disposal_owner.anchored

/// Override this to launch items in a specific direction
/datum/component/disposal_system_connection/proc/get_expel_target()
	PROTECTED_PROC(TRUE)
	return get_offset_target_turf(get_turf(disposal_owner), rand(5)-rand(5), rand(5)-rand(5))

/// Override this to give a custom list of items to flush instead of just the contents of the owner
/datum/component/disposal_system_connection/proc/get_flushed_item_list()
	PROTECTED_PROC(TRUE)
	return disposal_owner.contents



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Subtypes for handling how things are animated, if items are spat out, or deciding what items inside an object are flushed
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/disposaloutlet/handle_expel(datum/source,obj/structure/disposalholder/packet, delay_time)
	. = ..(packet,2 SECONDS)
	if(.)
		flick("outlet-open", disposal_owner)
		playsound(disposal_owner, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)

/datum/component/disposal_system_connection/disposaloutlet/get_expel_target()
	return get_ranged_target_turf(get_turf(disposal_owner), disposal_owner.dir, 10)
