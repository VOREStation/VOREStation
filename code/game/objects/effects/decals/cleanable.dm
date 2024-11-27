/*
USAGE NOTE
For decals, the var Persistent = 'has already been saved', and is primarily used to prevent duplicate savings of generic filth (filth.dm).
This also means 'TRUE' can be used to define a decal as "Do not save at all, even as a generic replacement." if a dirt decal is considered 'too common' to save.
generic_filth = TRUE means when the decal is saved, it will be switched out for a generic green 'filth' decal.
*/

/obj/effect/decal/cleanable
	plane = DIRTY_PLANE
	layer = DIRTY_LAYER
	var/persistent = FALSE
	var/generic_filth = FALSE
	var/age = 0
	var/list/random_icon_states = list()

/obj/effect/decal/cleanable/Initialize(var/mapload, var/_age)
	if(!isnull(_age))
		age = _age
	if(random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	if(!mapload || !CONFIG_GET(flag/persistence_ignore_mapload))
		SSpersistence.track_value(src, /datum/persistent/filth)
	. = ..()
	update_icon()

/obj/effect/decal/cleanable/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/filth)
	. = ..()

/obj/effect/decal/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/decal/cleanable/New()
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	..()


/obj/effect/decal/cleanable/update_icon()
	// Overrides should not inheret from this, and instead replace it entirely to match this in some form.
	// add_janitor_hud_overlay() does not pre-cut overlays, so cut_overlays() must be called first.
	// This is so it may be used with update_icon() overrides that use overlays, while adding the janitor overlay at the end.
	cut_overlays()
	add_janitor_hud_overlay()


/obj/effect/decal/cleanable/proc/add_janitor_hud_overlay()
	// This was original a seperate object that followed the grime, it got stuck in everything you can imagine!
	// It also likely doubled the memory use of every cleanable decal on station...
	var/image/hud = image('icons/mob/hud.dmi', src, "janhud[rand(1,9)]")
	hud.appearance_flags = (RESET_COLOR|PIXEL_SCALE|KEEP_APART)
	hud.plane = PLANE_JANHUD
	hud.layer = BELOW_MOB_LAYER
	hud.mouse_opacity = 0
	//HUD VARIANT: Allows the hud to show up with it's normal alpha, even if the 'dirty thing' it's attached to has a low alpha (ex: dirt). If you want to disable it, simply comment out the lines between the 'HUD VARIANT' tag!
	hud.appearance_flags = RESET_ALPHA
	hud.alpha = 255
	//HUD VARIANT end
	add_overlay(hud)
