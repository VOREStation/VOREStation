/datum/tgui_module/player_notes
	name = "Player Notes"
	tgui_id = "PlayerNotes"

/datum/tgui_module/player_notes/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/tgui_module/player_notes/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return

/datum/tgui_module/player_notes/tgui_data(mob/user)
	var/data[0]

	return data
