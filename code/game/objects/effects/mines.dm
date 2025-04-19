/obj/effect/mine
	name = "land mine"	//The name and description are deliberately NOT modified, so you can't game the mines you find.
	desc = "A small explosive land mine."
	density = FALSE
	anchored = TRUE
	icon = 'icons/obj/weapons.dmi'
	icon_state = "landmine"
	var/triggered = FALSE
	var/smoke_strength = 3
	var/obj/item/mine/mineitemtype = /obj/item/mine
	var/panel_open = FALSE
	var/datum/wires/mines/wires = null
	var/camo_net = FALSE	// Will the mine 'cloak' on deployment?

	// The trap item will be triggered in some manner when detonating. Default only checks for grenades.
	var/obj/item/trap = null

/obj/effect/mine/Initialize(mapload)
	icon_state = "landmine_armed"
	wires = new(src)
	. = ..()
	if(ispath(trap))
		trap = new trap(src)
	register_dangerous_to_step()
	if(camo_net)
		alpha = 50

/obj/effect/mine/Destroy()
	unregister_dangerous_to_step()
	if(trap)
		QDEL_NULL(trap)
	qdel_null(wires)
	return ..()

/obj/effect/mine/Moved(atom/oldloc)
	. = ..()
	if(.)
		var/turf/old_turf = get_turf(oldloc)
		var/turf/new_turf = get_turf(src)
		if(old_turf != new_turf)
			old_turf.unregister_dangerous_object(src)
			new_turf.register_dangerous_object(src)

/obj/effect/mine/proc/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = TRUE
	s.set_up(3, 1, src)
	s.start()

	if(trap)
		trigger_trap(M)
		visible_message("\The [src.name] flashes as it is triggered!")

	else
		explosion(loc, 0, 2, 3, 4) //land mines are dangerous, folks.
		visible_message("\The [src.name] detonates!")

	qdel(s)
	qdel(src)

/obj/effect/mine/proc/trigger_trap(var/mob/living/victim)
	if(istype(trap, /obj/item/grenade))
		var/obj/item/grenade/G = trap
		trap = null
		G.forceMove(get_turf(src))
		if(victim.ckey)
			msg_admin_attack("[key_name_admin(victim)] stepped on \a [src.name], triggering [trap]")
		G.activate()

	if(istype(trap, /obj/item/transfer_valve))
		var/obj/item/transfer_valve/TV = trap
		trap = null
		TV.forceMove(get_turf(src))
		TV.toggle_valve()

/obj/effect/mine/bullet_act()
	if(prob(50))
		explode()

/obj/effect/mine/ex_act(severity)
	if(severity <= 2 || prob(50))
		explode()
	..()

/obj/effect/mine/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	Bumped(AM)

/obj/effect/mine/Bumped(mob/M as mob|obj)

	if(triggered)
		return

	if(istype(M, /obj/mecha))
		explode(M)

	if(istype(M, /mob/living/))
		var/mob/living/mob = M
		if(!mob.hovering || !mob.flying)
			explode(M)

/obj/effect/mine/attackby(obj/item/W as obj, mob/living/user as mob)
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		panel_open = !panel_open
		user.visible_message(span_warning("[user] very carefully screws the mine's panel [panel_open ? "open" : "closed"]."),
		span_notice("You very carefully screw the mine's panel [panel_open ? "open" : "closed"]."))
		playsound(src, W.usesound, 50, 1)

		// Panel open, stay uncloaked, or uncloak if already cloaked. If you don't cloak on place, ignore it and just be normal alpha.
		alpha = camo_net ? (panel_open ? 255 : 50) : 255

	else if((W.has_tool_quality(TOOL_WIRECUTTER) || istype(W, /obj/item/multitool)) && panel_open)
		interact(user)
	else
		..()

/obj/effect/mine/interact(mob/living/user as mob)
	if(!panel_open || isAI(user))
		return
	user.set_machine(src)
	wires.Interact(user)

/obj/effect/mine/camo
	camo_net = TRUE

/obj/effect/mine/dnascramble
	mineitemtype = /obj/item/mine/dnascramble

