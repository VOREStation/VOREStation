// Custom garbage or whatever

/obj/item/trash/rkibble
	name = "bowl of Borg-O's"
	desc = "Contains every type of scrap material your robot puppy needs to grow big and strong."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "kibble"

/obj/item/trash/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			src.forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return

	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.module.type == /obj/item/weapon/robot_module/robot/scrubpup) // You can now feed the trash borg yay.
			playsound(R.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = R.vore_selected
			var/datum/belly/selected = R.vore_organs[belly]
			src.forceMove(R)
			selected.internal_contents |= src // Too many hoops and obstacles to stick it into the sleeper module.
			R.visible_message("<span class='warning'>[user] feeds [R] with [src]!</span>")
			return
	..()
