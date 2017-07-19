/mob/living/carbon/human/verb/eat_held_thingy()
	set name = "Eat Held Item"
	set category = "Object"
	var/mob/living/carbon/human/H = src
	if(H.species.omnivorous > 0)
		var/obj/item/I = H.get_active_hand()
		if(I)
			if(istype(I,/obj/item/weapon/holder) || istype(I,/obj/item/weapon/grab))
				return
			var/confirm = alert(H, "Eat the thing?", "Confirmation", "Yes!", "Cancel")
			if(confirm == "Yes!")
				var/bellychoice = input("Which belly?","Select A Belly") in H.vore_organs
				var/datum/belly/B = H.vore_organs[bellychoice]
				H.visible_message("<span class='warning'>[H] is trying to stuff [I] into their [bellychoice]!</span>")
				if(do_after(H,30,src))
					H.drop_item()
					I.loc = H
					B.internal_contents += I
					H.visible_message("<span class='warning'>[H] manages to stuff [I] into their [bellychoice]!</span>")
					playsound(H, B.vore_sound, 100, 1)
					return
				else
					return
	return