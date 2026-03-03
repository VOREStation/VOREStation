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
	var/controls_iconstate = "disposal"
	anchored = TRUE
	density = TRUE
	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = DISPOSALMODE_CHARGING
	var/flush = FALSE	// true if flush handle is pulled
	var/flushing = FALSE	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	var/last_sound
	active_power_usage = 2200	//the pneumatic pump power. 3 HP ~ 2200W
	idle_power_usage = 100
	var/stat_tracking = TRUE
	flags = REMOTEVIEW_ON_ENTER

// create a new disposal
// find the attached trunk (if present) and init gas resvr.
/obj/machinery/disposal/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()

	if(make_from)
		set_dir(make_from.dir)
		/* //I dont wanna set this up yet.
		make_from.moveToNullspace()
		stored = make_from
		*/
		qdel(make_from)
		mode = DISPOSALMODE_OFF

	var/obj/structure/disposalpipe/trunk/trunk = locate() in loc

	AddComponent(/datum/component/disposal_system_connection)
	RegisterSignal(src, COMSIG_DISPOSAL_RECEIVE, PROC_REF(packet_expel))
	if(trunk)
		SEND_SIGNAL(src, COMSIG_DISPOSAL_LINK, trunk)

	air_contents = new(PRESSURE_TANK_VOLUME)
	update_icon()

/obj/machinery/disposal/Destroy()
	eject()
	return ..()

/obj/machinery/disposal/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		deconstruct()

// attack by item places it in to disposal
/obj/machinery/disposal/attackby(obj/item/I, mob/user)
	if(stat & BROKEN || !I || !user)
		return

	add_fingerprint(user)
	if(mode <= DISPOSALMODE_OFF) // It's off
		if(I.has_tool_quality(TOOL_MULTITOOL))
			alter_bin_type(user)
			return
		else if(I.has_tool_quality(TOOL_SCREWDRIVER))
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
					deconstruct()
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
		update_icon()
		return

	if(istype(I, /obj/item/material/ashtray))
		var/obj/item/material/ashtray/A = I
		if(A.contents.len > 0)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " empties \the [A] into [src]."))
			for(var/obj/item/O in A.contents)
				O.forceMove(src)
			A.update_icon()
			update_icon()
			return

	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			for (var/mob/V in viewers(user))
				V.visible_message("[user] starts putting [GM.name] into the disposal.", 3)
			if(do_after(user, 2 SECONDS, target = src))
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
			if(victim.client)
				log_and_message_admins("placed [victim] inside \the [src]", user)
			victim.forceMove(src)
			qdel(I)
			user.visible_message(
				span_danger("[user] tosses \the [victim] into \the [src]."),
				span_danger("You toss \the [victim] into \the [src]."),
				span_warning("Pr-Thunk")
			)
			update_icon()
			return 1

		I.forceMove(src)

	user.visible_message("[user] places \the [I] into the [src].",  "You place \the [I] into the [src].","Ca-Clunk")
	update_icon()

