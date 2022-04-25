/mob/observer
	name = "observer"
	desc = "This shouldn't appear"
	density = FALSE
	vis_flags = NONE

/mob/observer/dead
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/ghost.dmi'
	icon_state = "ghost"
	stat = DEAD
	canmove = 0
	blinded = 0
	anchored = TRUE	//  don't get pushed around

	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghsot - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/has_enabled_antagHUD = 0
	var/medHUD = 0
	var/secHUD = 0
	var/antagHUD = 0
	universal_speak = 1
	var/atom/movable/following = null
	var/admin_ghosted = 0
	var/anonsay = 0
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/lighting_alpha = 255
	incorporeal_move = 1

	var/is_manifest = 0 //If set to 1, the ghost is able to whisper. Usually only set if a cultist drags them through the veil.
	var/ghost_sprite = null
	var/global/list/possible_ghost_sprites = list(
		"Clear" = "blank",
		"Green Blob" = "otherthing",
		"Bland" = "ghost",
		"Robed-B" = "ghost1",
		"Robed-BAlt" = "ghost2",
		"King" = "ghostking",
		"Shade" = "shade",
		"Hecate" = "ghost-narsie",
		"Glowing Statue" = "armour",
		"Artificer" = "artificer",
		"Behemoth" = "behemoth",
		"Harvester" = "harvester",
		"Wraith" = "wraith",
		"Viscerator" = "viscerator",
		"Corgi" = "corgi",
		"Tamaskan" = "tamaskan",
		"Black Cat" = "blackcat",
		"Lizard" = "lizard",
		"Goat" = "goat",
		"Space Bear" = "bear",
		"Bats" = "bat",
		"Chicken" = "chicken_white",
		"Parrot"= "parrot_fly",
		"Goose" = "goose",
		"Penguin" = "penguin",
		"Brown Crab" = "crab",
		"Gray Crab" = "evilcrab",
		"Trout" = "trout-swim",
		"Salmon" = "salmon-swim",
		"Pike" = "pike-swim",
		"Koi" = "koi-swim",
		"Carp" = "carp",
		"Red Robes" = "robe_red",
		"Faithless" = "faithless",
		"Shadowform" = "forgotten",
		"Dark Ethereal" = "bloodguardian",
		"Holy Ethereal" = "lightguardian",
		"Red Elemental" = "magicRed",
		"Blue Elemental" = "magicBlue",
		"Pink Elemental" = "magicPink",
		"Orange Elemental" = "magicOrange",
		"Green Elemental" = "magicGreen",
		"Daemon" = "daemon",
		"Guard Spider" = "guard",
		"Hunter Spider" = "hunter",
		"Nurse Spider" = "nurse",
		"Rogue Drone" = "drone",
		"ED-209" = "ed209",
		"Beepsky" = "secbot"
		)
	var/last_revive_notification = null // world.time of last notification, used to avoid spamming players from defibs or cloners.
	var/cleanup_timer // Refernece to a timer that will delete this mob if no client returns

/mob/observer/dead/New(mob/body)

	appearance = body
	invisibility = INVISIBILITY_OBSERVER
	layer = BELOW_MOB_LAYER
	plane = PLANE_GHOSTS
	alpha = 127

	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = world.view //I mean. I don't even know if byond has occlusion culling... but...

	var/turf/T
	if(ismob(body))
		T = get_turf(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ghost
		gender = body.gender
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
				else
					name = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

		// Fix for naked ghosts.
		// Unclear why this isn't being grabbed by appearance.
		if(ishuman(body))
			var/mob/living/carbon/human/H = body
			add_overlay(H.overlays_standing)

	if(!T)	T = pick(latejoin)			//Safety in case we cannot find the body's position
	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	real_name = name
	animate(src, pixel_y = 2, time = 10, loop = -1)
	observer_mob_list += src
	..()

/mob/observer/dead/Topic(href, href_list)
	if (href_list["track"])
		var/mob/target = locate(href_list["track"]) in mob_list
		if(target)
			ManualFollow(target)
	if(href_list["reenter"])
		reenter_corpse()
		return

/mob/observer/dead/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/weapon/book/tome))
		var/mob/observer/dead/M = src
		M.manifest(user)

/mob/observer/dead/CanPass(atom/movable/mover, turf/target)
	return TRUE

/mob/observer/dead/set_stat(var/new_stat)
	if(new_stat != DEAD)
		CRASH("It is best if observers stay dead, thank you.")

