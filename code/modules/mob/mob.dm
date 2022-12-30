/mob/Destroy()//This makes sure that mobs withGLOB.clients/keys are not just deleted from the game.
	mob_list -= src
	dead_mob_list -= src
	living_mob_list -= src
	unset_machine()
	qdel(hud_used)
	clear_fullscreen()
	if(client)
		for(var/obj/screen/movable/spell_master/spell_master in spell_masters)
			qdel(spell_master)
		remove_screen_obj_references()
		client.screen = list()
	if(mind && mind.current == src)
		spellremove(src)
	ghostize()
	QDEL_NULL(plane_holder)
	..()
	return QDEL_HINT_HARDDEL_NOW

/mob/proc/remove_screen_obj_references()
	hands = null
	pullin = null
	purged = null
	internals = null
	i_select = null
	m_select = null
	healths = null
	throw_icon = null
	pain = null
	item_use_icon = null
	gun_move_icon = null
	gun_setting_icon = null
	spell_masters = null
	zone_sel = null

/mob/Initialize()
	mob_list += src
	if(stat == DEAD)
		dead_mob_list += src
	else
		living_mob_list += src
	lastarea = get_area(src)
	set_focus(src) // VOREStation Add - Key Handling
	hook_vr("mob_new",list(src)) //VOREStation Code
	update_transform() // Some mobs may start bigger or smaller than normal.
	return ..()

/mob/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)

	if(!client && !teleop)	return

	if (type)
		if((type & VISIBLE_MESSAGE) && (is_blind() || paralysis) )//Vision related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
		if ((type & AUDIBLE_MESSAGE) && is_deaf())//Hearing related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
				if ((type & VISIBLE_MESSAGE) && (sdisabilities & BLIND))
					return
	// Added voice muffling for Issue 41.
	if(stat == UNCONSCIOUS || sleeping > 0)
		to_chat(src, "<I>... You can almost hear someone talking ...</I>")
	else
		to_chat(src,msg)
		if(teleop)
			to_chat(teleop, create_text_tag("body", "BODY:", teleop.client) + "[msg]")
	return

// Show a message to all mobs and objects in sight of this one
// This would be for visible actions by the src mob
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/mob/visible_message(var/message, var/self_message, var/blind_message, var/list/exclude_mobs = null, var/range = world.view, var/runemessage)
	if(self_message)
		if(LAZYLEN(exclude_mobs))
			exclude_mobs |= src
		else
			exclude_mobs = list(src)
		src.show_message(self_message, 1, blind_message, 2)
	if(isnull(runemessage))
		runemessage = -1
	. = ..(message, blind_message, exclude_mobs, range, runemessage) // Really not ideal that atom/visible_message has different arg numbering :(

// Returns an amount of power drawn from the object (-1 if it's not viable).
// If drain_check is set it will not actually drain power, just return a value.
// If surge is set, it will destroy/damage the recipient and not return any power.
// Not sure where to define this, so it can sit here for the rest of time.
/atom/proc/drain_power(var/drain_check,var/surge, var/amount = 0)
	return -1

// Show a message to all mobs and objects in earshot of this one
// This would be for audible actions by the src mob
// message is the message output to anyone who can hear.
// self_message (optional) is what the src mob hears.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/mob/audible_message(var/message, var/deaf_message, var/hearing_distance, var/self_message, var/radio_message, var/runemessage)

	var/range = hearing_distance || world.view
	var/list/hear = get_mobs_and_objs_in_view_fast(get_turf(src),range,remote_ghosts = FALSE)

	var/list/hearing_mobs = hear["mobs"]
	var/list/hearing_objs = hear["objs"]

	if(isnull(runemessage))
		runemessage = -1 // Symmetry with mob/audible_message, despite the fact this one doesn't call parent. Maybe it should!

	if(radio_message)
		for(var/obj/O as anything in hearing_objs)
			O.hear_talk(src, list(new /datum/multilingual_say_piece(GLOB.all_languages["Noise"], radio_message)), null)
	else
		for(var/obj/O as anything in hearing_objs)
			O.show_message(message, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)

	for(var/mob/M as anything in hearing_mobs)
		var/msg = message
		if(self_message && M==src)
			msg = self_message
		M.show_message(msg, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)
		if(runemessage != -1)
			M.create_chat_message(src, "[runemessage || message]", FALSE, list("emote"), audible = FALSE)

