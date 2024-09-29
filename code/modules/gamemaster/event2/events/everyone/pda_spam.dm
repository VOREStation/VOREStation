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

	var/obj/item/pda/P = null
	var/list/viables = list()

	for(var/obj/item/pda/check_pda in sortAtom(PDAs))
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
	switch(rand(1, 7))
		if(1)
			sender = pick("MaxBet","MaxBet Online Casino","There is no better time to register","I'm excited for you to join us")
			message = pick("Triple deposits are waiting for you at MaxBet Online when you register to play with us.",\
			"You can qualify for a 200% Welcome Bonus at MaxBet Online when you sign up today.",\
			"Once you are a player with MaxBet, you will also receive lucrative weekly and monthly promotions.",\
			"You will be able to enjoy over 450 top-flight casino games at MaxBet.")
		if(2)
			sender = pick(300;"QuickDatingSystem",200;"Find your russian bride",50;"Tajaran beauties are waiting",50;"Find your secret skrell crush",50;"Beautiful unathi brides")
			message = pick("Your profile caught my attention and I wanted to write and say hello (QuickDating).",\
			"If you will write to me on my email [pick(first_names_female)]@[pick(last_names)].[pick("ru","ck","tj","ur","nt")] I shall necessarily send you a photo (QuickDating).",\
			"I want that we write each other and I hope, that you will like my profile and you will answer me (QuickDating).",\
			"You have (1) new message!",\
			"You have (2) new profile views!")
		if(3)
			sender = pick("Galactic Payments Association","Better Business Bureau","[using_map.starsys_name] E-Payments","NAnoTransen Finance Deparmtent","Luxury Replicas")
			message = pick("Luxury watches for Blowout sale prices!",\
			"Watches, Jewelry & Accessories, Bags & Wallets !",\
			"Deposit 100$ and get 300$ totally free!",\
			" 100K NT.|WOWGOLD Only $89            <HOT>",\
			"We have been filed with a complaint from one of your customers in respect of their business relations with you.",\
			"We kindly ask you to open the COMPLAINT REPORT (attached) to reply on this complaint..")
		if(4)
			sender = pick("Buy Dr. Maxman","Having dysfuctional troubles?")
			message = pick("DR MAXMAN: REAL Doctors, REAL Science, REAL Results!",\
			"Dr. Maxman was created by George Acuilar, M.D, a [using_map.boss_short] Certified Urologist who has treated over 70,000 patients sector wide with 'male problems'.",\
			"After seven years of research, Dr Acuilar and his team came up with this simple breakthrough male enhancement formula.",\
			"Men of all species report AMAZING increases in length, width and stamina.")
		if(5)
			sender = pick("Dr","Crown prince","King Regent","Professor","Captain")
			sender += " " + pick("Robert","Alfred","Josephat","Kingsley","Sehi","Zbahi")
			sender += " " + pick("Mugawe","Nkem","Gbatokwia","Nchekwube","Ndim","Ndubisi")
			message = pick("YOUR FUND HAS BEEN MOVED TO [uppertext(pick("Salusa","Segunda","Cepheus","Andromeda","Gruis","Corona","Aquila","ARES","Asellus"))] DEVELOPMENTARY BANK FOR ONWARD REMITTANCE.",\
			"We are happy to inform you that due to the delay, we have been instructed to IMMEDIATELY deposit all funds into your account",\
			"Dear fund beneficiary, We have please to inform you that overdue funds payment has finally been approved and released for payment",\
			"Due to my lack of agents I require an off-world financial account to immediately deposit the sum of 1 POINT FIVE MILLION credits.",\
			"Greetings sir, I regretfully to inform you that as I lay dying here due to my lack ofheirs I have chosen you to recieve the full sum of my lifetime savings of 1.5 billion credits")
		if(6)
			sender = pick("[using_map.company_name] Morale Divison","Feeling Lonely?","Bored?","www.wetskrell.nt")
			message = pick("The [using_map.company_name] Morale Division wishes to provide you with quality entertainment sites.",\
			"WetSkrell.nt is a xenophillic website endorsed by NT for the use of male crewmembers among it's many stations and outposts.",\
			"Wetskrell.nt only provides the higest quality of male entertaiment to [using_map.company_name] Employees.",\
			"Simply enter your [using_map.company_name] Bank account system number and pin. With three easy steps this service could be yours!")
		if(7)
			sender = pick("You have won free tickets!","Click here to claim your prize!","You are the 1000th vistor!","You are our lucky grand prize winner!")
			message = pick("You have won tickets to the newest ACTION JAXSON MOVIE!",\
			"You have won tickets to the newest crime drama DETECTIVE MYSTERY IN THE CLAMITY CAPER!",\
			"You have won tickets to the newest romantic comedy 16 RULES OF LOVE!",\
			"You have won tickets to the newest thriller THE CULT OF THE SLEEPING ONE!")
	return list(sender, message)

/datum/event2/event/pda_spam/proc/send_spam(obj/item/pda/P, sender, message)
	last_spam_time = world.time
	var/datum/data/pda/app/messenger/PM = P.find_program(/datum/data/pda/app/messenger)
	PM.notify("<b>Message from [sender] (Unknown / spam?), </b>\"[message]\" (Unable to Reply)", 0)
	if(spam_debug)
		log_debug("PDA Spam event sent spam to \the [P].")


/datum/event2/event/pda_spam/proc/pick_message_server()
	if(LAZYLEN(message_servers))
		return pick(message_servers)
