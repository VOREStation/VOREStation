#define SPRINGTRAP_MANUAL_RESET_TIME 5 SECONDS
#define SPRINGTRAP_AUTO_RESET_TIME 15 SECONDS

/obj/structure/spring_trap
	name = "spring trap"
	desc = "A large tile, separated from the rest of the floor tiles, rigged to unleash a large amount of kinetic force the moment something steps on it!"
	layer = TURF_LAYER + 0.6
	anchored = TRUE

	var/sprung = TRUE
	var/distance = 3
	var/max_distance = 10
	/// Any value besides null means it will reset itself automatically. Set on construct, or by prefabs. (or varedits. How profane!)
	var/reset_time = null
	var/reset_timer_id = null
	/// Stored kit for this springtrap.
	var/obj/item/spring_trap_kit/stored_kit = /obj/item/spring_trap_kit

	icon = 'icons/obj/items.dmi'
	icon_state = "spring_trap"

/obj/structure/spring_trap/start_active
	sprung = FALSE

/obj/structure/spring_trap/self_resetting
	reset_time = SPRINGTRAP_AUTO_RESET_TIME
	stored_kit = /obj/item/spring_trap_kit/resetting

/obj/structure/spring_trap/self_resetting/start_active
	sprung = FALSE

/obj/structure/spring_trap/self_resetting_fast
	reset_time = SPRINGTRAP_AUTO_RESET_TIME / 3 //Three times faster
	stored_kit = /obj/item/spring_trap_kit/resetting_fast

/obj/structure/spring_trap/self_resetting_turbo/start_active
	sprung = FALSE

/obj/structure/spring_trap/adminbus
	name = "SPROINGINATOR 9000!!!"
	reset_time = 0.1 SECONDS //Not a define, because it's always going to be speedy.
	stored_kit = /obj/item/spring_trap_kit/adminbus

/obj/structure/spring_trap/adminbus/start_active
	sprung = FALSE

/obj/structure/spring_trap/update_icon()
	. = ..()
	if(sprung)
		icon_state = "[initial(icon_state)]-1"
	else
		icon_state = initial(icon_state)

/obj/structure/spring_trap/Initialize(mapload, obj/item/spring_trap_kit/resetting/crafted_kit)
	. = ..()
	//Create a kit for dropping when deconstructed.
	if(crafted_kit)
		stored_kit = crafted_kit
		stored_kit.forceMove(src)
	if(ispath(stored_kit))
		stored_kit = new stored_kit(src)
		stored_kit.reset_time = reset_time //Accounting for varedited and mapping subtypes
	if(reset_time)
		desc += "This one seems to have a motor that will re-tension the coil after [reset_time / 10] seconds." //Deciseconds
	update_icon() //Set sprung state if it's a newly built that needs to be set.

/obj/structure/spring_trap/Destroy()
	stored_kit = null
	. = ..()

/obj/structure/spring_trap/attackby(obj/item/W, mob/user, attack_modifier, click_parameters)
	. = ..()
	if(W.has_tool_quality(TOOL_WRENCH))
		user.visible_message(span_warning("[user] begins disassembling \the [src]"), span_notice("You start disassembling \the [src]"))
		playsound(src, W.usesound, 50, TRUE)

		if(!sprung) //Should've disarmed it first!
			if(!do_after(user, 2 SECONDS, target = src)) // Flat time because Hugbox.
				to_chat(user, span_danger("You feel like you narrowly avoided an incident..."))
				return
			user.visible_message(span_warning("[user] tries to disassemble \the [src], but it goes off, launching them!"))
			trigger(user, TRUE)
			return

		if(do_after(user, 8 SECONDS * W.toolspeed, target = src))
			user.visible_message(span_warning("[user] has disassembled \the [src]."), span_notice("You disassemble \the [src]."))
			sprung = TRUE
			stored_kit.forceMove(get_turf(src))
			qdel(src)

	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		user.visible_message(span_warning("[user] starts adjusting the spring in \the [src]"), span_notice("you start adjusting the spring in \the [src]..."))
		playsound(src, W.usesound, 50, TRUE)

		if(!sprung) //Should've disarmed it first! Also copied from above.
			if(!do_after(user, 2 SECONDS, target = src))
				to_chat(user, span_danger("You feel like you narrowly avoided an incident..."))
				return
			user.visible_message(span_warning("[user] tries to adjust \the [src]'s spring, but it goes off, launching them!"))
			trigger(user, TRUE)
			return

		if(do_after(user, 6 SECONDS * W.toolspeed, target = src))
			distance = tgui_input_number(user, "Pick distance", "distance", distance, min_value = 1, max_value = max_distance)
			user.visible_message(span_warning("[user] adjusts the spring in \the [src]"), span_notice("You adjust the spring in \the [src]"))
			return

	if(W.has_tool_quality(TOOL_CROWBAR))
		if(!sprung) //Should've disarmed it first! Except this time it doesnt give you a chance to set the direction..
			user.visible_message(span_warning("[user] starts adjusting \the [src]'s direction"), span_notice("You start adjusting \the [src]'s direction"))
			playsound(src, W.usesound, 50, TRUE)
			if(!do_after(user, 2 SECONDS, target = src)) // Flat time because Hugbox.
				to_chat(user, span_danger("You feel like you narrowly avoided an incident..."))
				return

		var/temp_dir = tgui_input_list(user, "Pick new direction", "direction", list("north", "south", "east", "west"), SOUTH)
		if(!temp_dir) //Cancel action
			return
		if(temp_dir == dir)
			to_chat(user, span_warning("\The [src] is already facing in that direction."))
			return

		//Actually start adjusting at this point
		playsound(src, W.usesound, 50, TRUE)
		user.visible_message(span_danger("[user] starts adjusting \the [src]'s direction"), span_notice("You start adjusting \the [src]'s direction"))
		if(do_after(user, 6 SECONDS * W.toolspeed, target = src))
			dir = text2dir(temp_dir)
			return

