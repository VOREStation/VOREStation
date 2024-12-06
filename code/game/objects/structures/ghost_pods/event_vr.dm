/obj/structure/ghost_pod/proc/reset_ghostpod()	//Makes the ghost pod usable again and re-adds it to the active ghost pod list if it is not on it.
	active_ghost_pods |= src
	used = FALSE
	busy = FALSE

/obj/structure/ghost_pod/ghost_activated/maintpred
	name = "maintenance hole"
	desc = "Looks like some creature dug its way into station's maintenance..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "tunnel_hole"
	icon_state_opened = "tunnel_hole"
	density = FALSE
	ghost_query_type = /datum/ghost_query/maints_pred
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	spawn_active = TRUE
	var/announce_prob = 35
	var/list/possible_mobs = list("Rabbit" = /mob/living/simple_mob/vore/rabbit,
								  "Red Panda" = /mob/living/simple_mob/vore/redpanda,
								  "Fennec" = /mob/living/simple_mob/vore/fennec,
								  "Fennix" = /mob/living/simple_mob/vore/fennix,
								  "Space Bumblebee" = /mob/living/simple_mob/vore/bee,
								  "Space Bear" = /mob/living/simple_mob/animal/space/bear,
								  "Voracious Lizard" = /mob/living/simple_mob/vore/aggressive/dino,
								  "Giant Frog" = /mob/living/simple_mob/vore/aggressive/frog,
								  "Giant Rat" = /mob/living/simple_mob/vore/aggressive/rat,
								  "Jelly Blob" = /mob/living/simple_mob/vore/jelly,
								  "Wolf" = /mob/living/simple_mob/vore/wolf,
								  "Juvenile Solargrub" = /mob/living/simple_mob/vore/solargrub,
								  "Sect Queen" = /mob/living/simple_mob/vore/sect_queen,
								  "Sect Drone" = /mob/living/simple_mob/vore/sect_drone,
								  "Defanged Xenomorph" = /mob/living/simple_mob/vore/xeno_defanged,
								  "Panther" = /mob/living/simple_mob/vore/aggressive/panther,
								  "Giant Snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
								  "Deathclaw" = /mob/living/simple_mob/vore/aggressive/deathclaw,
								  "Otie" = /mob/living/simple_mob/vore/otie,
								  "Mutated Otie" =/mob/living/simple_mob/vore/otie/feral,
								  "Red Otie" = /mob/living/simple_mob/vore/otie/red,
								  "Corrupt Hound" = /mob/living/simple_mob/vore/aggressive/corrupthound,
								  "Corrupt Corrupt Hound" = /mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi,
								  "Hunter Giant Spider" = /mob/living/simple_mob/animal/giant_spider/hunter,
								  "Lurker Giant Spider" = /mob/living/simple_mob/animal/giant_spider/lurker,
								  "Pepper Giant Spider" = /mob/living/simple_mob/animal/giant_spider/pepper,
								  "Thermic Giant Spider" = /mob/living/simple_mob/animal/giant_spider/thermic,
								  "Webslinger Giant Spider" = /mob/living/simple_mob/animal/giant_spider/webslinger,
								  "Frost Giant Spider" = /mob/living/simple_mob/animal/giant_spider/frost,
								  "Nurse Giant Spider" = /mob/living/simple_mob/animal/giant_spider/nurse/eggless,
								  "Giant Spider Queen" = /mob/living/simple_mob/animal/giant_spider/nurse/queen/eggless,
								  "Red Dragon" = /mob/living/simple_mob/vore/aggressive/dragon,
								  "Phoron Dragon" = /mob/living/simple_mob/vore/aggressive/dragon/virgo3b,
								  "Space Dragon" = /mob/living/simple_mob/vore/aggressive/dragon/space,
								  "Crypt Drake" = /mob/living/simple_mob/vore/cryptdrake,
								  "Weretiger" = /mob/living/simple_mob/vore/weretiger,
								  "Catslug" = /mob/living/simple_mob/vore/alienanimals/catslug,
								  "Squirrel" = /mob/living/simple_mob/vore/squirrel/big,
								  "Pakkun" =/mob/living/simple_mob/vore/pakkun,
								  "Snapdragon" =/mob/living/simple_mob/vore/pakkun/snapdragon,
								  "Sand pakkun" = /mob/living/simple_mob/vore/pakkun/sand,
								  "Fire pakkun" = /mob/living/simple_mob/vore/pakkun/fire,
								  "Amethyst pakkun" = /mob/living/simple_mob/vore/pakkun/purple,
								  "Raptor" = /mob/living/simple_mob/vore/raptor,
								  "Giant Bat" = /mob/living/simple_mob/vore/bat,
								  "Scel (Orange)" = /mob/living/simple_mob/vore/scel/orange,
								  "Scel (Blue)" = /mob/living/simple_mob/vore/scel/blue,
								  "Scel (Purple)" = /mob/living/simple_mob/vore/scel/purple,
								  "Scel (Red)" = /mob/living/simple_mob/vore/scel/red,
								  "Scel (Green)" = /mob/living/simple_mob/vore/scel/green,
								  "Cave Stalker" = /mob/living/simple_mob/vore/stalker,
								  "Kelpie" = /mob/living/simple_mob/vore/horse/kelpie,
								  "Scrubble" = /mob/living/simple_mob/vore/scrubble,
								  "Sonadile" = /mob/living/simple_mob/vore/sonadile,
								  "kururak" = /mob/living/simple_mob/animal/sif/kururak,
								  "Statue of Temptation" = /mob/living/simple_mob/vore/devil
								  )