/mob/proc/findname(msg)
	for(var/mob/M in mob_list)
		if (M.real_name == text("[]", msg))
			return M
	return 0

/mob/proc/Life()
//	if(organStructure)
//		organStructure.ProcessOrgans()
	return

#define UNBUCKLED 0
#define PARTIALLY_BUCKLED 1
#define FULLY_BUCKLED 2
/mob/proc/buckled()
	// Preliminary work for a future buckle rewrite,
	// where one might be fully restrained (like an elecrical chair), or merely secured (shuttle chair, keeping you safe but not otherwise restrained from acting)
	if(!buckled)
		return UNBUCKLED
	return restrained() ? FULLY_BUCKLED : PARTIALLY_BUCKLED

/mob/proc/is_blind()
	return ((sdisabilities & BLIND) || blinded || incapacitated(INCAPACITATION_KNOCKOUT))

/mob/proc/is_deaf()
	return ((sdisabilities & DEAF) || ear_deaf || incapacitated(INCAPACITATION_KNOCKOUT))

/mob/proc/is_physically_disabled()
	return incapacitated(INCAPACITATION_DISABLED)

/mob/proc/cannot_stand()
	return incapacitated(INCAPACITATION_KNOCKDOWN)

/mob/proc/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if ((incapacitation_flags & INCAPACITATION_STUNNED) && stunned)
		return 1

	if ((incapacitation_flags & INCAPACITATION_FORCELYING) && (weakened || resting))
		return 1

	if ((incapacitation_flags & INCAPACITATION_KNOCKOUT) && (stat || paralysis || sleeping || (status_flags & FAKEDEATH)))
		return 1

	if((incapacitation_flags & INCAPACITATION_RESTRAINED) && restrained())
		return 1

	if((incapacitation_flags & (INCAPACITATION_BUCKLED_PARTIALLY|INCAPACITATION_BUCKLED_FULLY)))
		var/buckling = buckled()
		if(buckling >= PARTIALLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_PARTIALLY))
			return 1
		if(buckling == FULLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_FULLY))
			return 1

	return 0

#undef UNBUCKLED
#undef PARTIALLY_BUCKLED
#undef FULLY_BUCKLED

/mob/proc/restrained()
	return

