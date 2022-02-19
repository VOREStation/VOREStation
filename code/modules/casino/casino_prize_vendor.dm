
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

// Use this define to register a prize!
// * n - The proper name of the purchasable
// * o - The object type path of the purchasable to spawn
// * r - The amount to dispense
// * p - The price of the purchasable in chips
// * l - The restriction of the item
#define CASINO_PRIZE(n, o, r, p, l) n = new /datum/data/casino_prize(n, o, r, p, l)

/datum/data/casino_prize
	var/equipment_path = null
	var/equipment_amt = 1
	var/cost = 0
	var/category = null
	var/restriction = null

/datum/data/casino_prize/New(name, path, amt, cost, restriction)
	src.name = name
	src.equipment_path = path
	src.equipment_amt = amt
	src.cost = cost
	src.category = category
	src.restriction = restriction

/obj/machinery/casino_prize_dispenser
	name = "Casino Prize Exchanger"
	desc = "Exchange your chips to obtain wonderful prizes! Hoepfully you'll get to keep some of them for a while."
	icon = 'icons/obj/casino.dmi'
	icon_state ="casino_prize_dispenser"
	var/icon_vend ="casino_prize_dispenser-vend"
	anchored = 1
	density = 1
	opacity = 0
	var/list/item_list

	clicksound = "button"
	var/vending_sound = "machines/vending/vending_drop.ogg"

	// Power
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	var/vend_power_usage = 150 //actuators and stuff

	// Vending-related
	var/datum/data/casino_prize/currently_vending = null // What we're requesting payment for right now
	var/list/log = list() //Log only SS13 staff is allowed to look at, CKEYS are listed here for record keeping of prizes and players for events!

	var/category_weapons	 = 1	//For listing categories, if false then prizes of this categories cant be obtained nor bought for post-shift enjoyment
	var/category_gear		 = 1	//If 1 prizes will be only logged
	var/category_clothing	 = 1	//If 2 prizes will both be logged and spawned
	var/category_misc		 = 1
	var/category_drinks		 = 1
	var/category_implants	 = 1
	var/category_event		 = 1	//For special events, holidays, etc

