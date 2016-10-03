/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/weapon/storage/fancy/
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"

/obj/item/weapon/storage/fancy/update_icon(var/itemremoved = 0)
	var/total_contents = contents.len - itemremoved
	icon_state = "[icon_type]box[total_contents]"
	return

/obj/item/weapon/storage/fancy/examine(mob/user)
	if(!..(user, 1))
		return

	if(contents.len <= 0)
		user << "There are no [icon_type]s left in the box."
	else if(contents.len == 1)
		user << "There is one [icon_type] left in the box."
	else
		user << "There are [contents.len] [icon_type]s in the box."

	return

/*
 * Egg Box
 */

/obj/item/weapon/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	can_hold = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg
		)

/obj/item/weapon/storage/fancy/egg_box/New()
	..()
	for(var/i=1 to storage_slots)
		new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
	return

/*
 * Candle Box
 */

/obj/item/weapon/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT

/obj/item/weapon/storage/fancy/candle_box/New()
	..()
	for(var/i=1 to 5)
		new /obj/item/weapon/flame/candle(src)
	return

/*
 * Crayon Box
 */

/obj/item/weapon/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = 2.0
	icon_type = "crayon"
	can_hold = list(
		/obj/item/weapon/pen/crayon
	)

/obj/item/weapon/storage/fancy/crayons/New()
	..()
	new /obj/item/weapon/pen/crayon/red(src)
	new /obj/item/weapon/pen/crayon/orange(src)
	new /obj/item/weapon/pen/crayon/yellow(src)
	new /obj/item/weapon/pen/crayon/green(src)
	new /obj/item/weapon/pen/crayon/blue(src)
	new /obj/item/weapon/pen/crayon/purple(src)
	update_icon()

/obj/item/weapon/storage/fancy/crayons/update_icon()
	overlays = list() //resets list
	overlays += image('icons/obj/crayons.dmi',"crayonbox")
	for(var/obj/item/weapon/pen/crayon/crayon in contents)
		overlays += image('icons/obj/crayons.dmi',crayon.colourName)

/obj/item/weapon/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/pen/crayon))
		switch(W:colourName)
			if("mime")
				usr << "This crayon is too sad to be contained in this box."
				return
			if("rainbow")
				usr << "This crayon is too powerful to be contained in this box."
				return
	..()

////////////
//CIG PACK//
////////////
/obj/item/weapon/storage/fancy/cigarettes
	name = "\improper pack of Trans-Stellar Duty-frees"
	desc = "A ubiquitous brand of cigarettes, found in every major spacefaring corporation in the universe. As mild and flavorless as it gets."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state_slots = list(slot_r_hand_str = "cigpacket", slot_l_hand_str = "cigpacket")
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/weapon/flame/lighter)
	icon_type = "cigarette"
	var/brand = "\improper Trans-Stellar Duty-free"

/obj/item/weapon/storage/fancy/cigarettes/New()
	..()
	flags |= NOREACT
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette(src)
	create_reagents(15 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	flags |= OPENCONTAINER
	if(brand)
		for(var/obj/item/clothing/mask/smokable/cigarette/C in src)
			C.brand = brand
			C.desc += " This one is \a [brand]."

/obj/item/weapon/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/weapon/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/weapon/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_sel.selecting == O_MOUTH)
		// Find ourselves a cig. Note that we could be full of lighters.
		var/obj/item/clothing/mask/smokable/cigarette/cig = locate() in src

		if(cig == null)
			user << "<span class='notice'>Looks like the packet is out of cigarettes.</span>"
			return

		// Instead of running equip_to_slot_if_possible() we check here first,
		// to avoid dousing cig with reagents if we're not going to equip it
		if(!cig.mob_can_equip(user, slot_wear_mask))
			return

		// We call remove_from_storage first to manage the reagent transfer and
		// UI updates.
		remove_from_storage(cig, null)
		user.equip_to_slot(cig, slot_wear_mask)

		reagents.maximum_volume = 15 * contents.len
		user << "<span class='notice'>You take a cigarette out of the pack.</span>"
		update_icon()
	else
		..()

/obj/item/weapon/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	brand = "\improper Dromedary Co. cigarette"

/obj/item/weapon/storage/fancy/cigarettes/killthroat
	name = "\improper AcmeCo packet"
	desc = "A packet of six AcmeCo cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Bpacket"
	brand = "\improper Acme Co. cigarette"

//	New()
//		..()
//		fill_cigarre_package(src,list("fuel" = 15))

// New exciting ways to kill your lungs! - Earthcrusher //

/obj/item/weapon/storage/fancy/cigarettes/luckystars
	name = "\improper pack of Lucky Stars"
	desc = "A mellow blend made from synthetic, pod-grown tobacco. The commercial jingle is guaranteed to get stuck in your head."
	icon_state = "LSpacket"
	brand = "\improper Lucky Star"

/obj/item/weapon/storage/fancy/cigarettes/jerichos
	name = "\improper pack of Jerichos"
	desc = "Typically seen dangling from the lips of Martian soldiers and border world hustlers. Tastes like hickory smoke, feels like warm liquid death down your lungs."
	icon_state = "Jpacket"
	brand = "\improper Jericho"

/obj/item/weapon/storage/fancy/cigarettes/menthols
	name = "\improper pack of Temperamento Menthols"
	desc = "With a sharp and natural organic menthol flavor, these Temperamentos are a favorite of NDV crews. Hardly anyone knows they make 'em in non-menthol!"
	icon_state = "TMpacket"
	brand = "\improper Temperamento Menthol"

/obj/item/weapon/storage/fancy/cigarettes/carcinomas
	name = "\improper pack of Carcinoma Angels"
	desc = "This unknown brand was slated for the chopping block, until they were publicly endorsed by an old Earthling gonzo journalist. The rest is history. They sell a variety for cats, too."
	icon_state = "CApacket"
	brand = "\improper Carcinoma Angel"

/obj/item/weapon/storage/fancy/cigarettes/professionals
	name = "\improper pack of Professional 120s"
	desc = "Let's face it - if you're smoking these, you're either trying to look upper-class or you're 80 years old. That's the only excuse. They are, however, very good quality."
	icon_state = "P100packet"
	brand = "\improper Professional 120"

/obj/item/weapon/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar)
	icon_type = "cigar"

/obj/item/weapon/storage/fancy/cigar/New()
	..()
	flags |= NOREACT
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/cigar(src)
	create_reagents(15 * storage_slots)

/obj/item/weapon/storage/fancy/cigar/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/weapon/storage/fancy/cigar/remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
		if(!istype(C)) return
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
		..()

/*
 * Vial Box
 */

/obj/item/weapon/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6
	can_hold = list(/obj/item/weapon/reagent_containers/glass/beaker/vial)

/obj/item/weapon/storage/fancy/vials/New()
	..()
	for(var/i=1 to 6)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial(src)
	return

/obj/item/weapon/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")
	max_w_class = 2
	can_hold = list(/obj/item/weapon/reagent_containers/glass/beaker/vial)
	max_storage_space = 12 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/weapon/storage/lockbox/vials/New()
	..()
	update_icon()

/obj/item/weapon/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = contents.len - itemremoved
	icon_state = "vialbox[total_contents]"
	overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/weapon/storage/lockbox/vials/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	update_icon()