/obj/structure/spring_trap/attack_hand(mob/user)
	if(!sprung)
		user.visible_message(span_danger("[user] starts to disarm \the [src]."), span_notice("You begin disarming \the [src]."), "You hear the slow creaking of a spring.")
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)

		if(do_after(user, 2 SECONDS, target = src)) //Misclick hugboxxing, mostly.
			to_chat(user, span_userdanger("You remove the tension latch. If you stop now, the trap will go off!"))
			if(do_after(user, 8 SECONDS, target = src))
				user.visible_message(span_danger("[user] has disarmed \the [src]."), span_notice("You have disarmed \the [src]."))
				sprung = TRUE
				update_icon()
			else
				trigger(user, TRUE)
	else
		var/time_to_reset = SPRINGTRAP_MANUAL_RESET_TIME //Dynamic time to reset manually. Decreased if you're assisting an auto-resetting trap along.
		if(reset_timer_id)
			time_to_reset = min(time_to_reset, (timeleft(reset_timer_id) / 2)) //Set reset time to half of remaining auto-reset time, if it's smaller than the default time.
		user.visible_message(span_danger("[user] starts to reset \the [src]."), span_notice("You begin resetting \the [src]."), "You hear the slow creaking of a spring.")
		if(do_after(user, time_to_reset, target = src))
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			if(reset_timer_id)
				deltimer(reset_timer_id) //Should always complete before the timer does, if one exists.
			sprung = FALSE
			update_icon()

/obj/structure/spring_trap/proc/trigger(mob/living/target)
	var/turf/T = get_turf(src)
	if(!T)
		return

	SSmotiontracker.ping(src, 100)
	playsound(src, 'sound/effects/metal_close.ogg', 70, 1)
	visible_message(span_danger("[target] triggers \the [src]."), span_danger("You trigger \the [src]."), span_infoplain(span_danger("you hear a SPROING!")))

	var/turf/land_turf = get_ranged_target_turf(T, dir, max_distance)

	for(var/atom/movable/thing in (T.contents | target))
		if(thing.anchored || thing.hovering || thing == src)
			continue
		if(thing.is_incorporeal() || istype(thing, /obj/effect) || istype(thing, /obj/item/projectile))
			continue
		if(isliving(target))
			var/mob/living/L = target
			if(L.flying)
				continue
			if(L.ckey)
				log_and_message_admins("has been yote by a [name] at \the [get_area(loc)], last touched by [forensic_data?.get_lastprint()]", L)

		thing.throw_at(land_turf, distance, 1)

	sprung = TRUE
	if(reset_time)
		reset_timer_id = addtimer(CALLBACK(src, PROC_REF(reset)), reset_time, TIMER_DELETE_ME | TIMER_STOPPABLE)
	update_icon()

/obj/structure/spring_trap/Crossed(atom/movable/AM)
	. = ..()
	if(sprung) // Not set.
		return
	if(AM.hovering)
		return
	if(AM.is_incorporeal() || istype(AM, /obj/effect) || istype(AM, /obj/item/projectile))
		return
	if(AM.throwing)
		addtimer(CALLBACK(src, PROC_REF(throw_check), AM), 5) //Idea stolen from TG glass table smashing code
		return
	else
		if(isliving(AM))
			var/mob/living/L = AM
			if(L.m_intent == I_WALK && prob(95)) //small change to trigger when trying to step past it...
				return
	trigger(AM)

/obj/structure/spring_trap/proc/throw_check(atom/movable/AM)
	if(AM.hovering)
		return
	if(AM.is_incorporeal()) //Shadekin phased out in the short period after being thrown on, I guess?
		return
	if(AM.loc == get_turf(src))
		trigger(AM)

/obj/structure/spring_trap/proc/reset()
	if(!sprung)
		return FALSE
	SSmotiontracker.ping(src, 100)
	visible_message(span_notice("[src] clicks as it resets itself."), "You hear the slow creaking of a spring, followed by a click.")
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	sprung = FALSE
	update_icon()

/obj/item/spring_trap_kit
	name = "spring trap assembly kit"
	desc = "A large metal tile and a large, home-made spring bundled together for easy assembly. \n\n" span_notice("It could have a motor added to let it self-reset.")
	icon = 'icons/obj/items.dmi'
	icon_state = "spring_trap-kit"
	matter = list(MAT_STEEL = MATERIAL_COST(9))
	/// Sets the cooldown on construct. Null means only manual reset.
	var/reset_time = null
	var/motor_upgrades = 0

