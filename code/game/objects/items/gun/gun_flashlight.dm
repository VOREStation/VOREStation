//Flashlight handlers
/obj/item/gun_new/item_ctrl_click(mob/user)
	if(can_flashlight && ishuman(user) && loc == user && !user.incapacitated(INCAPACITATION_ALL))
		toggle_flashlight()
	else
		return ..()

/obj/item/gun_new/proc/toggle_flashlight()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(gun_light)
		set_light(0)
		gun_light = FALSE
	else
		set_light(light_brightness)
		gun_light = TRUE

	playsound(src, 'sound/machines/button.ogg', 25)
	update_icon()
