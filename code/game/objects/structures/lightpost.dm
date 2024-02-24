/obj/structure/lightpost
	name = "lightpost"
	desc = "A homely lightpost."
	icon = 'icons/obj/32x64.dmi'
	icon_state = "lightpost"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	opacity = FALSE

	var/lit = TRUE // If true, will have a glowing overlay and lighting.
	var/festive = FALSE // If true, adds a festive bow overlay to it.

/obj/structure/lightpost/Initialize()
	update_icon()
	return ..()

/obj/structure/lightpost/update_icon()
	cut_overlays()

	if(lit)
		set_light(5, 1, "#E9E4AF")
		var/image/glow = image(icon_state = "[icon_state]-glow")
		glow.plane = PLANE_LIGHTING_ABOVE
		add_overlay(glow)
	else
		set_light(0)

	if(festive)
		var/image/bow = image(icon_state = "[icon_state]-festive")
		add_overlay(bow)

/obj/structure/lightpost/unlit
	lit = FALSE

/obj/structure/lightpost/festive
	desc = "A homely lightpost adorned with festive decor."
	festive = TRUE

/obj/structure/lightpost/festive/unlit
	lit = FALSE