/mob/proc/reset_view(atom/A)
	if (client)
		if (istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if (isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
		return TRUE

/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(!src || !isturf(src.loc) || !(A in view(src.loc)))
		return 0
	if(istype(A, /obj/effect/decal/point))
		return 0

	var/turf/tile = get_turf(A)
	if (!tile)
		return 0

	var/turf/our_tile = get_turf(src)
	var/obj/visual = new /obj/effect/decal/point(our_tile)
	visual.invisibility = invisibility
	visual.plane = ABOVE_PLANE
	visual.layer = FLY_LAYER

	animate(visual,
		pixel_x = (tile.x - our_tile.x) * world.icon_size + A.pixel_x,
		pixel_y = (tile.y - our_tile.y) * world.icon_size + A.pixel_y,
		time = 1.7,
		easing = EASE_OUT)

	QDEL_IN(visual, 2 SECONDS) //Better qdel

	face_atom(A)
	return 1


/mob/proc/ret_grab(list/L, flag)
	return

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	return

/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += text("[]\n", t)
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/proc/store_memory(msg as message, popup, sane = 1)
	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if (sane)
		msg = sanitize(msg)

	if (length(memory) == 0)
		memory += msg
	else
		memory += "<BR>[msg]"

	if (popup)
		memory()

/mob/proc/update_flavor_text()
	set src in usr
	if(usr != src)
		to_chat(usr, "No.")
	var/msg = sanitize(tgui_input_text(usr,"Set the flavor text in your 'examine' verb.","Flavor Text",html_decode(flavor_text), multiline = TRUE, prevent_enter = TRUE), extra = 0)	//VOREStation Edit: separating out OOC notes

	if(msg != null)
		flavor_text = msg

/mob/proc/warn_flavor_changed()
	if(flavor_text && flavor_text != "") // don't spam people that don't use it!
		to_chat(src, "<h2 class='alert'>OOC Warning:</h2>")
		to_chat(src, "<span class='alert'>Your flavor text is likely out of date! <a href='byond://?src=\ref[src];flavor_change=1'>Change</a></span>")

/mob/proc/print_flavor_text()
	if (flavor_text && flavor_text != "")
		var/msg = replacetext(flavor_text, "\n", " ")
		if(length(msg) <= 40)
			return "<span class='notice'>[msg]</span>"
		else
			return "<span class='notice'>[copytext_preserve_html(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</span></a>"

/*
/mob/verb/help()
	set name = "Help"
	src << browse('html/help.html', "window=help")
	return
*/

/mob/proc/set_respawn_timer(var/time)
	// Try to figure out what time to use

	// Special cases, can never respawn
	if(ticker?.mode?.deny_respawn)
		time = -1
	else if(!config.abandon_allowed)
		time = -1
	else if(!config.respawn)
		time = -1

	// Special case for observing before game start
	else if(ticker?.current_state <= GAME_STATE_SETTING_UP)
		time = 1 MINUTE

	// Wasn't given a time, use the config time
	else if(!time)
		time = config.respawn_time

	var/keytouse = ckey
	// Try harder to find a key to use
	if(!keytouse && key)
		keytouse = ckey(key)
	else if(!keytouse && mind?.key)
		keytouse = ckey(mind.key)

	GLOB.respawn_timers[keytouse] = world.time + time

/mob/observer/dead/set_respawn_timer()
	if(config.antag_hud_restricted && has_enabled_antagHUD)
		..(-1)
	else
		return // Don't set it, no need

/mob/verb/abandon_mob()
	set name = "Return to Menu"
	set category = "OOC"

	if(stat != DEAD || !ticker)
		to_chat(usr, "<span class='notice'><B>You must be dead to use this!</B></span>")
		return

	// Final chance to abort "respawning"
	if(mind && timeofdeath) // They had spawned before
		var/choice = tgui_alert(usr, "Returning to the menu will prevent your character from being revived in-round. Are you sure?", "Confirmation", list("No, wait", "Yes, leave"))
		if(choice == "No, wait")
			return
		else if(mind.assigned_role)
			var/extra_check = tgui_alert(usr, "Do you want to Quit This Round before you return to lobby? This will properly remove you from manifest, as well as prevent resleeving.","Quit This Round",list("Quit Round","Cancel"))
			if(extra_check == "Quit Round")
				//Update any existing objectives involving this mob.
				for(var/datum/objective/O in all_objectives)
					if(O.target == src.mind)
						if(O.owner && O.owner.current)
							to_chat(O.owner.current,"<span class='warning'>You get the feeling your target is no longer within your reach...</span>")
						qdel(O)

				//Resleeving cleanup
				if(mind)
					SStranscore.leave_round(src)

				//Job slot cleanup
				var/job = src.mind.assigned_role
				job_master.FreeRole(job)

				//Their objectives cleanup
				if(src.mind.objectives.len)
					qdel(src.mind.objectives)
					src.mind.special_role = null

				//Cut the PDA manifest (ugh)
				if(PDA_Manifest.len)
					PDA_Manifest.Cut()
				for(var/datum/data/record/R in data_core.medical)
					if((R.fields["name"] == src.real_name))
						qdel(R)
				for(var/datum/data/record/T in data_core.security)
					if((T.fields["name"] == src.real_name))
						qdel(T)
				for(var/datum/data/record/G in data_core.general)
					if((G.fields["name"] == src.real_name))
						qdel(G)

				//This removes them from being 'active' list on join screen
				src.mind.assigned_role = null
				to_chat(src,"<span class='notice'>Your job has been free'd up, and you can rejoin as another character or quit. Thanks for properly quitting round, it helps the server!</span>")

	// Beyond this point, you're going to respawn
	to_chat(usr, config.respawn_message)

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return

	announce_ghost_joinleave(client, 0)

	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	if(M.mind)
		M.mind.reset()
	return

/client/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	src << browse('html/changelog.html', "window=changes;size=675x650")
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		SScharacter_setup.queue_preferences_save(prefs)
		winset(src, "rpane.changelog", "background-color=none;font-style=;")

/mob/verb/observe()
	set name = "Observe"
	set category = "OOC"
	var/is_admin = 0

	if(client.holder && (client.holder.rights & R_ADMIN|R_EVENT))
		is_admin = 1
	else if(stat != DEAD || istype(src, /mob/new_player))
		to_chat(usr, "<font color='blue'>You must be observing to use this!</font>")
		return

	if(is_admin && stat == DEAD)
		is_admin = 0

	var/list/targets = list()


	targets += observe_list_format(nuke_disks)
	targets += observe_list_format(all_singularities)
	targets += getmobs()
	targets += observe_list_format(sortAtom(mechas_list))
	targets += observe_list_format(SSshuttles.ships)

	client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	var/ok = "[is_admin ? "Admin Observe" : "Observe"]"
	eye_name = tgui_input_list(usr, "Select something to [ok]:", "Select Target", targets)

	if (!eye_name)
		return

	var/mob/mob_eye = targets[eye_name]

	if(client && mob_eye)
		client.eye = mob_eye
		if (is_admin)
			client.adminobs = 1
			if(mob_eye == client.mob || client.eye == client.mob)
				client.adminobs = 0

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	unset_machine()
	reset_view(null)

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(href_list["flavor_more"])
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", name, replacetext(flavor_text, "\n", "<BR>")), text("window=[];size=500x200", name))
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
//	..()
	return


/mob/proc/pull_damage()
	return 0

/mob/verb/stop_pulling()

	set name = "Stop Pulling"
	set category = "IC"

	if(pulling)
		if(ishuman(pulling))
			var/mob/living/carbon/human/H = pulling
			visible_message(SPAN_WARNING("\The [src] lets go of \the [H]."), SPAN_NOTICE("You let go of \the [H]."), exclude_mobs = list(H))
			if(!H.stat)
				to_chat(H, SPAN_WARNING("\The [src] lets go of you."))
		pulling.pulledby = null
		pulling = null
		if(pullin)
			pullin.icon_state = "pull0"

/mob/proc/start_pulling(var/atom/movable/AM)

	if ( !AM || !usr || src==AM || !isturf(src.loc) )	//if there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if (AM.anchored)
		to_chat(src, "<span class='warning'>It won't budge!</span>")
		return

	var/mob/M = AM
	if(ismob(AM))

		if(!can_pull_mobs || !can_pull_size)
			to_chat(src, "<span class='warning'>They won't budge!</span>")
			return

		if((mob_size < M.mob_size) && (can_pull_mobs != MOB_PULL_LARGER))
			to_chat(src, "<span class='warning'>[M] is too large for you to move!</span>")
			return

		if((mob_size == M.mob_size) && (can_pull_mobs == MOB_PULL_SMALLER))
			to_chat(src, "<span class='warning'>[M] is too heavy for you to move!</span>")
			return

		// If your size is larger than theirs and you have some
		// kind of mob pull value AT ALL, you will be able to pull
		// them, so don't bother checking that explicitly.

		if(M.grabbed_by.len)
			// Only start pulling when nobody else has a grab on them
			. = 1
			for(var/obj/item/weapon/grab/G in M.grabbed_by)
				if(G.assailant != usr)
					. = 0
				else
					qdel(G)
			if(!.)
				to_chat(src, "<span class='warning'>Somebody has a grip on them!</span>")
				return

		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = usr

	else if(isobj(AM))
		var/obj/I = AM
		if(!can_pull_size || can_pull_size < I.w_class)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

	if(pulling)
		var/pulling_old = pulling
		stop_pulling()
		// Are we pulling the same thing twice? Just stop pulling.
		if(pulling_old == AM)
			return

	src.pulling = AM
	AM.pulledby = src

	if(pullin)
		pullin.icon_state = "pull1"

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.lying) // If they're on the ground we're probably dragging their arms to move them
			visible_message(SPAN_WARNING("\The [src] leans down and grips \the [H]'s arms."), SPAN_NOTICE("You lean down and grip \the [H]'s arms."), exclude_mobs = list(H))
			if(!H.stat)
				to_chat(H, SPAN_WARNING("\The [src] leans down and grips your arms."))
		else //Otherwise we're probably just holding their arm to lead them somewhere
			visible_message(SPAN_WARNING("\The [src] grips \the [H]'s arm."), SPAN_NOTICE("You grip \the [H]'s arm."), exclude_mobs = list(H))
			if(!H.stat)
				to_chat(H, SPAN_WARNING("\The [src] grips your arm."))
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25) //Quieter than hugging/grabbing but we still want some audio feedback

		if(H.pull_damage())
			to_chat(src, "<font color='red'><B>Pulling \the [H] in their current condition would probably be a bad idea.</B></font>")

	//Attempted fix for people flying away through space when cuffed and dragged.
	if(ismob(AM))
		var/mob/pulled = AM
		pulled.inertia_dir = 0

