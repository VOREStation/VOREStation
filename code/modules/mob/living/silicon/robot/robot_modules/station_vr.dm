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
	return 1

//Just add a new proc with the robot_module type if you wish to run some other vore code
/obj/item/weapon/robot_module/proc/vr_new() // Any Global modules, just add them before the return (This will also affect all the borgs in this file)
	return

/obj/item/weapon/robot_module/robot/medical/surgeon/vr_new() //Surgeon Bot
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	. = ..() //Any Global vore modules will come from here

/obj/item/weapon/robot_module/robot/medical/crisis/vr_new() //Crisis Bot
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	. = ..() //Any Global vore modules will come from here

/obj/item/weapon/robot_module/robot/knine
	name = "k9 robot module"
	sprites = list(
					"K9 hound" = "k9",
					"K9 Alternative (Static)" = "k92",
					"Secborg model V-2" = "secborg"
					)
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/knine/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src) //You need cuffs to be a proper sec borg!
	src.modules += new /obj/item/weapon/dogborg/jaws/big(src) //In case there's some kind of hostile mob.
	src.modules += new /obj/item/weapon/melee/baton/robot(src) //Since the pounce module refused to work, they get a stunbaton instead.
	src.modules += new /obj/item/device/dogborg/boop_module(src) //Boop people on the nose.
	src.modules += new /obj/item/device/dogborg/tongue(src) //This is so they can clean up bloody evidence after it's examined, and so they can lick crew.
	src.modules += new /obj/item/taperoll/police(src) //Block out crime scenes.
	src.modules += new /obj/item/device/dogborg/sleeper/K9(src) //Eat criminals. Bring them to the brig.
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg(src) //They /are/ a security borg, after all.
	src.modules += new /obj/item/weapon/dogborg/pounce(src) //Pounce
	src.emag 	 = new /obj/item/weapon/gun/energy/laser/mounted(src) //Emag. Not a big problem.
	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	//R.icon_state = "k9"
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.dogborg = TRUE
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
					"Mediborg model V-2" = "vale"
					)

/obj/item/weapon/robot_module/robot/medihound/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src) //In case a patient is being attacked by carp.
	src.modules += new /obj/item/device/dogborg/boop_module(src) //Boop the crew.
	src.modules += new /obj/item/device/dogborg/tongue(src) //Clean up bloody items by licking them, and eat rubbish for minor energy.
	src.modules += new /obj/item/device/healthanalyzer(src) // See who's hurt specificially.
	src.modules += new /obj/item/device/dogborg/sleeper(src) //So they can nom people and heal them
	src.modules += new /obj/item/weapon/reagent_containers/borghypo(src)//So medi-hounds aren't nearly useless
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src) //In case the chemist is nice!
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker(src)//For holding the chemicals when the chemist is nice
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	src.modules += new /obj/item/weapon/shockpaddles/robot/hound(src) //Paws of life
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src) //Pounce
	R.icon = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	//R.icon_state = "medihound"
	R.pixel_x 	 = -16
	R.old_x  	 = -16
	R.dogborg = TRUE
	..()

/obj/item/weapon/robot_module/robot/ert
	name = "Emergency Responce module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0
	sprites = list(
					"Standard" = "ert"
					)

/obj/item/weapon/robot_module/robot/ert/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/weapon/dogborg/jaws/big(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)
	src.modules += new /obj/item/device/dogborg/tongue(src)
	src.modules += new /obj/item/taperoll/police(src)
	src.modules += new /obj/item/device/dogborg/sleeper/K9(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg/ertgun(src)
	src.modules += new /obj/item/weapon/dogborg/swordtail(src)
	src.emag     = new /obj/item/weapon/gun/energy/laser/mounted(src)
	R.icon 		 = 'icons/mob/64x64robot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.dogborg = TRUE
	..()

/obj/item/weapon/robot_module/robot/scrubpup
	name = "Custodial Hound module"
	sprites = list(
					"Custodial Hound" = "scrubpup",
					)
	channels = list("Service" = 1)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/scrubpup/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/device/lightreplacer/dogborg(src)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/device/dogborg/tongue(src)
	src.modules += new /obj/item/device/dogborg/sleeper/compactor(src)
	src.emag 	 = new /obj/item/weapon/dogborg/pounce(src) //Pounce
	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	//R.icon_state = "scrubpup"
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.dogborg = TRUE
	..()

/obj/item/weapon/robot_module/robot/scrubpup/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)

/obj/item/weapon/robot_module/robot/science
	name = "Research Hound Module"
	sprites = list(
					"Research Hound" = "science",
					)
	channels = list("Science" = 1)
	can_be_pushed = 0

/obj/item/weapon/robot_module/robot/science/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/weapon/dogborg/jaws/small(src)
	src.modules += new /obj/item/device/dogborg/boop_module(src)
	src.modules += new /obj/item/device/dogborg/tongue(src)
	src.modules += new /obj/item/device/dogborg/sleeper/compactor/analyzer(src)
	//src.modules += new /obj/item/weapon/portable_destructive_analyzer(src) //Belly works now.
	src.modules += new /obj/item/weapon/gripper/research(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/weapon/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/weapon/storage/part_replacer(src)
	src.emag = new /obj/item/weapon/hand_tele(src)
	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	//R.icon_state = "science"
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.dogborg = TRUE
	..()

