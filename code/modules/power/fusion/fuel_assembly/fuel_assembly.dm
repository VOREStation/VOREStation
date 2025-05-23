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

/obj/item/fuel_assembly/process()
	if(!radioactivity)
		return PROCESS_KILL

	if(istype(loc, /turf))
		SSradiation.radiate(src, max(1,CEILING(radioactivity/30, 1)))

/obj/item/fuel_assembly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

// Mapper shorthand.
/obj/item/fuel_assembly/deuterium/Initialize(mapload)
	. = ..(mapload, MAT_DEUTERIUM)

/obj/item/fuel_assembly/tritium/Initialize(mapload)
	. = ..(mapload, MAT_TRITIUM)

/obj/item/fuel_assembly/phoron/Initialize(mapload)
	. = ..(mapload, MAT_PHORON)

/obj/item/fuel_assembly/supermatter/Initialize(mapload)
	. = ..(mapload, MAT_SUPERMATTER)
