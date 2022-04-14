/obj/item/clothing/mask/chewable
	name = "chewable item master"
	desc = "If you are seeing this, ahelp it."
	icon = 'icons/inventory/face/item.dmi'
	drop_sound = 'sound/items/drop/food.ogg'
	body_parts_covered = 0

	var/type_butt = null
	var/chem_volume = 0
	var/chewtime = 0
	var/brand
	var/list/filling = list()
	var/wrapped = FALSE

/obj/item/clothing/mask/chewable/attack_self(mob/user)
	if(wrapped)
		wrapped = FALSE
		to_chat(user, span("notice", "You unwrap \the [name]."))
		playsound(src.loc, 'sound/items/drop/wrapper.ogg', 50, 1)
		slot_flags = SLOT_EARS | SLOT_MASK
		update_icon()

/obj/item/clothing/mask/chewable/update_icon()
	cut_overlays()
	if(wrapped)
		add_overlay("[initial(icon_state)]_wrapper")

/obj/item/clothing/mask/chewable/Initialize()
	. = ..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	for(var/R in filling)
		reagents.add_reagent(R, filling[R])
	if(wrapped)
		slot_flags = null

/obj/item/clothing/mask/chewable/equipped(var/mob/living/user, var/slot)
	..()
	if(slot == slot_wear_mask)
		var/mob/living/carbon/human/C = user
		if(C.check_has_mouth())
			START_PROCESSING(SSprocessing, src)
		else
			to_chat(user, span("notice", "You don't have a mouth, and can't make much use of \the [src]."))

/obj/item/clothing/mask/chewable/dropped()
	STOP_PROCESSING(SSprocessing, src)
	..()

/obj/item/clothing/mask/chewable/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/chewable/proc/chew()
	chewtime--
	if(reagents && reagents.total_volume)
		if(ishuman(loc))
			var/mob/living/carbon/human/C = loc
			if (src == C.wear_mask && C.check_has_mouth())
				reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2)
		else
			STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/chewable/process()
	chew()
	if(chewtime < 1)
		spitout()

/obj/item/clothing/mask/chewable/tobacco
	name = "wad"
	desc = "A chewy wad of tobacco. Cut in long strands and treated with syrup so it doesn't taste like an ash-tray when you stuff it into your face."
	throw_speed = 0.5
	icon_state = "chew"
	type_butt = /obj/item/trash/spitwad
	w_class = 1
	slot_flags = SLOT_EARS | SLOT_MASK
	chem_volume = 50
	chewtime = 300
	brand = "tobacco"


/obj/item/clothing/mask/chewable/proc/spitout(var/transfer_color = 1, var/no_message = 0)
	if(type_butt)
		var/obj/item/butt = new type_butt(src.loc)
		transfer_fingerprints_to(butt)
		if(transfer_color)
			butt.color = color
		if(brand)
			butt.desc += " This one is \a [brand]."
		if(ismob(loc))
			var/mob/living/M = loc
			if(!no_message)
				to_chat(M, SPAN_NOTICE("The [name] runs out of flavor."))
			if(M.wear_mask)
				M.remove_from_mob(src) //un-equip it so the overlays can update
				M.update_inv_wear_mask(0)
				if(!M.equip_to_slot_if_possible(butt, slot_wear_mask))
					M.update_inv_l_hand(0)
					M.update_inv_r_hand(1)
					M.put_in_hands(butt)
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

/obj/item/clothing/mask/chewable/tobacco/cheap
	name = "chewing tobacco"
	desc = "A chewy wad of tobacco. Cut in long strands and treated with syrup so it tastes less like an ash-tray when you stuff it into your face."
	filling = list("nicotine" = 2)

/obj/item/clothing/mask/chewable/tobacco/fine
	name = "deluxe chewing tobacco"
	desc = "A chewy wad of fine tobacco. Cut in long strands and treated with syrup so it doesn't taste like an ash-tray when you stuff it into your face."
	filling = list("nicotine" = 3)

/obj/item/clothing/mask/chewable/tobacco/nico
	name = "nicotine gum"
	desc = "A chewy wad of synthetic rubber, laced with nicotine. Possibly the least disgusting method of nicotine delivery."
	icon_state = "nic_gum"
	type_butt = /obj/item/trash/spitgum
	wrapped = TRUE

/obj/item/clothing/mask/chewable/tobacco/nico/Initialize()
	. = ..()
	reagents.add_reagent("nicotine", 2)
	color = reagents.get_color()

/obj/item/weapon/storage/chewables
	name = "box of chewing wads master"
	desc = "A generic brand of Waffle Co Wads, unflavored chews. Why do these exist?"
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	drop_sound = 'sound/items/drop/shovel.ogg'
	use_sound = 'sound/items/storage/pillbottle.ogg'
	w_class = 2
	throwforce = 2
	slot_flags = SLOT_BELT
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco = 6)

/obj/item/weapon/storage/chewables/Initialize()
	. = ..()
	make_exact_fit()

//Tobacco Tins

/obj/item/weapon/storage/chewables/tobacco
	name = "tin of Al Mamun Smooth chewing tobacco"
	desc = "Packaged and shipped straight from Kishar, popularised by the biosphere farmers of Kanondaga."
	icon_state = "chew_generic"
	item_state = "cigpacket"
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/cheap = 6)
	storage_slots = 6

