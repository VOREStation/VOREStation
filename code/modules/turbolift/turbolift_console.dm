// Base type, do not use.
/obj/structure/lift
	name = "turbolift control component"
	icon = 'icons/obj/turbolift.dmi'
	anchored = TRUE
	density = FALSE
	plane = MOB_PLANE

	var/datum/turbolift/lift

/obj/structure/lift/set_dir(var/newdir)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	if(dir & NORTH)
		pixel_y = -32
	else if(dir & SOUTH)
		pixel_y = 32
	else if(dir & EAST)
		pixel_x = -32
	else if(dir & WEST)
		pixel_x = 32

/obj/structure/lift/proc/pressed(var/mob/user)
	if(!istype(user, /mob/living/silicon))
		if(user.a_intent == I_HURT)
			user.visible_message("<span class='danger'>\The [user] hammers on the lift button!</span>")
		else
			user.visible_message("<b>\The [user]</b> presses the lift button.")


/obj/structure/lift/Initialize(var/ml, var/datum/turbolift/_lift)
	lift = _lift
	. = ..(ml)

/obj/structure/lift/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/structure/lift/attack_generic(var/mob/user)
	return attack_hand(user)

/obj/structure/lift/attack_hand(var/mob/user)
	return interact(user)

/obj/structure/lift/interact(var/mob/user)
	if(!lift.is_functional())
		return 0
	return 1
// End base.

// Button. No HTML interface, just calls the associated lift to its floor.
/obj/structure/lift/button
	name = "elevator button"
	desc = "A call button for an elevator. Be sure to hit it three hundred times."
	icon_state = "button"
	var/light_up = FALSE
	req_access = list(access_eva)
	var/datum/turbolift_floor/floor

/obj/structure/lift/button/Destroy()
	if(floor && floor.ext_panel == src)
		floor.ext_panel = null
	floor = null
	return ..()

/obj/structure/lift/button/proc/reset()
	light_up = FALSE
	update_icon()

// Hit it with a PDA or ID to enable priority call mode
/obj/structure/lift/button/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/weapon/card/id/id = W.GetID()
	if(istype(id))
		if(!check_access(id))
			playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)
			return
		lift.priority_mode()
		if(floor == lift.current_floor)
			lift.open_doors()
		else
			lift.queue_move_to(floor)
		return
	. = ..()

/obj/structure/lift/button/interact(var/mob/user)
	if(!..())
		return
	if(lift.fire_mode || lift.priority_mode)
		playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)
		return
	light_up()
	pressed(user)
	if(floor == lift.current_floor && !(lift.target_floor))	//Make sure we're not going anywhere before opening doors
		lift.open_doors()
		spawn(3)
			reset()
		return
	lift.queue_move_to(floor)

/obj/structure/lift/button/proc/light_up()
	light_up = TRUE
	update_icon()

/obj/structure/lift/button/update_icon()
	if(lift.fire_mode)
		icon_state = "button_fire"
	else if(lift.priority_mode)
		icon_state = "button_pri"
	else if(light_up)
		icon_state = "button_lit"
	else
		icon_state = initial(icon_state)

// End button.

// Panel. Lists floors (HTML), moves with the elevator, schedules a move to a given floor.
/obj/structure/lift/panel
	name = "elevator control panel"
	desc = "A control panel for moving the elevator. There's a slot for swiping IDs to enable additional controls."
	icon_state = "panel"
	req_access = list(access_eva)
	req_one_access = list(access_heads, access_atmospherics, access_medical)

// Hit it with a PDA or ID to enable priority call mode
/obj/structure/lift/panel/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/weapon/card/id/id = W.GetID()
	if(istype(id))
		if(!check_access(id))
			playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)
			return
		lift.update_fire_mode(!lift.fire_mode)
		if(lift.fire_mode)
			audible_message("<span class='danger'>Firefighter Mode Activated.  Door safeties disabled.  Manual control engaged.</span>", runemessage = "SCREECH")
			playsound(src, 'sound/machines/airalarm.ogg', 25, 0, 4, volume_channel = VOLUME_CHANNEL_ALARMS)
		else
			audible_message("<span class='warning'>Firefighter Mode Deactivated. Door safeties enabled.  Automatic control engaged.</span>", runemessage = "ding")
		return
	. = ..()

/obj/structure/lift/panel/attack_ghost(var/mob/user)
	return interact(user)

/obj/structure/lift/panel/interact(var/mob/user)
	if(!..())
		return
	
	tgui_interact(user)

/obj/structure/lift/panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Turbolift", name)
		ui.open()

/obj/structure/lift/panel/tgui_data(mob/user)
	var/list/data = list()

	data["doors_open"] = lift.doors_are_open()
	data["fire_mode"] = lift.fire_mode

	var/list/floors = list()
	for(var/i in lift.floors.len to 1 step -1)
		var/datum/turbolift_floor/floor = lift.floors[i]
		floors.Add(list(list(
			"id" = i,
			"ref" = "\ref[floor]",
			"queued" = (floor in lift.queued_floors),
			"target" = (lift.target_floor == floor),
			"current" = (lift.current_floor == floor),
			"label" = floor.label,
			"name" = floor.name,
		)))
	data["floors"] = floors
	
	return data

/obj/structure/lift/panel/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("move_to_floor")
			. = TRUE
			lift.queue_move_to(locate(params["ref"]))
		if("toggle_doors")
			. = TRUE
			if(lift.doors_are_open())
				lift.close_doors()
			else
				lift.open_doors()
		if("emergency_stop")
			. = TRUE
			lift.emergency_stop()

	if(.)
		pressed(usr)

/obj/structure/lift/panel/update_icon()
	if(lift.fire_mode)
		icon_state = "panel_fire"
	else
		icon_state = initial(icon_state)

// End panel.