/mob/proc/can_use_hands()
	return

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_dead()
	return stat == DEAD

/mob/proc/is_mechanical()
	if(mind && (mind.assigned_role == "Cyborg" || mind.assigned_role == "AI"))
		return 1
	return istype(src, /mob/living/silicon) || get_species() == "Machine"

/mob/proc/is_ready()
	return client && !!mind

/mob/proc/get_gender()
	return gender

/mob/proc/name_gender()
	return gender

/mob/proc/see(message)
	if(!is_active())
		return 0
	to_chat(src,message)
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/mob/Stat()
	..()
	. = (is_client_active(10 MINUTES))

	if(.)
		if(statpanel("Status"))
			stat(null, "Time Dilation: [round(SStime_track.time_dilation_current,1)]% AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, [round(SStime_track.time_dilation_avg,1)]%, [round(SStime_track.time_dilation_avg_slow,1)]%)")
			if(ticker && ticker.current_state != GAME_STATE_PREGAME)
				stat("Station Time", stationtime2text())
				var/date = "[stationdate2text()], [capitalize(world_time_season)]"
				stat("Station Date", date)
				stat("Round Duration", roundduration2text())

		if(client.holder)
			if(statpanel("Status"))
				stat("Location:", "([x], [y], [z]) [loc]")
				stat("CPU:","[world.cpu]")
				stat("Instances:","[world.contents.len]")
				stat(null, "Time Dilation: [round(SStime_track.time_dilation_current,1)]% AVG:([round(SStime_track.time_dilation_avg_fast,1)]%, [round(SStime_track.time_dilation_avg,1)]%, [round(SStime_track.time_dilation_avg_slow,1)]%)")
				stat("Keys Held", keys2text(client.move_keys_held | client.mod_keys_held))
				stat("Next Move ADD", dirs2text(client.next_move_dir_add))
				stat("Next Move SUB", dirs2text(client.next_move_dir_sub))

			if(statpanel("MC"))
				stat("Location:", "([x], [y], [z]) [loc]")
				stat("CPU:","[world.cpu]")
				stat("Instances:","[world.contents.len]")
				stat("World Time:", world.time)
				stat("Real time of day:", REALTIMEOFDAY)
				stat(null)
				if(GLOB)
					GLOB.stat_entry()
				else
					stat("Globals:", "ERROR")
				if(Master)
					Master.stat_entry()
				else
					stat("Master Controller:", "ERROR")
				if(Failsafe)
					Failsafe.stat_entry()
				else
					stat("Failsafe Controller:", "ERROR")
				if(Master)
					stat(null)
					for(var/datum/controller/subsystem/SS in Master.subsystems)
						SS.stat_entry()

			if(statpanel("Tickets"))
				GLOB.ahelp_tickets.stat_entry()


			if(length(GLOB.sdql2_queries))
				if(statpanel("SDQL2"))
					stat("Access Global SDQL2 List", GLOB.sdql2_vv_statobj)
					for(var/datum/SDQL2_query/Q as anything in GLOB.sdql2_queries)
						Q.generate_stat()

		if(listed_turf && client)
			if(!TurfAdjacent(listed_turf))
				listed_turf = null
			else
				if(statpanel("Turf"))
					stat(listed_turf)
					for(var/atom/A in listed_turf)
						if(!A.mouse_opacity)
							continue
						if(A.invisibility > see_invisible)
							continue
						if(is_type_in_list(A, shouldnt_see))
							continue
						if(A.plane > plane)
							continue
						stat(A)


