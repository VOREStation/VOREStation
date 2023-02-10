var/list/_client_preferences
var/list/_client_preferences_by_key
var/list/_client_preferences_by_type

/proc/get_client_preferences()
	if(!_client_preferences)
		_client_preferences = list()
		for(var/datum/client_preference/client_type as anything in subtypesof(/datum/client_preference))
			if(initial(client_type.description))
				_client_preferences += new client_type()
	return _client_preferences

/proc/get_client_preference(var/datum/client_preference/preference)
	if(istype(preference))
		return preference
	if(ispath(preference))
		return get_client_preference_by_type(preference)
	return get_client_preference_by_key(preference)

/proc/get_client_preference_by_key(var/preference)
	if(!_client_preferences_by_key)
		_client_preferences_by_key = list()
		for(var/datum/client_preference/client_pref as anything in get_client_preferences())
			_client_preferences_by_key[client_pref.key] = client_pref
	return _client_preferences_by_key[preference]

/proc/get_client_preference_by_type(var/preference)
	if(!_client_preferences_by_type)
		_client_preferences_by_type = list()
		for(var/datum/client_preference/client_pref as anything in get_client_preferences())
			_client_preferences_by_type[client_pref.type] = client_pref
	return _client_preferences_by_type[preference]

/datum/client_preference
	var/description
	var/key
	var/enabled_by_default = TRUE
	var/enabled_description = "Yes"
	var/disabled_description = "No"

/datum/client_preference/proc/may_toggle(var/mob/preference_mob)
	return TRUE

/datum/client_preference/proc/toggled(var/mob/preference_mob, var/enabled)
	return

/*********************
* Player Preferences *
*********************/

/datum/client_preference/play_admin_midis
	description ="Play admin midis"
	key = "SOUND_MIDI"

/datum/client_preference/play_lobby_music
	description ="Play lobby music"
	key = "SOUND_LOBBY"

/datum/client_preference/play_lobby_music/toggled(var/mob/preference_mob, var/enabled)
	if(!preference_mob.client || !preference_mob.client.media)
		return

	if(enabled)
		preference_mob.client.playtitlemusic()
	else
		preference_mob.client.media.stop_music()

/datum/client_preference/play_ambiance
	description ="Play ambience"
	key = "SOUND_AMBIENCE"

/datum/client_preference/play_ambiance/toggled(var/mob/preference_mob, var/enabled)
	if(!enabled)
		preference_mob << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		preference_mob << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
//VOREStation Add - Need to put it here because it should be ordered riiiight here.
/datum/client_preference/play_jukebox
	description ="Play jukebox music"
	key = "SOUND_JUKEBOX"

/datum/client_preference/play_jukebox/toggled(var/mob/preference_mob, var/enabled)
	if(!enabled)
		preference_mob.stop_all_music()
	else
		preference_mob.update_music()

/datum/client_preference/eating_noises
	description = "Eating Noises"
	key = "EATING_NOISES"
	enabled_description = "Noisy"
	disabled_description = "Silent"

/datum/client_preference/digestion_noises
	description = "Digestion Noises"
	key = "DIGEST_NOISES"
	enabled_description = "Noisy"
	disabled_description = "Silent"

/datum/client_preference/belch_noises // Belching noises - pref toggle for 'em
	description = "Burping"
	key = "BELCH_NOISES"
	enabled_description = "Noisy"
	disabled_description = "Silent"

/datum/client_preference/emote_noises
	description = "Emote Noises" //MERP
	key = "EMOTE_NOISES"
	enabled_description = "Noisy"
	disabled_description = "Silent"
/datum/client_preference/whisubtle_vis
	description = "Whi/Subtles Ghost Visible"
	key = "WHISUBTLE_VIS"
	enabled_description = "Visible"
	disabled_description = "Hidden"
	enabled_by_default = FALSE
//VOREStation Add End
/datum/client_preference/weather_sounds
	description ="Weather sounds"
	key = "SOUND_WEATHER"
	enabled_description = "Audible"
	disabled_description = "Silent"

/datum/client_preference/supermatter_hum
	description ="Supermatter hum"
	key = "SOUND_SUPERMATTER"
	enabled_description = "Audible"
	disabled_description = "Silent"

/datum/client_preference/ghost_ears
	description ="Ghost ears"
	key = "CHAT_GHOSTEARS"
	enabled_description = "All Speech"
	disabled_description = "Nearby"

