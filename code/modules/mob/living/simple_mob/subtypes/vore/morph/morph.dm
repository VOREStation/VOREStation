#define MORPH_COOLDOWN 50

/mob/living/simple_mob/vore/hostile/morph
	name = "morph"
	real_name = "morph"
	desc = "A revolting, pulsating pile of flesh."
	tt_desc = "morphus shapeshiftus"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "morph"
	icon_living = "morph"
	icon_dead = "morph_dead"
	movement_cooldown = 1
	status_flags = CANPUSH
	pass_flags = PASSTABLE
	mob_bump_flag = SLIME

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	minbodytemp = 0
	maxHealth = 250
	health = 250
	taser_kill = FALSE
	melee_damage_lower = 15
	melee_damage_upper = 20
	see_in_dark = 8

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"
	attacktext = "glomped"
	attack_sound = 'sound/effects/blobattack.ogg'

	meat_amount = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	showvoreprefs = 0
	vore_active = 1

	var/morphed = FALSE
	var/tooltip = TRUE
	var/melee_damage_disguised = 0
	var/eat_while_disguised = FALSE
	var/atom/movable/form = null
	var/morph_time = 0
	var/our_size_multiplier = 1
	var/static/list/blacklist_typecache = typecacheof(list(
	/obj/screen,
	/obj/singularity,
	/mob/living/simple_mob/vore/hostile/morph,
	/obj/effect))

/mob/living/simple_mob/vore/hostile/morph/Initialize()
	verbs += /mob/living/proc/ventcrawl
	return ..()

/mob/living/simple_mob/vore/hostile/morph/Destroy()
	form = null
	return ..()

/mob/living/simple_mob/vore/hostile/morph/proc/allowed(atom/movable/A)
	return !is_type_in_typecache(A, blacklist_typecache) && (isobj(A) || ismob(A))

/mob/living/simple_mob/vore/hostile/morph/examine(mob/user)
	if(morphed)
		. = form.examine(user)
		if(get_dist(user, src) <= 3)
			. += "<span class='warning'>[form] doesn't look quite right...</span>"
	else
		. = ..()

/mob/living/simple_mob/vore/hostile/morph/ShiftClickOn(atom/movable/A)
	if(Adjacent(A))
		if(morph_time <= world.time && !stat)
			if(A == src)
				restore()
				return
			if(istype(A) && allowed(A))
				assume(A)
		else
			to_chat(src, "<span class='warning'>Your chameleon skin is still repairing itself!</span>")
	else
		..()

/mob/living/simple_mob/vore/hostile/morph/proc/assume(atom/movable/target)
	var/mob/living/carbon/human/humantarget = target
	if(istype(humantarget) && humantarget.resleeve_lock && ckey != humantarget.resleeve_lock)
		to_chat(src, "<span class='warning'>[target] cannot be impersonated!</span>")
		return
	if(morphed)
		to_chat(src, "<span class='warning'>You must restore to your original form first!</span>")
		return
	morphed = TRUE
	form = target

	visible_message("<span class='warning'>[src] suddenly twists and changes shape, becoming a copy of [target]!</span>")
	name = target.name
	desc = target.desc
	icon = target.icon
	icon_state = target.icon_state
	alpha = max(target.alpha, 150)
	copy_overlays(target, TRUE)
	our_size_multiplier = size_multiplier
	
	pixel_x = initial(target.pixel_x)
	pixel_y = initial(target.pixel_y)

	density = target.density

	if(isobj(target))
		size_multiplier = 1
		icon_scale_x = target.icon_scale_x
		icon_scale_y = target.icon_scale_y
		update_transform()
	
	else if(ismob(target))
		var/mob/living/M = target
		resize(M.size_multiplier, ignore_prefs = TRUE)

	//Morphed is weaker
	melee_damage_lower = melee_damage_disguised
	melee_damage_upper = melee_damage_disguised
	movement_cooldown = 5

	morph_time = world.time + MORPH_COOLDOWN

	return

/mob/living/simple_mob/vore/hostile/morph/proc/restore(var/silent = FALSE)
	if(!morphed)
		to_chat(src, "<span class='warning'>You're already in your normal form!</span>")
		return
	morphed = FALSE
	
	if(!silent)
		visible_message("<span class='warning'>[src] suddenly collapses in on itself, dissolving into a pile of green flesh!</span>")
	
	form = null
	name = initial(name)
	desc = initial(desc)

	icon = initial(icon)
	icon_state = initial(icon_state)

	alpha = initial(alpha)
	color = initial(color)
	plane = initial(plane)
	layer = initial(layer)

	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	icon_scale_x = initial(icon_scale_x)
	icon_scale_y = initial(icon_scale_y)

	density = initial(density)

	cut_overlays(TRUE) //ALL of zem
	
	maptext = null

	size_multiplier = our_size_multiplier
	resize(size_multiplier, ignore_prefs = TRUE)

	//Baseline stats
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	movement_cooldown = initial(movement_cooldown)

	morph_time = world.time + MORPH_COOLDOWN

/mob/living/simple_mob/vore/hostile/morph/death(gibbed)
	if(morphed)
		visible_message("<span class='warning'>[src] twists and dissolves into a pile of green flesh!</span>")
		restore(TRUE)
	..()

/mob/living/simple_mob/vore/hostile/morph/will_show_tooltip()
	return (!morphed)

/mob/living/simple_mob/vore/hostile/morph/resize(var/new_size, var/animate = TRUE, var/uncapped = FALSE, var/ignore_prefs = FALSE)
	if(morphed && !ismob(form))
		return
	return ..()

/mob/living/simple_mob/vore/hostile/morph/update_icon()
	if(morphed)
		return
	return ..()


/mob/living/simple_mob/vore/hostile/morph/update_icons()
	if(morphed)
		return
	return ..()

/mob/living/simple_mob/vore/hostile/morph/update_transform()
	if(morphed)
		var/matrix/M = matrix()
		M.Scale(icon_scale_x, icon_scale_y)
		M.Turn(icon_rotation)
		src.transform = M
	else
		..()
