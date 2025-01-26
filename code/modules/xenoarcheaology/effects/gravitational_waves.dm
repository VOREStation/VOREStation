/// Modified to work with the Artifact Harvester
/// BEWARE THOSE WHO TOUCH THIS FILE.
/// IF YOU ARE NOT CAREFUL, YOU CAN CAUSE AN INFINITE LOOP WITH THIS IF EFFECT = 0 TRIGGER = 0
/// AS IT WILL PULL THE USER INTO IT, TRIGGERING IT, WHICH PULLS THE USER INTO IT, TRIGGERING IT, WHICH PULLS THE... YEAH.
/// IT DOES THAT FOREVER. OR MORE APPROPRIATELY, IT DOES IT FOR 1 SECOND BEFORE THE ENTIRE SERVER CROAKS
/// THIS HAS BEEN RESOLVED BY OUR '	if(world.time >= last_wave_pull+10) last_wave_pull = world.time' LINE DOWN THERE

/datum/artifact_effect/extreme/gravity_wave
	name = "Gravitational Waves"
	effect_type = EFFECT_GRAVIATIONAL_WAVES

	var/last_wave_pull = 0
	var/pull_power

	effect_state = "gravisphere"
	effect_color = "#d8c3ff"

/datum/artifact_effect/extreme/gravity_wave/New()
	..()
	effect_type = EFFECT_GRAVIATIONAL_WAVES
	switch(pick(100;1, 50;2, 25;3))
		if(1) //short range
			effectrange = rand(2, 4)
		if(2) //medium range
			effectrange = rand(5, 9)
		if(3) //large range
			effectrange = rand(9, 14)
	pull_power = rand(STAGE_ONE, STAGE_FOUR)

/// BEWARE THOSE WHO TOUCH THIS FILE.
/datum/artifact_effect/extreme/gravity_wave/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		var/obj/item/anodevice/utilizer = holder.loc
		gravwave(utilizer, effectrange, pull_power)
	else
		gravwave(user, effectrange, pull_power)

/datum/artifact_effect/extreme/gravity_wave/DoEffectAura()
	var/atom/holder = get_master_holder()
	var/seconds_since_last_pull = max(0, round((last_wave_pull - world.time) / 10))
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(prob(10 + seconds_since_last_pull))
		holder.visible_message(span_alien("\The [holder] distorts as local gravity intensifies, and shifts toward it."))
		last_wave_pull = world.time
		gravwave(get_turf(holder), effectrange, pull_power)

/datum/artifact_effect/extreme/gravity_wave/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery)) //In case we're being used by a harvester.
		holder = holder.loc
	holder.visible_message(span_alien("\The [holder] distorts as local gravity intensifies, and shifts toward it."))
	gravwave(get_turf(holder), effectrange, pull_power)

/datum/artifact_effect/extreme/gravity_wave/proc/gravwave(var/atom/target, var/pull_range = 7, var/pull_power = STAGE_TWO)
	if(world.time >= last_wave_pull+10) //NO INFINITE LOOPS. do not touch this line or you WILL crash the server. I am not kidding. Go ahead, remove it on a test server and see what happens.
		last_wave_pull = world.time
		for(var/atom/A in oview(pull_range, target))
			A.singularity_pull(target, pull_power)
