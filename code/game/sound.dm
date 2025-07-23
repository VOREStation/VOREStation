/**
 * playsound is a proc used to play a 3D sound in a specific range. This uses SOUND_RANGE + extra_range to determine that.
 *
 * Arguments:
 * * source - Origin of sound.
 * * soundin - Either a file, or a string that can be used to get an SFX.
 * * vol - The volume of the sound, excluding falloff and pressure affection.
 * * vary - bool that determines if the sound changes pitch every time it plays.
 * * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE.
 * * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * * frequency - playback speed of audio.
 * * channel - The channel the sound is played at.
 * * pressure_affected - Whether or not difference in pressure affects the sound (E.g. if you can hear in space).
 * * ignore_walls - Whether or not the sound can pass through walls.
 * * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * preference - Sound preferences to check for this sound.
 */
/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff_exponent = SOUND_FALLOFF_EXPONENT, frequency = null, channel = 0, pressure_affected = TRUE, ignore_walls = TRUE, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, use_reverb = TRUE, preference = null, volume_channel = null)
	if(isarea(source))
		CRASH("playsound(): source is an area")

	if(islist(soundin))
		CRASH("playsound(): soundin attempted to pass a list! Consider using pick()")

	if(!soundin)
		CRASH("playsound(): no soundin passed")

	if(vol < SOUND_AUDIBLE_VOLUME_MIN) // never let sound go below SOUND_AUDIBLE_VOLUME_MIN or bad things will happen
		CRASH("playsound(): volume below SOUND_AUDIBLE_VOLUME_MIN. [vol] < [SOUND_AUDIBLE_VOLUME_MIN]")

	var/turf/turf_source = get_turf(source)
	if (!turf_source)
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	var/sound/S = isdatum(soundin) ? soundin : sound(get_sfx(soundin))
	var/maxdistance = SOUND_RANGE + extrarange
	//var/source_z = turf_source.z

	if(vary && !frequency)
		frequency = get_rand_frequency() // skips us having to do it per-sound later. should just make this a macro tbh

	/*
	var/list/listeners

	var/turf/above_turf = GET_TURF_ABOVE(turf_source)
	var/turf/below_turf = GET_TURF_BELOW(turf_source)

	var/audible_distance = CALCULATE_MAX_SOUND_AUDIBLE_DISTANCE(vol, maxdistance, falloff_distance, falloff_exponent)

	if(ignore_walls)
		listeners = get_hearers_in_range(audible_distance, turf_source, RECURSIVE_CONTENTS_CLIENT_MOBS)
		if(above_turf && istransparentturf(above_turf))
			listeners += get_hearers_in_range(audible_distance, above_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

		if(below_turf && istransparentturf(turf_source))
			listeners += get_hearers_in_range(audible_distance, below_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

	else //these sounds don't carry through walls
		listeners = get_hearers_in_view(audible_distance, turf_source, RECURSIVE_CONTENTS_CLIENT_MOBS)

		if(above_turf && istransparentturf(above_turf))
			listeners += get_hearers_in_view(audible_distance, above_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

		if(below_turf && istransparentturf(turf_source))
			listeners += get_hearers_in_view(audible_distance, below_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)
		for(var/mob/listening_ghost as anything in SSmobs.dead_players_by_zlevel[source_z])
			if(get_dist(listening_ghost, turf_source) <= audible_distance)
				listeners += listening_ghost

	for(var/mob/listening_mob in listeners)//had nulls sneak in here, hence the typecheck
		listening_mob.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb, preference, volume_channel)

	return listeners
	*/

	var/area/area_source = turf_source.loc
	var/list/listeners = GLOB.player_list.Copy()
	for(var/mob/M as anything in listeners)
		if(!M || !M.client)
			continue
		var/turf/T = get_turf(M)
		if(!T)
			continue
		var/area/A = T.loc
		if((A.flag_check(AREA_SOUNDPROOF) || area_source.flag_check(AREA_SOUNDPROOF)) && (A != area_source))
			continue
		//var/distance = get_dist(T, turf_source) Save get_dist for later because it's more expensive

		if(!T || T.z != turf_source.z) //^ +1
			continue
		if(get_dist(T, turf_source) > maxdistance)
			continue
		if(!ignore_walls && !can_see(turf_source, T, length = maxdistance * 2))
			continue

		SSmotiontracker.ping(source,vol) // Nearly everything pings this, the quieter the less likely
		M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb, preference, volume_channel)

/**
 * Plays a sound with a specific point of origin for src mob
 * Affected by pressure, distance, terrain and environment (see arguments)
 *
 * Arguments:
 * * turf_source - The turf our sound originates from, if this is not a turf, the sound is played with no spatial audio
 * * soundin - Either a file, or a string that can be used to get an SFX.
 * * vol - The volume of the sound, excluding falloff and pressure affection.
 * * vary - bool that determines if the sound changes pitch every time it plays.
 * * frequency - playback speed of audio.
 * * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * * channel - Optional: The channel the sound is played at.
 * * pressure_affected - bool Whether or not difference in pressure affects the sound (E.g. if you can hear in space).
 * * sound_to_use - Optional: Will default to soundin when absent
 * * max_distance - number, determines the maximum distance of our sound
 * * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * distance_multiplier - Default 1, multiplies the maximum distance of our sound
 * * use_reverb - bool default TRUE, determines if our sound has reverb
 * * preference - Sound preferences to check for this sound.
 */
/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent = SOUND_FALLOFF_EXPONENT, channel = 0, pressure_affected = TRUE, sound/sound_to_use, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE, preference, volume_channel = null)
	if(!client || ear_deaf > 0)
		return

	if(!check_sound_preference(preference))
		return

	if(!sound_to_use)
		sound_to_use = sound(get_sfx(soundin))

	sound_to_use.wait = 0 //No queue
	sound_to_use.channel = channel || SSsounds.random_available_channel()

	// I'm not sure if you can modify S.volume, but I'd rather not try to find out what
	// horrible things lurk in BYOND's internals, so we're just gonna do vol *=
	vol *= client.get_preference_volume_channel(volume_channel)
	vol *= client.get_preference_volume_channel(VOLUME_CHANNEL_MASTER)
	sound_to_use.volume = vol

	if(vary)
		if(frequency)
			sound_to_use.frequency = frequency
		else
			sound_to_use.frequency = get_rand_frequency()

	var/distance = 0

	if(isturf(turf_source))
		var/turf/turf_loc = get_turf(src)

		//sound volume falloff with distance
		distance = get_dist(turf_loc, turf_source) * distance_multiplier

		if(max_distance) //If theres no max_distance we're not a 3D sound, so no falloff.
			sound_to_use.volume -= CALCULATE_SOUND_VOLUME(vol, distance, max_distance, falloff_distance, falloff_exponent)

		if(pressure_affected)
			//Atmosphere affects sound
			var/pressure_factor = 1
			var/datum/gas_mixture/hearer_env = turf_loc.return_air()
			var/datum/gas_mixture/source_env = turf_source.return_air()

			if(hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
				if(pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //space
				pressure_factor = 0

			if(distance <= 1)
				pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

			sound_to_use.volume *= pressure_factor
			//End Atmosphere affecting sound

		if(sound_to_use.volume < SOUND_AUDIBLE_VOLUME_MIN)
			return //No sound

		var/dx = turf_source.x - turf_loc.x // Hearing from the right/left
		sound_to_use.x = dx * distance_multiplier
		var/dz = turf_source.y - turf_loc.y // Hearing from infront/behind
		sound_to_use.z = dz * distance_multiplier
		var/dy = (turf_source.z - turf_loc.z) * 5 * distance_multiplier // Hearing from  above / below, multiplied by 5 because we assume height is further along coords.
		sound_to_use.y = dy

		sound_to_use.falloff = max_distance || 1 //use max_distance, else just use 1 as we are a direct sound so falloff isnt relevant.

		// Sounds can't have their own environment. A sound's environment will be:
		// 1. the mob's
		// 2. the area's (defaults to SOUND_ENVRIONMENT_NONE)
		if(sound_environment_override != SOUND_ENVIRONMENT_NONE)
			sound_to_use.environment = sound_environment_override
		else
			var/area/A = get_area(src)
			sound_to_use.environment = A.sound_env

		if(!use_reverb || sound_to_use.environment == SOUND_ENVIRONMENT_NONE)
			sound_to_use.echo ||= new /list(18)
			sound_to_use.echo[3] = -10000
			sound_to_use.echo[4] = -10000

	if(HAS_TRAIT(src, TRAIT_SOUND_DEBUGGED))
		to_chat(src, span_admin("Max Range-[max_distance] Distance-[distance] Vol-[round(sound_to_use.volume, 0.01)] Sound-[sound_to_use.file]"))

	SEND_SOUND(src, sound_to_use)

/proc/sound_to_playing_players(soundin, volume = 100, vary = FALSE, frequency = 0, channel = 0, pressure_affected = FALSE, sound/S)
	if(!S)
		S = sound(get_sfx(soundin))
	for(var/m in GLOB.player_list)
		if(ismob(m) && !isnewplayer(m))
			var/mob/M = m
			M.playsound_local(M, null, volume, vary, frequency, null, channel, pressure_affected, S)

/mob/proc/check_sound_preference(list/preference)
	if(!islist(preference))
		preference = list(preference)

	for(var/p in preference)
		// Ignore nulls
		if(p)
			if(!read_preference(p))
				return FALSE

	return TRUE

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)

/client/proc/playtitlemusic()
	if(!ticker || !SSmedia_tracks.lobby_tracks.len || !media)
		return

	if(prefs?.read_preference(/datum/preference/toggle/play_lobby_music))
		var/datum/track/T = pick(SSmedia_tracks.lobby_tracks)
		media.push_music(T.url, world.time, 0.35)
		to_chat(src,span_notice("Lobby music: " + span_bold("[T.title]") + " by " + span_bold("[T.artist]") + "."))

///get a random frequency.
/proc/get_rand_frequency()
	return rand(32000, 55000)

///get_rand_frequency but lower range.
/proc/get_rand_frequency_low_range()
	return rand(38000, 45000)

///Used to convert a SFX define into a .ogg so we can add some variance to sounds. If soundin is already a .ogg, we simply return it
/proc/get_sfx(soundin)
	if(!istext(soundin))
		return soundin
	var/datum/sound_effect/sfx = GLOB.sfx_datum_by_key[soundin]
	return sfx?.return_sfx() || soundin

//Are these even used?	//Yes
GLOBAL_LIST_INIT(talk_sound, list('sound/talksounds/a.ogg','sound/talksounds/b.ogg','sound/talksounds/c.ogg','sound/talksounds/d.ogg','sound/talksounds/e.ogg','sound/talksounds/f.ogg','sound/talksounds/g.ogg','sound/talksounds/h.ogg'))

#define canine_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/scream/canine/wolf_scream.ogg', 'sound/voice/scream/canine/wolf_scream2.ogg', 'sound/voice/scream/canine/wolf_scream3.ogg', 'sound/voice/scream/canine/wolf_scream4.ogg', 'sound/voice/scream/canine/wolf_scream5.ogg', 'sound/voice/scream/canine/wolf_scream6.ogg'), "pain" = list('sound/voice/pain/canine/wolf_pain.ogg', 'sound/voice/pain/canine/wolf_pain2.ogg', 'sound/voice/pain/canine/wolf_pain3.ogg', 'sound/voice/pain/canine/wolf_pain4.ogg'), "gasp" = list('sound/voice/gasp/canine/wolf_gasp.ogg'), "death" = list('sound/voice/death/canine/wolf_death1.ogg', 'sound/voice/death/canine/wolf_death2.ogg', 'sound/voice/death/canine/wolf_death3.ogg', 'sound/voice/death/canine/wolf_death4.ogg', 'sound/voice/death/canine/wolf_death5.ogg'))
#define feline_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/scream/feline/feline_scream.ogg'), "pain" = list('sound/voice/pain/feline/feline_pain.ogg'), "gasp" = list('sound/voice/gasp/feline/feline_gasp.ogg'), "death" = list('sound/voice/death/feline/feline_death.ogg'))
#define cervine_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/scream/cervine/cervine_scream.ogg'), "pain" = null, "gasp" = null, "death" = list('sound/voice/death/cervine/cervine_death.ogg'))
#define robot_sounds list("cough" = list('sound/effects/mob_effects/m_machine_cougha.ogg', 'sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg'), "sneeze" = list('sound/effects/mob_effects/machine_sneeze.ogg'), "scream" = list('sound/voice/scream_silicon.ogg', 'sound/voice/android_scream.ogg', 'sound/voice/scream/robotic/robot_scream1.ogg', 'sound/voice/scream/robotic/robot_scream2.ogg', 'sound/voice/scream/robotic/robot_scream3.ogg'), "pain" = list('sound/voice/pain/robotic/robot_pain1.ogg', 'sound/voice/pain/robotic/robot_pain2.ogg', 'sound/voice/pain/robotic/robot_pain3.ogg'), "gasp" = null, "death" = list('sound/voice/borg_deathsound.ogg'))
#define male_generic_sounds list("cough" = list('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg'), "sneeze" = list('sound/effects/mob_effects/sneeze.ogg'), "scream" = list('sound/voice/scream/generic/male/male_scream_1.ogg', 'sound/voice/scream/generic/male/male_scream_2.ogg', 'sound/voice/scream/generic/male/male_scream_3.ogg', 'sound/voice/scream/generic/male/male_scream_4.ogg', 'sound/voice/scream/generic/male/male_scream_5.ogg', 'sound/voice/scream/generic/male/male_scream_6.ogg'), "pain" = list('sound/voice/pain/generic/male/male_pain_1.ogg', 'sound/voice/pain/generic/male/male_pain_2.ogg', 'sound/voice/pain/generic/male/male_pain_3.ogg', 'sound/voice/pain/generic/male/male_pain_4.ogg', 'sound/voice/pain/generic/male/male_pain_5.ogg', 'sound/voice/pain/generic/male/male_pain_6.ogg', 'sound/voice/pain/generic/male/male_pain_7.ogg', 'sound/voice/pain/generic/male/male_pain_8.ogg'), "gasp" = list('sound/voice/gasp/generic/male/male_gasp1.ogg', 'sound/voice/gasp/generic/male/male_gasp2.ogg', 'sound/voice/gasp/generic/male/male_gasp3.ogg'), "death" = list('sound/voice/death/generic/male/male_death_1.ogg', 'sound/voice/death/generic/male/male_death_2.ogg', 'sound/voice/death/generic/male/male_death_3.ogg', 'sound/voice/death/generic/male/male_death_4.ogg', 'sound/voice/death/generic/male/male_death_5.ogg', 'sound/voice/death/generic/male/male_death_6.ogg', 'sound/voice/death/generic/male/male_death_7.ogg'))
#define female_generic_sounds list("cough" = list('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg'), "sneeze" = list('sound/effects/mob_effects/f_sneeze.ogg'), "scream" = list('sound/voice/scream/generic/female/female_scream_1.ogg', 'sound/voice/scream/generic/female/female_scream_2.ogg', 'sound/voice/scream/generic/female/female_scream_3.ogg', 'sound/voice/scream/generic/female/female_scream_4.ogg', 'sound/voice/scream/generic/female/female_scream_5.ogg'), "pain" = list('sound/voice/pain/generic/female/female_pain_1.ogg', 'sound/voice/pain/generic/female/female_pain_2.ogg', 'sound/voice/pain/generic/female/female_pain_3.ogg'), "gasp" = list('sound/voice/gasp/generic/female/female_gasp1.ogg', 'sound/voice/gasp/generic/female/female_gasp2.ogg'), "death" = list('sound/voice/death/generic/female/female_death_1.ogg', 'sound/voice/death/generic/female/female_death_2.ogg', 'sound/voice/death/generic/female/female_death_3.ogg', 'sound/voice/death/generic/female/female_death_4.ogg', 'sound/voice/death/generic/female/female_death_5.ogg', 'sound/voice/death/generic/female/female_death_6.ogg'))
#define spider_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/spiderchitter.ogg'), "pain" = list('sound/voice/spiderchitter.ogg'), "gasp" = null, "death" = list('sound/voice/death/spider/spider_death.ogg'))
#define mouse_sounds list("cough" = list('sound/effects/mouse_squeak.ogg'), "sneeze" = list('sound/effects/mouse_squeak.ogg'), "scream" = list('sound/effects/mouse_squeak_loud.ogg'), "pain" = list('sound/effects/mouse_squeak.ogg'), "gasp" = list('sound/effects/mouse_squeak.ogg'), "death" = list('sound/effects/mouse_squeak_loud.ogg'))
#define lizard_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/effects/mob_effects/una_scream1.ogg','sound/effects/mob_effects/una_scream2.ogg'), "pain" = list('sound/voice/pain/lizard/lizard_pain.ogg'), "gasp" = null, "death" = list('sound/voice/death/lizard/lizard_death.ogg'))
#define vox_sounds list("cough" = list('sound/voice/shriekcough.ogg'), "sneeze" = list('sound/voice/shrieksneeze.ogg'), "scream" = list('sound/voice/shriek1.ogg'), "pain" = list('sound/voice/shriek1.ogg'), "gasp" = null, "death" = null)
#define slime_sounds list("cough" = list('sound/effects/slime_squish.ogg'), "sneeze" = null, "scream" = null, "pain" = null, "gasp" = null, "death" = null)
#define xeno_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/effects/mob_effects/x_scream1.ogg','sound/effects/mob_effects/x_scream2.ogg','sound/effects/mob_effects/x_scream3.ogg'), "pain" = list('sound/voice/pain/xeno/alien_roar1.ogg', 'sound/voice/pain/xeno/alien_roar2.ogg', 'sound/voice/pain/xeno/alien_roar3.ogg', 'sound/voice/pain/xeno/alien_roar4.ogg', 'sound/voice/pain/xeno/alien_roar5.ogg', 'sound/voice/pain/xeno/alien_roar6.ogg', 'sound/voice/pain/xeno/alien_roar7.ogg', 'sound/voice/pain/xeno/alien_roar8.ogg', 'sound/voice/pain/xeno/alien_roar9.ogg', 'sound/voice/pain/xeno/alien_roar10.ogg', 'sound/voice/pain/xeno/alien_roar11.ogg', 'sound/voice/pain/xeno/alien_roar12.ogg'), "gasp" = list('sound/voice/gasp/xeno/alien_hiss1.ogg'), "death" = list('sound/voice/death/xeno/xeno_death.ogg', 'sound/voice/death/xeno/xeno_death2.ogg'))
#define teshari_sounds list("cough" = list('sound/effects/mob_effects/tesharicougha.ogg','sound/effects/mob_effects/tesharicoughb.ogg'), "sneeze" = list('sound/effects/mob_effects/tesharisneeze.ogg'), "scream" = list('sound/effects/mob_effects/teshariscream.ogg'), "pain" = null, "gasp" = null, "death" = null)
#define raccoon_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/raccoon.ogg'), "pain" = list('sound/voice/raccoon.ogg'), "gasp" = null, "death" = list('sound/voice/raccoon.ogg'))
#define metroid_sounds list("cough" = list('sound/metroid/metroid_cough.ogg'), "sneeze" = list('sound/metroid/metroid_sneeze.ogg'), "scream" = list('sound/metroid/metroid_scream.ogg'), "pain" = list('sound/metroid/metroidsee.ogg'), "gasp" = list('sound/metroid/metroid_gasp.ogg'), "death" = list('sound/metroid/metroiddeath.ogg'))
#define vulpine_sounds list("cough" = null, "sneeze" = null, "scream" = list('sound/voice/scream/vulpine/fox_yip1.ogg', 'sound/voice/scream/vulpine/fox_yip2.ogg', 'sound/voice/scream/vulpine/fox_yip3.ogg'), "pain" = list('sound/voice/pain/vulpine/fox_pain1.ogg', 'sound/voice/pain/vulpine/fox_pain2.ogg', 'sound/voice/pain/vulpine/fox_pain3.ogg', 'sound/voice/pain/vulpine/fox_pain4.ogg'), "gasp" = list('sound/voice/gasp/canine/wolf_gasp.ogg'), "death" = list('sound/voice/death/canine/wolf_death1.ogg', 'sound/voice/death/canine/wolf_death2.ogg', 'sound/voice/death/canine/wolf_death3.ogg', 'sound/voice/death/canine/wolf_death4.ogg', 'sound/voice/death/canine/wolf_death5.ogg'))
#define no_sounds list("cough" = null, "sneeze" = null, "scream" = null, "pain" = null, "gasp" = null, "death" = null)
#define use_default list("cough" = null, "sneeze" = null, "scream" = null, "pain" = null, "gasp" = null, "death" = null)
/*
 * TBD Sound Defines below
*/
/*
#define avian_sounds list(
	"scream" = list(),
	"pain" = list(),
	"gasp" = list(),
	"death" = list()
)
#define slime_sounds list(
	"scream" = list(),
	"pain" = list(),
	"gasp" = list(),
	"death" = list()
)
#define vulpine_sounds list(
	"scream" = list(),
	"pain" = list(),
	"gasp" = list(),
	"death" = list()
)
#define lizard_sounds list(
	"scream" = list(),
	"pain" = list(),
	"gasp" = list(),
	"death" = list()
)
*/

// Not sure we even really need this
// var/list/species_sounds = list()

// Global list containing all of our sound options.
var/list/species_sound_map = list(
	"Canine" = canine_sounds,
	"Cervine" = cervine_sounds,
	"Feline" = feline_sounds,
	"Human Male" = male_generic_sounds,
	"Human Female" = female_generic_sounds,
	"Lizard" = lizard_sounds,
	"Metroid" = metroid_sounds,
	"Mouse" = mouse_sounds,
	"Raccoon" = raccoon_sounds,
	"Robotic" = robot_sounds,
	"Slime" = slime_sounds,
	"Spider" = spider_sounds,
	"Teshari" = teshari_sounds,
	"Vox" = vox_sounds,
	"Vulpine" = vulpine_sounds,
	"Xeno" = xeno_sounds,
	"None" = no_sounds,
	"Unset" = use_default
)

/* // Not sure we even really need this
/hook/startup/proc/Init_species_sounds() // The entries we're checking over MUST have unique keys.
	for(var/i in species_sound_map)
		species_sounds |= species_sound_map[i]
	return 1
*/

/*
 * Call this for when you need a sound from an already-identified list - IE, "Canine". pick() cannot parse procs.
 * Indexes must be pre-calculated by the time it reaches here - for instance;
 * var/mob/living/M = user
 * get_species_sound(M.client.pref.species_sound)["scream"] will return get_species_sound("Robotic")["scream"]
 * This can be paired with get_gendered_sound, like so: get_species_sound(get_gendered_sound(M))["emote"] <- get_gendered_sound will return whatever we have of the 3 valid options, and then get_species_sound will match that to the actual sound list.
 * The get_species_sound proc will retrieve and return the list based on the key given - get_species_sound("Robotic")["scream"] will return list('sound/voice/scream_silicon.ogg', 'sound/voice/android_scream.ogg', etc)
 * If you are adding new calls of this, follow the syntax of get_species_sound(species)["scream"] - you must attach ["emote"] to the end, outside the ()
 * If your species has a gendered sound, DON'T PANIC. Simply set the gender_specific_species_sounds var on the species to true, and when you call this, do it like so:
 * get_species_sound(H.species.species_sounds_male)["emote"] // If we're male, and want an emote sound gendered correctly.
*/
/proc/get_species_sound(var/sounds)
	if(!islist(species_sound_map[sounds])) // We check here if this list actually has anything in it, or if we're about to return a null index
		return null // Shitty failsafe but better than rewriting an entire litany of procs rn when I'm low on time - Rykka // list('sound/voice/silence.ogg')
	return species_sound_map[sounds] // Otherwise, successfully return our sound

/*
 * The following helper proc will select a species' default sounds - useful for if we're set to "Unset"
 * This is ONLY called by Unset, meaning we haven't chosen a species sound.
*/
/proc/select_default_species_sound(var/datum/preferences/pref) // Called in character setup. This is similar to check_gendered_sounds, except here we pull from the prefs.
	// First, we determine if we're custom-choosing a body or if we're a base game species.
	var/datum/species/valid = GLOB.all_species[pref.species]
	if(valid.selects_bodytype == (SELECTS_BODYTYPE_CUSTOM || SELECTS_BODYTYPE_SHAPESHIFTER)) // Custom species or xenochimera handling here
		valid = coalesce(GLOB.all_species[pref.custom_base], GLOB.all_species[pref.species])
	// Now we start getting our sounds.
	if(valid.gender_specific_species_sounds) // Do we have gender-specific sounds?
		if(pref.identifying_gender == FEMALE && valid.species_sounds_female)
			return valid.species_sounds_female
		else if(pref.identifying_gender == MALE && valid.species_sounds_male)
			return valid.species_sounds_male
		else // Failsafe. Update if there's ever gendered sounds for HERM/Neuter/etc
			return valid.species_sounds
	else
		return valid.species_sounds

/proc/get_gendered_sound(var/mob/living/user) // Called anywhere we need gender-specific species sounds. Gets the gender-specific sound if one exists, but otherwise, will return the species-generic sound list.
	var/mob/living/carbon/human/H = user
	if(ishuman(H))
		if(H.species.gender_specific_species_sounds) // Do we have gender-specific sounds?
			if(H.identifying_gender == FEMALE && H.species.species_sounds_female)
				return H.species.species_sounds_female
			else if(H.identifying_gender == MALE && H.species.species_sounds_male)
				return H.species.species_sounds_male
			else // Failsafe. Update if there's ever gendered sounds for HERM/Neuter/etc
				return H.species.species_sounds
		else
			return H.species.species_sounds
	else
		return user.species_sounds