// facing verbs
/mob/proc/canface()
//	if(!canmove)						return 0 //VOREStation Edit. Redundant check that only affects conscious proning, actual inability to turn and shift around handled by actual inabilities.
	if(stat)							return 0
	if(anchored)						return 0
	if(transforming)						return 0
	return 1

// Not sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't need to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
/mob/proc/update_canmove()
	return canmove


/mob/proc/facedir(var/ndir)
	if(!canface() || (client && (client.moving || !checkMoveCooldown())))
		DEBUG_INPUT("Denying Facedir for [src] (moving=[client?.moving])")
		return 0
	set_dir(ndir)
	if(buckled && buckled.buckle_movable)
		buckled.set_dir(ndir)
	setMoveCooldown(movement_delay())
	return 1


/mob/verb/eastface()
	set hidden = 1
	return facedir(client.client_dir(EAST))


/mob/verb/westface()
	set hidden = 1
	return facedir(client.client_dir(WEST))


/mob/verb/northface()
	set hidden = 1
	return facedir(client.client_dir(NORTH))


/mob/verb/southface()
	set hidden = 1
	return facedir(client.client_dir(SOUTH))


//This might need a rename but it should replace the can this mob use things check
/mob/proc/IsAdvancedToolUser()
	return 0

/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		facing_dir = null
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Weaken(amount)
	if(status_flags & CANWEAKEN)
		facing_dir = null
		weakened = max(max(weakened,amount),0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(amount,0)
		update_canmove()	//can you guess what this does yet?
	return

/mob/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(weakened + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Paralyse(amount)
	if(status_flags & CANPARALYSE)
		facing_dir = null
		paralysis = max(max(paralysis,amount),0)
	return

/mob/proc/SetParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(amount,0)
	return

/mob/proc/AdjustParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(paralysis + amount,0)
	return

/mob/proc/Sleeping(amount)
	facing_dir = null
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/proc/Confuse(amount)
	confused = max(max(confused,amount),0)
	return

/mob/proc/SetConfused(amount)
	confused = max(amount,0)
	return

/mob/proc/AdjustConfused(amount)
	confused = max(confused + amount,0)
	return

/mob/proc/Blind(amount)
	eye_blind = max(max(eye_blind,amount),0)
	return

/mob/proc/SetBlinded(amount)
	eye_blind = max(amount,0)
	return

/mob/proc/AdjustBlinded(amount)
	eye_blind = max(eye_blind + amount,0)
	return

/mob/proc/Resting(amount)
	facing_dir = null
	resting = max(max(resting,amount),0)
	update_canmove()
	return

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	update_canmove()
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	update_canmove()
	return

/mob/proc/AdjustLosebreath(amount)
	losebreath = CLAMP(losebreath + amount, 0, 25)

/mob/proc/SetLosebreath(amount)
	losebreath = CLAMP(amount, 0, 25)

/mob/proc/get_species()
	return ""

/mob/proc/flash_weak_pain()
	flick("weak_pain",pain)

/mob/proc/get_visible_implants(var/class = 0)
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		if(O.w_class > class)
			visible_implants += O
	return visible_implants

/mob/proc/embedded_needs_process()
	return (embedded.len > 0)

/mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || !usr.checkClickCooldown())
		return
	usr.setClickCooldown(20)

	if(usr.stat == 1)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self = null

	if(S == U)
		self = 1 // Removing object from yourself.

	valid_objects = get_visible_implants(0)
	if(!valid_objects.len)
		if(self)
			to_chat(src, "You have nothing stuck in your body that is large enough to remove.")
		else
			to_chat(U, "[src] has nothing stuck in their wounds that is large enough to remove.")
		return

	var/obj/item/weapon/selection = tgui_input_list(usr, "What do you want to yank out?", "Embedded objects", valid_objects)

	if(self)
		to_chat(src, "<span class='warning'>You attempt to get a good grip on [selection] in your body.</span>")
	else
		to_chat(U, "<span class='warning'>You attempt to get a good grip on [selection] in [S]'s body.</span>")

	if(!do_after(U, 30))
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message("<span class='warning'><b>[src] rips [selection] out of their body.</b></span>","<span class='warning'><b>You rip [selection] out of your body.</b></span>")
	else
		visible_message("<span class='warning'><b>[usr] rips [selection] out of [src]'s body.</b></span>","<span class='warning'><b>[usr] rips [selection] out of your body.</b></span>")
	valid_objects = get_visible_implants(0)
	if(valid_objects.len == 1) //Yanking out last object - removing verb.
		src.verbs -= /mob/proc/yank_out_object
		clear_alert("embeddedobject")

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/external/affected

		for(var/obj/item/organ/external/organ in H.organs) //Grab the organ holding the implant.
			for(var/obj/item/O in organ.implants)
				if(O == selection)
					affected = organ

		affected.implants -= selection
		H.shock_stage+=20
		affected.take_damage((selection.w_class * 3), 0, 0, 1, "Embedded object extraction")

		if(prob(selection.w_class * 5) && (affected.robotic < ORGAN_ROBOT)) //I'M SO ANEMIC I COULD JUST -DIE-.
			var/datum/wound/internal_bleeding/I = new (min(selection.w_class * 5, 15))
			affected.wounds += I
			H.custom_pain("Something tears wetly in your [affected] as [selection] is pulled free!", 50)

		if (ishuman(U))
			var/mob/living/carbon/human/human_user = U
			human_user.bloody_hands(H)

	else if(issilicon(src))
		var/mob/living/silicon/robot/R = src
		R.embedded -= selection
		R.adjustBruteLoss(5)
		R.adjustFireLoss(10)

	selection.forceMove(get_turf(src))
	U.put_in_hands(selection)

	for(var/obj/item/weapon/O in pinned)
		if(O == selection)
			pinned -= O
		if(!pinned.len)
			anchored = FALSE
	return 1

//Check for brain worms in head.
/mob/proc/has_brain_worms()

	for(var/I in contents)
		if(istype(I,/mob/living/simple_mob/animal/borer))
			return I

	return 0

/mob/proc/updateicon()
	return

// Please always use this proc, never just set the var directly.
/mob/proc/set_stat(var/new_stat)
	. = (stat != new_stat)
	stat = new_stat

/mob/verb/face_direction()

	set name = "Face Direction"
	set category = "IC"
	set src = usr

	set_face_dir()

	if(!facing_dir)
		to_chat(usr, "You are now not facing anything.")
	else
		to_chat(usr, "You are now facing [dir2text(facing_dir)].")

/mob/proc/set_face_dir(var/newdir)
	if(newdir == facing_dir)
		facing_dir = null
	else if(newdir)
		set_dir(newdir)
		facing_dir = newdir
	else if(facing_dir)
		facing_dir = null
	else
		set_dir(dir)
		facing_dir = dir

/mob/set_dir()
	if(facing_dir)
		if(!canface() || lying || buckled || restrained())
			facing_dir = null
		else if(dir != facing_dir)
			return ..(facing_dir)
	else
		return ..()

/mob/verb/northfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(NORTH))

