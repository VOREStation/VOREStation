//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS ( 2.0 / 6) //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 4 ticks. last_tick_duration = ~2.0 on average

#define HEAT_DAMAGE_LEVEL_1 2 //VOREStation Edit //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //VOREStation Edit //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //VOREStation Edit //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

#define COLD_ALERT_SEVERITY_LOW         1 // Constants passed to the cold and heat alerts.
#define COLD_ALERT_SEVERITY_MODERATE    2
#define COLD_ALERT_SEVERITY_MAX         3
#define ENVIRONMENT_COMFORT_MARKER_COLD 1

#define HOT_ALERT_SEVERITY_LOW          1
#define HOT_ALERT_SEVERITY_MODERATE     2
#define HOT_ALERT_SEVERITY_MAX          3
#define ENVIRONMENT_COMFORT_MARKER_HOT  2

#define RADIATION_SPEED_COEFFICIENT 0.1
#define HUMAN_COMBUSTION_TEMP 524 //524k is the sustained combustion temperature of human fat

/mob/living/carbon/human
	var/in_stasis = 0
	var/heartbeat = 0

/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (transforming)
		return

	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = 0

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++

	// This is not an ideal place for this but it will do for now.
	if(wearing_rig && wearing_rig.offline)
		wearing_rig = null

	..()

	if(life_tick % 30)
		hud_updateflag = (1 << TOTAL_HUDS) - 1

	voice = GetVoice()

	var/stasis = inStasisNow()
	if(getStasis() > 2)
		Sleeping(20)

	//No need to update all of these procs if the guy is dead.
	fall() //VORESTATION EDIT. Prevents people from floating
	if(stat != DEAD && !stasis)
		//Updates the number of stored chemicals for powers
		handle_changeling()

		//Organs and blood
		handle_organs()
		stabilize_body_temperature() //Body temperature adjusts itself (self-regulation)
		weightgain() 			//VOREStation Addition
		process_weaver_silk()	//VOREStation Addition
		handle_shock()

		handle_pain()

		handle_medical_side_effects()

		handle_heartbeat()
		handle_nif() 			//VOREStation Addition
		if(!client)
			species.handle_npc(src)

	else if(stat == DEAD && !stasis)
		handle_defib_timer()

	if(skip_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	pulse = handle_pulse()

/mob/living/carbon/human/proc/skip_some_updates()
	if(life_tick > 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
		return 1
	return 0

/mob/living/carbon/human/breathe()
	if(!inStasisNow())
		..()

// Calculate how vulnerable the human is to the current pressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit that's rated for the pressure, 1 if unprotected (equals 100%).
// Suitdamage can modifiy this in 10% steps.
// Protection scales down from 100% at the boundary to 0% at 10% in excess of the boundary
/mob/living/carbon/human/proc/get_pressure_weakness(pressure)
	if(pressure == null)
		return 1 // No protection if someone forgot to give a pressure

	var/pressure_adjustment_coefficient = 1 // Assume no protection at first.

	// Check suit
	if(wear_suit && wear_suit.max_pressure_protection != null && wear_suit.min_pressure_protection != null)
		pressure_adjustment_coefficient = 0
		// Pressure is too high
		if(wear_suit.max_pressure_protection < pressure)
			// Protection scales down from 100% at the boundary to 0% at 10% in excess of the boundary
			pressure_adjustment_coefficient += round((pressure - wear_suit.max_pressure_protection) / (wear_suit.max_pressure_protection/10))

		// Pressure is too low
		if(wear_suit.min_pressure_protection > pressure)
			pressure_adjustment_coefficient += round((wear_suit.min_pressure_protection - pressure) / (wear_suit.min_pressure_protection/10))

		// Handles breaches in your space suit. 10 suit damage equals a 100% loss of pressure protection.
		if(istype(wear_suit,/obj/item/clothing/suit/space))
			var/obj/item/clothing/suit/space/S = wear_suit
			if(S.can_breach && S.damage)
				pressure_adjustment_coefficient += S.damage * 0.1

	else
		// Missing key protection
		pressure_adjustment_coefficient = 1

	// Check hat
	if(head && head.max_pressure_protection != null && head.min_pressure_protection != null)
		// Pressure is too high
		if(head.max_pressure_protection < pressure)
			// Protection scales down from 100% at the boundary to 0% at 20% in excess of the boundary
			pressure_adjustment_coefficient += round((pressure - head.max_pressure_protection) / (head.max_pressure_protection/20))

		// Pressure is too low
		if(head.min_pressure_protection > pressure)
			pressure_adjustment_coefficient += round((head.min_pressure_protection - pressure) / (head.min_pressure_protection/20))

	else
		// Missing key protection
		pressure_adjustment_coefficient = 1

	pressure_adjustment_coefficient = min(pressure_adjustment_coefficient, 1)
	return pressure_adjustment_coefficient

// Calculate how much of the enviroment pressure-difference affects the human.
/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	var/pressure_difference

	// First get the absolute pressure difference.
	if(pressure < species.safe_pressure) // We are in an underpressure.
		pressure_difference = species.safe_pressure - pressure

	else //We are in an overpressure or standard atmosphere.
		pressure_difference = pressure - species.safe_pressure

	if(pressure_difference < 5) // If the difference is small, don't bother calculating the fraction.
		pressure_difference = 0

	else
		// Otherwise calculate how much of that absolute pressure difference affects us, can be 0 to 1 (equals 0% to 100%).
		// This is our relative difference.
		pressure_difference *= get_pressure_weakness(pressure)

	// The difference is always positive to avoid extra calculations.
	// Apply the relative difference on a standard atmosphere to get the final result.
	// The return value will be the adjusted_pressure of the human that is the basis of pressure warnings and damage.
	if(pressure < species.safe_pressure)
		return species.safe_pressure - pressure_difference
	else
		return species.safe_pressure + pressure_difference

/mob/living/carbon/human/handle_disabilities()
	..()

	if(stat != CONSCIOUS) //Let's not worry about tourettes if you're not conscious.
		return

	if (disabilities & EPILEPSY)
		if ((prob(1) && paralysis < 1))
			to_chat(src, "<font color='red'>You have a seizure!</font>")
			for(var/mob/O in viewers(src, null))
				if(O == src)
					continue
				O.show_message(text("<span class='danger'>[src] starts having a seizure!</span>"), 1)
			Paralyse(10)
			make_jittery(1000)
	if (disabilities & COUGHING)
		if ((prob(5) && paralysis <= 1))
			drop_item()
			spawn( 0 )
				emote("cough")
				return
	if (disabilities & TOURETTES)
		if ((prob(10) && paralysis <= 1))
			Stun(10)
			spawn( 0 )
				switch(rand(1, 3))
					if(1)
						emote("twitch")
					if(2 to 3)
						say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
				make_jittery(100)
				return
	if (disabilities & NERVOUS)
		if (prob(10))
			stuttering = max(10, stuttering)

	var/rn = rand(0, 200)
	if(getBrainLoss() >= 5)
		if(0 <= rn && rn <= 3)
			custom_pain("Your head feels numb and painful.", 10)
	if(getBrainLoss() >= 15)
		if(4 <= rn && rn <= 6) if(eye_blurry <= 0)
			to_chat(src, "<span class='warning'>It becomes hard to see for some reason.</span>")
			eye_blurry = 10
	if(getBrainLoss() >= 35)
		if(7 <= rn && rn <= 9) if(get_active_hand())
			to_chat(src, "<span class='danger'>Your hand won't respond properly, you drop what you're holding!</span>")
			drop_item()
	if(getBrainLoss() >= 45)
		if(10 <= rn && rn <= 12)
			if(prob(50))
				to_chat(src, "<span class='danger'>You suddenly black out!</span>")
				Paralyse(10)
			else if(!lying)
				to_chat(src, "<span class='danger'>Your legs won't respond properly, you fall down!</span>")
				Weaken(10)



/mob/living/carbon/human/handle_mutations_and_radiation()
	if(inStasisNow())
		return

	if(getFireLoss())
		if((COLD_RESISTANCE in mutations) || (prob(1)))
			heal_organ_damage(0,1)

	// DNA2 - Gene processing.
	// The HULK stuff that was here is now in the hulk gene.
	if(!isSynthetic())
		for(var/datum/dna/gene/gene in dna_genes)
			if(!gene.block)
				continue
			if(gene.is_active(src))
				gene.OnMobLife(src)

	radiation = CLAMP(radiation,0,250)

	if(!radiation)
		if(species.appearance_flags & RADIATION_GLOWS)
			set_light(0)
	else
		if(species.appearance_flags & RADIATION_GLOWS)
			set_light(max(1,min(5,radiation/15)), max(1,min(10,radiation/25)), species.get_flesh_colour(src))
		// END DOGSHIT SNOWFLAKE

		var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in internal_organs
		if(rad_organ && !rad_organ.is_broken())
			var/rads = radiation/25
			radiation -= rads
			adjust_nutrition(rads)
			adjustBruteLoss(-(rads))
			adjustFireLoss(-(rads))
			adjustOxyLoss(-(rads))
			adjustToxLoss(-(rads))
			updatehealth()
			return

		var/obj/item/organ/internal/brain/slime/core = locate() in internal_organs
		if(core)
			return

		//VOREStation Addition start: shadekin
		var/obj/item/organ/internal/brain/shadekin/s_brain = locate() in internal_organs
		if(s_brain)
			return
		//VOREStation Addition end: shadekin

		var/damage = 0
		radiation -= 1 * RADIATION_SPEED_COEFFICIENT
		if(radiation > 2.5 && prob(25)) // Safe for a little over 2m at the recommended maximum safe dosage of 0.05Bq
			damage = 1

		if (radiation > 50)
			damage = 1
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			if(!isSynthetic())
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
					radiation -= 5 * RADIATION_SPEED_COEFFICIENT
					to_chat(src, "<span class='warning'>You feel weak.</span>")
					Weaken(3)
					if(!lying)
						emote("collapse")
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT) && species.get_bodytype() == SPECIES_HUMAN) //apes go bald
					if((h_style != "Bald" || f_style != "Shaved" ))
						to_chat(src, "<span class='warning'>Your hair falls out.</span>")
						h_style = "Bald"
						f_style = "Shaved"
						update_hair()

		if (radiation > 75)
			damage = 3
			radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			if(!isSynthetic())
				if(prob(5))
					take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
				if(prob(1))
					to_chat(src, "<span class='warning'>You feel strange!</span>")
					adjustCloneLoss(5 * RADIATION_SPEED_COEFFICIENT)
					emote("gasp")

		if (radiation > 150)
			damage = 6
			radiation -= 4 * RADIATION_SPEED_COEFFICIENT

		if(damage)
			damage *= species.radiation_mod
			adjustToxLoss(damage * RADIATION_SPEED_COEFFICIENT)
			updatehealth()
			if(!isSynthetic() && organs.len)
				var/obj/item/organ/external/O = pick(organs)
				if(istype(O)) O.add_autopsy_data("Radiation Poisoning", damage)

	/** breathing **/