// Transform into next machine type
/obj/machinery/disposal/proc/alter_bin_type(mob/user)
	if(contents.len > 0)
		to_chat(user, "Eject the items first!")
		return
	// Get what we want to turn into
	var/nametag
	var/new_dir = SOUTH
	var/new_disposal_path
	var/result = tgui_input_list(user,
								"What do you want to reconfigure the disposal bin to?",
								"Multitool-Disposal interface",
								list(
									"Standard",
									"Wall",
									"Resleeving Deposit",
									"Wall Resleeving Deposit",
									"Hazard Bin",
									"Wall Hazard Bin",
									"Turn-In Bin",
									"Wall Turn-In Bin",
									"Mail Destination",
									"Wall Mail Destination"
									))
	if(!result)
		return
	switch(result)
		// Yellow
		if("Standard")
			new_disposal_path = /obj/machinery/disposal
		if("Wall")
			new_disposal_path = /obj/machinery/disposal/wall
			new_dir = reverse_direction(user.dir)
		// Blue
		if("Resleeving Deposit")
			new_disposal_path = /obj/machinery/disposal/cleaner
			new_dir = reverse_direction(user.dir)
		if("Wall Resleeving Deposit")
			new_disposal_path = /obj/machinery/disposal/wall/cleaner
			new_dir = reverse_direction(user.dir)
		// Red
		if("Hazard Bin")
			new_disposal_path = /obj/machinery/disposal/burn_pit
		if("Wall Hazard Bin")
			new_disposal_path = /obj/machinery/disposal/wall/burn_pit
			new_dir = reverse_direction(user.dir)
		// Green
		if("Turn-In Bin")
			new_disposal_path = /obj/machinery/disposal/turn_in
		if("Wall Turn-In Bin")
			new_disposal_path = /obj/machinery/disposal/wall/turn_in
			new_dir = reverse_direction(user.dir)
		// White
		if("Mail Destination")
			new_disposal_path = /obj/machinery/disposal/mail_reciever
			nametag = tgui_input_text(user,"Name this mail destination. This name has no effect on the disposal sorting junction, and is only for crew convenience.", "Mail Destination")
		if("Wall Mail Destination")
			new_disposal_path = /obj/machinery/disposal/wall/mail_reciever
			new_dir = reverse_direction(user.dir)
			nametag = tgui_input_text(user,"Name this mail destination. This name has no effect on the disposal sorting junction, and is only for crew convenience.", "Mail Destination")

	if(!new_disposal_path || (new_disposal_path == type && dir == new_dir))
		return
	if(!Adjacent(user) || contents.len > 0)
		return
	if(mode > DISPOSALMODE_OFF)
		return
	// Make new bin
	var/obj/machinery/disposal/new_bin = new new_disposal_path(loc)
	if(nametag) // mailer only
		new_bin.name = "[initial(new_bin.name)]([nametag])"
	new_bin.stat = stat
	new_bin.dir = new_dir
	new_bin.mode = mode
	new_bin.update_icon() // sets up wall outlets
	new_bin.update_icon()
	new_bin.visible_message("\The [src] reconfigures into \a [new_bin]!")
	// Effects
	playsound(new_bin, 'sound/items/jaws_cut.ogg', 50, 1)
	playsound(new_bin, 'sound/machines/machine_die_short.ogg', 50, 1)
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, new_bin)
	spark_system.attach(new_bin)
	spark_system.start()
	// Cleanup
	qdel(src)

// mouse drop another mob or self
//
/obj/machinery/disposal/MouseDrop_T(mob/living/target, mob/living/user)
	if(istype(target))
		stuff_mob_in(target, user)

/obj/machinery/disposal/proc/stuff_mob_in(mob/living/target, mob/living/user)
	//animals cannot put mobs other than themselves into disposal
	if(isanimal(user) && target != user)
		return
	if(user.stat || !user.canmove || !istype(target))
		return
	if(target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1)
		return

	add_fingerprint(user)
	if(user == target)
		user.visible_message("[user] starts climbing into [src]")
	else
		target.visible_message(span_danger("[user] starts stuffing [target] into [src]."), span_userdanger("[user] starts stuffing you into [src]!"))

	if(do_after(user, 2 SECONDS, target))
		if(!loc)
			return
		target.forceMove(src)
		if(user == target)
			user.visible_message("[user] climbs into [src].", span_notice("You climb into [src]"))
			log_and_message_admins("climbed into disposals!", user)
		else
			target.visible_message(span_danger("[user] stuffs [target] into \the [src]."), span_userdanger("[user] stuffs [target] into \the [src]."))
			add_attack_logs(user,target,"Disposals dunked")
		update_icon()

// attempt to move while inside
/obj/machinery/disposal/relaymove(mob/user)
	attempt_escape(user)

// resist to escape the bin
/obj/machinery/disposal/container_resist(mob/living/user)
	attempt_escape(user)

