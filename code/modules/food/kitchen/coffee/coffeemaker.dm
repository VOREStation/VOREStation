/* Welcome to the Coffee Maker code!
 *
 * Contains:
 *		Coffee Maker Code
 *		Coffee Cartridge Structure
 *		Individual Coffee Cartridges
 *		Random Cartridge Spawner
 *		Cartridge Boxes
 */

/*
 * The Coffee Maker
 */
/obj/machinery/coffeemaker
	name = "Coffee Maker"
	desc = "A Modello 2 Coffee Maker, the machine that provides the very life blood of any station."
	icon = 'icons/obj/coffee.dmi'
	icon_state = "coffeemaker"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 1000
	circuit = /obj/item/weapon/circuitboard/coffeemaker
	/// Base Var for the overlay system
	var/base_state
	/// Vars for the overlay system
	var/image/overlay_coffeepot
	var/image/overlay_cartridge
	/// Brewing Check
	var/brewing = FALSE
	/// The coffee cartridge to make coffee from. In the future, coffee grounds are like printer ink.
	var/obj/item/weapon/coffee_cartridge/cartridge = null
	/// The coffee pot which accepts the fresh brew
	var/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeepot/coffeepot = null
	/// These are for the Radial Menu. The Radial Menu will not show up unless both the 'coffeepot' and 'cartridge' are inserted.
	var/static/radial_examine = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_examine")
	var/static/radial_eject_pot = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "radial_eject_pot")
	var/static/radial_eject_cart = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "radial_eject_cart")
	var/static/radial_brew = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "radial_brew")


/obj/machinery/coffeemaker/Initialize()
	. = ..()
	coffeepot = new /obj/item/weapon/reagent_containers/food/drinks/glass2/coffeepot(src)
	if(!base_state)
		base_state = icon_state
	setup_overlay_vars()
	update_icon()
	default_apply_parts()

/obj/machinery/coffeemaker/proc/setup_overlay_vars()
	overlay_coffeepot = image(icon = src.icon, icon_state = "[base_state]-coffeepot")
	overlay_cartridge = image(icon = src.icon, icon_state = "[base_state]-cartridge")

/obj/machinery/coffeemaker/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 5)
		. += "[cartridge ? "[cartridge]" : "No cartridge"] is in [src]."
		. += "[coffeepot ? "[coffeepot]" : "No pot"] is in [src]."

/obj/machinery/coffeemaker/update_icon()
	..()
	cut_overlays()
	if(coffeepot)
		add_overlay(overlay_coffeepot)
	if(cartridge)
		add_overlay(overlay_cartridge)
	else
		if(!coffeepot)
			cut_overlay(overlay_coffeepot)
		if(!cartridge)
			cut_overlay(overlay_cartridge)

/obj/machinery/coffeemaker/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/weapon/coffee_cartridge) && anchored)
		if(cartridge)
			to_chat(user, "<span class='warning'>There is already a cartridge in [src].</span>")
			return
		if(!anchored)
			to_chat(user, "<span class='warning'>The machine isn't anchored.</span>")
			return
		else
			user.drop_item()
			W.loc = src
			cartridge = W
			user.visible_message("[user] inserts [cartridge] into [src].", "You insert the [cartridge] into [src].")
			playsound(src, 'sound/machines/click.ogg', 50, 1) //I know this doubles up with the 'drop' sound, but it still sounds better
		update_icon()

	if(istype(W, /obj/item/weapon/reagent_containers/food/drinks/glass2/coffeepot) && anchored)
		if(coffeepot)
			to_chat(user, "<span class='warning'>There is already a coffeepot in [src].</span>")
			return
		if(!anchored)
			to_chat(user, "<span class='warning'>The machine isn't anchored.</span>")
			return
		else
			user.drop_item()
			W.loc = src
			coffeepot = W
			user.visible_message("[user] inserts [coffeepot] into [src].", "You insert the [coffeepot] into [src].")
			playsound(src, 'sound/items/drop/glass.ogg', 50, 1) //I know this doubles up with the 'drop' sound, but it still sounds better
		update_icon()

	else if(W.is_wrench())
		if(cartridge)
			to_chat(user, "<span class='warning'>Remove cartridge first!</span>")
			return
		if(coffeepot)
			to_chat(user, "<span class='warning'>Remove coffeepot first!</span>")
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] [src] [anchored ? "to" : "from"] the ground")
		playsound(src, W.usesound, 75, 1)
	else if(default_deconstruction_screwdriver(user, W))
		return
	else if(default_deconstruction_crowbar(user, W))
		return
	else if(default_part_replacement(user, W))
		return

