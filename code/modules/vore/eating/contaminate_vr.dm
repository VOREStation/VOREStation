var/list/gurgled_overlays = list(
								"green" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "green"),
								"white" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "white"),
								"black" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "black"),
								"grey" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "grey"),
								"yellow" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "yellow"),
								"red" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "red"),
								"blue" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "blue"),
								"orange" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "orange"),
								"purple" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "purple"),
								"lime" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "lime"),
								"brown" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "brown"),
								"darkred" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "darkred"),
								"cyan" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "cyan"),
								"beige" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "beige"),
								"pink" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "pink")
								)

/obj/item
	var/gurgled = FALSE
	var/cleanname
	var/cleandesc
	var/gurgled_color

/obj/item/proc/gurgle_contaminate(atom/movable/item_storage = null, contamination_flavor = "Generic", contamination_color = "green")
	if(!can_gurgle())
		return FALSE

	if(gurgled && !(gurgled_color == contamination_color))
		decontaminate()

	if(!gurgled)
		gurgled = TRUE
		gurgled_color = contamination_color
		add_overlay(gurgled_overlays[gurgled_color])
		var/list/pickfrom = contamination_flavors[contamination_flavor]
		var/gurgleflavor = pick(pickfrom)
		cleanname = src.name
		cleandesc = src.desc
		name = "[gurgleflavor] [cleanname]"
		desc = "[cleandesc] It seems to be covered in ominously foul residue and needs a wash."
//		for(var/obj/item/O in contents)			//Yeah, no. This contaminates stuff that should never be contaminated in places that should not be reached. Handle it for specific cases instead.
//			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
		return TRUE

/obj/item/proc/can_gurgle()
	if(flags & PHORONGUARD)
		return FALSE
	else if(unacidable)
		return FALSE
	else
		return TRUE

/obj/item/decontaminate() //Decontaminate the sogginess as well.
	..()
	gurgled = FALSE
	cut_overlay(gurgled_overlays[gurgled_color])
	if(cleanname)
		name = cleanname
	if(cleandesc)
		desc = cleandesc

/obj/item/clean_blood() //Make this type of contamination sink washable as well.
	..()
	if(gurgled)
		decontaminate()

/obj/structure/sink/attackby(obj/item/I, mob/user) //Wash the soggy item before it can interact with the sink.
	if(istype(I) && I.gurgled)
		to_chat(user, "<span class='notice'>You start washing [I].</span>")

		busy = TRUE
		if(do_after(user, 40, src))
			I.clean_blood()
			user.visible_message("<span class='notice'>[user] washes [I] using [src].</span>",
				"<span class='notice'>You wash [I] using [src].</span>")
		busy = FALSE
	else
		..()

//////////////
// Special handling of gurgle_contaminate
//////////////
/obj/item/weapon/card/id/gurgle_contaminate(var/atom/movable/item_storage = null)
	digest_act(item_storage) //Contamination and digestion does same thing to these
	return TRUE

/obj/item/device/pda/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/weapon/reagent_containers/food/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/weapon/storage/vore_egg/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/weapon/holder/gurgle_contaminate(var/atom/movable/item_storage = null)
	if(isbelly(loc))
		digest_act(item_storage)
		return TRUE
	return FALSE

/obj/item/organ/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/weapon/cell/gurgle_contaminate(var/atom/movable/item_storage = null)
	if(!gurgled)
	//Don't make them wet, just drain
		var/obj/item/weapon/cell/C = src
		C.charge = 0
	return TRUE

/obj/item/weapon/storage/box/gurgle_contaminate(var/atom/movable/item_storage = null)
	if((. = ..()))
		name = "soggy [cleanname]"
		desc = "This soggy box is about to fall apart any time."

//Storages that contaminate contents
/obj/item/weapon/storage/backpack/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(contents)
		for(var/obj/item/O in contents)
			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()

/obj/item/weapon/storage/belt/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(contents)
		for(var/obj/item/O in contents)
			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()

/obj/item/weapon/storage/belt/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(contents)
		for(var/obj/item/O in contents)
			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()

/obj/item/clothing/suit/storage/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(pockets)
		if(pockets.contents)
			for(var/obj/item/O in pockets.contents)
				O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()
