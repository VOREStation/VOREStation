//Health bars in the game window would be pretty challenging and I don't know how to do that, so I thought this would be a good alternative

// Generates the progress bar text
/proc/chat_progress_bar(percentage, add_color = FALSE)
	switch(percentage)
		if(100)
			. = "|▓▓▓▓▓▓▓▓▓▓|"
		if(95 to 99)
			. = "|▓▓▓▓▓▓▓▓▓▒|"
		if(90 to 94)
			. = "|▓▓▓▓▓▓▓▓▓░|"
		if(85 to 89)
			. = "|▓▓▓▓▓▓▓▓▒░|"
		if(80 to 84)
			. = "|▓▓▓▓▓▓▓▓░░|"
		if(75 to 79)
			. = "|▓▓▓▓▓▓▓▒░░|"
		if(70 to 74)
			. = "|▓▓▓▓▓▓▓░░░|"
		if(65 to 69)
			. = "|▓▓▓▓▓▓▒░░░|"
		if(60 to 64)
			. = "|▓▓▓▓▓▓░░░░|"
		if(55 to 59)
			. = "|▓▓▓▓▓▒░░░░|"
		if(50 to 54)
			. = "|▓▓▓▓▓░░░░░|"
		if(45 to 49)
			. = "|▓▓▓▓▒░░░░░|"
		if(40 to 44)
			. = "|▓▓▓▓░░░░░░|"
		if(35 to 39)
			. = "|▓▓▓▒░░░░░░|"
		if(30 to 34)
			. = "|▓▓▓░░░░░░░|"
		if(25 to 29)
			. = "|▓▓▒░░░░░░░|"
		if(20 to 24)
			. = "|▓▓░░░░░░░░|"
		if(15 to 19)
			. = "|▓▒░░░░░░░░|"
		if(10 to 14)
			. = "|▓░░░░░░░░░|"
		if(5 to 9)
			. = "|▒░░░░░░░░░|"
		if(0)
			. = "|░░░░░░░░░░|"
		else
			. = "!░░░░░░░░░░!"

	if(add_color)
		switch(percentage)
			if(75 to 100)
				. = span_green(.)
			if(50 to 75)
				. = span_yellow(.)
			if(25 to 50)
				. = span_orange(.)
			else
				. = span_red(.)

/mob/living/proc/chat_healthbar(var/mob/living/reciever, onExamine = FALSE, override = FALSE)
	if(!reciever)	//No one to send it to, don't bother
		return
	if(!reciever.client)	//No one is home, don't bother
		return
	if(!override)	//Did the person push the verb? Ignore the pref
		if(!reciever.client.prefs?.read_preference(/datum/preference/toggle/vore_health_bars))
			return
	var/ourpercent = 0

	if(ishuman(src))	//humans don't die or become unconcious at 0%, it's actually like -50% or something, so, let's pretend they have 50 more health than they do
		ourpercent = ((health + 50) / (maxHealth + 50)) * 100
	else
		ourpercent = (health / maxHealth) * 100

	var/ourbar = ""
	var/obj/belly/ourbelly = src.loc
	var/which_var = "Health"
	var/datum/digest_mode/selective/DM_S = GLOB.digest_modes[DM_SELECT]
	var/digest_mode = ourbelly.digest_mode == DM_SELECT ? DM_S.get_selective_mode(ourbelly, src) : ourbelly.digest_mode
	if(digest_mode == DM_ABSORB || digest_mode == DM_DRAIN)
		ourpercent = round(((nutrition - 100) / 500) * 100)
		which_var = "Nutrition"	//It's secretly also a nutrition bar depending on your digest mode

	ourpercent = round(ourpercent)

	ourbar = chat_progress_bar(ourpercent, FALSE)
	ourbar = "[ourbar] [which_var] - [src.name]"

	if(stat == UNCONSCIOUS)
		ourbar = "[ourbar] - [span_orange("<b>UNCONSCIOUS</b>")]"
	else if(stat == DEAD)
		ourbar = "[ourbar] - [span_red("<b>DEAD</b>")]"
	if(absorbed)
		ourbar = span_purple("[ourbar] - ABSORBED")	//Absorb is a little funny, I didn't want it to say 'absorbing ABSORBED' so we did it different
	else if(ourpercent > 99 && digest_mode == DM_HEAL)
		ourbar = span_green("<b>[ourbar] - [digest_mode]ed</b>")
	else if(ourpercent > 75)
		ourbar = span_green("[ourbar] - [digest_mode]ing")
	else if(ourpercent > 50)
		ourbar = span_yellow("[ourbar] - [digest_mode]ing")
	else if(ourpercent > 25)
		ourbar = span_orange("[ourbar] - [digest_mode]ing")
	else if(ourpercent > 0)
		ourbar = span_red("[ourbar] - [digest_mode]ing")
	else
		ourbar = span_red("<b>[ourbar] - [digest_mode]ed</b>")

	if(onExamine)
		to_chat(reciever,span_notice("[ourbar]"))
	else
		to_chat(reciever,span_vnotice("[ourbar]"))

/mob/living/verb/print_healthbars()
	set name = "Print Prey Healthbars"
	set category = "Abilities"

	var/nuffin = TRUE

	var/obj/belly/amprey = src.loc

	if(istype(amprey))
		var/datum/digest_mode/selective/DM_S = GLOB.digest_modes[DM_SELECT]
		var/digest_mode = amprey.digest_mode == DM_SELECT ? DM_S.get_selective_mode(amprey, src) : amprey.digest_mode
		to_chat(src, span_notice("[digest_mode] - You are in [amprey.owner]'s [amprey.name]:"))
		src.chat_healthbar(src, TRUE, TRUE)
		nuffin = FALSE

	for(var/obj/belly/b in vore_organs)
		if(!b.contents.len)
			continue
		var/belly_announce = FALSE	//We only want to announce the belly once
		for(var/thing as anything in b.contents)
			if(!isliving(thing))
				continue
			if(!belly_announce)
				var/datum/digest_mode/selective/DM_S = GLOB.digest_modes[DM_SELECT]
				var/digest_mode = b.digest_mode == DM_SELECT ? DM_S.get_selective_mode(b, thing) : b.digest_mode
				to_chat(src, span_notice("[digest_mode] - Within your [b.name]:"))	//We only want to announce the belly if we found something
				belly_announce = TRUE
			var/mob/living/ourmob = thing
			ourmob.chat_healthbar(src, TRUE, TRUE)
			nuffin = FALSE
	if(nuffin)
		to_chat(src, span_warning("There are no mobs within any of your bellies to print health bars for, and you are not in a belly yourself."))
