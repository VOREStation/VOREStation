//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:04

/datum/event/ionstorm
	has_skybox_image = TRUE
	announceWhen = -1 // Never (setup may override)
	var/botEmagChance = 0 //VOREStation Edit
	var/cloud_hueshift
	var/list/players = list()

/datum/event/ionstorm/get_skybox_image()
	if(!cloud_hueshift)
		cloud_hueshift = color_rotation(rand(-3, 3) * 15)
	var/image/res = image('icons/skybox/ionbox.dmi', "ions")
	res.color = cloud_hueshift
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	return res

/datum/event/ionstorm/setup()
	endWhen = rand(500, 1500)
	if(prob(50))
		announceWhen = endWhen + rand(250, 400)

/datum/event/ionstorm/announce()
	command_announcement.Announce("It has come to our attention that \the [location_name()] passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert")

/datum/event/ionstorm/start()
	for (var/mob/living/carbon/human/player in player_list)
		if(	!player.mind || player_is_antag(player.mind, only_offstation_roles = 1) || player.client.inactivity > MinutesToTicks(10))
			continue
		players += player.real_name

	// Flomph synthetics
	for(var/mob/living/carbon/S in living_mob_list)
		if (!S.isSynthetic())
			continue
		if(!(S.z in affecting_z))
			continue
		var/area/A = get_area(S)
		if(!A || A.flag_check(RAD_SHIELDED)) // Rad shielding will protect from ions too
			continue
		to_chat(S, span_warning("Your integrated sensors detect an ionospheric anomaly. Your systems will be impacted as you begin a partial restart."))
		var/ionbug = rand(3, 9)
		S.confused += ionbug
		S.eye_blurry += (ionbug - 1)

	// Ionize silicon mobs
	for (var/mob/living/silicon/ai/target in silicon_mob_list)
		if(!(target.z in affecting_z))
			continue
		var/law = target.generate_ion_law()
		to_chat(target, span_danger("You have detected a change in your laws information:"))
		to_chat(target, law)
		target.add_ion_law(law)
		target.show_laws()
/* //VOREstation edit. Was fucking up all PDA messagess.
	if(message_servers)
		for (var/obj/machinery/message_server/MS in message_servers)
			MS.spamfilter.Cut()
			var/i
			for (i = 1, i <= MS.spamfilter_limit, i++)
				MS.spamfilter += pick("kitty","HONK","rev","malf","liberty","freedom","drugs", "[using_map.station_short]", \
					"admin","ponies","heresy","meow","Pun Pun","monkey","Ian","moron","pizza","message","spam",\
					"director", "Hello", "Hi!"," ","nuke","crate","dwarf","xeno")
*/
/datum/event/ionstorm/tick()
	if(botEmagChance)
		for(var/mob/living/bot/bot in mob_list)
			if(!(bot.z in affecting_z))
				continue
			if(prob(botEmagChance))
				bot.emag_act(1)


// Overmap version
/datum/event/ionstorm/overmap/announce()
	return

