/obj/belly
	// Don't forget to watch your commas at the end of each line if you change these.
	var/list/struggle_messages_outside = list(
		"%pred's %belly wobbles with a squirming meal.",
		"%pred's %belly jostles with movement.",
		"%pred's %belly briefly swells outward as someone pushes from inside.",
		"%pred's %belly fidgets with a trapped victim.",
		"%pred's %belly jiggles with motion from inside.",
		"%pred's %belly sloshes around.",
		"%pred's %belly gushes softly.",
		"%pred's %belly lets out a wet squelch.")

	var/list/struggle_messages_inside = list(
		"Your useless squirming only causes %pred's slimy %belly to squelch over your body.",
		"Your struggles only cause %pred's %belly to gush softly around you.",
		"Your movement only causes %pred's %belly to slosh around you.",
		"Your motion causes %pred's %belly to jiggle.",
		"You fidget around inside of %pred's %belly.",
		"You shove against the walls of %pred's %belly, making it briefly swell outward.",
		"You jostle %pred's %belly with movement.",
		"You squirm inside of %pred's %belly, making it wobble around.")

	var/list/absorbed_struggle_messages_outside = list(
		"%pred's %belly wobbles, seemingly on its own.",
		"%pred's %belly jiggles without apparent cause.",
		"%pred's %belly seems to shake for a second without an obvious reason.")

	var/list/absorbed_struggle_messages_inside = list(
		"You try and resist %pred's %belly, but only cause it to jiggle slightly.",
		"Your fruitless mental struggles only shift %pred's %belly a tiny bit.",
		"You can't make any progress freeing yourself from %pred's %belly.")

	var/list/escape_attempt_messages_owner = list(
		"%prey is attempting to free themselves from your %belly!")

	var/list/escape_attempt_messages_prey = list(
		"You start to climb out of %pred's %belly.")

	var/list/escape_messages_owner = list(
		"%prey climbs out of your %belly!")

	var/list/escape_messages_prey = list(
		"You climb out of %pred's %belly.")

	var/list/escape_messages_outside = list(
		"%prey climbs out of %pred's %belly!")

	var/list/escape_item_messages_owner = list(
		"%item suddenly slips out of your %belly!")

	var/list/escape_item_messages_prey = list(
		"Your struggles successfully cause %pred to squeeze your %item out of their %belly.")

	var/list/escape_item_messages_outside = list(
		"%item suddenly slips out of %pred's %belly!")

	var/list/escape_fail_messages_owner = list(
		"%prey's attempt to escape from your %belly has failed!")

	var/list/escape_fail_messages_prey = list(
		"Your attempt to escape %pred's %belly has failed!")

	var/list/escape_attempt_absorbed_messages_owner = list(
		"%prey is attempting to free themselves from your %belly!")

	var/list/escape_attempt_absorbed_messages_prey = list(
		"You try to force yourself out of %pred's %belly.")

	var/list/escape_absorbed_messages_owner = list(
		"%prey forces themselves free of your %belly!")

	var/list/escape_absorbed_messages_prey = list(
		"You manage to free yourself from %pred's %belly.")

	var/list/escape_absorbed_messages_outside = list(
		"%prey climbs out of %pred's %belly!")

	var/list/escape_fail_absorbed_messages_owner = list(
		"%prey's attempt to escape form your %belly has failed!")

	var/list/escape_fail_absorbed_messages_prey = list(
		"Before you manage to reach freedom, you feel yourself getting dragged back into %pred's %belly!")

	var/list/primary_transfer_messages_owner = list(
		"%prey slid into your %dest due to their struggling inside your %belly!")

	var/list/primary_transfer_messages_prey = list(
		"Your attempt to escape %pred's %belly has failed and your struggles only results in you sliding into %pred's %dest!")

	var/list/secondary_transfer_messages_owner = list(
		"%prey slid into your %dest due to their struggling inside your %belly!")

	var/list/secondary_transfer_messages_prey = list(
		"Your attempt to escape %pred's %belly has failed and your struggles only results in you sliding into %pred's %dest!")

	var/list/primary_autotransfer_messages_owner = list(
		"%prey moves along into your %dest!")

	var/list/primary_autotransfer_messages_prey = list(
		"%pred's %belly moves you along into their %dest!")

	var/list/secondary_autotransfer_messages_owner = list(
		"%prey moves along into your %dest!")

	var/list/secondary_autotransfer_messages_prey = list(
		"%pred's %belly moves you along into their %dest!")

	var/list/digest_chance_messages_owner = list(
		"You feel your %belly beginning to become active!")

	var/list/digest_chance_messages_prey = list(
		"In response to your struggling, %pred's %belly begins to get more active...")

	var/list/absorb_chance_messages_owner = list(
		"You feel your %belly start to cling onto its contents...")

	var/list/absorb_chance_messages_prey = list(
		"In response to your struggling, %pred's %belly begins to cling more tightly...")

	var/list/select_chance_messages_owner = list(
		"You feel your %belly beginning to become active!")

	var/list/select_chance_messages_prey = list(
		"In response to your struggling, %pred's %belly begins to get more active...")

	var/list/digest_messages_owner = list(
		"You feel %prey's body succumb to your digestive system, which breaks it apart into soft slurry.",
		"You hear a lewd glorp as your %belly muscles grind %prey into a warm pulp.",
		"Your %belly lets out a rumble as it melts %prey into sludge.",
		"You feel a soft gurgle as %prey's body loses form in your %belly. They're nothing but a soft mass of churning slop now.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your thighs.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your rump.",
		"Your %belly begins gushing %prey's remains through your system, adding some extra weight to your belly.",
		"Your %belly groans as %prey falls apart into a thick soup. You can feel their remains soon flowing deeper into your body to be absorbed.",
		"Your %belly kneads on every fiber of %prey, softening them down into mush to fuel your next hunt.",
		"Your %belly churns %prey down into a hot slush. You can feel the nutrients coursing through your digestive track with a series of long, wet glorps.")

	var/list/digest_messages_prey = list(
		"Your body succumbs to %pred's digestive system, which breaks you apart into soft slurry.",
		"%pred's %belly lets out a lewd glorp as their muscles grind you into a warm pulp.",
		"%pred's %belly lets out a rumble as it melts you into sludge.",
		"%pred feels a soft gurgle as your body loses form in their %belly. You're nothing but a soft mass of churning slop now.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's thighs.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's rump.",
		"%pred's %belly begins gushing your remains through their system, adding some extra weight to %pred's belly.",
		"%pred's %belly groans as you fall apart into a thick soup. Your remains soon flow deeper into %pred's body to be absorbed.",
		"%pred's %belly kneads on every fiber of your body, softening you down into mush to fuel their next hunt.",
		"%pred's %belly churns you down into a hot slush. Your nutrient-rich remains course through their digestive track with a series of long, wet glorps.")

	var/list/absorb_messages_owner = list(
		"You feel %prey becoming part of you.")

	var/list/absorb_messages_prey = list(
		"You feel yourself becoming part of %pred's %belly!")

	var/list/unabsorb_messages_owner = list(
		"You feel %prey reform into a recognizable state again.")

	var/list/unabsorb_messages_prey = list(
		"You are released from being part of %pred's %belly.")

	var/list/examine_messages = list(
		"They have something solid in their %belly!",
		"It looks like they have something in their %belly!")

	var/list/examine_messages_absorbed = list(
		"Their body looks somewhat larger than usual around the area of their %belly.",
		"Their %belly looks larger than usual.")

