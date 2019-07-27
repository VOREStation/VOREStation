/**********************Exploration Equipment Vendor**************************/

/obj/machinery/equipment_vendor/exploration
	name = "exploration equipment vendor"
	desc = "An equipment vendor for explorers, points collected with cataloguers can be spent here."
	icon = 'icons/obj/machines/mining_machines_vr.dmi'
	icon_state = "exploration"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/exploration_equipment_vendor
	var/icon_deny = "exploration-deny"
	var/icon_vend = "exploration-vend"
	var/obj/item/device/cataloguer/inserted_cataloguer
	var/list/prize_list = list(
		new /datum/data/exploration_equipment("1 Marker Beacon",			/obj/item/stack/marker_beacon,										1),
		new /datum/data/exploration_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,									10),
		new /datum/data/exploration_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,								30),
		new /datum/data/exploration_equipment("GPS Device",					/obj/item/device/gps/explorer,										10),
		new /datum/data/exploration_equipment("Whiskey",					/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,		10),
		new /datum/data/exploration_equipment("Absinthe",					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,	10),
		new /datum/data/exploration_equipment("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,			15),
		new /datum/data/exploration_equipment("Soap",						/obj/item/weapon/soap/nanotrasen,									20),
		new /datum/data/exploration_equipment("Laser Pointer",				/obj/item/device/laser_pointer,										90),
		new /datum/data/exploration_equipment("Plush Toy",					/obj/random/plushie,												30),
		new /datum/data/exploration_equipment("Shelter Capsule",			/obj/item/device/survivalcapsule,									50),
		new /datum/data/exploration_equipment("Point Transfer Card",		/obj/item/weapon/card/exploration_point_card,						50),
		new /datum/data/exploration_equipment("Survival Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner,	50),
		new /datum/data/exploration_equipment("Mini-Translocator",			/obj/item/device/perfect_tele/one_beacon,							120),
		new /datum/data/exploration_equipment("Space Cash",					/obj/item/weapon/spacecash/c100,									100),
		new /datum/data/exploration_equipment("Jump Boots",					/obj/item/clothing/shoes/bhop,										250),
		new /datum/data/exploration_equipment("Luxury Shelter Capsule",		/obj/item/device/survivalcapsule/luxury,							310)
		)

/datum/data/exploration_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0

/datum/data/exploration_equipment/New(name, path, cost)
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost

/obj/machinery/equipment_vendor/exploration/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()
	if(inserted_cataloguer && !powered())
		visible_message("<span class='notice'>The cataloguer slot indicator light flickers on \the [src] as it spits out the device before powering down.</span>")
		inserted_cataloguer.forceMove(get_turf(src))

/obj/machinery/equipment_vendor/exploration/update_icon()
	if(panel_open)
		icon_state = "[initial(icon_state)]-open"
	else if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/equipment_vendor/exploration/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/equipment_vendor/exploration/attack_ghost(mob/user)
	interact(user)

/obj/machinery/equipment_vendor/exploration/interact(mob/user)
	user.set_machine(src)

	var/dat
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_cataloguer))
		dat += "You have [inserted_cataloguer.points_stored] exploration points collected. <A href='?src=\ref[src];choice=eject'>Eject Cataloguer.</A><br>"
	else
		dat += "No Cataloguer inserted.  <A href='?src=\ref[src];choice=insert'>Insert Cataloguer.</A><br>"
	dat += "</div>"
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='100%'>"
	for(var/datum/data/exploration_equipment/prize in prize_list)
		dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A></td></tr>"
	dat += "</table>"
	var/datum/browser/popup = new(user, "miningvendor", "Exploration Equipment Vendor", 400, 600)
	popup.set_content(dat)
	popup.open()

/obj/machinery/equipment_vendor/exploration/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["choice"])
		if(istype(inserted_cataloguer))
			if(href_list["choice"] == "eject")
				to_chat(usr, "<span class='notice'>You eject the ID from [src]'s card slot.</span>")
				usr.put_in_hands(inserted_cataloguer)
				inserted_cataloguer = null
		else if(href_list["choice"] == "insert")
			var/obj/item/device/cataloguer/C = usr.get_active_hand()
			if(istype(C) && !inserted_cataloguer && usr.unEquip(C))
				C.forceMove(src)
				inserted_cataloguer = C
				interact(usr)
				to_chat(usr, "<span class='notice'>You insert the ID into [src]'s card slot.</span>")
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")
				flick(icon_deny, src)

	if(href_list["purchase"])
		if(istype(inserted_cataloguer))
			var/datum/data/exploration_equipment/prize = locate(href_list["purchase"])
			if (!prize || !(prize in prize_list))
				to_chat(usr, "<span class='warning'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			if(prize.cost > inserted_cataloguer.points_stored)
				to_chat(usr, "<span class='warning'>Error: Insufficent points for [prize.equipment_name]!</span>")
				flick(icon_deny, src)
			else
				inserted_cataloguer.points_stored -= prize.cost
				to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
				flick(icon_vend, src)
				new prize.equipment_path(drop_location())
		else
			to_chat(usr, "<span class='warning'>Error: Please insert a valid ID!</span>")
			flick(icon_deny, src)
	updateUsrDialog()

/obj/machinery/equipment_vendor/exploration/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, I))
		updateUsrDialog()
		return
	if(default_part_replacement(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(istype(I,/obj/item/device/cataloguer))
		if(!powered())
			return
		else if(!inserted_cataloguer && user.unEquip(I))
			I.forceMove(src)
			inserted_cataloguer = I
			interact(user)
		return
	..()

/obj/machinery/equipment_vendor/exploration/dismantle()
	if(inserted_cataloguer)
		inserted_cataloguer.forceMove(loc) //Prevents deconstructing the ORM from deleting whatever ID was inside it.
	. = ..()

/obj/machinery/equipment_vendor/exploration/proc/new_prize(var/name, var/path, var/cost) // Generic proc for adding new entries. Good for abusing for FUN and PROFIT.
	if(!cost)
		cost = 100
	if(!path)
		path = /obj/item/stack/marker_beacon
	if(!name)
		name = "Generic Entry"
	prize_list += new /datum/data/exploration_equipment(name, path, cost)

/obj/machinery/equipment_vendor/exploration/ex_act(severity, target)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(prob(50 / severity) && severity < 3)
		qdel(src)
