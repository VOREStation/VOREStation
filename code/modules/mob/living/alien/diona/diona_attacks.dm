/mob/living/carbon/alien/diona/MouseDrop(var/atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if(!istype(H) || !Adjacent(H))
		return ..()
	if(H.a_intent == "grab" && hat && !H.hands_are_full())
		hat.loc = get_turf(src)
		H.put_in_hands(hat)
		H.visible_message("<span class='danger'>\The [H] removes \the [src]'s [hat].</span>")
		hat = null
		updateicon()
	else
		return ..()

/mob/living/carbon/alien/diona/attackby(var/obj/item/weapon/W, var/mob/user)
	if(user.a_intent == "help" && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, "<span class='warning'>\The [src] is already wearing \the [hat].</span>")
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message("<b>\The [user]</b> puts \the [W] on \the [src].")
		return
	return ..()