/mob/living/carbon/human/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(wear_mask && (wear_mask.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(glasses && (glasses.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(head && (head.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	..()

/mob/living/carbon/human/handle_post_breath(datum/gas_mixture/breath)
	..()
	//spread some viruses while we are at it
	if(breath && virus2.len > 0 && prob(10))
		for(var/mob/living/carbon/M in view(1,src))
			src.spread_disease_to(M)


/mob/living/carbon/human/get_breath_from_internal(volume_needed=BREATH_VOLUME)
	if(internal)
		//Because rigs store their tanks out of reach of contents.Find(), a check has to be made to make
		//sure the rig is still worn, still online, and that its air supply still exists.
		var/obj/item/weapon/tank/rig_supply
		var/obj/item/weapon/rig/Rig = get_rig()

		if(Rig)
			rig_supply = Rig.air_supply

		if ((!rig_supply && !contents.Find(internal)) || !((wear_mask && (wear_mask.item_flags & AIRTIGHT)) || (head && (head.item_flags & AIRTIGHT))))
			internal = null

		if(internal)
			return internal.remove_air_volume(volume_needed)
		else if(internals)
			internals.icon_state = "internal0"
	return null


/mob/living/carbon/human/handle_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return

	if(suiciding)
		failed_last_breath = 1
		adjustOxyLoss(2)//If you are suiciding, you should die a little bit faster
		suiciding--
		return 0

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
		return 0
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
			reagents.add_reagent("toxin", CLAMP(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
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

/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		return
	//Stuff like the xenomorph's plasma regen happens here.
	species.handle_environment_special(src)

	if(is_incorporeal())
		return

	//Moved pressure calculations here for use in skip-processing check.
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure)

	//Check for contaminants before anything else because we don't want to skip it.
	for(var/g in environment.gas)
		if(gas_data.flags[g] & XGM_GAS_CONTAMINANT && environment.gas[g] > gas_data.overlay_limit[g] + 1)
			pl_effects()
			break

	if(istype(loc, /turf/space)) //VOREStation Edit - No FBPs overheating on space turfs inside mechs or people.
		//Don't bother if the temperature drop is less than 0.1 anyways. Hopefully BYOND is smart enough to turn this constant expression into a constant
		if(bodytemperature > (0.1 * HUMAN_HEAT_CAPACITY/(HUMAN_EXPOSED_SURFACE_AREA*STEFAN_BOLTZMANN_CONSTANT))**(1/4) + COSMIC_RADIATION_TEMPERATURE)
			//Thermal radiation into space
			var/heat_loss = HUMAN_EXPOSED_SURFACE_AREA * STEFAN_BOLTZMANN_CONSTANT * ((bodytemperature - COSMIC_RADIATION_TEMPERATURE)**4)
			var/temperature_loss = heat_loss/HUMAN_HEAT_CAPACITY
			bodytemperature -= temperature_loss
	else
		var/loc_temp = T0C
		if(istype(loc, /obj/mecha))
			var/obj/mecha/M = loc
			loc_temp =  M.return_temperature()
		else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/cc = loc
			loc_temp = cc.air_contents.temperature
		else
			loc_temp = environment.temperature

		if(adjusted_pressure < species.warning_high_pressure && adjusted_pressure > species.warning_low_pressure && abs(loc_temp - bodytemperature) < 20 && bodytemperature < species.heat_level_1 && bodytemperature > species.cold_level_1)
			clear_alert("pressure")
			return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
		var/temp_adj = 0
		if(loc_temp < bodytemperature)			//Place is colder than we are
			var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 0.99)	//For some reason, < 1 returns false if the value is 1.
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
		else if (loc_temp > bodytemperature)			//Place is hotter than we are
			var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 0.99)	//For some reason, < 1 returns false if the value is 1.
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		//Use heat transfer as proportional to the gas density. However, we only care about the relative density vs standard 101 kPa/20 C air. Therefore we can use mole ratios
		var/relative_density = environment.total_moles / MOLES_CELLSTANDARD
		bodytemperature += between(BODYTEMP_COOLING_MAX, temp_adj*relative_density, BODYTEMP_HEATING_MAX)

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature >= species.heat_level_1)
		//Body temperature is too hot.
		if(status_flags & GODMODE)
			return 1	//godmode

		var/burn_dam = 0

		// switch() can't access numbers inside variables, so we need to use some ugly if() spam ladder.
		if(bodytemperature >= species.heat_level_1)
			if(bodytemperature >= species.heat_level_2)
				if(bodytemperature >= species.heat_level_3)
					burn_dam = HEAT_DAMAGE_LEVEL_3
					throw_alert("temp", /obj/screen/alert/hot, HOT_ALERT_SEVERITY_MAX)
				else
					burn_dam = HEAT_DAMAGE_LEVEL_2
					throw_alert("temp", /obj/screen/alert/hot, HOT_ALERT_SEVERITY_MODERATE)
			else
				burn_dam = HEAT_DAMAGE_LEVEL_1
				throw_alert("temp", /obj/screen/alert/hot, HOT_ALERT_SEVERITY_LOW)

		take_overall_damage(burn=burn_dam, used_weapon = "High Body Temperature")

	else if(bodytemperature <= species.cold_level_1)
		//Body temperature is too cold.

		if(status_flags & GODMODE)
			return 1	//godmode


		if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/cold_dam = 0
			if(bodytemperature <= species.cold_level_1)
				if(bodytemperature <= species.cold_level_2)
					if(bodytemperature <= species.cold_level_3)
						cold_dam = COLD_DAMAGE_LEVEL_3
					else
						cold_dam = COLD_DAMAGE_LEVEL_2
				else
					cold_dam = COLD_DAMAGE_LEVEL_1

			take_overall_damage(burn=cold_dam, used_weapon = "Low Body Temperature")

	else clear_alert("temp")

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
	if(status_flags & GODMODE)
		return 1	//godmode

	if(adjusted_pressure >= species.hazard_high_pressure)
		var/pressure_damage = min( ( (adjusted_pressure / species.hazard_high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE)
		take_overall_damage(brute=pressure_damage, used_weapon = "High Pressure")
		throw_alert("pressure", /obj/screen/alert/highpressure, 2)
	else if(adjusted_pressure >= species.warning_high_pressure)
		throw_alert("pressure", /obj/screen/alert/highpressure, 1)
	else if(adjusted_pressure >= species.warning_low_pressure)
		clear_alert("pressure")
	else if(adjusted_pressure >= species.hazard_low_pressure)
		throw_alert("pressure", /obj/screen/alert/lowpressure, 1)
	else
		if( !(COLD_RESISTANCE in mutations))
			if(!isSynthetic() || !nif || !nif.flag_check(NIF_O_PRESSURESEAL,NIF_FLAGS_OTHER)) //VOREStation Edit - NIF pressure seals
				take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
			if(getOxyLoss() < 55) 		// 12 OxyLoss per 4 ticks when wearing internals;    unconsciousness in 16 ticks, roughly half a minute
				var/pressure_dam = 3	// 16 OxyLoss per 4 ticks when no internals present; unconsciousness in 13 ticks, roughly twenty seconds
										// (Extra 1 oxyloss from failed breath)
										// Being in higher pressure decreases the damage taken, down to a minimum of (species.hazard_low_pressure / ONE_ATMOSPHERE) at species.hazard_low_pressure
				pressure_dam *= (ONE_ATMOSPHERE - adjusted_pressure) / ONE_ATMOSPHERE

				if(wear_suit && wear_suit.min_pressure_protection && head && head.min_pressure_protection)
					var/protection = max(wear_suit.min_pressure_protection, head.min_pressure_protection) // Take the weakest protection
					pressure_dam *= (protection) / (ONE_ATMOSPHERE) 	// Divide by ONE_ATMOSPHERE to get a fractional protection
																		// Stronger protection (Closer to 0) results in a smaller fraction
																		// Firesuits (Min protection = 0.2 atmospheres) decrease oxyloss to 1/5

				adjustOxyLoss(pressure_dam)
			throw_alert("pressure", /obj/screen/alert/lowpressure, 2)
		else
			clear_alert("pressure")

	return

/*
/mob/living/carbon/human/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change
*/

/mob/living/carbon/human/proc/stabilize_body_temperature()
	// We produce heat naturally.
	if (species.passive_temp_gain)
		bodytemperature += species.passive_temp_gain
	if (species.body_temperature == null)
		return //this species doesn't have metabolic thermoregulation

	// FBPs will overheat when alive, prosthetic limbs are fine.
	if(stat != DEAD && robobody_count)
		if(!nif || !nif.flag_check(NIF_O_HEATSINKS,NIF_FLAGS_OTHER)) //VOREStation Edit - NIF heatsinks prevent the base heat increase per tick if installed.
			bodytemperature += round(robobody_count*1.15)
		var/obj/item/organ/internal/robotic/heatsink/HS = internal_organs_by_name[O_HEATSINK]
		if(!HS || HS.is_broken()) // However, NIF Heatsinks will not compensate for a core FBP component (your heatsink) being lost.
			bodytemperature += round(robobody_count*0.5)

	var/body_temperature_difference = species.body_temperature - bodytemperature

	if (abs(body_temperature_difference) < 0.5)
		return //fuck this precision

	if (on_fire)
		return //too busy for pesky metabolic regulation

	if(bodytemperature < species.cold_level_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
			adjust_nutrition(-2)
		var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		//to_world("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//				log_debug("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(species.cold_level_1 <= bodytemperature && bodytemperature <= species.heat_level_1)
		var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
		//to_world("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//				log_debug("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(bodytemperature > species.heat_level_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		//We totally need a sweat system cause it totally makes sense...~
		var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
		//to_world("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
//				log_debug("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt

	//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	. = 0
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.handle_high_temperature(temperature))
				. |= C.get_heat_protection_flags()

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	. = 0
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.handle_low_temperature(temperature))
				. |= C.get_cold_protection_flags()

/mob/living/carbon/human/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)

	. = get_thermal_protection(thermal_protection_flags)
	. = 1 - . // Invert from 1 = immunity to 0 = immunity.

	// Doing it this way makes multiplicative stacking not get out of hand, so two modifiers that give 0.5 protection will be combined to 0.75 in the end.
	for(var/datum/modifier/M as anything in modifiers)
		if(!isnull(M.heat_protection))
			. *= 1 - M.heat_protection

	// Code that calls this expects 1 = immunity so we need to invert again.
	. = 1 - .
	. = min(., 1.0)

/mob/living/carbon/human/get_cold_protection(temperature)
	if(COLD_RESISTANCE in mutations)
		return 1 //Fully protected from the cold.

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	. = get_thermal_protection(thermal_protection_flags)
	. = 1 - . // Invert from 1 = immunity to 0 = immunity.

	// Doing it this way makes multiplicative stacking not get out of hand, so two modifiers that give 0.5 protection will be combined to 0.75 in the end.
	for(var/datum/modifier/M as anything in modifiers)
		if(!isnull(M.cold_protection))
			// Invert the modifier values so they align with the current working value.
			. *= 1 - M.cold_protection

	// Code that calls this expects 1 = immunity so we need to invert again.
	. = 1 - .
	. = min(., 1.0)

/mob/living/carbon/human/proc/get_thermal_protection(var/flags)
	.=0
	if(flags)
		if(flags & HEAD)
			. += THERMAL_PROTECTION_HEAD
		if(flags & UPPER_TORSO)
			. += THERMAL_PROTECTION_UPPER_TORSO
		if(flags & LOWER_TORSO)
			. += THERMAL_PROTECTION_LOWER_TORSO
		if(flags & LEG_LEFT)
			. += THERMAL_PROTECTION_LEG_LEFT
		if(flags & LEG_RIGHT)
			. += THERMAL_PROTECTION_LEG_RIGHT
		if(flags & FOOT_LEFT)
			. += THERMAL_PROTECTION_FOOT_LEFT
		if(flags & FOOT_RIGHT)
			. += THERMAL_PROTECTION_FOOT_RIGHT
		if(flags & ARM_LEFT)
			. += THERMAL_PROTECTION_ARM_LEFT
		if(flags & ARM_RIGHT)
			. += THERMAL_PROTECTION_ARM_RIGHT
		if(flags & HAND_LEFT)
			. += THERMAL_PROTECTION_HAND_LEFT
		if(flags & HAND_RIGHT)
			. += THERMAL_PROTECTION_HAND_RIGHT
	return min(1,.)

/mob/living/carbon/human/handle_chemicals_in_body()

	if(inStasisNow())
		return

	if(reagents)
		chem_effects.Cut()

		if(touching)
			touching.metabolize()
		if(ingested)
			ingested.metabolize()
		if(bloodstr)
			bloodstr.metabolize()

		if(!isSynthetic())

			var/total_phoronloss = 0
			for(var/obj/item/I in src)
				if(I.contaminated)
					if(check_belly(I)) continue //VOREStation Edit
					if(src.species && src.species.get_bodytype() != "Vox" && src.species.get_bodytype() != "Shadekin")	//VOREStation Edit: shadekin
						// This is hacky, I'm so sorry.
						if(I != l_hand && I != r_hand)	//If the item isn't in your hands, you're probably wearing it. Full damage for you.
							total_phoronloss += vsc.plc.CONTAMINATION_LOSS
						else if(I == l_hand)	//If the item is in your hands, but you're wearing protection, you might be alright.
							var/l_hand_blocked = 0
							l_hand_blocked = 1-(100-getarmor(BP_L_HAND, "bio"))/100	//This should get a number between 0 and 1
							total_phoronloss += vsc.plc.CONTAMINATION_LOSS * l_hand_blocked
						else if(I == r_hand)	//If the item is in your hands, but you're wearing protection, you might be alright.
							var/r_hand_blocked = 0
							r_hand_blocked = 1-(100-getarmor(BP_R_HAND, "bio"))/100	//This should get a number between 0 and 1
							total_phoronloss += vsc.plc.CONTAMINATION_LOSS * r_hand_blocked
			if(total_phoronloss)
				if(!(status_flags & GODMODE))
					adjustToxLoss(total_phoronloss)

	if(status_flags & GODMODE)
		return 0	//godmode

	if(species.light_dam)
		var/light_amount = 0
		if(isturf(loc))
			var/turf/T = loc
			light_amount = T.get_lumcount() * 10
		if(light_amount > species.light_dam) //if there's enough light, start dying
			take_overall_damage(1,1)
		else //heal in the dark
			heal_overall_damage(1,1)

	// nutrition decrease
	if (nutrition > 0 && stat != DEAD)
		var/nutrition_reduction = species.hunger_factor

		for(var/datum/modifier/mod in modifiers)
			if(!isnull(mod.metabolism_percent))
				nutrition_reduction *= mod.metabolism_percent
		adjust_nutrition(-nutrition_reduction)

	if(noisy == TRUE && nutrition < 250 && prob(10)) //VOREStation edit for hunger noises.
		var/sound/growlsound = sound(get_sfx("hunger_sounds"))
		var/growlmultiplier = 100 - (nutrition / 250 * 100)
		playsound(src, growlsound, vol = growlmultiplier, vary = 1, falloff = 0.1, ignore_walls = TRUE, preference = /datum/client_preference/digestion_noises)
	// VOREStation Edit End

	// TODO: stomach and bloodstream organ.
	if(!isSynthetic())
		handle_trace_chems()

	updatehealth()

	return //TODO: DEFERRED

//DO NOT CALL handle_statuses() from this proc, it's called from living/Life() as long as this returns a true value.
/mob/living/carbon/human/handle_regular_status_updates()
	if(skip_some_updates())
		return 0

	if(status_flags & GODMODE)	return 0

	//SSD check, if a logged player is awake put them back to sleep!
	if(species.get_ssd(src) && !client && !teleop)
		Sleeping(2)
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = 1
		silent = 0
	else				//ALIVE. LIGHTS ARE ON
		updatehealth()	//TODO

		if(health <= config.health_threshold_dead || (should_have_organ("brain") && !has_brain()))
			death()
			blinded = 1
			silent = 0
			return 1

		//UNCONSCIOUS. NO-ONE IS HOME
		if((getOxyLoss() > (species.total_health/2)) || (health <= config.health_threshold_crit))
			Paralyse(3)

		if(hallucination)
			if(hallucination >= 20 && !(species.flags & (NO_POISON|IS_PLANT|NO_HALLUCINATION)) )
				if(prob(3))
					fake_attack(src)
				if(!handling_hal)
					spawn handle_hallucinations() //The not boring kind!
				if(client && prob(5))
					client.dir = pick(2,4,8)
					spawn(rand(20,50))
						client.dir = 1

			hallucination = max(0, hallucination - 2)
		else
			for(var/atom/a in hallucinations)
				qdel(a)

		//Brain damage from Oxyloss
		if(should_have_organ("brain"))
			var/brainOxPercent = 0.015		//Default 1.5% of your current oxyloss is applied as brain damage, 50 oxyloss is 1 brain damage
			if(CE_STABLE in chem_effects)
				brainOxPercent = 0.008		//Halved in effect
			if(oxyloss >= (getMaxHealth() * 0.3) && prob(5)) // If oxyloss exceeds 30% of your max health, you can take brain damage.
				adjustBrainLoss(brainOxPercent * oxyloss)

		if(halloss >= species.total_health)
			to_chat(src, "<span class='notice'>You're in too much pain to keep going...</span>")
			src.visible_message("<B>[src]</B> slumps to the ground, too weak to continue fighting.")
			Paralyse(10)
			setHalLoss(species.total_health - 1)

		if(paralysis || sleeping)
			blinded = 1
			set_stat(UNCONSCIOUS)
			animate_tail_reset()
			adjustHalLoss(-3)

			if(sleeping)
				handle_dreams()
				if (mind)
					//Are they SSD? If so we'll keep them asleep but work off some of that sleep var in case of stoxin or similar.
					if(client || sleeping > 3)
						AdjustSleeping(-1)
						throw_alert("asleep", /obj/screen/alert/asleep)
				if( prob(2) && health && !hal_crit && client )
					spawn(0)
						emote("snore")
		//CONSCIOUS
		else
			set_stat(CONSCIOUS)
			clear_alert("asleep")

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			var/list/E
			E = get_visible_implants(0)
			if(!E.len)
				embedded_flag = 0

		//Eyes
		//Check rig first because it's two-check and other checks will override it.
		if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/O = back
			if(O.helmet && O.helmet == head && (O.helmet.body_parts_covered & EYES))
				if((O.offline && O.offline_vision_restriction == 2) || (!O.offline && O.vision_restriction == 2))
					blinded = 1

		// Check everything else.

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			if(!embedded_needs_process())
				embedded_flag = 0
		//Vision
		var/obj/item/organ/vision
		if(species.vision_organ)
			vision = internal_organs_by_name[species.vision_organ]

		if(!species.vision_organ) // Presumably if a species has no vision organs, they see via some other means.
			SetBlinded(0)
			blinded =    0
			eye_blurry = 0
			clear_alert("blind")
		else if(!vision || vision.is_broken())   // Vision organs cut out or broken? Permablind.
			SetBlinded(1)
			blinded =    1
			eye_blurry = 1
			throw_alert("blind", /obj/screen/alert/blind)
		else //You have the requisite organs
			if(sdisabilities & BLIND) 	// Disabled-blind, doesn't get better on its own
				blinded =    1
				throw_alert("blind", /obj/screen/alert/blind)
			else if(eye_blind)		  	// Blindness, heals slowly over time
				AdjustBlinded(-1)
				blinded =    1
				throw_alert("blind", /obj/screen/alert/blind)
			else if(istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))	//resting your eyes with a blindfold heals blurry eyes faster
				eye_blurry = max(eye_blurry-3, 0)
				blinded =    1
				throw_alert("blind", /obj/screen/alert/blind)

			//blurry sight
			if(vision.is_bruised())   // Vision organs impaired? Permablurry.
				eye_blurry = 1
			if(eye_blurry)	           // Blurry eyes heal slowly
				eye_blurry = max(eye_blurry-1, 0)

		//Ears
		if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
			ear_deaf = max(ear_deaf, 1)
		else if(ear_deaf)			//deafness, heals slowly over time
			ear_deaf = max(ear_deaf-1, 0)
		else if(get_ear_protection() >= 2)	//resting your ears with earmuffs heals ear damage faster
			ear_damage = max(ear_damage-0.15, 0)
			ear_deaf = max(ear_deaf, 1)
		else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
			ear_damage = max(ear_damage-0.05, 0)

		//Resting
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
			adjustHalLoss(-3)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)
			adjustHalLoss(-1)

		if (drowsyness)
			drowsyness = max(0, drowsyness - 1)
			eye_blurry = max(2, eye_blurry)
			if (prob(5))
				Sleeping(1)
				Paralyse(5)

		// If you're dirty, your gloves will become dirty, too.
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

	return 1

/mob/living/carbon/human/set_stat(var/new_stat)
	. = ..()
	if(. && stat)
		update_skin(1)

/mob/living/carbon/human/handle_regular_hud_updates()
	if(hud_updateflag) // update our mob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()

	// now handle what we see on our screen

	if(!client)
		return 0

	..()

	client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science, global_hud.material, global_hud.whitense)

	if(istype(client.eye,/obj/machinery/camera))
		var/obj/machinery/camera/cam = client.eye
		client.screen |= cam.client_huds

	if(stat == DEAD) //Dead
		if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO
		if(healths)		healths.icon_state = "health7"	//DEAD healthmeter

	else if(stat == UNCONSCIOUS && health <= 0) //Crit
		//Critical damage passage overlay
		var/severity = 0
		switch(health)
			if(-20 to -10)			severity = 1
			if(-30 to -20)			severity = 2
			if(-40 to -30)			severity = 3
			if(-50 to -40)			severity = 4
			if(-60 to -50)			severity = 5
			if(-70 to -60)			severity = 6
			if(-80 to -70)			severity = 7
			if(-90 to -80)			severity = 8
			if(-95 to -90)			severity = 9
			if(-INFINITY to -95)	severity = 10
		overlay_fullscreen("crit", /obj/screen/fullscreen/crit, severity)
	else //Alive
		clear_fullscreen("crit")
		//Oxygen damage overlay
		if(oxyloss)
			var/severity = 0
			switch(oxyloss)
				if(10 to 20)		severity = 1
				if(20 to 25)		severity = 2
				if(25 to 30)		severity = 3
				if(30 to 35)		severity = 4
				if(35 to 40)		severity = 5
				if(40 to 45)		severity = 6
				if(45 to INFINITY)	severity = 7
			overlay_fullscreen("oxy", /obj/screen/fullscreen/oxy, severity)
		else
			clear_fullscreen("oxy")

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.getShockBruteLoss() + src.getShockFireLoss() + damageoverlaytemp	//Doesn't call the overlay if you can't actually feel it
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/severity = 0
			switch(hurtdamage)
				if(10 to 25)		severity = 1
				if(25 to 40)		severity = 2
				if(40 to 55)		severity = 3
				if(55 to 70)		severity = 4
				if(70 to 85)		severity = 5
				if(85 to INFINITY)	severity = 6
			overlay_fullscreen("brute", /obj/screen/fullscreen/brute, severity)
		else
			clear_fullscreen("brute")

		if(healths)
			if (chem_effects[CE_PAINKILLER] > 100)
				healths.icon_state = "health_numb"
			else
				// Generate a by-limb health display.
				var/mutable_appearance/healths_ma = new(healths)
				healths_ma.icon_state = "blank"
				healths_ma.overlays = null
				healths_ma.plane = PLANE_PLAYER_HUD

				var/no_damage = 1
				var/trauma_val = 0 // Used in calculating softcrit/hardcrit indicators.
				if(!(species.flags & NO_PAIN))
					trauma_val = max(traumatic_shock,halloss)/species.total_health
				var/limb_trauma_val = trauma_val*0.3
				// Collect and apply the images all at once to avoid appearance churn.
				var/list/health_images = list()
				for(var/obj/item/organ/external/E in organs)
					if(no_damage && (E.brute_dam || E.burn_dam))
						no_damage = 0
					health_images += E.get_damage_hud_image(limb_trauma_val)

				// Apply a fire overlay if we're burning.
				if(on_fire)
					health_images += image('icons/mob/OnFire.dmi',"[get_fire_icon_state()]")

				// Show a general pain/crit indicator if needed.
				if(trauma_val)
					if(!(species.flags & NO_PAIN))
						if(trauma_val > 0.7)
							health_images += image('icons/mob/screen1_health.dmi',"softcrit")
						if(trauma_val >= 1)
							health_images += image('icons/mob/screen1_health.dmi',"hardcrit")
				else if(no_damage)
					health_images += image('icons/mob/screen1_health.dmi',"fullhealth")

				healths_ma.add_overlay(health_images)
				healths.appearance = healths_ma


		var/fat_alert = /obj/screen/alert/fat
		var/hungry_alert = /obj/screen/alert/hungry
		var/starving_alert = /obj/screen/alert/starving

		if(isSynthetic())
			fat_alert = /obj/screen/alert/fat/synth
			hungry_alert = /obj/screen/alert/hungry/synth
			starving_alert = /obj/screen/alert/starving/synth
		//VOREStation Add - Vampire hunger alert
		else if(get_species() == SPECIES_CUSTOM)
			var/datum/species/custom/C = species
			if(/datum/trait/neutral/bloodsucker in C.traits)
				fat_alert = /obj/screen/alert/fat/vampire
				hungry_alert = /obj/screen/alert/hungry/vampire
				starving_alert = /obj/screen/alert/starving/vampire
		//VOREStation Add End

		switch(nutrition)
			if(450 to INFINITY)
				throw_alert("nutrition", fat_alert)
			// if(350 to 450)
			// if(250 to 350) // Alternative more-detailed tiers, not used.
			if(250 to 450)
				clear_alert("nutrition")
			if(150 to 250)
				throw_alert("nutrition", hungry_alert)
			else
				throw_alert("nutrition", starving_alert)

		if(blinded)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
			throw_alert("blind", /obj/screen/alert/blind)
		else
			clear_fullscreen("blind")
			clear_alert("blind")

		var/apply_nearsighted_overlay = FALSE
		if(disabilities & NEARSIGHTED)
			apply_nearsighted_overlay = TRUE

			if(glasses)
				var/obj/item/clothing/glasses/G = glasses
				if(G.prescription)
					apply_nearsighted_overlay = FALSE

			if(nif && nif.flag_check(NIF_V_CORRECTIVE, NIF_FLAGS_VISION)) // VOREStation Edit - NIF
				apply_nearsighted_overlay = FALSE

		set_fullscreen(apply_nearsighted_overlay, "nearsighted", /obj/screen/fullscreen/impaired, 1)

		set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)
		set_fullscreen(druggy, "high", /obj/screen/fullscreen/high)
		if(druggy)
			throw_alert("high", /obj/screen/alert/high)
		else
			clear_alert("high")

		if(!isbelly(loc)) clear_fullscreen("belly") //VOREStation Add - Belly fullscreens safety

		if(config.welder_vision)
			var/found_welder
			if(species.short_sighted)
				found_welder = 1
			else
				if(istype(glasses, /obj/item/clothing/glasses/welding))
					var/obj/item/clothing/glasses/welding/O = glasses
					if(!O.up)
						found_welder = 1
				if(!found_welder && nif && nif.flag_check(NIF_V_UVFILTER,NIF_FLAGS_VISION))	found_welder = 1 //VOREStation Add - NIF
				if(istype(glasses, /obj/item/clothing/glasses/sunglasses/thinblindfold))
					found_welder = 1
				if(!found_welder && istype(head, /obj/item/clothing/head/welding))
					var/obj/item/clothing/head/welding/O = head
					if(!O.up)
						found_welder = 1
				if(!found_welder && istype(back, /obj/item/weapon/rig))
					var/obj/item/weapon/rig/O = back
					if(O.helmet && O.helmet == head && (O.helmet.body_parts_covered & EYES))
						if((O.offline && O.offline_vision_restriction == 1) || (!O.offline && O.vision_restriction == 1))
							found_welder = 1
				if(absorbed) found_welder = 1 //VOREStation Code
			if(found_welder)
				client.screen |= global_hud.darkMask

