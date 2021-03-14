//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/device/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	origin_tech = list(TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, MAT_COPPER = 10, "waste" = 100)

	wires = WIRE_PULSE

	secured = 0

	var/on = 0
	var/visible = 0
	var/list/i_beams = null

/obj/item/device/assembly/infra/activate()
	if(!..())
		return FALSE
	on = !on
	update_icon()
	return TRUE

/obj/item/device/assembly/infra/toggle_secure()
	secured = !secured
	if(!secured)
		toggle_state(FALSE)
	update_icon()
	return secured

/obj/item/device/assembly/infra/proc/toggle_state(var/picked)
	if(!isnull(picked))
		on = picked
	else
		on = !on

	if(secured && on)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
		QDEL_LIST_NULL(i_beams)
	return on

/obj/item/device/assembly/infra/update_icon()
	cut_overlays()
	LAZYCLEARLIST(attached_overlays)
	if(on)
		add_overlay("infrared_on")
		LAZYADD(attached_overlays, "infrared_on")

	if(holder)
		holder.update_icon(2)

/obj/item/device/assembly/infra/process()
	if(!on && i_beams)
		QDEL_LIST_NULL(i_beams)
		return

	if(!i_beams && secured && (istype(loc, /turf) || (holder && istype(holder.loc, /turf))))
		create_beams()

/obj/item/device/assembly/infra/proc/create_beams(var/limit = 8)
	var/current_spot = get_turf(src)
	for(var/i = 1 to limit)
		var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(current_spot)
		I.master = src
		I.density = 1
		I.set_dir(dir)
		if(!step(I, I.dir)) //Try to take a step in that direction
			return //Couldn't, oh well, we hit a wall or something. Beam should qdel itself in it's Bump().
		I.density = 0
		i_beams |= I
		I.visible = visible

/obj/item/device/assembly/infra/attack_hand()
	QDEL_LIST_NULL(i_beams)
	..()

/obj/item/device/assembly/infra/Move()
	var/t = dir
	. = ..()
	set_dir(t)

/obj/item/device/assembly/infra/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	QDEL_LIST_NULL(i_beams)

/obj/item/device/assembly/infra/holder_movement()
	if(!holder)
		return FALSE
	QDEL_LIST_NULL(i_beams)
	return TRUE

/obj/item/device/assembly/infra/proc/trigger_beam()
	if(!process_cooldown())
		return FALSE
	pulse(0)
	QDEL_LIST_NULL(i_beams) //They will get recreated next process() if the situation is still appropriate
	if(!holder)
		visible_message("[bicon(src)] *beep* *beep*")

/obj/item/device/assembly/infra/tgui_interact(mob/user, datum/tgui/ui)
	if(!secured)
		to_chat(user, "<span class='warning'>[src] is unsecured!</span>")
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AssemblyInfrared", name)
		ui.open()

/obj/item/device/assembly/infra/tgui_data(mob/user)
	var/list/data = ..()

	data["on"] = on
	data["visible"] = visible

	return data

/obj/item/device/assembly/infra/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("state")
			toggle_state()
			return TRUE
		if("visible")
			visible = !visible
			for(var/ibeam in i_beams)
				var/obj/effect/beam/i_beam/I = ibeam
				I.visible = visible
				CHECK_TICK
			return TRUE

/obj/item/device/assembly/infra/verb/rotate_clockwise()
	set name = "Rotate Infrared Laser Clockwise"
	set category = "Object"
	set src in usr

	set_dir(turn(dir, 270))

/***************************IBeam*********************************/

/obj/effect/beam/i_beam
	name = "i beam"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ibeam"
	var/obj/item/device/assembly/infra/master = null
	var/visible = 0
	anchored = 1

/obj/effect/beam/i_beam/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/beam/i_beam/Destroy()
	STOP_PROCESSING(SSobj, src)
	master = null
	return ..()

/obj/effect/beam/i_beam/proc/hit()
	master?.trigger_beam()
	qdel(src)

/obj/effect/beam/i_beam/process()
	if(loc?.density || !master)
		qdel(src)
		return

/obj/effect/beam/i_beam/Bump()
	qdel(src)

/obj/effect/beam/i_beam/Bumped()
	hit()

/obj/effect/beam/i_beam/Crossed(var/atom/movable/AM)
	if(AM.is_incorporeal())
		return
	if(istype(AM, /obj/effect/beam))
		return
	hit()