/mob/verb/southfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(SOUTH))

/mob/verb/eastfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(EAST))

/mob/verb/westfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(WEST))

// Begin VOREstation edit
/mob/verb/shiftnorth()
	set hidden = TRUE
	if(!canface())
		return FALSE
	if(pixel_y <= (default_pixel_y + 16))
		pixel_y++
		is_shifted = TRUE

/mob/verb/shiftsouth()
	set hidden = TRUE
	if(!canface())
		return FALSE
	if(pixel_y >= (default_pixel_y - 16))
		pixel_y--
		is_shifted = TRUE

/mob/verb/shiftwest()
	set hidden = TRUE
	if(!canface())
		return FALSE
	if(pixel_x >= (default_pixel_x - 16))
		pixel_x--
		is_shifted = TRUE

/mob/verb/shifteast()
	set hidden = TRUE
	if(!canface())
		return FALSE
	if(pixel_x <= (default_pixel_x + 16))
		pixel_x++
		is_shifted = TRUE
// End VOREstation edit

/mob/proc/adjustEarDamage()
	return

/mob/proc/setEarDamage()
	return

// Set client view distance (size of client's screen). Returns TRUE if anything changed.
/mob/proc/set_viewsize(var/new_view = world.view)
	if (client && new_view != client.view)
		client.view = new_view
		return TRUE
	return FALSE

