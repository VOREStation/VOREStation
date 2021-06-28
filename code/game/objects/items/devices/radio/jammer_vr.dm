//Unlimited use, unlimited range jammer for admins. Turn it on, drop it somewhere, it works.
/obj/item/device/radio_jammer/admin
	jam_range = 255
	tick_cost = 0

/proc/is_vore_jammed(var/obj/radio)
	var/atom/current = radio
	while(current.loc)
		if(isbelly(current.loc))
			var/obj/belly/B = current.loc
			if(B.mode_flags & DM_FLAG_JAMSENSORS)
				return TRUE
		current = current.loc
	return FALSE
