/obj/item/fuel_assembly
	name = "fuel rod assembly"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_assembly"

	var/material_name

	var/percent_depleted = 1
	var/list/rod_quantities = list()
	var/fuel_type = MAT_COMPOSITE
	var/fuel_colour
	var/radioactivity = 0
	var/const/initial_amount = 3000000
	var/last_event = 0
	/// Mutex to prevent infinite recursion when propagating radiation pulses
	var/active = null

/obj/item/fuel_assembly/process()
	radiate()

/obj/item/fuel_assembly/proc/radiate()
	SIGNAL_HANDLER
	if(active)
		return
	if(world.time <= last_event + 1.5 SECONDS)
		return
	active = TRUE
	radiation_pulse(
		src,
		max_range = (radioactivity * 0.5),
		threshold = RAD_HEAVY_INSULATION,
		chance = DEFAULT_RADIATION_CHANCE,
		strength = radioactivity * 0.5
	)
	last_event = world.time
	active = FALSE

/obj/item/fuel_assembly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/item/fuel_assembly/Initialize(mapload, var/_material, var/_colour)
	. = ..()
	fuel_type = _material
	fuel_colour = _colour
	var/datum/material/material = get_material_by_name(fuel_type)
	if(istype(material))
		name = "[material.use_name] fuel rod assembly"
		desc = "A fuel rod for a fusion reactor. This one is made from [material.use_name]."
		fuel_colour = material.icon_colour
		fuel_type = material.use_name
		if(material.radioactivity)
			radioactivity = material.radioactivity
			desc += " It is warm to the touch."
			START_PROCESSING(SSobj, src)
		if(material.luminescence)
			set_light(material.luminescence, material.luminescence, material.icon_colour)
	else
		name = "[fuel_type] fuel rod assembly"
		desc = "A fuel rod for a fusion reactor. This one is made from [fuel_type]."

	icon_state = "blank"
	var/image/I = image(icon, "fuel_assembly")
	I.color = fuel_colour
	add_overlay(list(I, image(icon, "fuel_assembly_bracket")))
	rod_quantities[fuel_type] = initial_amount

// Mapper shorthand.
/obj/item/fuel_assembly/deuterium/Initialize(mapload)
	. = ..(mapload, MAT_DEUTERIUM)

/obj/item/fuel_assembly/tritium/Initialize(mapload)
	. = ..(mapload, MAT_TRITIUM)

/obj/item/fuel_assembly/phoron/Initialize(mapload)
	. = ..(mapload, MAT_PHORON)

/obj/item/fuel_assembly/supermatter/Initialize(mapload)
	. = ..(mapload, MAT_SUPERMATTER)
