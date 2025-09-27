///Disposal connection component, allows an atom to recieve and send disposal packages if attached to a disposal trunk.
/datum/component/disposal_system_connection
	VAR_PROTECTED/obj/disposal_owner = null

/datum/component/disposal_system_connection/Initialize()
	disposal_owner = parent
	RegisterSignal(disposal_owner, COMSIG_DISPOSAL_FLUSH, PROC_REF(on_flush))
	RegisterSignal(disposal_owner, COMSIG_DISPOSAL_RECEIVING, PROC_REF(on_recieve))
	RegisterSignal(disposal_owner, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/disposal_system_connection/Destroy()
	UnregisterSignal(disposal_owner, COMSIG_DISPOSAL_FLUSH)
	UnregisterSignal(disposal_owner, COMSIG_DISPOSAL_RECEIVING)
	UnregisterSignal(disposal_owner, COMSIG_PARENT_EXAMINE)
	disposal_owner = null
	. = ..()

// Signal handling
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/proc/on_flush(datum/source,datum/gas_mixture/flush_gas)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_accept())
		return FALSE
	// Important note, the flush_gas will be passed to the disposal packet when it's made. Caller should make a fresh gasmix datum after flushing this one!
	return handle_flush(flush_gas)

/datum/component/disposal_system_connection/proc/on_recieve(datum/source,obj/structure/disposalholder/packet)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_accept())
		return FALSE
	return handle_expel(packet)

/datum/component/disposal_system_connection/proc/on_examine(datum/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER
	var/has_connection = FALSE
	if(can_accept() && (locate(/obj/structure/disposalpipe/trunk) in get_turf(disposal_owner)))
		has_connection = TRUE
	examine_texts += span_notice("It [has_connection ? "is connected" : "can be connected"] to a disposal pipe network.")

// Flush handling, can be override by subtypes but excepts parent proc to handle core logic
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/component/disposal_system_connection/proc/handle_flush(datum/gas_mixture/flush_gas)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	var/obj/structure/disposalholder/packet = new()	// virtual holder object which actually travels through the pipes.
	packet.init(get_flushed_item_list(), flush_gas)
	finish_flush(packet)
	return TRUE

/datum/component/disposal_system_connection/proc/finish_flush(obj/structure/disposalholder/packet)
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
		// Handle client eye we get a black screen between trunk and eject if we have delay on ejection!
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)
				M.client.eye = disposal_owner
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
	// This way it can just pass nulls to this parent proc if it does it's own handling for those things. Like a machine that eats all stuff dumped into it instead of ejecting.

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

// Disposal outlets, needs to animate with a timed buzzer before stuff ejects
/datum/component/disposal_system_connection/disposaloutlet/handle_expel(obj/structure/disposalholder/packet, delay_time)
	. = ..(packet,3 SECONDS)
	if(.)
		flick("outlet-open", disposal_owner)
		playsound(disposal_owner, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)

/datum/component/disposal_system_connection/disposaloutlet/get_expel_target()
	return get_ranged_target_turf(get_turf(disposal_owner), disposal_owner.dir, 10)
