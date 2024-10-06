/mob/living/silicon/robot/platform/attack_hand(mob/user)

	if(!opened)
		if(recharging)
			var/obj/item/recharging_atom = recharging.resolve()
			if(istype(recharging_atom) && !QDELETED(recharging_atom) && recharging_atom.loc == src)
				recharging_atom.dropInto(loc)
				user.put_in_hands(recharging_atom)
				user.visible_message("<b>\The [user]</b> pops \the [recharging_atom] out of \the [src]'s recharging port.")
			recharging = null
			return TRUE

		if(try_remove_cargo(user))
			return TRUE

	. = ..()

/mob/living/silicon/robot/platform/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/cell) && !opened)
		if(recharging)
			to_chat(user, span_warning("\The [src] already has \a [recharging.resolve()] inserted into its recharging port."))
		else if(user.unEquip(W))
			W.forceMove(src)
			recharging = WEAKREF(W)
			recharge_complete = FALSE
			user.visible_message("<b>\The [user]</b> slots \the [W] into \the [src]'s recharging port.")
		return TRUE

	if(istype(W, /obj/item/floor_painter))
		return FALSE // Paint sprayer wil call try_paint() in afterattack()

	. = ..()

/mob/living/silicon/robot/platform/attack_ghost(mob/observer/dead/user)

	if(client || key || stat == DEAD || !ticker || !ticker.mode)
		return ..()

	var/confirm = tgui_alert(usr, "Do you wish to take control of \the [src]?", "Platform Control", list("No", "Yes"))
	if(confirm != "Yes" || QDELETED(src) || client || key || stat == DEAD || !ticker || !ticker.mode)
		return ..()

	if(jobban_isbanned(user, "Robot"))
		to_chat(user, span_warning("You are banned from synthetic roles and cannot take control of \the [src]."))
		return

	// Boilerplate from drone fabs, unsure if there's a shared proc to use instead.
	var/deathtime = world.time - user.timeofdeath
	var/deathtimeminutes = round(deathtime / (1 MINUTE))
	var/pluralcheck = ""
	if(deathtimeminutes == 1)
		pluralcheck = "minute"
	else if(deathtimeminutes > 0)
		pluralcheck = " [deathtimeminutes] minute\s and"
	var/deathtimeseconds = round((deathtime - deathtimeminutes * 1 MINUTE) / 10,1)
	if (deathtime < platform_respawn_time)
		to_chat(usr, "You have been dead for[pluralcheck] [deathtimeseconds] seconds.")
		to_chat(usr, "You must wait [platform_respawn_time/600] minute\s to take control of \the [src]!")
		return
	// End boilerplate.

	if(user.mind)
		user.mind.transfer_to(src)
	if(key != user.key)
		key = user.key
	SetName("[modtype] [braintype]-[rand(100,999)]")
	addtimer(CALLBACK(src, PROC_REF(welcome_client)), 1)
	qdel(user)

/mob/living/silicon/robot/platform/proc/welcome_client()
	if(client)
		to_chat(src, span_notice("<b>You are a think-tank</b>, a kind of flexible and adaptive drone intelligence installed into an armoured platform. Your programming compels you to be friendly and helpful wherever possible."))
	SetSleeping(0)
	SetWeakened(0)
	SetParalysis(0)
	resting = FALSE