/mob/living/carbon/human/reset_view(atom/A)
	..()
	if(machine_visual && machine_visual != A)
		machine_visual.remove_visual(src)

/mob/living/carbon/human/handle_vision()
	if(stat == DEAD)
		sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
		see_in_dark = 8
		if(client)
			if(client.view != world.view) // If mob dies while zoomed in with device, unzoom them.
				for(var/obj/item/item in contents)
					if(item.zoom)
						item.zoom()
						break

	else //We aren't dead
		sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_invisible = see_in_dark>2 ? SEE_INVISIBLE_LEVEL_ONE : see_invisible_default

		// Do this early so certain stuff gets turned off before vision is assigned.
		var/area/A = get_area(src)
		if(A?.no_spoilers)
			disable_spoiler_vision()

		if(XRAY in mutations)
			sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
			see_in_dark = 8
			if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO

		if(seer==1)
			var/obj/effect/rune/R = locate() in loc
			if(R && R.word1 == cultwords["see"] && R.word2 == cultwords["hell"] && R.word3 == cultwords["join"])
				see_invisible = SEE_INVISIBLE_CULT
			else
				see_invisible = see_invisible_default
				seer = 0

		if(!seedarkness)
			sight = species.get_vision_flags(src)
			see_in_dark = 8
			see_invisible = SEE_INVISIBLE_NOLIGHTING

		else
			sight = species.get_vision_flags(src)
			see_in_dark = species.darksight
			see_invisible = see_in_dark>2 ? SEE_INVISIBLE_LEVEL_ONE : see_invisible_default

		var/glasses_processed = 0
		var/obj/item/weapon/rig/rig = get_rig()
		if(istype(rig) && rig.visor && !looking_elsewhere)
			if(!rig.helmet || (head && rig.helmet == head))
				if(rig.visor && rig.visor.vision && rig.visor.active && rig.visor.vision.glasses)
					glasses_processed = process_glasses(rig.visor.vision.glasses)

		if(glasses && !glasses_processed && !looking_elsewhere)
			glasses_processed = process_glasses(glasses)
		if(XRAY in mutations)
			sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
			see_in_dark = 8
			if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO

		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.vision_flags))
				sight |= M.vision_flags

		if(!glasses_processed && nif)
			var/datum/nifsoft/vision_soft
			for(var/datum/nifsoft/NS in nif.nifsofts)
				if(NS.vision_exclusive && NS.active)
					vision_soft = NS
					break
			if(vision_soft)
				glasses_processed = process_nifsoft_vision(vision_soft)		//not really glasses but equitable

		if(!glasses_processed && (species.get_vision_flags(src) > 0))
			sight |= species.get_vision_flags(src)
		if(!seer && !glasses_processed && seedarkness)
			see_invisible = see_invisible_default

		if(machine)
			var/viewflags = machine.check_eye(src)
			if(viewflags < 0)
				reset_view(null, 0)
			else if(viewflags && !looking_elsewhere)
				sight |= viewflags
			else
				machine.apply_visual(src)
		else if(eyeobj)
			if(eyeobj.owner != src)

				reset_view(null)
		else
			var/isRemoteObserve = 0
			if((mRemote in mutations) && remoteview_target)
				if(remoteview_target.stat==CONSCIOUS)
					isRemoteObserve = 1
			if(!isRemoteObserve && client && !client.adminobs)
				remoteview_target = null
				reset_view(null, 0)
	return 1

