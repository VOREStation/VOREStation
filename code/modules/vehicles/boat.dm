/obj/vehicle/boat
	name = "boat"
	desc = "It's a wooden boat. Looks like it'll hold two people. Oars not included."
	icon = 'icons/obj/vehicles_36x32.dmi'
	icon_state = "boat"
	health = 100
	maxhealth = 100
	charge_use = 0 // Boats use oars.
	pixel_x = -2
	move_delay = 3 // Rather slow, but still faster than swimming, and won't get you wet.
	max_buckled_mobs = 2
	anchored = FALSE
	var/material/material = null
	var/riding_datum_type = /datum/riding/boat/small

/obj/vehicle/boat/sifwood/New(newloc, material_name)
	..(newloc, MAT_SIFWOOD)

/obj/vehicle/boat/dragon
	name = "dragon boat"
	desc = "It's a large wooden boat, carved to have a nordic-looking dragon on the front. Looks like it'll hold five people. Oars not included."
	icon = 'icons/obj/64x32.dmi'
	icon_state = "dragon_boat"
	health = 250
	maxhealth = 250
	pixel_x = -16
	max_buckled_mobs = 5
	riding_datum_type = /datum/riding/boat/big

/obj/vehicle/boat/dragon/New(newloc, material_name)
	..(newloc, material_name)
	var/image/I = image(icon, src, "dragon_boat_underlay", BELOW_MOB_LAYER)
	underlays += I

/obj/vehicle/boat/dragon/sifwood/New(newloc, material_name)
	..(newloc, MAT_SIFWOOD)

// Oars, which must be held inhand while in a boat to move it.
/obj/item/weapon/oar
	name = "oar"
	icon = 'icons/obj/vehicles.dmi'
	desc = "Used to provide propulsion to a boat."
	icon_state = "oar"
	item_state = "oar"
	force = 12
	var/material/material = null

/obj/item/weapon/oar/sifwood/New(newloc, material_name)
	..(newloc, MAT_SIFWOOD)

/obj/item/weapon/oar/New(newloc, material_name)
	..(newloc)
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	color = material.icon_colour

/obj/vehicle/boat/New(newloc, material_name)
	..(newloc)
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	color = material.icon_colour
	riding_datum = new riding_datum_type(src)

// Boarding.
/obj/vehicle/boat/MouseDrop_T(var/atom/movable/C, mob/user)
	if(ismob(C))
		user_buckle_mob(C, user)
	else
		..(C, user)

/obj/vehicle/boat/load(mob/living/L, mob/living/user)
	if(!istype(L)) // Only mobs on boats.
		return FALSE
	..(L, user)
