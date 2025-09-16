// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things, no other draggables
// Toilets are a type of disposal bin for small objects only and work on magic. By magic, I mean torque rotation
#define SEND_PRESSURE (0.05 + ONE_ATMOSPHERE) //kPa - assume the inside of a dispoal pipe is 1 atm, so that needs to be added.
#define PRESSURE_TANK_VOLUME 150	//L
#define PUMP_MAX_FLOW_RATE 11.25	//L/s - 4 m/s using a 15 cm by 15 cm inlet //NOTE: I reduced the send pressure from 801 to 101.05 which is about 1/8 there was originally, and this was 90 before that. 90/8 is about 11.25, so that's the new value. -Reo
#define DISPOSALMODE_EJECTONLY -1
#define DISPOSALMODE_OFF 0
#define DISPOSALMODE_CHARGING 1
#define DISPOSALMODE_CHARGED 2

/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	anchored = TRUE
	density = TRUE
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = DISPOSALMODE_CHARGING
	var/flush = FALSE	// true if flush handle is pulled
	var/flushing = FALSE	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	active_power_usage = 2200	//the pneumatic pump power. 3 HP ~ 2200W
	idle_power_usage = 100
	var/stat_tracking = TRUE

// create a new disposal
// find the attached trunk (if present) and init gas resvr.
/obj/machinery/disposal/Initialize(mapload)
	. = ..()

	var/obj/structure/disposalpipe/trunk/trunk = locate() in loc
	if(!trunk)
		mode = DISPOSALMODE_OFF
		flush = FALSE

	air_contents = new(PRESSURE_TANK_VOLUME)
	update()
	AddComponent(/datum/component/disposal_system_connection)

/obj/machinery/disposal/Destroy()
	eject()
	return ..()

// attack by item places it in to disposal
/obj/machinery/disposal/attackby(obj/item/I, mob/user)
	if(stat & BROKEN || !I || !user)
		return

	add_fingerprint(user)
	if(mode <= DISPOSALMODE_OFF) // It's off
		if(I.has_tool_quality(TOOL_SCREWDRIVER))
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			if(mode == DISPOSALMODE_OFF) // It's off but still not unscrewed
				mode = DISPOSALMODE_EJECTONLY // Set it to doubleoff l0l
				playsound(src, I.usesound, 50, 1)
				to_chat(user, "You remove the screws around the power connection.")
				return
			else if(mode == DISPOSALMODE_EJECTONLY)
				mode = DISPOSALMODE_OFF
				playsound(src, I.usesound, 50, 1)
				to_chat(user, "You attach the screws around the power connection.")
				return
		else if(I.has_tool_quality(TOOL_WELDER) && mode == DISPOSALMODE_EJECTONLY)
			if(contents.len > 0)
				to_chat(user, "Eject the items first!")
				return
			var/obj/item/weldingtool/W = I.get_welder()
			if(W.remove_fuel(0,user))
				playsound(src, W.usesound, 100, 1)
				to_chat(user, "You start slicing the floorweld off the disposal unit.")

				if(do_after(user, 2 SECONDS * W.toolspeed, target = src))
					if(!src || !W.isOn()) return
					to_chat(user, "You sliced the floorweld off the disposal unit.")
					var/obj/structure/disposalconstruct/C = new (get_turf(src))
					transfer_fingerprints_to(C)
					C.ptype = 6 // 6 = disposal unit
					C.anchored = TRUE
					C.density = TRUE
					C.update()
					qdel(src)
				return
			else
				to_chat(user, "You need more welding fuel to complete this task.")
				return


	if(istype(I, /obj/item/storage/bag/trash))
		var/obj/item/storage/bag/trash/T = I
		to_chat(user, span_blue("You empty the bag."))
		for(var/obj/item/O in T.contents)
			T.remove_from_storage(O,src)
		T.update_icon()
		update()
		return

	if(istype(I, /obj/item/material/ashtray))
		var/obj/item/material/ashtray/A = I
		if(A.contents.len > 0)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " empties \the [A] into [src]."))
			for(var/obj/item/O in A.contents)
				O.forceMove(src)
			A.update_icon()
			update()
			return

	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			for (var/mob/V in viewers(user))
				V.show_message("[user] starts putting [GM.name] into the disposal.", 3)
			if(do_after(user, 2 SECONDS, target = src))
				if (GM.client)
					GM.client.perspective = EYE_PERSPECTIVE
					GM.client.eye = src
				GM.forceMove(src)
				for (var/mob/C in viewers(src))
					C.show_message(span_red("[GM.name] has been placed in the [src] by [user]."), 3)
				qdel(G)

				add_attack_logs(user,GM,"Disposals dunked")
		return

	if(isrobot(user))
		return
	if(!I || I.anchored || !I.canremove)
		return

	user.drop_item()
	if(I)
		if(istype(I, /obj/item/holder))
			var/obj/item/holder/holder = I
			var/mob/victim = holder.held_mob
			if(ishuman(victim) || victim.client)
				log_and_message_admins("placed [victim]  inside \the [src]", user)
			victim.forceMove(src)

		I.forceMove(src)

	user.visible_message("[user] places \the [I] into the [src].",  "You place \the [I] into the [src].","Ca-Clunk")
	update()

// mouse drop another mob or self
//
/obj/machinery/disposal/MouseDrop_T(mob/target, mob/user)
	if(user.stat || !user.canmove || !istype(target))
		return
	if(target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1)
		return

	//animals cannot put mobs other than themselves into disposal
	if(isanimal(user) && target != user)
		return

	add_fingerprint(user)
	var/target_loc = target.loc
	var/msg
	for (var/mob/V in viewers(user))
		if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			V.show_message("[user] starts climbing into the disposal.", 3)
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			if(target.anchored) return
			V.show_message("[user] starts stuffing [target.name] into the disposal.", 3)
	if(!do_after(user, 2 SECONDS, target))
		return
	if(target_loc != target.loc)
		return
	if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)	// if drop self, then climbed in
											// must be awake, not stunned or whatever
		msg = "[user.name] climbs into the [src]."
		to_chat(user, "You climb into the [src].")
		log_and_message_admins("climbed into disposals!", user)
	else if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
		msg = "[user.name] stuffs [target.name] into the [src]!"
		to_chat(user, "You stuff [target.name] into the [src]!")

		add_attack_logs(user,target,"Disposals dunked")
	else
		return
	if (target.client)
		target.client.perspective = EYE_PERSPECTIVE
		target.client.eye = src

	target.forceMove(src)

	for (var/mob/C in viewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	update()
	return

// attempt to move while inside
/obj/machinery/disposal/relaymove(mob/user)
	if(user.stat || flushing)
		return
	if(user.loc == src)
		go_out(user)
	return

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)
	if (user.client)
		user.client.eye = user.client.mob
		user.client.perspective = MOB_PERSPECTIVE
	user.forceMove(get_turf(src))
	update()
	return

// ai as human but can't flush
/obj/machinery/disposal/attack_ai(mob/user)
	add_hiddenprint(user)
	tgui_interact(user)

// human interact with machine
/obj/machinery/disposal/attack_hand(mob/user)
	if(stat & BROKEN)
		return

	if(user && user.loc == src)
		to_chat(user, span_red("You cannot reach the controls from inside."))
		return

	// Clumsy folks can only flush it.
	if(user.IsAdvancedToolUser(1))
		tgui_interact(user)
	else
		flush = !flush
		update()
	return

// user interaction
/obj/machinery/disposal/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DisposalBin")
		ui.open()

/obj/machinery/disposal/tgui_data(mob/user)
	var/list/data = list()

	data["isAI"] = isAI(user)
	data["flushing"] = flush
	data["mode"] = mode
	data["pressure"] = round(clamp(100* air_contents.return_pressure() / (SEND_PRESSURE), 0, 100),1)

	return data

/obj/machinery/disposal/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return

	if(ui.user.loc == src)
		to_chat(ui.user, span_warning("You cannot reach the controls from inside."))
		return TRUE

	if(mode == DISPOSALMODE_EJECTONLY && action != "eject") // If the mode is -1, only allow ejection
		to_chat(ui.user, span_warning("The disposal units power is disabled."))
		return

	if(stat & BROKEN)
		return

	add_fingerprint(ui.user)

	if(flushing)
		return

	if(isturf(loc))
		if(action == "pumpOn")
			mode = DISPOSALMODE_CHARGING
			update()
		if(action == "pumpOff")
			mode = DISPOSALMODE_OFF
			update()

		if(action == "engageHandle")
			flush = TRUE
			update()
		if(action == "disengageHandle")
			flush = FALSE
			update()

		if(action == "eject")
			eject()

	return TRUE

// eject the contents of the disposal unit

/obj/machinery/disposal/verb/force_eject()
	set src in oview(1)
	set category = "Object"
	set name = "Force Eject"
	if(flushing)
		return
	eject()

/obj/machinery/disposal/proc/eject()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
		AM.pipe_eject(0)
	update()

// update the icon & overlays to reflect mode & status
/obj/machinery/disposal/proc/update()
	cut_overlays()
	if(stat & BROKEN)
		icon_state = "disposal-broken"
		mode = DISPOSALMODE_OFF
		flush = 0
		return

	// flush handle
	if(flush)
		add_overlay("[initial(icon_state)]-handle")

	// only handle is shown if no power
	if(stat & NOPOWER || mode == DISPOSALMODE_EJECTONLY)
		return

	// 	check for items in disposal - occupied light
	if(contents.len > 0)
		add_overlay("[initial(icon_state)]-full")

	// charging and ready light
	if(mode == DISPOSALMODE_CHARGING)
		add_overlay("[initial(icon_state)]-charge")
	else if(mode == DISPOSALMODE_CHARGED)
		add_overlay("[initial(icon_state)]-ready")

