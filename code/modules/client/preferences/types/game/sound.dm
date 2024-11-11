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

// Vorey sounds
/datum/preference/toggle/belch_noises // Belching noises - pref toggle for 'em
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "BELCH_NOISES"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/eating_noises
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "EATING_NOISES"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/digestion_noises
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "DIGEST_NOISES"
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
