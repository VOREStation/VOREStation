//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health regained per stack amount used

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
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
	var/heat_proof = 0 // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	var/maxhealth = 300
	var/health
	var/destroy_hits = 10 //How many strong hits it takes to destroy the door
	var/min_force = 10 //minimum amount of force needed to damage the door with a melee weapon
	var/hitsound = 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon
	var/repairing = 0
	var/block_air_zones = 1 //If set, air zones cannot merge across the door even when it is opened.
	var/close_door_at = 0 //When to automatically close the door, if possible

	var/anim_length_before_density = 3
	var/anim_length_before_finalize = 7

	//Multi-tile doors
	dir = EAST
	var/width = 1

	// turf animation
	var/atom/movable/overlay/c_animation = null

/obj/machinery/door/attack_generic(var/mob/user, var/damage)
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
			visible_message("<span class='danger'>\The [user] smashes into [src]!</span>")
			playsound(src, S.attack_sound, 75, 1)
			take_damage(damage)
		else
			visible_message("<b>\The [user]</b> bonks \the [src] harmlessly.")
	user.do_attack_animation(src)

/obj/machinery/door/New()
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
	return

/obj/machinery/door/Destroy()
	density = FALSE
	update_nearby_tiles()
	. = ..()

/obj/machinery/door/process()
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = world.time + next_close_wait()
			spawn(0)
				close()
		else
			close_door_at = 0
	if (..() == PROCESS_KILL && !close_door_at)
		return PROCESS_KILL

/obj/machinery/door/proc/autoclose_in(wait)
	close_door_at = world.time + wait
	START_MACHINE_PROCESSING(src)

/obj/machinery/door/proc/can_open()
	if(!density || operating || !ticker)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operating || !ticker)
		return 0
	return 1

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
	if(istype(AM, /obj/item/device/uav))
		if(check_access(null))
			open()
		else
			do_animate("deny")

	if(istype(AM, /mob/living/bot))
		var/mob/living/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density)
			if(mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
				open()
			else
				do_animate("deny")
		return
	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
				open()
			else
				do_animate("deny")

/obj/machinery/door/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density

/obj/machinery/door/CanZASPass(turf/T, is_zone)
	if(is_zone)
		return !block_air_zones // Block merging unless block_air_zones = 0
	return !density // Block airflow unless density = FALSE

/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating)	return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(density)
		if(allowed(user))	open()
		else				do_animate("deny")
	return

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	var/damage = Proj.get_structure_damage()

	// Emitter Blasts - these will eventually completely destroy the door, given enough time.
	if (damage > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			visible_message("<span class='danger'>\The [src.name] disintegrates!</span>")
			switch (Proj.damage_type)
				if(BRUTE)
					new /obj/item/stack/material/steel(src.loc, 2)
					new /obj/item/stack/rods(src.loc, 3)
				if(BURN)
					new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
			qdel(src)

	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, 100))



