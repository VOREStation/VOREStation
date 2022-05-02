//Common breathing procs

//Start of a breath chain, calls breathe()
/mob/living/human/proc/handle_breathing()
	if(!(air_master.current_cycle % 4) || failed_last_breath || (health < config.health_threshold_crit)) 	//First, resolve location and get a breath
		breathe()

/mob/living/human/proc/breathe()
	if(!should_have_organ(O_LUNGS))
		return

	var/datum/gas_mixture/breath = null

	// First, check if we can breathe at all

	//crit aka circulatory shock
	if(health < config.health_threshold_crit && !(CE_STABLE in chem_effects)) 
		AdjustLosebreath(1)

	// Suffocating so do not take a breath
	if(losebreath > 0) 
		AdjustLosebreath(-1)
		if(prob(10))
			emote("gasp")
	// Okay, we can breathe, now check if we can get air
	else
		// First, check for air from internals
		breath = get_breath_from_internal()

		// No breath from internals so let's try to get air from our location
		if(!breath)
			breath = get_breath_from_environment()
		
		// Still nothing? must be vacuum
		if(!breath)
			var/static/datum/gas_mixture/vacuum //avoid having to create a new gas mixture for each breath in space
			if(!vacuum) vacuum = new

			breath = vacuum 

	handle_breath(breath)
	handle_post_breath(breath)

/mob/living/human/proc/get_breath_from_internal(volume_needed=BREATH_VOLUME)
	if(!istype(internal))
		return null

	if(!(wear_mask?.item_flags & AIRTIGHT))
		internal = null
		if(internals)
			internals.icon_state = "internal0"
		return null

	//Because rigs store their tanks out of reach of contents.Find(), a check has to be made to make
	//sure the rig is still worn, still online, and that its air supply still exists.
	var/obj/item/rig/Rig = get_rig()
	if(!(internal in contents) && Rig?.air_supply)
		internal = Rig.air_supply

	if(internals)
		internals.icon_state = "internal[!!internal]"

	return internal?.remove_air_volume(volume_needed)

/mob/living/human/proc/get_breath_from_environment(var/volume_needed=BREATH_VOLUME)
	var/datum/gas_mixture/breath = null
	var/datum/gas_mixture/environment = null
	if(loc)
		environment = loc.return_air_for_internal_lifeform(src)

	if(environment)
		breath = environment.remove_volume(volume_needed)
		handle_chemical_smoke(environment) //handle chemical smoke while we're at it

	if(breath)
		//handle mask filtering
		if(istype(wear_mask, /obj/item/clothing/mask) && breath)
			var/obj/item/clothing/mask/M = wear_mask
			var/datum/gas_mixture/gas_filtered = M.filter_air(breath)
			loc.assume_air(gas_filtered)
		return breath
	return null

