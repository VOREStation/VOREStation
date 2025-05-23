/obj/item/stack/animalhide
	name = "hide"
	desc = "The hide of some creature."
	description_info = "Use something " + span_bold(span_red("sharp")) + ", like a knife, to scrape the hairs/feathers/etc off this hide to prepare it for tanning."
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

//Step one - dehairing.
/obj/item/stack/animalhide/attackby(obj/item/W as obj, mob/user as mob)
	if(has_edge(W) || is_sharp(W))
		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		user.visible_message(span_infoplain(span_bold("\The [user]") + " starts cutting hair off \the [src]"), span_notice("You start cutting the hair off \the [src]"), "You hear the sound of a knife rubbing against flesh")
		var/scraped = 0
		while(amount > 0 && do_after(user, 2.5 SECONDS, user))
			//Try locating an exisitng stack on the tile and add to there if possible
			var/obj/item/stack/hairlesshide/H = null
			for(var/obj/item/stack/hairlesshide/HS in user.loc) // Could be scraping something inside a locker, hence the .loc, not get_turf
				if(HS.get_amount() < HS.max_amount)
					H = HS
					break

			// Either we found a valid stack, in which case increment amount,
			// Or we need to make a new stack
			if(istype(H))
				H.add(1)
			else
				H = new /obj/item/stack/hairlesshide(user.loc)

			// Increment the amount
			src.use(1)
			scraped++

		if(scraped)
			to_chat(user, span_notice("You scrape the hair off [scraped] hide\s."))
	else
		..()

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