/obj/item/weapon/storage/chewables/tobacco/fine
	name = "tin of Suamalie chewing tobacco"
	desc = "Once reserved for the first-class tourists of Oasis, this premium blend has been released for the public to enjoy."
	icon_state = "chew_fine"
	item_state = "Dpacket"
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/fine = 6)

/obj/item/weapon/storage/box/fancy/chewables/tobacco/nico
	name = "box of Nico-Tine gum"
	desc = "A government doctor approved brand of nicotine gum. Cut out the middleman for your addiction fix."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "chew_nico"
	item_state = "Epacket"
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/nico = 6)
	storage_slots = 6
	drop_sound = 'sound/items/drop/box.ogg'
	use_sound = 'sound/items/storage/box.ogg'
	var/open = 0
	var/open_state
	var/closed_state

/obj/item/weapon/storage/box/fancy/chewables/tobacco/nico/New()
	if(!open_state)
		open_state = "[initial(icon_state)]0"
	if(!closed_state)
		closed_state = "[initial(icon_state)]"
	..()

/obj/item/weapon/storage/box/fancy/chewables/tobacco/nico/update_icon()
	cut_overlays()
	if(open)
		icon_state = open_state
		if(contents.len >= 1)
			add_overlay("chew_nico[contents.len]")
	else
		icon_state = closed_state

/obj/item/weapon/storage/box/fancy/chewables/tobacco/nico/open(mob/user as mob)
	if(open)
		return
	open = TRUE
	if(contents.len == 0)
		icon_state = "[initial(icon_state)]_empty"
	else
		update_icon()
	..()

/obj/item/weapon/storage/box/fancy/chewables/tobacco/nico/close(mob/user as mob)
	open = FALSE
	if(contents.len == 0)
		icon_state = "[initial(icon_state)]_empty"
	else
		update_icon()
	..()

/obj/item/clothing/mask/chewable/candy
	name = "wad"
	desc = "A chewy wad of wadding material."
	throw_speed = 0.5
	icon_state = "chew"
	type_butt = /obj/item/trash/spitgum
	w_class = 1
	slot_flags = SLOT_EARS | SLOT_MASK
	chem_volume = 50
	chewtime = 300
	filling = list("sugar" = 2)

/obj/item/clothing/mask/chewable/candy/gum
	name = "chewing gum"
	desc = "A chewy wad of fine synthetic rubber and artificial flavoring. Be sure to unwrap it, genius."
	icon_state = "gum"
	item_state = "gum"
	wrapped = TRUE

/obj/item/clothing/mask/chewable/candy/gum/Initialize()
	. = ..()
	reagents.add_reagent(pick("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice"),10)
	color = reagents.get_color()
	update_icon()

/obj/item/weapon/storage/box/gum
	name = "\improper Frooty-Choos flavored gum"
	desc = "A small pack of chewing gum in various flavors."
	description_fluff = "Frooty-Choos is NanoTrasen's top-selling brand of artificially flavoured fruit-adjacent non-swallowable chew-product. This extremely specific definition places sales figures safely away from competing 'gum' brands."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "gum_pack"
	item_state = "candy"
	slot_flags = SLOT_EARS
	w_class = 1
	starts_with = list(/obj/item/clothing/mask/chewable/candy/gum = 5)
	can_hold = list(/obj/item/clothing/mask/chewable/candy/gum,
					/obj/item/trash/spitgum)
	use_sound = 'sound/items/drop/paper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	max_storage_space = 5
	foldable = null
	trash = /obj/item/trash/gumpack

/obj/item/clothing/mask/chewable/candy/lolli
	name = "lollipop"
	desc = "A simple artificially flavored sphere of sugar on a handle, colloquially known as a sucker. Allegedly one is born every minute. Make sure to unwrap it, genius."
	type_butt = /obj/item/trash/lollibutt
	icon_state = "lollipop"
	item_state = "lollipop"
	wrapped = TRUE

/obj/item/clothing/mask/chewable/candy/lolli/process()
	chew()
	if(chewtime < 1)
		spitout(0)

/obj/item/clothing/mask/chewable/candy/lolli/Initialize()
	. = ..()
	reagents.add_reagent(pick("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice"),20)
	color = reagents.get_color()
	update_icon()

/obj/item/weapon/storage/box/pocky //ADDITION 04/17/2021
	name = "\improper Totemo yoi Pocky"
	desc = "A bundle of chocolate-coated bisquit sticks."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "pockys"
	item_state = "pocky"
	w_class = 1
	starts_with = list(/obj/item/clothing/mask/chewable/candy/pocky = 8)
	can_hold = list(/obj/item/clothing/mask/chewable/candy/pocky)
	use_sound = 'sound/items/drop/paper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	max_storage_space = 8
	foldable = null
	trash = /obj/item/trash/pocky

/obj/item/clothing/mask/chewable/candy/pocky //ADDITION 04/17/2021
	name = "chocolate pocky"
	desc = "A chocolate-coated biscuit stick."
	icon_state = "pockystick"
	item_state = "pocky"
<<<<<<< HEAD
=======
	filling = list("sugar" = 2, "chocolate" = 5)
>>>>>>> d0c064a4374... Merge pull request #8532 from Sypsoti/clothingtweaks-4-22
	type_butt = null

/obj/item/clothing/mask/chewable/candy/pocky/process()
	chew()
	if(chewtime < 1)
		if(ismob(loc))
			to_chat(loc, SPAN_NOTICE("There's no more of \the [name] left!"))
		spitout(0)