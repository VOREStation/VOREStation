/datum/power/technomancer/blink
	name = "Blink"
	desc = "Force the target to teleport a short distance away.  This target could be anything from something lying on the ground, to someone trying to \
	fight you, or even yourself."
	verbpath = /mob/living/carbon/human/proc/technomancer_blink

/mob/living/carbon/human/proc/technomancer_blink()
	place_spell_in_hand(/obj/item/weapon/spell/blink)

/obj/item/weapon/spell/blink
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

	valid_turfs:
		for(var/turf/simulated/T in view(AM, range))
			if(T.density || istype(T, /turf/simulated/mineral)) //Don't blink to vacuum or a wall
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
				L.buckled = null
		AM.forceMove(destination)
		AM.visible_message("<span class='notice'>\The [AM] vanishes!</span>")
		AM << "<span class='notice'>You suddenly appear somewhere else!</span>"
		new /obj/effect/effect/sparks(destination)
		new /obj/effect/effect/sparks(starting)
	return

/obj/item/weapon/spell/blink/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		safe_blink(AM)

/obj/item/weapon/spell/blink/on_use_cast(mob/user)
	safe_blink(user, 6)

/obj/item/weapon/spell/blink/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		visible_message("<span class='danger'>\The [user] reaches out towards \the [AM] with a glowing hand.</span>")
		safe_blink(AM, 6)