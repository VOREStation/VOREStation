//Attempted unify style implementation of boozeborgs. To lower peoples needed code diving to both understand this module and make new ones.
//Dropping my usual _unify for _ch this time. Commenting it here for github search.

// code/modules/mob/living/silicon/robot/robot_modules/station_vr.dm //tag so it shows up in gitsearch

/*
What Borgs are available is sadly handled in the above file in the proc

/hook/startup/proc/robot_modules_vr()
	robot_modules["Medihound"] = /obj/item/robot_module/robot/medihound
	robot_modules["K9"] = /obj/item/robot_module/robot/knine
	robot_modules["ERT"] = /obj/item/robot_module/robot/ert
	robot_modules["Janihound"] = /obj/item/robot_module/robot/scrubpup
	robot_modules["Sci-borg"] = /obj/item/robot_module/robot/science
	robot_modules["Pupdozer"] = /obj/item/robot_module/robot/engiedog
	return 1
*/

/obj/item/robot_module/robot/booze
	name = "BoozeHound robot module"
	channels = list("Service" = 1)
	languages = list(
					LANGUAGE_SOL_COMMON	= 1,
					LANGUAGE_UNATHI		= 1,
					LANGUAGE_SIIK		= 1,
					LANGUAGE_AKHANI		= 1,
					LANGUAGE_SKRELLIAN	= 1,
					LANGUAGE_SKRELLIANFAR = 0,
					LANGUAGE_ROOTLOCAL	= 0,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_GUTTER		= 0,
					LANGUAGE_SCHECHI	= 1,
					LANGUAGE_EAL		= 1,
					LANGUAGE_TERMINUS	= 1,
					LANGUAGE_SIGN		= 0
					)

/obj/item/robot_module/robot/booze
	sprites = list(
				"Beer Buddy" = "boozeborg",
				"Brilliant Blue" = "boozeborg(blue)",
				"Caffine Dispenser" = "boozeborg(coffee)",
				"Gamer Juice Maker" = "boozeborg(green)",
				"Liqour Licker" = "boozeborg(orange)",
				"The Grapist" = "boozeborg(purple)",
				"Vampire's Aid" = "boozeborg(red)",
				"Vodka Komrade" = "boozeborg(vodka)"
				)
/obj/item/robot_module/robot/booze/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/gripper/service(src)
	//src.modules += new /obj/item/reagent_containers/glass/bucket(src)
	//src.modules += new /obj/item/material/minihoe(src)
	//src.modules += new /obj/item/analyzer/plant_analyzer(src)
	//src.modules += new /obj/item/storage/bag/plants(src)
	//src.modules += new /obj/item/robot_harvester(src)
	src.modules += new /obj/item/material/knife(src)
	src.modules += new /obj/item/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/multitool(src) //to freeze trays
	src.modules += new /obj/item/dogborg/jaws/small(src)
	src.modules += new /obj/item/dogborg/boop_module(src)
	src.modules += new /obj/item/dogborg/sleeper/compactor/brewer(src)
	src.modules += new /obj/item/reagent_containers/glass/beaker(src)//For holding the ALCOHOL
	src.emag 	 = new /obj/item/dogborg/pounce(src)
	add_verb(R,/mob/living/silicon/robot/proc/reskin_booze)

	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)

	/* Remembered this causes the dogs to catch on fire lol.
	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L
	*/

	var/datum/matter_synth/water = new /datum/matter_synth()
	water.name = "Water reserves"
	water.recharge_rate = 0.1 // Recharging water for plants - hehe drooly borg
	water.max_energy = 1000
	water.energy = 0
	R.water_res = water
	synths += water

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T


	src.modules += new /obj/item/tray/robotray(src)
	src.modules += new /obj/item/reagent_containers/borghypo/service/booze(src)
	src.emag = new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagents/N = new/datum/reagents(50)
	src.emag.reagents = N
	N.my_atom = src.emag
	N.add_reagent("beer2", 50)
	src.emag.name = "Mickey Finn's Special Brew"

	R.can_buckle = 1
	R.icon 		 = 'icons/mob/widerobot_colors_ch.dmi'
	R.wideborg_dept = 'icons/mob/widerobot_colors_ch.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.vore_capacity = 1
	R.vore_capacity_ex = list("stomach" = 1)
	R.wideborg = TRUE
	add_verb(R,/mob/living/silicon/robot/proc/ex_reserve_refill) //TGPanel
	..()

/obj/item/robot_module/robot/booze/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2 * amount)
	if(src.emag)
		var/obj/item/reagent_containers/food/drinks/bottle/small/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2 * amount)

//BORGHYPO
/obj/item/reagent_containers/borghypo/service/booze
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispencer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 20
	recharge_time = 3
	volume = 120
	possible_transfer_amounts = list(1 ,5, 10, 20, 30)

//Resking proc for boozos

/mob/living/silicon/robot/proc/reskin_booze()
	set name = "Change Drink Color"
	set category = "Abilities.Silicon" //TGPanel
	set desc = "Choose the color of drink displayed inside you."

	var/mob/M = usr
	var/list/options = list()
	options["Beer"] = "Beer Buddy"
	options["Curacao"] = "Brilliant Blue"
	options["Coffee"] = "Caffine Dispenser"
	options["Space Mountain Wind"] = "Gamer Juice Maker"
	options["Whiskey Soda"] = "Liqour Licker"
	options["Grape Soda"] = "The Grapist"
	options["Demon's Blood"] = "Vampire's Aid"
	options["Slav Vodka"] = "Vodka Komrade"
	var/choice = input(M,"Choose your drink!") in options
	if(src && choice && !M.stat && in_range(M,src))
		icontype = options[choice]
		var/active_sound = 'sound/effects/bubbles.ogg'
		playsound(src.loc, "[active_sound]", 100, 0, 4)
		M << "Your Tank now displays [choice]. Drink up and enjoy!"
		updateicon()
		return 1

//SLEEPER "Brewer"
/obj/item/dogborg/sleeper/compactor/brewer //Boozehound gut.
	name = "Brew Belly"
	desc = "A mounted drunk tank unit with fuel processor."
	icon_state = "brewer"
	injection_chems = list(REAGENT_ID_VODKA,REAGENT_ID_BEER,REAGENT_ID_GIN) //Injected alcohol is 3 times as strong
	max_item_count = 1

/obj/item/dogborg/sleeper/compactor/brewer/inject_chem(mob/user, chem)
	if(patient && patient.reagents)
		if(chem in injection_chems + REAGENT_ID_INAPROVALINE)
			if(hound.cell.charge < 200) //This is so borgs don't kill themselves with it.
				to_chat(hound, span_notice("You don't have enough power to synthesize fluids."))
				return
			else if(patient.reagents.get_reagent_amount(chem) + 10 >= 50) //Preventing people from accidentally killing themselves by trying to inject too many chemicals!
				to_chat(hound, span_notice("Your stomach is currently too full of fluids to secrete more fluids of this kind."))
			else if(patient.reagents.get_reagent_amount(chem) + 10 <= 50) //No overdoses for you
				patient.reagents.add_reagent(chem, inject_amount)
				drain(100) //-100 charge per injection
			var/units = round(patient.reagents.get_reagent_amount(chem))
			to_chat(hound, span_notice("Injecting [units] unit\s into occupant.")) //If they were immersed, the reagents wouldn't leave with them.
