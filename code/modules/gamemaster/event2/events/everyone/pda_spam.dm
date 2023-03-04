/datum/event2/meta/pda_spam
	name = "pda spam"
	departments = list(DEPARTMENT_EVERYONE)
	event_type = /datum/event2/event/pda_spam

/datum/event2/meta/pda_spam/get_weight()
	return metric.count_people_in_department(DEPARTMENT_EVERYONE) * 2


/datum/event2/event/pda_spam
	length_lower_bound = 30 MINUTES
	length_upper_bound = 1 HOUR
	var/spam_debug = FALSE // If true, notices of the event sending spam go to `log_debug()`.
	var/last_spam_time = null // world.time of most recent spam.
	var/next_spam_attempt_time = 0 // world.time of next attempt to try to spam.
	var/give_up_after = 5 MINUTES
	var/obj/machinery/message_server/MS = null
	var/obj/machinery/exonet_node/node = null

/datum/event2/event/pda_spam/set_up()
	last_spam_time = world.time // So it won't immediately give up.
	MS = pick_message_server()
	node = get_exonet_node()

/datum/event2/event/pda_spam/event_tick()
	if(!can_spam())
		return

	if(world.time < next_spam_attempt_time)
		return

	next_spam_attempt_time = world.time + rand(30 SECONDS, 2 MINUTES)

	var/obj/item/device/pda/P = null
	var/list/viables = list()

	for(var/obj/item/device/pda/check_pda in sortAtom(PDAs))
		if (!check_pda.owner || check_pda == src || check_pda.hidden)
			continue

		var/datum/data/pda/app/messenger/M = check_pda.find_program(/datum/data/pda/app/messenger)
		if(!M || M.toff)
			continue
		viables += check_pda

	if(!viables.len)
		return

	P = pick(viables)
	var/list/spam = generate_spam()

	if(MS.send_pda_message("[P.owner]", spam[1], spam[2])) // Message been filtered by spam filter.
		return

	send_spam(P, spam[1], spam[2])


/datum/event2/event/pda_spam/should_end()
	. = ..()
	if(!.)
		// Give up if nobody was reachable for five minutes.
		if(last_spam_time + give_up_after < world.time)
			log_debug("PDA Spam event giving up after not being able to spam for awhile.")
			return TRUE

/datum/event2/event/pda_spam/proc/can_spam()
	if(!node || !node.on || !node.allow_external_PDAs)
		node = get_exonet_node()
		return FALSE

	if(!MS || !MS.active)
		MS = pick_message_server()
		return FALSE

	return TRUE

