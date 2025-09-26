/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/doorint.dmi'
	icon_state = "door1"
	anchored = TRUE
	opacity = 1
	density = TRUE
	can_atmos_pass = ATMOS_PASS_PROC
	layer = DOOR_OPEN_LAYER
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	var/open_layer = DOOR_OPEN_LAYER
	var/closed_layer = DOOR_CLOSED_LAYER

	var/visible = 1
	var/p_open = 0
	var/operating = 0
	var/autoclose = 0
	var/glass = 0
	var/normalspeed = 1
	var/heat_proof = FALSE // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	var/maxhealth = 300
	var/health
	var/destroy_hits = 10 //How many strong hits it takes to destroy the door
	var/min_force = 10 //minimum amount of force needed to damage the door with a melee weapon
	var/hitsound = 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon
	//var/repairing = 0 //VOREstation Edit: We're not using materials anymore
	var/block_air_zones = 1 //If set, air zones cannot merge across the door even when it is opened.
	var/close_door_at = 0 //When to automatically close the door, if possible

	var/anim_length_before_density = 0.3 SECONDS
	var/anim_length_before_finalize = 0.7 SECONDS

	//Multi-tile doors
	dir = EAST
	var/width = 1

	// turf animation
	var/atom/movable/overlay/c_animation = null

	var/reinforcing = 0
	var/tintable = 0
	var/icon_tinted
	var/id_tint

/obj/machinery/door/attack_generic(var/mob/user, var/damage)
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
			visible_message(span_danger("\The [user] smashes into [src]!"))
			playsound(src, S.attack_sound, 75, 1)
			take_damage(damage)
		else
			visible_message(span_infoplain(span_bold("\The [user]") + " bonks \the [src] harmlessly."))
	user.do_attack_animation(src)

/obj/machinery/door/Initialize(mapload)
	. = ..()
	if(density)
		layer = closed_layer
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(get_turf(src))
	else
		layer = open_layer
		explosion_resistance = 0


	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	health = maxhealth
	update_icon()

	update_nearby_tiles(need_rebuild=1)

/obj/machinery/door/Destroy()
	density = FALSE
	update_nearby_tiles()
	. = ..()
	/*
	var/obj/effect/step_trigger/claymore_laser/las = locate() in loc
	if(las)
		las.Trigger(src)
	*/

/obj/machinery/door/process()
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = world.time + next_close_wait()
			close()
		else
			close_door_at = 0
	if (..() == PROCESS_KILL && !close_door_at)
		return PROCESS_KILL

/obj/machinery/door/proc/autoclose_in(wait)
	close_door_at = world.time + wait
	START_MACHINE_PROCESSING(src)

/obj/machinery/door/proc/can_open()
	if(!density || operating || !SSticker)
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_DOOR_CAN_OPEN) & DOOR_DENY_OPEN)
		return FALSE
	return TRUE

/obj/machinery/door/proc/can_close()
	if(density || operating || !SSticker)
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_DOOR_CAN_CLOSE) & DOOR_DENY_CLOSE)
		return FALSE
	return TRUE

/obj/machinery/door/Bumped(atom/AM)
	. = ..()
	if(p_open || operating)
		return

	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10)
			return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(M.restrained() && !check_access(null))
			return
		else if(istype(M, /mob/living/simple_mob/animal/passive/mouse) && !(M.ckey))	//VOREStation Edit: Make wild mice
			return																		//VOREStation Edit: unable to open doors
		else
			bumpopen(M)
		return

	if(istype(AM, /obj/item/uav))
		if(check_access(null))
			open()
		else
			do_animate("deny")
		return

	if(isbot(AM))
		var/mob/living/bot/bot = AM
		if(check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density)
			if(mecha.occupant && (allowed(mecha.occupant) || check_access_list(mecha.operation_req_access)))
				open()
			else
				do_animate("deny")
		return

	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (allowed(wheel.pulling)))
				open()
			else
				do_animate("deny")
		return

