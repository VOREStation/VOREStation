//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/particle_accelerator/control_box
	name = "Particle Accelerator Control Computer"
	desc = "This controls the density of the particles."
	icon = 'icons/obj/machines/particle_accelerator_vr.dmi' //VOREStation Edit
	icon_state = "control_box"
	reference = "control_box"
	anchored = FALSE
	density = TRUE
	use_power = USE_POWER_OFF
	idle_power_usage = 500
	active_power_usage = 70000 //70 kW per unit of strength
	construction_state = 0
	active = 0
	dir = 1
	var/strength_upper_limit = 2
	var/interface_control = 1
	var/list/obj/structure/particle_accelerator/connected_parts
	var/assembled = 0
	var/parts = null
	var/datum/wires/particle_acc/control_box/wires = null

/obj/machinery/particle_accelerator/control_box/New()
	wires = new(src)
	connected_parts = list()
	update_active_power_usage(initial(active_power_usage) * (strength + 1))
	..()

/obj/machinery/particle_accelerator/control_box/Destroy()
	if(active)
		toggle_power()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/particle_accelerator/control_box/attack_hand(mob/user as mob)
	if(construction_state >= 3)
		tgui_interact(user)
	else if(construction_state == 2) // Wires exposed
		wires.Interact(user)

/obj/machinery/particle_accelerator/control_box/update_state()
	if(construction_state < 3)
		update_use_power(USE_POWER_OFF)
		assembled = 0
		active = 0
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength = null
			part.powered = 0
			part.update_icon()
		connected_parts = list()
		return
	if(!part_scan())
		update_use_power(USE_POWER_IDLE)
		active = 0
		connected_parts = list()


/obj/machinery/particle_accelerator/control_box/update_icon()
	if(active)
		icon_state = "[reference]p[strength]"
	else
		if(use_power)
			if(assembled)
				icon_state = "[reference]p"
			else
				icon_state = "u[reference]p"
		else
			switch(construction_state)
				if(0)
					icon_state = "[reference]"
				if(1)
					icon_state = "[reference]"
				if(2)
					icon_state = "[reference]w"
				else
					icon_state = "[reference]c"

/obj/machinery/particle_accelerator/control_box/proc/strength_change()
	for(var/obj/structure/particle_accelerator/part in connected_parts)
		part.strength = strength
		part.update_icon()