GLOBAL_LIST_INIT(vore_words_goo, list("muck","goo","sludge","slime","mire","ectoplasm","quagmire","glop","jelly","ooze","slush","mush","quicksand"))//%goo
GLOBAL_LIST_INIT(vore_words_hbellynoises, list("gurgle","gloorp","squelch","gloosh","squish","groan","grrrrrrn","sloooooOrp","slooosh","grrrbles","worbles"))//%happybelly
GLOBAL_LIST_INIT(vore_words_fat, list("love handles","fat","pudge","plumpness","squish","chunk","meat","softness","blubber","flab","paunch","hip dip","mass","dough","chub","marshmellowy goodness","girth","fluff","thickness","jello","adipose "))//%fat
GLOBAL_LIST_INIT(vore_words_grip, list("grip","grasp","clutch","hold"))//%grip
GLOBAL_LIST_INIT(vore_words_cozyholdingwords, list("soft","cozy","comfortable","gentle","snug","safe","restful","snuggly","intimate","secure"))//%cozy
GLOBAL_LIST_INIT(vore_words_angry, list("hated","unsafe","angry"))//%angry
GLOBAL_LIST_INIT(vore_words_acid, list("acid","burbling goo","angry slop","chime","devouring liquid","slop","liquid","goo","mush","boiling liquid","hot oil"))//%acid
GLOBAL_LIST_INIT(vore_words_snackname, list("snack","lunch","meat","calories","food","meal","dinner","chow","future pudge","fuel"))//%snack
GLOBAL_LIST_INIT(vore_words_hot, list("sweltering","hot","boiling","sizzling","burning","steaming","firey"))//%hot
GLOBAL_LIST_INIT(vore_words_snake, list("snake","serpent","reptilian","noodle","snek","noperope","throattube","armless mouth"))//%snake

