#define HUMAN_LOWEST_SLOWDOWN -3

/mob/living/carbon/human/movement_delay(oldloc, direct)

	. = 0

	if(force_max_speed)
		return HUMAN_LOWEST_SLOWDOWN

	for(var/datum/modifier/M in modifiers) //Do this before space check in case we're hasted (and use max speed)
		if(M.haste)
			return HUMAN_LOWEST_SLOWDOWN // Per haste documentation 'ignore slowdown and move really fast'. Calling ..() here adds slowdown.
		if(!isnull(M.slowdown))
			. += M.slowdown

	if(istype(loc, /turf/space))
		return ..() - 1

	. += species.slowdown

	//Quick math:
	//100 max hp w/ 0 damage = 100/100 * 100 = 100HP
	//100 max hp w/ 50 damage = (50/100) * 100 = 50HP
	//100 max hp w/ 50 halloss = (50/100) * 100 = 50HP
	//100 max hp w/ 75 damage = (25/100) * 100 = 75HP
	//200 max hp w/ 50 damage = (50/200) * 100 = 75HP
	if(species.pain_mod)
		var/health_percent = ((health / getMaxHealth()) * 100) / species.pain_mod //Species pain sensitivity does not apply to painkillers, so we apply it before

		var/hal_pain = getHalLoss() * species.pain_mod //trauma_mod is something entirely differently
		//var/hal_pain = can_feel_pain() ? (getHalLoss() * 2) * species.pain_mod : 0 //Variant for if you want pain immune people to not be affected by halloss slowdown.

		if((health_percent <= 60 || hal_pain >= 25) && !chem_effects[CE_NARCOTICS]) //Have taken 40% of our max health in damage OR we have >=25 halloss pain

			if(health_percent < 0)
				health_percent = 0 //Crit already has its own negative effects, so

			var/amount_damaged = 100 - health_percent //Get the percent.

			if(chem_effects[CE_PAINKILLER]) //On painkillers? Reduce pain! On anti-painkillers? Increase pain!
				var/painkiller_strength = chem_effects[CE_PAINKILLER]
				if(hal_pain > 25)
					hal_pain = max(0, max(25, hal_pain - (painkiller_strength * 0.33))) //Painkillers are only 33% effective against halloss pain and can never lower your hal_pain below 25. It makes it less noticible at high levels, but it can't completely nullify it (unless on narcotics)
				amount_damaged = max(0, amount_damaged - painkiller_strength)
			amount_damaged += hal_pain

			if(amount_damaged >= 25) //Still in enough pain for it to be significant?
				. += CLAMP((amount_damaged / 25), 0, 4) //Max of 4 slowdown from pain.

	var/hungry = (500 - nutrition) / 5 //Fixed 500 here instead of our huge MAX_NUTRITION
	if(hungry >= 70)
		. += hungry/50

	if(get_feralness() >= 10) //crazy feral animals give less and less of a shit about pain and hunger as they get crazier
		. = max(species.slowdown, species.slowdown+((.-species.slowdown)/(get_feralness()/10))) // As feral scales to damage, this amounts to an effective +1 slowdown cap
		if(shock_stage >= 10)
			. -= CLAMP((shock_stage / 40), 0.25, 1.5) //Feral creatures get halved shock penalty.

	if(riding_datum) //Bit of slowdown for taur rides if rider is bigger or fatter than mount.
		var/datum/riding/R = riding_datum
		var/mob/living/L = R.ridden
		for(var/mob/living/M in L.buckled_mobs)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.size_multiplier > L.size_multiplier)
					. += 1

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				. += 4
			else if(E.splinted && E.splinted.loc != E)
				. += 0.5
			else if(E.status & ORGAN_BROKEN)
				. += 1.5
	else
		. += max(2 * stance_damage, 0) //Handles missing feet/legs

	if(shock_stage >= 10)
		. += CLAMP((shock_stage / 20), 0.5, 3) //Slowly become slower the longer you're in traumatic shock. Simulates adrenaline wearing off. Entering soft crit immediately sets shock_stage to 61.

	if(FAT in mutations)
		. += 1.5

	if (bodytemperature < species.cold_level_1)
		. += (species.cold_level_1 - bodytemperature) / 10 * 1.75

	// Turf related slowdown
	var/turf/T = get_turf(src)
	. += calculate_turf_slowdown(T, direct)

	// Item related slowdown.
	var/item_tally = calculate_item_encumbrance()

	// Dragging heavy objects will also slow you down, similar to above.
	if(pulling)
		if(istype(pulling, /obj/item))
			var/obj/item/pulled = pulling
			item_tally += max(pulled.slowdown, 0)
		else if(ishuman(pulling))
			var/mob/living/carbon/human/H = pulling
			var/their_slowdown = max(H.calculate_item_encumbrance(), 1)
			item_tally = max(item_tally, their_slowdown) // If our slowdown is less than theirs, then we become as slow as them (before species modifires).

	if(item_tally > 0) //ALT-ENCUMBERANCE
		item_tally *= species.item_slowdown_mod //ALT-ENCUMBERANCE

	. += item_tally

	if(CE_SLOWDOWN in chem_effects)
		if(. >= 0 )
			. *= 1.25 //Add a quarter of penalties on top.
		. += chem_effects[CE_SLOWDOWN]

	//mRun means we don't get slowdown, so we axe the slowdown after all the slowdown stuff has been accounted for, but before speed buffs are applied.
	if(mRun in mutations)
		. = 0

	if(CE_SPEEDBOOST in chem_effects)
		if (. >= 0)	// cut any penalties in half
			. *= 0.5
		. -= chem_effects[CE_SPEEDBOOST]	// give 'em a buff on top.

	if(HAS_TRAIT(src, UNUSUAL_RUNNING) && !get_active_hand() && !get_inactive_hand()) //better not have any items on you mfer
		. -= 0.5 // ok vibe check passed, take this small movement buff and leave

	. = max(HUMAN_LOWEST_SLOWDOWN, . + CONFIG_GET(number/human_delay))	// Minimum return should be the same as force_max_speed
	. += ..()

