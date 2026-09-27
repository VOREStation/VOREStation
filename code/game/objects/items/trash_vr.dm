// Custom garbage or whatever

/obj/item/trash/attack(mob/living/M, mob/living/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(src,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			H.vore_selected.nom_atom(src)
			balloon_alert(H, "you can taste the flavor of garbage. Wait what?")
			return

	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.module.type == /obj/item/robot_module/robot/janitor) // You can now feed the trash borg yay.
			playsound(src,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			R.vore_selected.nom_atom(src)
			R.balloon_alert_visible("[user] feeds [R] with [src]!", "you feed [R] \the [src]!")
			return
	..()

/obj/item/trash/rkibble
	name = "bowl of Borg-O's"
	desc = "Contains every type of scrap material your robot puppy needs to grow big and strong."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "kibble"
	var/bitecount = 0
	var/bites = 5

/obj/item/trash/rkibble/attack_robot(mob/user)
	. = ..()
	if(isrobot(user))
		var/mob/living/silicon/robot/our_robot = user
		var/dist = get_dist(src, user)
		if(dist > 1)
			return
		bitecount++
		our_robot.cell?.give(50)
		user.setClickCooldown(user.get_attack_speed(user))
		//TODO I want to give borgs charge here but I don't know how to do that yet.
		if(bitecount>=5)
			user.balloon_alert_visible("\the [user] finishes eating \the [src]", \
			"finished eating \the [src].")
			qdel(src)
			return
		user.balloon_alert_visible("\the [user] nibbles \the [src]", \
		"nibbled \the [src].")

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

/obj/item/trash/ratfruitcake
	name = "\improper Flavor Unit package"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_fruitcake-trash"

/obj/item/trash/ratpackburger
	name = "\improper Prepackaged Meal Tray"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_pack_burger-trash"

/obj/item/trash/ratpackcheese
	name = "\improper Prepackaged Meal Tray"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_pack_cheese-trash"

/obj/item/trash/ratpackturkey
	name = "\improper Prepackaged Meal Tray"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_pack_turkey-trash"

/obj/item/trash/ratpackramen
	name = "\improper Prepackaged Meal Tray"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_pack_ramen_standard-trash"

/obj/item/trash/ratpackramen/standard
	icon_state = "altevian_pack_ramen_standard-trash"

/obj/item/trash/ratpackramen/lacquer1
	icon_state = "altevian_pack_ramen_lacquer1-trash"

/obj/item/trash/ratpackramen/lacquer2
	icon_state = "altevian_pack_ramen_lacquer2-trash"

/obj/item/trash/ratpackramen/lacquer3
	icon_state = "altevian_pack_ramen_lacquer3-trash"

/obj/item/trash/ratpackramen/fleet
	icon_state = "altevian_pack_ramen_fleet-trash"

/obj/item/trash/ratpackramen/trans
	icon_state = "altevian_pack_ramen_trans-trash"

/obj/item/trash/ratpackramen/ace
	icon_state = "altevian_pack_ramen_ace-trash"

/obj/item/trash/ratpacktaco
	name = "\improper Prepackaged Meal Tray"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_pack_taco-trash"

/obj/item/trash/ratpackcake
	name = "\improper Prepackaged Meal Tray"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_pack_cake-trash"

/obj/item/trash/ratpackmeat
	name = "\improper Prepackaged Meal Tray"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "altevian_pack_meat-trash"
