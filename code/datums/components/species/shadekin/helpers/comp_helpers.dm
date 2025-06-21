///Returns the shadekin component of the given mob
/mob/living/proc/get_shadekin_component()
	var/datum/component/shadekin/SK = GetComponent(/datum/component/shadekin)
	if(SK)
		return SK

///Handles the shadekin's HUD updates.
/datum/component/shadekin/proc/update_shadekin_hud()
	var/turf/T = get_turf(owner)
	if(owner.shadekin_display)
		var/l_icon = 0
		var/e_icon = 0

		owner.shadekin_display.invisibility = INVISIBILITY_NONE
		if(T)
			var/brightness = T.get_lumcount() //Brightness in 0.0 to 1.0
			var/darkness = 1-brightness //Invert
			switch(darkness)
				if(0.80 to 1.00)
					l_icon = 0
				if(0.60 to 0.80)
					l_icon = 1
				if(0.40 to 0.60)
					l_icon = 2
				if(0.20 to 0.40)
					l_icon = 3
				if(0.00 to 0.20)
					l_icon = 4

		switch(shadekin_get_energy())
			if(0 to 24)
				e_icon = 0
			if(25 to 49)
				e_icon = 1
			if(50 to 74)
				e_icon = 2
			if(75 to 99)
				e_icon = 3
			if(100 to INFINITY)
				e_icon = 4

		owner.shadekin_display.icon_state = "shadekin-[l_icon]-[e_icon]"
	return

///For simplekin or those that have a pre-defined eye color
/datum/component/shadekin/proc/set_eye_energy()
	if(!eye_color_influences_energy)
		return
	switch(eye_color)
		//Blue has constant, steady (slow) regen and ignores darkness.
		if(BLUE_EYES)
			set_light_and_darkness(0.75,0.75)
		if(RED_EYES)
			set_light_and_darkness(-0.5,0.5)
		if(PURPLE_EYES)
			set_light_and_darkness(-0.5,1)
		if(YELLOW_EYES)
			set_light_and_darkness(-2,3)
		if(GREEN_EYES)
			set_light_and_darkness(0.125,2)
		if(ORANGE_EYES)
			set_light_and_darkness(-0.25,0.75)

///Sets our eye color.
/datum/component/shadekin/proc/set_shadekin_eyecolor(var/mob/living/carbon/human/H)
	if(!ishuman(owner))
		return eye_color //revert to default if we're not a human
	else
		H = owner
	var/eyecolor_rgb = rgb(H.r_eyes, H.g_eyes, H.b_eyes)

	var/eyecolor_hue = rgb2num(eyecolor_rgb, COLORSPACE_HSV)[1]
	var/eyecolor_sat = rgb2num(eyecolor_rgb, COLORSPACE_HSV)[2]
	var/eyecolor_val = rgb2num(eyecolor_rgb, COLORSPACE_HSV)[3]

	//First, clamp the saturation/value to prevent black/grey/white eyes
	if(eyecolor_sat < 10)
		eyecolor_sat = 10
	if(eyecolor_val < 40)
		eyecolor_val = 40

	eyecolor_rgb = rgb(eyecolor_hue, eyecolor_sat, eyecolor_val, space=COLORSPACE_HSV)

	H.r_eyes = rgb2num(eyecolor_rgb)[1]
	H.g_eyes = rgb2num(eyecolor_rgb)[2]
	H.b_eyes = rgb2num(eyecolor_rgb)[3]

	//Now determine what color we fall into.
	switch(eyecolor_hue)
		if(0 to 20)
			eye_color = RED_EYES
		if(21 to 50)
			eye_color = ORANGE_EYES
		if(51 to 70)
			eye_color = YELLOW_EYES
		if(71 to 160)
			eye_color = GREEN_EYES
		if(161 to 260)
			eye_color = BLUE_EYES
		if(261 to 340)
			eye_color = PURPLE_EYES
		if(341 to 360)
			eye_color = RED_EYES
	return eye_color

///Adds the shadekin abilities to the owner.
/datum/component/shadekin/proc/add_shadekin_abilities()
	if(!owner.ability_master || !istype(owner.ability_master, /obj/screen/movable/ability_master/shadekin))
		owner.ability_master = null
		owner.ability_master = new /obj/screen/movable/ability_master/shadekin(owner)
	for(var/datum/power/shadekin/P in shadekin_ability_datums)
		if(!(P.verbpath in owner.verbs))
			add_verb(owner, P.verbpath)
			owner.ability_master.add_shadekin_ability(
					object_given = owner,
					verb_given = P.verbpath,
					name_given = P.name,
					ability_icon_given = P.ability_icon_state,
					arguments = list()
					)

//wait, it's all light?
///Allows setting the light and darkness gain.
///@Args: light_gain, dark_gain
/datum/component/shadekin/proc/set_light_and_darkness(light_gain, dark_gain)
	if(light_gain)
		energy_light = light_gain
	if(dark_gain)
		energy_dark = dark_gain


//ENERGY HELPERS

/// Returns the shadekin's current energy.
/// Returns max_energy if dark_energy_infinite is set to TRUE.
/datum/component/shadekin/proc/shadekin_get_energy()
	if(dark_energy_infinite)
		return max_dark_energy
	return dark_energy

/// Returns the shadekin's maximum energy.
/datum/component/shadekin/proc/shadekin_get_max_energy()
	return max_dark_energy

///Sets the shadekin's energy TO the given value.
/datum/component/shadekin/proc/shadekin_set_energy(var/new_energy)
	if(!isnum(new_energy))
		return
	dark_energy = CLAMP(new_energy, 0, max_dark_energy)

///Sets the shadekin's maximum energy.
/datum/component/shadekin/proc/shadekin_set_max_energy(var/new_max_energy)
	if(!isnum(new_max_energy))
		return //No.
	max_dark_energy = new_max_energy

///Adjusts the shadekin's energy by the given amount.
/datum/component/shadekin/proc/shadekin_adjust_energy(var/amount)
	if(!isnum(amount))
		return //No
	shadekin_set_energy(dark_energy + amount)
