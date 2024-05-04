/* Syndicate modules */

/obj/item/weapon/robot_module/robot/syndicate
	name = "illegal robot module"
	hide_on_manifest = TRUE
	languages = list(
					LANGUAGE_SOL_COMMON = 1,
					LANGUAGE_TRADEBAND = 1,
					LANGUAGE_UNATHI = 0,
					LANGUAGE_SIIK	= 0,
					LANGUAGE_AKHANI = 0,
					LANGUAGE_SKRELLIAN = 0,
					LANGUAGE_ROOTLOCAL = 0,
					LANGUAGE_GUTTER = 1,
					LANGUAGE_SCHECHI = 0,
					LANGUAGE_EAL	 = 1,
					LANGUAGE_SIGN	 = 0,
					LANGUAGE_TERMINUS = 1,
					LANGUAGE_ZADDAT = 0
					)
	var/id

// All syndie modules get these, and the base borg items (flash, crowbar, etc).
/obj/item/weapon/robot_module/robot/syndicate/create_equipment(var/mob/living/silicon/robot/robot)
	..()
	src.modules += new /obj/item/weapon/pinpointer/shuttle/merc(src)
	src.modules += new /obj/item/weapon/melee/energy/sword(src)

	var/datum/matter_synth/cloth = new /datum/matter_synth/cloth(40000)
	synths += cloth

	var/obj/item/stack/sandbags/cyborg/SB = new /obj/item/stack/sandbags/cyborg(src)
	SB.synths += list(cloth)

	var/jetpack = new/obj/item/weapon/tank/jetpack/carbondioxide(src)
	src.modules += jetpack
	robot.internals = jetpack

	var/obj/id = robot.idcard
	id.forceMove(src)
	src.modules += id

/obj/item/weapon/robot_module/robot/syndicate/Destroy()
	src.modules -= id
	id = null
	return ..()

// Gets a big shield and a gun that shoots really fast to scare the opposing force.
/obj/item/weapon/robot_module/robot/syndicate/protector
	name = "protector robot module"
	supported_upgrades = list(/obj/item/borg/upgrade/restricted/bellycapupgrade)

/obj/item/weapon/robot_module/robot/syndicate/protector/create_equipment(var/mob/living/silicon/robot/robot)
	..()
	src.modules += new /obj/item/shield_projector/rectangle/weak(src)
	src.modules += new /obj/item/weapon/gun/energy/dakkalaser(src)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)

	src.modules += new /obj/item/device/dogborg/sleeper/K9/syndie(src)
	src.modules += new /obj/item/weapon/dogborg/pounce(src)

// 95% engi-borg and 15% roboticist.
/obj/item/weapon/robot_module/robot/syndicate/mechanist
	name = "mechanist robot module"

/obj/item/weapon/robot_module/robot/syndicate/mechanist/create_equipment(var/mob/living/silicon/robot/robot)
	..()
	// General engineering/hacking.
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/multitool/ai_detector(src)
	src.modules += new /obj/item/weapon/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/weapon/rcd/electric/mounted/borg/lesser(src) // Can't eat rwalls to prevent AI core cheese.
	src.modules += new /obj/item/weapon/melee/energy/sword/ionic_rapier(src)

	// FBP repair.
	src.modules += new /obj/item/device/robotanalyzer(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot/jumper(src)
	src.modules += new /obj/item/weapon/gripper/no_use/organ/robotics(src)

	// Hacking other things.
	src.modules += new /obj/item/weapon/card/robot/syndi(src)
	src.modules += new /obj/item/weapon/card/emag/borg(src)

	// Materials.
	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite
	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire
	var/datum/matter_synth/metal = new /datum/matter_synth/metal(40000)
	synths += metal
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	synths += glass

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	src.modules += N

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/rods = new /obj/item/stack/rods/cyborg(src)
	rods.synths = list(metal)
	src.modules += rods

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/device/dogborg/sleeper/compactor/syndie/MD = new /obj/item/device/dogborg/sleeper/compactor/syndie(src)
	MD.metal = metal
	MD.glass = glass
	src.modules += MD

	src.modules += new /obj/item/weapon/dogborg/pounce(src)



// Mediborg optimized for on-the-field healing, but can also do surgery if needed.
/obj/item/weapon/robot_module/robot/syndicate/combat_medic
	name = "combat medic robot module"
	supported_upgrades = list(/obj/item/borg/upgrade/restricted/bellycapupgrade)

/obj/item/weapon/robot_module/robot/syndicate/combat_medic/create_equipment(var/mob/living/silicon/robot/robot)
	..()
	src.modules += new /obj/item/device/healthanalyzer/phasic(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/merc(src)

	// Surgery things.
	src.modules += new /obj/item/weapon/autopsy_scanner(src)
	src.modules += new /obj/item/weapon/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/hemostat/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/retractor/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/cautery/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bonegel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/FixOVein/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bonesetter/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/surgicaldrill/cyborg(src)
	src.modules += new /obj/item/weapon/gripper/no_use/organ(src)

	// General healing.
	src.modules += new /obj/item/weapon/gripper/medical(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot/combat(src)
	src.modules += new /obj/item/weapon/reagent_containers/dropper(src) // Allows borg to fix necrosis apparently
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.modules += new /obj/item/roller_holder(src)

	// Materials.
	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(15000)
	synths += medicine

	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	src.modules += O
	src.modules += B
	src.modules += S

	src.modules += new /obj/item/device/dogborg/sleeper/syndie(src)
	src.modules += new /obj/item/weapon/dogborg/pounce(src)

/obj/item/weapon/robot_module/robot/syndicate/combat_medic/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	..()
