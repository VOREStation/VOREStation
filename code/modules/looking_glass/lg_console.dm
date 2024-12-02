/obj/machinery/computer/looking_glass
	name = "looking glass control"
	desc = "Controls the looking glass displays in this room. Provided courtesy of Morpheus."

	icon_keyboard = "tech_key"
	icon_screen = "holocontrol"

	var/static/list/supported_programs = list()
	var/static/list/secret_programs = list()

	use_power = USE_POWER_IDLE
	active_power_usage = 8000

	var/current_program = "Off"
	var/area/looking_glass/my_area
	var/last_gravity_change = 0
	var/ready = TRUE
	var/immersion = FALSE

	var/lg_id = "change_me"

/obj/machinery/computer/looking_glass/Initialize()
	. = ..()
	for(var/area/looking_glass/lga in world)
		if(lga.lg_id == lg_id)
			my_area = lga
			break
	if(!istype(my_area))
		testing("Looking glass console [x],[y],[x] not in a looking glass area.")
	if(!supported_programs.len)
		supported_programs["Off"] = null
		supported_programs["Diagnostics"] = image(icon = 'icons/skybox/skybox.dmi', icon_state = "diagnostic")
		supported_programs["Space 1"] = image(icon = 'icons/skybox/skybox.dmi', icon_state = "space1")
		supported_programs["Space 2"] = image(icon = 'icons/skybox/skybox.dmi', icon_state = "space2")
		supported_programs["Space 3"] = image(icon = 'icons/skybox/skybox.dmi', icon_state = "space3")
		supported_programs["Space 4"] = image(icon = 'icons/skybox/skybox.dmi', icon_state = "space4")
		supported_programs["Space 5"] = image(icon = 'icons/skybox/skybox.dmi', icon_state = "space5")
		supported_programs["Space 6"] = image(icon = 'icons/skybox/skybox.dmi', icon_state = "space6")

		secret_programs["Maw"] = image(icon = 'icons/skybox/skybox_vr.dmi', icon_state = "maw")
		secret_programs["Flesh"] = image(icon = 'icons/skybox/skybox_vr.dmi', icon_state = "flesh")
		secret_programs["Synth Int"] = image(icon = 'icons/skybox/skybox_vr.dmi', icon_state = "synthinsides")
		secret_programs["Synth Int 2"] = image(icon = 'icons/skybox/skybox_vr.dmi', icon_state = "synthinsides_active")
		secret_programs["Two Teshari"] = image(icon = 'icons/skybox/skybox_vr.dmi', icon_state = "doubletesh")
		secret_programs["Teshari 1"] = image(icon = 'icons/skybox/skybox_vr.dmi', icon_state = "sca")
		secret_programs["Teshari 2"] = image(icon = 'icons/skybox/skybox_vr.dmi', icon_state = "eis")

/obj/machinery/computer/looking_glass/Destroy()
	my_area = null
	return ..()

/obj/machinery/computer/looking_glass/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/looking_glass/attack_hand(var/mob/user as mob)
	if(..())
		return

	tgui_interact(user)

/obj/machinery/computer/looking_glass/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LookingGlass", name)
		ui.open()

/obj/machinery/computer/looking_glass/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/program_list = list()
	for(var/P in supported_programs)
		program_list.Add(P)

	if(emagged)
		for(var/P in secret_programs)
			program_list.Add(P)

	data["supportedPrograms"] = program_list
	data["currentProgram"] = current_program
	data["immersion"] = immersion
	if(my_area?.get_gravity())
		data["gravity"] = 1
	else
		data["gravity"] = 0

	return data

/obj/machinery/computer/looking_glass/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("program")
			if(ready)
				var/prog = params["program"]
				if(prog == "Off")
					current_program = "Off"
					unload_program()
				else if((prog in supported_programs) || (emagged && (prog in secret_programs)))
					current_program = prog
					load_program(prog)
			else
				visible_message(span_warning("ERROR. Recalibrating displays."))
			return TRUE

		if("gravity")
			toggle_gravity(my_area)
			return TRUE

		if("immersion")
			immersion = !immersion
			my_area.toggle_optional(immersion)
			return TRUE

	add_fingerprint(ui.user)

/obj/machinery/computer/looking_glass/emag_act(var/remaining_charges, var/mob/user as mob)
	if (!emagged)
		playsound(src, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, span_notice("You unlock several programs that were hidden somewhere in memory."))
		log_game("[key_name(user)] emagged the [name]")
		return 1
	return

/obj/machinery/computer/looking_glass/proc/load_program(var/prog_name)
	ready = FALSE
	VARSET_IN(src, ready, TRUE, 10 SECONDS)

	if(prog_name in supported_programs)
		my_area.begin_program(supported_programs[prog_name])
	else if(prog_name in secret_programs)
		my_area.begin_program(secret_programs[prog_name])

/obj/machinery/computer/looking_glass/proc/unload_program()
	ready = FALSE
	VARSET_IN(src, ready, TRUE, 10 SECONDS)

	my_area.end_program()

/obj/machinery/computer/looking_glass/proc/toggle_gravity(var/area/A)
	if(world.time < (last_gravity_change + 3 SECONDS))
		if(world.time < (last_gravity_change + 1 SECOND))
			return
		visible_message(span_warning("ERROR. Recalibrating gravity field."))
		return

	last_gravity_change = world.time

	if(A.get_gravity())
		A.gravitychange(0)
	else
		A.gravitychange(1)

//This could all be done better, but it works for now.
/obj/machinery/computer/looking_glass/Destroy()
	unload_program()
	..()

/obj/machinery/computer/looking_glass/ex_act(severity)
	unload_program()
	..()

/obj/machinery/computer/looking_glass/power_change()
	var/oldstat = stat
	..()
	if (stat != oldstat && (stat & NOPOWER))
		unload_program()