// Returns a list containing two items, the sender and message.
/datum/event2/event/pda_spam/proc/generate_spam()
	var/sender = null
	var/message = null
	switch(rand(1, 8))
		if(1)
			sender = pick("MaxBet","MaxBet Online Casino","There is no better time to register","I'm excited for you to join us","Join millions of lucky players...")
			message = pick("Triple deposits are waiting for you at MaxBet Online when you register to play with us.",\
			"You can qualify for a 200% Welcome Bonus at MaxBet Online when you sign up today.",\
			"Once you are a player with MaxBet, you will also receive lucrative weekly and monthly promotions.",\
			"Life-changing winnings* await when you register with MaxBet today.",\
			"You will be able to enjoy over 450 top-flight casino games at MaxBet.")
		if(2)
			sender = pick(300;"QuickDatingSystem",200;"Find your almachi bride",50;"Tajaran beauties are waiting",50;"Find your secret skrell crush",50;"Beautiful unathi brides")
			message = pick("Your profile caught my attention and I wanted to write and say hello (QuickDating).",\
			"If you will write to me on my email [pick(pick(first_names_female),(pick(first_names_male)))]@[pick(last_names)].[pick("xo.vr","ck","tj","ur","gov","nt","xo.sh")] I shall necessarily send you a photo (QuickDating).",\
			"I want that we write each other and I hope, that you will like my profile and you will answer me (QuickDating).",\
			"Meet local [pick("boys", "girls", "singles", "drones")] in [pick("Vir", "Sif", "Londunseyja", "Low Sif Orbit", "[using_map.station_name]")]",\
			"You have (1) new message!",\
			"You have (2) new profile views!")
		if(3)
			sender = pick("Galactic Payments Association","TrustWire","[using_map.starsys_name] E-Payments","NAnoTransen Finance Deparmtent","Luxury Replicas", "Eutopian Encrypted Transfers", "Gilthari Experts")
			message = pick("Luxury [pick("cybernetics", "fashions", "watches", "genetics", "narcotics")] for Blowout sale prices!",\
			"Watches, Jewelry & Accessories, Bags & Wallets !",\
			"Deposit 100Th and get 300Th totally free!",\
			"Your package is being held at [using_map.starsys_name] customs until payment of fee at (this page)",
			"You have a pending transactions ,log in is required for verifcation!",\
			" 100K NT.|EUNOIACOIN �nly Th89            <HOT>",\
			"You have won a FREE [pick("Cyber Solutions household drone", "Xion power drill", "Oasis Vacation", "Bishop Rook fitting session", "NanoThreads makeover experience", "home autofabrication system", "MBT interstellar cruise", "custom cybernetic household companion", "full-immersion VR system", "personal robot chef unit", "ThinkTronic PDA upgrade", "Ward-Takahashi communicator", "Nispean Safari Experience", "case of Lite-Speed beer", "Charlemagne von Rheinland personal voidcraft", "lifetime supply of Cheesie Honkers", "RayZar personal energy weapon", "Kaleidoscope Cosmetics gene-therapy consultation")]!",\
			"We have been filed with a complaint from one of your customers in respect of their business relations with you.",\
			"We kindly ask you to open the COMPLAINT REPORT (attached) to reply on this complaint..")
		if(4)
			sender = pick("Buy Dr. Maxman","Having dysfuctional troubles?")
			message = pick("DR MAXMAN: REAL Doctors, REAL Science, REAL Results!",\
			"Dr. Maxman was created by George Acuilar, M.D, a [using_map.boss_short] Certified Urologist who has treated over 70,000 patients region wide with '[pick("male","female", "other")] problems'.",\
			"After seven years of research, Dr Acuilar and his team came up with this simple breakthrough [pick("male","female", "other")] enhancement formula.",\
			"[pick("Men", "Women", "USR_GENDER")] of all species report AMAZING increases in length, width and stamina.")
		if(5)
			sender = pick("Dr","Crown prince","King Regent","Professor", "Princess", "God King", "Captain")
			sender += " " + pick("Charat","Baqari","Saama","Rarakhan","Jiria","Zhabir")
			sender += " " + pick("Jivare","Nekhem","Gra'rit","Hakheet","Rrhazmir","Mirruhk","Sanudrra")
			message = pick("YOUR FUND HAS BEEN MOVED TO [uppertext(pick("Antananarivo","Rarkajar","Selem","Rakari","Andromeda","Terminus","Sidhe","Corona","Smith","Relan","Atlantis"))] DEVELOPMENTARY BANK FOR ONWARD REMITTANCE.",\
			"We are happy to inform you that due to the delay, we have been instructed to IMMEDIATELY deposit all funds into your account",\
			"Dear fund beneficiary, We have please to inform you that overdue funds payment has finally been approved and released for payment",\
			"Due to my lack of agents I require an off-world financial account to immediately deposit the sum of 1 POINT FIVE MILLION thalers.",\
			"Greetings [pick("sir", "madame", "esteemed colleague")], I regretfully to inform you that as I lay dying here due to my lack ofheirs I have chosen you to recieve the full sum of my lifetime savings of 1.5 billion thalers")
		if(6)
			sender = pick("[using_map.company_name] Morale Divison","Feeling Lonely?","Bored?","www.wetskrell.nt")
			message = pick("The [using_map.company_name] Morale Division wishes to provide you with quality entertainment sites.",\
			"WetSkrell.nt is a xenophillic website endorsed by NT for the use of discerning crewmembers among it's many stations and colonies.",\
			"Wetskrell.nt only provides the higest quality of xenophilic entertaiment to [using_map.company_name] Employees.",\
			"Simply enter your [using_map.company_name] Bank account system number and pin. With three easy steps this service could be yours!")
		if(7)
			sender = pick("You have won free tickets!", "Occulum Sweepstakes!", "Click here to claim your prize!","You are the 1000th vistor!","You are our lucky grand prize winner!")
			message = pick("You have won tickets to the newest [pick("INTERSTELLAR DIPLOMACY", "CULT OF THE SLEEPING ONE", "CAPTAIN CUTIE", "TERRY THE MAGIC SNAKE", "ERT RANGERS", "GUNDAM", "KNIGHTS OF THE FALLEN STAR", "TESHPETS", "SIXTEEN RULES OF LOVE", "BROTHERS OF WISDOM")] MOVIE!",\
			"You have won tickets to an EXCLUSIVE cast screening of [pick("ISHTAR'S GRACE", "SOLDIERS OF THE YEARLONG WAR", "GAME OF DRONES", "FREE DRONE", "THE STARS KNOW LOVE")]!",\
			"You have won tickets to the [game_year] [pick("Upstream League Sabremachy", "Eutopian Boxing Championship", "Sivian Laser Golf", "Golden Crescent Basketball League", "Galactic League Spaceball", "Space Cola Call of Battle Extreme e-Sports", "Interstellar Championship Chess")] Finals!",\
			"You have won tickets to the [pick("CHAT WITH SALLY", "WEST VIR WAKEUP")] studio audience!",\
			"You have won tickets to a [pick("BIG CLEATUS", "ChordMax", "Renegade Sunset", "Criminal Roses", "Organ Farm Dumpster Riot", "Strawberry Idol", "Dying of the Embers", "Lame Lords", "Shoulder of Orion", "Electronic Information Overload")] concert in [using_map.starsys_name]!")
		if(8)
			sender = pick("[pick("Ward  -Takahasi", "Nanotrasan", "Nanotras en Finacne", "Oculuam Broad Cast", "Major Bills' Shiping", "Think Tronnic", "Phantonborne")]   Customers  Service", "UTILITY BILLING FAILED", "Corprate Payroll", "Account Suspended!", "Your latest bill's has failed.", "ACTION REQUIRED", "ImPortant inFormation", "Your Password Has Been Reset")
			message = pick("Your account is under Review due to a problem with your payment Information.",\
			"Greetings customer we have locked your account and all pending orders due to a suspicions activity.",\
			"Please reset your password at the (attached) link immediately or your account will be deleted in 24 hours.",\
			"Your account has been flagged for review by the [pick("Vir Governmental Authroity", "Emergent Intelligence Oversight", "Golden Cresent Alliance Bloc", "Office of Fleet Inteligence")], your action is required.",\
			"Verify the  recent changes you have made to your customer (account) details.",\
			"Billing Information Issue Requiring Your Response Or Action WIll Be Taken.")
	return list(sender, message)

/datum/event2/event/pda_spam/proc/send_spam(obj/item/device/pda/P, sender, message)
	last_spam_time = world.time
	var/datum/data/pda/app/messenger/PM = P.find_program(/datum/data/pda/app/messenger)
	PM.notify("<b>Message from [sender] (Unknown / spam?), </b>\"[message]\" (Unable to Reply)", 0)
	if(spam_debug)
		log_debug("PDA Spam event sent spam to \the [P].")


/datum/event2/event/pda_spam/proc/pick_message_server()
	if(LAZYLEN(message_servers))
		return pick(message_servers)