/obj/structure/ghost_pod/ghost_activated/maintpred/create_occupant(var/mob/M)
	..()
	var/choice
	var/finalized = "No"

	if(jobban_isbanned(M, JOB_GHOSTROLES))
		to_chat(M, span_warning("You cannot inhabit this creature because you are banned from playing ghost roles."))
		reset_ghostpod()
		return

	//No OOC notes
	if (not_has_ooc_text(M))
		return

	while(finalized != "Yes" && M.client)
		choice = tgui_input_list(M, "What type of predator do you want to play as?", "Maintpred Choice", possible_mobs)
		if(!choice)	//We probably pushed the cancel button on the mob selection. Let's just put the ghost pod back in the list.
			to_chat(M, span_notice("No mob selected, cancelling."))
			reset_ghostpod()
			return

		if(choice)
			finalized = tgui_alert(M, "Are you sure you want to play as [choice]?","Confirmation",list("No","Yes"))

	if(!choice)	//If somehow we ended up here and we don't have a choice, let's just reset things!
		reset_ghostpod()
		return

	var/mobtype = possible_mobs[choice]
	var/mob/living/simple_mob/newPred = new mobtype(get_turf(src))
	qdel(newPred.ai_holder)
	newPred.ai_holder = null
	//newPred.movement_cooldown = 0			// The "needless artificial speed cap" exists for a reason
	if(M.mind)
		M.mind.transfer_to(newPred)
	to_chat(M, span_notice("You are " + span_bold(newPred) + ", somehow having gotten aboard the station in search of food. \
	You are wary of environment around you, but you do feel rather peckish. Stick around dark, secluded places to avoid danger or, \
	if you are cute enough, try to make friends with this place's inhabitants."))
	to_chat(M, span_critical("Please be advised, this role is NOT AN ANTAGONIST."))
	to_chat(M, span_warning("You may be a spooky space monster, but your role is to facilitate spooky space monster roleplay, not to fight the station and kill people. You can of course eat and/or digest people as you like if OOC prefs align, but this should be done as part of roleplay. If you intend to fight the station and kill people and such, you need permission from the staff team. GENERALLY, this role should avoid well populated areas. You’re a weird spooky space monster, so the bar is probably not where you’d want to go if you intend to survive. Of course, you’re welcome to try to make friends and roleplay how you will in this regard, but something to keep in mind."))
	newPred.ckey = M.ckey
	newPred.visible_message(span_warning("[newPred] emerges from somewhere!"))
	log_and_message_admins("successfully entered \a [src] and became a [newPred].")
	qdel(src)

/obj/structure/ghost_pod/ghost_activated/maintpred/no_announce
	announce_prob = 0

/obj/structure/ghost_pod/ghost_activated/morphspawn
	name = "weird goo"
	desc = "A pile of weird gunk... Wait, is it actually moving?"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "morph"
	icon_state_opened = "morph_dead"
	density = FALSE
	ghost_query_type = /datum/ghost_query/morph
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	spawn_active = TRUE
	var/announce_prob = 50

