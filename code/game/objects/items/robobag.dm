
/obj/item/bodybag/cryobag/robobag
	name = "synthmorph bag"
	desc = "A reusable polymer bag designed to slow down synthetic functions such as data corruption and coolant flow, \
	especially useful if short on time or in a hostile enviroment."
	icon = 'icons/obj/robobag.dmi'
	icon_state = "bodybag_folded"
	item_state = "bodybag_cryo_folded"
	origin_tech = list(TECH_ENGINEERING = 3)

/obj/item/bodybag/cryobag/robobag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/robobag/R = new /obj/structure/closet/body_bag/cryobag/robobag(user.loc)
	R.add_fingerprint(user)
	if(syringe)
		R.syringe = syringe
		syringe = null
	qdel(src)

/obj/structure/closet/body_bag/cryobag/robobag
	name = "synthmorph bag"
	desc = "A reusable polymer bag designed to slow down synthetic functions such as data corruption and coolant flow, \
	especially useful if short on time or in a hostile enviroment."
	icon = 'icons/obj/robobag.dmi'
	item_path = /obj/item/bodybag/cryobag/robobag
	tank_type = /obj/item/tank/stasis/nitro_cryo
	stasis_level = 2	// Lower than the normal cryobag, because it's not made for meat that dies. It's made for robots and is freezing.
	var/obj/item/clothing/accessory/badge/corptag	// The tag on the bag.

/obj/structure/closet/body_bag/cryobag/robobag/examine(mob/user)
	. = ..()
	if(corptag && Adjacent(user))
		. += "<span class='notice'>[src] has a [corptag] attached to it.</span>"

/obj/structure/closet/body_bag/cryobag/robobag/update_icon()
	cut_overlays()
	..()
	if(corptag)
		var/corptag_icon_state = "tag_blank"
		if(istype(corptag,/obj/item/clothing/accessory/badge/holo/detective) || istype(corptag,/obj/item/clothing/accessory/badge/holo/detective) || istype(corptag, /obj/item/clothing/accessory/badge/holo/hos) || istype(corptag, /obj/item/clothing/accessory/badge/old) || istype(corptag, /obj/item/clothing/accessory/badge/sheriff))
			corptag_icon_state = "tag_badge_gold"
		else if(istype(corptag, /obj/item/clothing/accessory/badge/holo/warden))
			corptag_icon_state = "tag_badge_silver"
		else if(istype(corptag, /obj/item/clothing/accessory/badge/holo))
			corptag_icon_state = "tag_badge_blue"
		else if(istype(corptag, /obj/item/clothing/accessory/badge/corporate_tag))
			corptag_icon_state = corptag.icon_state

		add_overlay(corptag_icon_state)

/obj/structure/closet/body_bag/cryobag/robobag/AltClick(mob/user)
	if(!Adjacent(user))
		..()
	if(corptag)
		corptag.forceMove(get_turf(user))
		to_chat(user, "<span class='notice'>You remove \the [corptag] from \the [src].</span>")
		corptag = null
		update_icon()
		return
	return ..()

/obj/structure/closet/body_bag/cryobag/robobag/Destroy()
	if(corptag && get_turf(src))
		var/turf/T = get_turf(src)
		corptag.forceMove(T)
		corptag = null
	else
		QDEL_NULL(corptag)
	return ..()

/obj/structure/closet/body_bag/cryobag/robobag/Entered(atom/movable/AM)
	..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.isSynthetic())
			if(H.getToxLoss() == 0)	// We don't exactly care about the bag being 'used' when containing a synth, unless it's got work.
				used = FALSE
			else
				H.add_modifier(/datum/modifier/fbp_debug/robobag)

/obj/structure/closet/body_bag/cryobag/robobag/attackby(obj/item/W, mob/user)
	if(opened)
		..()
	else //Allows the bag to respond to a cyborg analyzer and tag.
		if(istype(W,/obj/item/robotanalyzer))
			var/obj/item/robotanalyzer/analyzer = W
			for(var/mob/living/L in contents)
				analyzer.attack(L,user)

		else if(istype(W, /obj/item/clothing/accessory/badge))
			if(corptag)
				var/old_tag = corptag
				corptag.forceMove(get_turf(src))
				corptag = W
				user.unEquip(corptag)
				corptag.loc = null
				to_chat(user, "<span class='notice'>You swap \the [old_tag] for \the [corptag].</span>")
			else
				corptag = W
				user.unEquip(corptag)
				corptag.loc = null
				to_chat(user, "<span class='notice'>You attach \the [corptag] to \the [src].</span>")
			update_icon()

		else
			..()

/datum/modifier/fbp_debug
	name = "defragmenting"
	desc = "Your software is being debugged."
	mob_overlay_state = "signal_blue"

	on_created_text = "<span class='notice'>You feel something pour over your senses.</span>"
	on_expired_text = "<span class='notice'>Your mind is clear once more.</span>"
	stacks = MODIFIER_STACK_FORBID

/datum/modifier/fbp_debug/tick()
	if(holder.getToxLoss())
		holder.adjustToxLoss(rand(-1,-5))

/datum/modifier/fbp_debug/can_apply(mob/living/L)
	if(!L.isSynthetic())
		return FALSE
	return TRUE

/datum/modifier/fbp_debug/check_if_valid()
	..()
	if(!holder.getToxLoss())
		src.expire()

/datum/modifier/fbp_debug/robobag/check_if_valid()
	..()
	if(!istype(holder.loc, /obj/structure/closet/body_bag/cryobag/robobag))
		src.expire()
