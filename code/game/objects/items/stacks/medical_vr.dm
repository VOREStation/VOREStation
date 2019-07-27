/obj/item/stack/medical/advanced
	icon = 'icons/obj/stacks_vr.dmi'

/obj/item/stack/medical/advanced/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/medical/advanced/update_icon()
	switch(amount)
		if(1 to 2)
			icon_state = initial(icon_state)
		if(3 to 4)
			icon_state = "[initial(icon_state)]_4"
		if(5 to 6)
			icon_state = "[initial(icon_state)]_6"
		if(7 to 8)
			icon_state = "[initial(icon_state)]_8"
		if(9)
			icon_state = "[initial(icon_state)]_9"
		else
			icon_state = "[initial(icon_state)]_10"