/obj/machinery/coffeemaker/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(brewing)
		to_chat(user, "<span class='warning'>The machine is already brewing!</span>")
		return
	interact(user)

/obj/machinery/coffeemaker/interact(mob/user as mob) // The microwave Menu //I am reasonably certain that this is not a microwave //You're right, it's a coffee maker
	if(brewing || user.incapacitated())
		return

	var/list/options = list()

	if(cartridge)
		options["eject cart"] = radial_eject_cart

	if(coffeepot)
		options["eject pot"] = radial_eject_pot

	if(isAI(user))
		if(stat & NOPOWER)
			return
		options["examine"] = radial_examine

	if(coffeepot && cartridge)
		options["brew"] = radial_brew

	var/choice
	if(length(options) < 1)
		return
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options, require_near = !issilicon(user))

	// post choice verification
	if(brewing || (isAI(user) && stat & NOPOWER) || user.incapacitated())
		return

	switch(choice)
		if("eject cart")
			ejectcart(user)
		if("eject pot")
			ejectpot(user)
		if("examine")
			examine(user)
		if("brew")
			brew(user)

/obj/machinery/coffeemaker/proc/ejectpot(mob/user)
	if(coffeepot)
		user.put_in_hands(coffeepot)
		user.visible_message("[user] removes [coffeepot] from [src].", "You remove [coffeepot] from [src].")

		coffeepot = null
		update_icon()

/obj/machinery/coffeemaker/proc/ejectcart(mob/user)
	if(cartridge)
		user.put_in_hands(cartridge)
		user.visible_message("[user] removes [cartridge] from [src].", "You remove [cartridge] from [src].")

		cartridge = null
		update_icon()

/obj/machinery/coffeemaker/proc/brew(mob/user)
	if(cartridge.charges < 1)
		to_chat(user, "<span class='warning'>Coffee cartidge empty!</span>")
		return
	if(stat & (BROKEN|NOPOWER))
		to_chat(user, "<span class='warning'>The machine isn't powered!</span>")
		return
	if(coffeepot.reagents.total_volume >= coffeepot.reagents.maximum_volume)
		to_chat(user, "<span class='warning'>The coffee pot is already full!</span>")
		return

	brewing = TRUE
	user.visible_message("[user] starts a fresh pot in [src].", "You start a fresh pot in [src].")
	update_use_power(USE_POWER_ACTIVE)

	for(var/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeepot/C in src.contents)
		for(var/obj/item/weapon/coffee_cartridge/D in src.contents)
			if(D.reagent_type == "coffee")
				C.reagents.add_reagent("coffee", 120)
			if(D.reagent_type == "decaf")
				C.reagents.add_reagent("decaf", 120)
			if(D.reagent_type == "greentea")
				C.reagents.add_reagent("greentea", 120)
			if(D.reagent_type == "chaitea")
				C.reagents.add_reagent("chaitea", 120)
			if(D.reagent_type == "chaiteadecaf")
				C.reagents.add_reagent("chaiteadecaf", 120)
			if(D.reagent_type == "hot_coco")
				C.reagents.add_reagent("hot_coco", 120)
		playsound(src, 'sound/machines/coffeemaker_brew.ogg', 50, 1)
		cartridge.charges--
	sleep(60) //NO SPAMMING >:C
	brewing = FALSE
	update_use_power(USE_POWER_IDLE)

/*
 * Coffee Cartridge: like toner, but for your coffee!
 */