/obj/machinery/door/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density

/obj/machinery/door/CanZASPass(turf/T, is_zone)
	if(is_zone)
		return !block_air_zones // Block merging unless block_air_zones = 0
	return !density // Block airflow unless density = FALSE

/obj/machinery/door/proc/bumpopen(mob/user)
	if(!user)
		return
	if(operating)
		return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	if(SEND_SIGNAL(user, COMSIG_MOB_BUMPED_DOOR_OPEN, src) & DOOR_STOP_BUMP)
		return
	add_fingerprint(user)
	if(density)
		if(allowed(user))
			open()
		else
			do_animate("deny")
	return

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	var/damage = Proj.get_structure_damage()

	// Emitter Blasts - these will eventually completely destroy the door, given enough time.
	if (damage > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			visible_message(span_danger("\The [name] disintegrates!"))
			switch (Proj.damage_type)
				if(BRUTE)
					new /obj/item/stack/material/steel(loc, 2)
					new /obj/item/stack/rods(loc, 3)
				if(BURN)
					new /obj/effect/decal/cleanable/ash(loc) // Turn it to ashes!
			qdel(src)

	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, 100))



/obj/machinery/door/hitby(atom/movable/source, var/speed=5)
	..()
	visible_message(span_danger("[name] was hit by [source]."))
	var/tforce = 0
	if(ismob(source))
		tforce = 15 * (speed/THROWFORCE_SPEED_DIVISOR)
	else if(isobj(source))
		var/obj/object = source
		if(isitem(object))
			var/obj/item/our_item = object
			tforce = our_item.throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
		else
			tforce = object.w_class * (speed/THROWFORCE_SPEED_DIVISOR)
	playsound(src, hitsound, 100, 1)
	take_damage(tforce)

/obj/machinery/door/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/door/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	return try_to_activate_door(user)

/obj/machinery/door/attack_tk(mob/user)
	if(requiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attackby(obj/item/I, mob/user)
	add_fingerprint(user)

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == MAT_PLASTEEL)
		if(heat_proof)
			to_chat(user, span_warning("\The [src] is already reinforced."))
			return
		if((stat & BROKEN) || (health < maxhealth))
			to_chat(user, span_notice("It looks like \the [src] broken. Repair it before reinforcing it."))
			return
		if(!density)
			to_chat(user, span_warning("\The [src] must be closed before you can reinforce it."))
			return

		var/amount_needed = 2

		var/obj/item/stack/stack = I
		var/amount_given = amount_needed - reinforcing
		var/mats_given = stack.get_amount()
		var/singular_name = stack.singular_name
		if(reinforcing && amount_given <= 0)
			to_chat(user, span_warning("You must weld or remove \the plasteel from \the [src] before you can add anything else."))
		else
			if(mats_given >= amount_given)
				if(stack.use(amount_given))
					reinforcing += amount_given
			else
				if(stack.use(mats_given))
					reinforcing += mats_given
					amount_given = mats_given
		if(amount_given)
			to_chat(user, span_notice("You fit [amount_given] [singular_name]\s on \the [src]."))
		return

	if(reinforcing && I.has_tool_quality(TOOL_CROWBAR))
		var/obj/item/stack/material/plasteel/reinforcing_sheet = new /obj/item/stack/material/plasteel(get_turf(src), reinforcing)
		reinforcing = 0
		to_chat(user, span_notice("You remove \the [reinforcing_sheet]."))
		playsound(src, I.usesound, 100, 1)
		return

	if(I.has_tool_quality(TOOL_WELDER))
		if(reinforcing)
			if(!density)
				to_chat(user, span_warning("\The [src] must be closed before you can reinforce it."))
				return

			if(reinforcing < 2)
				to_chat(user, span_warning("You will need more plasteel to reinforce \the [src]."))
				return

			var/obj/item/weldingtool/welder = I.get_welder()
			if(welder.remove_fuel(0,user))
				to_chat(user, span_notice("You start welding the plasteel into place."))
				playsound(src, welder.usesound, 50, 1)
				if(do_after(user, 1 SECOND * welder.toolspeed, target = src) && welder && welder.isOn())
					to_chat(user, span_notice("You finish reinforcing \the [src]."))
					heat_proof = TRUE
					update_icon()
					reinforcing = 0
			return

		if(health < maxhealth)
			if(!density)
				to_chat(user, span_warning("\The [src] must be closed before you can repair it."))
				return

			var/obj/item/weldingtool/welder = I.get_welder()
			if(welder.remove_fuel(0,user))
				to_chat(user, span_notice("You start to fix dents and repair \the [src]."))
				playsound(src, welder.usesound, 50, 1)
				var/repairtime = maxhealth - health //Since we're not using materials anymore... We'll just calculate how much damage there is to repair.
				if(do_after(user, repairtime * welder.toolspeed, target = src) && welder && welder.isOn())
					to_chat(user, span_notice("You finish repairing the damage to \the [src]."))
					health = maxhealth
					update_icon()
			return

	// Handle signals
	if(..())
		return

	//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
	if(density && istype(I, /obj/item) && user.a_intent == I_HURT && !istype(I, /obj/item/card))
		var/obj/item/W = I
		user.setClickCooldown(user.get_attack_speed(W))
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			if(W.force < min_force)
				user.visible_message(span_danger("\The [user] hits \the [src] with \the [W] with no visible effect."))
			else
				user.visible_message(span_danger("\The [user] forcefully strikes \the [src] with \the [W]!"))
				playsound(src, hitsound, 100, 1)
				take_damage(W.force)
		return

	return try_to_activate_door(user)

