
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

	var/category_weapons	 = 2	//For listing categories, if false then prizes of this categories cant be obtained nor bought for post-shift enjoyment
	var/category_gear		 = 2	//If 1 prizes will be only logged
	var/category_clothing	 = 2	//If 2 prizes will both be logged and spawned
	var/category_misc		 = 2
	var/category_drinks		 = 2
	var/category_implants	 = 1
	var/category_event		 = 1	//For special events, holidays, etc

/obj/machinery/casino_prize_dispenser/Initialize()
	. = ..()
	power_change()

	item_list = list()
	item_list["Weapons"] = list(
		CASINO_PRIZE("Scepter", /obj/item/scepter, 1, 2500, "weapons"),
		CASINO_PRIZE("Rapier", /obj/item/melee/rapier, 1, 3000, "weapons"),
		CASINO_PRIZE("Chain of Command", /obj/item/melee/chainofcommand, 1, 1250, "weapons"),
		CASINO_PRIZE("Golden Bat", /obj/item/material/twohanded/baseballbat/gold, 1, 1000, "weapons"),
		CASINO_PRIZE("Size Gun", /obj/item/gun/energy/sizegun, 1, 1500, "weapons"),
		CASINO_PRIZE("Gradual Size Gun", /obj/item/slow_sizegun, 1, 1500, "weapons"),
		CASINO_PRIZE("Metamorphosis Ray", /obj/item/gun/energy/mouseray/metamorphosis, 1, 6000, "weapons"),
		CASINO_PRIZE("Net Gun", /obj/item/gun/energy/netgun, 1, 3000, "weapons"),
	)
	item_list["Gear"] = list(
		CASINO_PRIZE("Experimental Welder", /obj/item/weldingtool/experimental, 1, 500, "gear"),
		CASINO_PRIZE("Chemsprayer", /obj/item/reagent_containers/spray/chemsprayer, 1, 1250, "gear"),
		CASINO_PRIZE("Bluespace Beaker", /obj/item/reagent_containers/glass/beaker/bluespace, 1, 1000, "gear"),
		CASINO_PRIZE("Cryo Beaker", /obj/item/reagent_containers/glass/beaker/noreact, 1, 1000, "gear"),
		CASINO_PRIZE("Golden Pickaxe", /obj/item/pickaxe/gold, 1, 1000, "gear"),
	)
	item_list["Clothing"] = list(
		CASINO_PRIZE("Shark mask", /obj/item/clothing/mask/shark, 1, 250, "clothing"),
		CASINO_PRIZE("Pig mask", /obj/item/clothing/mask/pig, 1, 250, "clothing"),
		CASINO_PRIZE("Luchador mask", /obj/item/clothing/mask/luchador, 1, 250, "clothing"),
		CASINO_PRIZE("Horse mask", /obj/item/clothing/mask/horsehead, 1, 250, "clothing"),
		CASINO_PRIZE("Goblin mask", /obj/item/clothing/mask/goblin, 1, 250, "clothing"),
		CASINO_PRIZE("Fake moustache", /obj/item/clothing/mask/fakemoustache, 1, 250, "clothing"),
		CASINO_PRIZE("Dolphin mask", /obj/item/clothing/mask/dolphin, 1, 250, "clothing"),
		CASINO_PRIZE("Demon mask", /obj/item/clothing/mask/demon, 1, 250, "clothing"),
		CASINO_PRIZE("Chameleon mask", /obj/item/clothing/under/chameleon, 1, 1000, "clothing"),
		CASINO_PRIZE("Chameleon tie", /obj/item/clothing/accessory/chameleon, 1, 750, "clothing"),
		CASINO_PRIZE("Ian costume", /obj/item/clothing/suit/storage/hooded/costume/ian, 1, 250, "clothing"),
		CASINO_PRIZE("Carp costume", /obj/item/clothing/suit/storage/hooded/costume/carp, 1, 250, "clothing"),
		CASINO_PRIZE("Plague doctor costume", /obj/item/storage/box/casino/costume_plaguedoctor, 1, 500, "clothing"),
		CASINO_PRIZE("Wizard costume", /obj/item/storage/box/casino/costume_wizard, 1, 500, "clothing"),
		CASINO_PRIZE("Pirate costume", /obj/item/storage/box/casino/costume_pirate, 1, 500, "clothing"),
		CASINO_PRIZE("Commie costume", /obj/item/storage/box/casino/costume_commie, 1, 500, "clothing"),
		CASINO_PRIZE("Marine costume", /obj/item/storage/box/casino/costume_marine, 1, 500, "clothing"),
		CASINO_PRIZE("Cowboy costume", /obj/item/storage/box/casino/costume_cowboy, 1, 500, "clothing"),
		CASINO_PRIZE("Golden Collar", /obj/item/clothing/accessory/collar/gold, 1, 250, "clothing"),
		CASINO_PRIZE("Decorative Casino Sentient Prize Collar", /obj/item/clothing/accessory/collar/casinosentientprize_fake, 1, 100, "clothing"),
		CASINO_PRIZE("Bluespace Collar", /obj/item/clothing/accessory/collar/shock/bluespace, 1, 1000, "clothing"),
	)
	item_list["Donk Soft"] = list(
		CASINO_PRIZE("Donk-Soft shotgun", /obj/item/gun/projectile/shotgun/pump/toy, 1, 1000, "misc"),
		CASINO_PRIZE("Donk-Soft mosin-nagant", /obj/item/gun/projectile/shotgun/pump/toy/moistnugget, 1, 1000, "misc"),
		CASINO_PRIZE("Donk-Soft pistol", /obj/item/gun/projectile/pistol/toy, 1, 800, "misc"),
		CASINO_PRIZE("Donk-Soft levergun", /obj/item/gun/projectile/shotgun/pump/toy/levergun, 1, 1000, "misc"),
		CASINO_PRIZE("Donk-Soft commemorative pistol", /obj/item/gun/projectile/pistol/toy/n99, 1, 750, "misc"),
		CASINO_PRIZE("Donk-Soft revolver", /obj/item/gun/projectile/revolver/toy, 1, 750, "misc"),
		CASINO_PRIZE("Donk-Soft big-iron", /obj/item/gun/projectile/revolver/toy/big_iron, 1, 750, "misc"),
		CASINO_PRIZE("Donk-Soft crossbow", /obj/item/gun/projectile/revolver/toy/crossbow, 1, 600, "misc"),
		CASINO_PRIZE("Donk-Soft sawn off shotgun", /obj/item/gun/projectile/revolver/toy/sawnoff, 1, 800, "misc"),
		CASINO_PRIZE("Donk-Soft SMG", /obj/item/gun/projectile/automatic/toy, 1, 1200, "misc"),
		CASINO_PRIZE("Foam Darts", /obj/item/ammo_magazine/ammo_box/foam, 1, 100, "misc"),
		CASINO_PRIZE("Riot Darts", /obj/item/ammo_magazine/ammo_box/foam/riot, 1, 200, "misc"),
	)
	item_list["Miscellaneous"] = list(
		CASINO_PRIZE("Winner's Medal", /obj/item/clothing/accessory/medal/gold/casino, 1, 30000, "misc"),
		CASINO_PRIZE("Golden ID card", /obj/item/card/id/gold, 1, 1000, "misc"),
		CASINO_PRIZE("Gold-trimmed pen", /obj/item/pen/fountain5, 1, 50, "misc"),
		CASINO_PRIZE("Golden pen", /obj/item/pen/fountain7, 1, 350, "misc"),
		CASINO_PRIZE("Toy sword", /obj/item/toy/sword, 1, 200, "misc"),
		CASINO_PRIZE("Waterflower", /obj/item/reagent_containers/spray/waterflower, 1, 100, "misc"),
		CASINO_PRIZE("Horse stick", /obj/item/toy/stickhorse, 1, 100, "misc"),
		CASINO_PRIZE("Toy katana", /obj/item/toy/katana, 1, 200, "misc"),
		CASINO_PRIZE("Magic conch", /obj/item/toy/eight_ball/conch, 1, 100, "misc"),
		CASINO_PRIZE("Magic eight ball", /obj/item/toy/eight_ball, 1, 100, "misc"),
		CASINO_PRIZE("Foam sword", /obj/item/material/sword/foam, 1, 200, "misc"),
		CASINO_PRIZE("Whistle", /obj/item/toy/bosunwhistle, 1, 100, "misc"),
		CASINO_PRIZE("Golden cup", /obj/item/reagent_containers/food/drinks/golden_cup, 1, 250, "misc"),
		CASINO_PRIZE("Quality cigars", /obj/item/storage/fancy/cigar/havana, 1, 100, "misc"),
		CASINO_PRIZE("Golden zippo lighter", /obj/item/flame/lighter/zippo/gold, 1, 100, "misc"),
		CASINO_PRIZE("Candelabra", /obj/item/flame/candle/candelabra/everburn, 1, 400, "misc"),
		CASINO_PRIZE("Casino wallet", /obj/item/storage/wallet/casino, 1, 200, "misc"),
		CASINO_PRIZE("Casino cards", /obj/item/deck/cards/casino, 1, 200, "misc"),
		CASINO_PRIZE("Instrument: Accordion", /obj/item/instrument/accordion, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Banjo", /obj/item/instrument/banjo, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Musical bikehorn", /obj/item/instrument/bikehorn, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Electric guitar", /obj/item/instrument/eguitar, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Glockenspiel", /obj/item/instrument/glockenspiel, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Guitar", /obj/item/instrument/guitar, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Harmonica", /obj/item/instrument/harmonica, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Synthethic Piano", /obj/item/instrument/piano_synth, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Recorder", /obj/item/instrument/recorder, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Saxophone", /obj/item/instrument/saxophone, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Trombone", /obj/item/instrument/trombone, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Trumpet", /obj/item/instrument/trumpet, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Violin", /obj/item/instrument/violin, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Xylophone", /obj/item/instrument/xylophone, 1, 500, "misc"),
		CASINO_PRIZE("Instrument: Golden fiddle", /obj/item/instrument/violin/golden, 1, 1500, "misc"),
		CASINO_PRIZE("Instrument: Trumpet (warning: spooky)", /obj/item/instrument/trumpet/spectral, 1, 1000, "misc"),
		CASINO_PRIZE("Instrument: Trombone (warning: spooky)", /obj/item/instrument/trombone/spectral, 1, 1000, "misc"),
		CASINO_PRIZE("Instrument: Saxophone (warning: spooky)", /obj/item/instrument/saxophone/spectral, 1, 1000, "misc"),
		CASINO_PRIZE("Instrument: Musical Moth (you monster)", /obj/item/instrument/musicalmoth, 1, 500, "misc"),
	)
	item_list["Drinks"] = list(
		CASINO_PRIZE("Redeemer's brew", /obj/item/reagent_containers/food/drinks/bottle/redeemersbrew, 1, 150, "drinks"),
		CASINO_PRIZE("Poison wine", /obj/item/reagent_containers/food/drinks/bottle/pwine, 1, 150, "drinks"),
		CASINO_PRIZE("Patron", /obj/item/reagent_containers/food/drinks/bottle/patron, 1, 150, "drinks"),
		CASINO_PRIZE("Holy water", /obj/item/reagent_containers/food/drinks/bottle/holywater, 1, 150, "drinks"),
		CASINO_PRIZE("Goldschlager", /obj/item/reagent_containers/food/drinks/bottle/goldschlager, 1, 150, "drinks"),
		CASINO_PRIZE("Champagne", /obj/item/reagent_containers/food/drinks/bottle/champagne, 1, 150, "drinks"),
		CASINO_PRIZE("Bottle of Nothing", /obj/item/reagent_containers/food/drinks/bottle/bottleofnothing, 1, 150, "drinks"),
		CASINO_PRIZE("Whiskey bliss", /obj/item/reagent_containers/food/drinks/bottle/specialwhiskey, 1, 150, "drinks"),
	)
	item_list["Pets"] = list(
		CASINO_PRIZE("Cat", /obj/item/grenade/spawnergrenade/casino, 1, 700, "pets"),
		CASINO_PRIZE("Chicken", /obj/item/grenade/spawnergrenade/casino/chicken, 1, 700, "pets"),
		CASINO_PRIZE("Cow", /obj/item/grenade/spawnergrenade/casino/cow, 1, 700, "pets"),
		CASINO_PRIZE("Corgi", /obj/item/grenade/spawnergrenade/casino/corgi, 1, 900, "pets"),
		CASINO_PRIZE("Fox", /obj/item/grenade/spawnergrenade/casino/fox, 1, 700, "pets"),
		CASINO_PRIZE("Red panda", /obj/item/grenade/spawnergrenade/casino/redpanda, 1, 1200, "pets"),
		CASINO_PRIZE("Otie", /obj/item/grenade/spawnergrenade/casino/otie, 1, 1500, "pets"),
		CASINO_PRIZE("Snake", /obj/item/grenade/spawnergrenade/casino/snake, 1, 900, "pets"),
		CASINO_PRIZE("Penguin", /obj/item/grenade/spawnergrenade/casino/penguin, 1, 900, "pets"),
		CASINO_PRIZE("Fennec", /obj/item/grenade/spawnergrenade/casino/fennec, 1, 1200, "pets"),
		CASINO_PRIZE("Bird", /obj/item/grenade/spawnergrenade/casino/goldcrest, 1, 1500, "pets"),
		CASINO_PRIZE("Capture Crystal", /obj/item/capture_crystal, 1, 3000, "pets"),
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

/obj/machinery/casino_prize_dispenser/attackby(obj/item/W as obj, mob/user as mob)
	if(currently_vending)
		if(istype(W, /obj/item/spacecasinocash))
			to_chat(user, span_warning("Please select prize on display with sufficient amount of chips."))
		else
			SStgui.update_uis(src)
			return // don't smack that machine with your 2 chips

	if(istype(W, /obj/item/spacecasinocash))
		attack_hand(user)
		return
	..()

/obj/machinery/casino_prize_dispenser/proc/pay_with_chips(var/obj/item/spacecasinocash/cashmoney, mob/user, var/price)
	//"cashmoney_:[cashmoney] user:[user] currently_vending:[currently_vending]"
	if(price > cashmoney.worth)
		to_chat(user, "[icon2html(cashmoney, user.client)] " + span_warning("That is not enough chips."))
		return 0

	if(istype(cashmoney, /obj/item/spacecasinocash))
		visible_message(span_info("\The [user] inserts some chips into \the [src]."))
		cashmoney.worth -= price

		if(cashmoney.worth <= 0)
			user.drop_from_inventory(cashmoney)
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

/obj/machinery/casino_prize_dispenser/tgui_act(action, params, datum/tgui/ui)
	if(stat & (BROKEN|NOPOWER))
		return
	if(ui.user.stat || ui.user.restrained())
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
					to_chat(ui.user, span_warning("Prize checkout error has occurred, purchase cancelled."))
					return FALSE

			if(restriction_check < 1)
				to_chat(ui.user, span_warning("[name] is restricted, this prize can't be bought."))
				return FALSE
			if(restriction_check > 1)
				item_given = TRUE

			if(price <= 0 && item_given == TRUE)
				vend(bi, ui.user)
				return TRUE

			currently_vending = bi

			if(istype(ui.user.get_active_hand(), /obj/item/spacecasinocash))
				var/obj/item/spacecasinocash/cash = ui.user.get_active_hand()
				paid = pay_with_chips(cash, ui.user, price)
			else
				to_chat(ui.user, span_warning("Payment failure: Improper payment method, please provide chips."))
				return TRUE // we set this because they shouldn't even be able to get this far, and we want the UI to update.
			if(paid)
				if(item_given == TRUE)
					vend(bi, ui.user)

				speak("Thank you for your purchase, your [bi] has been logged.")
				do_logging(currently_vending, ui.user, bi)
				. = TRUE
			else
				to_chat(ui.user, span_warning("Payment failure: unable to process payment."))

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
		O.show_message(span_npc_say(span_name("\The [src]") + " beeps, \"[message]\""),2)
	return

/obj/machinery/casino_prize_dispenser/process() //Might not need this, but just to be safe for now
	if(stat & (BROKEN|NOPOWER))
		return

#undef CASINO_PRIZE
