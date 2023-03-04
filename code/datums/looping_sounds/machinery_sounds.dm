/datum/looping_sound/showering
	start_sound = 'sound/machines/shower/shower_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/shower/shower_mid1.ogg'=1,'sound/machines/shower/shower_mid2.ogg'=1,'sound/machines/shower/shower_mid3.ogg'=1)
	mid_length = 10
	end_sound = 'sound/machines/shower/shower_end.ogg'
	volume = 15

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/supermatter
	mid_sounds = list('sound/machines/sm/loops/calm.ogg'=1)
	mid_length = 60
	volume = 40
	extra_range = 10
	pref_check = /datum/client_preference/supermatter_hum

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/generator
	start_sound = 'sound/machines/generator/generator_start.ogg'
	start_length = 4
	mid_sounds = list('sound/machines/generator/generator_mid1.ogg'=1, 'sound/machines/generator/generator_mid2.ogg'=1, 'sound/machines/generator/generator_mid3.ogg'=1)
	mid_length = 4
	end_sound = 'sound/machines/generator/generator_end.ogg'
	volume = 40

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/datum/looping_sound/deep_fryer
	start_sound = 'sound/machines/kitchen/fryer/deep_fryer_immerse.ogg' //my immersions
	start_length = 10
	mid_sounds = list('sound/machines/kitchen/fryer/deep_fryer_1.ogg' = 1, 'sound/machines/kitchen/fryer/deep_fryer_2.ogg' = 1)
	mid_length = 2
	end_sound = 'sound/machines/kitchen/fryer/deep_fryer_emerge.ogg'
	volume = 15

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/microwave
	start_sound = 'sound/machines/kitchen/microwave/microwave-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/kitchen/microwave/microwave-mid1.ogg'=10, 'sound/machines/kitchen/microwave/microwave-mid2.ogg'=1)
	mid_length = 10
	end_sound = 'sound/machines/kitchen/microwave/microwave-end.ogg'
	volume = 90

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/oven
	start_sound = 'sound/machines/kitchen/oven/oven-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/kitchen/oven/oven-mid1.ogg'=10)
	mid_length = 40
	end_sound = 'sound/machines/kitchen/oven/oven-stop.ogg'
	volume = 50

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/grill
	start_sound = 'sound/machines/kitchen/grill/grill-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/kitchen/grill/grill-mid1.ogg'=10)
	mid_length = 40
	end_sound = 'sound/machines/kitchen/grill/grill-stop.ogg'
	volume = 50

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/mixer
	start_sound = 'sound/machines/kitchen/mixer/mixer-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/kitchen/mixer/mixer-mid1.ogg'=10)
	mid_length = 10
	end_sound = 'sound/machines/kitchen/mixer/mixer-stop.ogg'
	volume = 50

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/cerealmaker
	start_sound = 'sound/machines/kitchen/cerealmaker/cerealmaker-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/kitchen/cerealmaker/cerealmaker-mid1.ogg'=10)
	mid_length = 60
	end_sound = 'sound/machines/kitchen/cerealmaker/cerealmaker-stop.ogg'
	volume = 50

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/candymaker
	start_sound = 'sound/machines/kitchen/candymaker/candymaker-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/kitchen/candymaker/candymaker-mid1.ogg'=10)
	mid_length = 40
	end_sound = 'sound/machines/kitchen/candymaker/candymaker-stop.ogg'
	volume = 20

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/looping_sound/air_pump
	start_sound = 'sound/machines/air_pump/airpumpstart.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/air_pump/airpumpidle.ogg' = 1)
	mid_length = 70
	end_sound = 'sound/machines/air_pump/airpumpshutdown.ogg'
	volume = 15
	pref_check = /datum/client_preference/air_pump_noise

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/vehicle_engine
	start_sound = 'sound/machines/vehicle/engine_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/vehicle/engine_mid.ogg'=1)
	mid_length = 6
	end_sound = 'sound/machines/vehicle/engine_end.ogg'
	volume = 20

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/mining_drill
	start_sound = 'sound/machines/drill/drill_start.ogg'
	start_length = 19
	mid_sounds = list('sound/machines/drill/drill_mid.ogg'=1)
	mid_length = 19
	end_sound = 'sound/machines/drill/drill_end.ogg'
	volume = 50

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/fabricator
	mid_sounds = list('sound/machines/fabricator/fabricator1.ogg'=1, 'sound/machines/fabricator/fabricator2.ogg'=1)
	mid_length = 60
	volume = 25