/obj/machinery/door/hitby(AM as mob|obj, var/speed=5)

	..()
	visible_message("<span class='danger'>[src.name] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 15 * (speed/5)
	else
		tforce = AM:throwforce * (speed/5)
	playsound(src, hitsound, 100, 1)
	take_damage(tforce)
	return

/obj/machinery/door/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/attack_hand(mob/user as mob)
	return src.attackby(user, user)

/obj/machinery/door/attack_tk(mob/user as mob)
	if(requiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(istype(I))
		if(attackby_vr(I, user))	//VOREStation begin: Fireproofing
			return					//VOREStation begin: Fireproofing
		if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
			if(stat & BROKEN)
				to_chat(user, "<span class='notice'>It looks like \the [src] is pretty busted. It's going to need more than just patching up now.</span>")
				return
			if(health >= maxhealth)
				to_chat(user, "<span class='notice'>Nothing to fix!</span>")
				return
			if(!density)
				to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
				return

			//figure out how much metal we need
			var/amount_needed = (maxhealth - health) / DOOR_REPAIR_AMOUNT
			amount_needed = (round(amount_needed) == amount_needed)? amount_needed : round(amount_needed) + 1 //Why does BYOND not have a ceiling proc?

			var/obj/item/stack/stack = I
			var/amount_given = amount_needed - repairing
			var/mats_given = stack.get_amount()
			if(repairing && amount_given <= 0)
				to_chat(user, "<span class='warning'>You must weld or remove \the [get_material_name()] from \the [src] before you can add anything else.</span>")
			else
				if(mats_given >= amount_given)
					if(stack.use(amount_given))
						repairing += amount_given
				else
					if(stack.use(mats_given))
						repairing += mats_given
						amount_given = mats_given
			if(amount_given)
				to_chat(user, "<span class='notice'>You fit [amount_given] [stack.singular_name]\s to damaged and broken parts on \the [src].</span>")

			return

		if(repairing && I.has_tool_quality(TOOL_WELDER))
			if(!density)
				to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
				return

			var/obj/item/weapon/weldingtool/welder = I.get_welder()
			if(welder.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>You start to fix dents and weld \the [get_material_name()] into place.</span>")
				playsound(src, welder.usesound, 50, 1)
				if(do_after(user, (5 * repairing) * welder.toolspeed) && welder && welder.isOn())
					to_chat(user, "<span class='notice'>You finish repairing the damage to \the [src].</span>")
					health = between(health, health + repairing*DOOR_REPAIR_AMOUNT, maxhealth)
					update_icon()
					repairing = 0
			return

		if(repairing && I.has_tool_quality(TOOL_CROWBAR))
			var/datum/material/mat = get_material()
			var/obj/item/stack/material/repairing_sheet = mat.place_sheet(loc, repairing)
			repairing = 0
			to_chat(user, "<span class='notice'>You remove \the [repairing_sheet].</span>")
			playsound(src, I.usesound, 100, 1)
			return

		//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
		if(src.density && istype(I, /obj/item/weapon) && user.a_intent == I_HURT && !istype(I, /obj/item/weapon/card))
			var/obj/item/weapon/W = I
			user.setClickCooldown(user.get_attack_speed(W))
			if(W.damtype == BRUTE || W.damtype == BURN)
				user.do_attack_animation(src)
				if(W.force < min_force)
					user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W] with no visible effect.</span>")
				else
					user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [W]!</span>")
					playsound(src, hitsound, 100, 1)
					take_damage(W.force)
			return

	if(src.operating > 0 || isrobot(user))
		return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.operating)
		return

	if(src.allowed(user) && operable())
		if(src.density)
			open()
		else
			close()
		return

	if(src.density)
		do_animate("deny")
	return

/obj/machinery/door/emag_act(var/remaining_charges)
	if(density && operable())
		do_animate("spark")
		sleep(6)
		open()
		operating = -1
		return 1

/obj/machinery/door/take_damage(var/damage)
	var/initialhealth = src.health
	src.health = max(0, src.health - damage)
	if(src.health <= 0 && initialhealth > 0)
		src.set_broken()
	else if(src.health < src.maxhealth / 4 && initialhealth >= src.maxhealth / 4)
		visible_message("\The [src] looks like it's about to break!" )
	else if(src.health < src.maxhealth / 2 && initialhealth >= src.maxhealth / 2)
		visible_message("\The [src] looks seriously damaged!" )
	else if(src.health < src.maxhealth * 3/4 && initialhealth >= src.maxhealth * 3/4)
		visible_message("\The [src] shows signs of damage!" )
	update_icon()
	return


/obj/machinery/door/examine(mob/user)
	. = ..()
	if(src.health <= 0)
		. += "It is broken!"
	else if(src.health < src.maxhealth / 4)
		. += "It looks like it's about to break!"
	else if(src.health < src.maxhealth / 2)
		. += "It looks seriously damaged!"
	else if(src.health < src.maxhealth * 3/4)
		. += "It shows signs of damage!"


/obj/machinery/door/proc/set_broken()
	stat |= BROKEN
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[src.name] breaks!" )
	update_icon()
	return


/obj/machinery/door/emp_act(severity)
	if(prob(20/severity) && (istype(src,/obj/machinery/door/airlock) || istype(src,/obj/machinery/door/window)) )
		spawn(0)
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
			spawn(0)
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

	do_animate("opening")
	icon_state = "door0"
	set_opacity(0)
	sleep(anim_length_before_density)
	src.density = FALSE
	update_nearby_tiles()
	sleep(anim_length_before_finalize)
	src.layer = open_layer
	explosion_resistance = 0
	update_icon()
	set_opacity(0)
	operating = 0

	if(autoclose)
		autoclose_in(next_close_wait())

	return 1

/obj/machinery/door/proc/next_close_wait()
	return (normalspeed ? 150 : 5)

/obj/machinery/door/proc/close(var/forced = 0)
	if(!can_close(forced))
		return
	operating = 1

	close_door_at = 0
	do_animate("closing")
	sleep(anim_length_before_density)
	src.density = TRUE
	explosion_resistance = initial(explosion_resistance)
	src.layer = closed_layer
	update_nearby_tiles()
	sleep(anim_length_before_finalize)
	update_icon()
	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	operating = 0

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		qdel(fire)

	return 1

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	return ..(M)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	if(!air_master)
		return 0

	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		air_master.mark_for_update(turf)

	return 1

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
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
