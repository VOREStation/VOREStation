/obj/machinery/computer/id_restorer
	name = "ID restoration terminal"
	desc = "A terminal for restoration of damaged IDs. Mostly used for aftermath of unfortunate falls into vats of acid."
	icon_state = "restorer"
	icon_keyboard = null
	light_color = "#11cc00"
	layer = ABOVE_WINDOW_LAYER
	icon_keyboard = null
	icon = 'icons/obj/machines/id_restorer_vr.dmi'
	density = FALSE
	clicksound = null
	circuit = /obj/item/circuitboard/id_restorer

	var/icon_success = "restorer_success"
	var/icon_fail = "restorer_fail"

	var/obj/item/card/id/inserted

/obj/machinery/computer/id_restorer/attackby(obj/I, mob/user)
	/*
	if(istype(I, /obj/item/card/id) && !(istype(I,/obj/item/card/id/guest)))
		if(!inserted && user.unEquip(I))
			I.forceMove(src)
			inserted = I
		else if(inserted)
			to_chat(user, "<span class='warning'>There is already ID card inside.</span>")
		return
	*/
	..()

/obj/machinery/computer/id_restorer/attack_hand(mob/user)
	if(..()) return
	if(stat & (NOPOWER|BROKEN)) return

	/*
	if(!inserted) // No point in giving you an option what to do if there's no ID to do things with.
		to_chat(user, "<span class='notice'>No ID is inserted.</span>")
		return

	var/choice = tgui_alert(user,"What do you want to do?","[src]",list("Restore ID access","Eject ID","Cancel"))
	if(user.incapacitated() || (get_dist(src, user) > 1))
		return
	switch(choice)
		if("Restore ID access")
			var/mob/living/carbon/human/H = user
			if(!(istype(H)))
				to_chat(user, "<span class='warning'>Invalid user detected. Access denied.</span>")
				flick(icon_fail, src)
				return
			else if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)))	//Face hiding bad
				to_chat(user, "<span class='warning'>Facial recognition scan failed due to physical obstructions. Access denied.</span>")
				flick(icon_fail, src)
				return
			else if(H.get_face_name() == "Unknown" || !(H.real_name == inserted.registered_name))
				to_chat(user, "<span class='warning'>Facial recognition scan failed. Access denied.</span>")
				flick(icon_fail, src)
				return
			else if(LAZYLEN(inserted.lost_access) && !(LAZYLEN(inserted.access)))
				inserted.access = inserted.lost_access
				inserted.lost_access = list()
				inserted.desc = "A partially digested card that has seen better days. The damage to access codes, however, appears to have been mitigated."
				to_chat(user, "<span class='notice'>ID access codes successfully restored.</span>")
				flick(icon_success, src)
				return
			else if(!(LAZYLEN(inserted.lost_access)))
				to_chat(user, "<span class='notice'>No recent access codes damage detected. Restoration cancelled.</span>")
				return
			else
				to_chat(user, "<span class='warning'>Terminal encountered unknown error. Contact system administrator or try again.</span>")
				flick(icon_fail, src)
				return
		if("Eject ID")
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
	*/


//Frame
/datum/frame/frame_types/id_restorer
	name = "ID Restoration Terminal"
	frame_class = FRAME_CLASS_DISPLAY
	frame_size = 2
	frame_style = FRAME_STYLE_WALL
	x_offset = 30
	y_offset = 30
	icon_override = 'icons/obj/machines/id_restorer_vr.dmi'

/datum/frame/frame_types/id_restorer/get_icon_state(var/state)
	return "restorer_b[state]"