/obj/machinery/casino_prize_dispenser/Initialize()
	. = ..()
	power_change()

	item_list = list()
	item_list["Weapons"] = list(
		CASINO_PRIZE("Scepter", /obj/item/weapon/scepter, 1, 500, "weapons"),
		CASINO_PRIZE("Chain of Command", /obj/item/weapon/melee/chainofcommand, 1, 250, "weapons"),
		CASINO_PRIZE("Size Gun", /obj/item/weapon/gun/energy/sizegun, 1, 100, "weapons"),
		CASINO_PRIZE("Advanced Particle Rifle", /obj/item/weapon/gun/energy/particle/advanced, 1, 500, "weapons"),
		CASINO_PRIZE("Temperature Gun", /obj/item/weapon/gun/energy/temperature, 1, 250, "weapons"),
		CASINO_PRIZE("Alien Pistol", /obj/item/weapon/gun/energy/alien, 1, 1000, "weapons"),
		CASINO_PRIZE("Floral Gun", /obj/item/weapon/gun/energy/floragun, 1, 250, "weapons"),
		CASINO_PRIZE("Net Gun", /obj/item/weapon/gun/energy/netgun, 1, 500, "weapons"),
	)
	item_list["Gear"] = list(
		CASINO_PRIZE("Experimental Welder", /obj/item/weapon/weldingtool/experimental, 1, 500, "gear"),
		CASINO_PRIZE("Chameleon Tie", /obj/item/clothing/accessory/chameleon, 1, 250, "gear"),
		CASINO_PRIZE("Chemsprayer", /obj/item/weapon/reagent_containers/spray/chemsprayer, 1, 250, "gear"),
		CASINO_PRIZE("Bluespace Beaker", /obj/item/weapon/reagent_containers/glass/beaker/bluespace, 1, 200, "gear"),
		CASINO_PRIZE("Cryo Beaker", /obj/item/weapon/reagent_containers/glass/beaker/noreact, 1, 200, "gear"),
	)
	item_list["Clothing"] = list(
		CASINO_PRIZE("Shark mask", /obj/item/clothing/mask/shark, 1, 50, "clothing"),
		CASINO_PRIZE("Pig mask", /obj/item/clothing/mask/pig, 1, 50, "clothing"),
		CASINO_PRIZE("Luchador mask", /obj/item/clothing/mask/luchador, 1, 50, "clothing"),
		CASINO_PRIZE("Horse mask", /obj/item/clothing/mask/horsehead, 1, 50, "clothing"),
		CASINO_PRIZE("Goblin mask", /obj/item/clothing/mask/goblin, 1, 50, "clothing"),
		CASINO_PRIZE("Fake moustache", /obj/item/clothing/mask/fakemoustache, 1, 50, "clothing"),
		CASINO_PRIZE("Dolphin mask", /obj/item/clothing/mask/dolphin, 1, 50, "clothing"),
		CASINO_PRIZE("Demon mask", /obj/item/clothing/mask/demon, 1, 50, "clothing"),
		CASINO_PRIZE("Chameleon mask", /obj/item/clothing/under/chameleon, 1, 250, "clothing"),
		CASINO_PRIZE("Ian costume", /obj/item/clothing/suit/storage/hooded/costume/ian, 1, 50, "clothing"),
		CASINO_PRIZE("Carp costume", /obj/item/clothing/suit/storage/hooded/costume/carp, 1, 50, "clothing"),
	)
	item_list["Miscellaneous"] = list(
		CASINO_PRIZE("Toy sword", /obj/item/toy/sword, 1, 50, "misc"),
		CASINO_PRIZE("Waterflower", /obj/item/weapon/reagent_containers/spray/waterflower, 1, 50, "misc"),
		CASINO_PRIZE("Horse stick", /obj/item/toy/stickhorse, 1, 50, "misc"),
		CASINO_PRIZE("Katana", /obj/item/toy/katana, 1, 50, "misc"),
		CASINO_PRIZE("Conch", /obj/item/toy/eight_ball/conch, 1, 50, "misc"),
		CASINO_PRIZE("Eight ball", /obj/item/toy/eight_ball, 1, 50, "misc"),
		CASINO_PRIZE("Foam sword", /obj/item/weapon/material/sword/foam, 1, 50, "misc"),
		CASINO_PRIZE("Whistle", /obj/item/toy/bosunwhistle, 1, 50, "misc"),
		CASINO_PRIZE("Golden cup", /obj/item/weapon/reagent_containers/food/drinks/golden_cup, 1, 50, "misc"),
		CASINO_PRIZE("Quality cigars", /obj/item/weapon/storage/fancy/cigar/havana, 1, 50, "misc"),
		CASINO_PRIZE("Casino wallet (kept after event)", /obj/item/weapon/storage/wallet/casino, 1, 50, "misc"),
		CASINO_PRIZE("Casino cards", /obj/item/weapon/deck/cards/casino, 1, 50, "misc"),
	)
	item_list["Drinks"] = list(
		CASINO_PRIZE("Redeemer's brew", /obj/item/weapon/reagent_containers/food/drinks/bottle/redeemersbrew, 1, 50, "drinks"),
		CASINO_PRIZE("Poison wine", /obj/item/weapon/reagent_containers/food/drinks/bottle/pwine, 1, 50, "drinks"),
		CASINO_PRIZE("Patron", /obj/item/weapon/reagent_containers/food/drinks/bottle/patron, 1, 50, "drinks"),
		CASINO_PRIZE("Holy water", /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, 1, 50, "drinks"),
		CASINO_PRIZE("Goldschlager", /obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager, 1, 50, "drinks"),
		CASINO_PRIZE("Champagne", /obj/item/weapon/reagent_containers/food/drinks/bottle/champagne, 1, 50, "drinks"),
		CASINO_PRIZE("Bottle of Nothing", /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing, 1, 50, "drinks"),
		CASINO_PRIZE("Whiskey bliss", /obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey, 1, 50, "drinks"),
	)

	item_list["Implants"] = list(
		CASINO_PRIZE("Implanter (Remember to get one unless you want to borrow from station!)", /obj/item/weapon/implanter, 1, 100, "implants"),
		CASINO_PRIZE("Implant: Tazer", /obj/item/weapon/implantcase/taser, 1, 1000, "implants"),
		CASINO_PRIZE("Implant: Medkit", /obj/item/weapon/implantcase/medkit, 1, 500, "implants"),
		CASINO_PRIZE("Implant: Shades", /obj/item/weapon/implantcase/shades, 1, 750, "implants"),
		CASINO_PRIZE("Implant: Sprinter", /obj/item/weapon/implantcase/sprinter, 1, 1500, "implants"),
		CASINO_PRIZE("Implant: Toolkit", /obj/item/weapon/implantcase/toolkit, 1, 500, "implants"),
		CASINO_PRIZE("Implant: Language", /obj/item/weapon/implantcase/vrlanguage, 1, 1000, "implants"),
		CASINO_PRIZE("Implant: Analyzer", /obj/item/weapon/implantcase/analyzer, 1, 500, "implants"),
		CASINO_PRIZE("Implant: Size control", /obj/item/weapon/implant/sizecontrol , 1, 500, "implants"),
	)

	item_list["Event"] = list(
	)

/obj/machinery/casino_prize_dispenser/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(!(stat & NOPOWER))
			icon_state = initial(icon_state)
		else
			spawn(rand(0, 15))
				icon_state = "[initial(icon_state)]-off"

/obj/machinery/casino_prize_dispenser/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)

/obj/machinery/casino_prize_dispenser/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(currently_vending)
		if(istype(W, /obj/item/weapon/spacecasinocash))
			to_chat(usr, "<span class='warning'>Please select prize on display with sufficient amount of chips.</span>")
		else
			SStgui.update_uis(src)
			return // don't smack that machine with your 2 chips

	if(istype(W, /obj/item/weapon/spacecasinocash))
		attack_hand(user)
		return
	..()

