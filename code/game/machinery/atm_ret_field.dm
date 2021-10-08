/obj/machinery/atmospheric_field_generator
	name = "atmospheric retention field generator"
	desc = "A floor-mounted piece of equipment that generates an atmosphere-retaining energy field when powered and activated.  Linked to environmental alarm systems and will automatically activate when hazardous conditions are detected.<br><br>Note: prolonged immersion in active atmospheric retention fields may have negative long-term health consequences."
	icon = 'icons/obj/atm_fieldgen.dmi'
	icon_state = "arfg_off"
	anchored = TRUE
	opacity = 0
	density = 0 //we can be walked over
	power_channel = ENVIRON	//so they shut off last
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 3500
	var/ispowered = 1
	var/isactive = 0
	var/list/areas_added
	var/field_type = /obj/structure/atmospheric_retention_field

/obj/machinery/atmospheric_field_generator/impassable
	desc = "An older model of ARF-G that generates an impassable retention field. Works just as well as the modern variety, but is slightly more energy-efficient.<br><br>Note: prolonged immersion in active atmospheric retention fields may have negative long-term health consequences."
	active_power_usage = 3000
	field_type = /obj/structure/atmospheric_retention_field/impassable

/obj/machinery/atmospheric_field_generator/power_change()
	var/oldstat
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
	if(stat != oldstat && isactive && (stat & NOPOWER))
		ispowered = 0
		disable_field()
		update_icon()

/obj/machinery/atmospheric_field_generator/emp_act()
	disable_field()
	. = ..()

//for now, do nothing, we'll fix this up later
/obj/machinery/atmospheric_field/generator/ex_act()
	return

/obj/machinery/atmospheric_field_generator/proc/generate_field()
	if(!ispowered || isactive) //if it's not powered or it's already on, don't do anything
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
	plane = TURF_PLANE
	layer = ABOVE_MOB_LAYER
	can_atmos_pass = ATMOS_PASS_NO

	light_range = 3
	light_power = 1
	light_color = "#FFFFFF"
	light_on = TRUE

/obj/structure/atmospheric_retention_field/Initialize()
	. = ..()	
	update_nearby_tiles() //Force ZAS update

/obj/structure/atmospheric_retention_field/Destroy()
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