/// Replaces a bunch of format strings with relevant messages.
/// `prey` may be a string or a specific prey ref.
/obj/belly/proc/belly_format_string(message, prey, use_absorbed_count = FALSE, item = null, dest = null, use_first_only = FALSE)
	if(islist(message))
		. = "[pick(message)]"
	else
		. = "[message]"

	. = replacetext(., "%belly", lowertext(name))
	. = replacetext(., "%pred", owner)
	. = replacetext(., "%prey", prey)

	var/total_prey_count = 0
	var/all_object_and_prey_count = LAZYLEN(contents)
	var/ghost_count = 0
	var/absorbed_count = 0
	for(var/mob/M in contents)
		total_prey_count++

		if(isobserver(M))
			all_object_and_prey_count--
			ghost_count++

		if(isliving(M))
			var/mob/living/L = M
			if(L.absorbed)
				absorbed_count++

	. = replacetext(., "%countpreytotal", total_prey_count)
	. = replacetext(., "%countpreyabsorbed", absorbed_count)
	. = replacetext(., "%countprey", use_absorbed_count ? absorbed_count : total_prey_count)
	. = replacetext(., "%countghosts", ghost_count)
	. = replacetext(., "%count", all_object_and_prey_count)
	. = replacetext(., "%digestedprey", digested_prey_count)

	if(!isnull(item))
		. = replacetext(., "%item", item)
	if(!isnull(dest))
		. = replacetext(., "%dest", dest)

	// Belly messages
	. = replacetext(., "%goo", use_first_only ? GLOB.vore_words_goo[1] : pick(GLOB.vore_words_goo))
	. = replacetext(., "%happybelly", use_first_only ? GLOB.vore_words_hbellynoises[1] : pick(GLOB.vore_words_hbellynoises))
	. = replacetext(., "%fat", use_first_only ? GLOB.vore_words_fat[1] : pick(GLOB.vore_words_fat))
	. = replacetext(., "%grip", use_first_only ? GLOB.vore_words_grip[1] : pick(GLOB.vore_words_grip))
	. = replacetext(., "%cozy", use_first_only ? GLOB.vore_words_cozyholdingwords[1] : pick(GLOB.vore_words_cozyholdingwords))
	. = replacetext(., "%angry", use_first_only ? GLOB.vore_words_angry[1] : pick(GLOB.vore_words_angry))
	. = replacetext(., "%acid", use_first_only ? GLOB.vore_words_acid[1] : pick(GLOB.vore_words_acid))
	. = replacetext(., "%snack", use_first_only ? GLOB.vore_words_snackname[1] : pick(GLOB.vore_words_snackname))
	. = replacetext(., "%hot", use_first_only ? GLOB.vore_words_hot[1] : pick(GLOB.vore_words_hot))
	. = replacetext(., "%snake", use_first_only ? GLOB.vore_words_snake[1] : pick(GLOB.vore_words_snake))

// Get the line that should show up in Examine message if the owner of this belly
// is examined.   By making this a proc, we not only take advantage of polymorphism,
// but can easily make the message vary based on how many people are inside, etc.
// Returns a string which shoul be appended to the Examine output.
/obj/belly/proc/get_examine_msg()
	if(!(LAZYLEN(contents)) || !(LAZYLEN(examine_messages)))
		return ""

	var/raw_message = pick(examine_messages)
	var/total_bulge = 0

	var/list/vore_contents = list()
	for(var/G in contents)
		if(!isobserver(G))
			vore_contents += G //Exclude any ghosts from %prey

	for(var/mob/living/P in contents)
		if(!P.absorbed) //This is required first, in case there's a person absorbed and not absorbed in a stomach.
			total_bulge += P.size_multiplier

	if(total_bulge < bulge_size || bulge_size == 0)
		return ""

	return(span_red(span_italics("[belly_format_string(raw_message, english_list(vore_contents))]")))