/obj/machinery/door/proc/try_to_activate_door(mob/user)
	add_fingerprint(user)
	if(operating || isrobot(user))
		return FALSE //borgs can't attack doors open because it conflicts with their AI-like interaction with them.
	if(allowed(user) && operable())
		if(density)
			open()
		else
			close()
		return TRUE
	if(density)
		do_animate("deny")

	return FALSE

/obj/machinery/door/emag_act(var/remaining_charges)
	if(density && operable())
		do_animate("spark")
		addtimer(CALLBACK(src, PROC_REF(trigger_emag)), 0.6 SECONDS)
		return TRUE

/obj/machinery/door/proc/trigger_emag()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	open()
	operating = -1

/obj/machinery/door/take_damage(var/damage)
	var/initialhealth = health
	health = max(0, health - damage)
	if(health <= 0 && initialhealth > 0)
		set_broken()
	else if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
		visible_message("\The [src] looks like it's about to break!" )
	else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
		visible_message("\The [src] looks seriously damaged!" )
	else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
		visible_message("\The [src] shows signs of damage!" )
	update_icon()
	return


/obj/machinery/door/examine(mob/user)
	. = ..()
	if(health <= 0)
		. += "It is broken!"
	else if(health < maxhealth / 4)
		. += "It looks like it's about to break!"
	else if(health < maxhealth / 2)
		. += "It looks seriously damaged!"
	else if(health < maxhealth * 3/4)
		. += "It shows signs of damage!"


/obj/machinery/door/proc/set_broken()
	stat |= BROKEN
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[name] breaks!" )
	update_icon()
	return


/obj/machinery/door/emp_act(severity)
	if(prob(20/severity) && (istype(src,/obj/machinery/door/airlock) || istype(src,/obj/machinery/door/window)) )
		open()
	..()


/obj/machinery/door/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(25))
				qdel(src)
			else
				take_damage(300)
		if(3.0)
			if(prob(80))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
			else
				take_damage(150)
	return

/obj/machinery/door/blob_act()
	if(density) // If it's closed.
		if(stat & BROKEN)
			open(1)
		else
			take_damage(100)

