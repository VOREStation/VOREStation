/obj/item/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MAT_STEEL = 500, MAT_GLASS = 50)

	wires = WIRE_PULSE

	secured = 0

	var/timing = 0
	var/time = 10


/obj/item/assembly/timer/activate()
	if(!..())
		return FALSE

	set_state(!timing)

	update_icon()
	return 0

/obj/item/assembly/timer/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured

/obj/item/assembly/timer/proc/set_state(var/state)
	if(state && !timing) //Not running, starting though
		START_PROCESSING(SSobj, src)
	else if(timing && !state) //Running, stopping though
		STOP_PROCESSING(SSobj, src)
	timing = state

/obj/item/assembly/timer/proc/timer_end()
	if(!secured)
		return 0
	pulse(0)
	if(!holder)
		visible_message("\icon[src][bicon(src)] *beep* *beep*", "*beep* *beep*")

/obj/item/assembly/timer/process()
	if(timing && time-- <= 0)
		set_state(0)
		timer_end()
		time = 10

/obj/item/assembly/timer/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		add_overlay("timer_timing")
		attached_overlays += "timer_timing"
	if(holder)
		holder.update_icon()
	return

/obj/item/assembly/timer/tgui_interact(mob/user, datum/tgui/ui)
	if(!secured)
		to_chat(user, "<span class='warning'>[src] is unsecured!</span>")
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AssemblyTimer", name)
		ui.open()

/obj/item/assembly/timer/tgui_data(mob/user)
	var/list/data = ..()
	data["time"] = time * 10
	data["timing"] = timing
	return data

/obj/item/assembly/timer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("timing")
			timing = !timing
			update_icon()
			return TRUE
		if("set_time")
			var/real_new_time = 0
			var/new_time = params["time"]
			var/list/L = splittext(new_time, ":")
			if(LAZYLEN(L))
				for(var/i in 1 to LAZYLEN(L))
					real_new_time += text2num(L[i]) * (60 ** (LAZYLEN(L) - i))
			else
				real_new_time = text2num(new_time)
			time = clamp(real_new_time, 0, 600)
			return TRUE
