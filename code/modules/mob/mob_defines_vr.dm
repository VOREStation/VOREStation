/mob
	var/vantag_hud = 0			// Do I have the HUD enabled?
	var/mob/temporary_form		// For holding onto a temporary form

	var/disconnect_time = null		//Time of client loss, set by Logout(), for timekeeping

	var/obj/screen/shadekin/shadekin_display = null
	var/obj/screen/xenochimera/danger_level/xenochimera_danger_display = null

	var/size_multiplier = 1 //multiplier for the mob's icon size
	var/accumulated_rads = 0 	// For radiation stuff.
	var/faction_bump_vore = FALSE	// Don't bump nom mobs of the same faction

/mob/drop_location()
	if(temporary_form)
		return temporary_form.drop_location()
	return ..()