/obj/machinery/door/update_icon()
	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"
	SSradiation.resistance_cache.Remove(get_turf(src))
	return


/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && !(stat & (NOPOWER|BROKEN)))
				flick("door_deny", src)
				playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)
	return

/obj/machinery/door/proc/open(var/forced = 0)
	if(!can_open(forced))
		return
	operating = 1

	SEND_SIGNAL(src, COMSIG_DOOR_OPEN, forced)

	do_animate("opening")
	icon_state = "door0"
	set_opacity(0)
	addtimer(CALLBACK(src, PROC_REF(open_internalsetdensity),forced), anim_length_before_density)

/obj/machinery/door/proc/open_internalsetdensity(var/forced = 0)
	PRIVATE_PROC(TRUE) //do not touch this or BYOND will devour you
	SHOULD_NOT_OVERRIDE(TRUE)
	density = FALSE
	update_nearby_tiles()
	addtimer(CALLBACK(src, PROC_REF(open_internalfinish),forced), anim_length_before_finalize)

/obj/machinery/door/proc/open_internalfinish(var/forced = 0)
	PRIVATE_PROC(TRUE) //do not touch this or BYOND will devour you
	SHOULD_NOT_OVERRIDE(TRUE)
	layer = open_layer
	explosion_resistance = 0
	update_icon()
	set_opacity(0)
	operating = 0

	/*
	var/obj/effect/step_trigger/claymore_laser/las = locate() in loc
	if(las)
		addtimer(CALLBACK(las, TYPE_PROC_REF(/obj/effect/step_trigger/claymore_laser,Trigger), src), 5)
	*/

	if(autoclose)
		autoclose_in(next_close_wait())
	return TRUE

/obj/machinery/door/proc/next_close_wait()
	var/lowest_temp = T20C
	var/highest_temp = T0C
	for(var/D in GLOB.cardinal)
		var/turf/target = get_step(loc, D)
		if(!target.density)
			var/datum/gas_mixture/airmix = target.return_air()
			if(!airmix)
				continue
			if(airmix.temperature < lowest_temp)
				lowest_temp = airmix.temperature
			if(airmix.temperature > highest_temp)
				highest_temp = airmix.temperature
	// Fast close to keep in the heat
	var/open_speed = 150
	if(abs(highest_temp - lowest_temp) >= 5)
		open_speed = 15
	return (normalspeed ? open_speed : 5)

/obj/machinery/door/proc/close(var/forced = 0)
	if(!can_close(forced))
		return
	operating = 1

	SEND_SIGNAL(src, COMSIG_DOOR_CLOSE, forced)

	close_door_at = 0
	do_animate("closing")
	addtimer(CALLBACK(src, PROC_REF(close_internalsetdensity),forced), anim_length_before_density)

/obj/machinery/door/proc/close_internalsetdensity(var/forced = 0)
	PRIVATE_PROC(TRUE) //do not touch this or BYOND will devour you
	SHOULD_NOT_OVERRIDE(TRUE)
	density = TRUE
	explosion_resistance = initial(explosion_resistance)
	layer = closed_layer
	update_nearby_tiles()
	addtimer(CALLBACK(src, PROC_REF(close_internalfinish),forced), anim_length_before_finalize)

/obj/machinery/door/proc/close_internalfinish(var/forced = 0)
	PROTECTED_PROC(TRUE) //do not touch this or BYOND will devour you
	update_icon()
	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	operating = 0

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		qdel(fire)

	/*
	var/obj/effect/step_trigger/claymore_laser/las = locate() in loc
	if(las)
		addtimer(CALLBACK(las, TYPE_PROC_REF(/obj/effect/step_trigger/claymore_laser,Trigger), src), 1)
	*/

	return TRUE

/obj/machinery/door/proc/requiresID()
	return TRUE

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	. = ..()

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	if(!SSair)
		return FALSE

	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		SSair.mark_for_update(turf)

	return TRUE

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(density && (opacity || heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles()

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'