/mob/observer/dead/examine_icon()
	var/icon/I = get_cached_examine_icon(src)
	if(!I)
		I = getFlatIcon(src, defdir = SOUTH, no_anim = TRUE)
		set_cached_examine_icon(src, I, 200 SECONDS)
	return I
	
/mob/observer/dead/examine(mob/user)
	. = ..()
	
	if(is_admin(user))
		. += "\t><span class='admin'>[ADMIN_FULLMONTY(src)]</span>"

/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/observer/dead/Life()
	..()
	if(!loc) return
	if(!client) return 0

	handle_regular_hud_updates()
	handle_vision()

/mob/proc/ghostize(var/can_reenter_corpse = 1)
	if(key)
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(H.vr_holder && !can_reenter_corpse)
				H.exit_vr()
				return 0
		var/mob/observer/dead/ghost = new(src)	//Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.timeofdeath = src.timeofdeath //BS12 EDIT
		ghost.key = key
		if(istype(loc, /obj/structure/morgue))
			var/obj/structure/morgue/M = loc
			M.update()
		else if(istype(loc, /obj/structure/closet/body_bag))
			var/obj/structure/closet/body_bag/B = loc
			B.update()
		if(ghost.client)
			ghost.client.time_died_as_mouse = ghost.timeofdeath
		if(ghost.client && !ghost.client.holder && !config.antag_hud_allowed)		// For new ghosts we remove the verb from even showing up if it's not allowed.
			ghost.verbs -= /mob/observer/dead/verb/toggle_antagHUD	// Poor guys, don't know what they are missing!
		return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat == DEAD && !forbid_seeing_deadchat)
		announce_ghost_joinleave(ghostize(1))
	else
		var/response
		if(src.client && src.client.holder)
			response = tgui_alert(src, "You have the ability to Admin-Ghost. The regular Ghost verb will announce your presence to dead chat. Both variants will allow you to return to your body using 'aghost'.\n\nWhat do you wish to do?", "Are you sure you want to ghost?", list("Ghost", "Admin Ghost", "Stay in body"))
			if(response == "Admin Ghost")
				if(!src.client)
					return
				src.client.admin_ghost()
		else
			response = tgui_alert(src, "Are you -sure- you want to ghost?\n(You are alive, or otherwise have the potential to become alive. Don't abuse ghost unless you are inside a cryopod or equivalent! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", list("Ghost", "Stay in body")) // VOREStation edit because we don't make players stay dead for 30 minutes.
		if(response != "Ghost")
			return
		resting = 1
		var/turf/location = get_turf(src)
		var/special_role = check_special_role()
		if(!istype(loc,/obj/machinery/cryopod))
			log_and_message_admins("has ghosted outside cryo[special_role ? " as [special_role]" : ""]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)",usr)
		else if(special_role)
			log_and_message_admins("has ghosted in cryo as [special_role]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)",usr)
		var/mob/observer/dead/ghost = ghostize(0)	// 0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		if(ghost)
			ghost.timeofdeath = world.time 	// Because the living mob won't have a time of death and we want the respawn timer to work properly.
			ghost.set_respawn_timer()
			announce_ghost_joinleave(ghost)

/mob/observer/dead/can_use_hands()	return 0
/mob/observer/dead/is_active()		return 0

/mob/observer/dead/Stat()
	..()
	if(statpanel("Status"))
		if(emergency_shuttle)
			var/eta_status = emergency_shuttle.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)

/mob/observer/dead/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"
	if(!client)	return
	if(!(mind && mind.current && can_reenter_corpse))
		to_chat(src, "<span class='warning'>You have no body.</span>")
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, "<span class='warning'>Another consciousness is in your body... it is resisting you.</span>")
		return
	//VOREStation Add
	if(prevent_respawns.Find(mind.name))
		to_chat(usr, "<span class='warning'>You already quit this round as this character, sorry!</span>")
		return
	//VOREStation Add End
	if(mind.current.ajourn && mind.current.stat != DEAD) //check if the corpse is astral-journeying (it's client ghosted using a cultist rune).
		var/found_rune
		for(var/obj/effect/rune/R in mind.current.loc)   //whilst corpse is alive, we can only reenter the body if it's on the rune
			if(R && R.word1 == cultwords["hell"] && R.word2 == cultwords["travel"] && R.word3 == cultwords["self"]) // Found an astral journey rune.
				found_rune = 1
				break
		if(!found_rune)
			to_chat(usr, "<span class='warning'>The astral cord that ties your body and your spirit has been severed. You are likely to wander the realm beyond until your body is finally dead and thus reunited with you.</span>")
			return
	mind.current.ajourn=0
	mind.current.key = key
	mind.current.teleop = null
	if(istype(mind.current.loc, /obj/structure/morgue))
		var/obj/structure/morgue/M = mind.current.loc
		M.update(1)
	else if(istype(mind.current.loc, /obj/structure/closet/body_bag))
		var/obj/structure/closet/body_bag/B = mind.current.loc
		B.update(1)
	if(!admin_ghosted)
		announce_ghost_joinleave(mind, 0, "They now occupy their body again.")
	return 1

