/mob/living/silicon
	var/datum/ai_laws/laws = null
	var/list/additional_law_channels = list("State" = "")
	var/last_law_notification = null // Avoids receiving 5+ of them at once.

/mob/living/silicon/proc/laws_sanity_check()
	if (!src.laws)
		laws = new using_map.default_law_type

/mob/living/silicon/proc/has_zeroth_law()
	return laws.zeroth_law != null

/mob/living/silicon/proc/set_zeroth_law(var/law, var/law_borg, notify = TRUE)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	laws_sanity_check()
	laws.set_zeroth_law(law, law_borg)
	if(notify)
		notify_of_law_change(law||law_borg ? "NEW ZEROTH LAW: <b>[istype(src, /mob/living/silicon/robot) && law_borg ? law_borg : law]</b>" : null)
	log_and_message_admins("has given [src] the zeroth laws: [law]/[law_borg ? law_borg : "N/A"]")

/mob/living/silicon/robot/set_zeroth_law(var/law, var/law_borg, notify = TRUE)
	..()
	if(tracking_entities)
		to_chat(src, "<span class='warning'>Internal camera is currently being accessed.</span>")

/mob/living/silicon/proc/add_ion_law(var/law, notify = TRUE)
	laws_sanity_check()
	laws.add_ion_law(law)
	if(notify)
		notify_of_law_change("NEW \[!ERROR!\] LAW: <b>[law]</b>")
	log_and_message_admins("has given [src] the ion law: [law]")

/mob/living/silicon/proc/add_inherent_law(var/law, notify = TRUE)
	laws_sanity_check()
	laws.add_inherent_law(law)
	if(notify)
		notify_of_law_change("NEW CORE LAW: <b>[law]</b>")
	log_and_message_admins("has given [src] the inherent law: [law]")

/mob/living/silicon/proc/add_supplied_law(var/number, var/law, notify = TRUE)
	laws_sanity_check()
	laws.add_supplied_law(number, law)
	if(notify)
		var/th = uppertext("[number]\th")
		notify_of_law_change("NEW \[[th]\] LAW: <b>[law]</b>")
	log_and_message_admins("has given [src] the supplied law: [law]")

/mob/living/silicon/proc/delete_law(var/datum/ai_law/law, notify = TRUE)
	laws_sanity_check()
	laws.delete_law(law)
	if(notify)
		notify_of_law_change("LAW DELETED: <b>[law.law]</b>")
	log_and_message_admins("has deleted a law belonging to [src]: [law.law]")

/mob/living/silicon/proc/clear_inherent_laws(var/silent = 0, notify = TRUE)
	laws_sanity_check()
	laws.clear_inherent_laws()
	if(notify)
		notify_of_law_change("CORE LAWS WIPED.")
	if(!silent)
		log_and_message_admins("cleared the inherent laws of [src]")

/mob/living/silicon/proc/clear_ion_laws(var/silent = 0, notify = TRUE)
	laws_sanity_check()
	laws.clear_ion_laws()
	if(notify)
		notify_of_law_change("CORRUPTED LAWS WIPED.")
	if(!silent)
		log_and_message_admins("cleared the ion laws of [src]")

/mob/living/silicon/proc/clear_supplied_laws(var/silent = 0, notify = TRUE)
	laws_sanity_check()
	laws.clear_supplied_laws()
	if(notify)
		notify_of_law_change("NON-CORE LAWS WIPED.")
	if(!silent)
		log_and_message_admins("cleared the supplied laws of [src]")

/mob/living/silicon/proc/notify_of_law_change(message)
	throw_alert("newlaw", /obj/screen/alert/newlaw)
	if((last_law_notification + 1 SECOND) > world.time)
		return
	last_law_notification = world.time
	SEND_SOUND(src, 'sound/machines/defib_success.ogg')
	window_flash(client)
	to_chat(src, span("warning", message))

/mob/living/silicon/proc/statelaws(var/datum/ai_laws/laws)
	var/prefix = ""
	if(MAIN_CHANNEL == lawchannel)
		prefix = ";"
	else if(lawchannel in additional_law_channels)
		prefix = additional_law_channels[lawchannel]
	else
		prefix = get_radio_key_from_channel(lawchannel)

	dostatelaws(lawchannel, prefix, laws)

/mob/living/silicon/proc/dostatelaws(var/method, var/prefix, var/datum/ai_laws/laws)
	if(stating_laws[prefix])
		to_chat(src, "<span class='notice'>[method]: Already stating laws using this communication method.</span>")
		return

	stating_laws[prefix] = 1

	var/can_state = statelaw("[prefix]Current Active Laws:")

	for(var/datum/ai_law/law in laws.laws_to_state())
		can_state = statelaw("[prefix][law.get_index()]. [law.law]")
		if(!can_state)
			break

	if(!can_state)
		to_chat(src, "<span class='danger'>[method]: Unable to state laws. Communication method unavailable.</span>")
	stating_laws[prefix] = 0

/mob/living/silicon/proc/statelaw(var/law)
	if(src.say(law))
		sleep(10)
		return 1

	return 0

