
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = " "
	var/base_desc = " "
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	w_class = ITEMSIZE_SMALL
	flags = OPENCONTAINER | NOCONDUCT
	unacidable = TRUE //glass doesn't dissolve in acid
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'
	description_info = "Clicking on a venomous animal (or person) with the lid closed will express their venom into the beaker!"

	var/label_text = ""

	var/list/prefill = null	//Reagents to fill the container with on New(), formatted as "reagentID" = quantity

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/item/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/storage/secure/safe,
		/obj/machinery/iv_drip,
		/obj/structure/medical_stand, //VOREStation Add,
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/mob/living/simple_mob/animal/passive/cow,
		/mob/living/simple_mob/animal/goat,
		/obj/machinery/computer/centrifuge,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/structure/frame,
		/obj/machinery/radiocarbon_spectrometer,
		/obj/machinery/portable_atmospherics/powered/reagent_distillery
		)

/obj/item/reagent_containers/glass/Initialize()
	. = ..()
	if(LAZYLEN(prefill))
		for(var/R in prefill)
			reagents.add_reagent(R,prefill[R])
		prefill = null
		update_icon()
	base_name = name
	base_desc = desc

/obj/item/reagent_containers/glass/examine(var/mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		if(reagents && reagents.reagent_list.len)
			. += span_notice("It contains [reagents.total_volume] units of liquid.")
		else
			. += span_notice("It is empty.")
		if(!is_open_container())
			. += span_notice("Airtight lid seals it completely.")

/obj/item/reagent_containers/glass/attack_self()
	..()
	if(is_open_container())
		to_chat(usr, span_notice("You put the lid on \the [src]."))
		flags ^= OPENCONTAINER
	else
		to_chat(usr, span_notice("You take the lid off \the [src]."))
		flags |= OPENCONTAINER
	update_icon()

/obj/item/reagent_containers/glass/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return	..()

	// If the container is *closed* we do snake milking!~
	if(!is_open_container() && isliving(M))
		return attempt_snake_milking(user, M)

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/reagent_containers/glass/standard_feed_mob(var/mob/user, var/mob/target)
	if(user.a_intent == I_HURT)
		return 1
	return ..()

/obj/item/reagent_containers/glass/self_feed_message(var/mob/user)
	to_chat(user, span_notice("You swallow a gulp from \the [src]."))

/obj/item/reagent_containers/glass/proc/attempt_snake_milking(mob/living/user, mob/living/target)
	var/reagent
	var/amount

	if(target.trait_injection_selected)
		reagent = target.trait_injection_selected
		amount = target.trait_injection_amount
	else if(istype(target, /mob/living/simple_mob/animal/giant_spider))
		var/mob/living/simple_mob/animal/giant_spider/spider = target
		reagent = spider.poison_type
		amount = spider.poison_per_bite

	if(!reagent || !amount)
		to_chat(user, span_warning("[target] does not have venom you can express. Open the beaker to drink from it."))
		return TRUE

	if(TIMER_COOLDOWN_RUNNING(target, COOLDOWN_VENOM_MILKING))
		user.visible_message(span_warning("[user] attempts to express venom from [target], but nothing happens."), span_warning("[target] had their venom expressed too recently, try again later."))
		return TRUE

	TIMER_COOLDOWN_START(target, COOLDOWN_VENOM_MILKING, 30 SECONDS)
	user.visible_message(span_notice("[user] expresses venom from [target]."))
	reagents.add_reagent(reagent, amount)
	return TRUE

/obj/item/reagent_containers/glass/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity || !is_open_container()) //Is the container open & are they next to whatever they're clicking?
		return 1 //If not, do nothing.
	for(var/type in can_be_placed_into) //Is it something it can be placed into?
		if(istype(target, type))
			return 1
	if(standard_dispenser_refill(user, target)) //Are they clicking a water tank/some dispenser?
		return 1
	if(standard_pour_into(user, target)) //Pouring into another beaker?
		return
	if(user.a_intent == I_HURT)
		if(standard_splash_mob(user,target))
			return 1
		if(reagents && reagents.total_volume)
			to_chat(user, span_notice("You splash the solution onto [target].")) //They are on harm intent, aka wanting to spill it.
			reagents.splash(target, reagents.total_volume)
			return 1
	..()

/obj/item/reagent_containers/glass/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
		var/tmp_label = sanitizeSafe(tgui_input_text(user, "Enter a label for [name]", "Label", label_text, MAX_NAME_LEN), MAX_NAME_LEN)
		if(length(tmp_label) > 50)
			to_chat(user, span_notice("The label can be at most 50 characters long."))
		else if(length(tmp_label) > 10)
			to_chat(user, span_notice("You set the label."))
			label_text = tmp_label
			update_name_label()
		else
			to_chat(user, span_notice("You set the label to \"[tmp_label]\"."))
			label_text = tmp_label
			update_name_label()
	if(istype(W,/obj/item/storage/bag))
		..()
	if(W && W.w_class <= w_class && (flags & OPENCONTAINER) && user.a_intent != I_HELP)
		to_chat(user, span_notice("You dip \the [W] into \the [src]."))
		reagents.touch_obj(W, reagents.total_volume)

/obj/item/reagent_containers/glass/proc/update_name_label()
	if(label_text == "")
		name = base_name
	else if(length(label_text) > 20)
		var/short_label_text = copytext(label_text, 1, 21)
		name = "[base_name] ([short_label_text]...)"
	else
		name = "[base_name] ([label_text])"
	desc = "[base_desc] It is labeled \"[label_text]\"."
	update_icon()

/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	center_of_mass = list("x" = 15,"y" = 11)
	matter = list(MAT_GLASS = 500)
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	var/rating = 1