/obj/structure/ghost_pod/ghost_activated/morphspawn/create_occupant(var/mob/M)
	..()

	//No OOC notes
	if (not_has_ooc_text(M))
		return

	var/mob/living/simple_mob/vore/morph/newMorph = new /mob/living/simple_mob/vore/morph(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(newMorph)
	to_chat(M, span_notice("You are a " + span_bold("Morph") + ", somehow having gotten aboard the station in your wandering. \
	You are wary of environment around you, but your primal hunger still calls for you to find prey. Seek a convincing disguise, \
	using your amorphous form to traverse vents to find and consume weak prey."))
	to_chat(M, span_notice("You can use shift + click on objects to disguise yourself as them, but your strikes are nearly useless when you are disguised. \
	You can undisguise yourself by shift + clicking yourself, but disguise being switched, or turned on and off has a short cooldown. You can also ventcrawl, \
	by using alt + click on the vent or scrubber."))
	to_chat(M, span_critical("Please be advised, this role is NOT AN ANTAGONIST."))
	to_chat(M, span_warning("You may be a spooky space monster, but your role is to facilitate spooky space monster roleplay, not to fight the station and kill people. You can of course eat and/or digest people as you like if OOC prefs align, but this should be done as part of roleplay. If you intend to fight the station and kill people and such, you need permission from the staff team. GENERALLY, this role should avoid well populated areas. You’re a weird spooky space monster, so the bar is probably not where you’d want to go if you intend to survive. Of course, you’re welcome to try to make friends and roleplay how you will in this regard, but something to keep in mind."))

	newMorph.ckey = M.ckey
	newMorph.visible_message(span_warning("A morph appears to crawl out of somewhere."))
	log_and_message_admins("successfully entered \a [src] and became a Morph.")
	qdel(src)

/obj/structure/ghost_pod/ghost_activated/morphspawn/no_announce
	announce_prob = 0

/obj/structure/ghost_pod/ghost_activated/maintpred/redgate //For ghostpods placed in the redgate that aren't spawned via an event
	name = "creature hole"
	desc = "Looks like some creature dug is hiding in the redgate..."
	announce_prob = 0
	icon_state = "redgate_hole"
	icon_state_opened = "redgate_hole"

/obj/structure/ghost_pod/ghost_activated/maintpred/redgate/Initialize()
	..()
	if(!(src in active_ghost_pods))
		active_ghost_pods += src

/obj/structure/ghost_pod/ghost_activated/maint_lurker
	name = "strange maintenance hole"
	desc = "This is my hole! It was made for me!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "tunnel_hole"
	icon_state_opened = "tunnel_hole"
	density = FALSE
	ghost_query_type = /datum/ghost_query/maints_lurker
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	spawn_active = TRUE

//override the standard attack_ghost proc for custom messages
/obj/structure/ghost_pod/ghost_activated/maint_lurker/attack_ghost(var/mob/observer/dead/user)
	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, span_warning("You cannot use this spawnpoint because you are banned from playing ghost roles."))
		return

	//No whitelist
	if(!is_alien_whitelisted(user, GLOB.all_species[user.client.prefs.species]))
		to_chat(user, span_warning("You cannot use this spawnpoint to spawn as a species you are not whitelisted for!"))
		return

	//No OOC notes/FT
	if(not_has_ooc_text(user))
		//to_chat(user, span_warning("You must have proper out-of-character notes and flavor text configured for your current character slot to use this spawnpoint."))
		return

	var/choice = tgui_alert(user, "Using this spawner will spawn you as your currently loaded character slot in a special role. It should not be used with characters you regularly play on station. Are you absolutely sure you wish to continue?", "Maint Lurker Spawner", list("Yes", "No"))

	if(!choice || choice == "No")
		return

	create_occupant(user)

/obj/structure/ghost_pod/ghost_activated/maint_lurker/create_occupant(var/mob/M)
	..()

	var/picked_ckey = M.ckey
	var/picked_slot = M.client.prefs.default_slot

	var/mob/living/carbon/human/new_character = new(src.loc)
	if(!new_character)
		to_chat(M, span_warning("Something went wrong and spawning failed. Please check your character slot doesn't have any obvious errors, then either try again or send an adminhelp!"))
		reset_ghostpod()
		return
	log_and_message_admins("successfully used a Maintenance Lurker spawnpoint and became their loaded character.")

	M.client.prefs.copy_to(new_character)
	new_character.dna.ResetUIFrom(new_character)
	new_character.sync_organ_dna()
	new_character.key = M.key
	new_character.mind.loaded_from_ckey = picked_ckey
	new_character.mind.loaded_from_slot = picked_slot

	job_master.EquipRank(new_character, JOB_MAINT_LURKER, 1)

	for(var/lang in new_character.client.prefs.alternate_languages)
		var/datum/language/chosen_language = GLOB.all_languages[lang]
		if(chosen_language)
			if(is_lang_whitelisted(src,chosen_language) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	new_character.regenerate_icons()

	new_character.update_transform()

	to_chat(new_character, span_notice("You are a " + span_bold(JOB_MAINT_LURKER) + ", a loose end... you have no special advantages compared to the rest of the crew, so be cautious! You have spawned with an ID that will allow you free access to maintenance areas along with any of your chosen loadout items that are not role restricted, and can make use of anything you can find in maintenance."))
	to_chat(new_character, span_critical("Please be advised, this role is " + span_bold("NOT AN ANTAGONIST.")))
	to_chat(new_character, span_notice("Whoever or whatever your chosen character slot is, your role is to facilitate roleplay focused around that character; this role is not free license to attack and murder people without provocation or explicit out-of-character consent. You should probably be cautious around high-traffic and highly sensitive areas (e.g. Telecomms) as Security personnel would be well within their rights to treat you as a trespasser. That said, good luck!"))

	new_character.visible_message(span_warning("[new_character] appears to crawl out of somewhere."))
	qdel(src)

/obj/structure/ghost_pod/ghost_activated/maint_lurker/Initialize()
	..()
	if(!(src in active_ghost_pods))
		active_ghost_pods += src