/obj/item/weapon/coffee_cartridge
	name = "coffeemaker cartridge"
	desc = "A basic coffee cartridge"
	icon = 'icons/obj/coffee.dmi'
	icon_state = "cartridge"
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'
	w_class = ITEMSIZE_SMALL
	var/charges = 3
	var/reagent_type = "coffee"

/obj/item/weapon/coffee_cartridge/examine(mob/user)
	. = ..()
	if(charges)
		. += span_warning("The cartridge has [charges] portions remaining.")
	else
		. += span_warning("The cartridge has no unspent grounds remaining.")

/*
 * Individual Cartridges
 */
/obj/item/weapon/coffee_cartridge/coffee
	name = "Caffè Pancia Grassa"
	desc = "A coffee cartridge"
	icon_state = "cart_coffee"

/obj/item/weapon/coffee_cartridge/decaf
	name = "Caffè Pancia Magra (Decaf)"
	desc = "A coffee cartridge"
	icon_state = "cart_decaf"
	reagent_type = "decaf"

/obj/item/weapon/coffee_cartridge/tea
	name = "Celestial Green Tea"
	desc = "A coffee cartridge"
	icon_state = "cart_tea"
	reagent_type = "greentea"

/obj/item/weapon/coffee_cartridge/chaitea
	name = "Spiritual Spiced Chai Tea"
	desc = "A coffee cartridge"
	icon_state = "cart_chaitea"
	reagent_type = "chaitea"

/obj/item/weapon/coffee_cartridge/chaiteadecaf
	name = "Spiritual Spiced Chai Tea (Decaf)"
	desc = "A coffee cartridge"
	icon_state = "cart_decafchai"
	reagent_type = "chaiteadecaf"

/obj/item/weapon/coffee_cartridge/hotcoco
	name = "Kilimanjaro Hot Coco Blend"
	desc = "A coffee cartridge"
	icon_state = "cart_coco"
	reagent_type = "hot_coco"

/*
 * Random Cartridge Spawner
 */
/obj/random/coffee_cartridge
	name = "random coffee cartridge"
	desc = "This is a random coffee cartridge"
	icon = 'icons/obj/coffee.dmi'
	icon_state = "random_cart"

/obj/random/coffee_cartridge/item_to_spawn()
	return pick(/obj/item/weapon/coffee_cartridge/coffee,
				/obj/item/weapon/coffee_cartridge/decaf,
				/obj/item/weapon/coffee_cartridge/tea,
				/obj/item/weapon/coffee_cartridge/chaitea,
				/obj/item/weapon/coffee_cartridge/chaiteadecaf,
				/obj/item/weapon/coffee_cartridge/hotcoco)

/*
 * Cartridge Boxes
 */
/obj/item/weapon/storage/box/coffee_cartridge
	name = "box of standard coffee maker cartridges"
	desc = "A box that is filled with the standard coffee maker cartridges."
	icon_state = "coffee"
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	starts_with = list(
		/obj/item/weapon/coffee_cartridge/coffee = 4,
		/obj/item/weapon/coffee_cartridge/decaf = 2
	)

/obj/item/weapon/storage/box/assorted_coffee_cartridge
	name = "box of assorted coffee maker cartridges"
	desc = "A box that is filled with various different coffee maker cartridges."
	icon_state = "coffee"
	max_storage_space = ITEMSIZE_COST_SMALL * 6

var/list/random_weighted_coffee_cartridge = list(
	/obj/item/weapon/coffee_cartridge/tea = 4,
	/obj/item/weapon/coffee_cartridge/chaitea = 3,
	/obj/item/weapon/coffee_cartridge/chaiteadecaf = 3,
	/obj/item/weapon/coffee_cartridge/hotcoco = 2
)

/obj/item/weapon/storage/box/assorted_coffee_cartridge/Initialize()
	for(var/i in 1 to 6)
		var/type_to_spawn = pickweight(random_weighted_coffee_cartridge)
		new type_to_spawn(src)
	. = ..()