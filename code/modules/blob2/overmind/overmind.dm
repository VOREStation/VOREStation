var/list/overminds = list()

/mob/observer/blob
	name = "Blob Overmind"
	real_name = "Blob Overmind"
	desc = "The overmind. It controls the blob."
	icon = 'icons/mob/blob.dmi'
	icon_state = "marker"
	mouse_opacity = 1
	see_in_dark = 8
	invisibility = INVISIBILITY_OBSERVER

	faction = "blob"
	var/obj/structure/blob/core/blob_core = null // The blob overmind's core
	var/blob_points = 0
	var/max_blob_points = 200
	var/last_attack = 0
	var/datum/blob_type/blob_type = null
	var/list/blob_mobs = list()
	var/list/resource_blobs = list()
	var/placed = 0
	var/base_point_rate = 2 //for blob core placement
	var/ai_controlled = TRUE
	var/auto_pilot = FALSE // If true, and if a client is attached, the AI routine will continue running.

	universal_understand = TRUE

	var/list/has_langs = list(LANGUAGE_ANIMAL)
	var/datum/language/default_language = null

/mob/observer/blob/get_default_language()
	return default_language

/mob/observer/blob/Initialize(newloc, pre_placed = 0, starting_points = 60, desired_blob_type = null)
	blob_points = starting_points
	if(pre_placed) //we already have a core!
		placed = 1

	overminds += src
	var/new_name = "[initial(name)] ([rand(1, 999)])"
	name = new_name
	real_name = new_name
	if(desired_blob_type)
		blob_type = new desired_blob_type()
	else
		var/datum/blob_type/BT = pick(subtypesof(/datum/blob_type))
		blob_type = new BT()
	color = blob_type.complementary_color
	if(blob_core)
		blob_core.update_icon()

	for(var/L in has_langs)
		languages |= GLOB.all_languages[L]
	if(languages.len)
		default_language = languages[1]

	return ..(newloc)

/mob/observer/blob/Destroy()
	for(var/obj/structure/blob/B as anything in GLOB.all_blobs)
		if(B && B.overmind == src)
			B.overmind = null
			B.update_icon() //reset anything that was ours

	for(var/mob/living/simple_mob/blob/spore/BM as anything in blob_mobs)
		if(BM)
			BM.overmind = null
			BM.update_icons()

	overminds -= src
	return ..()

/mob/observer/blob/Stat()
	..()
	if(statpanel("Status"))
		if(blob_core)
			stat(null, "Core Health: [blob_core.integrity]")
		stat(null, "Power Stored: [blob_points]/[max_blob_points]")
		stat(null, "Total Blobs: [GLOB.all_blobs.len]")

/mob/observer/blob/Move(var/atom/NewLoc, Dir = 0)
	if(placed)
		var/obj/structure/blob/B = (locate() in view("5x5", NewLoc))
		if(B)
			forceMove(NewLoc)
			return TRUE
		else
			return FALSE
	else
		var/area/A = get_area(NewLoc)
		if(istype(NewLoc, /turf/space) || istype(A, /area/shuttle)) //if unplaced, can't go on shuttles or space tiles
			return FALSE
		forceMove(NewLoc)
		return TRUE

/mob/observer/blob/proc/add_points(points)
	blob_points = between(0, blob_points + points, max_blob_points)

/mob/observer/blob/Life()
	if(ai_controlled && (!client || auto_pilot))
		if(prob(blob_type.ai_aggressiveness))
			auto_attack()

		if(blob_points >= 100)
			if(!auto_factory() && !auto_resource())
				auto_node()

/mob/observer/blob/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	message = sanitize(message)

	if(!message)
		return

	//If you're muted for IC chat
	if(client)
		if(message)
			client.handle_spam_prevention(MUTE_IC)
			if((client.prefs.muted & MUTE_IC) || say_disabled)
				to_chat(src, "<span class='warning'>You cannot speak in IC (Muted).</span>")
				return

	//These will contain the main receivers of the message
	var/list/listening = list()
	var/list/listening_obj = list()

	var/turf/T = get_turf(src)
	if(T)
		//Obtain the mobs and objects in the message range
		var/list/results = get_mobs_and_objs_in_view_fast(T, world.view, remote_ghosts = client ? TRUE : FALSE)
		listening = results["mobs"]
		listening_obj = results["objs"]
	else
		return 1 //If we're in nullspace, then forget it.

	var/list/message_pieces = parse_languages(message)
	if(istype(message_pieces, /datum/multilingual_say_piece)) // Little quirk for dealing with hivemind/signlang languages.
		var/datum/multilingual_say_piece/S = message_pieces // Yay for BYOND's hilariously broken typecasting for allowing us to do this.
		S.speaking.broadcast(src, S.message)
		return 1

	if(!LAZYLEN(message_pieces))
		log_runtime(EXCEPTION("Message failed to generate pieces. [message] - [json_encode(message_pieces)]"))
		return 0

	//Handle nonverbal languages here
	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking.flags & NONVERBAL)
			custom_emote(VISIBLE_MESSAGE, "[pick(S.speaking.signlang_verb)].")

	for(var/mob/M in listening)
		spawn()
			if(M && src)
				if(get_dist(M, src) <= world.view || (M.stat == DEAD && !forbid_seeing_deadchat))
					M.hear_say(message_pieces, "conveys", (M.faction == blob_type.faction), src)

	//Object message delivery
	for(var/obj/O in listening_obj)
		spawn(0)
			if(O && src) //If we still exist, when the spawn processes
				var/dst = get_dist(get_turf(O),get_turf(src))
				if(dst <= world.view)
					O.hear_talk(src, message_pieces, "conveys")

	log_say(message, src)
	return 1
