/obj/machinery/mineral/equipment_vendor/survey
	name = "exploration equipment vendor"
	desc = "An equipment vendor for explorers, points collected with a survey scanner can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "explore"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/mining_equipment_vendor
	icon_deny = "explore-deny"
	prize_list = list(
		new /datum/data/mining_equipment("1 Marker Beacon",				/obj/item/stack/marker_beacon,										1),
		new /datum/data/mining_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,									10),
		new /datum/data/mining_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,								30),
		new /datum/data/mining_equipment("Whiskey",						/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,		120),
		new /datum/data/mining_equipment("Absinthe",					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,	120),
		new /datum/data/mining_equipment("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,			15),
		new /datum/data/mining_equipment("Soap",						/obj/item/weapon/soap/nanotrasen,									20),
		new /datum/data/mining_equipment("Laser Pointer",				/obj/item/device/laser_pointer,										90),
		new /datum/data/mining_equipment("Geiger Counter",				/obj/item/device/geiger,											75),
		new /datum/data/mining_equipment("Plush Toy",					/obj/random/plushie,												30),
		new /datum/data/mining_equipment("Umbrella",					/obj/item/weapon/melee/umbrella/random,								20),
		new /datum/data/mining_equipment("Extraction Equipment - Fulton Beacon",	/obj/item/fulton_core,									300),
		new /datum/data/mining_equipment("Extraction Equipment - Fulton Pack",		/obj/item/extraction_pack,								125),
		new /datum/data/mining_equipment("Point Transfer Card",			/obj/item/weapon/card/mining_point_card/survey,						50),
		new /datum/data/mining_equipment("Fishing Net",					/obj/item/weapon/material/fishing_net,								50),
		new /datum/data/mining_equipment("Titanium Fishing Rod",		/obj/item/weapon/material/fishing_rod/modern,						100),
		new /datum/data/mining_equipment("Direct Payment - 1000",		/obj/item/weapon/spacecash/c1000,									500),
		new /datum/data/mining_equipment("Industrial Equipment - Phoron Bore",	/obj/item/weapon/gun/magnetic/matfed,						500),
		new /datum/data/mining_equipment("Survey Tools - Shovel",		/obj/item/weapon/shovel,											40),
		new /datum/data/mining_equipment("Survey Tools - Mechanical Trap",	/obj/item/weapon/beartrap,										50),
		new /datum/data/mining_equipment("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,	100),
		new /datum/data/mining_equipment("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,	300),
		new /datum/data/mining_equipment("Injector (L) - Glucose",/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/glucose,	50),
		new /datum/data/mining_equipment("Injector (L) - Panacea",/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity,	50),
		new /datum/data/mining_equipment("Injector (L) - Trauma",/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute,	250),
		new /datum/data/mining_equipment("Nanopaste Tube",				/obj/item/stack/nanopaste,											100),
		new /datum/data/mining_equipment("Defense Equipment - Phase Pistol",/obj/item/weapon/gun/energy/phasegun/pistol,					30),
		new /datum/data/mining_equipment("Defense Equipment - Smoke Bomb",/obj/item/weapon/grenade/smokebomb,								100),
		new /datum/data/mining_equipment("Defense Equipment - Razor Drone Deployer",/obj/item/weapon/grenade/spawnergrenade/manhacks/station,	200),
		new /datum/data/mining_equipment("Defense Equipment - Sentry Drone Deployer",/obj/item/weapon/grenade/spawnergrenade/ward,			300),
		new /datum/data/mining_equipment("Defense Equipment - Steel Machete",	/obj/item/weapon/material/knife/machete,					75)
		)

/obj/machinery/mineral/equipment_vendor/explorer/interact(mob/user)
	user.set_machine(src)

	var/dat
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.survey_points] survey points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"
	dat += "</div>"
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='100%'>"
	for(var/datum/data/mining_equipment/prize in prize_list)
		dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A></td></tr>"
	dat += "</table>"
	var/datum/browser/popup = new(user, "miningvendor", "Survey Equipment Vendor", 400, 600)
	popup.set_content(dat)
	popup.open()

/obj/machinery/mineral/equipment_vendor/explorer/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				to_chat(usr, "<span class='notice'>You eject the ID from [src]'s card slot.</span>")
				usr.put_in_hands(inserted_id)
				inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if(istype(I) && !inserted_id && usr.unEquip(I))
				I.forceMove(src)
				inserted_id = I
				interact(usr)
				to_chat(usr, "<span class='notice'>You insert the ID into [src]'s card slot.</span>")
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")
				flick(icon_deny, src)

	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/data/mining_equipment/prize = locate(href_list["purchase"])
			if (!prize || !(prize in prize_list))
				to_chat(usr, "<span class='warning'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			if(prize.cost > inserted_id.survey_points)
				to_chat(usr, "<span class='warning'>Error: Insufficent points for [prize.equipment_name]!</span>")
				flick(icon_deny, src)
			else
				inserted_id.survey_points -= prize.cost
				to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
				new prize.equipment_path(drop_location())
		else
			to_chat(usr, "<span class='warning'>Error: Please insert a valid ID!</span>")
			flick(icon_deny, src)
	updateUsrDialog()
