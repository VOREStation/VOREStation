// addictions
#define ADDICTION_PROC -4000 // point where addiction triggers, starts counting down from 0 to here!
#define SLOWADDICT_PROC -8000 // point where certain chems with barely addictive traits will kick in
#define FASTADDICT_PROC -1000 // point where certain chems with super addictive traits will kick in
#define ADDICTION_PEAK 300 // point where addicted mobs reset to upon getting their addiction satiated... Decays over time,triggering messages and sideeffects if under 80. Most cure at 0.

/mob/living/carbon/proc/sync_addictions()
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!species)
		return
	if(!species.traits)
		return
	for(var/TR in species.traits)
		var/datum/trait/T = all_traits[TR]
		if(!T)
			continue
		if(!T.addiction)
			continue
		addict_to_reagent( T.addiction, TRUE)

/mob/living/proc/handle_addictions()
	PROTECTED_PROC(TRUE)
	// Empty so it can be overridden

/mob/living/carbon/handle_addictions()
	// Don't process this if we're part of someone else
	if(absorbed)
		return
	// All addictions start at 0.
	var/list/addict = list()
	for(var/datum/reagent/R in bloodstr.reagent_list)
		var/reagentid = R.id
		if(istype( SSchemistry.chemical_reagents[reagentid], /datum/reagent/ethanol))
			reagentid = "ethanol"
		if(reagentid in addictives)
			addict.Add(reagentid)
	// Only needed for alcohols, will interfere with pills if you detect other things!
	for(var/datum/reagent/R in ingested.reagent_list)
		var/reagentid = R.id
		if(istype( SSchemistry.chemical_reagents[reagentid], /datum/reagent/ethanol))
			reagentid = "ethanol"
		if(reagentid in addictives)
			addict.Add(reagentid)

	for(var/A in addict)
		if(!(A in addictions))
			addictions.Add(A)
			addiction_counters[A] = 0
		if(addiction_counters[A] <= 0)
			// Build addiction until it procs
			addiction_counters[A] -= rand(1,3)
			if(addiction_counters < SLOWADDICT_PROC)
				addiction_counters = SLOWADDICT_PROC
			// Check for addition
			if(A in slow_addictives)
				// Slowest addictions for some medications
				if(addiction_counters[A] <= SLOWADDICT_PROC)
					addict_to_reagent(A, FALSE)
			if(A in fast_addictives)
				// quickly addict to these drugs, bliss, oxyco etc
				if(addiction_counters[A] <= FASTADDICT_PROC)
					addict_to_reagent(A, FALSE)
			else
				// slower addiction over a longer period, cigs and painkillers mostly
				if(addiction_counters[A] <= ADDICTION_PROC)
					addict_to_reagent(A, FALSE)
		else
			// satiating addiction we already have
			if(addiction_counters[A] < ADDICTION_PEAK)
				if(addiction_counters[A] < 100)
					addiction_counters[A] = 100
					var/datum/reagent/RR = SSchemistry.chemical_reagents[A]
					to_chat(src, span_notice("You feel rejuvenated as the [RR.name] rushes through you."))
				addiction_counters[A] += rand(8,13)

	// For all counters above 100, count down
	// For all under 0, count up to 0 randomly, reducing initial addiction buildup if you didn't proc it
	if(addictions.len)
		var/C = pick(addictions)
		// return to normal... we didn't haven't been addicted yet, but we shouldn't become addicted instantly next time if it's been a few hours!
		if(addiction_counters[C] < 0)
			if(prob(15))
				addiction_counters[C] += 1
		// proc reagent's withdrawl
		if(addiction_counters[C] > 0)
			var/datum/reagent/RE = SSchemistry.chemical_reagents[C]
			addiction_counters[C] = RE.withdrawl(src,species.reagent_tag) // withdrawl can modify the value however it deems fit as you are affected by it
		// remove if finished
		if(addiction_counters[C] == 0)
			addictions.Remove(C)


/mob/living/carbon/proc/addict_to_reagent(var/reagentid, var/round_start)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	round_start = TRUE // Comment this out to make addictions ONLY affect roundstart traits
	if(isSynthetic() || !round_start) // Should this be allowed? I guess you can roleplay Bender as an FBP?
		return
	if(!(reagentid in addictions))
		addictions.Add(reagentid)
	addiction_counters[reagentid] = ADDICTION_PEAK

/mob/living/carbon/proc/get_addiction_to_reagent(var/reagentid) // returns counter's value or 0
	return addiction_counters ? addiction_counters[reagentid] : 0

#undef ADDICTION_PROC
#undef SLOWADDICT_PROC
#undef FASTADDICT_PROC
#undef ADDICTION_PEAK