/mob/observer/dead/verb/toggle_medHUD()
	set category = "Ghost"
	set name = "Toggle MedicHUD"
	set desc = "Toggles Medical HUD allowing you to see how everyone is doing"

	medHUD = !medHUD
	plane_holder.set_vis(VIS_CH_HEALTH, medHUD)
	plane_holder.set_vis(VIS_CH_STATUS_OOC, medHUD)
	to_chat(src, "<font color='blue'><B>Medical HUD [medHUD ? "Enabled" : "Disabled"]</B></font>")

/mob/observer/dead/verb/toggle_secHUD()
	set category = "Ghost"
	set name = "Toggle Security HUD"
	set desc = "Toggles Security HUD allowing you to see people's displayed ID's job, wanted status, etc"

	secHUD = !secHUD
	plane_holder.set_vis(VIS_CH_ID, secHUD)
	plane_holder.set_vis(VIS_CH_WANTED, secHUD)
	plane_holder.set_vis(VIS_CH_IMPTRACK, secHUD)
	plane_holder.set_vis(VIS_CH_IMPLOYAL, secHUD)
	plane_holder.set_vis(VIS_CH_IMPCHEM, secHUD)
	to_chat(src, "<font color='blue'><B>Security HUD [secHUD ? "Enabled" : "Disabled"]</B></font>")

/mob/observer/dead/verb/toggle_antagHUD()
	set category = "Ghost"
	set name = "Toggle AntagHUD"
	set desc = "Toggles AntagHUD allowing you to see who is the antagonist"

	if(!config.antag_hud_allowed && !client.holder)
		to_chat(src, "<font color='red'>Admins have disabled this for this round.</font>")
		return
	if(jobban_isbanned(src, "AntagHUD"))
		to_chat(src, "<font color='red'><B>You have been banned from using this feature</B></font>")
		return
	if(config.antag_hud_restricted && !has_enabled_antagHUD && !client.holder)
		var/response = tgui_alert(src, "If you turn this on, you will not be able to take any part in the round.","Are you sure you want to turn this feature on?",list("Yes","No"))
		if(response == "No") return
		can_reenter_corpse = FALSE
		set_respawn_timer(-1) // Foreeeever
	if(!has_enabled_antagHUD && !client.holder)
		has_enabled_antagHUD = TRUE

	antagHUD = !antagHUD
	plane_holder.set_vis(VIS_CH_SPECIAL, antagHUD)
	to_chat(src, "<font color='blue'><B>AntagHUD [antagHUD ? "Enabled" : "Disabled"]</B></font>")

/mob/observer/dead/proc/jumpable_areas()
	var/list/areas = return_sorted_areas()
	if(client?.holder)
		return areas
	
	for(var/key in areas)
		var/area/A = areas[key]
		if(A.z in using_map?.secret_levels)
			areas -= key
		if(A.z in using_map?.hidden_levels)
			areas -= key

	return areas

/mob/observer/dead/proc/jumpable_mobs()
	var/list/mobs = getmobs()
	if(client?.holder)
		return mobs

	for(var/key in mobs)
		var/mobz = get_z(mobs[key])
		if(mobz in using_map?.secret_levels)
			mobs -= key
		if(mobz in using_map?.hidden_levels)
			mobs -= key

	return mobs

