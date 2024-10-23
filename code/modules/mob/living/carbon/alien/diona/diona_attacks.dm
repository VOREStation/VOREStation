/mob/living/carbon/alien/diona/MouseDrop(var/atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if(!istype(H) || !Adjacent(H))
		return ..()
	if(H.a_intent == "grab" && hat && !H.hands_are_full())
		hat.loc = get_turf(src)
		H.put_in_hands(hat)
		H.visible_message(span_danger("\The [H] removes \the [src]'s [hat]."))
		hat = null
		update_icon()
	else
		return ..()

/mob/living/carbon/alien/diona/attackby(var/obj/item/W, var/mob/user)
	if(user.a_intent == "help" && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, span_warning("\The [src] is already wearing \the [hat]."))
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message(span_infoplain(span_bold("\The [user]") + " puts \the [W] on \the [src]."))
		return
	return ..()
