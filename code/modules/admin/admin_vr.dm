/datum/admins/proc/set_uplink(mob/living/carbon/human/H as mob)
	set category = "Debug"
	set name = "Set Uplink"
	set desc = "Allows admins to set up an uplink on a character. This will be required for a character to use telecrystals."
	set popup_menu = FALSE

	if(check_rights(R_ADMIN|R_DEBUG))
		traitors.spawn_uplink(H)
		H.mind.tcrystals = DEFAULT_TELECRYSTAL_AMOUNT
		H.mind.accept_tcrystals = 1
		var/msg = "[key_name(usr)] has given [H.ckey] an uplink."
		message_admins(msg)
	else
		to_chat(usr, "You do not have access to this command.")