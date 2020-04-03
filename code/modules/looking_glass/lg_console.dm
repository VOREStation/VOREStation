/obj/machinery/computer/looking_glass
	name = "looking glass control"
	desc = "Controls the looking glass displays in this room. Provided courtesy of KHI."

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

/obj/machinery/computer/looking_glass/Destroy()
	my_area = null
	return ..()

/obj/machinery/computer/looking_glass/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/looking_glass/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)

	ui_interact(user)

/obj/machinery/computer/looking_glass/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	var/program_list[0]

	for(var/P in supported_programs)
		program_list[++program_list.len] = P

	if(emagged)
		for(var/P in secret_programs)
			program_list[++program_list.len] = P

	data["supportedPrograms"] = program_list
	data["currentProgram"] = current_program
	data["immersion"] = immersion
	if(my_area?.has_gravity)
		data["gravity"] = 1
	else
		data["gravity"] = null

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "lookingglass.tmpl", src.name, 400, 550)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(20)

/obj/machinery/computer/looking_glass/Topic(href, href_list)
	if(..())
		return 1
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

		if(href_list["program"])
			if(ready)
				var/prog = href_list["program"]
				if(prog == "Off")
					current_program = "Off"
					unload_program()
				else if((prog in supported_programs) || (emagged && (prog in secret_programs)))
					current_program = prog
					load_program(prog)
			else
				visible_message("<span class='warning'>ERROR. Recalibrating displays.</span>")

		else if(href_list["gravity"])
			toggle_gravity(my_area)

		else if(href_list["immersion"])
			immersion = !immersion
			my_area.toggle_optional(immersion)

		src.add_fingerprint(usr)

	SSnanoui.update_uis(src)

/obj/machinery/computer/looking_glass/emag_act(var/remaining_charges, var/mob/user as mob)
	if (!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You unlock several programs that were hidden somewhere in memory.</span>")
		log_game("[key_name(usr)] emagged the [name]")
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
		visible_message("<span class='warning'>ERROR. Recalibrating gravity field.</span>")
		return

	last_gravity_change = world.time

	if(A.has_gravity)
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