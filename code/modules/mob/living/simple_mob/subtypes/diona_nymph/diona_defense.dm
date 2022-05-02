/mob/living/carbon/diona_nymph/MouseDrop(var/atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if(ishuman(H) && Adjacent(H) && H.a_intent == "grab" && hat && !H.hands_are_full())
		hat.loc = get_turf(src)
		H.put_in_hands(hat)
		H.visible_message("<span class='danger'>\The [H] removes \the [src]'s [hat].</span>")
		hat = null
		updateicon()
		return
	return ..()

/mob/living/carbon/diona_nymph/attackby(var/obj/item/W, var/mob/user)
	if(user.a_intent == "help" && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, "<span class='warning'>\The [src] is already wearing \the [hat].</span>")
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message("<span class='notice'>\The [user] puts \the [W] on \the [src].</span>")
		return
	return ..()

/mob/living/carbon/diona_nymph/ex_act(severity)

	if(!blinded)
		flash_eyes()

	var/b_loss = 0
	var/f_loss = 0
	switch (severity)
		if(1.0)
			b_loss += 500
			gib()
			return

		if(2.0)
			b_loss += 60
			f_loss += 60
			ear_damage += 30
			ear_deaf += 120

		if(3.0)
			b_loss += 30
			ear_damage += 15
			ear_deaf += 60
			if (prob(50))
				Paralyse(1)

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()