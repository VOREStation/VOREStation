/mob/living/carbon/diona/MouseDrop(var/atom/over_object)
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


/mob/living/carbon/diona/attackby(var/obj/item/W, var/mob/user)
	if(user.a_intent == "help" && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, "<span class='warning'>\The [src] is already wearing \the [hat].</span>")
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message("<span class='notice'>\The [user] puts \the [W] on \the [src].</span>")
		return
	return ..()


/mob/living/carbon/diona/attack_ui(slot_id)
	return


/mob/living/carbon/diona/attack_hand(mob/living/carbon/M as mob)
	..()
	switch(M.a_intent)
		if(I_HELP)
			help_shake_act(M)

		if(I_GRAB)
			if(M == src)
				return
			var/obj/item/grab/G = new /obj/item/grab(M, src)

			M.put_in_active_hand(G)

			grabbed_by += G
			G.affecting = src
			G.synch()

			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			src.visible_message(
				SPAN_WARNING("[M] grabs \the [src] passively!"),
				SPAN_WARNING("You grab \the [src].")
			)

		else
			var/damage = rand(1, 9)
			if (prob(10))
				playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				src.visible_message(
					SPAN_DANGER("[M] attempts to punch \the [src], but missed!"),
					SPAN_DANGER("You failed to punch \the [src]!")
				)
				return

			playsound(src, "punch", 25, 1, -1)
			if (damage > 4.9)
				Weaken(rand(10,15))
			src.visible_message(
				SPAN_DANGER("[M] punches \the [src]!"),
				SPAN_DANGER("You punch \the [src].")
			)

			adjustBruteLoss(damage)
			updatehealth()


/mob/living/carbon/diona/ex_act(severity)
	if(!blinded)
		flash_eyes()

	var/b_loss = 0
	var/f_loss = 0
	switch(severity)
		if(1.0)
			b_loss = 500
			gib()
			return

		if(2.0)
			b_loss = 60
			f_loss = 60
			ear_damage += 30
			ear_deaf += 120

		if(3.0)
			b_loss = 30
			if(prob(50))
				Paralyse(1)
			ear_damage += 15
			ear_deaf += 60

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)
	updatehealth()
