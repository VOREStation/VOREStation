/obj/machinery/item_bank
	name = "electronic lockbox"
	desc = "A place to store things you might want later!"
	icon = 'icons/obj/stationobjs_vr.dmi'
	icon_state = "item_bank"
	idle_power_usage = 1
	active_power_usage = 5
	anchored = TRUE
	density = FALSE
	var/busy_bank = FALSE
	var/static/list/item_takers = list()

/obj/machinery/item_bank/proc/persist_item_savefile_path(mob/user)
	return "data/player_saves/[copytext(user.ckey, 1, 2)]/[user.ckey]/persist_item.sav"

/obj/machinery/item_bank/proc/persist_item_savefile_save(mob/user, obj/item/O)
	if(IsGuestKey(user.key))
		return 0

	var/savefile/F = new /savefile(src.persist_item_savefile_path(user))

	F["persist item"] << O.type
	F["persist name"] << initial(O.name)

	return 1

/obj/machinery/item_bank/proc/persist_item_savefile_load(mob/user, thing)
	if (IsGuestKey(user.key))
		return 0

	var/path = src.persist_item_savefile_path(user)

	if (!fexists(path))
		return 0

	var/savefile/F = new /savefile(path)

	if(!F) return 0

	var/persist_item
	F["persist item"] >> persist_item

	if (isnull(persist_item) || !ispath(persist_item))
		fdel(path)
		tgui_alert_async(user, "An item could not be retrieved.")
		return 0
	if(thing == "type")
		return persist_item
	if(thing == "name")
		var/persist_name
		F["persist name"] >> persist_name
		return persist_name


/obj/machinery/item_bank/Initialize()
	. = ..()

/obj/machinery/item_bank/attack_hand(mob/living/user)
	. = ..()
	if(!ishuman(user))
		return
	if(istype(user) && Adjacent(user))
		if(inoperable() || panel_open)
			to_chat(user, "<span class='warning'>\The [src] seems to be nonfunctional...</span>")
		else
			start_using(user)

/obj/machinery/item_bank/proc/start_using(mob/living/user)
	if(!ishuman(user))
		return
	if(busy_bank)
		to_chat(user, "<span class='warning'>\The [src] is already in use.</span>")
		return
	busy_bank = TRUE
	var/I = persist_item_savefile_load(user, "type")
	var/Iname = persist_item_savefile_load(user, "name")
	var/choice = tgui_alert(user, "What would you like to do [src]?", "[src]", list("Check contents", "Retrieve item", "Info", "Cancel"), timeout = 10 SECONDS)
	if(!choice || choice == "Cancel" || !Adjacent(user) || inoperable() || panel_open)
		busy_bank = FALSE
		return
	else if(choice == "Check contents" && I)
		to_chat(user, "<span class='notice'>\The [src] has \the [Iname] for you!</span>")
		busy_bank = FALSE
	else if(choice == "Retrieve item" && I)
		if(user.hands_are_full())
			to_chat(user,"<span class='notice'>Your hands are full!</span>")
			busy_bank = FALSE
			return
		if(user.ckey in item_takers)
			to_chat(user, "<span class='warning'>You have already taken something out of \the [src] this shift.</span>")
			busy_bank = FALSE
			return
		choice = tgui_alert(user, "If you remove this item from the bank, it will be unable to be stored again. Do you still want to remove it?", "[src]", list("No", "Yes"), timeout = 10 SECONDS)
		icon_state = "item_bank_o"
		if(!choice || choice == "No" || !Adjacent(user) || inoperable() || panel_open)
			busy_bank = FALSE
			icon_state = "item_bank"
			return
		else if(!do_after(user, 10 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE) || inoperable())
			busy_bank = FALSE
			icon_state = "item_bank"
			return
		var/obj/N = new I(get_turf(src))
		log_admin("[key_name_admin(user)] retrieved [N] from the item bank.")
		visible_message("<span class='notice'>\The [src] dispenses the [N] to \the [user].</span>")
		user.put_in_hands(N)
		N.persist_storable = FALSE
		var/path = src.persist_item_savefile_path(user)
		var/savefile/F = new /savefile(src.persist_item_savefile_path(user))
		F["persist item"] << null
		F["persist name"] << null
		fdel(path)
		item_takers += user.ckey
		busy_bank = FALSE
		icon_state = "item_bank"
	else if(choice == "Info")
		to_chat(user, "<span class='notice'>\The [src] can store a single item for you between shifts! Anything that has been retrieved from the bank cannot be stored again in the same shift. Anyone can withdraw from the bank one time per shift. Some items are not able to be accepted by the bank.</span>")
		busy_bank = FALSE
		return
	else if(!I)
		to_chat(user, "<span class='warning'>\The [src] doesn't seem to have anything for you...</span>")
		busy_bank = FALSE