/obj/machinery/disposal/proc/attempt_escape(mob/user)
	if(user.stat || flushing)
		return
	go_out(user)

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)
	user.forceMove(get_turf(src))
	update_icon()

// ai as human but can't flush
/obj/machinery/disposal/attack_ai(mob/user)
	add_hiddenprint(user)
	tgui_interact(user)
/*
/obj/machinery/disposal/attack_paw()
	if(stat & BROKEN)
		return
	flush = !flush
	update_icon()
*/
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
		update_icon()
	return

/obj/machinery/disposal/click_alt(mob/user)
	/*
	if(user.canUseTopic) //Later...
		return
	*/
	if(get_dist(user, src) > 1 || user.loc == src || user.stat) //Until the above exists...
		return
	flush = !flush
	update_icon()

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

	switch(action)
		if("pumpOn")
			mode = DISPOSALMODE_CHARGING
			update_icon()
		if("pumpOff")
			mode = DISPOSALMODE_OFF
			update_icon()

		if("engageHandle")
			flush = TRUE
			update_icon()
		if("disengageHandle")
			flush = FALSE
			update_icon()

		if("eject")
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
	update_icon()

// update the icon & overlays to reflect mode & status
/obj/machinery/disposal/update_icon()
	cut_overlays()
	if(stat & BROKEN)
		icon_state = "disposal-broken"
		mode = DISPOSALMODE_OFF
		flush = 0
		return

	// flush handle
	if(flush)
		add_overlay("[controls_iconstate]-handle")

	// only handle is shown if no power
	if(stat & NOPOWER || mode == DISPOSALMODE_EJECTONLY)
		return

	// 	check for items in disposal - occupied light
	if(contents.len > 0)
		add_overlay("[controls_iconstate]-full")

	// charging and ready light
	if(mode == DISPOSALMODE_CHARGING)
		add_overlay("[controls_iconstate]-charge")
	else if(mode == DISPOSALMODE_CHARGED)
		add_overlay("[controls_iconstate]-ready")

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
		update_icon()
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
	flushing = TRUE
	flush_animation()
	//Bit of a nasty way to do this. But sleep()s are nastier.
	addtimer(CALLBACK(src, PROC_REF(flush_startup)), 1 SECOND)

/obj/machinery/disposal/proc/flush_animation()
	PROTECTED_PROC(TRUE)
	flick("[icon_state]-flush", src)

/obj/machinery/disposal/proc/flush_startup()
	PROTECTED_PROC(TRUE)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		last_sound = world.time
	addtimer(CALLBACK(src, PROC_REF(flush_complete)), 0.5 SECONDS) // wait for animation to finish

/obj/machinery/disposal/proc/flush_complete()
	PROTECTED_PROC(TRUE)
	if(QDELETED(src))
		return
	// We don't ever want digestion remains going through disposals, but people understandably thing they're doing right by trashing them
	// So let's just delete them instead!
	for(var/obj/item/digestion_remains/bone in src)
		qdel(bone)

	var/list/flushed_items = list()
	for(var/atom/movable/AM in src)
		flushed_items += AM

	if(stat_tracking)
		GLOB.disposals_flush_shift_roundstat++

	if(!SEND_SIGNAL(src, COMSIG_DISPOSAL_FLUSH, flushed_items, air_contents)) //If the signal isnt recieved, we'll just expel immediately.
		if(length(contents))
			packet_expel(src, flushed_items, air_contents)

	air_contents = new(PRESSURE_TANK_VOLUME)	// new empty gas resv. Disposal packet takes ownership of the original one!
	flushing = FALSE

	// now reset disposal state
	flush = FALSE
	if(mode == DISPOSALMODE_CHARGED)	// if was ready,
		mode = DISPOSALMODE_CHARGING	// switch to charging

	update_icon()

