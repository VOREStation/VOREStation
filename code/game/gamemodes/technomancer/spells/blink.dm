/datum/technomancer/spell/blink
	name = "Blink"
	desc = "Force the target to teleport a short distance away.  This target could be anything from something lying on the ground, \
	to someone trying to fight you, or even yourself.  Using this on someone next to you makes their potential distance after \
	teleportation greater.  Self casting has the greatest potential for distance, as well as the cheapest cost."
	enhancement_desc = "Blink distance is increased greatly."
	spell_power_desc = "Blink distance is scaled up with more spell power."
	cost = 50
	obj_path = /obj/item/spell/blink
	ability_icon_state = "tech_blink"
	category = UTILITY_SPELLS

/obj/item/spell/blink
	name = "blink"
	desc = "Teleports you or someone else a short distance away."
	icon_state = "blink"
	cast_methods = CAST_RANGED | CAST_MELEE | CAST_USE
	aspect = ASPECT_TELE

/proc/safe_blink(atom/movable/AM, var/range = 3)
	if(AM.anchored || !AM.loc)
		return
	var/turf/starting = get_turf(AM)
	var/list/targets = list()

	if(starting.block_tele)
		return

	valid_turfs:
		for(var/turf/simulated/T in range(AM, range))
			if(T.density || T.block_tele || istype(T, /turf/simulated/mineral)) //Don't blink to vacuum or a wall
				continue
			for(var/atom/movable/stuff in T.contents)
				if(stuff.density)
					continue valid_turfs
			targets.Add(T)

	if(!targets.len)
		return
	var/turf/simulated/destination = null

	destination = pick(targets)

	if(destination)
		if(ismob(AM))
			var/mob/living/L = AM
			if(L.buckled)
				L.buckled.unbuckle_mob()
		AM.forceMove(destination)
		AM.visible_message(span_infoplain(span_bold("\The [AM]") + " vanishes!"))
		to_chat(AM, span_notice("You suddenly appear somewhere else!"))
		new /obj/effect/effect/sparks(destination)
		new /obj/effect/effect/sparks(starting)
	return

/obj/item/spell/blink/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		if(!within_range(AM))
			to_chat(user, span_warning("\The [AM] is too far away to blink."))
			return
		if(!allowed_to_teleport())
			to_chat(user, span_warning("Teleportation doesn't seem to work here."))
			return
		if(pay_energy(400))
			if(check_for_scepter())
				safe_blink(AM, calculate_spell_power(6))
			else
				safe_blink(AM, calculate_spell_power(3))
			adjust_instability(3)
			add_attack_logs(user,AM,"Blinked")
		else
			to_chat(user, span_warning("You need more energy to blink [AM] away!"))

/obj/item/spell/blink/on_use_cast(mob/user)
	if(!allowed_to_teleport())
		to_chat(user, span_warning("Teleportation doesn't seem to work here."))
		return
	if(pay_energy(200))
		if(check_for_scepter())
			safe_blink(user, calculate_spell_power(10))
		else
			safe_blink(user, calculate_spell_power(6))
		adjust_instability(1)
		add_attack_logs(user,user,"Blinked")
	else
		to_chat(user, span_warning("You need more energy to blink yourself away!"))

/obj/item/spell/blink/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		if(!allowed_to_teleport())
			to_chat(user, span_warning("Teleportation doesn't seem to work here."))
			return
		if(pay_energy(300))
			visible_message(span_danger("\The [user] reaches out towards \the [AM] with a glowing hand."))
			if(check_for_scepter())
				safe_blink(AM, 10)
			else
				safe_blink(AM, 6)
			adjust_instability(2)
			add_attack_logs(user,AM,"Blinked")
		else
			to_chat(user, span_warning("You need more energy to blink [AM] away!"))