/obj/effect/mine/dnascramble/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = TRUE
	s.set_up(3, 1, src)
	s.start()
	if(istype(M))
		M.radiation += 50
		randmutb(M)
		domutcheck(M,null)
		M.UpdateAppearance()
	visible_message("\The [src.name] flashes violently before disintegrating!")
	SSmotiontracker.ping(src,100)
	spawn(0)
		qdel(s)
		qdel(src)

/obj/effect/mine/stun
	mineitemtype = /obj/item/mine/stun

/obj/effect/mine/stun/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	triggered = TRUE
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	if(istype(M))
		M.Stun(30)
	visible_message("\The [src.name] flashes violently before disintegrating!")
	SSmotiontracker.ping(src,100)
	spawn(0)
		qdel(s)
		qdel(src)

/obj/effect/mine/n2o
	mineitemtype = /obj/item/mine/n2o

/obj/effect/mine/n2o/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	triggered = TRUE
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas(GAS_N2O, 30)
	visible_message("\The [src.name] detonates!")
	SSmotiontracker.ping(src,100)
	spawn(0)
		qdel(src)

/obj/effect/mine/phoron
	mineitemtype = /obj/item/mine/phoron

/obj/effect/mine/phoron/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	triggered = TRUE
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas(GAS_PHORON, 30)
			target.hotspot_expose(1000, CELL_VOLUME)
	visible_message("\The [src.name] detonates!")
	SSmotiontracker.ping(src,100)
	spawn(0)
		qdel(src)

/obj/effect/mine/kick
	mineitemtype = /obj/item/mine/kick

/obj/effect/mine/kick/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = TRUE
	s.set_up(3, 1, src)
	s.start()
	if(istype(M, /obj/mecha))
		var/obj/mecha/E = M
		M = E.occupant
	if(istype(M))
		qdel(M.client)
	spawn(0)
		qdel(s)
		qdel(src)

/obj/effect/mine/frag
	mineitemtype = /obj/item/mine/frag
	var/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment)
	var/num_fragments = 20  //total number of fragments produced by the grenade
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

/obj/effect/mine/frag/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = TRUE
	s.set_up(3, 1, src)
	s.start()
	var/turf/O = get_turf(src)
	if(!O)
		return
	src.fragmentate(O, num_fragments, spread_range, fragment_types) //only 20 weak fragments because you're stepping directly on it
	visible_message("\The [src.name] detonates!")
	SSmotiontracker.ping(src,100)
	spawn(0)
		qdel(s)
		qdel(src)

/obj/effect/mine/training	//Name and Desc commented out so it's possible to trick people with the training mines
//	name = "training mine"
//	desc = "A mine with its payload removed, for EOD training and demonstrations."
	mineitemtype = /obj/item/mine/training

/obj/effect/mine/training/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	triggered = TRUE
	visible_message("\The [src.name]'s light flashes rapidly as it 'explodes'.")
	new src.mineitemtype(get_turf(src))
	spawn(0)
		qdel(src)

/obj/effect/mine/emp
	mineitemtype = /obj/item/mine/emp

/obj/effect/mine/emp/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	triggered = TRUE
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	visible_message("\The [src.name] flashes violently before disintegrating!")
	SSmotiontracker.ping(src,100)
	empulse(loc, 2, 4, 7, 10, 1) // As strong as an EMP grenade
	spawn(0)
		qdel(src)

/obj/effect/mine/emp/camo
	camo_net = TRUE

/obj/effect/mine/incendiary
	mineitemtype = /obj/item/mine/incendiary

/obj/effect/mine/incendiary/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	triggered = TRUE
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	if(istype(M))
		M.adjust_fire_stacks(5)
		M.fire_act()
	visible_message("\The [src.name] bursts into flames!")
	SSmotiontracker.ping(src,100)
	spawn(0)
		qdel(src)

/obj/effect/mine/gadget
	mineitemtype = /obj/item/mine/gadget

/obj/effect/mine/gadget/explode(var/mob/living/M)
	if(triggered) // Prevents circular mine explosions from two mines detonating eachother
		return
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = TRUE
	s.set_up(3, 1, src)
	s.start()

	if(trap)
		trigger_trap(M)
		visible_message("\The [src.name] flashes as it is triggered!")

	else
		explosion(loc, 0, 0, 2, 2)
		visible_message("\The [src.name] detonates!")
	SSmotiontracker.ping(src,100)

	qdel(s)
	qdel(src)

