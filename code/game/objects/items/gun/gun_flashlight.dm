//Flashlight handlers
/obj/item/gun/item_ctrl_click(mob/user)
	if(can_flashlight && ishuman(user) && loc == user && !user.incapacitated(INCAPACITATION_ALL))
		toggle_flashlight()
	else
		return ..()

/obj/item/gun/proc/toggle_flashlight()
	if(gun_light)
		set_light(0)
		gun_light = FALSE
	else
		set_light(light_brightness)
		gun_light = TRUE

	playsound(src, 'sound/machines/button.ogg', 25)
	update_icon()
