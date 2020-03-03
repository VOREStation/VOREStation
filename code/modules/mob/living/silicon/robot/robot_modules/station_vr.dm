/obj/item/weapon/robot_module
	languages = list(LANGUAGE_SOL_COMMON= 1,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_UNATHI		= 0,
					LANGUAGE_SIIK		= 0,
					LANGUAGE_SKRELLIAN	= 0,
					LANGUAGE_GUTTER		= 0,
					LANGUAGE_SCHECHI	= 0,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_BIRDSONG	= 0,
					LANGUAGE_SAGARU		= 0,
					LANGUAGE_CANILUNZT	= 0,
					LANGUAGE_ECUREUILIAN= 0,
					LANGUAGE_DAEMON		= 0,
					LANGUAGE_ENOCHIAN	= 0
					)
	var/vr_sprites = list()

/obj/item/weapon/robot_module/robot/clerical
	languages = list(
					LANGUAGE_SOL_COMMON	= 1,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_UNATHI		= 1,
					LANGUAGE_SIIK		= 1,
					LANGUAGE_SKRELLIAN	= 1,
					LANGUAGE_ROOTLOCAL	= 0,
					LANGUAGE_GUTTER		= 1,
					LANGUAGE_SCHECHI	= 1,
					LANGUAGE_EAL		= 1,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_BIRDSONG	= 1,
					LANGUAGE_SAGARU		= 1,
					LANGUAGE_CANILUNZT	= 1,
					LANGUAGE_ECUREUILIAN= 1,
					LANGUAGE_DAEMON		= 1,
					LANGUAGE_ENOCHIAN	= 1
					)

/hook/startup/proc/robot_modules_vr()
	robot_modules["Medihound"] = /obj/item/weapon/robot_module/robot/medihound
	robot_modules["K9"] = /obj/item/weapon/robot_module/robot/knine
	robot_modules["ERT"] = /obj/item/weapon/robot_module/robot/ert
	robot_modules["Janihound"] = /obj/item/weapon/robot_module/robot/scrubpup
	robot_modules["Sci-borg"] = /obj/item/weapon/robot_module/robot/science
	robot_modules["Pupdozer"] = /obj/item/weapon/robot_module/robot/engiedog
	return 1

//Just add a new proc with the robot_module type if you wish to run some other vore code
/obj/item/weapon/robot_module/proc/vr_new() // Any Global modules, just add them before the return (This will also affect all the borgs in this file)
	return

/obj/item/weapon/robot_module/proc/vr_add_sprites() // Adds sprites from this file into list of avialible ones for global modules
	sprites += vr_sprites
	return

/obj/item/weapon/robot_module/robot/medical/surgeon/vr_new() //Surgeon Bot
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	. = ..() //Any Global vore modules will come from here

/obj/item/weapon/robot_module/robot/medical/crisis/vr_new() //Crisis Bot
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	. = ..() //Any Global vore modules will come from here

/obj/item/weapon/robot_module/robot/medical/surgeon //VOREStation sprites
	vr_sprites = list(
						"Acheron" = "mechoid-Medical",
						"Shellguard Noble" = "Noble-MED",
						"ZOOM-BA" = "zoomba-medical"
					 )

/obj/item/weapon/robot_module/robot/medical/crisis //VOREStation sprites
	vr_sprites = list(
						"Handy" = "handy-med",
						"Acheron" = "mechoid-Medical",
						"Shellguard Noble" = "Noble-MED",
						"ZOOM-BA" = "zoomba-crisis"
					 )

/obj/item/weapon/robot_module/robot/clerical/butler //VOREStation sprites
	vr_sprites = list(
						"Handy - Service" = "handy-service",
						"Handy - Hydro" = "handy-hydro",
						"Acheron" = "mechoid-Service",
						"Shellguard Noble" = "Noble-SRV",
						"ZOOM-BA" = "zoomba-service"
					 )