/mob/living/carbon/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	. = FALSE
	if(G && G.active)
		if(G.darkness_view)
			see_in_dark += G.darkness_view
			. = TRUE
		if(G.overlay && client)
			client.screen |= G.overlay
		if(G.vision_flags)
			sight |= G.vision_flags
			. = TRUE
		if(istype(G,/obj/item/clothing/glasses/night) && !seer)
			see_invisible = SEE_INVISIBLE_MINIMUM

		if(G.see_invisible >= 0)
			see_invisible = G.see_invisible
			. = TRUE
		else if(!druggy && !seer)
			see_invisible = see_invisible_default

/mob/living/carbon/human/proc/process_nifsoft_vision(var/datum/nifsoft/NS)
	. = FALSE
	if(NS && NS.active)
		if(NS.darkness_view)
			see_in_dark += NS.darkness_view
			. = TRUE
		if(NS.vision_flags_mob)
			sight |= NS.vision_flags_mob
			. = TRUE

/mob/living/carbon/human/handle_random_events()
	if(inStasisNow())
		return

	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 30 && isSynthetic())
			if(!confused)
				if(prob(5))
					to_chat(src, "<span class='danger'>You lose directional control!</span>")
					Confuse(10)
		if (getToxLoss() >= 45 && !isSynthetic())
			spawn vomit()


	//0.1% chance of playing a scary sound to someone who's in complete darkness
	if(isturf(loc) && rand(1,1000) == 1)
		var/turf/T = loc
		if(T.get_lumcount() <= LIGHTING_SOFT_THRESHOLD)
			playsound_local(src,pick(scarySounds),50, 1, -1)