/obj/item/spring_trap_kit/resetting
	name = "self-resetting spring trap assembly kit"
	desc = "A large metal tile, a large, home-made spring and a motor bundled together for easy assembly. \n\n" + span_notice("Another motor could be added to let it reset even faster!")
	matter = list(MAT_STEEL = MATERIAL_COST(9.8), MAT_GLASS = MATERIAL_COST(0.013)) // 9 sheets, plus the cost of a motor.
	reset_time = SPRINGTRAP_AUTO_RESET_TIME
	motor_upgrades = 1

/obj/item/spring_trap_kit/resetting_fast
	name = "turbo self-resetting spring trap assembly kit"
	desc = "A large metal tile, a large, home-made spring and two motors bundled together for easy assembly."
	matter = list(MAT_STEEL = MATERIAL_COST(10.6), MAT_GLASS = MATERIAL_COST(0.026)) // 9 sheets, plus the cost of two motors.
	reset_time = SPRINGTRAP_AUTO_RESET_TIME / 3 //Fast
	motor_upgrades = 2

/obj/item/spring_trap_kit/custom //For mapperbus traps.
	name = "self-resetting spring trap assembly kit"
	desc = "A large metal tile, a large home-made spring and a motor bundled together for easy assembly. \n\n" + span_warning("The motor seems to be non-standard, and is permanantly affixed to the tile...")
	motor_upgrades = 10 //So you cant modify it.

/obj/item/spring_trap_kit/custom/adminbus
	name = "SPROINGINATOR 9000 assembly kit"
	desc = "SPROING! SPROING! SPROING! THE BOUNCING NEVER ENDS!"
	reset_time = 0.1 SECONDS //the SECONDS macro feels a bit unnessesary tbh.
	motor_upgrades = 9001 // IT'S A DATED OLD MEME!!

/obj/item/spring_trap_kit/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return TRUE
	user.visible_message(span_danger("[user] starts to construct \the [src]."), span_notice("You start constructing \the [src]"))
	if(do_after(user, 5 SECONDS, target = src))
		build_trap(user)

/obj/item/spring_trap_kit/attackby(obj/item/W, mob/user)
	. = ..()
	if(motor_upgrades > 5) //Maybe not a great way to do it, but it can be adjusted later if more levels are desired or whatever.
		return
	if(istype(W, /obj/item/stock_parts/motor))
		if(motor_upgrades >= 2)
			to_chat(user, span_warning("\The [src] is already fully upgraded, it cant support any more motors!"))
			return
		if(!do_after(user, 3 SECONDS, src))
			return
		var/obj/item/spring_trap_kit/type_to_create = /obj/item/spring_trap_kit
		switch(motor_upgrades)
			if(0)
				type_to_create = /obj/item/spring_trap_kit/resetting
			if(1)
				type_to_create = /obj/item/spring_trap_kit/resetting_fast
		new type_to_create(drop_location()) //Should place at the user's feet, or the tile it's on, or in the vorebelly the user is in one, or whatever else.
		qdel(W) //Motor Gone
		qdel(src)
	if(W.has_tool_quality(TOOL_WRENCH))
		user.visible_message(span_notice("[user] starts disassmbling \the [src]."), span_notice("You start disassembling \the [src]"))
		if(!do_after(user, 3 SECONDS))
			return
		user.visible_message(span_notice("[user] diassembles \the [src]"), span_notice("You disassemble \the [src]"))
		new /obj/item/stack/sheets/steel(drop_location(), 8)
		new /obj/item/stack/rods(drop_location(), 2)
		for(var/i, i < motor_upgrades, i++)
			new /obj/item/stock_parts/motor(drop_location())
		qdel(src)

/obj/item/spring_trap_kit/proc/build_trap(mob/user)
	playsound(src, 'sound/machines/click.ogg', 50, 1)
	var/obj/structure/spring_trap/spring_trap = new(get_turf(user), src)
	spring_trap.add_fingerprint(user)
	spring_trap.dir = user.dir
	if(reset_time)
		spring_trap.reset_time = reset_time
	user.drop_from_inventory(src, get_turf(user))
	src.forceMove(spring_trap)

/obj/item/spring_trap_kit/custom/adminbus/build_trap(mob/user) //Copypasta, ew, but also only for adminbus version
	playsound(src, 'sound/machines/click.ogg', 50, 1)
	var/obj/structure/spring_trap/spring_trap = new(get_turf(user), src)
	spring_trap.add_fingerprint(user)
	spring_trap.dir = user.dir
	spring_trap.name = "SPROINGINATOR 9000!!!" //All because I wanted it to have a funny name... :(
	if(reset_time)
		spring_trap.reset_time = reset_time
	user.drop_from_inventory(src, get_turf(user))
	src.forceMove(spring_trap)

#undef SPRINGTRAP_MANUAL_RESET_TIME
#undef SPRINGTRAP_AUTO_RESET_TIME
