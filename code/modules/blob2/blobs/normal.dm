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

/obj/structure/blob/normal/pulsed()
	..()

	if(prob(30))
		adjust_scale((rand(10, 13) / 10), (rand(10, 13) / 10))

	else
		adjust_scale(1)
