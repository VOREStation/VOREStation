/obj/item/stack/medical/advanced
	icon = 'icons/obj/stacks_vr.dmi'

/obj/item/stack/medical/advanced/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/medical/advanced/update_icon()
	switch(amount)
		if(1 to 2)
			icon_state = initial(icon_state)
		if(3 to 4)
			icon_state = "[initial(icon_state)]_4"
		if(5 to 6)
			icon_state = "[initial(icon_state)]_6"
		if(7 to 8)
			icon_state = "[initial(icon_state)]_8"
		if(9)
			icon_state = "[initial(icon_state)]_9"
		else
			icon_state = "[initial(icon_state)]_10"


/obj/item/stack/medical/advanced/clotting
	name = "liquid bandage kit"
	singular_name = "liquid bandage kit"
	desc = "A spray that stops bleeding using a patented chemical cocktail. Non-refillable. Only one use required per patient."
	icon_state = "clotkit"
	heal_burn = 0
	heal_brute = 2 // Only applies to non-humans, to give this some slight application on animals
	origin_tech = list(TECH_BIO = 3)
	apply_sounds = list('sound/effects/spray.ogg', 'sound/effects/spray2.ogg', 'sound/effects/spray3.ogg')
	amount = 5
	max_amount = 5

/obj/item/stack/medical/advanced/clotting/attack(mob/living/carbon/human/H, var/mob/user)
	if(..())
		return 1

	if(!istype(H))
		return

	var/clotted = 0
	var/too_far_gone = 0

	for(var/obj/item/organ/external/affecting as anything in H.organs) //'organs' is just external organs, as opposed to 'internal_organs'

		// No amount of clotting is going to help you here.
		if(affecting.open)
			too_far_gone++
			continue

		for(var/datum/wound/W as anything in affecting.wounds)
			// No need
			if(W.bandaged)
				continue
			// It's not that amazing
			if(W.internal)
				continue
			if(W.current_stage <= W.max_bleeding_stage)
				clotted++
			W.bandage()

	var/healmessage = span_notice("You spray [src] onto [H], sealing [clotted ? clotted : "no"] wounds.")
	if(too_far_gone)
		healmessage += " <span class='warning'>You can see some wounds that are too large where the spray is not taking effect.</span>"

	to_chat(user, healmessage)
	use(1)
	playsound(src, pick(apply_sounds), 25)
	update_icon()

/obj/item/stack/medical/advanced/clotting/update_icon()
	icon_state = "[initial(icon_state)]_[amount]"
