/obj/mecha/micro/sec/moved_inside(var/mob/living/carbon/human/H as mob)
	if(..())
		if(H.client)
			H.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")
		return 1
	else
		return 0

/obj/mecha/micro/sec/go_out()
	if(src.occupant && src.occupant.client)
		src.occupant.client.mouse_pointer_icon = initial(src.occupant.client.mouse_pointer_icon)
	..()
	return

/obj/mecha/micro/sec/polecat //figured give 'em the names of small predatory critters
	desc = "A hardened security vehicle for micro crewmembers. To them, it's a superheavy tank. To everyone else, it's kinda cute."
	name = "Polecat"
	icon_state = "polecat"
	initial_icon = "polecat"
	step_in = 2 // human running speed
	dir_in = 2 //Facing south.
	health = 150
	step_energy_drain = 4 // less efficient than base micromech, but still a micromech.
	deflect_chance = 10
	max_temperature = 15000
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/micro/sec/polecat
	internal_damage_threshold = 35
	max_equip = 3
	max_micro_utility_equip = 0
	max_micro_weapon_equip = 3
	damage_minimum = 5		//A teeny bit of armor

/obj/effect/decal/mecha_wreckage/micro/sec/polecat
	name = "Polecat wreckage"
	icon_state = "polecat-broken"

/obj/mecha/micro/sec/weasel
	desc = "A light scout exosuit for micro crewmembers, built for fast reconnaisance."
	name = "Weasel"
	icon_state = "weasel"
	initial_icon = "weasel"
	step_in = 1 // zoom zoom
	dir_in = 2 //Facing south.
	health = 100
	deflect_chance = 5
	max_temperature = 5000
	wreckage = /obj/effect/decal/mecha_wreckage/micro/sec/weasel
	internal_damage_threshold = 20
	max_equip = 2
	max_micro_utility_equip = 0
	max_micro_weapon_equip = 2

/obj/effect/decal/mecha_wreckage/micro/sec/weasel
	name = "Weasel wreckage"
	icon_state = "weasel-broken"
