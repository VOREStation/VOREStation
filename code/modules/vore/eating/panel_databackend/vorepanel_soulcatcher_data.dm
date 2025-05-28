#define INTERIOR_DESIGN "Interior Design"
#define CAPTURE_MESSAGE "Capture Message"
#define TRANSIT_MESSAGE "Transit Message"
#define TRANSFER_MESSAGE "Transfer Message"
#define RELEASE_MESSAGE "Release Message"
#define DELETE_MESSAGE "Delete Message"


/datum/vore_look/proc/get_soulcatcher_data(mob/owner)
	if(!owner.soulgem)
		return null

	var/list/stored_souls = list()
	for(var/soul in owner.soulgem.brainmobs)
		var/list/info = list("displayText" = "[soul]", "value" = "\ref[soul]")
		stored_souls.Add(list(info))
	var/list/soulcatcher_data = list(
		"active" = owner.soulgem.flag_check(SOULGEM_ACTIVE),
		"name" = owner.soulgem.name,
		"caught_souls" = stored_souls,
		"selected_soul" = owner.soulgem.selected_soul,
		"selected_sfx" = owner.soulgem.linked_belly,
		"sc_message_data" =  compile_soulcatcher_message_data(owner.soulgem),
		"taken_over" = owner.soulgem.is_taken_over(),
		"catch_self" = owner.soulgem.flag_check(NIF_SC_CATCHING_ME),
		"catch_prey" = owner.soulgem.flag_check(NIF_SC_CATCHING_OTHERS),
		"catch_drain" = owner.soulgem.flag_check(SOULGEM_CATCHING_DRAIN),
		"catch_ghost" = owner.soulgem.flag_check(SOULGEM_CATCHING_GHOSTS),
		"ext_hearing" = owner.soulgem.flag_check(NIF_SC_ALLOW_EARS),
		"ext_vision" = owner.soulgem.flag_check(NIF_SC_ALLOW_EYES),
		"mind_backups" = owner.soulgem.flag_check(NIF_SC_BACKUPS),
		"sr_projecting" = owner.soulgem.flag_check(NIF_SC_PROJECTING),
		"show_vore_sfx" = owner.soulgem.flag_check(SOULGEM_SHOW_VORE_SFX),
		"see_sr_projecting" = owner.soulgem.flag_check(SOULGEM_SEE_SR_SOULS),
	)
	return soulcatcher_data

/datum/vore_look/proc/compile_soulcatcher_message_data(obj/soulgem/gem)
	if(!sc_message_subtab)
		sc_message_subtab = INTERIOR_DESIGN
	var/list/tab_data = list(
		"possible_messages" = list(INTERIOR_DESIGN, CAPTURE_MESSAGE, TRANSIT_MESSAGE, TRANSFER_MESSAGE, RELEASE_MESSAGE, DELETE_MESSAGE),
		"sc_subtab" = sc_message_subtab
		)
	if(sc_message_subtab == INTERIOR_DESIGN)
		tab_data["max_length"] = VORE_SC_DESC_MAX
		tab_data["active_message"] = gem.inside_flavor
		tab_data["set_action"] = SC_INTERIOR_MESSAGE
		tab_data["tooltip"] = "Displayed to prey after being 'caught' by the soulcatcher. This will be displayed after an intro set in the capture message. If you already have prey and change the interior, this will be displayed after the transit message."
	if(sc_message_subtab == CAPTURE_MESSAGE)
		tab_data["max_length"] = VORE_SC_MAX
		tab_data["active_message"] = gem.capture_message
		tab_data["set_action"] = SC_CAPTURE_MEESAGE
		tab_data["tooltip"] = "Change what the prey sees while being 'caught'. This will be printed before the iterior design to the prey."
	if(sc_message_subtab == TRANSIT_MESSAGE)
		tab_data["max_length"] = VORE_SC_MAX
		tab_data["active_message"] = gem.transit_message
		tab_data["set_action"] = SC_TRANSIT_MESSAGE
		tab_data["tooltip"] = "Change what the prey sees when you change the interior with them already captured."
	if(sc_message_subtab == TRANSFER_MESSAGE)
		tab_data["max_length"] = VORE_SC_MAX
		tab_data["active_message"] = gem.transfer_message
		tab_data["set_action"] = SC_TRANSFERE_MESSAGE
		tab_data["tooltip"] = "Change what the prey sees when they are transfered."
	if(sc_message_subtab == RELEASE_MESSAGE)
		tab_data["max_length"] = VORE_SC_MAX
		tab_data["active_message"] = gem.release_message
		tab_data["set_action"] = SC_RELEASE_MESSAGE
		tab_data["tooltip"] = "Change what the prey sees when they are released."
	if(sc_message_subtab == DELETE_MESSAGE)
		tab_data["max_length"] = VORE_SC_MAX
		tab_data["active_message"] = gem.delete_message
		tab_data["set_action"] = SC_DELETE_MESSAGE
		tab_data["tooltip"] = "Change what the prey sees when they are deleted."
	return tab_data

/datum/vore_look/proc/get_ability_data(mob/owner)
	var/list/abilities = list()

	var/nutri_value = 0
	if(isliving(owner))
		var/mob/living/H = owner
		nutri_value = H.nutrition

	abilities["nutrition"] = nutri_value
	abilities["size_change"] = list (
		"current_size" = owner.size_multiplier,
		"minimum_size" = owner.has_large_resize_bounds() ? RESIZE_MINIMUM_DORMS : RESIZE_MINIMUM,
		"maximum_size" = owner.has_large_resize_bounds() ? RESIZE_MAXIMUM_DORMS : RESIZE_MAXIMUM,
		"resize_cost" = VORE_RESIZE_COST
	)
	return abilities

#undef INTERIOR_DESIGN
#undef CAPTURE_MESSAGE
#undef TRANSIT_MESSAGE
#undef TRANSFER_MESSAGE
#undef RELEASE_MESSAGE
#undef DELETE_MESSAGE
