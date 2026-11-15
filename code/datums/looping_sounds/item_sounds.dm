/datum/looping_sound/small_motor
	start_sound = 'sound/items/small_motor/motor_start_nopull.ogg'
	start_length = 2 SECONDS
	mid_sounds = list(
		'sound/items/small_motor/motor_idle.ogg',
		'sound/items/small_motor/motor_fast.ogg',
		'sound/items/small_motor/motor_faster.ogg'
	)
	mid_length = 1.9 SECONDS //someone make this loop better please, i'm no good at sound. the clips should be 2 seconds exact but there's a gap if it's set to 2
	end_sound = 'sound/items/small_motor/motor_end.ogg'
	var/speed = 1

/datum/looping_sound/small_motor/get_sound(starttime)
	speed = clamp(speed, 1, 3)
	return ..(starttime, mid_sounds[speed])
