/obj/machinery/atmospheric_field_generator
	name = "atmospheric retention field generator"
	desc = "A floor-mounted piece of equipment that generates an atmosphere-retaining energy field when powered and activated. Linked to environmental alarm systems and will automatically activate when hazardous conditions are detected.<br><br>Note: prolonged immersion in active atmospheric retention fields may have negative long-term health consequences."
	icon = 'icons/obj/atm_fieldgen.dmi'
	icon_state = "arfg_off"
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	power_channel = ENVIRON	//so they shut off last
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2500
	var/ispowered = TRUE
	var/isactive = FALSE
	var/wasactive = FALSE		//controls automatic reboot after power-loss
	var/alwaysactive = FALSE	//for a special subtype
	
	//how long it takes us to reboot if we're shut down by an EMP
	var/reboot_delay_min = 50
	var/reboot_delay_max = 75
	
	var/hatch_open = FALSE
	var/wires_intact = TRUE
	var/list/areas_added
	var/field_type = /obj/structure/atmospheric_retention_field
	circuit = /obj/item/weapon/circuitboard/arf_generator

/obj/machinery/atmospheric_field_generator/impassable
	desc = "An older model of ARF-G that generates an impassable retention field. Works just as well as the modern variety, but is slightly more energy-efficient.<br><br>Note: prolonged immersion in active atmospheric retention fields may have negative long-term health consequences."
	active_power_usage = 2000
	field_type = /obj/structure/atmospheric_retention_field/impassable

/obj/machinery/atmospheric_field_generator/perma
	name = "static atmospheric retention field generator"
	desc = "A floor-mounted piece of equipment that generates an atmosphere-retaining energy field when powered and activated. This model is designed to always be active, though the field will still drop from loss of power or electromagnetic interference.<br><br>Note: prolonged immersion in active atmospheric retention fields may have negative long-term health consequences."
	alwaysactive = TRUE
	active_power_usage = 2000

/obj/machinery/atmospheric_field_generator/perma/impassable
	active_power_usage = 1500
	field_type = /obj/structure/atmospheric_retention_field/impassable

/obj/machinery/atmospheric_field_generator/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_crowbar() && isactive)
		if(!src) return
		to_chat(user, "<span class='warning'>You can't open the ARF-G whilst it's running!</span>")
		return
	if(W.is_crowbar() && !isactive)
		if(!src) return
		to_chat(user, "<span class='notice'>You [hatch_open? "close" : "open"] \the [src]'s access hatch.</span>")
		hatch_open = !hatch_open
		update_icon()
		if(alwaysactive && wires_intact)
			generate_field()
		return
	if(hatch_open && W.is_multitool())
		if(!src) return
		to_chat(user, "<span class='notice'>You toggle \the [src]'s activation behavior to [alwaysactive? "emergency" : "always-on"].</span>")
		alwaysactive = !alwaysactive
		update_icon()
		return
	if(hatch_open && W.is_wirecutter())
		if(!src) return
		to_chat(user, "<span class='warning'>You [wires_intact? "cut" : "mend"] \the [src]'s wires!</span>")
		wires_intact = !wires_intact
		update_icon()
		return
	if(hatch_open && istype(W,/obj/item/weapon/weldingtool))
		if(!src) return
		var/obj/item/weapon/weldingtool/WT = W
		if(!WT.isOn()) return
		if(WT.get_fuel() < 5) // uses up 5 fuel.
			to_chat(user, "<span class='warning'>You need more fuel to complete this task.</span>")
			return
		user.visible_message("[user] starts to disassemble \the [src].", "You start to disassemble \the [src].")
		playsound(src, WT.usesound, 50, 1)
		if(do_after(user,15 * W.toolspeed))
			if(!src || !user || !WT.remove_fuel(5, user)) return
			to_chat(user, "<span class='notice'>You fully disassemble \the [src]. There were no salvageable parts.</span>")
			qdel(src)
		return

/obj/machinery/atmospheric_field_generator/perma/Initialize()
	generate_field()

/obj/machinery/atmospheric_field_generator/update_icon()
	if(stat & BROKEN)
		icon_state = "arfg_broken"
	else if(hatch_open && wires_intact)
		icon_state = "arfg_open_wires"
	else if(hatch_open && !wires_intact)
		icon_state = "arfg_open_wirescut"
	else if(isactive)
		icon_state = "arfg_on"
	else
		icon_state = "arfg_off"

/obj/machinery/atmospheric_field_generator/power_change()
	var/oldstat
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
		if(alwaysactive || wasactive)	//reboot our field if we were on or are supposed to be always-on
			generate_field()
	if(stat != oldstat && isactive && (stat & NOPOWER))
		ispowered = 0
		disable_field()
		update_icon()

