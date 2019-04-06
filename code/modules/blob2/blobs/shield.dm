/obj/structure/blob/shield
	name = "thick blob"
	base_name = "thick"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_shield"
	desc = "A solid wall of slightly twitching tendrils."
	max_integrity = 100
	point_return = 4
	can_atmos_pass = ATMOS_PASS_NO

/obj/structure/blob/shield/core
	point_return = 0

/obj/structure/blob/shield/update_icon()
	..()
	if(integrity <= 75)
		icon_state = "blob_shield_damaged"
		desc = "A wall of twitching tendrils."
	else
		icon_state = initial(icon_state)
		desc = initial(desc)

	if(overmind)
		name = "[base_name] [overmind.blob_type.name]"
	else
		name = "inert [base_name] blob"