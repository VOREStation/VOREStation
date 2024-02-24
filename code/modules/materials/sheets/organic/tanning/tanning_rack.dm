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
	cut_overlays()
	if(drying)
		if(drying.wetness)
			add_overlay("leather_wet")
		else
			add_overlay("leather_dry")

/obj/structure/tanning_rack/attackby(var/atom/A, var/mob/user)
	if(istype(A, /obj/item/stack/wetleather))
		if(!drying) // If not drying anything, start drying the thing
			if(user.unEquip(A, target = src))
				drying = A
		else // Drying something, add if possible
			var/obj/item/stack/wetleather/W = A
			W.transfer_to(drying, W.get_amount(), TRUE)
		update_icon()
		return TRUE
	return ..()

/obj/structure/tanning_rack/attack_hand(var/mob/user)
	if(drying)
		var/obj/item/stack/S = drying
		if(!drying.wetness) // If it's dry, make a stack of dry leather and prepare to put that in their hands
			var/obj/item/stack/material/leather/L = new(src, drying.get_amount())
			drying.set_amount(0)
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