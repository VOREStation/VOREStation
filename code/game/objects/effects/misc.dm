//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

// Shown really briefly when attacking with axes.
/obj/effect/temporary_effect/cleave_attack
	name = "cleaving attack"
	desc = "Something swinging really wide."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "cleave"
	layer = 6
	time_to_die = 6
	alpha = 140
	invisibility = 0
	mouse_opacity = 0
	new_light_range = 0
	new_light_power = 0
	pixel_x = -32
	pixel_y = -32

/obj/effect/temporary_effect/cleave_attack/initialize() // Makes the slash fade smoothly. When completely transparent it should qdel itself.
	animate(src, alpha = 0, time = time_to_die - 1)