/datum/client_preference/ghost_sight
	description ="Ghost sight"
	key = "CHAT_GHOSTSIGHT"
	enabled_description = "All Emotes"
	disabled_description = "Nearby"

/datum/client_preference/ghost_radio
	description ="Ghost radio"
	key = "CHAT_GHOSTRADIO"
	enabled_description = "All Chatter"
	disabled_description = "Nearby"

/datum/client_preference/chat_tags
	description ="Chat tags"
	key = "CHAT_SHOWICONS"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/air_pump_noise
	description ="Air Pump Ambient Noise"
	key = "SOUND_AIRPUMP"
	enabled_description = "Audible"
	disabled_description = "Silent"

/datum/client_preference/old_door_sounds
	description ="Old Door Sounds"
	key = "SOUND_OLDDOORS"
	enabled_description = "Old"
	disabled_description = "New"

/datum/client_preference/department_door_sounds
	description ="Department-Specific Door Sounds"
	key = "SOUND_DEPARTMENTDOORS"
	enabled_description = "Enabled"
	disabled_description = "Disabled"

/datum/client_preference/pickup_sounds
	description = "Picked Up Item Sounds"
	key = "SOUND_PICKED"
	enabled_description = "Enabled"
	disabled_description = "Disabled"

/datum/client_preference/drop_sounds
	description = "Dropped Item Sounds"
	key = "SOUND_DROPPED"
	enabled_description = "Enabled"
	disabled_description = "Disabled"

/datum/client_preference/mob_tooltips
	description ="Mob tooltips"
	key = "MOB_TOOLTIPS"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/inv_tooltips
	description ="Inventory tooltips"
	key = "INV_TOOLTIPS"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/attack_icons
	description ="Attack icons"
	key = "ATTACK_ICONS"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/precision_placement
	description ="Precision Placement"
	key = "PRECISE_PLACEMENT"
	enabled_description = "Active"
	disabled_description = "Inactive"

/datum/client_preference/hotkeys_default
	description ="Hotkeys Default"
	key = "HUD_HOTKEYS"
	enabled_description = "Enabled"
	disabled_description = "Disabled"
	enabled_by_default = FALSE // Backwards compatibility

/datum/client_preference/show_typing_indicator
	description ="Typing indicator"
	key = "SHOW_TYPING"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/show_typing_indicator/toggled(var/mob/preference_mob, var/enabled)
	if(!enabled)
		preference_mob.set_typing_indicator(FALSE)

/datum/client_preference/show_ooc
	description ="OOC chat"
	key = "CHAT_OOC"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/show_looc
	description ="LOOC chat"
	key = "CHAT_LOOC"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/show_dsay
	description ="Dead chat"
	key = "CHAT_DEAD"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/check_mention
	description ="Emphasize Name Mention"
	key = "CHAT_MENTION"
	enabled_description = "Emphasize"
	disabled_description = "Normal"

/datum/client_preference/show_progress_bar
	description ="Progress Bar"
	key = "SHOW_PROGRESS"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/safefiring
	description = "Gun Firing Intent Requirement"
	key = "SAFE_FIRING"
	enabled_description = "Safe"
	disabled_description = "Dangerous"

/datum/client_preference/browser_style
	description = "Fake NanoUI Browser Style"
	key = "BROWSER_STYLED"
	enabled_description = "Fancy"
	disabled_description = "Plain"

/datum/client_preference/ambient_occlusion
	description = "Fake Ambient Occlusion"
	key = "AMBIENT_OCCLUSION_PREF"
	enabled_by_default = FALSE
	enabled_description = "On"
	disabled_description = "Off"

/datum/client_preference/ambient_occlusion/toggled(var/mob/preference_mob, var/enabled)
	. = ..()
	if(preference_mob && preference_mob.plane_holder)
		var/datum/plane_holder/PH = preference_mob.plane_holder
		PH.set_ao(VIS_OBJS, enabled)
		PH.set_ao(VIS_MOBS, enabled)

/datum/client_preference/instrument_toggle
	description ="Hear In-game Instruments"
	key = "SOUND_INSTRUMENT"

/datum/client_preference/vchat_enable
	description = "Enable/Disable VChat"
	key = "VCHAT_ENABLE"
	enabled_description =  "Enabled"
	disabled_description = "Disabled"

