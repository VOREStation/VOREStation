/obj/screen/ghost
	icon = 'icons/mob/screen_ghost.dmi'

/obj/screen/ghost/MouseEntered(location,control,params)
	flick(icon_state + "_anim", src)
	openToolTip(usr, src, params, title = name, content = desc)

/obj/screen/ghost/MouseExited()
	closeToolTip(usr)

/obj/screen/ghost/Click()
	closeToolTip(usr)

/obj/screen/ghost/returntomenu
	name = "Return to menu"
	desc = "Return to the title screen menu."
	icon_state = "returntomenu"

/obj/screen/ghost/returntomenu/Click()
	..()
	var/mob/observer/dead/G = usr
	G.abandon_mob()

/obj/screen/ghost/jumptomob
	name = "Jump to mob"
	desc = "Pick a mob from a list to jump to."
	icon_state = "jumptomob"

/obj/screen/ghost/jumptomob/Click()
	..()
	var/mob/observer/dead/G = usr
	G.jumptomob()

/obj/screen/ghost/orbit
	name = "Orbit"
	desc = "Pick a mob to follow and orbit."
	icon_state = "orbit"

/obj/screen/ghost/orbit/Click()
	..()
	var/mob/observer/dead/G = usr
	G.follow()

/obj/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	desc = "Only applicable if you HAVE a corpse..."
	icon_state = "reenter_corpse"

/obj/screen/ghost/reenter_corpse/Click()
	..()
	var/mob/observer/dead/G = usr
	G.reenter_corpse()

/obj/screen/ghost/teleport
	name = "Teleport"
	desc = "Pick an area to teleport to."
	icon_state = "teleport"

/obj/screen/ghost/teleport/Click()
	..()
	var/mob/observer/dead/G = usr
	G.dead_tele()

/obj/screen/ghost/pai
	name = "pAI Alert"
	desc = "Ping all the unoccupied pAI devices in the world."
	icon_state = "pai"

/obj/screen/ghost/pai/Click()
	..()
	var/mob/observer/dead/G = usr
	G.paialert()

/obj/screen/ghost/up
	name = "Move Upwards"
	desc = "Move up a z-level."
	icon_state = "up"

/obj/screen/ghost/up/Click()
	..()
	var/mob/observer/dead/G = usr
	G.zMove(UP)

/obj/screen/ghost/down
	name = "Move Downwards"
	desc = "Move down a z-level."
	icon_state = "down"

/obj/screen/ghost/down/Click()
	..()
	var/mob/observer/dead/G = usr
	G.zMove(DOWN)

/obj/screen/ghost/vr
	name = "Enter VR"
	desc = "Enter virtual reality."
	icon = 'icons/mob/screen_ghost.dmi'
	icon_state = "entervr"

/obj/screen/ghost/vr/Click()
	..()
	var/mob/observer/dead/G = usr
	var/datum/data/record/record_found
	record_found = find_general_record("name", G.client.prefs.real_name)
	// Found their record, they were spawned previously. Remind them corpses cannot play games.
	if(record_found)
		var/answer = tgui_alert(G, "You seem to have previously joined this round. If you are currently dead, you should not enter VR as this character. Would you still like to proceed?", "Previously spawned",list("Yes", "No"))
		if(answer != "Yes")
			return

	var/S = null
	var/list/vr_landmarks = list()
	for(var/obj/effect/landmark/virtual_reality/sloc in GLOB.landmarks_list)
		vr_landmarks += sloc.name
	if(!LAZYLEN(vr_landmarks))
		to_chat(G, "There are no available spawn locations in virtual reality.")
		return
	S = tgui_input_list(G, "Please select a location to spawn your avatar at:", "Spawn location", vr_landmarks)
	if(!S)
		return 0
	for(var/obj/effect/landmark/virtual_reality/i in GLOB.landmarks_list)
		if(i.name == S)
			S = i
			break

	G.fake_enter_vr(S)

/mob/observer/dead/create_mob_hud(datum/hud/HUD, apply_to_client = TRUE)
	..()

	var/list/adding = list()
	HUD.adding = adding

	var/obj/screen/using
	using = new /obj/screen/ghost/returntomenu()
	using.screen_loc = ui_ghost_returntomenu
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/jumptomob()
	using.screen_loc = ui_ghost_jumptomob
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/orbit()
	using.screen_loc = ui_ghost_orbit
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/reenter_corpse()
	using.screen_loc = ui_ghost_reenter_corpse
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/teleport()
	using.screen_loc = ui_ghost_teleport
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/pai()
	using.screen_loc = ui_ghost_pai
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/up()
	using.screen_loc = ui_ghost_updown
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/down()
	using.screen_loc = ui_ghost_updown
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/vr()
	using.screen_loc = ui_ghost_vr
	using.hud = src
	adding += using

	/*
	using = new /obj/screen/language_menu
	using.icon = ui_style
	using.hud = src
	adding += using
	*/

	if(client && apply_to_client)
		client.screen = list()
		client.screen += HUD.adding
		client.screen += client.void

/* I wish we had this. Not yet, though.
/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory

//We should only see observed mob alerts.
/datum/hud/ghost/reorganize_alerts(mob/viewmob)
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		return
	. = ..()
*/
