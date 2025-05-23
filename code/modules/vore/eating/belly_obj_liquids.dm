///////////////////// NUTRITION REAGENT PRODUCTION /////////////////

/obj/belly/proc/HandleBellyReagents()
	if(show_liquids && reagentbellymode && reagent_mode_flags & DM_FLAG_REAGENTSNUTRI && reagents.total_volume < custom_max_volume && !isnewplayer(owner)) //Removed if(reagentbellymode == TRUE) since that's less optimized
		if(isrobot(owner))
			var/mob/living/silicon/robot/R = owner
			if(R.cell && R.cell.charge >= gen_cost*10 && gen_interval >= gen_time)
				GenerateBellyReagents()
				gen_interval = 0
			else
				gen_interval++
		else
			if(owner.nutrition >= gen_cost && gen_interval >= gen_time)
				GenerateBellyReagents()
				gen_interval = 0
			else
				gen_interval++

/obj/belly/proc/HandleBellyReagentEffects(var/list/touchable_atoms)
	if(LAZYLEN(contents))
		if(show_liquids && reagent_touches && reagents.total_volume >= 5)
			var/affecting_amt = reagents.total_volume / max(LAZYLEN(touchable_atoms), 1)
			if(affecting_amt > 5)
				affecting_amt = 5
			if(affecting_amt >= 1)
				for(var/mob/living/L in touchable_atoms)
					if(!L.apply_reagents)
						continue
					if((L.digestable && digest_mode == DM_DIGEST))
						if(!L.permit_healbelly && is_beneficial) // Healing reagents turned off in preferences!
							continue
						if(reagents.total_volume)
							reagents.trans_to(L, affecting_amt, 1, FALSE)
					if(L.permit_healbelly && digest_mode == DM_HEAL)
						if(is_beneficial && reagents.total_volume)
							reagents.trans_to(L, affecting_amt, 1, FALSE)
				for(var/obj/item/I in touchable_atoms)
					if(is_type_in_list(I, item_digestion_blacklist))
						continue
					if(reagents.total_volume)
						reagents.trans_to(I, affecting_amt, 1, FALSE)
		SEND_SIGNAL(src, COMSIG_BELLY_UPDATE_VORE_FX, FALSE, reagents.total_volume) // Signals vore_fx() reagents updates.
		for(var/mob/living/L in contents)
			vore_fx(L, FALSE, reagents.total_volume)
	if(owner.previewing_belly == src)
		vore_fx(owner, FALSE, reagents.total_volume)

/obj/belly/proc/GenerateBellyReagents()
	if(isrobot(owner))
		var/mob/living/silicon/robot/R = owner
		if(!R.use_direct_power(gen_cost*10, 200))
			return
	else
		owner.nutrition -= gen_cost
	for(var/reagent in generated_reagents)
		reagents.add_reagent(reagent, generated_reagents[reagent])
	if(count_liquid_for_sprite)
		owner.handle_belly_update() //This is run whenever a belly's contents are changed.
	if(LAZYLEN(belly_surrounding))
		SEND_SIGNAL(src, COMSIG_BELLY_UPDATE_VORE_FX, FALSE, reagents.total_volume) // Signals vore_fx() reagents updates.

//////////////////////////// REAGENT_DIGEST ////////////////////////

/obj/belly/proc/GenerateBellyReagents_digesting()	//The rate isnt based on selected reagent, due to the fact that the price of the reagent is already paid by nutrient not gained.
	if(reagents.total_volume + (digest_nutri_gain * gen_amount) <= custom_max_volume) //By default a reagent with an amount of 1 should result in pred getting 100 units from a full health prey
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] * digest_nutri_gain / gen_cost)
	else
		owner_adjust_nutrition(digest_nutri_gain * owner.get_digestion_efficiency_modifier())
	digest_nutri_gain = 0

/obj/belly/proc/GenerateBellyReagents_digested()
	if(reagents.total_volume <= custom_max_volume - 25 * gen_amount)
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] * 25)
	else
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] / gen_amount * (custom_max_volume - reagents.total_volume))
	digest_nutri_gain = 0

//////////////////////////// REAGENT_ABSORB ////////////////////////

/obj/belly/proc/GenerateBellyReagents_absorbing()
	if(reagents.total_volume <= custom_max_volume - 1.5 * gen_amount) //Going for 1.5 amount of reagent per cycle, can be adjusted in future if need adjustments
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] * 1.5)
	else
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] / gen_amount * (custom_max_volume - reagents.total_volume))

/obj/belly/proc/GenerateBellyReagents_absorbed()
	if(reagents.total_volume <= custom_max_volume - 25 * gen_amount) //Going for 25 amount of reagent for absorbing the prey, can be adjusted in future if need adjustments
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] * 10)
	else
		for(var/reagent in generated_reagents)
			reagents.add_reagent(reagent, generated_reagents[reagent] / gen_amount * (custom_max_volume - reagents.total_volume))