/mob/living/carbon/human/handle_stomach()
	spawn(0)
		for(var/mob/living/M in stomach_contents)
			if(M.loc != src)
				stomach_contents.Remove(M)
				continue
			if(istype(M, /mob/living/carbon) && stat != 2)
				if(M.stat == 2)
					M.death(1)
					stomach_contents.Remove(M)
					qdel(M)
					continue
				if(air_master.current_cycle%3==1)
					if(!(M.status_flags & GODMODE))
						M.adjustBruteLoss(5)
					adjust_nutrition(10)

/mob/living/carbon/human/proc/handle_changeling()
	if(mind && mind.changeling)
		mind.changeling.regenerate()
		if(hud_used)
			ling_chem_display.invisibility = 0
//			ling_chem_display.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#dd66dd'>[round(mind.changeling.chem_charges)]</font></div>"
			switch(mind.changeling.chem_storage)
				if(1 to 50)
					switch(mind.changeling.chem_charges)
						if(0 to 9)
							ling_chem_display.icon_state = "ling_chems0"
						if(10 to 19)
							ling_chem_display.icon_state = "ling_chems10"
						if(20 to 29)
							ling_chem_display.icon_state = "ling_chems20"
						if(30 to 39)
							ling_chem_display.icon_state = "ling_chems30"
						if(40 to 49)
							ling_chem_display.icon_state = "ling_chems40"
						if(50)
							ling_chem_display.icon_state = "ling_chems50"
				if(51 to 80) //This is a crappy way of checking for engorged sacs...
					switch(mind.changeling.chem_charges)
						if(0 to 9)
							ling_chem_display.icon_state = "ling_chems0e"
						if(10 to 19)
							ling_chem_display.icon_state = "ling_chems10e"
						if(20 to 29)
							ling_chem_display.icon_state = "ling_chems20e"
						if(30 to 39)
							ling_chem_display.icon_state = "ling_chems30e"
						if(40 to 49)
							ling_chem_display.icon_state = "ling_chems40e"
						if(50 to 59)
							ling_chem_display.icon_state = "ling_chems50e"
						if(60 to 69)
							ling_chem_display.icon_state = "ling_chems60e"
						if(70 to 79)
							ling_chem_display.icon_state = "ling_chems70e"
						if(80)
							ling_chem_display.icon_state = "ling_chems80e"
	else
		if(mind && hud_used)
			ling_chem_display.invisibility = 101

