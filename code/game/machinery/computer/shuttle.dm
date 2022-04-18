/obj/machinery/computer/shuttle
	name = "Shuttle"
	desc = "For shuttle control."
	icon_keyboard = "tech_key"
	icon_screen = "shuttle"
	light_color = "#00ffff"
	var/auth_need = 3.0
	var/list/authorized = list(  )


/obj/machinery/computer/shuttle/attackby(var/obj/item/card/W as obj, var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER))	return
	if ((!( istype(W, /obj/item/card) ) || !( ticker ) || emergency_shuttle.location() || !( user )))	return
	if (istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if (istype(W, /obj/item/pda))
			var/obj/item/pda/pda = W
			W = pda.id
		if (!W:access) //no access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return

		var/list/cardaccess = W:access
		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return

		if(!(access_heads in W:access)) //doesn't have this access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return 0

		var/choice = tgui_alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", list("Authorize", "Repeal", "Abort"))
		if(emergency_shuttle.location() && user.get_active_hand() != W)
			return 0
		switch(choice)
			if("Authorize")
				src.authorized -= W:registered_name
				src.authorized += W:registered_name
				if (src.auth_need - src.authorized.len > 0)
					message_admins("[key_name_admin(user)] has authorized early shuttle launch")
					log_game("[user.ckey] has authorized early shuttle launch")
					to_world("<span class='notice'><b>Alert: [src.auth_need - src.authorized.len] authorizations needed until shuttle is launched early</b></span>")
				else
					message_admins("[key_name_admin(user)] has launched the shuttle")
					log_game("[user.ckey] has launched the shuttle early")
					to_world("<span class='notice'><b>Alert: Shuttle launch time shortened to 10 seconds!</b></span>")
					emergency_shuttle.set_launch_countdown(10)
					//src.authorized = null
					qdel(src.authorized)
					src.authorized = list(  )

			if("Repeal")
				src.authorized -= W:registered_name
				to_world("<span class='notice'><b>Alert: [src.auth_need - src.authorized.len] authorizations needed until shuttle is launched early</b></span>")

			if("Abort")
				to_world("<span class='notice'><b>All authorizations to shortening time for shuttle launch have been revoked!</b></span>")
				src.authorized.len = 0
				src.authorized = list(  )

<<<<<<< HEAD
	else if (istype(W, /obj/item/weapon/card/emag) && !emagged)
		var/choice = tgui_alert(user, "Would you like to launch the shuttle?", "Shuttle control", list("Launch", "Cancel"))
=======
	else if (istype(W, /obj/item/card/emag) && !emagged)
		var/choice = alert(user, "Would you like to launch the shuttle?","Shuttle control", "Launch", "Cancel")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

		if(!emagged && !emergency_shuttle.location() && user.get_active_hand() == W)
			switch(choice)
				if("Launch")
					to_world("<span class='notice'><b>Alert: Shuttle launch time shortened to 10 seconds!</b></span>")
					emergency_shuttle.set_launch_countdown(10)
					emagged = 1
				if("Cancel")
					return
	return
