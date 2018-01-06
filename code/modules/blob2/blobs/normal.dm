/obj/structure/blob/normal
	name = "normal blob"
	base_name = "blob"
	icon_state = "blob"
	light_range = 0
	integrity = 21 //doesn't start at full health
	max_integrity = 25
	health_regen = 1

/obj/structure/blob/normal/update_icon()
	..()
	if(integrity <= 15)
		icon_state = "blob_damaged"
		desc = "A thin lattice of slightly twitching tendrils."
	else
		icon_state = "blob"
		desc = "A thick wall of writhing tendrils."

	if(overmind)
		name = "[overmind.blob_type.name]"
	else
		name = "inert [base_name]"