/mob/living/carbon/human/Moved()
	. = ..()
	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	if(pose && pose_move) //clear pose on movement if choosing to
		pose = null
		pose_move = FALSE
		remove_pose_indicator()

// This calculates the amount of slowdown to receive from items worn. This does NOT include species modifiers.
// It is in a seperate place to avoid an infinite loop situation with dragging mobs dragging each other.
// Also its nice to have these things seperated.

//Return FALSE for no encumberance
/mob/proc/calculate_item_encumbrance()
	return FALSE

/mob/living/carbon/human/calculate_item_encumbrance()
	/// We check for all the items the wearer has that cause slowdown (positive or negative)
	/// We then multiply the postive ones by our species.item_slowdown_mod to slow us down more, while we leave negative ones untouched.
	/// Heavy things in your hands are affected by this change, UNLESS the thing in your hand speeds you up, in which case it doesn't.
	/// Before you look at the below for(), yes, I know. It looks ugly. However, it is REQUIRED to be done this way instead of using get_equipped_items() as that makes a new list and does a LOT. This proc is called once (or up to 3 times if someone is being dragged) every time someone moves. Making hundreds of new lists() every second is a good way to destroy you CPU.

	/// If this is STILL proving to be too resource intensive, I have left the old code commented out underneath this.
	/// Just search this file for lines labled as "ALT-ENCUMBERANCE" that are commented out.
	/// Just comment out the below code, uncomment out the version labeled 'ALT-ENCUMBERANCE', and you'll be back to the old system.

	var/total_item_slowdown = 0
	var/slowdown_mod = species.item_slowdown_mod //HIGHER = MAKES YOU SLOWER
	for(var/slot in list(back, belt, l_ear, r_ear, glasses, gloves, head, shoes, wear_id, wear_mask, wear_suit, w_uniform)) //Two things to note here. ONE: If you add a new inventory slot, ADD IT HERE. Two: If we ever get a global list on human of all the inventory slots (MINUS HANDS) add it here.
		if(!slot) //ZOOM
			continue
		var/obj/item/I = slot
		if(istype(I))
			var/item_slowdown = I.slowdown //Positive == Slows you down. Negative == Speeds you up.
			if(item_slowdown != 0) //If it's a positive number, we multiply it by out slowdown mod. Otherwise, don't do anything special.
				if(item_slowdown > 0 && slowdown_mod > 0)
					item_slowdown = item_slowdown * (slowdown_mod)

				/// Adminbus / future proofing. These should NEVER get called unless someone down the line does something crazy
				else if(slowdown_mod < 0 && item_slowdown < 0)
					item_slowdown = -(item_slowdown * slowdown_mod)
				else if(slowdown_mod < 0 && item_slowdown > 0)
					item_slowdown = item_slowdown + slowdown_mod //Yes, this is + (Adding a negative), not multiplied. You are not making the 5 slowdown rigsuit give you 5*X speed. You're getting 5-X slowdown instead.
			total_item_slowdown += item_slowdown
	for(var/hands in list(l_hand, r_hand)) //Hands get special treatment. We want slowdown_mod
		if(!hands)
			continue
		var/obj/item/H = hands
		var/item_slowdown = H.slowdown
		if(item_slowdown > 0)
			total_item_slowdown += item_slowdown * slowdown_mod
		else
			continue

	. += total_item_slowdown

	//ALT-ENCUMBERANCE below here
	/*
	if(shoes)	// Shoes can make you go faster.
		if(!buckled || (buckled && istype(buckled, /obj/machinery/power/rtg/reg)))
			. += shoes.slowdown

	// Loop through some slots, and add up their slowdowns.
	// Includes slots which can provide armor, the back slot, and suit storage.
	for(var/obj/item/I in list(wear_suit, w_uniform, back, gloves, head, s_store))
		if(istype(I,/obj/item/rig))
			for(var/obj/item/II in I.contents)
				. += II.slowdown
		. += I.slowdown

	// Hands are also included, to make the 'take off your armor instantly and carry it with you to go faster' trick no longer viable.
	// This is done seperately to disallow negative numbers (so you can't hold shoes in your hands to go faster).
	for(var/obj/item/I in list(r_hand, l_hand) )
		. += max(I.slowdown, 0)
	*/
	//ALT-ENCUMBERANCE end

