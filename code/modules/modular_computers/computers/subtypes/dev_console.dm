/obj/item/modular_computer/console
	name = "console"
	desc = "A stationary computer."
	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_unpowered = "console"
	icon_state_screensaver = "standby"
	icon_state_menu = "menu"
	hardware_flag = PROGRAM_CONSOLE
	anchored = TRUE
	density = TRUE
	layer = 2.9
	base_idle_power_usage = 100
	base_active_power_usage = 500
	max_hardware_size = 3
	steel_sheet_cost = 20
	light_strength = 4
	max_damage = 300
	broken_damage = 150

/obj/item/modular_computer/console/update_icon()
	. = ..()
	// Connecty
	if(initial(icon_state) == "console")
		var/append_string = ""
		var/left = turn(dir, -90)
		var/right = turn(dir, 90)
		var/turf/L = get_step(src, left)
		var/turf/R = get_step(src, right)
		var/obj/item/modular_computer/console/LC = locate() in L
		var/obj/item/modular_computer/console/RC = locate() in R
		if(LC && LC.dir == dir && initial(LC.icon_state) == "console")
			append_string += "_L"
		if(RC && RC.dir == dir && initial(RC.icon_state) == "console")
			append_string += "_R"
		icon_state = "console[append_string]"
