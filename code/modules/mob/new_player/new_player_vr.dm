/mob/new_player/proc/spawn_checks_vr(var/rank)
	var/pass = TRUE
	var/datum/job/J = SSjob.get_job(rank)

	if(!J)
		log_debug("Couldn't find job: [rank] for spawn_checks_vr, panic-returning that it's fine to spawn.")
		return TRUE

	//No Flavor Text
	if (config.require_flavor && !client?.prefs?.flavor_texts["general"] && !(J.mob_type & JOB_SILICON))
		to_chat(src,"<span class='warning'>Please set your general flavor text to give a basic description of your character. Set it using the 'Set Flavor text' button on the 'General' tab in character setup, and choosing 'General' category.</span>")
		pass = FALSE

	//No OOC notes
	if (config.allow_Metadata && (!client?.prefs?.metadata || length(client.prefs.metadata) < 15))
		to_chat(src,"<span class='warning'>Please set informative OOC notes related to RP/ERP preferences. Set them using the 'OOC Notes' button on the 'General' tab in character setup.</span>")
		pass = FALSE

	//Are they on the VERBOTEN LIST?
	if (prevent_respawns.Find(client?.prefs?.real_name))
		to_chat(src,"<span class='warning'>You've already quit the round as this character. You can't go back now that you've free'd your job slot. Play another character, or wait for the next round.</span>")
		pass = FALSE

	//Do they have their scale properly setup?
	if(!client?.prefs?.size_multiplier)
		pass = FALSE
		to_chat(src,"<span class='warning'>You have not set your scale yet. Do this on the VORE tab in character setup.</span>")

	//Can they play?
	if(!is_alien_whitelisted(src,GLOB.all_species[client?.prefs?.species]) && !check_rights(R_ADMIN, 0))
		pass = FALSE
		to_chat(src,"<span class='warning'>You are not allowed to spawn in as this species.</span>")

	//Custom species checks
	if (client?.prefs?.species == "Custom Species")

		//Didn't name it
		if(!client?.prefs?.custom_species)
			pass = FALSE
			to_chat(src,"<span class='warning'>You have to name your custom species. Do this on the VORE tab in character setup.</span>")

		//Check traits/costs
		var/list/megalist = client.prefs.pos_traits + client.prefs.neu_traits + client.prefs.neg_traits
		var/points_left = client.prefs.starting_trait_points
		var/traits_left = client.prefs.max_traits
		var/pref_synth = client.prefs.dirty_synth
		var/pref_meat = client.prefs.gross_meatbag
		for(var/datum/trait/T as anything in megalist)
			var/cost = traits_costs[T]

			if(cost)
				traits_left--

			//A trait was removed from the game
			if(isnull(cost))
				pass = FALSE
				to_chat(src,"<span class='warning'>Your custom species is not playable. One or more traits appear to have been removed from the game or renamed. Enter character setup to correct this.</span>")
				break
			else
				points_left -= traits_costs[T]

			var/take_flags = initial(T.can_take)
			if((pref_synth && !(take_flags & SYNTHETICS)) || (pref_meat && !(take_flags & ORGANICS)))
				pass = FALSE
				to_chat(src, "<span class='warning'>Some of your traits are not usable by your character type (synthetic traits on organic, or vice versa).</span>")

		//Went into negatives
		if(points_left < 0 || traits_left < 0)
			pass = FALSE
			to_chat(src,"<span class='warning'>Your custom species is not playable. Reconfigure your traits on the VORE tab.</span>")

	//Final popup notice
	if (!pass)
		tgui_alert_async(src,"There were problems with spawning your character. Check your message log for details.","Error")
	return pass