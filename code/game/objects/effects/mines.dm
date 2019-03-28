/obj/effect/mine
	name = "land mine"	//The name and description are deliberately NOT modified, so you can't game the mines you find.
	desc = "A small explosive land mine."
	density = 0
	anchored = 1
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	var/triggered = 0
	var/smoke_strength = 3
	var/mineitemtype = /obj/item/weapon/mine
	var/panel_open = 0
	var/datum/wires/mines/wires = null
	register_as_dangerous_object = TRUE

/obj/effect/mine/New()
	icon_state = "uglyminearmed"
	wires = new(src)

/obj/effect/mine/proc/explode(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	explosion(loc, 0, 2, 3, 4) //land mines are dangerous, folks.
	visible_message("\The [src.name] detonates!")
	qdel(s)
	qdel(src)

/obj/effect/mine/bullet_act()
	if(prob(50))
		explode()

/obj/effect/mine/ex_act(severity)
	if(severity <= 2 || prob(50))
		explode()
	..()

/obj/effect/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/effect/mine/Bumped(mob/M as mob|obj)

	if(triggered)
		return

	if(istype(M, /mob/living/))
		if(!M.hovering)
			explode(M)

/obj/effect/mine/attackby(obj/item/W as obj, mob/living/user as mob)
	if(W.is_screwdriver())
		panel_open = !panel_open
		user.visible_message("<span class='warning'>[user] very carefully screws the mine's panel [panel_open ? "open" : "closed"].</span>",
		"<span class='notice'>You very carefully screw the mine's panel [panel_open ? "open" : "closed"].</span>")
		playsound(src.loc, W.usesound, 50, 1)

	else if((W.is_wirecutter() || istype(W, /obj/item/device/multitool)) && panel_open)
		interact(user)
	else
		..()

/obj/effect/mine/interact(mob/living/user as mob)
	if(!panel_open || istype(user, /mob/living/silicon/ai))
		return
	user.set_machine(src)
	wires.Interact(user)

/obj/effect/mine/dnascramble
	mineitemtype = /obj/item/weapon/mine/dnascramble

/obj/effect/mine/dnascramble/explode(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	if(M)
		M.radiation += 50
		randmutb(M)
		domutcheck(M,null)
	visible_message("\The [src.name] flashes violently before disintegrating!")
	spawn(0)
		qdel(s)
		qdel(src)

/obj/effect/mine/stun
	mineitemtype = /obj/item/weapon/mine/stun

/obj/effect/mine/stun/explode(var/mob/living/M)
	triggered = 1
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	if(M)
		M.Stun(30)
	visible_message("\The [src.name] flashes violently before disintegrating!")
	spawn(0)
		qdel(s)
		qdel(src)

/obj/effect/mine/n2o
	mineitemtype = /obj/item/weapon/mine/n2o

/obj/effect/mine/n2o/explode(var/mob/living/M)
	triggered = 1
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)
	visible_message("\The [src.name] detonates!")
	spawn(0)
		qdel(src)

/obj/effect/mine/phoron
	mineitemtype = /obj/item/weapon/mine/phoron

/obj/effect/mine/phoron/explode(var/mob/living/M)
	triggered = 1
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("phoron", 30)
			target.hotspot_expose(1000, CELL_VOLUME)
	visible_message("\The [src.name] detonates!")
	spawn(0)
		qdel(src)

/obj/effect/mine/kick
	mineitemtype = /obj/item/weapon/mine/kick

/obj/effect/mine/kick/explode(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	if(M)
		qdel(M.client)
	spawn(0)
		qdel(s)
		qdel(src)

/obj/effect/mine/frag
	mineitemtype = /obj/item/weapon/mine/frag
	var/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment)
	var/num_fragments = 20  //total number of fragments produced by the grenade
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

/obj/effect/mine/frag/explode(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	var/turf/O = get_turf(src)
	if(!O)
		return
	src.fragmentate(O, 20, 7, list(/obj/item/projectile/bullet/pellet/fragment)) //only 20 weak fragments because you're stepping directly on it
	visible_message("\The [src.name] detonates!")
	spawn(0)
		qdel(s)
		qdel(src)

/obj/effect/mine/training	//Name and Desc commented out so it's possible to trick people with the training mines
//	name = "training mine"
//	desc = "A mine with its payload removed, for EOD training and demonstrations."
	mineitemtype = /obj/item/weapon/mine/training

/obj/effect/mine/training/explode(var/mob/living/M)
	triggered = 1
	visible_message("\The [src.name]'s light flashes rapidly as it 'explodes'.")
	new src.mineitemtype(get_turf(src))
	spawn(0)
		qdel(src)

/obj/effect/mine/emp
	mineitemtype = /obj/item/weapon/mine/emp

/obj/effect/mine/emp/explode(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	visible_message("\The [src.name] flashes violently before disintegrating!")
	empulse(loc, 2, 4, 7, 10, 1) // As strong as an EMP grenade
	spawn(0)
		qdel(src)

/obj/effect/mine/incendiary
	mineitemtype = /obj/item/weapon/mine/incendiary

/obj/effect/mine/incendiary/explode(var/mob/living/M)
	triggered = 1
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	if(M)
		M.adjust_fire_stacks(5)
		M.fire_act()
	visible_message("\The [src.name] bursts into flames!")
	spawn(0)
		qdel(src)

/////////////////////////////////////////////
// The held item version of the above mines
/////////////////////////////////////////////
/obj/item/weapon/mine
	name = "mine"
	desc = "A small explosive mine with 'HE' and a grenade symbol on the side."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	var/countdown = 10
	var/minetype = /obj/effect/mine		//This MUST be an /obj/effect/mine type, or it'll runtime.

/obj/item/weapon/mine/attack_self(mob/user as mob)	// You do not want to move or throw a land mine while priming it... Explosives + Sudden Movement = Bad Times
	add_fingerprint(user)
	msg_admin_attack("[key_name_admin(user)] primed \a [src]")
	user.visible_message("[user] starts priming \the [src.name].", "You start priming \the [src.name]. Hold still!")
	if(do_after(user, 10 SECONDS))
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		prime(user)
	else
		visible_message("[user] triggers \the [src.name]!", "You accidentally trigger \the [src.name]!")
		prime(user, TRUE)
	return

/obj/item/weapon/mine/proc/prime(mob/user as mob, var/explode_now = FALSE)
	visible_message("\The [src.name] beeps as the priming sequence completes.")
	var/obj/effect/mine/R = new minetype(get_turf(src))
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	if(explode_now)
		R.explode(user)
	spawn(0)
		qdel(src)

/obj/item/weapon/mine/dnascramble
	name = "radiation mine"
	desc = "A small explosive mine with a radiation symbol on the side."
	minetype = /obj/effect/mine/dnascramble

/obj/item/weapon/mine/phoron
	name = "incendiary mine"
	desc = "A small explosive mine with a fire symbol on the side."
	minetype = /obj/effect/mine/phoron

/obj/item/weapon/mine/kick
	name = "kick mine"
	desc = "Concentrated war crimes. Handle with care."
	minetype = /obj/effect/mine/kick

/obj/item/weapon/mine/n2o
	name = "nitrous oxide mine"
	desc = "A small explosive mine with three Z's on the side."
	minetype = /obj/effect/mine/n2o

/obj/item/weapon/mine/stun
	name = "stun mine"
	desc = "A small explosive mine with a lightning bolt symbol on the side."
	minetype = /obj/effect/mine/stun

/obj/item/weapon/mine/frag
	name = "fragmentation mine"
	desc = "A small explosive mine with 'FRAG' and a grenade symbol on the side."
	minetype = /obj/effect/mine/frag

/obj/item/weapon/mine/training
	name = "training mine"
	desc = "A mine with its payload removed, for EOD training and demonstrations."
	minetype = /obj/effect/mine/training

/obj/item/weapon/mine/emp
	name = "emp mine"
	desc = "A small explosive mine with a lightning bolt symbol on the side."
	minetype = /obj/effect/mine/emp

/obj/item/weapon/mine/incendiary
	name = "incendiary mine"
	desc = "A small explosive mine with a fire symbol on the side."
	minetype = /obj/effect/mine/incendiary

// This tells AI mobs to not be dumb and step on mines willingly.
/obj/item/weapon/mine/is_safe_to_step(mob/living/L)
	if(!L.hovering)
		return FALSE
	return ..()