/mob/living/carbon/human/handle_shock()
	..()
	if(status_flags & GODMODE)	return 0	//godmode
	if(!can_feel_pain()) return

	if(health < config.health_threshold_softcrit)// health 0 makes you immediately collapse
		shock_stage = max(shock_stage, 61)

	if(traumatic_shock >= 80)
		shock_stage += 1
	else if(health < config.health_threshold_softcrit)
		shock_stage = max(shock_stage, 61)
	else
		shock_stage = min(shock_stage, 160)
		shock_stage = max(shock_stage-1, 0)

	if(stat)
		return 0

	if(shock_stage == 10)
		custom_pain("[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!", 40)

	if(shock_stage >= 30)
		if(shock_stage == 30 && !isbelly(loc)) //VOREStation Edit
			custom_emote(VISIBLE_MESSAGE, "is having trouble keeping their eyes open.")
		eye_blurry = max(2, eye_blurry)
		stuttering = max(stuttering, 5)

	if(shock_stage == 40)
		to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please&#44; just end the pain", "Your whole body is going numb")]!</span>")

	if (shock_stage >= 60)
		if(shock_stage == 60 && !isbelly(loc)) //VOREStation Edit
			custom_emote(VISIBLE_MESSAGE, "'s body becomes limp.")
		if (prob(2))
			to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please&#44; just end the pain", "Your whole body is going numb")]!</span>")
			Weaken(20)

	if(shock_stage >= 80)
		if (prob(5))
			to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please&#44; just end the pain", "Your whole body is going numb")]!</span>")
			Weaken(20)

	if(shock_stage >= 120)
		if (prob(2))
			to_chat(src, "<span class='danger'>[pick("You black out", "You feel like you could die any moment now", "You are about to lose consciousness")]!</span>")
			Paralyse(5)

	if(shock_stage == 150)
		if(!isbelly(loc)) //VOREStation Edit
			custom_emote(VISIBLE_MESSAGE, "can no longer stand, collapsing!")
		Weaken(20)

	if(shock_stage >= 150)
		Weaken(20)