/////////////////////////////////////////////
// The held item version of the above mines
/////////////////////////////////////////////
/obj/item/mine
	name = "mine"
	desc = "A small explosive mine with 'HE' and a grenade symbol on the side."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "landmine"
	var/countdown = 10
	var/minetype = /obj/effect/mine		//This MUST be an /obj/effect/mine type, or it'll runtime.

	var/obj/item/trap = null

	var/list/allowed_gadgets = null

/obj/item/mine/attack_self(mob/user as mob)	// You do not want to move or throw a land mine while priming it... Explosives + Sudden Movement = Bad Times
	add_fingerprint(user)
	msg_admin_attack("[key_name_admin(user)] primed \a [src]")
	user.visible_message("[user] starts priming \the [src.name].", "You start priming \the [src.name]. Hold still!")
	if(do_after(user, 10 SECONDS))
		playsound(src, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		prime(user)
	else
		visible_message("[user] triggers \the [src.name]!", "You accidentally trigger \the [src.name]!")
		prime(user, TRUE)
	return

/obj/item/mine/attackby(obj/item/W as obj, mob/living/user as mob)
	if(W.has_tool_quality(TOOL_SCREWDRIVER) && trap)
		to_chat(user, span_notice("You begin removing \the [trap]."))
		if(do_after(user, 10 SECONDS))
			to_chat(user, span_notice("You finish disconnecting the mine's trigger."))
			trap.forceMove(get_turf(src))
			trap = null
		return

	if(LAZYLEN(allowed_gadgets) && !trap)
		var/allowed = FALSE

		for(var/path in allowed_gadgets)
			if(istype(W, path))
				allowed = TRUE
				break

		if(allowed)
			user.drop_from_inventory(W)
			W.forceMove(src)
			trap = W

	..()

/obj/item/mine/proc/prime(mob/user as mob, var/explode_now = FALSE)
	visible_message("\The [src.name] beeps as the priming sequence completes.")
	var/obj/effect/mine/R = new minetype(get_turf(src))
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	if(trap)
		R.trap = trap
		trap = null
		R.trap.forceMove(R)
	if(explode_now)
		R.explode(user)
	spawn(0)
		qdel(src)

/obj/item/mine/dnascramble
	name = "radiation mine"
	desc = "A small explosive mine with a radiation symbol on the side."
	minetype = /obj/effect/mine/dnascramble

/obj/item/mine/phoron
	name = "incendiary mine"
	desc = "A small explosive mine with a fire symbol on the side."
	minetype = /obj/effect/mine/phoron

/obj/item/mine/kick
	name = "kick mine"
	desc = "Concentrated war crimes. Handle with care."
	minetype = /obj/effect/mine/kick

/obj/item/mine/n2o
	name = "nitrous oxide mine"
	desc = "A small explosive mine with three Z's on the side."
	minetype = /obj/effect/mine/n2o

/obj/item/mine/stun
	name = "stun mine"
	desc = "A small explosive mine with a lightning bolt symbol on the side."
	minetype = /obj/effect/mine/stun

/obj/item/mine/frag
	name = "fragmentation mine"
	desc = "A small explosive mine with 'FRAG' and a grenade symbol on the side."
	minetype = /obj/effect/mine/frag

/obj/item/mine/training
	name = "training mine"
	desc = "A mine with its payload removed, for EOD training and demonstrations."
	minetype = /obj/effect/mine/training

/obj/item/mine/emp
	name = "emp mine"
	desc = "A small explosive mine with a lightning bolt symbol on the side."
	minetype = /obj/effect/mine/emp

/obj/item/mine/incendiary
	name = "incendiary mine"
	desc = "A small explosive mine with a fire symbol on the side."
	minetype = /obj/effect/mine/incendiary

/obj/item/mine/gadget
	name = "gadget mine"
	desc = "A small pressure-triggered device. If no component is added, the internal release bolts will detonate in unison when triggered."

	allowed_gadgets = list(/obj/item/grenade, /obj/item/transfer_valve)

// This tells AI mobs to not be dumb and step on mines willingly.
/obj/item/mine/is_safe_to_step(mob/living/L)
	if(!L.hovering || !L.flying)
		return FALSE
	return ..()