/mob/observer/dead/verb/dead_tele(areaname as anything in jumpable_areas())
	set name = "Teleport"
	set category = "Ghost"
	set desc = "Teleport to a location."

	if(!istype(usr, /mob/observer/dead))
		to_chat(usr, "Not when you're not dead!")
		return

	var/area/A
	
	if(!areaname)
		var/list/areas = jumpable_areas()
		var/input = tgui_input_list(usr, "Select an area:", "Ghost Teleport", areas)
		if(!input)
			return
		A = areas[input]
		if(!A)
			return

	if(!istype(usr, /mob/observer/dead))
		to_chat(usr, "Not when you're not dead!")
		return

	usr.forceMove(pick(get_area_turfs(A || jumpable_areas()[areaname])))
	usr.on_mob_jump()

/mob/observer/dead/verb/follow(mobname as anything in jumpable_mobs())
	set name = "Follow"
	set category = "Ghost"
	set desc = "Follow and haunt a mob."

	if(!istype(usr, /mob/observer/dead))
		to_chat(usr, "Not when you're not dead!")
		return

	var/mob/M

	if(!mobname)
		var/list/possible_mobs = jumpable_mobs()
		var/input = tgui_input_list(usr, "Select a mob:", "Ghost Follow", possible_mobs)
		if(!input)
			return
		M = possible_mobs[input]
		if(!M)
			return

	if(!istype(usr, /mob/observer/dead))
		to_chat(usr, "Not when you're not dead!")
		return

	ManualFollow(M || jumpable_mobs()[mobname])
	
/mob/observer/dead/forceMove(atom/destination)
	if(client?.holder)
		return ..()
	
	if(get_z(destination) in using_map?.secret_levels)
		to_chat(src,SPAN_WARNING("Sorry, that z-level does not allow ghosts."))
		if(following)
			stop_following()
		return
	
	return ..()

/mob/observer/dead/Move(atom/newloc, direct = 0, movetime)
	if(client?.holder)
		return ..()
	
	if(get_z(newloc) in using_map?.secret_levels)
		to_chat(src,SPAN_WARNING("Sorry, that z-level does not allow ghosts."))
		if(following)
			stop_following()
		return
	
	return ..()

// This is the ghost's follow verb with an argument
/mob/observer/dead/proc/ManualFollow(var/atom/movable/target)
	if(!target)
		return

	var/turf/targetloc = get_turf(target)
	if(check_holy(targetloc))
		to_chat(usr, "<span class='warning'>You cannot follow a mob standing on holy grounds!</span>")
		return
	if(get_z(target) in using_map?.secret_levels)
		to_chat(src, SPAN_WARNING("Sorry, that target is in an area that ghosts aren't allowed to go."))
		return
	if(target != src)
		if(following && following == target)
			return
		following = target
		to_chat(src, "<span class='notice'>Now following [target]</span>")
		if(ismob(target))
			forceMove(get_turf(target))
			var/mob/M = target
			M.following_mobs += src
		else
			spawn(0)
				while(target && following == target && client)
					var/turf/T = get_turf(target)
					if(!T)
						break
					// To stop the ghost flickering.
					if(loc != T)
						forceMove(T)
					sleep(15)

	var/icon/I = icon(target.icon,target.icon_state,target.dir)

	var/orbitsize = (I.Width()+I.Height())*0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)

	var/rot_seg

	/* We don't have this pref yet
	switch(ghost_orbit)
		if(GHOST_ORBIT_TRIANGLE)
			rot_seg = 3
		if(GHOST_ORBIT_SQUARE)
			rot_seg = 4
		if(GHOST_ORBIT_PENTAGON)
			rot_seg = 5
		if(GHOST_ORBIT_HEXAGON)
			rot_seg = 6
		else //Circular
			rot_seg = 36 //360/10 bby, smooth enough aproximation of a circle
	*/

	orbit(target, orbitsize, FALSE, 20, rot_seg)

/mob/observer/dead/orbit()
	set_dir(2) //reset dir so the right directional sprites show up
	return ..()

/mob/observer/dead/stop_orbit()
	. = ..()
	//restart our floating animation after orbit is done.
	pixel_y = 0
	pixel_x = 0
	transform = null
	animate(src, pixel_y = 2, time = 10, loop = -1)

/mob/observer/dead/proc/stop_following()
	following = null
	stop_orbit()

/mob/proc/update_following()
	. = get_turf(src)
	for(var/mob/observer/dead/M in following_mobs)
		if(!.)
			M.stop_following()
		
		if(M.following != src)
			following_mobs -= M
		else
			if(M.loc != .)
				M.forceMove(.)

/mob
	var/list/following_mobs = list()