/obj/item/weapon/robot_module/robot/clerical/general //VOREStation sprites
	vr_sprites = list(
						"Handy" = "handy-clerk",
						"Acheron" = "mechoid-Service",
						"Shellguard Noble" = "Noble-SRV",
						"ZOOM-BA" = "zoomba-clerical"
					 )

/obj/item/weapon/robot_module/robot/janitor //VOREStation sprites
	vr_sprites = list(
						"Handy" = "handy-janitor",
						"Acheron" = "mechoid-Janitor",
						"Shellguard Noble" = "Noble-CLN",
						"ZOOM-BA" = "zoomba-janitor"
					 )

/obj/item/weapon/robot_module/robot/security/general //VOREStation sprites
	vr_sprites = list(
						"Handy" = "handy-sec",
						"Acheron" = "mechoid-Security",
						"Shellguard Noble" = "Noble-SEC",
						"ZOOM-BA" = "zoomba-security"
					 )

/obj/item/weapon/robot_module/robot/miner //VOREStation sprites
	vr_sprites = list(
						"Handy" = "handy-miner",
						"Acheron" = "mechoid-Miner",
						"Shellguard Noble" = "Noble-DIG",
						"ZOOM-BA" = "zoomba-miner"
					 )

/obj/item/weapon/robot_module/robot/standard //VOREStation sprites
	vr_sprites = list(
						"Handy" = "handy-standard",
						"Acheron" = "mechoid-Standard",
						"Shellguard Noble" = "Noble-STD",
						"ZOOM-BA" = "zoomba-standard"
					 )

/obj/item/weapon/robot_module/robot/engineering/general //VOREStation sprites
	vr_sprites = list(
						"Acheron" = "mechoid-Engineering",
						"Shellguard Noble" = "Noble-ENG",
						"ZOOM-BA" = "zoomba-engineering"
					 )

/obj/item/weapon/robot_module/robot/research //VOREStation sprites
	vr_sprites = list(
						"Acheron" = "mechoid-Science",
						"ZOOM-BA" = "zoomba-research"
					 )

/obj/item/weapon/robot_module/robot/security/combat //VOREStation sprites
	vr_sprites = list(
						"Acheron" = "mechoid-Combat",
						"ZOOM-BA" = "zoomba-combat"
					 )

/obj/item/weapon/robot_module/robot/knine
	name = "k9 robot module"
	sprites = list(
					"K9 hound" = "k9",
					"K9 Alternative (Static)" = "k92",
					"Secborg model V-2" = "secborg",
					"Borgi" = "borgi-sec"
					)
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/knine/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src) //You need cuffs to be a proper sec borg!
	src.modules += new /obj/item/weapon/dogborg/jaws/big(src) //In case there's some kind of hostile mob.
	src.modules += new /obj/item/weapon/melee/baton/robot(src) //Since the pounce module refused to work, they get a stunbaton instead.
	src.modules += new /obj/item/device/dogborg/boop_module(src) //Boop people on the nose.
	src.modules += new /obj/item/taperoll/police(src) //Block out crime scenes.
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg(src) //They /are/ a security borg, after all.
	src.modules += new /obj/item/weapon/dogborg/pounce(src) //Pounce
	src.emag 	 = new /obj/item/weapon/gun/energy/laser/mounted(src) //Emag. Not a big problem.

	var/datum/matter_synth/water = new /datum/matter_synth(500) //Starts full and has a max of 500
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/K9/B = new /obj/item/device/dogborg/sleeper/K9(src) //Eat criminals. Bring them to the brig.
	B.water = water
	src.modules += B

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/toggle_rider_reins
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()

/obj/item/weapon/robot_module/robot/knine/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/weapon/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost * amount)
		T.update_icon()
	else
		T.charge_tick = 0
	/*var/obj/item/weapon/melee/baton/robot/B = locate() in src.modules //Borg baton uses borg cell.
	if(B && B.bcell)
		B.bcell.give(amount)*/