/obj/belly/proc/get_examine_msg_absorbed()
	if(!(LAZYLEN(contents)) || !(LAZYLEN(examine_messages_absorbed)) || !display_absorbed_examine)
		return ""

	var/raw_message = pick(examine_messages_absorbed)

	var/absorbed_count = 0
	var/list/absorbed_victims = list()
	for(var/mob/living/L in contents)
		if(L.absorbed)
			absorbed_victims += L
			absorbed_count++

	if(!absorbed_count)
		return ""

	return(span_red(span_italics("[belly_format_string(raw_message, english_list(absorbed_victims), use_absorbed_count = TRUE)]")))

// The next function gets the messages set on the belly, in human-readable format.
// This is useful in customization boxes and such. The delimiter right now is \n\n so
// in message boxes, this looks nice and is easily delimited.
/obj/belly/proc/get_messages(type, delim = "\n\n")
	VB_MESSAGE_SANIRY(type)

	var/list/raw_messages
	switch(type)
		if(STRUGGLE_OUTSIDE)
			raw_messages = struggle_messages_outside
		if(STRUGGLE_INSIDE)
			raw_messages = struggle_messages_inside
		if(ABSORBED_STRUGGLE_OUSIDE)
			raw_messages = absorbed_struggle_messages_outside
		if(ABSORBED_STRUGGLE_INSIDE)
			raw_messages = absorbed_struggle_messages_inside
		if(ESCAPE_ATTEMPT_OWNER)
			raw_messages = escape_attempt_messages_owner
		if(ESCAPE_ATTEMPT_PREY)
			raw_messages = escape_attempt_messages_prey
		if(ESCAPE_OWNER)
			raw_messages = escape_messages_owner
		if(ESCAPE_PREY)
			raw_messages = escape_messages_prey
		if(ESCAPE_OUTSIDE)
			raw_messages = escape_messages_outside
		if(ESCAPE_ITEM_OWNER)
			raw_messages = escape_item_messages_owner
		if(ESCAPE_ITEM_PREY)
			raw_messages = escape_item_messages_prey
		if(ESCAPE_ITEM_OUTSIDE)
			raw_messages = escape_item_messages_outside
		if(ESCAPE_FAIL_OWNER)
			raw_messages = escape_fail_messages_owner
		if(ESCAPE_FAIL_PREY)
			raw_messages = escape_fail_messages_prey
		if(ABSORBED_ESCAPE_ATTEMPT_OWNER)
			raw_messages = escape_attempt_absorbed_messages_owner
		if(ABSORBED_ESCAPE_ATTEMPT_PREY)
			raw_messages = escape_attempt_absorbed_messages_prey
		if(ABSORBED_ESCAPE_OWNER)
			raw_messages = escape_absorbed_messages_owner
		if(ABSORBED_ESCAPE_PREY)
			raw_messages = escape_absorbed_messages_prey
		if(ABSORBED_ESCAPE_OUTSIDE)
			raw_messages = escape_absorbed_messages_outside
		if(FULL_ABSORBED_ESCAPE_OWNER)
			raw_messages = escape_fail_absorbed_messages_owner
		if(FULL_ABSORBED_ESCAPE_PREY)
			raw_messages = escape_fail_absorbed_messages_prey
		if(PRIMARY_TRANSFER_OWNER)
			raw_messages = primary_transfer_messages_owner
		if(PRIMARY_TRANSFER_PREY)
			raw_messages = primary_transfer_messages_prey
		if(SECONDARY_TRANSFER_OWNER)
			raw_messages = secondary_transfer_messages_owner
		if(SECONDARY_TRANSFER_PREY)
			raw_messages = secondary_transfer_messages_prey
		if(PRIMARY_AUTO_TRANSFER_OWNER)
			raw_messages = primary_autotransfer_messages_owner
		if(PRIMARY_AUTO_TRANSFER_PREY)
			raw_messages = primary_autotransfer_messages_prey
		if(SECONDARY_AUTO_TRANSFER_OWNER)
			raw_messages = secondary_autotransfer_messages_owner
		if(SECONDARY_AUTO_TRANSFER_PREY)
			raw_messages = secondary_autotransfer_messages_prey
		if(DIGEST_CHANCE_OWNER)
			raw_messages = digest_chance_messages_owner
		if(DIGEST_CHANCE_PREY)
			raw_messages = digest_chance_messages_prey
		if(ABSORB_CHANCE_OWNER)
			raw_messages = absorb_chance_messages_owner
		if(ABSORB_CHANCE_PREY)
			raw_messages = absorb_chance_messages_prey
		if(DIGEST_OWNER)
			raw_messages = digest_messages_owner
		if(DIGEST_PREY)
			raw_messages = digest_messages_prey
		if(EXAMINES)
			raw_messages = examine_messages
		if(EXAMINES_ABSORBED)
			raw_messages = examine_messages_absorbed
		if(ABSORB_OWNER)
			raw_messages = absorb_messages_owner
		if(ABSORB_PREY)
			raw_messages = absorb_messages_prey
		if(UNABSORBS_OWNER)
			raw_messages = unabsorb_messages_owner
		if(UNABSORBS_PREY)
			raw_messages = unabsorb_messages_prey
		if(BELLY_MODE_DIGEST)
			raw_messages = emote_lists[DM_DIGEST]
		if(BELLY_MODE_HOLD)
			raw_messages = emote_lists[DM_HOLD]
		if(BELLY_MODE_HOLD_ABSORB)
			raw_messages = emote_lists[DM_HOLD_ABSORBED]
		if(BELLY_MODE_ABSORB)
			raw_messages = emote_lists[DM_ABSORB]
		if(BELLY_MODE_HEAL)
			raw_messages = emote_lists[DM_HEAL]
		if(BELLY_MODE_DRAIN)
			raw_messages = emote_lists[DM_DRAIN]
		if(BELLY_MODE_STEAL)
			raw_messages = emote_lists[DM_SIZE_STEAL]
		if(BELLY_MODE_EGG)
			raw_messages = emote_lists[DM_EGG]
		if(BELLY_MODE_SHRINK)
			raw_messages = emote_lists[DM_SHRINK]
		if(BELLY_MODE_GROW)
			raw_messages = emote_lists[DM_GROW]
		if(BELLY_MODE_UNABSORB)
			raw_messages = emote_lists[DM_UNABSORB]
	var/messages = null
	if(raw_messages)
		messages = raw_messages.Join(delim)
	return messages

