/* Syndicate modules */

/obj/item/robot_module/robot/syndicate
	name = "illegal robot module"
	hide_on_manifest = TRUE
	languages = list(
					LANGUAGE_SOL_COMMON = 1,
					LANGUAGE_TRADEBAND = 1,
					LANGUAGE_UNATHI = 0,
					LANGUAGE_SIIK	= 0,
					LANGUAGE_AKHANI = 0,
					LANGUAGE_SKRELLIAN = 0,
					LANGUAGE_SKRELLIANFAR = 0,
					LANGUAGE_ROOTLOCAL = 0,
					LANGUAGE_GUTTER = 1,
					LANGUAGE_SCHECHI = 0,
					LANGUAGE_EAL	 = 1,
					LANGUAGE_SIGN	 = 0,
					LANGUAGE_TERMINUS = 1,
					LANGUAGE_ZADDAT = 0
					)
	sprites = list(
					"Cerberus" = "syndie_bloodhound",
					"Cerberus - Treaded" = "syndie_treadhound",
					"Ares" = "squats",
					"Telemachus" = "toiletbotantag",
					"WTOperator" = "hosborg",
					"XI-GUS" = "spidersyndi",
					"XI-ALP" = "syndi-heavy"
				)
	var/id

// All syndie modules get these, and the base borg items (flash, crowbar, etc).
<<<<<<< HEAD
/obj/item/weapon/robot_module/robot/syndicate/New(var/mob/living/silicon/robot/R)
	..()
	loc = R
	src.modules += new /obj/item/weapon/pinpointer/shuttle/merc(src)
	src.modules += new /obj/item/weapon/melee/energy/sword(src)
=======
/obj/item/robot_module/robot/syndicate/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/pinpointer/shuttle/merc(src)
	src.modules += new /obj/item/melee/energy/sword(src)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

	var/datum/matter_synth/cloth = new /datum/matter_synth/cloth(40000)
	synths += cloth

	var/obj/item/stack/sandbags/cyborg/SB = new /obj/item/stack/sandbags/cyborg(src)
	SB.synths += list(cloth)

	var/jetpack = new/obj/item/tank/jetpack/carbondioxide(src)
	src.modules += jetpack
	R.internals = jetpack

	id = R.idcard
	src.modules += id

/obj/item/robot_module/robot/syndicate/Destroy()
	src.modules -= id
	id = null
	return ..()

// Gets a big shield and a gun that shoots really fast to scare the opposing force.
/obj/item/robot_module/robot/syndicate/protector
	name = "protector robot module"
	sprites = list(
		"Cerberus - Treaded" = "syndie_treadhound",
		"Cerberus" = "syndie_bloodhound",
		"Ares" = "squats",
		"XI-ALP" = "syndi-heavy"
		)

<<<<<<< HEAD
/obj/item/weapon/robot_module/robot/syndicate/protector/New(var/mob/living/silicon/robot/R)
	..()
=======
/obj/item/robot_module/robot/syndicate/protector/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	src.modules += new /obj/item/shield_projector/rectangle/weak(src)
	src.modules += new /obj/item/gun/energy/dakkalaser(src)
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/melee/baton/robot(src)

// 95% engi-borg and 15% roboticist.
/obj/item/robot_module/robot/syndicate/mechanist
	name = "mechanist robot module"
	sprites = list(
		"XI-GUS" = "spidersyndi",
		"WTOperator" = "sleekhos"
		)

<<<<<<< HEAD
/obj/item/weapon/robot_module/robot/syndicate/mechanist/New(var/mob/living/silicon/robot/R)
	..()
=======
/obj/item/robot_module/robot/syndicate/mechanist/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	// General engineering/hacking.
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool/ai_detector(src)
	src.modules += new /obj/item/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/rcd/electric/mounted/borg/lesser(src) // Can't eat rwalls to prevent AI core cheese.
	src.modules += new /obj/item/melee/energy/sword/ionic_rapier(src)

	// FBP repair.
	src.modules += new /obj/item/robotanalyzer(src)
	src.modules += new /obj/item/shockpaddles/robot/jumper(src)
	src.modules += new /obj/item/gripper/no_use/organ/robotics(src)

	// Hacking other things.
	src.modules += new /obj/item/card/robot/syndi(src)
	src.modules += new /obj/item/card/emag(src)

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




// Mediborg optimized for on-the-field healing, but can also do surgery if needed.
/obj/item/robot_module/robot/syndicate/combat_medic
	name = "combat medic robot module"
	sprites = list(
		"Telemachus" = "toiletbotantag"
		)

<<<<<<< HEAD
/obj/item/weapon/robot_module/robot/syndicate/combat_medic/New(var/mob/living/silicon/robot/R)
	..()
=======
/obj/item/robot_module/robot/syndicate/combat_medic/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	src.modules += new /obj/item/borg/sight/hud/med(src)
	src.modules += new /obj/item/healthanalyzer/advanced(src)
	src.modules += new /obj/item/reagent_containers/borghypo/merc(src)

	// Surgery things.
	src.modules += new /obj/item/autopsy_scanner(src)
	src.modules += new /obj/item/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/surgical/hemostat/cyborg(src)
	src.modules += new /obj/item/surgical/retractor/cyborg(src)
	src.modules += new /obj/item/surgical/cautery/cyborg(src)
	src.modules += new /obj/item/surgical/bonegel/cyborg(src)
	src.modules += new /obj/item/surgical/FixOVein/cyborg(src)
	src.modules += new /obj/item/surgical/bonesetter/cyborg(src)
	src.modules += new /obj/item/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/surgical/surgicaldrill/cyborg(src)
	src.modules += new /obj/item/gripper/no_use/organ(src)

	// General healing.
	src.modules += new /obj/item/gripper/medical(src)
	src.modules += new /obj/item/shockpaddles/robot/combat(src)
	src.modules += new /obj/item/reagent_containers/dropper(src) // Allows borg to fix necrosis apparently
	src.modules += new /obj/item/reagent_containers/syringe(src)
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

/obj/item/robot_module/robot/syndicate/combat_medic/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	..()