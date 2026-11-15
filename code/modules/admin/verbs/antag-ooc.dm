/client/proc/aooc(msg as text)
	set category = "OOC.Chat"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	var/is_antag = mob.mind?.special_role

	if(!is_antag) // Non-antagonists and non-admins have no business using this.
		to_chat(src, span_warning("Sorry, but only certain antagonists or administrators can use this verb."))
		return

	var/datum/antagonist/antag_datum = SSantag_job.get_antag_data(src.mob.mind.special_role)
	if(!(antag_datum?.can_speak_aooc) || !antag_datum.can_hear_aooc)
		to_chat(src, span_warning("Sorry, but your antagonist type is not allowed to speak in AOOC."))
		return

	msg = sanitize(msg)
	if(!msg)
		return

	perform_aooc(msg)

ADMIN_VERB(admin_aooc, R_ADMIN|R_MOD|R_EVENT, "Admin AOOC", "Send a message to antagonist OOC.", ADMIN_CATEGORY_CHAT, msg as text)
	msg = sanitize(msg)
	if(!msg)
		return

	user.perform_aooc(msg)

/client/proc/perform_aooc(msg)
	// Name shown to admins.
	var/display_name = src.key
	if(holder?.fakekey)
		display_name = holder.fakekey

	// Name shown to other players.  Admins whom are not also antags have their rank displayed.
	var/player_display = (check_rights_for(src, R_ADMIN|R_MOD|R_EVENT) && !(mob.mind?.special_role)) ? "[display_name]([holder.rank_names()])" : display_name

	for(var/mob/target_mob in GLOB.mob_list)
		if(check_rights_for(target_mob.client, R_ADMIN|R_MOD|R_EVENT)) // Staff can see AOOC unconditionally, and with more details.
			to_chat(target_mob, span_ooc(span_aooc("[create_text_tag("aooc", "Antag-OOC:", target_mob.client)] <EM>[get_options_bar(src, 0, 1, 1)]([admin_jump_link(src.mob, check_rights_for(target_mob.client, R_HOLDER))]):</EM> " + span_message("[msg]"))))
			continue
		if(target_mob.client) // Players can only see AOOC if observing, or if they are an antag type allowed to use AOOC.
			var/datum/antagonist/antag_datum = null
			if(target_mob.mind) // Observers don't have minds, but they should still see AOOC.
				antag_datum = SSantag_job.get_antag_data(target_mob.mind.special_role)
			if((target_mob.mind?.special_role && antag_datum?.can_hear_aooc) || isobserver(target_mob)) // Antags must have their type be allowed to AOOC to see AOOC.  This prevents, say, ERT from seeing AOOC.
				to_chat(target_mob, span_ooc(span_aooc("[create_text_tag("aooc", "Antag-OOC:", target_mob.client)] <EM>[player_display]:</EM> " + span_message("[msg]"))))

	mob.log_talk("(AOOC) [msg]", LOG_OOC, color="#ff0000")