// timed process
// charge the gas reservoir and perform flush if ready
/obj/machinery/disposal/process()
	if(!air_contents || (stat & BROKEN))			// nothing can happen if broken
		update_use_power(USE_POWER_OFF)
		return

	flush_count++
	if( flush_count >= flush_every_ticks )
		if( contents.len )
			if(mode == DISPOSALMODE_CHARGED)
				spawn(0)
					feedback_inc("disposal_auto_flush",1)
					flush()
		flush_count = 0

	if(flush && air_contents.return_pressure() >= SEND_PRESSURE )	// flush can happen even without power
		flush()

	if(mode != DISPOSALMODE_CHARGING) //if off or ready, no need to charge
		update_use_power(USE_POWER_IDLE)
	else if(air_contents.return_pressure() >= SEND_PRESSURE)
		mode = DISPOSALMODE_CHARGED //if full enough, switch to ready mode
		update()
	else
		pressurize() //otherwise charge

/obj/machinery/disposal/proc/pressurize()
	if(stat & NOPOWER)			// won't charge if no power
		update_use_power(USE_POWER_OFF)
		return

	var/atom/L = loc						// recharging from loc turf
	var/datum/gas_mixture/env = L.return_air()

	var/power_draw = -1
	if(env && env.temperature > 0)
		var/transfer_moles = (PUMP_MAX_FLOW_RATE/env.volume)*env.total_moles	//group_multiplier is divided out here
		power_draw = pump_gas(src, env, air_contents, transfer_moles, active_power_usage)

	if (power_draw > 0)
		use_power(power_draw)

// perform a flush
/obj/machinery/disposal/proc/flush()
	if(flushing)
		return

	flushing = TRUE
	flick("[icon_state]-flush", src)
	// wait for animation to finish
	addtimer(CALLBACK(src, PROC_REF(flush_animation)), 1 SECOND, TIMER_DELETE_ME)

/obj/machinery/disposal/proc/flush_animation()
	PROTECTED_PROC(TRUE)
	// wait for animation to finish
	playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
	addtimer(CALLBACK(src, PROC_REF(flush_resolve)), 0.5 SECOND, TIMER_DELETE_ME)

/obj/machinery/disposal/proc/flush_resolve()
	SEND_SIGNAL(src,COMSIG_DISPOSAL_FLUSH,air_contents)
	air_contents = new(PRESSURE_TANK_VOLUME)	// new empty gas resv. Disposal packet takes ownership of the original one!
	if(stat_tracking)
		GLOB.disposals_flush_shift_roundstat++
	flushing = FALSE

	// now reset disposal state
	flush = FALSE
	if(mode == DISPOSALMODE_CHARGED)	// if was ready,
		mode = DISPOSALMODE_CHARGING	// switch to charging
	update()
	return

// called when area power changes
/obj/machinery/disposal/power_change()
	..()	// do default setting/reset of stat NOPOWER bit
	update()	// update icon
	return

/obj/machinery/disposal/hitby(atom/movable/source)
	. = ..()
	if(isitem(source) && !istype(source, /obj/item/projectile))
		if(prob(75))
			source.forceMove(src)
			visible_message("\The [source] lands in \the [src].")
		else
			visible_message("\The [source] bounces off of \the [src]'s rim!")

	if(isliving(source))
		if(prob(75))
			var/mob/living/to_be_dunked = source
			if(ishuman(source) ||to_be_dunked.client)
				log_and_message_admins("[source] was thrown into \the [src]", null)
			source.forceMove(src)
			visible_message("\The [source] lands in \the [src].")

/obj/machinery/disposal/wall
	name = "inset disposal unit"
	icon_state = "wall"

	density = FALSE

/obj/machinery/disposal/wall/update()
	..()

	switch(dir)
		if(1)
			pixel_x = 0
			pixel_y = -32
		if(2)
			pixel_x = 0
			pixel_y = 32
		if(4)
			pixel_x = -32
			pixel_y = 0
		if(8)
			pixel_x = 32
			pixel_y = 0


// Cleaner subtype
/obj/machinery/disposal/wall/cleaner
	name = "resleeving equipment deposit"
	desc = "Automatically cleans and transports items to the local resleeving facilities."
	icon_state = "bluewall"

/obj/machinery/disposal/wall/cleaner/flush()
	if(flushing)
		return

	// Clean items before sending them
	for(var/obj/item/flushed_item in src)
		if(istype(flushed_item, /obj/item/storage))
			var/obj/item/storage/storage_flushed = flushed_item
			var/list/storage_items = storage_flushed.return_inv()
			for(var/obj/item/item in storage_items)
				item.wash(CLEAN_WASH)
			continue
		if(istype(flushed_item, /obj/item))
			flushed_item.wash(CLEAN_WASH)

	. = ..()

#undef DISPOSALMODE_EJECTONLY
#undef DISPOSALMODE_OFF
#undef DISPOSALMODE_CHARGING
#undef DISPOSALMODE_CHARGED
#undef SEND_PRESSURE
#undef PRESSURE_TANK_VOLUME
#undef PUMP_MAX_FLOW_RATE
