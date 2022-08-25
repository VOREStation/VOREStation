// Custom garbage or whatever

/obj/item/trash/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(src,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			forceMove(H.vore_selected)
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return

	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.module.type == /obj/item/weapon/robot_module/robot/scrubpup) // You can now feed the trash borg yay.
			playsound(src,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			forceMove(R.vore_selected)
			R.visible_message("<span class='warning'>[user] feeds [R] with [src]!</span>")
			return
	..()

/obj/item/trash/rkibble
	name = "bowl of Borg-O's"
	desc = "Contains every type of scrap material your robot puppy needs to grow big and strong."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "kibble"

/obj/item/trash/fancyplate
	name = "dirty fancy plate"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "fancyplate"

/obj/item/trash/ratcheese
	name = "\improper Flavor Unit package"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_cheese_block-trash"

/obj/item/trash/ratveg
	name = "\improper Premium Ration packet"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_veggies-trash"

/obj/item/trash/ratjuice
	name = "\improper Space-Safe Meal package"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_juice-trash"