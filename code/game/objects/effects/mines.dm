/obj/effect/mine
	name = "mine"
	desc = "A small explosive mine with 'HE' and a grenade symbol on the side."
	density = 0
	anchored = 1
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	var/triggered = 0
	var/smoke_strength = 3
	var/mineitemtype = /obj/item/weapon/mine
	var/panel_open = 0
	var/datum/wires/mines/wires = null

/obj/effect/mine/New()
	icon_state = "uglyminearmed"
	wires = new(src)

/obj/effect/mine/proc/explode()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	explosion(loc, 0, 2, 3, 4) //land mines are dangerous, folks.
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

	if(triggered) return

	if(istype(M, /mob/living/))
		explode()

/obj/effect/mine/attackby(obj/item/W as obj, mob/living/user as mob)
	if(isscrewdriver(W))
		panel_open = !panel_open
		user.visible_message("<span class='warning'>[user] very carefully screws the mine's panel [panel_open ? "open" : "closed"].</span>",
		"<span class='notice'>You very carefully screw the mine's panel [panel_open ? "open" : "closed"].</span>")
		playsound(src.loc, W.usesound, 50, 1)

	else if((iswirecutter(W) || ismultitool(W)) && panel_open)
		interact(user)
	else
		..()

/obj/effect/mine/interact(mob/living/user as mob)
	if(!panel_open || istype(user, /mob/living/silicon/ai))
		return

	user.set_machine(src)
	wires.Interact(user)

/obj/effect/mine/dnascramble/explode(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	obj:radiation += 50
	randmutb(obj)
	domutcheck(obj,null)
	qdel(s)
	qdel(src)

/obj/effect/mine/stun/explode(obj)
	triggered = 1
	if(ismob(obj))
		var/mob/M = obj
		M.Stun(30)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	qdel(s)
	qdel(src)

/obj/effect/mine/n2o/explode()
	triggered = 1
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)
	qdel(src)

/obj/effect/mine/phoron/explode()
	triggered = 1
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("phoron", 30)

			target.hotspot_expose(1000, CELL_VOLUME)
	qdel(src)

/obj/effect/mine/kick/explode(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	qdel(obj:client)
	qdel(s)
	qdel(src)

/obj/effect/mine/frag/explode()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	var/turf/O = get_turf(src)
	if(!O)
		return
	src.fragmentate(O, 20, 7, list(/obj/item/projectile/bullet/pellet/fragment)) //only 20 weak fragments because you're stepping directly on it
	qdel(s)
	qdel(src)

/obj/effect/mine/training/explode()
	triggered = 1
	visible_message("\The [src.name]'s light flashes rapidly as it 'explodes'.")
	new src.mineitemtype(get_turf(src))
	qdel(src)

/obj/effect/mine/dnascramble
	name = "radiation mine"
	desc = "A small explosive mine with a radiation symbol on the side."
	icon_state = "uglymine"
	mineitemtype = /obj/item/weapon/mine/dnascramble

/obj/effect/mine/phoron
	name = "incendiary mine"
	desc = "A small explosive mine with a fire symbol on the side."
	icon_state = "uglymine"
	mineitemtype = /obj/item/weapon/mine/phoron

/obj/effect/mine/kick
	name = "kick mine"
	desc = "Concentrated war crimes. Handle with care."
	icon_state = "uglymine"
	mineitemtype = /obj/item/weapon/mine/kick

/obj/effect/mine/n2o
	name = "nitrous oxide mine"
	desc = "A small explosive mine with three Z's on the side."
	icon_state = "uglymine"
	mineitemtype = /obj/item/weapon/mine/n2o

/obj/effect/mine/stun
	name = "stun mine"
	desc = "A small explosive mine with a lightning bolt symbol on the side."
	icon_state = "uglymine"
	mineitemtype = /obj/item/weapon/mine/stun

/obj/effect/mine/frag
	name = "fragmentation mine"
	desc = "A small explosive mine with 'FRAG' and a grenade symbol on the side."
	icon_state = "uglymine"
	mineitemtype = /obj/item/weapon/mine/frag
	var/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment)
	var/num_fragments = 20  //total number of fragments produced by the grenade
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

/obj/effect/mine/training
	name = "training mine"
	desc = "A mine with its payload removed, for EOD training and demonstrations."
	icon_state = "uglymine"
	mineitemtype = /obj/item/weapon/mine/training

/obj/item/weapon/mine
	name = "mine"
	desc = "A small explosive mine with 'HE' and a grenade symbol on the side."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	var/arming = 0
	var/countdown = 10
	var/minetype = /obj/effect/mine

/obj/item/weapon/mine/attack_self(mob/user as mob)
	if(!arming)
		to_chat(user, "<span class='warning'>You prime \the [name]! [countdown] seconds!</span>")
		icon_state = initial(icon_state) + "armed"
		arming = 1
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()
		spawn(countdown*10)
			if(arming)
				prime()
				if(user)
					msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
				return
	else
		to_chat(user, "You cancel \the [name]'s priming sequence.")
		arming = 0
		countdown = initial(countdown)
		icon_state = initial(icon_state)
		add_fingerprint(user)
	return

/obj/item/weapon/mine/proc/prime(mob/user as mob)
	visible_message("\The [src.name] beeps as the priming sequence completes.")
	var/atom/R = new minetype(get_turf(src))
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	spawn(0)
		qdel(src)

/obj/item/weapon/mine/dnascramble
	name = "radiation mine"
	desc = "A small explosive mine with a radiation symbol on the side."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/dnascramble

/obj/item/weapon/mine/phoron
	name = "incendiary mine"
	desc = "A small explosive mine with a fire symbol on the side."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/phoron

/obj/item/weapon/mine/kick
	name = "kick mine"
	desc = "Concentrated war crimes. Handle with care."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/kick

/obj/item/weapon/mine/n2o
	name = "nitrous oxide mine"
	desc = "A small explosive mine with three Z's on the side."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/n2o

/obj/item/weapon/mine/stun
	name = "stun mine"
	desc = "A small explosive mine with a lightning bolt symbol on the side."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/stun

/obj/item/weapon/mine/frag
	name = "fragmentation mine"
	desc = "A small explosive mine with 'FRAG' and a grenade symbol on the side."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/frag

/obj/item/weapon/mine/training
	name = "training mine"
	desc = "A mine with its payload removed, for EOD training and demonstrations."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/training