/mob/living/carbon/human/proc/handle_pulse()
	if(life_tick % 5) return pulse	//update pulse every 5 life ticks (~1 tick/sec, depending on server load)

	var/temp = PULSE_NORM

	var/brain_modifier = 1

	var/modifier_shift = 0
	var/modifier_set

	if(modifiers && modifiers.len)
		for(var/datum/modifier/mod in modifiers)
			if(isnull(modifier_set) && !isnull(mod.pulse_set_level))
				modifier_set = round(mod.pulse_set_level)	// Should be a whole number, but let's not take chances.
			else if(mod.pulse_set_level > modifier_set)
				modifier_set = round(mod.pulse_set_level)

			modifier_set = max(0, modifier_set)	// No setting to negatives.

			if(mod.pulse_modifier)
				modifier_shift += mod.pulse_modifier

	modifier_shift = round(modifier_shift)

	if(!internal_organs_by_name[O_HEART])
		temp = PULSE_NONE
		if(!isnull(modifier_set))
			temp = modifier_set
		return temp //No blood, no pulse.

	if(stat == DEAD)
		temp = PULSE_NONE
		if(!isnull(modifier_set))
			temp = modifier_set
		return temp	//that's it, you're dead, nothing can influence your pulse, aside from outside means.

	var/obj/item/organ/internal/heart/Pump = internal_organs_by_name[O_HEART]

	var/obj/item/organ/internal/brain/Control = internal_organs_by_name[O_BRAIN]

	if(Control)
		brain_modifier = Control.get_control_efficiency()

		if(brain_modifier <= 0.7 && brain_modifier >= 0.4) // 70%-40% control, things start going weird as the brain is failing.
			brain_modifier = rand(5, 15) / 10

	if(Pump)
		temp += Pump.standard_pulse_level - PULSE_NORM

	if(round(vessel.get_reagent_amount("blood")) <= species.blood_volume*species.blood_level_danger)	//how much blood do we have
		temp = temp + 3	//not enough :(

	if(status_flags & FAKEDEATH)
		temp = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

	if(!isnull(modifier_set))
		temp = modifier_set

	temp = max(0, temp + modifier_shift)	// No negative pulses.

	if(Pump)
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id in bradycardics)
				if(temp <= Pump.standard_pulse_level + 3 && temp >= Pump.standard_pulse_level)
					temp--
			if(R.id in tachycardics)
				if(temp <= Pump.standard_pulse_level + 1 && temp >= PULSE_NONE)
					temp++
			if(R.id in heartstopper) //To avoid using fakedeath
				temp = PULSE_NONE
			if(R.id in cheartstopper) //Conditional heart-stoppage
				if(R.volume >= R.overdose)
					temp = PULSE_NONE
		return temp * brain_modifier
	//handles different chems' influence on pulse
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.id in bradycardics)
			if(temp <= PULSE_THREADY && temp >= PULSE_NORM)
				temp--
		if(R.id in tachycardics)
			if(temp <= PULSE_FAST && temp >= PULSE_NONE)
				temp++
		if(R.id in heartstopper) //To avoid using fakedeath
			temp = PULSE_NONE
		if(R.id in cheartstopper) //Conditional heart-stoppage
			if(R.volume >= R.overdose)
				temp = PULSE_NONE

	return max(0, round(temp * brain_modifier))

