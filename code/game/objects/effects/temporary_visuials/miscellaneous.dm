/obj/effect/temp_visual/decoy
	desc = "It's a decoy!"
	duration = 15

/obj/effect/temp_visual/decoy/initialize(mapload, atom/mimiced_atom, var/customappearance)
	. = ..()
	alpha = initial(alpha)
	if(mimiced_atom)
		name = mimiced_atom.name
		appearance = mimiced_atom.appearance
		set_dir(mimiced_atom.dir)
		mouse_opacity = 0
	if(customappearance)
		appearance = customappearance

/obj/effect/temp_visual/decoy/fading/initialize(mapload, atom/mimiced_atom)
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/decoy/fading/fivesecond
	duration = 50

/obj/effect/temp_visual/small_smoke
	icon_state = "smoke"
	duration = 50