/obj/machinery/atmospheric_field_generator/emp_act()
	. = ..()
	disable_field() //shutting dowwwwwwn
	if(alwaysactive || wasactive) //reboot after a short delay if we were online before
		spawn(rand(reboot_delay_min,reboot_delay_max))
			generate_field()

/obj/machinery/atmospheric_field_generator/ex_act(severity)
	switch(severity)
		if(1)
			disable_field()
			qdel(src)
			return
		if(2)
			stat |= BROKEN
			update_icon()
			src.visible_message("The ARF-G cracks and shatters!","You hear an uncomfortable metallic crunch.")
			disable_field()
		if(3)
			emp_act()
	return

/obj/machinery/atmospheric_field_generator/proc/generate_field()
	if(!ispowered || hatch_open || !wires_intact || isactive) //if it's not powered, the hatch is open, the wires are busted, or it's already on, don't do anything
		return
	else
		isactive = 1
		icon_state = "arfg_on"
		new field_type (src.loc)
		src.visible_message("<span class='warning'>The ARF-G crackles to life!</span>","<span class='warning'>You hear an ARF-G coming online!</span>")
		update_use_power(USE_POWER_ACTIVE)
	return
	
/obj/machinery/atmospheric_field_generator/proc/disable_field()
	if(isactive)
		icon_state = "arfg_off"
		for(var/obj/structure/atmospheric_retention_field/F in loc)
			qdel(F)
		src.visible_message("The ARF-G shuts down with a low hum.","You hear an ARF-G powering down.")
		update_use_power(USE_POWER_IDLE)
		isactive = 0
	return
	
/obj/machinery/atmospheric_field_generator/Initialize()
	. = ..()
	//Delete ourselves if we find extra mapped in arfgs
	for(var/obj/machinery/atmospheric_field_generator/F in loc)
		if(F != src)
			log_debug("Duplicate ARFGS at [x],[y],[z]")
			return INITIALIZE_HINT_QDEL
	
	var/area/A = get_area(src)
	ASSERT(istype(A))

	LAZYADD(A.all_arfgs, src)
	areas_added = list(A)

	for(var/direction in cardinal)
		A = get_area(get_step(src,direction))
		if(istype(A) && !(A in areas_added))
			LAZYADD(A.all_arfgs, src)
			areas_added += A

/obj/structure/atmospheric_retention_field
	name = "atmospheric retention field"
	desc = "A shimmering forcefield that keeps the good air inside and the bad air outside. This field has been modulated so that it doesn't impede movement or projectiles.<br><br>Note: prolonged immersion in active atmospheric retention fields may have negative long-term health consequences."
	icon = 'icons/obj/atm_fieldgen.dmi'
	icon_state = "arfg_field"
	anchored = TRUE
	density = FALSE
	opacity = 0
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	//mouse_opacity = 0
	can_atmos_pass = ATMOS_PASS_NO
	var/basestate = "arfg_field"

	light_range = 3
	light_power = 1
	light_color = "#FFFFFF"
	light_on = TRUE

/obj/structure/atmospheric_retention_field/update_icon()
	cut_overlays() //overlays.Cut()
	var/list/dirs = list()
	for(var/obj/structure/atmospheric_retention_field/F in orange(src,1))
		dirs += get_dir(src, F)

	var/list/connections = dirs_to_corner_states(dirs)

	icon_state = ""
	for(var/i = 1 to 4)
		var/image/I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
		add_overlay(I)
	
	return

/obj/structure/atmospheric_retention_field/Initialize()
	. = ..()	
	update_nearby_tiles() //Force ZAS update
	update_connections(1)
	update_icon()

/obj/structure/atmospheric_retention_field/Destroy()
	for(var/obj/structure/atmospheric_retention_field/W in orange(1, src.loc))
		W.update_connections(1)
	update_nearby_tiles() //Force ZAS update
	. = ..()

/obj/structure/atmospheric_retention_field/attack_hand(mob/user as mob)
	if(density)
		visible_message("You touch the retention field, and it crackles faintly. Tingly!")
	else
		visible_message("You try to touch the retention field, but pass through it like it isn't even there.")

/obj/structure/atmospheric_retention_field/ex_act()
	return

/obj/structure/atmospheric_retention_field/impassable
	desc = "A shimmering forcefield that keeps the good air inside and the bad air outside. It seems fairly solid, almost like it's made out of some kind of hardened light.<br><br>Note: prolonged immersion in active atmospheric retention fields may have negative long-term health consequences."
	icon = 'icons/obj/atm_fieldgen.dmi'
	icon_state = "arfg_field"
	density = TRUE

/obj/machinery/atmospheric_field_generator/perma/underdoors
	field_type = /obj/structure/atmospheric_retention_field/underdoors

/obj/structure/atmospheric_retention_field/underdoors
	plane = OBJ_PLANE
	layer = UNDER_JUNK_LAYER
