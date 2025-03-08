/* Other, unaffiliated modules */

// The module that borgs on the surface have.  Generally has a lot of useful tools in exchange for questionable loyalty to the crew.
/obj/item/robot_module/robot/lost
	name = "lost robot module"
	hide_on_manifest = TRUE

/obj/item/robot_module/robot/lost/create_equipment(var/mob/living/silicon/robot/robot)
	..()
	// Sec
	src.modules += new /obj/item/melee/robotic/baton/shocker(src)
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/borg/combat/shield(src)

	// Med
	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/shockpaddles/robot(src)
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
	src.emag += new /obj/item/gun/energy/robotic/laser/retro(src)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	src.modules += new /obj/item/dogborg/sleeper/lost(src)
	src.modules += new /obj/item/dogborg/pounce(src)

/obj/item/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
	hide_on_manifest = TRUE

/obj/item/robot_module/robot/gravekeeper/create_equipment(var/mob/living/silicon/robot/robot)
	..()
	// For fending off animals and looters
	src.modules += new /obj/item/melee/robotic/baton/shocker(src)
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
	src.emag += new /obj/item/gun/energy/robotic/laser/retro(src)

	var/datum/matter_synth/wood = new /datum/matter_synth/wood(25000)
	synths += wood

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	// For uwu
	src.modules += new /obj/item/dogborg/sleeper/compactor/generic(src)
	src.emag += new /obj/item/dogborg/pounce(src)
