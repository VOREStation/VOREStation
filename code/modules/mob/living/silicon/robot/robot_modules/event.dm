/* Other, unaffiliated modules */

// The module that borgs on the surface have.  Generally has a lot of useful tools in exchange for questionable loyalty to the crew.
/obj/item/robot_module/robot/lost
	name = "lost robot module"
	hide_on_manifest = TRUE
	sprites = list(
					"Drone" = "drone-lost"
				)

<<<<<<< HEAD
/obj/item/weapon/robot_module/robot/lost/New(var/mob/living/silicon/robot/R)
	..()
=======
/obj/item/robot_module/robot/lost/Initialize(var/ml)

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	// Sec
	src.modules += new /obj/item/melee/baton/shocker/robot(src)
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/borg/combat/shield(src)

	// Med
	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/reagent_containers/borghypo/lost(src)

	// Engi
	src.modules += new /obj/item/weldingtool/electric/mounted(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool(src)

	// Sci
	src.modules += new /obj/item/robotanalyzer(src)

	// Potato
	src.emag = new /obj/item/gun/energy/retro/mounted(src)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

/obj/item/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
	hide_on_manifest = TRUE
	sprites = list(
					"Drone" = "drone-gravekeeper",
					"Sleek" = "sleek-gravekeeper"
				)

<<<<<<< HEAD
/obj/item/weapon/robot_module/robot/gravekeeper/New(var/mob/living/silicon/robot/R)
	..()
=======
/obj/item/robot_module/robot/gravekeeper/Initialize(var/ml)

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	// For fending off animals and looters
	src.modules += new /obj/item/melee/baton/shocker/robot(src)
	src.modules += new /obj/item/borg/combat/shield(src)

	// For repairing gravemarkers
	src.modules += new /obj/item/weldingtool/electric/mounted(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)

	// For growing flowers
	src.modules += new /obj/item/material/minihoe(src)
	src.modules += new /obj/item/material/knife/machete/hatchet(src)
	src.modules += new /obj/item/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/storage/bag/plants(src)
	src.modules += new /obj/item/robot_harvester(src)

	// For digging and beautifying graves
	src.modules += new /obj/item/shovel(src)
	src.modules += new /obj/item/gripper/gravekeeper(src)

	// For really persistent looters
	src.emag = new /obj/item/gun/energy/retro/mounted(src)

	var/datum/matter_synth/wood = new /datum/matter_synth/wood(25000)
	synths += wood

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W