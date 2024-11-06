/mob/proc/flash_pain()
	flick("pain",pain)

/mob/var/list/pain_stored = list()
/mob/var/last_pain_message = ""
/mob/var/next_pain_time = 0
/mob/var/multilimb_pain_time = 0 // Global pain cooldown exists to prevent spam for multi-limb damage


// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-spam timer
/mob/living/carbon/proc/custom_pain(message, power, force)
	if((!message || stat || !can_feel_pain() || chem_effects[CE_PAINKILLER] > power) && !synth_cosmetic_pain)
		return 0
	message = span_danger("[message]")
	if(power >= 50)
		message = "<font size=3>[message]</font>"

	// Anti message spam checks
	// If multiple limbs are injured, cooldown is ignored to print all injuries until all limbs are iterated over
	if(client?.prefs?.read_preference(/datum/preference/toggle/pain_frequency))
		switch(power)
			if(0 to 5)
				force = 0
			if(6 to 20)
				force = prob(1)
		if(force || (message != last_pain_message) || (world.time >= next_pain_time))
			switch(power)
				if(0 to 5)
					next_pain_time = world.time + 300 SECONDS
					multilimb_pain_time = world.time + 45 SECONDS
				if(6 to 20)
					next_pain_time = world.time + clamp((30 - power) SECONDS, 10 SECONDS, 30 SECONDS)
					multilimb_pain_time = world.time + clamp((30 - power) SECONDS, 10 SECONDS, 30 SECONDS)
				if(21 to INFINITY)
					next_pain_time = world.time + (100 - power)
					multilimb_pain_time = world.time + (100 - power)
			last_pain_message = message
			to_chat(src,message)

	else if(force || (message != last_pain_message) || (world.time >= next_pain_time))
		last_pain_message = message
		to_chat(src,message)
		next_pain_time = world.time + (100 - power)
		multilimb_pain_time = world.time + (100 - power)

/mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return

	if(!can_feel_pain() && !synth_cosmetic_pain)
		return

	if(world.time < multilimb_pain_time) //prevents spam in case of multi-limb injuries.
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		if(!E.organ_can_feel_pain() && !synth_cosmetic_pain) continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
			if(istype(src, /mob/living/carbon/human)) //VOREStation Edit Start
				var/mob/living/carbon/human/H = src
				maxdam *= H.species.trauma_mod //VOREStation edit end
	if(damaged_organ && chem_effects[CE_PAINKILLER] < maxdam)
		if(maxdam > 10 && paralysis)
			AdjustParalysis(-round(maxdam/10))
		if(maxdam > 50 && prob(maxdam / 5))
			drop_item()
		var/burning = damaged_organ.burn_dam > damaged_organ.brute_dam
		var/msg
		switch(maxdam)
			if(1 to 10)
				msg =  "Your [damaged_organ.name] [burning ? "burns" : "hurts"]."
			if(11 to 90)
				flash_weak_pain()
				msg = "<font size=2>Your [damaged_organ.name] [burning ? "burns" : "hurts"] badly!</font>"
			if(91 to 10000)
				flash_pain()
				msg = "<font size=3>OH GOD! Your [damaged_organ.name] is [burning ? "on fire" : "hurting terribly"]!</font>"
		custom_pain(msg, maxdam, prob(10))

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/I in internal_organs)
		if((I.status & ORGAN_DEAD) || I.robotic >= ORGAN_ROBOT) continue
		if(I.damage > 2) if(prob(2))
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			src.custom_pain("You feel a sharp pain in your [parent.name]", 50)

	if(prob(2))
		switch(getToxLoss())
			if(1 to 10)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(11 to 30)
				custom_pain("Your body hurts a little.", getToxLoss())
			if(31 to 60)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(61 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad.", getToxLoss())
