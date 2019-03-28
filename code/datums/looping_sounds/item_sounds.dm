/datum/looping_sound/geiger
	mid_sounds = list(
		list('sound/items/geiger/low1.ogg'=1, 'sound/items/geiger/low2.ogg'=1, 'sound/items/geiger/low3.ogg'=1, 'sound/items/geiger/low4.ogg'=1),
		list('sound/items/geiger/med1.ogg'=1, 'sound/items/geiger/med2.ogg'=1, 'sound/items/geiger/med3.ogg'=1, 'sound/items/geiger/med4.ogg'=1),
		list('sound/items/geiger/high1.ogg'=1, 'sound/items/geiger/high2.ogg'=1, 'sound/items/geiger/high3.ogg'=1, 'sound/items/geiger/high4.ogg'=1),
		list('sound/items/geiger/ext1.ogg'=1, 'sound/items/geiger/ext2.ogg'=1, 'sound/items/geiger/ext3.ogg'=1, 'sound/items/geiger/ext4.ogg'=1)
		)
	mid_length = 1 SECOND
	volume = 25
	var/last_radiation

/datum/looping_sound/geiger/get_sound(starttime)
	var/danger
	switch(last_radiation)
		if(0 to RAD_LEVEL_MODERATE)
			danger = 1
		if(RAD_LEVEL_MODERATE to RAD_LEVEL_HIGH)
			danger = 2
		if(RAD_LEVEL_HIGH to RAD_LEVEL_VERY_HIGH)
			danger = 3
		if(RAD_LEVEL_VERY_HIGH to INFINITY)
			danger = 4
		else
			return null
	return ..(starttime, mid_sounds[danger])

/datum/looping_sound/geiger/stop()
	. = ..()
	last_radiation = 0
