/obj/item/modular_computer/laptop
	anchored = TRUE
	name = "laptop computer"
	desc = "A portable computer."
	hardware_flag = PROGRAM_LAPTOP
	icon_state_unpowered = "laptop-open"
	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "laptop-open"
	icon_state_screensaver = "standby"
	base_idle_power_usage = 25
	base_active_power_usage = 200
	max_hardware_size = 2
	light_strength = 3
	max_damage = 200
	broken_damage = 100
	w_class = ITEMSIZE_NORMAL
	var/icon_state_closed = "laptop-closed"

/obj/item/modular_computer/laptop/AltClick(mob/living/human/user)
	// We need to be close to it to open it
	if((!in_range(src, user)) || user.stat || user.restrained())
		return
	// Prevents carrying of open laptops inhand.
	// While they work inhand, i feel it'd make tablets lose some of their high-mobility advantage they have over laptops now.
	if(!istype(loc, /turf/))
		to_chat(usr, "\The [src] has to be on a stable surface first!")
		return
	//VOREStation Addition Begin
	var/supported = FALSE
	for(var/obj/structure/table/S in loc)
		supported = TRUE
	if(!supported && !anchored)
		to_chat(usr, "You will need a better supporting surface before opening \the [src]!")
		return
	//VOREStation Addition End
	anchored = !anchored
	screen_on = anchored
	update_icon()

/obj/item/modular_computer/laptop/update_icon()
	if(anchored)
		..()
	else
		cut_overlays()
		set_light(0)		// No glow from closed laptops
		icon_state = icon_state_closed

/obj/item/modular_computer/laptop/preset
	anchored = FALSE
	screen_on = FALSE
