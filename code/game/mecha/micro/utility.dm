

/obj/mecha/micro/utility/gopher //small digging creature, to keep the theme
	desc = "A tough little utility mech for micro crewmembers, based on a miner borg chassis."
	name = "Gopher"
	icon_state = "gopher"
	initial_icon = "gopher"
	step_in = 3
	dir_in = 2 //Facing south.
	health = 100
	deflect_chance = 10
	damage_absorption = list("brute"=0.9,"fire"=1,"bullet"=1,"laser"=1,"energy"=1,"bomb"=1)
	max_temperature = 15000
	infra_luminosity = 6
	var/overload = 0
	var/overload_coeff = 2
	wreckage = /obj/effect/decal/mecha_wreckage/micro/utility/gopher
	internal_damage_threshold = 35
	max_micro_utility_equip = 2
	max_micro_weapon_equip = 0
	max_equip = 2

/obj/effect/decal/mecha_wreckage/micro/utility/gopher
	name = "Gopher wreckage"
	icon_state = "gopher-broken"

