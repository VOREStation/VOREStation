#define MORPH_COOLDOWN 50

/mob/living/simple_mob/vore/morph
	name = "morph"
	real_name = "morph"
	desc = "A revolting, pulsating pile of flesh."
	tt_desc = "morphus shapeshiftus"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "new_morph"
	icon_living = "new_morph"
	icon_dead = "new_morph_dead"
	icon_rest = null
	color = "#658a62"
	movement_cooldown = -1
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
	maxHealth = 50
	health = 50
	taser_kill = FALSE
	melee_damage_lower = 15
	melee_damage_upper = 20
	see_in_dark = 8

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"
	attacktext = "glomped"
	attack_sound = 'sound/effects/blobattack.ogg'

	meat_amount = 0

	showvoreprefs = 0
	vore_active = 1
	vore_default_mode = DM_HOLD


	var/morphed = FALSE
	var/tooltip = TRUE
	var/melee_damage_disguised = 0
	var/eat_while_disguised = FALSE
	var/atom/movable/form = null
	var/morph_time = 0
	var/our_size_multiplier = 1
	var/original_ckey
	var/chosen_color
	var/static/list/blacklist_typecache = typecacheof(list(
	/obj/screen,
	/obj/singularity,
	/mob/living/simple_mob/vore/morph,
	/obj/effect))

/mob/living/simple_mob/vore/morph/Initialize()
	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/simple_mob/vore/morph/proc/take_over_prey)
	if(!istype(src, /mob/living/simple_mob/vore/morph/dominated_prey))
		add_verb(src, /mob/living/simple_mob/vore/morph/proc/morph_color)

	return ..()

/mob/living/simple_mob/vore/morph/Destroy()
	form = null
	return ..()

/mob/living/simple_mob/vore/morph/proc/allowed(atom/movable/A)
	return !is_type_in_typecache(A, blacklist_typecache) && (isobj(A) || ismob(A))

/mob/living/simple_mob/vore/morph/examine(mob/user)
	if(morphed)
		. = form.examine(user)
		if(get_dist(user, src) <= 3 && !resting)
			. += span_warning("[form] doesn't look quite right...")
	else
		. = ..()

/mob/living/simple_mob/vore/morph/ShiftClickOn(atom/movable/A)
	if(Adjacent(A))
		if(morph_time <= world.time && !stat)
			if(A == src)
				restore()
				return
			if(istype(A) && allowed(A))
				assume(A)
		else
			to_chat(src, span_warning("Your chameleon skin is still repairing itself!"))
	else
		..()

/mob/living/simple_mob/vore/morph/proc/assume(atom/movable/target)
	var/mob/living/carbon/human/humantarget = target
	if(istype(humantarget) && !humantarget.allow_mimicry)
		to_chat(src, span_warning("[target] cannot be impersonated!"))
		return
	if(morphed)
		to_chat(src, span_warning("You must restore to your original form first!"))
		return
	morphed = TRUE
	form = target

	visible_message(span_warning("[src] suddenly twists and changes shape, becoming a copy of [target]!"))
	color = null
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
	movement_cooldown = 1

	morph_time = world.time + MORPH_COOLDOWN

	return

/mob/living/simple_mob/vore/morph/proc/restore(var/silent = FALSE)
	if(!morphed)
		to_chat(src, span_warning("You're already in your normal form!"))
		return
	morphed = FALSE

	if(!silent)
		visible_message(span_warning("[src] suddenly collapses in on itself, dissolving into a pile of flesh!"))

	form = null
	name = initial(name)
	desc = initial(desc)

	icon = initial(icon)
	icon_state = initial(icon_state)

	alpha = initial(alpha)
	if(chosen_color)
		color = chosen_color
	else
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

/mob/living/simple_mob/vore/morph/death(gibbed)
	if(morphed)
		visible_message(span_warning("[src] twists and dissolves into a pile of flesh!"))
		restore(TRUE)
	..()

/mob/living/simple_mob/vore/morph/will_show_tooltip()
	return (!morphed)

/mob/living/simple_mob/vore/morph/resize(var/new_size, var/animate = TRUE, var/uncapped = FALSE, var/ignore_prefs = FALSE, var/aura_animation = TRUE)
	if(morphed && !ismob(form))
		return
	return ..()

/mob/living/simple_mob/vore/morph/lay_down()
	if(morphed)
		var/temp_state = icon_state
		..()
		icon_state = temp_state
		//Stolen from protean blobs, ambush noms from resting! Doesn't hide you any better, but makes noms sneakier.
		if(resting)
			plane = ABOVE_OBJ_PLANE
			to_chat(src,span_notice("Your form settles in, appearing more 'normal'... laying in wait."))
		else
			plane = MOB_PLANE
			to_chat(src,span_notice("Your form quivers back to life, allowing you to move again!"))
			if(can_be_drop_pred) //Toggleable in vore panel
				var/list/potentials = living_mobs(0)
				if(potentials.len)
					var/mob/living/target = pick(potentials)
					if(istype(target) && target.devourable && target.can_be_drop_prey && vore_selected)
						if(target.buckled)
							target.buckled.unbuckle_mob(target, force = TRUE)
						target.forceMove(vore_selected)
						to_chat(target,span_vwarning("\The [src] quickly engulfs you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!"))
	else
		..()

/mob/living/simple_mob/vore/morph/update_icon()
	if(morphed)
		return
	return ..()


/mob/living/simple_mob/vore/morph/update_icons()
	if(morphed)
		return
	return ..()

/mob/living/simple_mob/vore/morph/update_transform()
	if(morphed)
		var/matrix/M = matrix()
		M.Scale(icon_scale_x, icon_scale_y)
		M.Turn(icon_rotation)
		src.transform = M
	else
		..()