/obj/item/weapon/robot_module/robot/medihound
	name = "MediHound module"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	sprites = list(
					"Medical Hound" = "medihound",
					"Dark Medical Hound (Static)" = "medihounddark",
					"Mediborg model V-2" = "vale",
					"Borgi" = "borgi-medi"
					)

/obj/item/weapon/robot_module/robot/medihound/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src) //In case a patient is being attacked by carp.
	src.modules += new /obj/item/device/dogborg/boop_module(src) //Boop the crew.
	src.modules += new /obj/item/device/healthanalyzer(src) // See who's hurt specificially.
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src) //In case the chemist is nice!
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker(src)//For holding the chemicals when the chemist is nice
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	src.modules += new /obj/item/weapon/shockpaddles/robot/hound(src) //Paws of life
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src) //Pounce

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/weapon/reagent_containers/borghypo/hound/H = new /obj/item/weapon/reagent_containers/borghypo/hound(src)
	H.water = water
	src.modules += H

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/B = new /obj/item/device/dogborg/sleeper(src) //So they can nom people and heal them
	B.water = water
	src.modules += B

	R.icon = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x  	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/toggle_rider_reins
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()

/obj/item/weapon/robot_module/robot/ert
	name = "Emergency Responce module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0
	sprites = list(
					"Standard" = "ert",
					"Borgi" = "borgi"
					)

