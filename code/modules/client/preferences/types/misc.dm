/// Whether or not to toggle ambient occlusion, the shadows around people
/datum/preference/toggle/ambient_occlusion
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "AMBIENT_OCCLUSION_PREF"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/ambient_occlusion/apply_to_client(client/client, value)
	var/datum/plane_holder/PH = client?.mob?.plane_holder
	if(PH)
		PH.set_ao(VIS_OBJS, value)
		PH.set_ao(VIS_MOBS, value)

/datum/preference/toggle/mob_tooltips
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "MOB_TOOLTIPS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/inv_tooltips
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "INV_TOOLTIPS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/attack_icons
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ATTACK_ICONS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/precision_placement
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "PRECISE_PLACEMENT"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/hotkeys_default
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "HUD_HOTKEYS"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_progress_bar
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SHOW_PROGRESS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/safefiring
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SAFE_FIRING"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/status_indicators
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SHOW_STATUS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/status_indicators/apply_to_client(client/client, value)
	var/datum/plane_holder/PH = client?.mob?.plane_holder
	if(PH)
		PH.set_vis(VIS_STATUS, value)

/datum/preference/toggle/auto_afk
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "AUTO_AFK"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER
