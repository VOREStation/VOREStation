/obj/item/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/items.dmi'
	icon_state = "lipstick"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/colour = "red"
	var/open = 0
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/lipstick/purple
	name = "purple lipstick"
	colour = "purple"

/obj/item/lipstick/jade
	name = "jade lipstick"
	colour = "jade"

/obj/item/lipstick/black
	name = "black lipstick"
	colour = "black"

/obj/item/lipstick/random
	name = "lipstick"

/obj/item/lipstick/random/Initialize(mapload)
	. = ..()
	colour = pick("red","purple","jade","black")
	name = "[colour] lipstick"

/obj/item/lipstick/attack_self(mob/user as mob)
	to_chat(user, span_notice("You twist \the [src] [open ? "closed" : "open"]."))
	open = !open
	if(open)
		icon_state = "[initial(icon_state)]_[colour]"
	else
		icon_state = initial(icon_state)

/obj/item/lipstick/attack(mob/M as mob, mob/user as mob)
	if(!open)	return

	if(!istype(M, /mob))	return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lip_style)	//if they already have lipstick on
			to_chat(user, span_notice("You need to wipe off the old lipstick first!"))
			return
		if(H == user)
			user.visible_message(span_notice("[user] does their lips with \the [src]."), \
									span_notice("You take a moment to apply \the [src]. Perfect!"))
			H.lip_style = colour
			H.update_icons_body()
		else
			user.visible_message(span_warning("[user] begins to do [H]'s lips with \the [src]."), \
									span_notice("You begin to apply \the [src]."))
			if(do_after(user, 20, H))	//user needs to keep their active hand, H does not.
				user.visible_message(span_notice("[user] does [H]'s lips with \the [src]."), \
										span_notice("You apply \the [src]."))
				H.lip_style = colour
				H.update_icons_body()
	else
		to_chat(user, span_notice("Where are the lips on that?"))

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()

/obj/item/haircomb //sparklysheep's comb
	name = "purple comb"
	desc = "A pristine purple comb made from flexible plastic."
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"

/obj/item/haircomb/attack_self(mob/living/user)
	var/text = "person"
	if(ishuman(user))
		var/mob/living/carbon/human/U = user
		switch(U.identifying_gender)
			if(MALE)
				text = "guy"
			if(FEMALE)
				text = "lady"
	else
		switch(user.gender)
			if(MALE)
				text = "guy"
			if(FEMALE)
				text = "lady"
	user.visible_message(span_notice("[user] uses [src] to comb their hair with incredible style and sophistication. What a [text]."))

/obj/item/makeover
	name = "makeover kit"
	desc = "A tiny case containing a mirror and some contact lenses."
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/items.dmi'
	icon_state = "trinketbox"
	var/datum/tgui_module/appearance_changer/mirror/coskit/M

/obj/item/makeover/Initialize(mapload)
	. = ..()
	M = new(src, null)

/obj/item/makeover/attack_self(mob/living/carbon/user as mob)
	if(ishuman(user))
		to_chat(user, span_notice("You flip open \the [src] and begin to adjust your appearance."))
		M.tgui_interact(user)
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(istype(E))
			E.change_eye_color()

/obj/item/makeover/Destroy()
	qdel(M)
	. = ..()
