/obj/item/stack/animalhide
	name = "hide"
	desc = "The hide of some creature."
	description_info = "Use something <b><font color='red'>sharp</font></b>, like a knife, to scrape the hairs/feathers/etc off this hide to prepare it for tanning."
	icon_state = "sheet-hide"
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	amount = 1
	max_amount = 20
	stacktype = "hide"
	no_variants = TRUE
// This needs to be very clearly documented for players. Whether it should stay in the main description is up for debate.
/obj/item/stack/animalhide/examine(var/mob/user)
	. = ..()
	. += description_info

/obj/item/stack/animalhide/human
	name = "skin"
	desc = "The by-product of sapient farming."
	singular_name = "skin piece"
	icon_state = "sheet-hide"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'
	stacktype = "hide-human"

/obj/item/stack/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"
	stacktype = "hide-corgi"

/obj/item/stack/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon_state = "sheet-cat"
	stacktype = "hide-cat"

/obj/item/stack/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"
	stacktype = "hide-monkey"

/obj/item/stack/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"
	stacktype = "hide-lizard"

/obj/item/stack/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon_state = "sheet-xeno"
	stacktype = "hide-xeno"

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien chitin piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	stacktype = "hide-chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"

//Step one - dehairing.
/obj/item/stack/animalhide/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(has_edge(W) || is_sharp(W))
		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		user.visible_message("<span class='notice'>\The [user] starts cutting hair off \the [src]</span>", "<span class='notice'>You start cutting the hair off \the [src]</span>", "You hear the sound of a knife rubbing against flesh")
		var/scraped = 0
		while(amount > 0 && do_after(user, 2.5 SECONDS)) // 2.5s per hide
			//Try locating an exisitng stack on the tile and add to there if possible
			var/obj/item/stack/hairlesshide/H = null
			for(var/obj/item/stack/hairlesshide/HS in user.loc) // Could be scraping something inside a locker, hence the .loc, not get_turf
				if(HS.amount < HS.max_amount)
					H = HS
					break
			
			 // Either we found a valid stack, in which case increment amount,
			 // Or we need to make a new stack
			if(istype(H))
				H.amount++
			else
				H = new /obj/item/stack/hairlesshide(user.loc)

			// Increment the amount
			src.use(1)
			scraped++
		
		if(scraped)
			to_chat(user, SPAN_NOTICE("You scrape the hair off [scraped] hide\s."))
	else
		..()


//Step two - washing..... it's actually in washing machine code, and ere.

/obj/item/stack/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	description_info = "Get it <b><font color='blue'>wet</font></b> to continue tanning this into leather.<br>\
					You could set it in a river, wash it with a sink, or just splash water on it with a bucket."
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"
	no_variants = FALSE
	max_amount = 20
	stacktype = "hairlesshide"

/obj/item/stack/hairlesshide/examine(var/mob/user)
	. = ..()
	. += description_info

/obj/item/stack/hairlesshide/water_act(var/wateramount)
	. = ..()
	wateramount = min(amount, round(wateramount))
	for(var/i in 1 to wateramount)
		var/obj/item/stack/wetleather/H = null
		for(var/obj/item/stack/wetleather/HS in get_turf(src)) // Doesn't have a user, can't just use their loc
			if(HS.amount < HS.max_amount)
				H = HS
				break
			
		 // Either we found a valid stack, in which case increment amount,
		 // Or we need to make a new stack
		if(istype(H))
			H.amount++
		else
			H = new /obj/item/stack/wetleather(get_turf(src))

		// Increment the amount
		src.use(1)

/obj/item/stack/hairlesshide/proc/rapidcure(var/stacknum = 1)
	stacknum = min(stacknum, amount)

	while(stacknum)
		var/obj/item/stack/wetleather/I = new /obj/item/stack/wetleather(get_turf(src))

		if(istype(I))
			I.dry()

		use(1)
		stacknum -= 1

//Step three - drying
/obj/item/stack/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	description_info = "To finish tanning the leather, you need to dry it. \
						You could place it under a <b><font color='red'>fire</font></b>, \
						put it in a <b><font color='blue'>drying rack</font></b>, \
						or build a <b><font color='brown'>tanning rack</font></b> from steel or wooden boards."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying
	no_variants = FALSE
	max_amount = 20
	stacktype = "wetleather"

	var/dry_type = /obj/item/stack/material/leather

/obj/item/stack/wetleather/examine(var/mob/user)
	. = ..()
	. += description_info
	. += "\The [src] is [get_dryness_text()]."

/obj/item/stack/wetleather/proc/get_dryness_text()
	if(wetness > 20)
		return "wet"
	if(wetness > 10)
		return "damp"
	if(wetness)
		return "almost dry"
	return "dry"

/obj/item/stack/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			dry()

/obj/item/stack/wetleather/proc/dry()
	var/obj/item/stack/material/leather/L = new(src.loc)
	L.amount = amount
	use(amount)
	return L

/obj/item/stack/wetleather/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	. = ..()
	if(.) // If it transfers any, do a weighted average of the wetness
		var/obj/item/stack/wetleather/W = S
		var/oldamt = W.amount - .
		W.wetness = round(((oldamt * W.wetness) + (. * wetness)) / W.amount)



/obj/structure/tanning_rack
	name = "tanning rack"
	desc = "A rack used to stretch leather out and hold it taut during the tanning process."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"

	var/obj/item/stack/wetleather/drying = null

/obj/structure/tanning_rack/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src) // SSObj fires ~every 2s , starting from wetness 30 takes ~1m

/obj/structure/tanning_rack/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/tanning_rack/process()
	if(drying && drying.wetness)
		drying.wetness = max(drying.wetness - 1, 0)
		if(!drying.wetness)
			visible_message("The [drying] is dry!")
			update_icon()

/obj/structure/tanning_rack/examine(var/mob/user)
	. = ..()
	if(drying)
		. += "\The [drying] is [drying.get_dryness_text()]."

/obj/structure/tanning_rack/update_icon()
	overlays.Cut()
	if(drying)
		var/image/I
		if(drying.wetness)
			I = image(icon, "leather_wet")
		else
			I = image(icon, "leather_dry")
		add_overlay(I)

/obj/structure/tanning_rack/attackby(var/atom/A, var/mob/user)
	if(istype(A, /obj/item/stack/wetleather))
		if(!drying) // If not drying anything, start drying the thing
			if(user.unEquip(A, target = src))
				drying = A
		else // Drying something, add if possible
			var/obj/item/stack/wetleather/W = A
			W.transfer_to(drying, W.amount, TRUE)
		update_icon()
		return TRUE
	return ..()

/obj/structure/tanning_rack/attack_hand(var/mob/user)
	if(drying)
		var/obj/item/stack/S = drying
		if(!drying.wetness) // If it's dry, make a stack of dry leather and prepare to put that in their hands
			var/obj/item/stack/material/leather/L = new(src)
			L.amount = drying.amount
			drying.use(drying.amount)
			S = L

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!H.put_in_any_hand_if_possible(S))
				S.forceMove(get_turf(src))
		else
			S.forceMove(get_turf(src))
		drying = null
		update_icon()

/obj/structure/tanning_rack/attack_robot(var/mob/user)
	attack_hand(user) // That has checks to 