/obj/item/reagent_containers/glass/beaker/get_rating()
	return rating

/obj/item/reagent_containers/glass/beaker/Initialize()
	. = ..()
	desc += " Can hold up to [volume] units."

/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0.1 to 20)	filling.icon_state = "[icon_state]-10"
			if(20 to 40) 	filling.icon_state = "[icon_state]-20"
			if(40 to 60)	filling.icon_state = "[icon_state]-40"
			if(60 to 80)	filling.icon_state = "[icon_state]-60"
			if(80 to 100)	filling.icon_state = "[icon_state]-80"
			if(100 to INFINITY)	filling.icon_state = "[icon_state]-100"

		filling.color = reagents.get_color()
		add_overlay(filling)

	if (!is_open_container())
		add_overlay("lid_[initial(icon_state)]")

	if (label_text)
		add_overlay("label_[initial(icon_state)]")

/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	center_of_mass = list("x" = 16,"y" = 11)
	matter = list(MAT_GLASS = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	flags = OPENCONTAINER
	rating = 3

/obj/item/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	center_of_mass = list("x" = 16,"y" = 13)
	matter = list(MAT_GLASS = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	flags = OPENCONTAINER | NOREACT

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	center_of_mass = list("x" = 16,"y" = 11)
	matter = list(MAT_GLASS = 5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	flags = OPENCONTAINER
	rating = 5

/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	center_of_mass = list("x" = 15,"y" = 9)
	matter = list(MAT_GLASS = 250)
	volume = 30
	w_class = ITEMSIZE_TINY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	flags = OPENCONTAINER

/obj/item/reagent_containers/glass/beaker/cryoxadone
	name = "beaker (cryoxadone)"
	prefill = list("cryoxadone" = 30)

/obj/item/reagent_containers/glass/beaker/sulphuric
	prefill = list("sacid" = 60)

/obj/item/reagent_containers/glass/beaker/stopperedbottle
	name = "stoppered bottle"
	desc = "A stoppered bottle for keeping beverages fresh."
	icon_state = "stopperedbottle"
	center_of_mass = list("x" = 16,"y" = 13)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	flags = OPENCONTAINER

/obj/item/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	center_of_mass = list("x" = 16,"y" = 10)
	matter = list(MAT_STEEL = 200)
	w_class = ITEMSIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	flags = OPENCONTAINER
	unacidable = FALSE
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'

/obj/item/reagent_containers/glass/bucket/attackby(var/obj/item/D, mob/user as mob)
	if(isprox(D))
		to_chat(user, "You add [D] to [src].")
		qdel(D)
		user.put_in_hands(new /obj/item/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(D.has_tool_quality(TOOL_WIRECUTTER))
		to_chat(user, span_notice("You cut a big hole in \the [src] with \the [D].  It's kinda useless as a bucket now."))
		user.put_in_hands(new /obj/item/clothing/head/helmet/bucket)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/stack/material) && D.get_material_name() == MAT_STEEL)
		var/obj/item/stack/material/M = D
		if (M.use(1))
			var/obj/item/secbot_assembly/edCLN_assembly/B = new /obj/item/secbot_assembly/edCLN_assembly
			B.loc = get_turf(src)
			to_chat(user, span_notice("You armed the robot frame."))
			if (user.get_inactive_hand()==src)
				user.remove_from_mob(src)
				user.put_in_inactive_hand(B)
			qdel(src)
		else
			to_chat(user, span_warning("You need one sheet of metal to arm the robot frame."))
	else if(istype(D, /obj/item/mop) || istype(D, /obj/item/soap) || istype(D, /obj/item/reagent_containers/glass/rag))  //VOREStation Edit - "Allows soap and rags to be used on buckets"
		if(reagents.total_volume < 1)
			to_chat(user, span_warning("\The [src] is empty!"))
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, span_notice("You wet \the [D] in \the [src]."))
			playsound(src, 'sound/effects/slosh.ogg', 25, 1)
	else
		return ..()

/obj/item/reagent_containers/glass/bucket/update_icon()
	cut_overlays()
	if (!is_open_container())
		add_overlay("lid_[initial(icon_state)]")

/obj/item/reagent_containers/glass/bucket/wood
	desc = "An old wooden bucket."
	name = "wooden bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "woodbucket"
	item_state = "woodbucket"
	center_of_mass = list("x" = 16,"y" = 8)
	matter = list(MAT_WOOD = 50)
	w_class = ITEMSIZE_LARGE
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	flags = OPENCONTAINER
	unacidable = FALSE
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/reagent_containers/glass/bucket/wood/attackby(var/obj/D, mob/user as mob)
	if(isprox(D))
		to_chat(user, "This wooden bucket doesn't play well with electronics.")
		return
	else if(istype(D, /obj/item/material/knife/machete/hatchet))
		to_chat(user, span_notice("You cut a big hole in \the [src] with \the [D].  It's kinda useless as a bucket now."))
		user.put_in_hands(new /obj/item/clothing/head/helmet/bucket/wood)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, span_warning("\The [src] is empty!"))
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, span_notice("You wet \the [D] in \the [src]."))
			playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		return ..()

/obj/item/reagent_containers/glass/cooler_bottle
	desc = "A bottle for a water-cooler."
	name = "water-cooler bottle"
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler_bottle"
	matter = list(MAT_PLASTIC = 2000)
	w_class = ITEMSIZE_NO_CONTAINER
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 2000
	slowdown = 2

	can_be_placed_into = list(
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink
		)

/obj/item/reagent_containers/glass/pint_mug
	desc = "A rustic pint mug designed for drinking ale."
	name = "pint mug"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "pint_mug"
	matter = list(MAT_WOOD = 50)
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'