// The next function sets the messages on the belly, from human-readable var
// replacement strings and linebreaks as delimiters (two \n\n by default).
// They also sanitize the messages.
// Give them a limit for each type...
/obj/belly/proc/set_messages(raw_text, type, delim = "\n\n", limit)
	if(!limit)
		CRASH("[src] set message called without limit!")
	VB_MESSAGE_SANIRY(type)

	var/list/raw_list

	if(findtext(raw_text, delim))
		raw_list = splittext(html_encode(raw_text), delim)
	else
		raw_list = list(raw_text)
	for(var/i = 1, i <= raw_list.len, i++)
		if(!length(raw_list[i]))
			raw_list.Cut(i, i + 1)
			i--
	if(raw_list.len > 10)
		raw_list.Cut(11)
		log_debug("[owner] tried to set [lowertext(name)] with 11+ messages")

	var/realIndex = 0
	for(var/i = 1, i <= raw_list.len, i++)
		realIndex++
		raw_list[i] = readd_quotes(raw_list[i])
		//Also fix % sign for var replacement
		raw_list[i] = replacetext(raw_list[i],"&#37;","%")
		if(length(raw_list[i]) > limit || length(raw_list[i]) < 10)
			to_chat(owner, span_warning("One of the message for [lowertext(name)] exceeded the limit of [limit] characters or has been below the lower limit of 10 characters and has been removed. Actual length: [length(raw_list[i])]"))
			//Reflect message to the player so that they don't just lose it
			to_chat(owner, span_warning("Message [realIndex]: [raw_list[i]]"))
			log_debug("[owner] tried to set [lowertext(name)] [type] message with >[limit] or <10 characters")
			raw_list.Cut(i, i + 1)
			i--

	ASSERT(raw_list.len <= 10) //Sanity

	switch(type)
		if(STRUGGLE_OUTSIDE)
			struggle_messages_outside = raw_list
		if(STRUGGLE_INSIDE)
			struggle_messages_inside = raw_list
		if(ABSORBED_STRUGGLE_OUSIDE)
			absorbed_struggle_messages_outside = raw_list
		if(ABSORBED_STRUGGLE_INSIDE)
			absorbed_struggle_messages_inside = raw_list
		if(ESCAPE_ATTEMPT_OWNER)
			escape_attempt_messages_owner = raw_list
		if(ESCAPE_ATTEMPT_PREY)
			escape_attempt_messages_prey = raw_list
		if(ESCAPE_OWNER)
			escape_messages_owner = raw_list
		if(ESCAPE_PREY)
			escape_messages_prey = raw_list
		if(ESCAPE_OUTSIDE)
			escape_messages_outside = raw_list
		if(ESCAPE_ITEM_OWNER)
			escape_item_messages_owner = raw_list
		if(ESCAPE_ITEM_PREY)
			escape_item_messages_prey = raw_list
		if(ESCAPE_ITEM_OUTSIDE)
			escape_item_messages_outside = raw_list
		if(ESCAPE_FAIL_OWNER)
			escape_fail_messages_owner = raw_list
		if(ESCAPE_FAIL_PREY)
			escape_fail_messages_prey = raw_list
		if(ABSORBED_ESCAPE_ATTEMPT_OWNER)
			escape_attempt_absorbed_messages_owner = raw_list
		if(ABSORBED_ESCAPE_ATTEMPT_PREY)
			escape_attempt_absorbed_messages_prey = raw_list
		if(ABSORBED_ESCAPE_OWNER)
			escape_absorbed_messages_owner = raw_list
		if(ABSORBED_ESCAPE_PREY)
			escape_absorbed_messages_prey = raw_list
		if(ABSORBED_ESCAPE_OUTSIDE)
			escape_absorbed_messages_outside = raw_list
		if(FULL_ABSORBED_ESCAPE_OWNER)
			escape_fail_absorbed_messages_owner = raw_list
		if(FULL_ABSORBED_ESCAPE_PREY)
			escape_fail_absorbed_messages_prey = raw_list
		if(PRIMARY_TRANSFER_OWNER)
			primary_transfer_messages_owner = raw_list
		if(PRIMARY_TRANSFER_PREY)
			primary_transfer_messages_prey = raw_list
		if(SECONDARY_TRANSFER_OWNER)
			secondary_transfer_messages_owner = raw_list
		if(SECONDARY_TRANSFER_PREY)
			secondary_transfer_messages_prey = raw_list
		if(PRIMARY_AUTO_TRANSFER_OWNER)
			primary_autotransfer_messages_owner = raw_list
		if(PRIMARY_AUTO_TRANSFER_PREY)
			primary_autotransfer_messages_prey = raw_list
		if(SECONDARY_AUTO_TRANSFER_OWNER)
			secondary_autotransfer_messages_owner = raw_list
		if(SECONDARY_AUTO_TRANSFER_PREY)
			secondary_autotransfer_messages_prey = raw_list
		if(DIGEST_CHANCE_OWNER)
			digest_chance_messages_owner = raw_list
		if(DIGEST_CHANCE_PREY)
			digest_chance_messages_prey = raw_list
		if(ABSORB_CHANCE_OWNER)
			absorb_chance_messages_owner = raw_list
		if(ABSORB_CHANCE_PREY)
			absorb_chance_messages_prey = raw_list
		if(DIGEST_OWNER)
			digest_messages_owner = raw_list
		if(DIGEST_PREY)
			digest_messages_prey = raw_list
		if(ABSORB_OWNER)
			absorb_messages_owner = raw_list
		if(ABSORB_PREY)
			absorb_messages_prey = raw_list
		if(UNABSORBS_OWNER)
			unabsorb_messages_owner = raw_list
		if(UNABSORBS_PREY)
			unabsorb_messages_prey = raw_list
		if(EXAMINES)
			examine_messages = raw_list
		if(EXAMINES_ABSORBED)
			examine_messages_absorbed = raw_list
		if(BELLY_MODE_DIGEST)
			emote_lists[DM_DIGEST] = raw_list
		if(BELLY_MODE_HOLD)
			emote_lists[DM_HOLD] = raw_list
		if(BELLY_MODE_HOLD_ABSORB)
			emote_lists[DM_HOLD_ABSORBED] = raw_list
		if(BELLY_MODE_ABSORB)
			emote_lists[DM_ABSORB] = raw_list
		if(BELLY_MODE_HEAL)
			emote_lists[DM_HEAL] = raw_list
		if(BELLY_MODE_DRAIN)
			emote_lists[DM_DRAIN] = raw_list
		if(BELLY_MODE_STEAL)
			emote_lists[DM_SIZE_STEAL] = raw_list
		if(BELLY_MODE_EGG)
			emote_lists[DM_EGG] = raw_list
		if(BELLY_MODE_SHRINK)
			emote_lists[DM_SHRINK] = raw_list
		if(BELLY_MODE_GROW)
			emote_lists[DM_GROW] = raw_list
		if(BELLY_MODE_UNABSORB)
			emote_lists[DM_UNABSORB] = raw_list