/obj/machinery/particle_accelerator/control_box/proc/add_strength(var/s)
	if(assembled)
		strength++
		if(strength > strength_upper_limit)
			strength = strength_upper_limit
		else
			message_admins("PA Control Computer increased to [strength] by [key_name(usr, usr.client)](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[usr]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
			log_game("PACCEL([x],[y],[z]) [key_name(usr)] increased to [strength]")
			investigate_log("increased to <font color='red'>[strength]</font> by [usr.key]","singulo")
		strength_change()

/obj/machinery/particle_accelerator/control_box/proc/remove_strength(var/s)
	if(assembled)
		strength--
		if(strength < 0)
			strength = 0
		else
			message_admins("PA Control Computer decreased to [strength] by [key_name(usr, usr.client)](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[usr]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
			log_game("PACCEL([x],[y],[z]) [key_name(usr)] decreased to [strength]")
			investigate_log("decreased to <font color='green'>[strength]</font> by [usr.key]","singulo")
		strength_change()

/obj/machinery/particle_accelerator/control_box/power_change()
	..()
	if(stat & NOPOWER)
		active = 0
		update_use_power(USE_POWER_OFF)
	else if(!stat && construction_state == 3)
		update_use_power(USE_POWER_IDLE)


/obj/machinery/particle_accelerator/control_box/process()
	if(src.active)
		//a part is missing!
		if( length(connected_parts) < 6 )
			log_game("PACCEL([x],[y],[z]) Failed due to missing parts.")
			investigate_log("lost a connected part; It <font color='red'>powered down</font>.","singulo")
			toggle_power()
			return
		//emit some particles
		for(var/obj/structure/particle_accelerator/particle_emitter/PE in connected_parts)
			if(PE)
				PE.emit_particle(src.strength)


/obj/machinery/particle_accelerator/control_box/proc/part_scan()
	for(var/obj/structure/particle_accelerator/fuel_chamber/F in orange(1,src))
		src.set_dir(F.dir)
		break

	connected_parts = list()
	assembled = 0
	var/ldir = turn(dir,90)
	var/rdir = turn(dir,-90)
	var/odir = turn(dir,180)
	var/turf/T = src.loc

	T = get_step(T,ldir)
	if(!check_part(T,/obj/structure/particle_accelerator/fuel_chamber))
		return 0

	T = get_step(T,odir)
	if(!check_part(T,/obj/structure/particle_accelerator/end_cap))
		return 0

	T = get_step(T,dir)
	T = get_step(T,dir)
	if(!check_part(T,/obj/structure/particle_accelerator/power_box))
		return 0

	T = get_step(T,dir)
	if(!check_part(T,/obj/structure/particle_accelerator/particle_emitter/center))
		return 0

	T = get_step(T,ldir)
	if(!check_part(T,/obj/structure/particle_accelerator/particle_emitter/left))
		return 0

	T = get_step(T,rdir)
	T = get_step(T,rdir)
	if(!check_part(T,/obj/structure/particle_accelerator/particle_emitter/right))
		return 0

	assembled = 1
	return 1



/obj/machinery/particle_accelerator/control_box/proc/check_part(var/turf/T, var/type)
	if(!(T)||!(type))
		return 0

	var/obj/structure/particle_accelerator/PA = locate(/obj/structure/particle_accelerator) in T
	if(istype(PA, type) && PA.connect_master(src) && PA.report_ready(src))
		src.connected_parts.Add(PA)
		return 1
	return 0


/obj/machinery/particle_accelerator/control_box/proc/toggle_power()
	active = !active
	investigate_log("turned [active?"<font color='red'>ON</font>":"<font color='green'>OFF</font>"] by [usr ? usr.key : "outside forces"]","singulo")
	message_admins("PA Control Computer turned [active ?"ON":"OFF"] by [usr ? key_name(usr, usr.client) : "outside forces"](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[usr]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("PACCEL([x],[y],[z]) [usr ? key_name(usr, usr.client) : "outside forces"] turned [active?"ON":"OFF"].")
	if(active)
		update_use_power(USE_POWER_ACTIVE)
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength = src.strength
			part.powered = 1
			part.update_icon()
	else
		update_use_power(USE_POWER_IDLE)
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength = null
			part.powered = 0
			part.update_icon()
	return 1

/obj/machinery/particle_accelerator/control_box/proc/is_interactive(mob/user)
	if(!interface_control)
		to_chat(user, "<span class='alert'>ERROR: Request timed out. Check wire contacts.</span>")
		return FALSE
	if(construction_state != 3)
		return FALSE
	return TRUE

/obj/machinery/particle_accelerator/control_box/tgui_status(mob/user)
	if(is_interactive(user))
		return ..()
	return STATUS_CLOSE

/obj/machinery/particle_accelerator/control_box/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ParticleAccelerator", name)
		ui.open()

/obj/machinery/particle_accelerator/control_box/tgui_data(mob/user)
	var/list/data = list()
	data["assembled"] = assembled
	data["power"] = active
	data["strength"] = strength
	return data

/obj/machinery/particle_accelerator/control_box/tgui_act(action, params)
	if(..())
		return

	switch(action)
		if("power")
			if(wires.is_cut(WIRE_POWER))
				return
			toggle_power()
			. = TRUE
		if("scan")
			part_scan()
			. = TRUE
		if("add_strength")
			if(wires.is_cut(WIRE_PARTICLE_STRENGTH))
				return
			add_strength()
			. = TRUE
		if("remove_strength")
			if(wires.is_cut(WIRE_PARTICLE_STRENGTH))
				return
			remove_strength()
			. = TRUE

	update_icon()