/mob/Destroy()
	for(var/mob/observer/dead/M in following_mobs)
		M.stop_following()
	following_mobs = null
	return ..()

/mob/observer/dead/Destroy()
	if(ismob(following))
		var/mob/M = following
		M.following_mobs -= src
	stop_following()
	observer_mob_list -= src
	return ..()

/mob/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	update_following()

/mob/Life()
	// to catch teleports etc which directly set loc
	update_following()
	return ..()

/mob/proc/check_holy(var/turf/T)
	return 0

/mob/observer/dead/check_holy(var/turf/T)
	if(check_rights(R_ADMIN|R_FUN|R_EVENT, 0, src))
		return 0

	return (T && T.holy) && (is_manifest || (mind in cult.current_antagonists))

/mob/observer/dead/verb/jumptomob() //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"
	set popup_menu = FALSE

	if(!istype(usr, /mob/observer/dead)) //Make sure they're an observer!
		return

	var/list/possible_mobs = jumpable_mobs()
	var/input = tgui_input_list(usr, "Select a mob:", "Ghost Jump", possible_mobs)
	if(!input)
		return

	var/target = possible_mobs[input]
	if (!target)//Make sure we actually have a target
		return
	else
		var/mob/M = target //Destination mob
		var/turf/T = get_turf(M) //Turf of the destination mob

		if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
			forceMove(T)
			stop_following()
		else
			to_chat(src, "This mob is not located in the game world.")

/mob/observer/dead/memory()
	set hidden = 1
	to_chat(src, "<font color='red'>You are dead! You have no mind to store memory!</font>")

/mob/observer/dead/add_memory()
	set hidden = 1
	to_chat(src, "<font color='red'>You are dead! You have no mind to store memory!</font>")

/mob/observer/dead/Post_Incorpmove()
	stop_following()

/mob/observer/dead/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	if(!istype(usr, /mob/observer/dead)) return

	// Shamelessly copied from the Gas Analyzers
	if (!( istype(usr.loc, /turf) ))
		return

	var/datum/gas_mixture/environment = usr.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	to_chat(src, "<font color='blue'><B>Results:</B></font>")
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(src, "<font color='blue'>Pressure: [round(pressure,0.1)] kPa</font>")
	else
		to_chat(src, "<font color='red'>Pressure: [round(pressure,0.1)] kPa</font>")
	if(total_moles)
		for(var/g in environment.gas)
			to_chat(src, "<font color='blue'>[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]% ([round(environment.gas[g], 0.01)] moles)</font>")
		to_chat(src, "<font color='blue'>Temperature: [round(environment.temperature-T0C,0.1)]&deg;C ([round(environment.temperature,0.1)]K)</font>")
		to_chat(src, "<font color='blue'>Heat Capacity: [round(environment.heat_capacity(),0.1)]</font>")

/mob/observer/dead/verb/check_radiation()
	set name = "Check Radiation"
	set category = "Ghost"

	var/turf/t = get_turf(src)
	if(t)
		var/rads = SSradiation.get_rads_at_turf(t)
		to_chat(src, "<span class='notice'>Radiation level: [rads ? rads : "0"] Bq.</span>")


/mob/observer/dead/verb/become_mouse()
	set name = "Become mouse"
	set category = "Ghost"

	if(config.disable_player_mice)
		to_chat(src, "<span class='warning'>Spawning as a mouse is currently disabled.</span>")
		return

	//VOREStation Add Start
	if(jobban_isbanned(src, "GhostRoles"))
		to_chat(src, "<span class='warning'>You cannot become a mouse because you are banned from playing ghost roles.</span>")
		return
	//VOREStation Add End

	if(!MayRespawn(1))
		return

	var/turf/T = get_turf(src)
	if(!T || (T.z in using_map.admin_levels))
		to_chat(src, "<span class='warning'>You may not spawn as a mouse on this Z-level.</span>")
		return

	var/timedifference = world.time - client.time_died_as_mouse
	if(client.time_died_as_mouse && timedifference <= mouse_respawn_time * 600)
		var/timedifference_text
		timedifference_text = time2text(mouse_respawn_time * 600 - timedifference,"mm:ss")
		to_chat(src, "<span class='warning'>You may only spawn again as a mouse more than [mouse_respawn_time] minutes after your death. You have [timedifference_text] left.</span>")
		return

	var/response = tgui_alert(src, "Are you -sure- you want to become a mouse?","Are you sure you want to squeek?",list("Squeek!","Nope!"))
	if(response != "Squeek!") return  //Hit the wrong key...again.


	//find a viable mouse candidate
	var/mob/living/simple_mob/animal/passive/mouse/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in machines)
		if(!v.welded && v.z == T.z && v.network && v.network.normal_members.len > 20)
			found_vents.Add(v)
	if(found_vents.len)
		vent_found = pick(found_vents)
		host = new /mob/living/simple_mob/animal/passive/mouse(vent_found)
	else
		to_chat(src, "<span class='warning'>Unable to find any unwelded vents to spawn mice at.</span>")

	if(host)
		if(config.uneducated_mice)
			host.universal_understand = 0
		announce_ghost_joinleave(src, 0, "They are now a mouse.")
		host.ckey = src.ckey
		host.add_ventcrawl(vent_found)
		to_chat(host, "<span class='info'>You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent.</span>")