/obj/machinery/item_bank/attackby(obj/item/O, mob/living/user)
	if(!ishuman(user))
		return
	if(busy_bank)
		to_chat(user, "<span class='warning'>\The [src] is already in use.</span>")
		return
	busy_bank = TRUE
	var/I = persist_item_savefile_load(user, "type")
	if(!istool(O) && O.persist_storable)
		if(ispath(I))
			to_chat(user, "<span class='warning'>You cannot store \the [O]. You already have something stored.</span>")
			busy_bank = FALSE
			return
		var/choice = tgui_alert(user, "If you store \the [O], anything it contains may be lost to \the [src]. Are you sure?", "[src]", list("Store", "Cancel"), timeout = 10 SECONDS)
		if(!choice || choice == "Cancel" || !Adjacent(user) || inoperable() || panel_open)
			busy_bank = FALSE
			return
		for(var/obj/check in O.contents)
			if(!check.persist_storable)
				to_chat(user, "<span class='warning'>\The [src] buzzes. \The [O] contains [check], which cannot be stored. Please remove this item before attempting to store \the [O]. As a reminder, any contents of \the [O] will be lost if you store it with contents.</span>")
				busy_bank = FALSE
				return
		user.visible_message("<span class='notice'>\The [user] begins storing \the [O] in \the [src].</span>","<span class='notice'>You begin storing \the [O] in \the [src].</span>")
		icon_state = "item_bank_o"
		if(!do_after(user, 10 SECONDS, src, exclusive = TASK_ALL_EXCLUSIVE) || inoperable())
			busy_bank = FALSE
			icon_state = "item_bank"
			return
		src.persist_item_savefile_save(user, O)
		user.visible_message("<span class='notice'>\The [user] stores \the [O] in \the [src].</span>","<span class='notice'>You stored \the [O] in \the [src].</span>")
		log_admin("[key_name_admin(user)] stored [O] in the item bank.")
		qdel(O)
		busy_bank = FALSE
		icon_state = "item_bank"
	else
		to_chat(user, "<span class='warning'>You cannot store \the [O]. \The [src] either does not accept that, or it has already been retrieved from storage this shift.</span>")
		busy_bank = FALSE

/////STORABLE ITEMS AND ALL THAT JAZZ/////
//I am only really intending this to be used for single items. Mostly stuff you got right now, but can't/don't want to use right now.
//It is not at all intended to be a thing that just lets you hold on to stuff forever, but just until it's the right time to use it.

/obj

	var/persist_storable = TRUE		//If this is true, this item can be stored in the item bank.
									//This is automatically set to false when an item is removed from storage

/////LIST OF STUFF WE DON'T WANT PEOPLE STORING/////

/obj/item/pda
	persist_storable = FALSE
/obj/item/communicator
	persist_storable = FALSE
/obj/item/card
	persist_storable = FALSE
/obj/item/holder
	persist_storable = FALSE
/obj/item/radio
	persist_storable = FALSE
/obj/item/encryptionkey
	persist_storable = FALSE
/obj/item/storage			//There are lots of things that have stuff that we may not want people to just have. And this is mostly intended for a single thing.
	persist_storable = FALSE		//And it would be annoying to go through and consider all of them, so default to disabled.
/obj/item/storage/backpack	//But we can enable some where it makes sense. Backpacks and their variants basically never start with anything in them, as an example.
	persist_storable = TRUE
/obj/item/reagent_containers/hypospray/vial
	persist_storable = FALSE
/obj/item/cmo_disk_holder
	persist_storable = FALSE
/obj/item/defib_kit/compact/combat
	persist_storable = FALSE
/obj/item/clothing/glasses/welding/superior
	persist_storable = FALSE
/obj/item/clothing/shoes/magboots/adv
	persist_storable = FALSE
/obj/item/rig
	persist_storable = FALSE
/obj/item/clothing/head/helmet/space/void
	persist_storable = FALSE
/obj/item/clothing/suit/space/void
	persist_storable = FALSE
/obj/item/grab
	persist_storable = FALSE
/obj/item/grenade
	persist_storable = FALSE
/obj/item/hand_tele
	persist_storable = FALSE
/obj/item/paper
	persist_storable = FALSE
/obj/item/backup_implanter
	persist_storable = FALSE
/obj/item/disk/nuclear
	persist_storable = FALSE
/obj/item/gun/energy/locked		//These are guns with security measures on them, so let's say the box won't let you put them in there.
	persist_storable = FALSE			//(otherwise explo will just put their locker/vendor guns into it every round)
/obj/item/retail_scanner
	persist_storable = FALSE
/obj/item/telecube
	persist_storable = FALSE
/obj/item/reagent_containers/glass/bottle/adminordrazine
	persist_storable = FALSE
/obj/item/gun/energy/sizegun/admin
	persist_storable = FALSE
/obj/item/gun/energy/sizegun/abductor
	persist_storable = FALSE
/obj/item/stack
	persist_storable = FALSE
/obj/item/book
	persist_storable = FALSE
/obj/item/melee/cursedblade
	persist_storable = FALSE
/obj/item/circuitboard/mecha/imperion
	persist_storable = FALSE
/obj/item/paicard
	persist_storable = FALSE
/obj/item/organ
	persist_storable = FALSE
/obj/item/soulstone
	persist_storable = FALSE
/obj/item/aicard
	persist_storable = FALSE
/obj/item/mmi
	persist_storable = FALSE
/obj/item/seeds
	persist_storable = FALSE
/obj/item/reagent_containers/food/snacks/grown
	persist_storable = FALSE
/obj/item/stock_parts
	persist_storable = FALSE
/obj/item/rcd
	persist_storable = FALSE
