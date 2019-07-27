/obj/item/stack/medical/advanced
	icon = 'icons/obj/stacks_vr.dmi'

/obj/item/stack/medical/advanced/New()
	..()
	update_icon()
	return

/obj/item/stack/medical/advanced/update_icon()
	if(amount <= 2)
		icon_state = initial(icon_state)
	else if (amount <= 4)
		icon_state = "[initial(icon_state)]_4"
	else if (amount <= 6)
		icon_state = "[initial(icon_state)]_6"
	else if (amount <= 8)
		icon_state = "[initial(icon_state)]_8"
	else if (amount <= 9)
		icon_state = "[initial(icon_state)]_9"
	else
		icon_state = "[initial(icon_state)]_10"