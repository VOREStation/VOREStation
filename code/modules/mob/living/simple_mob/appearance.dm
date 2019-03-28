/mob/living/simple_mob/update_icon()
	. = ..()
	cut_overlays()
//	var/mutable_appearance/ma = new(src)
//	ma.layer = layer
//	ma.plane = plane

	add_overlay(modifier_overlay)

	if(!icon_living) // Prevent the mob from turning invisible if icon_living is null.
		icon_living = initial(icon_state)

	//Awake and normal
	if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED) ))
		icon_state = icon_living

	//Dead
	else if(stat >= DEAD)
		icon_state = icon_dead

	//Resting or KO'd
	else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest)
		icon_state = icon_rest

	//Backup
	else
		icon_state = initial(icon_state)

	if(has_hands)
		if(r_hand_sprite)
			add_overlay(r_hand_sprite)
		if(l_hand_sprite)
			add_overlay(l_hand_sprite)

	if(has_eye_glow)
		if(icon_state != icon_living)
			remove_eyes()
		else
			add_eyes()

//	appearance = ma


// If your simple mob's update_icon() call calls overlays.Cut(), this needs to be called after this, or manually apply modifier_overly to overlays.
/mob/living/simple_mob/update_modifier_visuals()
	var/image/effects = null
	if(modifier_overlay)
		cut_overlay(modifier_overlay)
		modifier_overlay.cut_overlays()
		effects = modifier_overlay
	else
		effects = new()

	for(var/datum/modifier/M in modifiers)
		if(M.mob_overlay_state)
			var/image/I = image("icon" = 'icons/mob/modifier_effects.dmi', "icon_state" = M.mob_overlay_state)
			I.appearance_flags = RESET_COLOR // So colored mobs don't affect the overlay.
			effects.add_overlay(I)

	modifier_overlay = effects
	add_overlay(modifier_overlay)


/mob/living/simple_mob/proc/add_eyes()
	if(!eye_layer)
		eye_layer = image(icon, "[icon_state]-eyes")
		eye_layer.plane = PLANE_LIGHTING_ABOVE

	add_overlay(eye_layer)

/mob/living/simple_mob/proc/remove_eyes()
	cut_overlay(eye_layer)


/mob/living/simple_mob/gib()
	..(icon_gib,1,icon) // we need to specify where the gib animation is stored