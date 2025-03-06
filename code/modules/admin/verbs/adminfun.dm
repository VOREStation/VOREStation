ADMIN_VERB(admin_explosion, R_ADMIN|R_FUN, "Explosion", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, atom/orignator as obj|mob|turf)
	var/devastation = tgui_input_number(user, "Range of total devastation. -1 to none", text("Input"), min_value=-1)
	if(devastation == null)
		return
	var/heavy = tgui_input_number(user, "Range of heavy impact. -1 to none", text("Input"), min_value=-1)
	if(heavy == null)
		return
	var/light = tgui_input_number(user, "Range of light impact. -1 to none", text("Input"), min_value=-1)
	if(light == null)
		return
	var/flash = tgui_input_number(user, "Range of flash. -1 to none", text("Input"), min_value=-1)
	if(flash == null)
		return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20))
			if (tgui_alert(user, "Are you sure you want to do this? It will laaag.", "Confirmation", list("Yes", "No")) != "Yes")
				return

		explosion(orignator, devastation, heavy, light, flash)
		log_admin("[key_name(user)] created an explosion ([devastation],[heavy],[light],[flash]) at [AREACOORD(orignator)]")
		message_admins("[key_name_admin(user)] created an explosion ([devastation],[heavy],[light],[flash]) at [AREACOORD(orignator)]")
		feedback_add_details("admin_verb","Explosion") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(admin_emp, R_ADMIN|R_FUN, "EM Pulse", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, atom/orignator as obj|mob|turf)
	var/heavy = tgui_input_number(user, "Range of heavy pulse.", text("Input"))
	if(heavy == null)
		return
	var/med = tgui_input_number(user, "Range of medium pulse.", text("Input"))
	if(med == null)
		return
	var/light = tgui_input_number(user, "Range of light pulse.", text("Input"))
	if(light == null)
		return
	var/long = tgui_input_number(user, "Range of long pulse.", text("Input"))
	if(long == null)
		return

	if (heavy || med || light || long)
		empulse(orignator, heavy, med, light, long)
		log_admin("[key_name(user)] created an EM Pulse ([heavy],[med],[light],[long]) at [AREACOORD(orignator)]")
		message_admins("[key_name_admin(user)] created an EM PUlse ([heavy],[med],[light],[long]) at [AREACOORD(orignator)]")
		feedback_add_details("admin_verb","EM Pulse") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(gib_them, R_ADMIN, "Gib", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/victim in mob_list)
	var/confirm = tgui_alert(user, "You sure?", "Confirm", list("Yes", "No"))
	if(confirm != "Yes")
		return
	//Due to the delay here its easy for something to have happened to the mob
	if(isnull(victim))
		return

	log_admin("[key_name(user)] has gibbed [key_name(victim)]")
	message_admins("[key_name_admin(user)] has gibbed [key_name_admin(victim)]")
	feedback_add_details("admin_verb", "Gib") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(isobserver(victim))
		gibs(victim.loc)
		return

	var/mob/living/living_victim = victim
	if (istype(living_victim))
		living_victim.gib()

ADMIN_VERB(gib_self, R_ADMIN, "Gibself", "Give yourself the same treatment you give others.", ADMIN_CATEGORY_FUN)
	var/confirm = tgui_alert(user, "You sure?", "Confirm", list("Yes", "No"))
	if(confirm != "Yes")
		return

	log_admin("[key_name(user)] used gibself.")
	message_admins(span_blue("[key_name_admin(user)] used gibself."))
	feedback_add_details("admin_verb", "Gib Self") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	var/mob/living/ourself = user.mob
	if (istype(ourself))
		ourself.gib()