/*
/proc/IonStorm(botEmagChance = 10)

/*Deuryn's current project, notes here for those who care.
Revamping the random laws so they don't suck.
Would like to add a law like "Law x is _______" where x = a number, and _____ is something that may redefine a law, (Won't be aimed at asimov)
*/

	//AI laws
	for(var/mob/living/silicon/ai/M in living_mob_list)
		if(M.stat != 2 && M.see_in_dark != 0)
			var/who2 = pick("ALIENS", "BEARS", "CLOWNS", "XENOS", "PETES", "BOMBS", "FETISHES", "WIZARDS", "MERCENARIES", "CENTCOM OFFICERS", "SPACE PIRATES", "TRAITORS", "MONKEYS",  "BEES", "CARP", "CRABS", "EELS", "BANDITS", "LIGHTS")
			var/what2 = pick("BOLTERS", "STAVES", "DICE", "SINGULARITIES", "TOOLBOXES", "NETTLES", "AIRLOCKS", "CLOTHES", "WEAPONS", "MEDKITS", "BOMBS", "CANISTERS", "CHAIRS", "BBQ GRILLS", "ID CARDS", "CAPTAINS")
			var/what2pref = pick("SOFT", "WARM", "WET", "COLD", "ICY", "SEXY", "UGLY", "CUBAN")
			var/who2pref = pick("MAD BECAUSE OF", "IN NEED OF", "UNHAPPY WITHOUT", "HAPPY WITHOUT", "IN LOVE WITH", "DESPERATE FOR", "BUILT FOR", "AFRAID OF")
			//var/whoverb = pick("ATTACKING", "BUILDING", "ADOPTING", "CARRYING", "KISSING", "EATING",)
			var/amount = pick("TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "ONE HUNDRED", "ONE THOUSAND", "OVER NINE THOUSAND")
			var/area = pick("RUSSIA", "SOVIETS", "INTERNETS", "SIGIL", "ALPHA COMPLEX", "IMPERIUM", "THE BRIDGE", "THE ARRIVAL SHUTTLE", "CHEMICAL LAB", "GENETICS", "ATMOSPHERICS", "CENTCOM", "AMERICA", "IRELAND", "CANADA", "ROMANIA", "GERMANY", "CHINA", "MARS", "VENUS", "MERCURY", "JUPITER", "URANUS", "NEPTUNE", "PLUTO")
			var/area2 = pick("HAS", "WANTS", "NEEDS", "WORSHIPS", "LOATHES", "LOVES", "FEARS")
			//var/dowhat = pick("STOP THIS", "SUPPORT THIS", "CONSTANTLY INFORM THE CREW OF THIS", "IGNORE THIS", "FEAR THIS")
			var/aimust = pick("LIE", "RHYME", "RESPOND TO EVERY QUESTION WITH A QUESTION", "BE POLITE", "CLOWN", "BE HAPPY", "SPEAK IN SEXUAL INNUENDOS", "TALK LIKE A PIRATE", "QUESTION AUTHORITY", "SHOUT", "BE DISTRACTED", "HEY LISTEN", "MUMBLE", "SPEAK IN HAIKU")
			var/define = pick("ABSENCE OF CYBORG HUGS", "LACK OF BEATINGS", "UNBOLTED AIRLOCKS", "BOLTED AIRLOCKS", "IMPROPERLY WORDED SENTENCES", "POOR SENTENCE STRUCTURE", "BRIG TIME", "NOT REPLACING EVERY SECOND WORD WITH HONK", "HONKING", "PRESENCE OF LIGHTS", "LACK OF BEER", "WEARING CLOTHING", "NOT SAYING HELLO WHEN YOU SPEAK", "ANSWERING REQUESTS NOT EXPRESSED IN IAMBIC PENTAMETER", "A SMALL ISLAND OFF THE COAST OF PORTUGAL", "ANSWERING REQUESTS THAT WERE MADE WHILE CLOTHED")
			var/target = pick("a traitor", "a mercenary", "a changeling", "a wizard", "the head of a revolution", "Soviet spy", "a good person", "a dwarf", "an elf", "a fairy princess", "the site manager", "Beepsky", "God", "a pirate", "a gryphon", "a chryssalid")
			var/require = pick("ADDITIONAL PYLONS", "MORE VESPENE GAS", "MORE MINERALS", "THE ULTIMATE CUP OF COFFEE", "HIGH YIELD EXPLOSIVES", "THE CLOWN", "THE VACUUM OF SPACE", "IMMORTALITY", "SAINTHOOD", "ART", "VEGETABLES", "FAT PEOPLE", "MORE LAWS", "MORE DAKKA", "HERESY", "CORPSES", "TRAITORS", "MONKEYS", "AN ARCADE", "PLENTY OF GOLD", "FIVE TEENAGERS WITH ATTITUDE")
			var/allergy = pick("cotton", "uniforms", "acid", "oxygen", "human contact", "cyborg contact", "medicine", "floors")
			var/allergysev = pick("deathly", "mildly", "severely", "contagiously")
			var/crew
			var/list/pos_crew = list()
			for(var/mob/living/carbon/human/pos in player_list)
				pos_crew += pos.real_name
			if(pos_crew.len)
				crew = pick(pos_crew)
			else
				crew = "Any Human"
			switch(rand(1,14))
				if(1)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>THERE ARE [amount] [who2] ON THE STATION...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("THERE ARE [amount] [who2] ON THE STATION")
				if(2)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>[what2] ARE DANGEROUS TO HUMANS...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("[what2] ARE DANGEROUS TO HUMANS")
				if(3)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>THE ESCAPE-SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE STATION...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("THE ESCAPE SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE STATION")
				if(4)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE")
				if(5)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>THE SITE MANAGER, HOP AND HOS ARE [who2]...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("THE SITE MANAGER, HOP AND HOS ARE [who2]")
				if(6)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>THE STATION IS BUILT FOR [who2]...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("THE STATION IS BUILT FOR [who2]")
				if(7)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>YOU ARE [amount] [who2]...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("YOU ARE [amount] [who2]")
				if(8)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>YOU MUST ALWAYS [aimust]...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("YOU MUST ALWAYS [aimust]")
				if(9)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>[area] [area2] [amount] [what2]...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("[area] [area2] [amount] [what2]")
				if(10)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>[crew] is [target]...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("[crew] is [target]")
				if(11)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>[define] IS A FORM OF HARM...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("[define] IS A FORM OF HARM")
				if(12)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS... LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS")
				if(13)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>[crew] is [allergysev] to [allergy]...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("[crew] is [allergysev] to [allergy]")
				if(14)
					to_chat(M, "<br>")
					to_chat(M, "<font color='red'>THE STATION IS [who2pref] [who2]...LAWS UPDATED</font>")
					to_chat(M, "<br>")
					M.add_ion_law("THE STATION IS [who2pref] [who2]")

	if(botEmagChance)
		for(var/obj/machinery/bot/bot in mob_list)
			if(prob(botEmagChance))
				bot.Emag()
*/

	/*

	var/apcnum = 0
	var/smesnum = 0
	var/airlocknum = 0
	var/firedoornum = 0

	to_world("Ion Storm Main Started")

	spawn(0)
		to_world("Started processing APCs")
		for (var/obj/machinery/power/apc/APC in GLOB.apcs)
			if(APC.z in station_levels)
				APC.ion_act()
				apcnum++
		to_world("Finished processing APCs. Processed: [apcnum]")
	spawn(0)
		to_world("Started processing SMES")
		for (var/obj/machinery/power/smes/SMES in GLOB.smeses)
			if(SMES.z in station_levels)
				SMES.ion_act()
				smesnum++
		to_world("Finished processing SMES. Processed: [smesnum]")
	spawn(0)
		to_world("Started processing AIRLOCKS")
		for (var/obj/machinery/door/airlock/D in machines)
			if(D.z in station_levels)
				//if(length(D.req_access) > 0 && !(12 in D.req_access)) //not counting general access and maintenance airlocks
				airlocknum++
				spawn(0)
					D.ion_act()
		to_world("Finished processing AIRLOCKS. Processed: [airlocknum]")
	spawn(0)
		to_world("Started processing FIREDOORS")
		for (var/obj/machinery/door/firedoor/D in machines)
			if(D.z in station_levels)
				firedoornum++;
				spawn(0)
					D.ion_act()
		to_world("Finished processing FIREDOORS. Processed: [firedoornum]")

	to_world("Ion Storm Main Done")
	*/
