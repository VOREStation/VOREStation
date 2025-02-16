/mob/proc/update_fullness(var/returning = FALSE)
	if(!returning)
		if(updating_fullness)
			return
		updating_fullness = TRUE
		spawn(2)
		updating_fullness = FALSE
		src.update_fullness(TRUE)
		return
	var/list/new_fullness = list()
	vore_fullness = 0
	for(var/belly_class in vore_icon_bellies)
		new_fullness[belly_class] = 0
	for(var/obj/belly/B as anything in vore_organs)
		if(DM_FLAG_VORESPRITE_BELLY & B.vore_sprite_flags)
			new_fullness[B.belly_sprite_to_affect] += B.GetFullnessFromBelly()
		if(ishuman(src) && DM_FLAG_VORESPRITE_ARTICLE & B.vore_sprite_flags)
			if(!new_fullness[B.undergarment_chosen])
				new_fullness[B.undergarment_chosen] = 1
			new_fullness[B.undergarment_chosen] += B.GetFullnessFromBelly()
			new_fullness[B.undergarment_chosen + "-ifnone"] = B.undergarment_if_none
			new_fullness[B.undergarment_chosen + "-color"] = B.undergarment_color
	for(var/belly_class in vore_icon_bellies)
		new_fullness[belly_class] /= size_multiplier //Divided by pred's size so a macro mob won't get macro belly from a regular prey.
		new_fullness[belly_class] *= belly_size_multiplier // Some mobs are small even at 100% size. Let's account for that.
		new_fullness[belly_class] = round(new_fullness[belly_class], 1) // Because intervals of 0.25 are going to make sprite artists cry.
		vore_fullness_ex[belly_class] = min(vore_capacity_ex[belly_class], new_fullness[belly_class])
		vore_fullness += new_fullness[belly_class]
	if(vore_fullness < 0)
		vore_fullness = 0
	vore_fullness = min(vore_capacity, vore_fullness)
	updating_fullness = FALSE
	return new_fullness

/mob/living/proc/vs_animate(var/belly_to_animate)
	return

// use this instead of upsate fullness where you need to directly update a belly size
/mob/proc/handle_belly_update()
	if(ishuman(src))
		update_fullness()
		return
	update_icon()
