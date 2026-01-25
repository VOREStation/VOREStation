/obj/effect/temp_visual/decoy
	desc = "It's a decoy!"
	duration = 15

/obj/effect/temp_visual/decoy/Initialize(mapload, atom/mimiced_atom, var/customappearance)
	. = ..()
	alpha = initial(alpha)
	if(mimiced_atom)
		name = mimiced_atom.name
		appearance = mimiced_atom.appearance
		set_dir(mimiced_atom.dir)
		mouse_opacity = 0
	if(customappearance)
		appearance = customappearance

/obj/effect/temp_visual/decoy/fading/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/decoy/fading/fivesecond
	duration = 50

/obj/effect/temp_visual/small_smoke
	icon_state = "smoke"
	duration = 50

/obj/effect/temp_visual/glitch
	icon_state = "glitch"
	duration = 5

/obj/effect/temp_visual/confuse
	icon_state = "confuse"
	duration = 5

/obj/effect/temp_visual/pre_confuse
	icon_state = "pre_confuse"
	duration = 5

/obj/effect/temp_visual/impact_effect
	icon_state = "impact_bullet"
	plane = PLANE_LIGHTING_ABOVE // So they're visible even in a shootout in maint.
	duration = 5

/obj/effect/temp_visual/impact_effect/Initialize(mapload, obj/item/projectile/P, x, y)
	pixel_x = x
	pixel_y = y
	return ..()

/obj/effect/temp_visual/impact_effect/red_laser
	icon_state = "impact_laser"
	duration = 4

/obj/effect/temp_visual/impact_effect/red_laser/wall
	icon_state = "impact_laser_wall"
	duration = 10

/obj/effect/temp_visual/impact_effect/blue_laser
	icon_state = "impact_laser_blue"
	duration = 4

/obj/effect/temp_visual/impact_effect/green_laser
	icon_state = "impact_laser_green"
	duration = 4

/obj/effect/temp_visual/impact_effect/purple_laser
	icon_state = "impact_laser_purple"
	duration = 4

// Colors itself based on the projectile.
// Checks light_color and color.
/obj/effect/temp_visual/impact_effect/monochrome_laser
	icon_state = "impact_laser_monochrome"
	duration = 4

/obj/effect/temp_visual/impact_effect/monochrome_laser/Initialize(mapload, obj/item/projectile/P, x, y)
	if(P.light_color)
		color = P.light_color
	else if(P.color)
		color = P.color
	return ..()

/obj/effect/temp_visual/impact_effect/ion
	icon_state = "shieldsparkles"
	duration = 6

// VOREStation Add - Kinetic Accelerator/Medigun
/obj/effect/temp_visual/kinetic_blast
	name = "kinetic explosion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	layer = ABOVE_MOB_LAYER
	duration = 4

/obj/effect/temp_visual/explosion
	name = "explosion"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	pixel_x = -32
	pixel_y = -32
	duration = 8

/obj/effect/temp_visual/explosion/fast
	icon_state = "explosionfast"
	duration = 4

/obj/effect/temp_visual/heal
	name = "healing glow"
	icon_state = XENO_CHEM_HEAL
	duration = 15

/obj/effect/temp_visual/heal/Initialize(mapload)
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)
	. = ..()
// VOREStation Add End

/obj/effect/temp_visual/circle_wave
	icon = 'icons/effects/64x64.dmi'
	icon_state = "circle_wave"
	pixel_x = -16
	pixel_y = -16
	duration = 0.5 SECONDS
	color = COLOR_LIME
	var/max_alpha = 255
	var/amount_to_scale = 2

/obj/effect/temp_visual/circle_wave/Initialize(mapload)
	transform = matrix().Scale(0.1)
	animate(src, transform = matrix().Scale(amount_to_scale), time = duration, flags = ANIMATION_PARALLEL)
	animate(src, alpha = max_alpha, time = duration * 0.6, flags = ANIMATION_PARALLEL)
	animate(alpha = 0, time = duration * 0.4)
	apply_wibbly_filters(src)
	return ..()

/obj/effect/temp_visual/circle_wave/bioscrambler
	color = COLOR_LIME

/obj/effect/temp_visual/circle_wave/bioscrambler/light
	max_alpha = 128

/obj/effect/temp_visual/circle_wave/void_conduit
	color = COLOR_FULL_TONER_BLACK
	duration = 12 SECONDS
	amount_to_scale = 12

/obj/effect/temp_visual/circle_wave/star_blast
	color = COLOR_VOID_PURPLE
