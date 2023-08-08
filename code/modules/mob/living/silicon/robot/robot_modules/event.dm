/* Other, unaffiliated modules */

// The module that borgs on the surface have.  Generally has a lot of useful tools in exchange for questionable loyalty to the crew.
/obj/item/weapon/robot_module/robot/lost
	name = "lost robot module"
	hide_on_manifest = TRUE

/obj/item/weapon/robot_module/robot/lost/New(var/mob/living/silicon/robot/R)
	..()
	// Sec
	src.modules += new /obj/item/weapon/melee/baton/shocker/robot(src)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/borg/combat/shield(src)

	// Med
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/lost(src)

	// Engi
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/multitool(src)

	// Sci
	src.modules += new /obj/item/device/robotanalyzer(src)

	// Potato
	src.emag += new /obj/item/weapon/gun/energy/retro/mounted(src)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

/obj/item/weapon/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
	hide_on_manifest = TRUE

/obj/item/weapon/robot_module/robot/gravekeeper/New(var/mob/living/silicon/robot/R)
	..()
	// For fending off animals and looters
	src.modules += new /obj/item/weapon/melee/baton/shocker/robot(src)
	src.modules += new /obj/item/borg/combat/shield(src)

	// For repairing gravemarkers
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)

	// For growing flowers
	src.modules += new /obj/item/weapon/material/minihoe(src)
	src.modules += new /obj/item/weapon/material/knife/machete/hatchet(src)
	src.modules += new /obj/item/device/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/weapon/storage/bag/plants(src)
	src.modules += new /obj/item/weapon/robot_harvester(src)

	// For digging and beautifying graves
	src.modules += new /obj/item/weapon/shovel(src)
	src.modules += new /obj/item/weapon/gripper/gravekeeper(src)

	// For really persistent looters
	src.emag += new /obj/item/weapon/gun/energy/retro/mounted(src)

	var/datum/matter_synth/wood = new /datum/matter_synth/wood(25000)
	synths += wood

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W