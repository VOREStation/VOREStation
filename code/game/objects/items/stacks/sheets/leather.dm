/obj/item/stack/animalhide
	name = "hide"
	desc = "The hide of some creature."
	icon_state = "sheet-hide"
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	amount = 1
	stacktype = "hide"
	no_variants = TRUE

	var/process_type = /obj/item/stack/hairlesshide

/obj/item/stack/animalhide/human
	name = "skin"
	desc = "The by-product of sapient farming."
	singular_name = "skin piece"
	icon_state = "sheet-hide"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'
	amount = 1
	stacktype = "hide-human"

/obj/item/stack/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"
	amount = 1
	stacktype = "hide-corgi"

/obj/item/stack/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon_state = "sheet-cat"
	amount = 1
	stacktype = "hide-cat"

/obj/item/stack/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"
	amount = 1
	stacktype = "hide-monkey"

/obj/item/stack/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"
	amount = 1
	stacktype = "hide-lizard"

/obj/item/stack/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon_state = "sheet-xeno"
	amount = 1
	stacktype = "hide-xeno"

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien chitin piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	amount = 1
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
		if(do_after(user,50))
			to_chat(user, "<span class='notice'>You cut the hair from this [src.singular_name]</span>")
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/hairlesshide/HS in user.loc)
				if(HS.amount < 50 && istype(HS, process_type))
					HS.amount++
					src.use(1)
					return
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/HS = new process_type(usr.loc)
			if(istype(HS))
				HS.amount = 1
			src.use(1)
	else
		..()


//Step two - washing..... it's actually in washing machine code, and ere.

/obj/item/stack/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"
	no_variants = FALSE
	amount = 1
	stacktype = "hairlesshide"
	var/cleaning = FALSE	// Can we be water_acted, or are we busy? To prevent accidental hide duplication and the collapse of causality.

	var/wet_type = /obj/item/stack/wetleather

/obj/item/stack/hairlesshide/water_act(var/wateramount)
	..()
	cleaning = TRUE
	while(amount > 0 && wateramount > 0)
		use(1)
		wateramount--
		new wet_type(get_turf(src))
	cleaning = FALSE

	return

/obj/item/stack/hairlesshide/proc/rapidcure(var/stacknum = 1)
	stacknum = min(stacknum, amount)

	while(stacknum)
		var/obj/item/stack/wetleather/I = new wet_type(get_turf(src))

		if(istype(I))
			I.dry()

		use(1)
		stacknum -= 1

//Step three - drying
/obj/item/stack/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying
	no_variants = FALSE
	amount = 1
	stacktype = "wetleather"

	var/dry_type = /obj/item/stack/material/leather

/obj/item/stack/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			dry()

/obj/item/stack/wetleather/proc/dry()
	//Try locating an exisitng stack on the tile and add to there if possible
	for(var/obj/item/stack/material/leather/HS in src.loc)
		if(HS.amount < 50)
			HS.amount++
			wetness = initial(wetness)
			src.use(1)
			return
	//If it gets to here it means it did not find a suitable stack on the tile.
	var/obj/item/stack/HS = new dry_type(src.loc)

	if(istype(HS))
		HS.amount = 1
	wetness = initial(wetness)
	src.use(1)
