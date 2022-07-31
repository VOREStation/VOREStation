/obj/mecha/working/ripley
	desc = "Autonomous Power Loader Unit. The workhorse of the exosuit world."
	name = "APLU \"Ripley\""
	icon_state = "ripley"
	initial_icon = "ripley"
	step_in = 5 // vorestation edit, was 6 but that's PAINFULLY slow
	step_energy_drain = 5 // vorestation edit because 10 drained a significant chunk of its cell before you even got out the airlock
	max_temperature = 20000
	health = 200
	maxhealth = 200		//Don't forget to update the /old variant if  you change this number.
	wreckage = /obj/effect/decal/mecha_wreckage/ripley
	cargo_capacity = 10
	var/obj/item/mining_scanner/orescanner // vorestation addition

	minimum_penetration = 10

	encumbrance_gap = 2

	starting_components = list(
		/obj/item/mecha_parts/component/hull/durable,
		/obj/item/mecha_parts/component/actuator,
		/obj/item/mecha_parts/component/armor/mining,
		/obj/item/mecha_parts/component/gas,
		/obj/item/mecha_parts/component/electrical
		)

	icon_scale_x = 1.2
	icon_scale_y = 1.2

/obj/mecha/working/ripley/Move()
	. = ..()
	if(.)
		collect_ore()

/obj/mecha/working/ripley/proc/collect_ore()
	if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in equipment)
		var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in cargo
		if(ore_box)
			for(var/obj/item/ore/ore in range(1, src))
				if(ore.Adjacent(src) && ((get_dir(src, ore) & dir) || ore.loc == loc)) //we can reach it and it's in front of us? grab it!
					ore.forceMove(ore_box)

/obj/mecha/working/ripley/Destroy()
	for(var/atom/movable/A in src.cargo)
		A.loc = loc
		var/turf/T = loc
		if(istype(T))
			T.Entered(A)
		step_rand(A)
	cargo.Cut()
	..()

/obj/mecha/working/ripley/firefighter
	desc = "Standard APLU chassis was refitted with additional thermal protection and cistern."
	name = "APLU \"Firefighter\""
	icon_state = "firefighter"
	initial_icon = "firefighter"
	max_temperature = 65000
	health = 250
	lights_power = 8
	damage_absorption = list("fire"=0.5,"bullet"=0.8,"bomb"=0.5)
	wreckage = /obj/effect/decal/mecha_wreckage/ripley/firefighter
	max_hull_equip = 2
	max_weapon_equip = 0
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

/obj/mecha/working/ripley/deathripley
	desc = "OH SHIT IT'S THE DEATHSQUAD WE'RE ALL GONNA DIE"
	name = "DEATH-RIPLEY"
	icon_state = "deathripley"
	initial_icon = "deathripley"
	step_in = 2
	opacity=0
	lights_power = 60
	wreckage = /obj/effect/decal/mecha_wreckage/ripley/deathripley
	step_energy_drain = 0
	max_hull_equip = 1
	max_weapon_equip = 1
	max_utility_equip = 3
	max_universal_equip = 1
	max_special_equip = 1

/obj/mecha/working/ripley/deathripley/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/safety
	ME.attach(src)
	return

/obj/mecha/working/ripley/mining
	desc = "An old, dusty mining ripley."
	name = "APLU \"Miner\""

/obj/mecha/working/ripley/mining/Initialize()
	. = ..()
	//Attach drill
	if(prob(25)) //Possible diamond drill... Feeling lucky?
		var/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill/D = new /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill
		D.attach(src)
	else
		var/obj/item/mecha_parts/mecha_equipment/tool/drill/D = new /obj/item/mecha_parts/mecha_equipment/tool/drill
		D.attach(src)

	//Attach hydrolic clamp
	var/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/HC = new /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	HC.attach(src)
	for(var/obj/item/mecha_parts/mecha_tracking/B in src.contents)//Deletes the beacon so it can't be found easily
		qdel (B)

/obj/mecha/working/ripley/antique
	name = "APLU \"Geiger\""
	desc = "You can't beat the classics."
	icon_state = "ripley-old"
	initial_icon = "ripley-old"

	show_pilot = TRUE
	pilot_lift = 5

	max_utility_equip = 1
	max_universal_equip = 3

	icon_scale_x = 1
	icon_scale_y = 1

//Vorestation Edit Start

/obj/mecha/working/ripley/Initialize()
	. = ..()
	orescanner = new /obj/item/mining_scanner

/obj/mecha/working/ripley/verb/detect_ore()
	set category = "Exosuit Interface"
	set name = "Detect Ores"
	set src = usr.loc
	set popup_menu = 0

	orescanner.attack_self(usr)

//Vorestation Edit End

//Meant for random spawns.
/obj/mecha/working/ripley/mining/old
	desc = "An old, dusty mining ripley."

/obj/mecha/working/ripley/mining/old/Initialize()
	. = ..()
	health = 25
	maxhealth = 190	//Just slightly worse.
	cell.charge = rand(0, cell.charge)
