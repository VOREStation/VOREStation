/obj/mecha/micro/polecat //figured give 'em the names of small predatory critters
	desc = "A hardened security vehicle for micro crewmembers. To them, it's a superheavy tank. To everyone else, it's kinda cute."
	name = "Polecat"
	icon_state = "polecat"
	initial_icon = "polecat"
	step_in = 2 // human running speed
	dir_in = 1 //Facing North.
	health = 150
	deflect_chance = 10
	damage_absorption = list("brute"=0.75,"fire"=1,"bullet"=0.8,"laser"=0.7,"energy"=0.85,"bomb"=1)
	max_temperature = 15000
	infra_luminosity = 6
	var/overload = 0
	var/overload_coeff = 2
	wreckage = /obj/effect/decal/mecha_wreckage/micro/polecat
	internal_damage_threshold = 35
	max_equip = 3

/obj/effect/decal/mecha_wreckage/micro/polecat
	name = "Polecat wreckage"
	icon_state = "polecat-broken"

/obj/mecha/micro/weasel
	desc = "A light scout exosuit for micro crewmembers, built for fast reconnaisance. Yes, it IS a miner borg chassis with wheels attached to the legs. ."
	name = "Weasel"
	icon_state = "weasel"
	initial_icon = "weasel"
	step_in = 1 // zoom zoom
	dir_in = 1 //Facing North.
	health = 100
	deflect_chance = 5
	damage_absorption = list("brute"=1,"fire"=1,"bullet"=0.9,"laser"=0.8,"energy"=0.85,"bomb"=1)
	max_temperature = 5000
	infra_luminosity = 6
	var/overload = 0
	var/overload_coeff = 2
	wreckage = /obj/effect/decal/mecha_wreckage/micro/weasel
	internal_damage_threshold = 20
	max_equip = 2

/obj/effect/decal/mecha_wreckage/micro/weasel
	name = "Weasel wreckage"
	icon_state = "weasel-broken"