//////////////////////////// REAGENT_DRAIN ///////////////////////// //Currently not needed, maybe later a specific proc for drain needs to be made - Jack



//////////////////////////// REAGENT SELECTION /////////////////////

//This is gonna end up a long proc, but its gonna have to make do for now

/obj/belly/proc/ReagentSwitch()
	var/list/our_reagents = list()
	for(var/entry in reagent_choices)
		our_reagents.Add(lowertext(entry))
	switch(reagent_chosen)
		if(REAGENT_WATER)
			generated_reagents = list(REAGENT_ID_WATER_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_WATER)
			gen_amount = 1
			gen_cost = 1
			reagentid = REAGENT_ID_WATER_BELLY
			reagentcolor = "#0064C877"
		if(REAGENT_MILK)
			generated_reagents = list(REAGENT_ID_MILK_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_MILK)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_ID_MILK_BELLY
			reagentcolor = "#DFDFDF"
		if(REAGENT_CREAM)
			generated_reagents = list(REAGENT_ID_CREAM_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_CREAM)
			gen_amount = 1
			gen_cost = 5
			reagentid = REAGENT_ID_CREAM_BELLY
			reagentcolor = "#DFD7AF"
		if(REAGENT_HONEY)
			generated_reagents = list(REAGENT_ID_HONEY_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_HONEY)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_ID_HONEY_BELLY
			reagentcolor = "#FFFF00"
		if(REAGENT_CHERRYJELLY)	//Kinda WIP, allows slime like folks something to stuff others with, should make a generic jelly in future
			generated_reagents = list(REAGENT_ID_CHERRYJELLY_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_CHERRYJELLY)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_ID_CHERRYJELLY_BELLY
			reagentcolor = "#801E28"
		if(REAGENT_STOMACID)
			generated_reagents = list(REAGENT_ID_STOMACID_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_STOMACID)
			gen_amount = 1
			gen_cost = 1
			reagentid = REAGENT_ID_STOMACID_BELLY
			reagentcolor = "#664330"
		if(REAGENT_DIETSTOMACID)
			generated_reagents = list(REAGENT_ID_DIETSTOMACID_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_DIETSTOMACID)
			gen_amount = 1
			gen_cost = 1
			reagentid = REAGENT_ID_DIETSTOMACID_BELLY
			reagentcolor = "#664330"
		if(REAGENT_CLEANER)
			generated_reagents = list(REAGENT_ID_CLEANER_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_CLEANER)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_ID_CLEANER_BELLY
			reagentcolor = "#A5F0EE"
		if(REAGENT_LUBE)
			generated_reagents = list(REAGENT_ID_LUBE_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_LUBE)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_ID_LUBE_BELLY
			reagentcolor = "#009CA8"
		if(REAGENT_BIOMASS)
			generated_reagents = list(REAGENT_ID_BIOMASS_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_BIOMASS)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_ID_BIOMASS_BELLY
			reagentcolor = "#DF9FBF"
		if(REAGENT_CONCENTRATEDRADIUM)
			generated_reagents = list(REAGENT_ID_CONCENTRATEDRADIUM_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_CONCENTRATEDRADIUM)
			gen_amount = 1
			gen_cost = 1
			reagentid = REAGENT_ID_CONCENTRATEDRADIUM_BELLY
			reagentcolor = "#C7C7C7"
		if(REAGENT_TRICORDRAZINE)
			generated_reagents = list(REAGENT_ID_TRICORDRAZINE_BELLY = 1)
			if(reagent_name in our_reagents)
				reagent_name = lowertext(REAGENT_TRICORDRAZINE)
			gen_amount = 1
			gen_cost = 10
			reagentid = REAGENT_ID_TRICORDRAZINE_BELLY
			reagentcolor = "#8040FF"
			is_beneficial = TRUE


/////////////////////// FULLNESS MESSAGES //////////////////////

// Get the line that should show up in Examine message if the owner of this belly is examined.
// Returns a string which shoul be appended to the Examine output.
// Yes I know it doesnt look great with 5 almost identical procs in a row, I didnt have a better idea at the time - Jack
/obj/belly/proc/get_reagent_examine_msg1()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness1_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return(span_red("[formatted_message]<BR>"))

/obj/belly/proc/get_reagent_examine_msg2()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness2_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return(span_red("[formatted_message]<BR>"))

/obj/belly/proc/get_reagent_examine_msg3()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness3_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return(span_red("[formatted_message]<BR>"))

/obj/belly/proc/get_reagent_examine_msg4()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness4_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return(span_red("[formatted_message]<BR>"))

/obj/belly/proc/get_reagent_examine_msg5()
	if(fullness1_messages.len)
		var/formatted_message
		var/raw_message = pick(fullness5_messages)

		formatted_message = replacetext(raw_message,"%belly",lowertext(name))
		formatted_message = replacetext(formatted_message,"%pred",owner)

		return(span_red("[formatted_message]<BR>"))