/obj/item/weapon/robot_module/robot/ert/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/weapon/dogborg/jaws/big(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)
	src.modules += new /obj/item/taperoll/police(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg/ertgun(src)
	src.modules += new /obj/item/weapon/dogborg/swordtail(src)
	src.emag     = new /obj/item/weapon/gun/energy/laser/mounted(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/K9/B = new /obj/item/device/dogborg/sleeper/K9(src)
	B.water = water
	src.modules += B

	R.icon 		 = 'icons/mob/64x64robot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/toggle_rider_reins
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()

/obj/item/weapon/robot_module/robot/scrubpup
	name = "Custodial Hound module"
	sprites = list(
					"Custodial Hound" = "scrubpup",
					"Borgi" = "borgi-jani"
					)
	channels = list("Service" = 1)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/scrubpup/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/pupscrubber(src)
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src) //Pounce

	//Starts empty. Can only recharge with recycled material.
	var/datum/matter_synth/metal = new /datum/matter_synth/metal()
	metal.name = "Steel reserves"
	metal.recharge_rate = 0
	metal.max_energy = 50000
	metal.energy = 0
	var/datum/matter_synth/glass = new /datum/matter_synth/glass()
	glass.name = "Glass reserves"
	glass.recharge_rate = 0
	glass.max_energy = 50000
	glass.energy = 0
	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water

	synths += metal
	synths += glass
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/lightreplacer/dogborg/LR = new /obj/item/device/lightreplacer/dogborg(src)
	LR.glass = glass
	src.modules += LR

	var/obj/item/device/dogborg/sleeper/compactor/C = new /obj/item/device/dogborg/sleeper/compactor(src)
	C.metal = metal
	C.glass = glass
	C.water = water
	src.modules += C

	//Sheet refiners can only produce raw sheets.
	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.name = "steel recycler"
	M.desc = "A device that refines recycled steel into sheets."
	M.synths = list(metal)
	M.recipes = list()
	M.recipes += new/datum/stack_recipe("steel sheet", /obj/item/stack/material/steel, 1, 1, 20)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.name = "glass recycler"
	G.desc = "A device that refines recycled glass into sheets."
	G.material = get_material_by_name("placeholder") //Hacky shit but we want sheets, not windows.
	G.synths = list(glass)
	G.recipes = list()
	G.recipes += new/datum/stack_recipe("glass sheet", /obj/item/stack/material/glass, 1, 1, 20)
	src.modules += G

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/toggle_rider_reins
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()

/obj/item/weapon/robot_module/robot/science
	name = "Research Hound Module"
	sprites = list(
					"Research Hound" = "science",
					"Borgi" = "borgi-sci"
					)
	channels = list("Science" = 1)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/science/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/weapon/gripper/research(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/weapon/storage/part_replacer(src)
	src.modules += new /obj/item/device/robotanalyzer(src)
	src.modules += new /obj/item/weapon/card/robot(src)
	src.modules += new /obj/item/weapon/gripper/no_use/organ/robotics(src)
	src.modules += new /obj/item/weapon/gripper/no_use/mech(src)
	src.emag = new /obj/item/weapon/hand_tele(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/dogborg/sleeper/compactor/analyzer/B = new /obj/item/device/dogborg/sleeper/compactor/analyzer(src)
	B.water = water
	src.modules += B

	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite
	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	src.modules += N

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/toggle_rider_reins
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()

/obj/item/weapon/robot_module/robot/engiedog
	name = "Construction Hound module"
	sprites = list(
					"Pupdozer" = "pupdozer",
					"Borgi" = "borgi-eng",
					"V2 Engidog" = "thottbot"
					)
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/engiedog/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/analyzer(src)
	src.modules += new /obj/item/device/geiger(src)
	src.modules += new /obj/item/taperoll/engineering(src)
	src.modules += new /obj/item/weapon/inflatable_dispenser/robot(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/weapon/pickaxe(src)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/weapon/gripper/circuit(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/device/floor_painter(src)
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src)

	//Painfully slow charger regen but high capacity. Also starts with low amount.
	var/datum/matter_synth/metal = new /datum/matter_synth/metal()
	metal.name = "Steel reserves"
	metal.recharge_rate = 100
	metal.max_energy = 50000
	metal.energy = 10000
	var/datum/matter_synth/glass = new /datum/matter_synth/glass()
	glass.name = "Glass reserves"
	glass.recharge_rate = 100
	glass.max_energy = 50000
	glass.energy = 10000
	var/datum/matter_synth/wood = new /datum/matter_synth/wood()
	wood.name = "Wood reserves"
	wood.recharge_rate = 100
	wood.max_energy = 50000
	wood.energy = 10000
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic()
	plastic.name = "Plastic reserves"
	plastic.recharge_rate = 100
	plastic.max_energy = 50000
	plastic.energy = 10000
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel()
	plasteel.name = "Plasteel reserves"// Adding plasteel synthesizer to move in-line with Engiborg.
	plasteel.recharge_rate = 100
	plasteel.max_energy = 20000
	plasteel.energy = 10000
	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += metal
	synths += glass
	synths += wood
	synths += plastic
	synths += wire
	synths += water
	synths += plasteel

	var/obj/item/device/dogborg/tongue/T = new /obj/item/device/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/device/lightreplacer/dogborg/LR = new /obj/item/device/lightreplacer/dogborg(src)
	LR.glass = glass
	src.modules += LR

	var/obj/item/device/dogborg/sleeper/compactor/decompiler/MD = new /obj/item/device/dogborg/sleeper/compactor/decompiler(src)
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic
	MD.water = water
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/RD = new /obj/item/stack/rods/cyborg(src)
	RD.synths = list(metal)
	src.modules += RD

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	src.modules += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/PL = new (src)
	PL.synths = list(plastic)
	src.modules += PL

	var/obj/item/stack/material/cyborg/plasteel/PS = new (src)
	PS.synths = list(plasteel)
	src.modules += PS

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/toggle_rider_reins
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()

/obj/item/weapon/robot_module/Reset(var/mob/living/silicon/robot/R)
	R.pixel_x = initial(pixel_x)
	R.pixel_y = initial(pixel_y)
	R.icon = initial(R.icon)
	R.dogborg = FALSE
	R.wideborg = FALSE
	R.ui_style_vr = FALSE
	R.default_pixel_x = initial(pixel_x)
	R.scrubbing = FALSE
	R.verbs -= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs -= /mob/living/silicon/robot/proc/robot_mount
	R.verbs -= /mob/living/proc/toggle_rider_reins
	R.verbs -= /mob/living/proc/shred_limb
	R.verbs -= /mob/living/silicon/robot/proc/rest_style
	..()