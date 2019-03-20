/obj/machinery/computer/id_restorer
	name = "ID restoration terminal"
	icon_state = "id-restorer"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	icon_keyboard = null
	icon_screen = "restorer"
	density = 0
	circuit = /obj/item/weapon/circuitboard/guestpass

	var/obj/item/weapon/card/id/inserted

/obj/machinery/computer/id_restorer/attackby(obj/I, mob/user)
	if(istype(I, /obj/item/weapon/card/id) && !(istype(I,/obj/item/weapon/card/id/guest)))
		if(!inserted && user.unEquip(I))
			I.forceMove(src)
			inserted = I
		else if(inserted)
			user << "<span class='warning'>There is already ID card inside.</span>"
		return
	..()

/obj/machinery/computer/id_restorer/attack_hand(mob/user)
	if(..()) return
	if(stat & (NOPOWER|BROKEN)) return

	var/choice = alert(user,"What do you want to do?","[src]","Restore ID access","Eject ID","Cancel")
	if(user.incapacitated() || (get_dist(src, user) > 1))
		return
	switch(choice)
		if("Restore ID access")
			if(!inserted)
				to_chat(user, "<span class='notice'>No ID is inserted.</span>")
				return
			var/mob/living/carbon/human/H = user
			if(!(istype(H)))
				to_chat(user, "<span class='warning'>Invalid user detected. Access denied.</span>")
				return
			else if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)))	//Face hiding bad
				to_chat(user, "<span class='warning'>Facial recognition scan failed due to physical obstructions. Access denied.</span>")
				return
			else if(H.get_face_name() == "Unknown" || !(H.real_name == inserted.registered_name))
				to_chat(user, "<span class='warning'>Facial recognition scan failed. Access denied.</span>")
				return
			else if(LAZYLEN(inserted.lost_access) && !(LAZYLEN(inserted.access)))
				inserted.access = inserted.lost_access
				inserted.lost_access = list()
				to_chat(user, "<span class='notice'>ID access codes successfully restored.</span>")
				return
			else if(!(LAZYLEN(inserted.lost_access)))
				to_chat(user, "<span class='notice'>No recent access codes damage detected. Restoration cancelled.</span>")
				return
			else
				to_chat(user, "<span class='warning'>Terminal encountered unknown error. Contact system administrator or try again.</span>")
				return
		if("Eject ID")
			if(!inserted)
				to_chat(user, "<span class='notice'>No ID is inserted.</span>")
				return
			if(ishuman(user))
				inserted.forceMove(get_turf(src))
				if(!user.get_active_hand())
					user.put_in_hands(inserted)
				inserted = null
			else
				inserted.forceMove(get_turf(src))
				inserted = null
			return
		if("Cancel")
			return