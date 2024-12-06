/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	appearance_flags = TILE_BOUND|PIXEL_SCALE|NO_CLIENT_COLOR
	layer = LAYER_HUD_BASE
	plane = PLANE_PLAYER_HUD
	unacidable = TRUE
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.
	var/datum/hud/hud = null // A reference to the owner HUD, if any.

/obj/screen/Destroy()
	master = null
	return ..()

/obj/screen/proc/component_click(obj/screen/component_button/component, params)
	return

/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480


/obj/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.
	var/list/object_overlays = list() // Required for inventory/screen overlays.

/obj/screen/inventory/MouseEntered()
	..()
	add_overlays()

/obj/screen/inventory/MouseExited()
	..()
	cut_overlay(object_overlays)
	object_overlays.Cut()

/obj/screen/inventory/proc/add_overlays()
	if(hud && hud.mymob && slot_id)
		var/mob/user = hud.mymob
		var/obj/item/holding = user.get_active_hand()

		if(!holding || user.get_equipped_item(slot_id))
			return

		var/image/item_overlay = image(holding)
		item_overlay.alpha = 92

		if(!holding.mob_can_equip(user, slot_id, disable_warning = TRUE))
			item_overlay.color = "#ff0000"
		else
			item_overlay.color = "#00ff00"

		object_overlays += item_overlay
		add_overlay(object_overlays)

/obj/screen/close
	name = "close"

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/storage))
			var/obj/item/storage/S = master
			S.close(usr)
	return 1


/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Destroy()
	. = ..()
	owner = null

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return 1
	if(!usr.checkClickCooldown())
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return 1

	if(!(owner in usr))
		return 1

	owner.ui_action_click()
	return 1

/obj/screen/grab
	name = "grab"

/obj/screen/grab/Click()
	var/obj/item/grab/G = master
	G.s_click(src)
	return 1

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return


/obj/screen/storage
	name = "storage"

/obj/screen/storage/Click()
	if(!usr.checkClickCooldown())
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1
	if(master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			usr.ClickOn(master)
	return 1

/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = BP_TORSO
	var/static/list/hover_overlays_cache = list()
	var/hovering_choice
	var/mutable_appearance/selecting_appearance

/obj/screen/zone_sel/Click(location, control,params)
	if(isobserver(usr))
		return

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/choice = get_zone_at(icon_x, icon_y)
	if(!choice)
		return 1

	return set_selected_zone(choice, usr)

/obj/screen/zone_sel/MouseEntered(location, control, params)
	MouseMove(location, control, params)

/obj/screen/zone_sel/MouseMove(location, control, params)
	if(isobserver(usr))
		return

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/choice = get_zone_at(icon_x, icon_y)

	if(hovering_choice == choice)
		return
	vis_contents -= hover_overlays_cache[hovering_choice]
	hovering_choice = choice

	if(!choice)
		return

	var/obj/effect/overlay/zone_sel/overlay_object = hover_overlays_cache[choice]
	if(!overlay_object)
		overlay_object = new
		overlay_object.icon_state = "[choice]"
		hover_overlays_cache[choice] = overlay_object
	vis_contents += overlay_object

/obj/effect/overlay/zone_sel
	icon = 'icons/mob/zone_sel.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 128
	anchored = TRUE
	layer = LAYER_HUD_ABOVE
	plane = PLANE_PLAYER_HUD_ABOVE

/obj/screen/zone_sel/MouseExited(location, control, params)
	if(!isobserver(usr) && hovering_choice)
		vis_contents -= hover_overlays_cache[hovering_choice]
		hovering_choice = null

/obj/screen/zone_sel/proc/get_zone_at(icon_x, icon_y)
	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					return BP_R_FOOT
				if(17 to 22)
					return BP_L_FOOT
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					return BP_R_LEG
				if(17 to 22)
					return BP_L_LEG
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					return BP_R_HAND
				if(12 to 20)
					return BP_GROIN
				if(21 to 24)
					return BP_L_HAND
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					return BP_R_ARM
				if(12 to 20)
					return BP_TORSO
				if(21 to 24)
					return BP_L_ARM
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							return O_MOUTH
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							return O_EYES
					if(25 to 27)
						if(icon_x in 15 to 17)
							return O_EYES
				return BP_HEAD

/obj/screen/zone_sel/proc/set_selected_zone(choice, mob/user)
	if(isobserver(user))
		return
	if(choice != selecting)
		selecting = choice
		update_icon()

/obj/screen/zone_sel/update_icon()
	cut_overlays()
	selecting_appearance = mutable_appearance('icons/mob/zone_sel.dmi', "[selecting]")
	add_overlay(selecting_appearance)

/obj/screen/Click(location, control, params)
	..() // why the FUCK was this not called before
	if(!usr)	return 1
	switch(name)
		if("toggle")
			if(usr.hud_used.inventory_shown)
				usr.hud_used.inventory_shown = 0
				usr.client.screen -= usr.hud_used.other
			else
				usr.hud_used.inventory_shown = 1
				usr.client.screen += usr.hud_used.other

			usr.hud_used.hidden_inventory_update()

		if("equip")
			if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
				return 1
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("control_vtec")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.speed == 0 && R.vtec_active)
					R.speed = -0.5
					R.hud_used.control_vtec.icon_state = "speed_1"
				else if(R.speed == -0.5 && R.vtec_active)
					R.speed = -1
					R.hud_used.control_vtec.icon_state = "speed_2"
				else
					R.speed = 0
					R.hud_used.control_vtec.icon_state = "speed_0"

		if("mov_intent")
			if(isliving(usr))
				if(iscarbon(usr))
					var/mob/living/carbon/C = usr
					if(C.legcuffed)
						to_chat(C, span_notice("You are legcuffed! You cannot run until you get [C.legcuffed] removed!"))
						C.m_intent = "walk"	//Just incase
						C.hud_used.move_intent.icon_state = "walking"
						return 1
				var/mob/living/L = usr
				switch(L.m_intent)
					if("run")
						L.m_intent = "walk"
						L.hud_used.move_intent.icon_state = "walking"
					if("walk")
						L.m_intent = "run"
						L.hud_used.move_intent.icon_state = "running"
		if("m_intent")
			if(!usr.m_int)
				switch(usr.m_intent)
					if("run")
						usr.m_int = "13,14"
					if("walk")
						usr.m_int = "14,14"
					if("face")
						usr.m_int = "15,14"
			else
				usr.m_int = null
		if("walk")
			usr.m_intent = "walk"
			usr.m_int = "14,14"
		if("face")
			usr.m_intent = "face"
			usr.m_int = "15,14"
		if("run")
			usr.m_intent = "run"
			usr.m_int = "13,14"
		if("Reset Machine")
			usr.unset_machine()
		if("internal")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
					if(C.internal)
						C.internal = null
						to_chat(C, span_notice("No longer running on internals."))
						if(C.internals)
							C.internals.icon_state = "internal0"
					else

						var/no_mask
						if(!(C.wear_mask && C.wear_mask.item_flags & AIRTIGHT))
							var/mob/living/carbon/human/H = C
							if(!(H.head && H.head.item_flags & AIRTIGHT))
								no_mask = 1

						if(no_mask)
							to_chat(C, span_notice("You are not wearing a suitable mask or helmet."))
							return 1
						else
							var/list/nicename = null
							var/list/tankcheck = null
							var/breathes = GAS_O2    //default, we'll check later
							var/list/contents = list()
							var/from = "on"

							if(ishuman(C))
								var/mob/living/carbon/human/H = C
								breathes = H.species.breath_type
								nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
								tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
							else
								nicename = list("right hand", "left hand", "back")
								tankcheck = list(C.r_hand, C.l_hand, C.back)

							// Rigs are a fucking pain since they keep an air tank in nullspace.
							var/obj/item/rig/Rig = C.get_rig()
							if(Rig)
								if(Rig.air_supply && !Rig.offline)
									from = "in"
									nicename |= "hardsuit"
									tankcheck |= Rig.air_supply

							for(var/i=1, i<tankcheck.len+1, ++i)
								if(istype(tankcheck[i], /obj/item/tank))
									var/obj/item/tank/t = tankcheck[i]
									if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
										contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
										continue					//in it, so we're going to believe the tank is what it says it is
									switch(breathes)
																		//These tanks we're sure of their contents
										if(GAS_N2) 							//So we're a bit more picky about them.

											if(t.air_contents.gas[GAS_N2] && !t.air_contents.gas[GAS_O2])
												contents.Add(t.air_contents.gas[GAS_N2])
											else
												contents.Add(0)

										if (GAS_O2)
											if(t.air_contents.gas[GAS_O2] && !t.air_contents.gas[GAS_PHORON])
												contents.Add(t.air_contents.gas[GAS_O2])
											else
												contents.Add(0)

										// No races breath this, but never know about downstream servers.
										if ("carbon dioxide")
											if(t.air_contents.gas[GAS_CO2] && !t.air_contents.gas[GAS_PHORON])
												contents.Add(t.air_contents.gas[GAS_CO2])
											else
												contents.Add(0)

										// And here's for the Vox
										if (GAS_PHORON)
											if(t.air_contents.gas[GAS_PHORON] && !t.air_contents.gas[GAS_O2])
												contents.Add(t.air_contents.gas[GAS_PHORON])
											else
												contents.Add(0)


								else
									//no tank so we set contents to 0
									contents.Add(0)

							//Alright now we know the contents of the tanks so we have to pick the best one.

							var/best = 0
							var/bestcontents = 0
							for(var/i=1, i <  contents.len + 1 , ++i)
								if(!contents[i])
									continue
								if(contents[i] > bestcontents)
									best = i
									bestcontents = contents[i]


							//We've determined the best container now we set it as our internals

							if(best)
								to_chat(C, span_notice("You are now running on internals from [tankcheck[best]] [from] your [nicename[best]]."))
								C.internal = tankcheck[best]


							if(C.internal)
								if(C.internals)
									C.internals.icon_state = "internal1"
							else
								to_chat(C, span_notice("You don't have a[breathes==GAS_O2 ? "n " + GAS_O2 + " : addtext(" ",breathes)] tank."))
		if("act_intent")
			usr.a_intent_change("right")
		if(I_HELP)
			usr.a_intent = I_HELP
			if(ispAI(usr))
				usr.a_intent_change(I_HELP)
			else
				usr.hud_used.action_intent.icon_state = "intent_help"
		if(I_HURT)
			usr.a_intent = I_HURT
			if(ispAI(usr))
				usr.a_intent_change(I_HURT)
			else
				usr.hud_used.action_intent.icon_state = "intent_harm"
		if(I_GRAB)
			usr.a_intent = I_GRAB
			if(ispAI(usr))
				usr.a_intent_change(I_GRAB)
			else
				usr.hud_used.action_intent.icon_state = "intent_grab"
		if(I_DISARM)
			usr.a_intent = I_DISARM
			if(ispAI(usr))
				usr.a_intent_change(I_DISARM)
			else
				usr.hud_used.action_intent.icon_state = "intent_disarm"

		if("pull")
			usr.stop_pulling()
		if("throw")
			if(!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr:toggle_throw_mode()
		if("drop")
			if(usr.client)
				usr.client.drop_item()
		if("autowhisper")
			if(isliving(usr))
				var/mob/living/u = usr
				u.toggle_autowhisper()
		if("autowhisper mode")
			if(isliving(usr))
				var/mob/living/u = usr
				u.autowhisper_mode()
		if("check known languages")
			usr.check_languages()
		if("set pose")
			if(ishuman(usr))
				var/mob/living/carbon/human/u = usr
				u.pose()
			else if (issilicon(usr))
				var/mob/living/silicon/u = usr
				u.pose()
		if("move upwards")
			usr.up()
		if("move downwards")
			usr.down()

		if("use held item on self")
			var/obj/screen/useself/s = src
			if(ishuman(usr))
				var/mob/living/carbon/human/u = usr
				var/obj/item/i = u.get_active_hand()
				if(i)
					s.can_use(u,i)
				else
					to_chat(usr, span_notice("You're not holding anything to use. You need to have something in your active hand to use it."))

		if("module")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
//				if(R.module)
//					R.hud_used.toggle_show_robot_modules()
//					return 1
				R.pick_module()

		if("inventory")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.hud_used.toggle_show_robot_modules()
					return 1
				else
					to_chat(R, "You haven't selected a module yet.")

		if("radio")
			if(issilicon(usr))
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.uneq_active()
				else
					to_chat(R, "You haven't selected a module yet.")

		if("module1")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(1)

		if("module2")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(2)

		if("module3")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(3)

		if("AI Core")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.view_core()

		if("Show Camera List")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				var/camera = tgui_input_list(AI, "Pick Camera:", "Camera Choice", AI.get_camera_list())
				AI.ai_camera_list(camera)

		if("Track With Camera")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				var/target_name = tgui_input_list(AI, "Pick Mob:", "Mob Choice", AI.trackable_mobs())
				AI.ai_camera_track(target_name)

		if("Toggle Camera Light")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.toggle_camera_light()

		if("Crew Monitoring")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.subsystem_crew_monitor()

		if("Show Crew Manifest")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.subsystem_crew_manifest()

		if("Show Alerts")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.subsystem_alarm_monitor()

		if("Announcement")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.ai_announcement()

		if("Call Emergency Shuttle")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.ai_call_shuttle()

		if("State Laws")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.ai_checklaws()

		if("PDA - Send Message")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.aiPDA.start_program(AI.aiPDA.find_program(/datum/data/pda/app/messenger))
				AI.aiPDA.cmd_pda_open_ui(usr)

		if("PDA - Show Message Log")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.aiPDA.start_program(AI.aiPDA.find_program(/datum/data/pda/app/messenger))
				AI.aiPDA.cmd_pda_open_ui(usr)

		if("Take Image")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.take_image()

		if("View Images")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				AI.view_images()
		else
			return attempt_vr(src,"Click_vr",list(location,control,params)) //VOREStation Add - Additional things.
	return 1

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(!usr.checkClickCooldown())
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1
	switch(name)
		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("r")
		if("l_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("l")
		if("swap")
			usr:swap_hand()
		if("hand")
			usr:swap_hand()
		else
			if(usr.attack_ui(slot_id))
				usr.update_inv_l_hand(0)
				usr.update_inv_r_hand(0)
	return 1

// Hand slots are special to handle the handcuffs overlay
/obj/screen/inventory/hand
	var/image/handcuff_overlay

/obj/screen/inventory/hand/update_icon()
	..()
	if(!hud)
		return
	if(!handcuff_overlay)
		var/state = (hud.l_hand_hud_object == src) ? "l_hand_hud_handcuffs" : "r_hand_hud_handcuffs"
		handcuff_overlay = image("icon"='icons/mob/screen_gen.dmi', "icon_state"=state)
	cut_overlays()
	if(hud.mymob && iscarbon(hud.mymob))
		var/mob/living/carbon/C = hud.mymob
		if(C.handcuffed)
			add_overlay(handcuff_overlay)

// PIP stuff
/obj/screen/component_button
	var/obj/screen/parent

/obj/screen/component_button/Initialize(mapload, obj/screen/new_parent)
	. = ..()
	parent = new_parent

/obj/screen/component_button/Click(params)
	if(parent)
		parent.component_click(src, params)

// Character setup stuff
/obj/screen/setup_preview

	var/datum/preferences/pref

/obj/screen/setup_preview/Destroy()
	pref = null
	return ..()

// Background 'floor'
/obj/screen/setup_preview/pm_helper
	icon = null
	icon_state = null
	appearance_flags = PLANE_MASTER
	plane = PLANE_EMISSIVE
	alpha = 0

/obj/screen/setup_preview/bg
	mouse_over_pointer = MOUSE_HAND_POINTER

/obj/screen/setup_preview/bg/Click(params)
	pref?.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
	pref?.update_preview_icon()

/obj/screen/splash
	screen_loc = "1,1"
	layer = LAYER_HUD_ABOVE
	plane = PLANE_PLAYER_HUD_ABOVE
	var/client/holder

/obj/screen/splash/New(client/C, visible)
	. = ..()

	holder = C

	if(!visible)
		alpha = 0

	if(!lobby_image)
		qdel(src)
		return

	icon = lobby_image.icon
	icon_state = lobby_image.icon_state

	holder.screen += src

/obj/screen/splash/proc/Fade(out, qdel_after = TRUE)
	if(QDELETED(src))
		return
	if(out)
		animate(src, alpha = 0, time = 30)
	else
		alpha = 0
		animate(src, alpha = 255, time = 30)
	if(qdel_after)
		QDEL_IN(src, 30)

/obj/screen/splash/Destroy()
	if(holder)
		holder.screen -= src
		holder = null
	return ..()


/**
 * This object holds all the on-screen elements of the mapping unit.
 * It has a decorative frame and onscreen buttons. The map itself is drawn
 * using a white mask and multiplying the mask against it to crop it to the
 * size of the screen. This is not ideal, as filter() is faster, and has
 * alpha masks, but the alpha masks it has can't be animated, so the 'ping'
 * mode of this device isn't possible using that technique.
 *
 * The markers use that technique, though, so at least there's that.
 */
/obj/screen/movable/mapper_holder
	name = "gps unit"
	icon = null
	icon_state = ""
	screen_loc = "CENTER,CENTER"
	alpha = 255
	appearance_flags = KEEP_TOGETHER
	mouse_opacity = 1
	plane = PLANE_HOLOMAP

	var/running = FALSE

	var/obj/screen/mapper/mask_full/mask_full
	var/obj/screen/mapper/mask_ping/mask_ping
	var/obj/screen/mapper/bg/bg

	var/obj/screen/mapper/frame/frame
	var/obj/screen/mapper/powbutton/powbutton
	var/obj/screen/mapper/mapbutton/mapbutton

	var/obj/item/mapping_unit/owner
	var/obj/screen/mapper/extras_holder/extras_holder

/obj/screen/movable/mapper_holder/Initialize(mapload, newowner)
	owner = newowner

	mask_full = new(src) // Full white square mask
	mask_ping = new(src) // Animated 'pinging' mask
	bg = new(src) // Background color, holds map in vis_contents, uses mult against masks

	frame = new(src) // Decorative frame
	powbutton = new(src) // Clickable button
	mapbutton = new(src) // Clickable button

	frame.icon_state = initial(frame.icon_state)+owner.hud_frame_hint

	/**
	 * The vis_contents layout is: this(frame,extras_holder,mask(bg(map)))
	 * bg is set to BLEND_MULTIPLY against the mask to crop it.
	 */

	mask_full.vis_contents.Add(bg)
	mask_ping.vis_contents.Add(bg)
	frame.vis_contents.Add(powbutton,mapbutton)
	vis_contents.Add(frame)


/obj/screen/movable/mapper_holder/Destroy()
	qdel_null(mask_full)
	qdel_null(mask_ping)
	qdel_null(bg)

	qdel_null(frame)
	qdel_null(powbutton)
	qdel_null(mapbutton)

	extras_holder = null
	owner = null
	return ..()

/obj/screen/movable/mapper_holder/proc/update(var/obj/screen/mapper/map, var/obj/screen/mapper/extras_holder/extras, ping = FALSE)
	if(!running)
		running = TRUE
		if(ping)
			vis_contents.Add(mask_ping)
		else
			vis_contents.Add(mask_full)

	bg.vis_contents.Cut()
	bg.vis_contents.Add(map)

	if(extras && !extras_holder)
		extras_holder = extras
		vis_contents += extras_holder
	if(!extras && extras_holder)
		vis_contents -= extras_holder
		extras_holder = null

/obj/screen/movable/mapper_holder/proc/powerClick()
	if(running)
		off()
	else
		on()

/obj/screen/movable/mapper_holder/proc/mapClick()
	if(owner)
		if(running)
			off()
		owner.pinging = !owner.pinging
		on()

/obj/screen/movable/mapper_holder/proc/off(var/inform = TRUE)
	frame.cut_overlay("powlight")
	bg.vis_contents.Cut()
	vis_contents.Remove(mask_ping, mask_full, extras_holder)
	extras_holder = null
	running = FALSE
	if(inform)
		owner.stop_updates()

/obj/screen/movable/mapper_holder/proc/on(var/inform = TRUE)
	frame.add_overlay("powlight")
	if(inform)
		owner.start_updates()

// Prototype
/obj/screen/mapper
	plane = PLANE_HOLOMAP
	mouse_opacity = 0
	var/obj/screen/movable/mapper_holder/parent

/obj/screen/mapper/New()
	..()
	parent = loc

/obj/screen/mapper/Destroy()
	parent = null
	return ..()

// Holds the actual map image
/obj/screen/mapper/map
	var/offset_x = 32
	var/offset_y = 32

// I really wish I could use filters for this instead of this multiplication-masking technique
// but alpha filters can't be animated, which means I can't use them for the 'sonar ping' mode.
// If filters start supporting animated icons in the future (for the alpha mask filter),
// you should definitely replace these with that technique instead.
/obj/screen/mapper/mask_full
	icon = 'icons/effects/64x64.dmi'
	icon_state = "mapper_mask"

/obj/screen/mapper/mask_ping
	icon = 'icons/effects/64x64.dmi'
	icon_state = "mapper_ping"

/obj/screen/mapper/bg
	icon = 'icons/effects/64x64.dmi'
	icon_state = "mapper_bg"

	blend_mode = BLEND_MULTIPLY
	appearance_flags = KEEP_TOGETHER

// Frame/deco components
/obj/screen/mapper/frame
	icon = 'icons/effects/gpshud.dmi'
	icon_state = "frame"
	plane = PLANE_HOLOMAP_FRAME
	pixel_x = -18
	pixel_y = -29
	mouse_opacity = 1
	vis_flags = VIS_INHERIT_ID

/obj/screen/mapper/powbutton
	icon = 'icons/effects/gpshud.dmi'
	icon_state = "powbutton"
	plane = PLANE_HOLOMAP_FRAME
	mouse_opacity = 1

/obj/screen/mapper/powbutton/Click()
	if(!usr.checkClickCooldown())
		return TRUE
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return TRUE
	if(istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return TRUE
	parent.powerClick()
	flick("powClick",src)
	usr << get_sfx("button")
	return TRUE

/obj/screen/mapper/mapbutton
	icon = 'icons/effects/gpshud.dmi'
	icon_state = "mapbutton"
	plane = PLANE_HOLOMAP_FRAME
	mouse_opacity = 1

/obj/screen/mapper/mapbutton/Click()
	if(!usr.checkClickCooldown())
		return TRUE
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return TRUE
	if(istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return TRUE
	parent.mapClick()
	flick("mapClick",src)
	usr << get_sfx("button")
	return TRUE

// Markers are 16x16, people have apparently settled on centering them on the 8,8 pixel
/obj/screen/mapper/marker
	icon = 'icons/holomap_markers.dmi'
	plane = PLANE_HOLOMAP_ICONS

	var/offset_x = -8
	var/offset_y = -8

// Holds markers in its vis_contents. It uses an alpha filter to crop them to the HUD screen size
/obj/screen/mapper/extras_holder
	icon = null
	icon_state = null
	plane = PLANE_HOLOMAP_ICONS
	appearance_flags = KEEP_TOGETHER

// Begin TGMC Ammo HUD Port
/obj/screen/ammo
	name = "ammo"
	icon = 'icons/mob/screen_ammo.dmi'
	icon_state = "ammo"
	screen_loc = ui_ammo_hud1
	var/warned = FALSE
	var/static/list/ammo_screen_loc_list = list(ui_ammo_hud1, ui_ammo_hud2, ui_ammo_hud3 ,ui_ammo_hud4)

/obj/screen/ammo/proc/add_hud(var/mob/living/user, var/obj/item/gun/G)

	if(!user?.client)
		return

	if(!G)
		CRASH("/obj/screen/ammo/proc/add_hud() has been called from [src] without the required param of G")

	if(!G.has_ammo_counter())
		return

	user.client.screen += src

/obj/screen/ammo/proc/remove_hud(var/mob/living/user)
	user?.client?.screen -= src

/obj/screen/ammo/proc/update_hud(var/mob/living/user, var/obj/item/gun/G)
	if(!user?.client?.screen.Find(src))
		return

	if(!G || !istype(G) || !G.has_ammo_counter() || !G.get_ammo_type() || isnull(G.get_ammo_count()))
		remove_hud()
		return

	var/list/ammo_type = G.get_ammo_type()
	var/rounds = G.get_ammo_count()

	var/hud_state = ammo_type[1]
	var/hud_state_empty = ammo_type[2]

	overlays.Cut()

	var/empty = image('icons/mob/screen_ammo.dmi', src, "[hud_state_empty]")

	if(rounds == 0)
		if(warned)
			overlays += empty
		else
			warned = TRUE
			var/obj/screen/ammo/F = new /obj/screen/ammo(src)
			F.icon_state = "frame"
			user.client.screen += F
			flick("[hud_state_empty]_flash", F)
			spawn(20)
				user.client.screen -= F
				qdel(F)
				overlays += empty
	else
		warned = FALSE
		overlays += image('icons/mob/screen_ammo.dmi', src, "[hud_state]")

	rounds = num2text(rounds)
	//Handle the amount of rounds
	switch(length(rounds))
		if(1)
			overlays += image('icons/mob/screen_ammo.dmi', src, "o[rounds[1]]")
		if(2)
			overlays += image('icons/mob/screen_ammo.dmi', src, "o[rounds[2]]")
			overlays += image('icons/mob/screen_ammo.dmi', src, "t[rounds[1]]")
		if(3)
			overlays += image('icons/mob/screen_ammo.dmi', src, "o[rounds[3]]")
			overlays += image('icons/mob/screen_ammo.dmi', src, "t[rounds[2]]")
			overlays += image('icons/mob/screen_ammo.dmi', src, "h[rounds[1]]")
		else //"0" is still length 1 so this means it's over 999
			overlays += image('icons/mob/screen_ammo.dmi', src, "o9")
			overlays += image('icons/mob/screen_ammo.dmi', src, "t9")
			overlays += image('icons/mob/screen_ammo.dmi', src, "h9")
