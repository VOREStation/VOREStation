
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
	flags = OPENCONTAINER
	unacidable = 1 //glass doesn't dissolve in acid

	var/label_text = ""

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
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/retaliate/goat,
		/obj/machinery/computer/centrifuge,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/structure/frame,
		/obj/machinery/radiocarbon_spectrometer,
		/obj/machinery/xenobio2/manualinjector
		)

/obj/item/weapon/reagent_containers/glass/New()
	..()
	base_name = name
	base_desc = desc

/obj/item/weapon/reagent_containers/glass/examine(var/mob/user)
	if(!..(user, 2))
		return
	if(reagents && reagents.reagent_list.len)
		user << "<span class='notice'>It contains [reagents.total_volume] units of liquid.</span>"
	else
		user << "<span class='notice'>It is empty.</span>"
	if(!is_open_container())
		user << "<span class='notice'>Airtight lid seals it completely.</span>"

/obj/item/weapon/reagent_containers/glass/attack_self()
	..()
	if(is_open_container())
		usr << "<span class = 'notice'>You put the lid on \the [src].</span>"
		flags ^= OPENCONTAINER
	else
		usr << "<span class = 'notice'>You take the lid off \the [src].</span>"
		flags |= OPENCONTAINER
	update_icon()

/obj/item/weapon/reagent_containers/glass/do_surgery(mob/living/carbon/M, mob/living/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	afterattack(M, user, 1)
	return 1

/obj/item/weapon/reagent_containers/glass/afterattack(var/obj/target, var/mob/user, var/proximity)

	if(!is_open_container() || !proximity)
		return

	for(var/type in can_be_placed_into)
		if(istype(target, type))
			return

	if(standard_splash_mob(user, target))
		return
	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return

	if(reagents && reagents.total_volume)
		user << "<span class='notice'>You splash the solution onto [target].</span>"
		reagents.splash(target, reagents.total_volume)
		return

/obj/item/weapon/reagent_containers/glass/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 50)
			user << "<span class='notice'>The label can be at most 50 characters long.</span>"
		else if(length(tmp_label) > 10)
			user << "<span class='notice'>You set the label.</span>"
			label_text = tmp_label
			update_name_label()
		else
			user << "<span class='notice'>You set the label to \"[tmp_label]\".</span>"
			label_text = tmp_label
			update_name_label()

/obj/item/weapon/reagent_containers/glass/proc/update_name_label()
	if(label_text == "")
		name = base_name
	else if(length(label_text) > 10)
		var/short_label_text = copytext(label_text, 1, 11)
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
	matter = list("glass" = 500)

/obj/item/weapon/reagent_containers/glass/beaker/New()
	..()
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
	matter = list("glass" = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	matter = list("glass" = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	flags = OPENCONTAINER | NOREACT

/obj/item/weapon/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	matter = list("glass" = 5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	matter = list("glass" = 250)
	volume = 30
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone/New()
	..()
	reagents.add_reagent("cryoxadone", 30)
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/sulphuric/New()
		..()
		reagents.add_reagent("sacid", 60)
		update_icon()

/obj/item/weapon/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	w_class = ITEMSIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	flags = OPENCONTAINER
	unacidable = 0

/obj/item/weapon/reagent_containers/glass/bucket/attackby(var/obj/D, mob/user as mob)
	if(isprox(D))
		user << "You add [D] to [src]."
		qdel(D)
		user.put_in_hands(new /obj/item/weapon/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/weapon/wirecutters))
		to_chat(user, "<span class='notice'>You cut a big hole in \the [src] with \the [D].  It's kinda useless as a bucket now.</span>")
		user.put_in_hands(new /obj/item/clothing/head/helmet/bucket)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/weapon/mop) || istype(D, /obj/item/weapon/soap) || istype(D, /obj/item/weapon/reagent_containers/glass/rag))  //VOREStation Edit - "Allows soap and rags to be used on buckets"
		if(reagents.total_volume < 1)
			user << "<span class='warning'>\The [src] is empty!</span>"
		else
			reagents.trans_to_obj(D, 5)
			user << "<span class='notice'>You wet \the [D] in \the [src].</span>"
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		return ..()

/obj/item/weapon/reagent_containers/glass/bucket/update_icon()
	overlays.Cut()
	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

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
