// Admin Verbs in this file are special and cannot use the AVD system for some reason or another.

/client/proc/readmin()
	set name = "Readmin"
	set category = "Admin.Misc"
	set desc = "Regain your admin powers."

	var/datum/admins/A = GLOB.deadmins[ckey]

	if(!A)
		A = GLOB.admin_datums[ckey]
		if (!A)
			var/msg = " is trying to readmin but they have no deadmin entry"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return

	A.associate(src)

	if(!holder)
		return //This can happen if an admin attempts to vv themself into somebody elses's deadmin datum by getting ref via brute force

	to_chat(src, span_interface("You are now an admin."), confidential = TRUE)
	message_admins("[src] re-adminned themselves.")
	log_admin("[src] re-adminned themselves.")
	//BLACKBOX_LOG_ADMIN_VERB("Readmin")

	if(isobserver(mob))
		var/mob/observer/dead/our_mob = mob
		our_mob.visualnet?.addVisibility(our_mob, src)