//Throwing stuff

/mob/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/proc/throw_mode_off()
	src.in_throw_mode = 0
	if(src.throw_icon) //in case we don't have the HUD and we use the hotkey
		src.throw_icon.icon_state = "act_throw_off"

/mob/proc/throw_mode_on()
	src.in_throw_mode = 1
	if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_on"

/mob/proc/isSynthetic()
	return 0

/mob/proc/is_muzzled()
	return 0

//Exploitable Info Update

/mob/proc/amend_exploitable(var/obj/item/I)
	if(istype(I))
		exploit_addons |= I
		var/exploitmsg = html_decode("\n" + "Has " + I.name + ".")
		exploit_record += exploitmsg

/client/proc/check_has_body_select()
	return mob && mob.hud_used && istype(mob.zone_sel, /obj/screen/zone_sel)

/client/verb/body_toggle_head()
	set name = "body-toggle-head"
	set hidden = 1
	toggle_zone_sel(list(BP_HEAD, O_EYES, O_MOUTH))

/client/verb/body_r_arm()
	set name = "body-r-arm"
	set hidden = 1
	toggle_zone_sel(list(BP_R_ARM,BP_R_HAND))

/client/verb/body_l_arm()
	set name = "body-l-arm"
	set hidden = 1
	toggle_zone_sel(list(BP_L_ARM,BP_L_HAND))