/mob/living/carbon/human/proc/handle_heartbeat()
	if(pulse == PULSE_NONE)
		return

	var/obj/item/organ/internal/heart/H = internal_organs_by_name[O_HEART]

	if(!H || (H.robotic >= ORGAN_ROBOT))
		return

	if(pulse >= PULSE_2FAST || shock_stage >= 10 || (istype(get_turf(src), /turf/space) && is_preference_enabled(/datum/client_preference/play_ambiance)))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse)/2

		if(heartbeat >= rate)
			heartbeat = 0
			src << sound('sound/effects/singlebeat.ogg',0,0,0,50)
		else
			heartbeat++

/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements need to change as determined by the mobs hud_updateflag.
*/
/mob/living/carbon/human/proc/handle_hud_list()
	if (BITTEST(hud_updateflag, HEALTH_HUD))
		var/image/holder = grab_hud(HEALTH_HUD)
		if(stat == DEAD)
			holder.icon_state = "-100" 	// X_X
		else
			holder.icon_state = RoundHealth((health-config.health_threshold_crit)/(getMaxHealth()-config.health_threshold_crit)*100)
		apply_hud(HEALTH_HUD, holder)

	if (BITTEST(hud_updateflag, LIFE_HUD))
		var/image/holder = grab_hud(LIFE_HUD)
		if(isSynthetic())
			holder.icon_state = "hudrobo"
		else if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		apply_hud(LIFE_HUD, holder)

	if (BITTEST(hud_updateflag, STATUS_HUD))
		var/foundVirus = 0
		for (var/ID in virus2)
			if (ID in virusDB)
				foundVirus = 1
				break

		var/image/holder = grab_hud(STATUS_HUD)
		var/image/holder2 = grab_hud(STATUS_HUD_OOC)
		if (isSynthetic())
			holder.icon_state = "hudrobo"
		else if(stat == DEAD)
			holder.icon_state = "huddead"
			holder2.icon_state = "huddead"
		else if(foundVirus)
			holder.icon_state = "hudill"
		else if(has_brain_worms())
			var/mob/living/simple_mob/animal/borer/B = has_brain_worms()
			if(B.controlling)
				holder.icon_state = "hudbrainworm"
			else
				holder.icon_state = "hudhealthy"
			holder2.icon_state = "hudbrainworm"
		else
			holder.icon_state = "hudhealthy"
			if(virus2.len)
				holder2.icon_state = "hudill"
			else
				holder2.icon_state = "hudhealthy"

		apply_hud(STATUS_HUD, holder)
		apply_hud(STATUS_HUD_OOC, holder2)

	if (BITTEST(hud_updateflag, ID_HUD))
		var/image/holder = grab_hud(ID_HUD)
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				holder.icon_state = "hud[ckey(I.GetJobName())]"
			else
				holder.icon_state = "hudunknown"
		else
			holder.icon_state = "hudunknown"

		apply_hud(ID_HUD, holder)

	if (BITTEST(hud_updateflag, WANTED_HUD))
		var/image/holder = grab_hud(WANTED_HUD)
		holder.icon_state = "hudblank"
		var/perpname = name
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name

		for(var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						holder.icon_state = "hudwanted"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						holder.icon_state = "hudprisoner"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						holder.icon_state = "hudparolled"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
						holder.icon_state = "hudreleased"
						break

		apply_hud(WANTED_HUD, holder)

	if (  BITTEST(hud_updateflag, IMPLOYAL_HUD) \
	   || BITTEST(hud_updateflag,  IMPCHEM_HUD) \
	   || BITTEST(hud_updateflag, IMPTRACK_HUD))

		var/image/holder1 = grab_hud(IMPTRACK_HUD)
		var/image/holder2 = grab_hud(IMPLOYAL_HUD)
		var/image/holder3 = grab_hud(IMPCHEM_HUD)

		holder1.icon_state = "hudblank"
		holder2.icon_state = "hudblank"
		holder3.icon_state = "hudblank"

		for(var/obj/item/weapon/implant/I in src)
			if(I.implanted)
				if(!I.malfunction)
					if(istype(I,/obj/item/weapon/implant/tracking))
						holder1.icon_state = "hud_imp_tracking"
					if(istype(I,/obj/item/weapon/implant/loyalty))
						holder2.icon_state = "hud_imp_loyal"
					if(istype(I,/obj/item/weapon/implant/chem))
						holder3.icon_state = "hud_imp_chem"

		apply_hud(IMPTRACK_HUD, holder1)
		apply_hud(IMPLOYAL_HUD, holder2)
		apply_hud(IMPCHEM_HUD, holder3)

	if (BITTEST(hud_updateflag, SPECIALROLE_HUD))
		var/image/holder = grab_hud(SPECIALROLE_HUD)
		holder.icon_state = "hudblank"
		if(mind && mind.special_role)
			if(hud_icon_reference[mind.special_role])
				holder.icon_state = hud_icon_reference[mind.special_role]
			else
				holder.icon_state = "hudsyndicate"
		apply_hud(SPECIALROLE_HUD, holder)

	attempt_vr(src,"handle_hud_list_vr",list()) //VOREStation Add - Custom HUDs.

	hud_updateflag = 0

/mob/living/carbon/human/handle_fire()
	if(..())
		return

	var/thermal_protection = get_heat_protection(fire_stacks * 1500) // Arbitrary but below firesuit max temp when below 20 stacks.

	if(thermal_protection == 1) // Immune.
		return
	else
		var/fire_temp_add = (BODYTEMP_HEATING_MAX + (fire_stacks * 15)) * (1-thermal_protection)
		//This is to prevent humans from heating up indefinitely. A human being on fire (fat burns at 250C) can't magically
		//   increase your body temperature beyond 250C, but it's possible something else (atmos) has heated us up beyond it,
		//   so don't worry about the firestacks at that point. Really, we should be cooling the room down, because it has
		//   to expend energy to heat our body up! But let's not worry about that.
		if((bodytemperature + fire_temp_add) > HUMAN_COMBUSTION_TEMP)
			return

		bodytemperature += fire_temp_add

/mob/living/carbon/human/rejuvenate()
	restore_blood()
	shock_stage = 0
	traumatic_shock = 0
	..()

/mob/living/carbon/human/proc/handle_defib_timer()
	if(!should_have_organ(O_BRAIN))
		return // No brain.

	var/obj/item/organ/internal/brain/brain = internal_organs_by_name[O_BRAIN]
	if(!brain)
		return // Still no brain.

	brain.tick_defib_timer()

#undef HUMAN_MAX_OXYLOSS
#undef HUMAN_CRIT_MAX_OXYLOSS
