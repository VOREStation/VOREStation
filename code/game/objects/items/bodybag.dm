//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/closets/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = ITEMSIZE_SMALL

/obj/item/bodybag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
	R.add_fingerprint(user)
	qdel(src)


/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "This box contains body bags."
	icon_state = "bodybags"
	starts_with = list(/obj/item/bodybag = 7)

/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/closets/bodybag.dmi'
	closet_appearance = null
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	density = FALSE
	storage_capacity = (MOB_MEDIUM * 2) - 1
	var/contains_body = 0

/obj/structure/closet/body_bag/attackby(var/obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/pen))
		var/t = tgui_input_text(user, "What would you like the label to be?", text("[]", src.name), null, MAX_NAME_LEN	)
		if (user.get_active_hand() != W)
			return
		if (!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = "body bag - "
			src.name += t
			add_overlay("bodybag_label")
		else
			src.name = "body bag"
	//..() //Doesn't need to run the parent. Since when can fucking bodybags be welded shut? -Agouri
		return
	else if(W.has_tool_quality(TOOL_WIRECUTTER))
		to_chat(user, "You cut the tag off the bodybag")
		src.name = "body bag"
		cut_overlays()
		return

/obj/structure/closet/body_bag/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/body_bag/close()
	if(..())
		density = FALSE
		return 1
	return 0

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return 0
		if(opened)	return 0
		if(contents.len)	return 0
		visible_message("[usr] folds up the [src.name]")
		var/folded = new item_path(get_turf(src))
		spawn(0)
			qdel(src)
		return folded

/obj/structure/closet/body_bag/relaymove(mob/user,direction)
	if(src.loc != get_turf(src))
		src.loc.relaymove(user,direction)
	else
		..()

/obj/structure/closet/body_bag/proc/get_occupants()
	var/list/occupants = list()
	for(var/mob/living/carbon/human/H in contents)
		occupants += H
	return occupants

/obj/structure/closet/body_bag/proc/update(var/broadcast=0)
	if(istype(loc, /obj/structure/morgue))
		var/obj/structure/morgue/M = loc
		M.update(broadcast)

/obj/structure/closet/body_bag/update_icon()
	if(opened)
		icon_state = "open"
	else
		icon_state = "closed_unlocked"

	cut_overlays()
	/* Ours don't have toetags
	if(has_label)
		add_overlay("bodybag_label")
	*/


/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A non-reusable plastic bag designed to slow down bodily functions such as circulation and breathing, \
	especially useful if short on time or in a hostile enviroment."
	icon = 'icons/obj/closets/cryobag.dmi'
	icon_state = "bodybag_folded"
	item_state = "bodybag_cryo_folded"
	origin_tech = list(TECH_BIO = 4)
	var/obj/item/reagent_containers/syringe/syringe

/obj/item/bodybag/cryobag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/R = new /obj/structure/closet/body_bag/cryobag(user.loc)
	R.add_fingerprint(user)
	if(syringe)
		R.syringe = syringe
		syringe = null
	qdel(src)

/obj/structure/closet/body_bag/cryobag
	name = "stasis bag"
	desc = "A non-reusable plastic bag designed to slow down bodily functions such as circulation and breathing, \
	especially useful if short on time or in a hostile enviroment."
	icon = 'icons/obj/closets/cryobag.dmi'
	item_path = /obj/item/bodybag/cryobag
	store_misc = 0
	store_items = 0
	var/used = 0
	var/obj/item/tank/tank = null
	var/tank_type = /obj/item/tank/stasis/oxygen
	var/stasis_level = 3 //Every 'this' life ticks are applied to the mob (when life_ticks%stasis_level == 1)
	var/obj/item/reagent_containers/syringe/syringe

/obj/structure/closet/body_bag/cryobag/Initialize()
	tank = new tank_type(null) //It's in nullspace to prevent ejection when the bag is opened.
	..()

/obj/structure/closet/body_bag/cryobag/Destroy()
	QDEL_NULL(syringe)
	QDEL_NULL(tank)
	return ..()

/obj/structure/closet/body_bag/cryobag/attack_hand(mob/living/user)
	if(used)
		var/confirm = tgui_alert(user, "Are you sure you want to open \the [src]? \The [src] will expire upon opening it.", "Confirm Opening", list("No", "Yes"))
		if(confirm == "Yes")
			..() // Will call `toggle()` and open the bag.
	else
		..()

/obj/structure/closet/body_bag/cryobag/open()
	. = ..()
	if(used)
		new /obj/item/usedcryobag(loc)
		qdel(src)

/obj/structure/closet/body_bag/cryobag/update_icon()
	..()
	cut_overlays()
	var/image/I = image(icon, "indicator[opened]")
	I.appearance_flags = RESET_COLOR
	I.color = COLOR_LIME
	add_overlay(I)

/obj/structure/closet/body_bag/cryobag/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(. && syringe)
		var/obj/item/bodybag/cryobag/folded = .
		folded.syringe = syringe
		syringe = null

/obj/structure/closet/body_bag/cryobag/Entered(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.Stasis(stasis_level)
		src.used = 1
		inject_occupant(H)

	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 1
		for(var/obj/item/organ/organ in O)
			organ.preserved = 1
	..()

/obj/structure/closet/body_bag/cryobag/Exited(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.Stasis(0)

	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 0
		for(var/obj/item/organ/organ in O)
			organ.preserved = 0
	..()

/obj/structure/closet/body_bag/cryobag/return_air() //Used to make stasis bags protect from vacuum.
	if(tank)
		return tank.air_contents
	..()

/obj/structure/closet/body_bag/cryobag/proc/inject_occupant(var/mob/living/carbon/human/H)
	if(!syringe)
		return

	if(H.reagents)
		syringe.reagents.trans_to_mob(H, 30, CHEM_BLOOD)

/obj/structure/closet/body_bag/cryobag/examine(mob/user)
	. = ..()
	if(Adjacent(user)) //The bag's rather thick and opaque from a distance.
		. += span_info("You peer into \the [src].")
		if(syringe)
			. += span_info("It has a syringe added to it.")
		for(var/mob/living/L in contents)
			. += L.examine(user)

/obj/structure/closet/body_bag/cryobag/attackby(obj/item/W, mob/user)
	if(opened)
		..()
	else //Allows the bag to respond to a health analyzer by analyzing the mob inside without needing to open it.
		if(istype(W,/obj/item/healthanalyzer))
			var/obj/item/healthanalyzer/analyzer = W
			for(var/mob/living/L in contents)
				analyzer.attack(L,user)

		else if(istype(W,/obj/item/reagent_containers/syringe))
			if(syringe)
				to_chat(user,span_warning("\The [src] already has an injector! Remove it first."))
			else
				var/obj/item/reagent_containers/syringe/syringe = W
				to_chat(user,span_info("You insert \the [syringe] into \the [src], and it locks into place."))
				user.unEquip(syringe)
				src.syringe = syringe
				syringe.loc = null
				for(var/mob/living/carbon/human/H in contents)
					inject_occupant(H)
					break

		else if(W.has_tool_quality(TOOL_SCREWDRIVER))
			if(syringe)
				if(used)
					to_chat(user,span_warning("The injector cannot be removed now that the stasis bag has been used!"))
				else
					syringe.forceMove(src.loc)
					to_chat(user,span_info("You pry \the [syringe] out of \the [src]."))
					syringe = null

		else
			..()

/obj/item/usedcryobag
	name = "used stasis bag"
	desc = "Pretty useless now.."
	icon_state = "bodybag_used"
	icon = 'icons/obj/closets/cryobag.dmi'