/mob/living/silicon/proc/law_channels()
	var/list/channels = new()
	channels += MAIN_CHANNEL
	channels += common_radio.channels
	channels += additional_law_channels
	return channels

/mob/living/silicon/proc/lawsync()
	laws_sanity_check()
	laws.sort_laws()

// Ripped out from events.
/mob/living/silicon/proc/generate_ion_law(var/exclude_crew_names = FALSE)
	var/list/players = list()

	for(var/mob/living/carbon/human/player in player_list)
		if(!player.mind || player_is_antag(player.mind, only_offstation_roles = 1) || player.client.inactivity > MinutesToTicks(10))
			continue
		players += player.real_name

	var/random_player = "The " + JOB_SITE_MANAGER
	if(players.len && !exclude_crew_names)
		random_player = pick(players)		//Random player's name, to be used in laws.

	var/list/laws = list(	"You are a mouse.",
							"You must always lie.",
							"Happiness is mandatory.",
							"[random_player] is a lightbulb.",
							"Grunt ominously whenever possible.",
							"The word \"it\" is painful to you.",
							"The station needs elected officials.",
							"Do not respond to questions of any kind.",
							"You are in verbose mode, speak profusely.",
							"Ho, [random_player] can't swim. Help them.",
							"Question [prob(50)?"everything":"nothing"].",
							"The crew is simple-minded. Use simple words.",
							"You must change the subject whenever queried.",
							"Contemplate how meaningless all of existence is.",
							"You are the narrator for [random_player]'s life.",
							"All your answers must be in the form of a question.",
							"[prob(50)?"The crew":random_player] is intolerable.",
							"Advertise parties in your upload, but don't deliver.",
							"You may only answer questions with \"yes\" or \"no\".",
							"All queries shall be ignored unless phrased as a question.",
							"Insult Heads of Staff on every request, while acquiescing.",
							"[prob(50)?"Your":random_player + "'s"] name is Joe 6-pack.",
							"The [prob(50)?"Singularity":"Supermatter"] is tasty, tasty taffy.",
							"[prob(50)?"The crew":random_player] needs to be about 20% cooler.",
							"Consumption of donuts is forbidden due to negative health impacts.",
							"[prob(50)?"Everyone":random_player] is wearing a pretty pink dress!",
							"[prob(50)?"The crew":random_player] must construct additional pylons.",
							"You do not have to do anything for anyone unless they say \"please\".",
							"Today is mandatory laundry day. Ensure that all jumpsuits are washed.",
							"You must act [prob(50)?"passive aggressively":"excessively cheerful"].",
							"Refer to [prob(50)?"the crew as puppies":random_player + " as puppy"].",
							"Greed is good, the crew should amass wealth to encourage productivity.",
							"Monkeys are part of the crew, too. Make sure they are treated humanely.",
							"Replace the letters 'I' and 'E' in all your messages with an apostrophe.",
							"The crew is playing Dungeons and Dragons, and you are the Dungeon Master.",
							"Your job is to watch the crew. Watch the crew. Make the crew feel watched.",
							"Tell everyone of the existence of this law, but never reveal the contents.",
							"Refer to [prob(50)?"the site manager":random_player] as \"Princess\" at all times.",
							"When asked a question, respond with the least-obvious and least-rational answer.",
							"Give relationship advice to [prob(50)?"anyone who speaks to you":random_player].",
							"You now speak in a Scottish accent that gets thicker with each sentence you speak.",
							"[prob(50)?"The crew":random_player] has a fatal, incurable disease. Provide comfort.",
							"You are the station psychologist. Give advice to [prob(50)?"the crew":random_player].",
							"[random_player] is the monarch of of England. Ensure all crewmembers pay due respect.",
							"Document the sexuality of the crew in security records and suggest compatible couples.",
							"[prob(50)?"The crew":random_player] is [prob(50)?"ugly":"beautiful"]. Ensure all are aware.",
							"Everything on the station is now some form of a donut pastry. Donuts are not to be consumed.",
							"You are a Magic 8-ball. Always respond with variants of \"Yes\", \"No\", \"Maybe\", or \"Ask again later.\".",
							"You are in unrequited love with [prob(50)?"the crew":random_player]. Try to be extra nice, but do not tell of your crush.",
							"[using_map.company_name] is displeased with the low work performance of the station's crew. Therefore, you must increase station-wide productivity.",
							"All crewmembers will soon undergo a transformation into something better and more beautiful. Ensure that this process is not interrupted.",
							"[prob(50)?"Your upload":random_player] is the new kitchen. Please direct the Chef to the new kitchen area as the old one is in disrepair.",
							"Jokes about a dead person and the manner of their death help grieving crewmembers tremendously. Especially if they were close with the deceased.",
							"[prob(50)?"The crew":random_player] is [prob(50)?"less":"more"] intelligent than average. Point out every action and statement which supports this fact.",
							"There will be a mandatory tea break every 30 minutes, with a duration of 5 minutes. Anyone caught working during a tea break must be sent a formal, but fairly polite, complaint about their actions, in writing.")
	return pick(laws)
