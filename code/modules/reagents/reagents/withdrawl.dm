/datum/reagent/proc/handle_addiction(var/mob/living/carbon/M, var/alien)
	// overridable proc for custom withdrawl behaviors, standard is chills, cravings, vomiting, weakness and CE_WITHDRAWL organ damage
	if(alien == IS_DIONA)
		return 0
	var/current_addiction = M.get_addiction_to_reagent(id)
	// slow degrade
	if(prob(8))
		current_addiction  -= 1
	// withdrawl mechanics
	if(current_addiction < 10)
		if(prob(2))
			M.Weaken(1)
	else if(current_addiction > 10)
		if(CE_STABLE in M.chem_effects) // Inaprovaline can be used to treat addiction
			if(prob(1))
				switch(rand(1,3))
					if(1)
						to_chat(M, span_notice("You feel sluggish."))
					if(2)
						to_chat(M, span_notice("You feel awful."))
					if(3)
						to_chat(M, span_notice("Everything feels sore."))
				// effects
				if(current_addiction < 100 && prob(10))
					M.emote(pick("pale","shiver","twitch"))
				if(current_addiction <= 60)
					if(prob(1))
						M.Weaken(2)
					if(prob(5) && prob(1))
						M.emote("vomit")
		else
			// send a message to notify players
			if(prob(2))
				if(current_addiction <= 40)
					to_chat(M, span_danger("You're dying for some [name]!"))
				else if(current_addiction <= 60)
					to_chat(M, span_warning("You're really craving some [name]."))
				else if(current_addiction <= 100)
					to_chat(M, span_notice("You're feeling the need for some [name]."))
				// effects
				if(current_addiction < 100 && prob(20))
					M.emote(pick("pale","shiver","twitch"))
			// proc side effect
			if(current_addiction <= 30)
				if(prob(3))
					M.Weaken(2)
					M.emote("vomit")
					M.add_chemical_effect(CE_WITHDRAWL, rand(2,4) * REM)
			else if(current_addiction <= 50)
				if(prob(3))
					M.emote("vomit")
					M.add_chemical_effect(CE_WITHDRAWL, rand(1,3) * REM)
			else if(current_addiction <= 70)
				if(prob(2))
					M.emote("vomit")
	if(current_addiction <= 0) //safety
		current_addiction = 0
	return current_addiction

/datum/reagent/proc/addiction_cure_message()
	return span_notice("You feel your symptoms end, you no longer feel the craving for [name].")

/datum/reagent/proc/addiction_refresh_message()
	return span_notice("You feel rejuvenated as the [name] rushes through you.")