// Similar to above, but for turf slowdown.
/mob/living/carbon/human/proc/calculate_turf_slowdown(turf/T, direct)
	if(!T)
		return 0

	if(T.movement_cost && !flying) //If you are flying you are probably not affected by the terrain on the ground.
		var/turf_move_cost = T.movement_cost
		if(locate(/obj/structure/catwalk) in T) //catwalks prevent turfs from slowing your
			return 0
		if(istype(T, /turf/simulated/floor/water))
			if(species.water_movement)
				turf_move_cost = CLAMP(turf_move_cost + species.water_movement, HUMAN_LOWEST_SLOWDOWN, 15)
			if(istype(shoes, /obj/item/clothing/shoes))
				var/obj/item/clothing/shoes/feet = shoes
				if(istype(feet) && feet.water_speed)
					turf_move_cost = CLAMP(turf_move_cost + feet.water_speed, HUMAN_LOWEST_SLOWDOWN, 15)
			. += turf_move_cost
		else if(istype(T, /turf/simulated/floor/outdoors/snow))
			if(species.snow_movement)
				turf_move_cost = CLAMP(turf_move_cost + species.snow_movement, HUMAN_LOWEST_SLOWDOWN, 15)
			if(istype(shoes, /obj/item/clothing/shoes))
				var/obj/item/clothing/shoes/feet = shoes
				if(istype(feet) && feet.snow_speed)
					turf_move_cost = CLAMP(turf_move_cost + feet.snow_speed, HUMAN_LOWEST_SLOWDOWN, 15)
			. += turf_move_cost
		else
			turf_move_cost = CLAMP(turf_move_cost, HUMAN_LOWEST_SLOWDOWN, 15)
			. += turf_move_cost

	// Wind makes it easier or harder to move, depending on if you're with or against the wind.
	// I don't like that so I'm commenting it out :)
/*
	if((T.is_outdoors()) && (T.z <= SSplanets.z_to_planet.len))
		var/datum/planet/P = SSplanets.z_to_planet[z]
		if(P)
			var/datum/weather_holder/WH = P.weather_holder
			if(WH && WH.wind_speed) // Is there any wind?
				// With the wind.
				if(direct & WH.wind_dir)
					. = max(. - WH.wind_speed, -1) // Wind speedup is capped to prevent supersonic speeds from a storm.
				// Against it.
				else if(direct & GLOB.reverse_dir[WH.wind_dir])
					. += WH.wind_speed

*/
#undef HUMAN_LOWEST_SLOWDOWN

///Gets whatever jetpack we may have and returns it. Checks back -> rig -> suit storage -> suit
/mob/living/carbon/human/get_jetpack()
	if(back)
		if(istype(back, /obj/item/tank/jetpack))
			return back
		var/obj/item/rig/rig = get_rig()
		if(istype(rig))
			for(var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				return module.jets
	if(s_store && istype(s_store, /obj/item/tank/jetpack))
		return s_store
	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/space/void))
		var/obj/item/clothing/suit/space/void/v = wear_suit
		if(v.tank && istype(v.tank, /obj/item/tank/jetpack))
			return v.tank


/mob/living/carbon/human/Process_Spacemove(var/check_drift = 0)
	//Can we act?
	if(restrained())	return 0

	if(..()) //Can move due to other reasons, don't use jetpack fuel
		return TRUE

	if(species.can_space_freemove || (species.can_zero_g_move && !istype(get_turf(src), /turf/space)))
		return TRUE

	if(flying) //If you're flying, you glide around!
		return TRUE

	//Do we have a working jetpack?
	var/obj/item/tank/jetpack/thrust = get_jetpack()

	if(thrust)
		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.do_thrust(0.01, src)))
			inertia_dir = 0
			return TRUE

	return FALSE

// Handle footstep sounds
/mob/living/carbon/human/handle_footstep(var/turf/T)
	if(shoes && loc == T && get_gravity(loc) && !flying)
		if(SEND_SIGNAL(shoes, COMSIG_SHOES_STEP_ACTION, m_intent))
			return
	return

/mob/living/carbon/human/set_dir(var/new_dir)
	. = ..()
	if(. && (species.tail || tail_style))
		//update_tail_showing() this is already called by update_inv_wear_suit
		update_inv_wear_suit()