//Handle possble chem smoke effect
/mob/living/human/proc/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(wear_mask && (wear_mask.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(glasses && (glasses.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(head && (head.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return

	for(var/obj/effect/vfx/smoke/chem/smoke in view(1, src))
		if(smoke.reagents.total_volume)
			//smoke.reagents.trans_to_mob(src, 10, CHEM_INGEST, copy = 1)
			// TODO SURGERY_REFACTOR: Integrate with lungs
			break

// TODO SURGERY_REFACTOR: Pass over this with lungs
/mob/living/human/proc/handle_breath(datum/gas_mixture/breath)
	if(suiciding)
		failed_last_breath = 1
		adjustOxyLoss(2) // If you are suiciding, you should die a little bit faster
		suiciding--
		return FALSE

	if(does_not_breathe)
		failed_last_breath = 0
		adjustOxyLoss(-5)
		return

	if(!breath || (breath.total_moles == 0))
		failed_last_breath = 1
		if(health > config.health_threshold_crit)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		if(breath && should_have_organ(O_LUNGS))
			var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
			if(!L.is_bruised() && prob(8))
				rupture_lung()

		throw_alert("pressure", /obj/screen/alert/lowpressure)
		return FALSE
	else
		clear_alert("pressure")

	var/safe_pressure_min = species.minimum_breath_pressure // Minimum safe partial pressure of breathable gas in kPa


	// Lung damage increases the minimum safe pressure.
	if(should_have_organ(O_LUNGS))
		var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
		if(isnull(L))
			safe_pressure_min = INFINITY //No lungs, how are you breathing?
		else if(L.is_broken())
			safe_pressure_min *= 1.5
		else if(L.is_bruised())
			safe_pressure_min *= 1.25
		else if(breath)
			if(breath.total_moles < BREATH_MOLES / 10 || breath.total_moles > BREATH_MOLES * 5)
				if(is_below_sound_pressure(get_turf(src)))	//No more popped lungs from choking/drowning
					if (prob(8))
						rupture_lung()

	var/safe_exhaled_max = 10
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/inhaled_gas_used = 0

	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

	var/inhaling
	var/poison
	var/exhaling

	var/breath_type
	var/poison_type
	var/exhale_type

	var/failed_inhale = 0
	var/failed_exhale = 0

	if(species.breath_type)
		breath_type = species.breath_type
	else
		breath_type = "oxygen"
	inhaling = breath.gas[breath_type]

	if(species.poison_type)
		poison_type = species.poison_type
	else
		poison_type = "phoron"
	poison = breath.gas[poison_type]

	if(species.exhale_type)
		exhale_type = species.exhale_type
		exhaling = breath.gas[exhale_type]
	else
		exhaling = 0

	var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	// To be clear, this isn't how much they're exhaling -- it's the amount of the species exhale_gas that they just
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

	// Not enough to breathe
	if(inhale_pp < safe_pressure_min)
		if(prob(20))
			spawn(0) emote("gasp")

		var/ratio = inhale_pp/safe_pressure_min
		// Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
		adjustOxyLoss(max(HUMAN_MAX_OXYLOSS*(1-ratio), 0))
		failed_inhale = 1

		switch(breath_type)
			if("oxygen")
				throw_alert("oxy", /obj/screen/alert/not_enough_oxy)
			if("phoron")
				throw_alert("oxy", /obj/screen/alert/not_enough_tox)
			if("nitrogen")
				throw_alert("oxy", /obj/screen/alert/not_enough_nitro)
			if("carbon_dioxide")
				throw_alert("oxy", /obj/screen/alert/not_enough_co2)
			if("volatile_fuel")
				throw_alert("oxy", /obj/screen/alert/not_enough_fuel)
			if("nitrous_oxide")
				throw_alert("oxy", /obj/screen/alert/not_enough_n2o)

	else
		// We're in safe limits
		clear_alert("oxy")

	inhaled_gas_used = inhaling/6

	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	if(exhale_type)
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, bodytemperature, update = 0) //update afterwards

		// Too much exhaled gas in the air
		if(exhaled_pp > safe_exhaled_max)
			if (prob(15))
				var/word = pick("extremely dizzy","short of breath","faint","confused")
				to_chat(src, "<span class='danger'>You feel [word].</span>")

			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			failed_exhale = 1

		else if(exhaled_pp > safe_exhaled_max * 0.7)
			if (!prob(1))
				var/word = pick("dizzy","short of breath","faint","momentarily confused")
				to_chat(src, "<span class='warning'>You feel [word].</span>")

			//scale linearly from 0 to 1 between safe_exhaled_max and safe_exhaled_max*0.7
			var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)

			//give them some oxyloss, up to the limit - we don't want people falling unconcious due to CO2 alone until they're pretty close to safe_exhaled_max.
			if (getOxyLoss() < 50*ratio)
				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			failed_exhale = 1

		else if(exhaled_pp > safe_exhaled_max * 0.6)
			if(prob(0.3))
				var/word = pick("a little dizzy","short of breath")
				to_chat(src, "<span class='warning'>You feel [word].</span>")

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		if(reagents)
			reagents.add_reagent("toxin", clamp(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
			breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		throw_alert("tox_in_air", /obj/screen/alert/tox_in_air)
	else
		clear_alert("tox_in_air")

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas["nitrous_oxide"])
		var/SA_pp = (breath.gas["nitrous_oxide"] / breath.total_moles) * breath_pressure

		// Enough to make us paralysed for a bit
		if(SA_pp > SA_para_min)

			// 3 gives them one second to wake up and run away a bit!
			Paralyse(3)

			// Enough to make us sleep as well
			if(SA_pp > SA_sleep_min)
				Sleeping(5)

		// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
		else if(SA_pp > 0.15)
			if(prob(20))
				spawn(0) emote(pick("giggle", "laugh"))
		breath.adjust_gas("nitrous_oxide", -breath.gas["nitrous_oxide"]/6, update = 0) //update after

	// Were we able to breathe?
	if (failed_inhale || failed_exhale)
		failed_last_breath = 1
	else
		failed_last_breath = 0
		adjustOxyLoss(-5)
		
	if(!does_not_breathe && client) // If we breathe, and have an active client, check if we have synthetic lungs.
		var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
		var/turf = get_turf(src)
		var/mob/living/human/M = src
		if(L.robotic < ORGAN_ROBOT && is_below_sound_pressure(turf) && M.internal) // Only non-synthetic lungs, please, and only play these while the pressure is below that which we can hear sounds normally AND we're on internals.
			if(!failed_inhale && (world.time >= (last_breath_sound + 7 SECONDS))) // Were we able to inhale successfully? Play inhale.
				var/exhale = failed_exhale // Pass through if we passed exhale or not
				play_inhale(M, exhale)
				last_breath_sound = world.time


	// Hot air hurts :(
	if((breath.temperature <= species.cold_discomfort_level || breath.temperature >= species.heat_discomfort_level) && !(COLD_RESISTANCE in mutations))

		if(breath.temperature <= species.breath_cold_level_1)
			if(prob(20))
				to_chat(src, "<span class='danger'>You feel your face freezing and icicles forming in your lungs!</span>")
		else if(breath.temperature >= species.breath_heat_level_1)
			if(prob(20))
				to_chat(src, "<span class='danger'>You feel your face burning and a searing heat in your lungs!</span>")

		if(breath.temperature >= species.heat_discomfort_level)
		
			if(breath.temperature >= species.breath_heat_level_3)
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, BURN, BP_HEAD, used_weapon = "Excessive Heat")
				throw_alert("temp", /obj/screen/alert/hot, HOT_ALERT_SEVERITY_MAX)
			else if(breath.temperature >= species.breath_heat_level_2)
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, BURN, BP_HEAD, used_weapon = "Excessive Heat")
				throw_alert("temp", /obj/screen/alert/hot, HOT_ALERT_SEVERITY_MODERATE)
			else if(breath.temperature >= species.breath_heat_level_1)
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, BURN, BP_HEAD, used_weapon = "Excessive Heat")
				throw_alert("temp", /obj/screen/alert/hot, HOT_ALERT_SEVERITY_LOW)
			else if(species.get_environment_discomfort(src, ENVIRONMENT_COMFORT_MARKER_HOT))
				throw_alert("temp", /obj/screen/alert/warm, HOT_ALERT_SEVERITY_LOW)
			else
				clear_alert("temp")

		else if(breath.temperature <= species.cold_discomfort_level)

			if(breath.temperature <= species.breath_cold_level_3)
				apply_damage(COLD_GAS_DAMAGE_LEVEL_3, BURN, BP_HEAD, used_weapon = "Excessive Cold")
				throw_alert("temp", /obj/screen/alert/cold, COLD_ALERT_SEVERITY_MAX)
			else if(breath.temperature <= species.breath_cold_level_2)
				apply_damage(COLD_GAS_DAMAGE_LEVEL_1, BURN, BP_HEAD, used_weapon = "Excessive Cold")
				throw_alert("temp", /obj/screen/alert/cold, COLD_ALERT_SEVERITY_LOW)
			else if(breath.temperature <= species.breath_cold_level_1)
				apply_damage(COLD_GAS_DAMAGE_LEVEL_2, BURN, BP_HEAD, used_weapon = "Excessive Cold")
				throw_alert("temp", /obj/screen/alert/cold, COLD_ALERT_SEVERITY_MODERATE)
			else if(species.get_environment_discomfort(src, ENVIRONMENT_COMFORT_MARKER_COLD))
				throw_alert("temp", /obj/screen/alert/chilly, COLD_ALERT_SEVERITY_LOW)
			else
				clear_alert("temp")

		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
		temp_adj *= relative_density

		if(temp_adj > BODYTEMP_HEATING_MAX)
			temp_adj = BODYTEMP_HEATING_MAX
		if(temp_adj < BODYTEMP_COOLING_MAX)
			temp_adj = BODYTEMP_COOLING_MAX

		bodytemperature += temp_adj

	else
		clear_alert("temp")

	breath.update_values()
	return 1

/mob/living/human/proc/handle_post_breath(datum/gas_mixture/breath)
	if(breath)
		loc.assume_air(breath) //by default, exhale
	//spread some viruses while we are at it
	if(breath && virus2.len > 0 && prob(10))
		for(var/mob/living/human/M in view(1,src))
			src.spread_disease_to(M)

/mob/living/human/proc/play_inhale(var/mob/living/M, var/exhale)
	var/suit_inhale_sound
	if(species.suit_inhale_sound)
		suit_inhale_sound = species.suit_inhale_sound
	else // Failsafe
		suit_inhale_sound = 'sound/effects/mob_effects/suit_breathe_in.ogg'
	
	playsound_local(get_turf(src), suit_inhale_sound, 100, pressure_affected = FALSE, volume_channel = VOLUME_CHANNEL_AMBIENCE)
	if(!exhale) // Did we fail exhale? If no, play it after inhale finishes.
		addtimer(CALLBACK(src, .proc/play_exhale, M), 5 SECONDS)
	
/mob/living/human/proc/play_exhale(var/mob/living/M)
	var/suit_exhale_sound
	if(species.suit_exhale_sound)
		suit_exhale_sound = species.suit_exhale_sound
	else // Failsafe
		suit_exhale_sound = 'sound/effects/mob_effects/suit_breathe_out.ogg'
	
	playsound_local(get_turf(src), suit_exhale_sound, 100, pressure_affected = FALSE, volume_channel = VOLUME_CHANNEL_AMBIENCE)