/mob/living/simple_mob/vore/morph/proc/morph_color()
	set name = "Pick Color"
	set category = "Abilities.Settings"
	set desc = "You can set your color!"
	var/newcolor = input(usr, "Choose a color.", "", color) as color|null
	if(newcolor)
		color = newcolor
		chosen_color = newcolor


/mob/living/simple_mob/vore/morph/proc/take_over_prey()
	set name = "Take Over Prey"
	set category = "Abilities.Morph"
	set desc = "Take command of your prey's body."
	if(morphed)
		to_chat(src, span_warning("You must restore to your original form first!"))
		return
	var/list/possible_mobs = list()
	for(var/obj/belly/B in src.vore_organs)
		for(var/mob/living/H in B)
			if((ishuman(H) || isrobot(H)) && H.ckey)
				possible_mobs += H
			else
				continue
		var/mob/living/L = tgui_input_list(src, "Select a mob to take over:", "Take Over Prey", possible_mobs)
		if(!L)
			return
		if(!L.allow_mimicry)
			to_chat(src, span_warning("\The [L] cannot be impersonated!"))
			return
		if(tgui_alert(src, "You selected [L] to attempt to take over. Are you sure?", "Take Over Prey",list("No","Yes")) == "Yes")
			log_admin("[key_name_admin(src)] offered [L] to swap bodies as a morph.")
			if(tgui_alert(L, "\The [src] has elected to attempt to take over your body and control you. Is this something you will allow to happen?", "Allow Morph To Take Over",list("No","Yes")) == "Yes")
				if(tgui_alert(L, "Are you sure? The only way to undo this on your own is to OOC Escape.", "Allow Morph To Take Over",list("No","Yes")) == "Yes")
					if(buckled)
						buckled.unbuckle_mob()
					if(L.buckled)
						L.buckled.unbuckle_mob()
					if(LAZYLEN(buckled_mobs))
						for(var/buckledmob in buckled_mobs)
							riding_datum.force_dismount(buckledmob)
					if(LAZYLEN(L.buckled_mobs))
						for(var/p_buckledmob in L.buckled_mobs)
							L.riding_datum.force_dismount(p_buckledmob)
					if(pulledby)
						pulledby.stop_pulling()
					if(L.pulledby)
						L.pulledby.stop_pulling()
					stop_pulling()
					original_ckey = ckey
					log_and_message_admins("[key_name_admin(src)] has swapped bodies with [key_name_admin(L)] as a morph at [get_area(src)] - [COORD(src)].")
					new /mob/living/simple_mob/vore/morph/dominated_prey(L.vore_selected, L.ckey, src, L)
				else
					to_chat(src, span_warning("\The [L] declined your request for control."))
			else
				to_chat(src, span_warning("\The [L] declined your request for control."))

/mob/living/simple_mob/vore/morph/dominated_prey
	name = "subservient node"
	color = "#171717"
	digestable = 0
	devourable = 0
	var/mob/living/simple_mob/vore/morph/parent_morph
	var/mob/living/carbon/human/prey_body
	var/prey_ckey


/mob/living/simple_mob/vore/morph/dominated_prey/New(loc, pckey, parent, prey)
	. = ..()
	if(pckey)
		prey_ckey = pckey
		parent_morph = parent
		prey_body = prey
		prey_body.forceMove(get_turf(parent_morph))
		prey_body.muffled = FALSE
		prey_body.absorbed = FALSE
		absorbed = TRUE
		ckey = prey_ckey
		prey_body.ckey = parent_morph.original_ckey
		parent_morph.forceMove(src)
		name = "[prey_body.name]"
		to_chat(prey_body, span_notice("You have completely assumed the form of [prey_body]. Your form is now unable to change anymore until you restore control back to them. You can do this by 'ejecting' them from your [prey_body.vore_selected]. This will not actually release them from your body in this state, but instead return control to them, and restore you to your original form."))
	else
		qdel(src)

/mob/living/simple_mob/vore/morph/dominated_prey/death(gibbed)
	. = ..()
	undo_prey_takeover(FALSE)


/mob/living/simple_mob/vore/morph/dominated_prey/Destroy()
	. = ..()
	parent_morph = null
	prey_body = null

/mob/living/simple_mob/vore/morph/dominated_prey/proc/undo_prey_takeover(ooc_escape)
	if(buckled)
		buckled.unbuckle_mob()
	if(prey_body.buckled)
		prey_body.buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(LAZYLEN(prey_body.buckled_mobs))
		for(var/p_buckledmob in prey_body.buckled_mobs)
			prey_body.riding_datum.force_dismount(p_buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	if(prey_body.pulledby)
		prey_body.pulledby.stop_pulling()
	stop_pulling()

	if(ooc_escape)
		prey_body.forceMove(get_turf(src))
		parent_morph.forceMove(get_turf(src))
		parent_morph.ckey = parent_morph.original_ckey
		prey_body.ckey = prey_ckey
		log_and_message_admins("[key_name_admin(prey_body)] used the OOC escape button to get out of [key_name_admin(parent_morph)]. They have been returned to their original bodies. [ADMIN_FLW(src)]")
	else
		parent_morph.forceMove(get_turf(prey_body))
		parent_morph.ckey = parent_morph.original_ckey
		prey_body.ckey = prey_ckey
		prey_body.forceMove(parent_morph.vore_selected)
		log_and_message_admins("[key_name_admin(prey_body)] and [key_name_admin(parent_morph)] have been returned to their original bodies. [get_area(src)] - [COORD(src)].")
	qdel(src)

#undef MORPH_COOLDOWN