/mob/observer/dead/verb/view_manfiest()
	set name = "Show Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += data_core.get_manifest()

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

//This is called when a ghost is drag clicked to something.
/mob/observer/dead/MouseDrop(atom/over)
	if(!usr || !over) return
	if (isobserver(usr) && usr.client && usr.client.holder && isliving(over))
		if (usr.client.holder.cmd_ghost_drag(src,over))
			return

	return ..()

//Used for drawing on walls with blood puddles as a spooky ghost.
/mob/observer/dead/verb/bloody_doodle()

	set category = "Ghost"
	set name = "Write in blood"
	set desc = "If the round is sufficiently spooky, write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	if(!(config.cult_ghostwriter))
		to_chat(src, "<font color='red'>That verb is not currently permitted.</font>")
		return

	if (!src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	var/ghosts_can_write
	if(ticker.mode.name == "cult")
		if(cult.current_antagonists.len > config.cult_ghostwriter_req_cultists)
			ghosts_can_write = 1

	if(!ghosts_can_write && !check_rights(R_ADMIN|R_EVENT|R_FUN, 0)) //Let's allow for admins to write in blood for events and the such.
		to_chat(src, "<font color='red'>The veil is not thin enough for you to do that.</font>")
		return

	var/list/choices = list()
	for(var/obj/effect/decal/cleanable/blood/B in view(1,src))
		if(B.amount > 0)
			choices += B

	if(!choices.len)
		to_chat(src, "<span class = 'warning'>There is no blood to use nearby.</span>")
		return

	var/obj/effect/decal/cleanable/blood/choice = tgui_input_list(src, "What blood would you like to use?", "Blood Choice", choices)

	var/direction = tgui_input_list(src,"Which way?","Tile selection", list("Here","North","South","East","West"))
	var/turf/simulated/T = src.loc
	if (direction != "Here")
		T = get_step(T,text2dir(direction))

	if (!istype(T))
		to_chat(src, "<span class='warning'>You cannot doodle there.</span>")
		return

	if(!choice || choice.amount == 0 || !(src.Adjacent(choice)))
		return

	var/doodle_color = (choice.basecolor) ? choice.basecolor : "#A10808"

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, "<span class='warning'>There is no space to write on!</span>")
		return

	var/max_length = 50

	var/message = sanitize(input(usr, "Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)

		if (length(message) > max_length)
			message += "-"
			to_chat(src, "<span class='warning'>You ran out of blood to write with!</span>")

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = doodle_color
		W.update_icon()
		W.message = message
		W.add_hiddenprint(src)
		W.visible_message("<font color='red'>Invisible fingers crudely paint something in blood on [T]...</font>")

/mob/observer/dead/pointed(atom/A as mob|obj|turf in view())
	if(!..())
		return 0
	usr.visible_message("<span class='deadsay'><b>[src]</b> points to [A]</span>")
	return 1

/mob/observer/dead/proc/manifest(mob/user)
	is_manifest = TRUE
	verbs |= /mob/observer/dead/proc/toggle_visibility
	verbs |= /mob/observer/dead/proc/ghost_whisper
	to_chat(src, "<font color='purple'>As you are now in the realm of the living, you can whisper to the living with the <b>Spectral Whisper</b> verb, inside the IC tab.</font>")
	if(plane != PLANE_WORLD)
		user.visible_message( \
			"<span class='warning'>\The [user] drags ghost, [src], to our plane of reality!</span>", \
			"<span class='warning'>You drag [src] to our plane of reality!</span>" \
		)
		toggle_visibility(TRUE)
	else
		var/datum/gender/T = gender_datums[user.get_visible_gender()]
		user.visible_message ( \
			"<span class='warning'>\The [user] just tried to smash [T.his] book into that ghost!  It's not very effective.</span>", \
			"<span class='warning'>You get the feeling that the ghost can't become any more visible.</span>" \
		)

/mob/observer/dead/proc/toggle_icon(var/icon)
	if(!client)
		return

	var/iconRemoved = 0
	for(var/image/I in client.images)
		if(I.icon_state == icon)
			iconRemoved = 1
			qdel(I)

	if(!iconRemoved)
		var/image/J = image('icons/mob/mob.dmi', loc = src, icon_state = icon)
		client.images += J

/mob/observer/dead/proc/toggle_visibility(var/forced = 0)
	set category = "Ghost"
	set name = "Toggle Visibility"
	set desc = "Allows you to turn (in)visible (almost) at will."

	var/toggled_invisible
	if(!forced && plane == PLANE_GHOSTS && world.time < toggled_invisible + 600)
		to_chat(src, "You must gather strength before you can turn visible again...")
		return

	if(plane == PLANE_WORLD)
		toggled_invisible = world.time
		visible_message("<span class='emote'>It fades from sight...</span>", "<span class='info'>You are now invisible.</span>")
	else
		to_chat(src, "<span class='info'>You are now visible!</span>")

	plane = (plane == PLANE_GHOSTS) ? PLANE_WORLD : PLANE_GHOSTS
	invisibility = (plane == PLANE_WORLD) ? 0 : INVISIBILITY_OBSERVER

	// Give the ghost a cult icon which should be visible only to itself
	toggle_icon("cult")

/mob/observer/dead/verb/toggle_anonsay()
	set category = "Ghost"
	set name = "Toggle Anonymous Chat"
	set desc = "Toggles showing your key in dead chat."

	src.anonsay = !src.anonsay
	if(anonsay)
		to_chat(src, "<span class='info'>Your key won't be shown when you speak in dead chat.</span>")
	else
		to_chat(src, "<span class='info'>Your key will be publicly visible again.</span>")

/mob/observer/dead/canface()
	return 1

/mob/observer/dead/proc/can_admin_interact()
	return check_rights(R_ADMIN|R_EVENT, 0, src)

/mob/observer/dead/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Ghost"
	ghostvision = !ghostvision
	updateghostsight()
	to_chat(src, "You [ghostvision ? "now" : "no longer"] have ghost vision.")

/mob/observer/dead/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set desc = "Toggles your ability to see lighting overlays, and the darkness they create."
	set category = "Ghost"
	
	var/static/list/darkness_names = list("normal darkness levels", "30% darkness removed", "70% darkness removed", "no darkness")
	var/static/list/darkness_levels = list(255, 178, 76, 0)

	var/index = darkness_levels.Find(lighting_alpha)
	if(!index || index >= darkness_levels.len)
		index = 1
	else
		index++
	
	lighting_alpha = darkness_levels[index]
	updateghostsight()
	to_chat(src, "Your vision now has [darkness_names[index]].")

/mob/observer/dead/proc/updateghostsight()
	plane_holder.set_desired_alpha(VIS_LIGHTING, lighting_alpha)
	plane_holder.set_vis(VIS_LIGHTING, lighting_alpha)
	plane_holder.set_vis(VIS_GHOSTS, ghostvision)

/mob/observer/dead/MayRespawn(var/feedback = 0)
	if(!client)
		return 0
	if(mind && mind.current && mind.current.stat != DEAD && can_reenter_corpse)
		if(feedback)
			to_chat(src, "<span class='warning'>Your non-dead body prevent you from respawning.</span>")
		return 0
	if(config.antag_hud_restricted && has_enabled_antagHUD == 1)
		if(feedback)
			to_chat(src, "<span class='warning'>antagHUD restrictions prevent you from respawning.</span>")
		return 0
	return 1

/atom/proc/extra_ghost_link()
	return

/mob/extra_ghost_link(var/atom/ghost)
	if(client && eyeobj)
		return "|<a href='byond://?src=\ref[ghost];track=\ref[eyeobj]'>eye</a>"

/mob/observer/dead/extra_ghost_link(var/atom/ghost)
	if(mind && mind.current)
		return "|<a href='byond://?src=\ref[ghost];track=\ref[mind.current]'>body</a>"

/proc/ghost_follow_link(var/atom/target, var/atom/ghost)
	if((!target) || (!ghost)) return
	. = "<a href='byond://?src=\ref[ghost];track=\ref[target]'>follow</a>"
	. += target.extra_ghost_link(ghost)

//Culted Ghosts

/mob/observer/dead/proc/ghost_whisper()
	set name = "Spectral Whisper"
	set category = "IC"

	if(is_manifest)  //Only able to whisper if it's hit with a tome.
		var/list/options = list()
		for(var/mob/living/Ms in view(src))
			options += Ms
		var/mob/living/M = tgui_input_list(src, "Select who to whisper to:", "Whisper to?", options)
		if(!M)
			return 0
		var/msg = sanitize(input(src, "Message:", "Spectral Whisper") as text|null)
		if(msg)
			log_say("(SPECWHISP to [key_name(M)]): [msg]", src)
			to_chat(M, "<span class='warning'> You hear a strange, unidentifiable voice in your head... <font color='purple'>[msg]</font></span>")
			to_chat(src, "<span class='warning'> You said: '[msg]' to [M].</span>")
		else
			return
		return 1
	else
		to_chat(src, "<span class='danger'>You have not been pulled past the veil!</span>")

/mob/observer/dead/verb/choose_ghost_sprite()
	set category = "Ghost"
	set name = "Choose Sprite"

	var/choice
	var/previous_state
	var/finalized = "No"

	while(finalized == "No" && src.client)
		choice = tgui_input_list(usr, "What would you like to use for your ghost sprite?", "Ghost Sprite", possible_ghost_sprites)
		if(!choice)
			return

		if(choice)
			icon = 'icons/mob/ghost.dmi'
			cut_overlays()

			if(icon_state && icon)
				previous_state = icon_state

			icon_state = possible_ghost_sprites[choice]
			finalized = tgui_alert(src, "Look at your sprite. Is this what you wish to use?","Ghost Sprite",list("No","Yes"))

			ghost_sprite = possible_ghost_sprites[choice]

			if(finalized == "No")
				icon_state = previous_state

/mob/observer/dead/is_blind()
	return FALSE

/mob/observer/dead/is_deaf()
	return FALSE

/mob/observer/dead/verb/paialert()
	set category = "Ghost"
	set name = "Blank pAI alert"
	set desc = "Flash an indicator light on available blank pAI devices for a smidgen of hope."
	
	if(usr.client.prefs?.be_special & BE_PAI)
		var/count = 0
		for(var/obj/item/device/paicard/p in all_pai_cards)
			var/obj/item/device/paicard/PP = p
			if(PP.pai == null)
				count++
<<<<<<< HEAD
				PP.icon = 'icons/obj/pda_vr.dmi' // VOREStation Edit
=======
>>>>>>> 2a494dcb666... Merge pull request #8530 from Spookerton/cerebulon/ssoverlay
				PP.add_overlay("pai-ghostalert")
				spawn(54)
					PP.cut_overlays()
		to_chat(usr,"<span class='notice'>Flashing the displays of [count] unoccupied PAIs.</span>")
	else
		to_chat(usr,"<span class='warning'>You have 'Be pAI' disabled in your character prefs, so we can't help you.</span>")

/mob/observer/dead/speech_bubble_appearance()
	return "ghost"

// Lets a ghost know someone's trying to bring them back, and for them to get into their body.
// Mostly the same as TG's sans the hud element, since we don't have TG huds.
/mob/observer/dead/proc/notify_revive(var/message, var/sound, flashwindow = TRUE, var/atom/source)
	if((last_revive_notification + 2 MINUTES) > world.time)
		return
	last_revive_notification = world.time

	if(flashwindow)
		window_flash(client)
	if(message)
		to_chat(src, "<span class='ghostalert'><font size=4>[message]</font></span>")
		if(source)
			throw_alert("\ref[source]_notify_revive", /obj/screen/alert/notify_cloning, new_master = source)
	to_chat(src, "<span class='ghostalert'><a href=?src=[REF(src)];reenter=1>(Click to re-enter)</a></span>")
	if(sound)
		SEND_SOUND(src, sound(sound))

/mob/observer/dead/verb/respawn()
	set name = "Respawn"
	set category = "Ghost"
	src.abandon_mob()