// called when area power changes
/obj/machinery/disposal/power_change()
	..()	// do default setting/reset of stat NOPOWER bit
	update_icon()	// update icon
	return

// called when the bin expels items, generally from a disposal network, or trying to flush without a proper connection.
// should usually only occur if the pipe network if modified or delivering mail
/obj/machinery/disposal/proc/packet_expel(datum/source, list/expelled_items, datum/gas_mixture/gas)
	SIGNAL_HANDLER
	var/turf/T = get_turf(src)
	var/turf/target
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

	for(var/atom/movable/AM in expelled_items)
		target = get_offset_target_turf(loc, rand(5)-rand(5), rand(5)-rand(5))

		AM.forceMove(T)
		AM.pipe_eject(0)
		AM.throw_at(target, 5, 1)

	T.assume_air(gas)

/obj/machinery/disposal/hitby(atom/movable/source, datum/thrownthing/throwingdatum)
	if(!source.CanEnterDisposals())
		return ..()

	if(prob(75))
		source.forceMove(src)
		if(isliving(source))
			var/mob/living/to_be_dunked = source
			if(to_be_dunked.client)
				log_and_message_admins("has thrown [source] into \the [src]", throwingdatum?.get_thrower())
			//flush()
			visible_message("\The [source] lands in \the [src].") // "and triggers the flush system!"
		else
			visible_message("\The [source] lands in \the [src].")
	else
		visible_message("\The [source] bounces off of \the [src]'s rim!")
		return ..()
	update_icon()

// Ideally, deconstruct would be a proc on /machinery, but you cant have nice things with polaris.
// AKA: FUKKIN CHANGE THIS WHEN THAT HAPPENS!!!!!1!!   pls. -Reo
/obj/machinery/disposal/proc/deconstruct(disassembled = TRUE)
	var/turf/T = loc
	/* // More nice things... Someday we'll have flags_1 and then have proper support for anything being a hologram.
	if(!(flags_1 & NODECONSTRUCT_1))
		if(stored)
			stored.forceMove(T)
			src.transfer_fingerprints_to(stored)
			stored.anchored = FALSE
			stored.density = TRUE
			stored.update_icon()
	*/
	//This is temporary until the above gets used. Or it's permanant if you're reading this 5 years from now.
	var/obj/structure/disposalconstruct/C = new (src.loc/*, null, SOUTH, FALSE, src*/)
	transfer_fingerprints_to(C)
	C.ptype = 6 // 6 = disposal unit
	C.update_icon()
	C.anchored = TRUE
	C.density = TRUE
	//End of "temporary" code
	for(var/atom/movable/AM in src)
		AM.forceMove(T)
	//..() //*cough
	qdel(src) //Parent above should do this, but that's not a thing as of writing this.


/obj/machinery/disposal/proc/clean_items()
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

// Wall mounted base type
/obj/machinery/disposal/wall
	name = "inset disposal unit"
	icon_state = "wall"
	controls_iconstate = "wall"

	density = FALSE

/obj/machinery/disposal/wall/update_icon()
	. = ..()
	switch(dir)
		if(NORTH)
			pixel_x = 0
			pixel_y = -32
		if(SOUTH)
			pixel_x = 0
			pixel_y = 32
		if(EAST)
			pixel_x = -32
			pixel_y = 0
		if(WEST)
			pixel_x = 32
			pixel_y = 0

#undef DISPOSALMODE_EJECTONLY
#undef DISPOSALMODE_OFF
#undef DISPOSALMODE_CHARGING
#undef DISPOSALMODE_CHARGED
#undef SEND_PRESSURE
#undef PRESSURE_TANK_VOLUME
#undef PUMP_MAX_FLOW_RATE

/atom/movable/proc/CanEnterDisposals()
	return TRUE

/obj/item/projectile/CanEnterDisposals()
	return FALSE

/obj/effect/CanEnterDisposals()
	return FALSE

/obj/mecha/CanEnterDisposals()
	return FALSE
