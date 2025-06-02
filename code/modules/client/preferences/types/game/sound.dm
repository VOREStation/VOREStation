/datum/preference/toggle/play_admin_midis
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_MIDI"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/play_lobby_music
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_LOBBY"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/play_lobby_music/apply_to_client(client/client, value)
	if(value)
		client?.playtitlemusic()
	else
		client?.media?.stop_music()

/datum/preference/toggle/play_ambience
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_AMBIENCE"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/play_ambience/apply_to_client(client/client, value)
	if(!value)
		client << sound(null, repeat = 0, wait = 0, volume = 0, channel = CHANNEL_AMBIENCE_FORCED)
		client << sound(null, repeat = 0, wait = 0, volume = 0, channel = CHANNEL_AMBIENCE)

/datum/preference/toggle/play_jukebox
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_JUKEBOX"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/play_jukebox/apply_to_client(client/client, value)
	if(value)
		client?.mob?.update_music()
	else
		client?.mob?.stop_all_music()

/datum/preference/toggle/instrument_toggle
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_INSTRUMENT"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/emote_noises
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "EMOTE_NOISES"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/radio_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "RADIO_SOUNDS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/say_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SAY_SOUNDS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/emote_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "EMOTE_SOUNDS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/whisper_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "WHISPER_SOUNDS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/subtle_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SUBTLE_SOUNDS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/air_pump_noise
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_AIRPUMP"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/old_door_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_OLDDOORS"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/department_door_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_DEPARTMENTDOORS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/pickup_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_PICKED"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/drop_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_DROPPED"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/weather_sounds
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_WEATHER"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/supermatter_hum
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_SUPERMATTER"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/play_mentorhelp_ping
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_MENTORHELP"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/numeric/ambience_freq
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ambience_freq"
	savefile_identifier = PREFERENCE_PLAYER
	minimum = 0
	maximum = 60

/datum/preference/numeric/ambience_freq/create_default_value()
	return 5

/datum/preference/numeric/ambience_chance
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ambience_chance"
	savefile_identifier = PREFERENCE_PLAYER
	minimum = 0
	maximum = 100

/datum/preference/numeric/ambience_chance/create_default_value()
	return 35

// Volume channels
/datum/preference/volume_channels
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "volume_channels"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/volume_channels/pref_deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return list()

	for(var/channel in input)
		if(!(channel in GLOB.all_volume_channels))
			// Channel no longer exists, yeet
			input -= channel

	for(var/channel in GLOB.all_volume_channels)
		if(!(channel in input))
			input["[channel]"] = 1
		else
			input["[channel]"] = clamp(input["[channel]"], 0, 2)

	return input

/datum/preference/volume_channels/is_valid(value)
	return islist(value)

/datum/preference/volume_channels/create_default_value()
	return list()

/mob/proc/get_preference_volume_channel(volume_channel)
	if(!client)
		return 0
	return client.get_preference_volume_channel(volume_channel)

/client/proc/get_preference_volume_channel(volume_channel)
	if(!volume_channel || !prefs)
		return 1

	var/list/volume_channels = prefs.read_preference(/datum/preference/volume_channels)
	return volume_channels["[volume_channel]"]

// Neat little volume adjuster thing in case you don't wanna touch preferences by hand you lazy fuck
/datum/volume_panel
/datum/volume_panel/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/volume_panel/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VolumePanel", "Volume Panel")
		ui.open()

/datum/volume_panel/tgui_data(mob/user)
	if(!user.client || !user.client.prefs)
		return list("error" = TRUE)

	var/list/data = ..()
	data["volume_channels"] = user.client.prefs.read_preference(/datum/preference/volume_channels)
	return data

/datum/volume_panel/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	if(!ui.user?.client?.prefs)
		return TRUE

	var/datum/preferences/P = ui.user.client.prefs
	var/list/volume_channels = P.read_preference(/datum/preference/volume_channels)

	switch(action)
		if("adjust_volume")
			var/channel = params["channel"]
			if(channel in volume_channels)
				volume_channels["[channel]"] = clamp(params["vol"], 0, 2)
				P.write_preference_by_type(/datum/preference/volume_channels, volume_channels)
				return TRUE

/client/verb/volume_panel()
	set name = "Volume Panel"
	set category = "Preferences.Sounds"
	set desc = "Allows you to adjust volume levels on the fly."

	if(!volume_panel)
		volume_panel = new(src)

	volume_panel.tgui_interact(mob)

// Jukebox volume
/datum/preference/numeric/living/jukebox_volume
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "media_volume"
	savefile_identifier = PREFERENCE_PLAYER

	minimum = 0
	maximum = 100
	step = 1

/datum/preference/numeric/living/jukebox_volume/apply_to_client_updated(client/client, value)
	client?.media?.update_volume(value)