/datum/client_preference/status_indicators
	description = "Status Indicators"
	key = "SHOW_STATUS"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/radio_sounds
	description = "Radio Sounds"
	key = "RADIO_SOUNDS"
	enabled_description = "On"
	disabled_description = "Off"

/datum/client_preference/say_sounds
	description = "Say Sounds"
	key = "SAY_SOUNDS"
	enabled_description = "On"
	disabled_description = "Off"

/datum/client_preference/emote_sounds
	description = "Me Sounds"
	key = "EMOTE_SOUNDS"
	enabled_description = "On"
	disabled_description = "Off"

/datum/client_preference/whisper_sounds
	description = "Whisper Sounds"
	key = "WHISPER_SOUNDS"
	enabled_description = "On"
	disabled_description = "Off"

/datum/client_preference/subtle_sounds
	description = "Subtle Sounds"
	key = "SUBTLE_SOUNDS"
	enabled_description = "On"
	disabled_description = "Off"

/datum/client_preference/runechat_mob
	description = "Runechat (Mobs)"
	key = "RUNECHAT_MOB"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/runechat_obj
	description = "Runechat (Objs)"
	key = "RUNECHAT_OBJ"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/runechat_border
	description = "Runechat Message Border"
	key = "RUNECHAT_BORDER"
	enabled_description = "Show"
	disabled_description = "Hide"
	enabled_by_default = TRUE

/datum/client_preference/runechat_long_messages
	description = "Runechat Message Length"
	key = "RUNECHAT_LONG"
	enabled_description = "Long"
	disabled_description = "Short"
	enabled_by_default = FALSE

/datum/client_preference/status_indicators/toggled(mob/preference_mob, enabled)
	. = ..()
	if(preference_mob && preference_mob.plane_holder)
		var/datum/plane_holder/PH = preference_mob.plane_holder
		PH.set_vis(VIS_STATUS, enabled)

/datum/client_preference/show_lore_news
	description = "Lore News Popup"
	key = "NEWS_POPUP"
	enabled_by_default = TRUE
	enabled_description = "Popup New On Login"
	disabled_description = "Do Nothing"

/datum/client_preference/play_mentorhelp_ping
	description = "Mentorhelps"
	key = "SOUND_MENTORHELP"
	enabled_description = "Hear"
	disabled_description = "Silent"

/datum/client_preference/player_tips
	description = "Receive Tips Periodically"
	key = "RECEIVE_TIPS"
	enabled_description = "Enabled"
	disabled_description = "Disabled"

/********************
* Staff Preferences *
********************/
/datum/client_preference/admin/may_toggle(var/mob/preference_mob)
	return check_rights(R_ADMIN|R_EVENT, 0, preference_mob)

/datum/client_preference/mod/may_toggle(var/mob/preference_mob)
	return check_rights(R_MOD|R_ADMIN, 0, preference_mob)

/datum/client_preference/debug/may_toggle(var/mob/preference_mob)
	return check_rights(R_DEBUG|R_ADMIN, 0, preference_mob)

/datum/client_preference/mod/show_attack_logs
	description = "Attack Log Messages"
	key = "CHAT_ATTACKLOGS"
	enabled_description = "Show"
	disabled_description = "Hide"
	enabled_by_default = FALSE

/datum/client_preference/debug/show_debug_logs
	description = "Debug Log Messages"
	key = "CHAT_DEBUGLOGS"
	enabled_description = "Show"
	disabled_description = "Hide"
	enabled_by_default = FALSE

/datum/client_preference/admin/show_chat_prayers
	description = "Chat Prayers"
	key = "CHAT_PRAYER"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/holder/may_toggle(var/mob/preference_mob)
	return preference_mob && preference_mob.client && preference_mob.client.holder

/datum/client_preference/holder/play_adminhelp_ping
	description = "Adminhelps"
	key = "SOUND_ADMINHELP"
	enabled_description = "Hear"
	disabled_description = "Silent"

/datum/client_preference/holder/hear_radio
	description = "Radio chatter"
	key = "CHAT_RADIO"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/holder/show_rlooc
	description ="Remote LOOC chat"
	key = "CHAT_RLOOC"
	enabled_description = "Show"
	disabled_description = "Hide"

/datum/client_preference/holder/show_staff_dsay
	description ="Staff Deadchat"
	key = "CHAT_ADSAY"
	enabled_description = "Show"
	disabled_description = "Hide"
