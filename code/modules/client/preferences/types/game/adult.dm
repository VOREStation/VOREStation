/datum/preference/toggle/tummy_sprites
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "VISIBLE_TUMMIES"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = TRUE //it IS a vore server

/datum/preference/toggle/tummy_sprites/apply_to_client_updated(client/client, value)
	client.mob.recalculate_vis()
	. = ..()

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

/datum/preference/toggle/vore_health_bars
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "VORE_HEALTH_BARS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER
