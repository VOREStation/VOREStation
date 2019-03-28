// Plays a sound at its location every so often.
/obj/effect/map_effect/interval/sound_emitter
	name = "sound emitter"
	icon_state = "sound_emitter"
	var/list/sounds_to_play = list(null) // List containing sound files or strings of sound groups.
	// A sound or string is picked randomly each run.

	var/sound_volume = 50 // How loud the sound is. 0 is silent, and 100 is loudest. Please be reasonable with the volume.
	// Note that things like vacuum may affect the volume heard by other mobs.

	var/sound_frequency_variance = TRUE // If the sound will sound somewhat different each time.
	// If a specific frequency is desired, sound_frequency must also be set.

	var/sound_extra_range = 0 // Set to make sounds heard from farther away than normal.

	var/sound_fallout = 0 // Within the 'fallout distance', the sound stays at the same volume, otherwise it attenuates.
	// Higher numbers make the sound fade out more slowly with distance.

	var/sound_global = FALSE // If true, sounds will not be distorted due to the current area's 'sound environment'.
	// It DOES NOT make the sound have a constant volume or z-level wide range, despite the misleading name.

	var/sound_frequency = null // Sets a specific custom frequency. sound_frequency_variance must be true as well.
	// If sound_frequency is null, but sound_frequency_variance is true, a semi-random frequency will be chosen to the sound each time.

	var/sound_channel = 0 // BYOND allows a sound to play in 1 through 1024 sound channels.
	// 0 will have BYOND give it the lowest available channel, it is not recommended to change this without a good reason.

	var/sound_pressure_affected = TRUE // If false, people in low pressure or vacuum will hear the sound.

	var/sound_ignore_walls = TRUE // If false, walls will completely muffle the sound.

	var/sound_preference = null // Player preference to check before playing this sound to them, if any.

/obj/effect/map_effect/interval/sound_emitter/trigger()
	playsound(
		src,
		pick(sounds_to_play),
		sound_volume,
		sound_frequency_variance,
		sound_extra_range,
		sound_fallout,
		sound_global,
		sound_frequency,
		sound_channel,
		sound_pressure_affected,
		sound_ignore_walls,
		sound_preference
		)
	..()

/obj/effect/map_effect/interval/sound_emitter/thunder
	sounds_to_play = list("thunder")
	interval_lower_bound = 10 SECONDS
	interval_upper_bound = 15 SECONDS

/obj/effect/map_effect/interval/sound_emitter/geiger
	sounds_to_play = list('sound/items/geiger/low1.ogg', 'sound/items/geiger/low2.ogg', 'sound/items/geiger/low3.ogg', 'sound/items/geiger/low4.ogg')
	interval_lower_bound = 1 SECOND
	interval_upper_bound = 1 SECOND

/obj/effect/map_effect/interval/sound_emitter/geiger/med
	sounds_to_play = list('sound/items/geiger/med1.ogg', 'sound/items/geiger/med2.ogg', 'sound/items/geiger/med3.ogg', 'sound/items/geiger/med4.ogg')

/obj/effect/map_effect/interval/sound_emitter/geiger/high
	sounds_to_play = list('sound/items/geiger/high1.ogg', 'sound/items/geiger/high2.ogg', 'sound/items/geiger/high3.ogg', 'sound/items/geiger/high4.ogg')

/obj/effect/map_effect/interval/sound_emitter/geiger/ext
	sounds_to_play = list('sound/items/geiger/ext1.ogg', 'sound/items/geiger/ext2.ogg', 'sound/items/geiger/ext3.ogg', 'sound/items/geiger/ext4.ogg')

/obj/effect/map_effect/interval/sound_emitter/punching
	sounds_to_play = list("punch")
	interval_lower_bound = 5
	interval_upper_bound = 1 SECOND

/obj/effect/map_effect/interval/sound_emitter/explosions
	sounds_to_play = list("explosion")
	interval_lower_bound = 5 SECONDS
	interval_upper_bound = 10 SECONDS

/obj/effect/map_effect/interval/sound_emitter/explosions/distant
	sounds_to_play = list('sound/effects/explosionfar.ogg')

/obj/effect/map_effect/interval/sound_emitter/ballistic_gunfight
	sounds_to_play = list(
		'sound/weapons/Gunshot1.ogg',
		'sound/weapons/Gunshot_deagle.ogg',
		'sound/weapons/Gunshot_generic_rifle.ogg',
		'sound/weapons/Gunshot_sniper.ogg',
		'sound/weapons/Gunshot_shotgun.ogg',
		'sound/weapons/Gunshot3.ogg',
		'sound/weapons/Gunshot_machinegun.ogg'
		)
	interval_lower_bound = 5
	interval_upper_bound = 2 SECONDS

/obj/effect/map_effect/interval/sound_emitter/energy_gunfight
	sounds_to_play = list(
		'sound/weapons/Taser.ogg',
		'sound/weapons/laser.ogg',
		'sound/weapons/eLuger.ogg',
		'sound/weapons/laser3.ogg',
		'sound/weapons/pulse.ogg',
		'sound/weapons/gauss_shoot.ogg',
		'sound/weapons/emitter.ogg'
		)
	interval_lower_bound = 5
	interval_upper_bound = 2 SECONDS


// I'm not sorry.
/obj/effect/map_effect/interval/sound_emitter/clownsteps
	sounds_to_play = list("clownstep")
	interval_lower_bound = 5
	interval_upper_bound = 1 SECOND

/obj/effect/map_effect/interval/sound_emitter/bikehorns
	sounds_to_play = list('sound/items/bikehorn.ogg')
	interval_lower_bound = 5
	interval_upper_bound = 1 SECOND