// The next function gets the messages set on the belly, in human-readable format.
// This is useful in customization boxes and such. The delimiter right now is \n\n so
// in message boxes, this looks nice and is easily delimited.
/obj/belly/proc/get_reagent_messages(var/type, var/delim = "\n\n")
	ASSERT(type == "full1" || type == "full2" || type == "full3" || type == "full4" || type == "full5")
	var/list/raw_messages

	switch(type)
		if("full1")
			raw_messages = fullness1_messages
		if("full2")
			raw_messages = fullness2_messages
		if("full3")
			raw_messages = fullness3_messages
		if("full4")
			raw_messages = fullness4_messages
		if("full5")
			raw_messages = fullness5_messages

	var/messages = raw_messages.Join(delim)
	return messages

// The next function sets the messages on the belly, from human-readable var
// replacement strings and linebreaks as delimiters (two \n\n by default).
// They also sanitize the messages.
/obj/belly/proc/set_reagent_messages(var/raw_text, var/type, var/delim = "\n\n")
	ASSERT(type == "full1" || type == "full2" || type == "full3" || type == "full4" || type == "full5")

	var/list/raw_list = splittext(html_encode(raw_text),delim)
	if(raw_list.len > 10)
		raw_list.Cut(11)
		log_debug("[owner] tried to set [lowertext(name)] with 11+ messages")

	for(var/i = 1, i <= raw_list.len, i++)
		if(length(raw_list[i]) > 160 || length(raw_list[i]) < 10) //160 is fudged value due to htmlencoding increasing the size
			raw_list.Cut(i,i)
			log_debug("[owner] tried to set [lowertext(name)] with >121 or <10 char message")
		else
			raw_list[i] = readd_quotes(raw_list[i])
			//Also fix % sign for var replacement
			raw_list[i] = replacetext(raw_list[i],"&#37;","%")

	ASSERT(raw_list.len <= 10) //Sanity

	switch(type)
		if("full1")
			fullness1_messages = raw_list
		if("full2")
			fullness2_messages = raw_list
		if("full3")
			fullness3_messages = raw_list
		if("full4")
			fullness4_messages = raw_list
		if("full5")
			fullness5_messages = raw_list

	return

/////////////////////////// Process Cycle Lite /////////////////////////// CHOMP PCL
/obj/belly/proc/quick_cycle() //For manual belly cycling without straining the bellies subsystem.
	HandleBellyReagents()	//reagent belly stuff.
	// VERY early exit
	if(!contents.len)
		return

	var/to_update = FALSE //Did anything update worthy happen?

/////////////////////////// Exit Early //////////////////////////// CHOMP PCL
	var/list/touchable_atoms = contents - items_preserved
	if(!length(touchable_atoms))
		return

	var/datum/digest_mode/DM = GLOB.digest_modes["[digest_mode]"]
	if(!DM)
		log_debug("Digest mode [digest_mode] didn't exist in the digest_modes list!!")
		return FALSE
	if(DM.handle_atoms(src, touchable_atoms))
		updateVRPanels()
		return

	var/list/touchable_mobs = null

	var/list/hta_returns = handle_touchable_atoms(touchable_atoms)
	if(islist(hta_returns))
		if(hta_returns["touchable_mobs"])
			touchable_mobs = hta_returns["touchable_mobs"]
		if(hta_returns["to_update"])
			to_update = hta_returns["to_update"]

	if(!LAZYLEN(touchable_mobs))
		return

///////////////////// Time to actually process mobs ///////////////////// CHOMP PCL
	for(var/target in touchable_mobs)
		var/mob/living/L = target
		if(!istype(L))
			continue
		var/list/returns = DM.process_mob(src, target)
		if(istype(returns) && returns["to_update"])
			to_update = TRUE

	if(to_update)
		updateVRPanels()
/////////////////////////// CHOMP PCL END ///////////////////////////

/obj/belly/proc/update_internal_overlay()
	if(LAZYLEN(belly_surrounding))
		SEND_SIGNAL(src, COMSIG_BELLY_UPDATE_VORE_FX, TRUE) // Signals vore_fx() to listening atoms. Atoms must handle appropriate isliving() checks.
	for(var/A in belly_surrounding)
		if(isliving(A))
			vore_fx(A,1)
	if(owner.previewing_belly == src)
		if(isbelly(owner.loc))
			owner.previewing_belly = null
			return
		vore_fx(owner,1)

/obj/belly/deserialize(var/list/data)
	..()
	STOP_PROCESSING(SSbellies, src)
	STOP_PROCESSING(SSobj, src)
	if(speedy_mob_processing)
		START_PROCESSING(SSobj, src)
	else
		START_PROCESSING(SSbellies, src)
