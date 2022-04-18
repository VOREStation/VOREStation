/obj/item/fuel_assembly
	name = "fuel rod assembly"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_assembly"

	var/material_name

	var/percent_depleted = 1
	var/list/rod_quantities = list()
	var/fuel_type = "composite"
	var/fuel_colour
	var/radioactivity = 0
	var/const/initial_amount = 3000000

<<<<<<< HEAD
/obj/item/weapon/fuel_assembly/New(var/newloc, var/_material, var/_colour)
=======
/obj/item/fuel_assembly/Initialize(var/ml, var/_material, var/_colour)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	fuel_type = _material
	fuel_colour = _colour
	..(newloc)

/obj/item/fuel_assembly/Initialize()
	. = ..()
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
<<<<<<< HEAD
/obj/item/weapon/fuel_assembly/deuterium/New(var/newloc)
	..(newloc, "deuterium")

/obj/item/weapon/fuel_assembly/tritium/New(var/newloc)
	..(newloc, "tritium")

/obj/item/weapon/fuel_assembly/phoron/New(var/newloc)
	..(newloc, "phoron")

/obj/item/weapon/fuel_assembly/supermatter/New(var/newloc)
	..(newloc, "supermatter")
=======
/obj/item/fuel_assembly/deuterium/Initialize(var/ml)
	. = ..(ml, "deuterium")

/obj/item/fuel_assembly/tritium/Initialize(var/ml)
	. = ..(ml, "tritium")

/obj/item/fuel_assembly/phoron/Initialize(var/ml)
	. = ..(ml, MAT_PHORON)

/obj/item/fuel_assembly/supermatter/Initialize(var/ml)
	. = ..(ml, "supermatter")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
