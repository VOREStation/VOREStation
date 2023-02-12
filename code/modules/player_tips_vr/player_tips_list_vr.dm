/* List of player tips
Weighted to emphasize more important over less.area
Weights are not additive. You can have multiple prob(50) items.
prob(50) makes it half as likely to appear and so forth.
When editing the list, please try and keep similar probabilities near each other. High on top, low on bottom */

//argument determines if to pick a random tip or use a forced choice.
/datum/player_tips/proc/pick_tip(var/isSpecific)
	var/choice = null
	if(!(isSpecific == "none" || isSpecific == "general" || isSpecific == "gameplay" || isSpecific == "roleplay" || isSpecific == "lore" ))
		choice = "none" //Making sure that wrong arguments still give tips.
	if(isSpecific == "none")
		choice = pick (
			prob(50); "general",
			prob(50); "gameplay",
			prob(25); "roleplay",
			prob(20); "lore"
		)
	else
		choice = isSpecific

	switch(choice)
		if("general")
			var/info = "The following is a general tip to playing on VOREStation! \n"
			return pick(
			prob(60); "[info] Got a question about gameplay, roleplay or the setting? Press F1 to Mentorhelp!",
			prob(60); "[info] We have a wiki that is actively updated! Please check it out at https://wiki.vore-station.net/Main_Page for help!",
			prob(60); "[info] Unsure about rules? Press F1 and ask our admins for clarification - they are happy to help.",
			prob(30); "[info] Don't be afraid to approach your fellow players for advice! Learning things ICly can help build powerful bonds!",
			prob(30); "[info] Need some guideance making a character or with roleplay concepts? Our discord's Cadet-Academy and Lore channels are happy to help!",
			prob(30); "[info] Having difficulties getting started? Pressing F3 to speak and typing '; Hello! I'm a new hire. Could someone please give me a tour?' or as appropriate for your character is a good way to start! More help available at: https://wiki.vore-station.net/The_Basics",
			prob(30); "[info] Want to try out a new department? Consider joining as an intern when it's well-staffed. Our players enjoy teaching eager students. You can approach such roleplay as simply getting taught the local technologies, procedures - you don't need to be 'fresh out of school' to justify it!",
			prob(30); "[info] Our discord is an excellent resource to stay up to date about changes and events! If wanting to separate your kink and real identities, Discord has a built in means to swap accounts within the client. It is OK to lurk!",
			prob(5); "[info] Got another tip for the list? Please let us know on Discord/Dev-suggestions!"
			)


		if("gameplay")
			var/info = "The following is a gameplay-focused tip to playing on VORESTation \n"
			return pick(
				prob(50); "[info] To talk to your fellow coworkers, use ';'! You may append it by an exclamation mark, like ';!' to perform an audiable emote. ",
				prob(50); "[info] Lost on the map? You can find In-Character help by speaking on the Common Radio. You can do this by pressing F3 and typing ' ; ' before your message. Your fellow co-workers will likely help. If OOC help is preferred, press F1 for mentorhelp. ",
				prob(50); "[info] You may set your suit sensors by clicking on the icon in the bottom left corner, then right click the clothes that appear right above it. It is recommended to turn on suit sensors to 'TRACKING' before doing anything dangerous like mining, and to turn them off before digestion scenes as prey.",
				prob(35); "[info] It is never a bad idea to visit the medbay if you get injured - small burns and cuts can get infected and become harder to treat! If there is no medical staff, bathrooms and the bar often has a NanoMed on the wall - with ointments to disinfect cuts and burns, bandages to treat bruises and encourage healing.",
				prob(25); "[info] Two control modes exist for SS13 - hotkey ON and hotkey OFF. You can swap between the two modes by pressing TAB. In hotkey mode, to chat you need to press T to say anything which creates a small talking bubble. You can consult our list of hotkeys at https://wiki.vore-station.net/Keyboard_Shortcuts",
				prob(25); "[info] Do you want to shift your character around, for instance to appear as if leaning on the wall? Press CTRL + SHIFT + arrow keys to do so! Moving resets this.",
				prob(25); "[info] Emergency Fire Doors  seal breaches and keep active fires out. Please do not open them without good reason.",
				prob(25); "[info] The kitchen's Oven can fit multiple ingredients in one slot if you pull the baking tray out first.  This is required for most recipes, and the Grille and Deep Frier work the same way!",
				prob(10); "[info] You can keep a single item between rounds using secure lockboxes! Beware! You can only store 1 item across all characters! To find these lockboxes, feel free to ask over radio!",
				prob(10); "[info] Not every hostile NPC you encounter while mining or exploring need to be defeated. Sometimes, it's better to avoid or run away from them. For example, star-treaders are slow and weak but have lots of HP - it is better to just run away."
				)

		if("roleplay")
			var/info = "The following is a roleplay-focused tip to playing on VORESTation \n"
			return pick(
				prob(50); "[info] Having difficulty finding scenes? The number one tip that people should take for finding scenes is to be active! Generally speaking, people are more likely to interact with you if you are moving about and doing things. Don't be afraid to talk to people, you're less likely to be approached if you're sat alone at a table silently. People that are looking for scenes generally like to see how you type and RP before they'll start working towards a scene with you.",
				prob(50); "[info] Please avoid a character that knows everything. Having only a small set of jobs you are capable of doing can help flesh out your character! It's OK for things to break and fail if nobody is around to fix it - you do not need to do others' jobs.",
				prob(25); "[info] Embrace the limits of your character's skillsets! Seeking out other players to help you with a more challenging task might build friendships, or even lead to a scene!",
				prob(25); "[info] Slowing down when meeting another player can help with finding roleplay! Your fellow player might be typing up a greeting or an emote, and if you run off you won't see it!",
				prob(25); "[info] It is a good idea to wait a few moments after using mechanics like lick, hug or headpat on another player. They might be typing up a response or wish to reciprocate, and if you run away you might miss out!",
				prob(25); "[info] Participating in an away mission and see something acting strange? Try emoting or talking to it before resorting to fighting. It may be a GM event!",
				prob(15); "[info] We are a heavy roleplay server. This does not neccessarily mean 'serious' roleplay, levity and light-hearted RP is more than welcome! Please do not ignore people just because it is unlikely you will be able to scene.",
				prob(10); "[info] Sending faxes to central command, using the 'pray' verb or pressing F1 to ahelp are highly encouraged when exploring the gateway or overmap locations! Letting GMs know something fun is happening allows them to spice things up and make the world feel alive!"
				)

		if("lore")
			var/info = "The following is tip for understanding the lore of VOREStation \n"
			return pick(
				prob(75); "[info] Our lore significantly differs from that of other servers. You can find the key differences at https://wiki.vore-station.net/Key_differences#We_have_a_well_fleshed_out_lore._We_are_not_comically_grimdark,_but_neither_a_utopia.",
				prob(75); "[info] You can find a short summary of our setting that everyone should know at https://wiki.vore-station.net/Vital_Lore",
				prob(50); "[info] You are currently working in the Virgo-Erigone system. It takes weeks to months (depending on your wealth) to return to Earth from here.  https://wiki.vore-station.net/Infrastructure#Bluespace_Gate",
				prob(50); "[info] The majority of employees live at the colony of Al'Qasbah. Most people live underground, with only the wealthiest living out in the habitation bubble. This is the place the tram/shuttle takes you at the end of the round. https://wiki.vore-station.net/Al%27Qasbah",
				prob(10); "[info] Thaler is a universal currency. Its value is set to 1 second of FTL 'bluespace' travel. While ubiquitous in frontier worlds, it has an unfavourable exchange rate with most currencies used by well-settled regions, limiting immigration to places such as Earth. https://wiki.vore-station.net/Thaler"
			)
