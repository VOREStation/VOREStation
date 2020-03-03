
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/glass
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
	unacidable = 1 //glass doesn't dissolve in acid

	var/label_text = ""

	var/list/prefill = null	//Reagents to fill the container with on New(), formatted as "reagentID" = quantity

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/weapon/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/item/weapon/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/weapon/storage/secure/safe,
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

/obj/item/weapon/reagent_containers/glass/Initialize()
	. = ..()
	if(LAZYLEN(prefill))
		for(var/R in prefill)
			reagents.add_reagent(R,prefill[R])
		prefill = null
		update_icon()
	base_name = name
	base_desc = desc

/obj/item/weapon/reagent_containers/glass/examine(var/mob/user)
	if(!..(user, 2))
		return
	if(reagents && reagents.reagent_list.len)
		to_chat(user, "<span class='notice'>It contains [reagents.total_volume] units of liquid.</span>")
	else
		to_chat(user, "<span class='notice'>It is empty.</span>")
	if(!is_open_container())
		to_chat(user, "<span class='notice'>Airtight lid seals it completely.</span>")

/obj/item/weapon/reagent_containers/glass/attack_self()
	..()
	if(is_open_container())
		to_chat(usr, "<span class = 'notice'>You put the lid on \the [src].</span>")
		flags ^= OPENCONTAINER
	else
		to_chat(usr, "<span class = 'notice'>You take the lid off \the [src].</span>")
		flags |= OPENCONTAINER
	update_icon()

/obj/item/weapon/reagent_containers/glass/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return	..()

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/weapon/reagent_containers/glass/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src] first.</span>")
		return 1
	if(user.a_intent == I_HURT)
		return 1
	return ..()

/obj/item/weapon/reagent_containers/glass/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")

/obj/item/weapon/reagent_containers/glass/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!is_open_container() || !proximity) //Is the container open & are they next to whatever they're clicking?
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
			to_chat(user, "<span class='notice'>You splash the solution onto [target].</span>") //They are on harm intent, aka wanting to spill it.
			reagents.splash(target, reagents.total_volume)
			return 1
	..()

/obj/item/weapon/reagent_containers/glass/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 50)
			to_chat(user, "<span class='notice'>The label can be at most 50 characters long.</span>")
		else if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>You set the label.</span>")
			label_text = tmp_label
			update_name_label()
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
	if(istype(W,/obj/item/weapon/storage/bag))
		..()
	if(W && W.w_class <= w_class && (flags & OPENCONTAINER))
		to_chat(user, "<span class='notice'>You dip \the [W] into \the [src].</span>")
		reagents.touch_obj(W, reagents.total_volume)

/obj/item/weapon/reagent_containers/glass/proc/update_name_label()
	if(label_text == "")
		name = base_name
	else if(length(label_text) > 20)
		var/short_label_text = copytext(label_text, 1, 21)
		name = "[base_name] ([short_label_text]...)"
	else
		name = "[base_name] ([label_text])"
	desc = "[base_desc] It is labeled \"[label_text]\"."

/obj/item/weapon/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	center_of_mass = list("x" = 15,"y" = 11)
	matter = list("glass" = 500)

/obj/item/weapon/reagent_containers/glass/beaker/Initialize()
	. = ..()
	desc += " Can hold up to [volume] units."

/obj/item/weapon/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]-10"
			if(10 to 24) 	filling.icon_state = "[icon_state]10"
			if(25 to 49)	filling.icon_state = "[icon_state]25"
			if(50 to 74)	filling.icon_state = "[icon_state]50"
			if(75 to 79)	filling.icon_state = "[icon_state]75"
			if(80 to 90)	filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		filling.color = reagents.get_color()
		overlays += filling

	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/weapon/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	center_of_mass = list("x" = 16,"y" = 11)
	matter = list("glass" = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	center_of_mass = list("x" = 16,"y" = 13)
	matter = list("glass" = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	flags = OPENCONTAINER | NOREACT

/obj/item/weapon/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	center_of_mass = list("x" = 16,"y" = 11)
	matter = list("glass" = 5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	center_of_mass = list("x" = 15,"y" = 9)
	matter = list("glass" = 250)
	volume = 30
	w_class = ITEMSIZE_TINY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone
	prefill = list("cryoxadone" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/sulphuric
	prefill = list("sacid" = 60)

/obj/item/weapon/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	center_of_mass = list("x" = 16,"y" = 10)
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	w_class = ITEMSIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	flags = OPENCONTAINER
	unacidable = 0

/obj/item/weapon/reagent_containers/glass/bucket/attackby(var/obj/item/D, mob/user as mob)
	if(isprox(D))
		to_chat(user, "You add [D] to [src].")
		qdel(D)
		user.put_in_hands(new /obj/item/weapon/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(D.is_wirecutter())
		to_chat(user, "<span class='notice'>You cut a big hole in \the [src] with \the [D].  It's kinda useless as a bucket now.</span>")
		user.put_in_hands(new /obj/item/clothing/head/helmet/bucket)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/stack/material) && D.get_material_name() == DEFAULT_WALL_MATERIAL)
		var/obj/item/stack/material/M = D
		if (M.use(1))
			var/obj/item/weapon/secbot_assembly/edCLN_assembly/B = new /obj/item/weapon/secbot_assembly/edCLN_assembly
			B.loc = get_turf(src)
			to_chat(user, "<span class='notice'>You armed the robot frame.</span>")
			if (user.get_inactive_hand()==src)
				user.remove_from_mob(src)
				user.put_in_inactive_hand(B)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need one sheet of metal to arm the robot frame.</span>")
	else if(istype(D, /obj/item/weapon/mop) || istype(D, /obj/item/weapon/soap) || istype(D, /obj/item/weapon/reagent_containers/glass/rag))  //VOREStation Edit - "Allows soap and rags to be used on buckets"
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, "<span class='notice'>You wet \the [D] in \the [src].</span>")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
	else
		return ..()

/obj/item/weapon/reagent_containers/glass/bucket/update_icon()
	overlays.Cut()
	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

obj/item/weapon/reagent_containers/glass/bucket/wood
	desc = "An old wooden bucket."
	name = "wooden bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "woodbucket"
	item_state = "woodbucket"
	center_of_mass = list("x" = 16,"y" = 8)
	matter = list("wood" = 50)
	w_class = ITEMSIZE_LARGE
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	flags = OPENCONTAINER
	unacidable = 0

/obj/item/weapon/reagent_containers/glass/bucket/wood/attackby(var/obj/D, mob/user as mob)
	if(isprox(D))
		to_chat(user, "This wooden bucket doesn't play well with electronics.")
		return
	else if(istype(D, /obj/item/weapon/material/knife/machete/hatchet))
		to_chat(user, "<span class='notice'>You cut a big hole in \the [src] with \the [D].  It's kinda useless as a bucket now.</span>")
		user.put_in_hands(new /obj/item/clothing/head/helmet/bucket/wood)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/weapon/mop))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, "<span class='notice'>You wet \the [D] in \the [src].</span>")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		return ..()

/obj/item/weapon/reagent_containers/glass/cooler_bottle
	desc = "A bottle for a water-cooler."
	name = "water-cooler bottle"
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler_bottle"
	matter = list("glass" = 2000)
	w_class = ITEMSIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