/obj/machinery/casino_prize_dispenser/proc/pay_with_chips(var/obj/item/weapon/spacecasinocash/cashmoney, mob/user, var/price)
	//"cashmoney_:[cashmoney] user:[user] currently_vending:[currently_vending]"
	if(price > cashmoney.worth)
		to_chat(usr, "\icon[cashmoney] <span class='warning'>That is not enough chips.</span>")
		return 0

	if(istype(cashmoney, /obj/item/weapon/spacecasinocash))
		visible_message("<span class='info'>\The [usr] inserts some chips into \the [src].</span>")
		cashmoney.worth -= price

		if(cashmoney.worth <= 0)
			usr.drop_from_inventory(cashmoney)
			qdel(cashmoney)
		else
			cashmoney.update_icon()
	return 1

/obj/machinery/casino_prize_dispenser/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/vending),
	)

/obj/machinery/casino_prize_dispenser/tgui_data(mob/user)
	var/list/data[0]

	data["items"] = list()
	for(var/cat in item_list)
		var/list/cat_items = list()
		for(var/prize_name in item_list[cat])
			var/datum/data/casino_prize/prize = item_list[cat][prize_name]
			cat_items[prize_name] = list("name" = prize_name, "price" = prize.cost, "restriction" = prize.restriction)
		data["items"][cat] = cat_items
	return data

/obj/machinery/casino_prize_dispenser/tgui_interact(mob/user, datum/tgui/ui = null)
	// Open the window
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CasinoPrizeDispenser", name)
		ui.open()

/obj/machinery/casino_prize_dispenser/tgui_act(action, params)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.stat || usr.restrained())
		return
	if(..())
		return TRUE
	. = TRUE
	switch(action)
		if("purchase")
			var/paid = FALSE
			var/category = params["cat"]
			var/restriction_category = params["restriction"]
			var/restriction_check = 0
			var/item_given = FALSE
			var/name = params["name"]
			var/price = params["price"]
			var/datum/data/casino_prize/bi = item_list[category][name]
			switch(restriction_category)
				if("weapons")
					restriction_check = category_weapons
				if("gear")
					restriction_check = category_gear
				if("clothing")
					restriction_check = category_clothing
				if("misc")
					restriction_check = category_misc
				if("drinks")
					restriction_check = category_drinks
				if("implants")
					restriction_check = category_implants
				if("event")
					restriction_check = category_event
				else
					to_chat(usr, "<span class='warning'>Prize checkout error has occured, purchase cancelled.</span>")
					return FALSE

			if(restriction_check < 1)
				to_chat(usr, "<span class='warning'>[name] is restricted, this prize can't be bought.</span>")
				return FALSE
			if(restriction_check > 1)
				item_given = TRUE

			if(price <= 0 && item_given == TRUE)
				vend(bi, usr)
				return TRUE

			currently_vending = bi

			if(istype(usr.get_active_hand(), /obj/item/weapon/spacecasinocash))
				var/obj/item/weapon/spacecasinocash/cash = usr.get_active_hand()
				paid = pay_with_chips(cash, usr, price)
			else
				to_chat(usr, "<span class='warning'>Payment failure: Improper payment method, please provide chips.</span>")
				return TRUE // we set this because they shouldn't even be able to get this far, and we want the UI to update.
			if(paid)
				if(item_given == TRUE)
					vend(bi, usr)

				speak("Thank you for your purchase, your [bi] has been logged.")
				do_logging(currently_vending, usr, bi)
				. = TRUE
			else
				to_chat(usr, "<span class='warning'>Payment failure: unable to process payment.</span>")

/obj/machinery/casino_prize_dispenser/proc/vend(datum/data/casino_prize/bi, mob/user)
	SStgui.update_uis(src)

	if(ispath(bi.equipment_path, /obj/item/stack))
		new bi.equipment_path(loc, bi.equipment_amt)
		playsound(src, 'sound/machines/vending/vending_drop.ogg', 100, 1)
		return TRUE

	for(var/i in 1 to bi.equipment_amt)
		new bi.equipment_path(loc)
		playsound(src, 'sound/machines/vending/vending_drop.ogg', 100, 1)

	currently_vending = null
	use_power(vend_power_usage)	//actuators and stuff
	flick("[icon_state]-vend",src)


/obj/machinery/casino_prize_dispenser/proc/do_logging(item, mob/user, datum/data/casino_prize/bi)
	var/prize_log = "{ckey:[user.ckey]character_name:[user.name]item_path: [bi.equipment_path]}"
	log[++log.len] = prize_log
	//Currently doesnt have an ingame way to show. Can only be viewed through View-Variables, to ensure theres no chance of players ckeys exposed - Jack

/obj/machinery/casino_prize_dispenser/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if(!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/casino_prize_dispenser/process() //Might not need this, but just to be safe for now
	if(stat & (BROKEN|NOPOWER))
		return