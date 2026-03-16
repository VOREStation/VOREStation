/obj/item/medigun_backpack/verb/toggle_medigun()
	set name = "Toggle medigun"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(maintenance)
		to_chat(user, span_warning("Please close the maintenance hatch with a screwdriver first, or to remove components, use a crowbar."))
		return

	if(!medigun)
		to_chat(user, span_warning("The medigun is missing!"))
		return

	if(medigun.loc != src)
		reattach_medigun(user) //Remove from their hands and back onto the medigun unit
		return

	if(!slot_check())
		to_chat(user, span_warning("You need to equip [src] before taking out [medigun]."))
	else
		if(!user.put_in_hands(medigun)) //Detach the medigun into the user's hands
			to_chat(user, span_warning("You need a free hand to hold the medigun!"))
		else
			containsgun = 0
			replace_icon(TRUE)
			if(is_twohanded())
				medigun.update_twohanding()
			user.update_inv_back()
