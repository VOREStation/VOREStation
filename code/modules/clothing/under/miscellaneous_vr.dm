/obj/item/clothing/var/hides_bulges = FALSE // OwO wats this?

/mob/living/carbon/human/proc/show_pudge()
	//A uniform could hide it.
	if(istype(w_uniform,/obj/item/clothing))
		var/obj/item/clothing/under = w_uniform
		if(under.hides_bulges)
			return FALSE

	//We return as soon as we find one, no need for 'else' really.
	if(istype(wear_suit,/obj/item/clothing))
		var/obj/item/clothing/suit = wear_suit
		if(suit.hides_bulges)
			return FALSE


	return TRUE

/obj/item/clothing/under/permit
	name = "public nudity permit"
	desc = "This permit entitles the bearer to conduct their duties without a uniform. Normally issued to furred crewmembers or those with nothing to hide."
	icon = 'icons/obj/card.dmi'
	icon_state = "guest"
	body_parts_covered = 0

	sprite_sheets = list()

	item_state = "golem"  //This is dumb and hacky but was here when I got here.
	worn_state = "golem"  //It's basically just a coincidentally black iconstate in the file.

/obj/item/clothing/under/bluespace
	name = "bluespace jumpsuit"
	icon_state = "lingchameleon"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_uniforms.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_uniforms.dmi',
			)
	item_state = "lingchameleon"
	worn_state = "lingchameleon"
	desc = "Do you feel like warping spacetime today? Because it seems like that's on the agenda, now. \
			Allows one to resize themselves at will, and conceals their true weight."
	hides_bulges = TRUE
	var/original_size

/obj/item/clothing/under/bluespace/verb/resize()
	set name = "Adjust Size"
	set category = "Object"
	set src in usr
	bluespace_size(usr)
	..()

/obj/item/clothing/under/bluespace/proc/bluespace_size(mob/usr as mob)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if (H.stat || H.restrained())
		return

	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	var/choice = alert(H,"Change which way?","Mass Alteration","Size Up","Cancel","Size Down")
	if(choice == "Cancel")
		return FALSE

	//Check AGAIN because we accepted user input which is blocking.
	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	if (isnull(H.size_multiplier))
		to_chat(H,"<span class='warning'>The uniform panics and corrects your apparently microscopic size.</span>")
		H.resize(RESIZE_NORMAL)
		H.update_icons()
		return

	var/new_size
	if (choice == "Size Up")
		switch(H.size_multiplier)
			if(RESIZE_BIG to RESIZE_HUGE)
				new_size = RESIZE_HUGE
			if(RESIZE_NORMAL to RESIZE_BIG)
				new_size = RESIZE_BIG
			if(RESIZE_SMALL to RESIZE_NORMAL)
				new_size = RESIZE_NORMAL
			if((0 - INFINITY) to RESIZE_TINY)
				new_size = RESIZE_SMALL

	else if (choice == "Size Down")
		switch(H.size_multiplier)
			if(RESIZE_HUGE to INFINITY)
				new_size = RESIZE_BIG
			if(RESIZE_BIG to RESIZE_HUGE)
				new_size = RESIZE_NORMAL
			if(RESIZE_NORMAL to RESIZE_BIG)
				new_size = RESIZE_SMALL
			if((0 - INFINITY) to RESIZE_NORMAL)
				new_size = RESIZE_TINY

	if(new_size)
		if(new_size != H.size_multiplier)
			if(!original_size)
				original_size = H.size_multiplier
			H.resize(new_size)
			H.visible_message("<span class='warning'>The space around [H] distorts as they change size!</span>","<span class='notice'>The space around you distorts as you change size!</span>")
		else
			to_chat(H,"<span class='warning'>That's as far as you can resize in that direction!</span>")
			return

/obj/item/clothing/under/bluespace/mob_can_unequip(mob/M, slot, disable_warning = 0)
	. = ..()
	if(. && ishuman(M) && original_size)
		var/mob/living/carbon/human/H = M
		H.resize(original_size)
		original_size = null
		H.visible_message("<span class='warning'>The space around [H] distorts as they return to their original size!</span>","<span class='notice'>The space around you distorts as you return to your original size!</span>")