/client/verb/body_chest()
	set name = "body-chest"
	set hidden = 1
	toggle_zone_sel(list(BP_TORSO))

/client/verb/body_groin()
	set name = "body-groin"
	set hidden = 1
	toggle_zone_sel(list(BP_GROIN))

/client/verb/body_r_leg()
	set name = "body-r-leg"
	set hidden = 1
	toggle_zone_sel(list(BP_R_LEG,BP_R_FOOT))

/client/verb/body_l_leg()
	set name = "body-l-leg"
	set hidden = 1
	toggle_zone_sel(list(BP_L_LEG,BP_L_FOOT))

/client/proc/toggle_zone_sel(list/zones)
	if(!check_has_body_select())
		return
	var/obj/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(next_in_list(mob.zone_sel.selecting,zones))

// This handles setting the client's color variable, which makes everything look a specific color.
// This proc is here so it can be called without needing to check if the client exists, or if the client relogs.
// This is for inheritence since /mob/living will serve most cases. If you need ghosts to use this you'll have to implement that yourself.
/mob/proc/update_client_color()
	if(client && client.color)
		animate(client, color = null, time = 10)
	return

/mob/proc/swap_hand()
	return

//Throwing stuff
/mob/proc/throw_item(atom/target)
	return FALSE

/mob/proc/will_show_tooltip()
	if(alpha <= EFFECTIVE_INVIS)
		return FALSE
	return TRUE

/mob/MouseEntered(location, control, params)
	if(usr != src && usr.is_preference_enabled(/datum/client_preference/mob_tooltips) && src.will_show_tooltip())
		openToolTip(user = usr, tip_src = src, params = params, title = get_nametag_name(usr), content = get_nametag_desc(usr))

	..()

/mob/MouseDown()
	closeToolTip(usr) //No reason not to, really

	..()

/mob/MouseExited()
	closeToolTip(usr) //No reason not to, really

	..()

// Manages a global list of mobs with clients attached, indexed by z-level.
/mob/proc/update_client_z(new_z) // +1 to register, null to unregister.
	if(registered_z != new_z)
		if(registered_z)
			GLOB.players_by_zlevel[registered_z] -= src
		if(client)
			if(new_z)
				GLOB.players_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null

GLOBAL_LIST_EMPTY_TYPED(living_players_by_zlevel, /list)
/mob/living/update_client_z(new_z)
	var/precall_reg_z = registered_z
	. = ..() // will update registered_z if necessary
	if(precall_reg_z != registered_z) // parent did work, let's do work too
		if(precall_reg_z)
			GLOB.living_players_by_zlevel[precall_reg_z] -= src
		if(registered_z)
			GLOB.living_players_by_zlevel[registered_z] += src

/mob/onTransitZ(old_z, new_z)
	..()
	update_client_z(new_z)

/mob/cloak()
	. = ..()
	if(client && cloaked_selfimage)
		client.images += cloaked_selfimage

/mob/uncloak()
	if(client && cloaked_selfimage)
		client.images -= cloaked_selfimage
	return ..()

/mob/get_cloaked_selfimage()
	var/icon/selficon = getCompoundIcon(src)
	selficon.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1) //White
	var/image/selfimage = image(selficon)
	selfimage.color = "#0000FF"
	selfimage.alpha = 100
	selfimage.layer = initial(layer)
	selfimage.plane = initial(plane)
	selfimage.loc = src

	return selfimage

/mob/proc/GetAltName()
	return ""

/mob/proc/get_ghost(even_if_they_cant_reenter = 0)
	if(mind)
		return mind.get_ghost(even_if_they_cant_reenter)

/mob/proc/grab_ghost(force)
	if(mind)
		return mind.grab_ghost(force = force)
