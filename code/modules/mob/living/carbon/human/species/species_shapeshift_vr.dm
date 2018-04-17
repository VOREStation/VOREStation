/mob/living/carbon/human/proc/shapeshifter_select_ears()
	set name = "Select Ears"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_ear_styles = list("Normal" = null)
	for(var/path in ear_styles_list)
		var/datum/sprite_accessory/ears/instance = ear_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_ear_styles[instance.name] = path

	// Present choice to user
	var/new_ear_style = input(src, "Pick some ears!", "Character Preference", ear_style ? ear_style.name : null) as null|anything in pretty_ear_styles
	if(!new_ear_style)
		return
	
	//Set new style
	ear_style = ear_styles_list[pretty_ear_styles[new_ear_style]]
	
	//Allow color picks
	var/current_pri_color = rgb(r_ears,g_ears,b_ears)
	
	var/new_pri_color = input("Pick primary ear color:","Ear Color (Pri)", current_pri_color) as null|color
	if(new_pri_color)
		var/list/new_color_rgb_list = hex2rgb(new_pri_color)
		r_ears = new_color_rgb_list[1]
		g_ears = new_color_rgb_list[2]
		b_ears = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_ears2,g_ears2,b_ears2)
	
		var/new_sec_color = input("Pick secondary ear color (only applies to some ears):","Ear Color (sec)", current_sec_color) as null|color
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_ears2 = new_color_rgb_list[1]
			g_ears2 = new_color_rgb_list[2]
			b_ears2 = new_color_rgb_list[3]

	update_hair() //Includes Virgo ears

/mob/living/carbon/human/proc/shapeshifter_select_tail()
	set name = "Select Tail"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_tail_styles = list("Normal" = null)
	for(var/path in tail_styles_list)
		var/datum/sprite_accessory/tail/instance = tail_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_tail_styles[instance.name] = path

	// Present choice to user
	var/new_tail_style = input(src, "Pick a tail!", "Character Preference", tail_style ? tail_style.name : null) as null|anything in pretty_tail_styles
	if(!new_tail_style)
		return
	
	//Set new style
	tail_style = tail_styles_list[pretty_tail_styles[new_tail_style]]
	
	//Allow color picks
	var/current_pri_color = rgb(r_tail,g_tail,b_tail)
	
	var/new_pri_color = input("Pick primary tail color:","Tail Color (Pri)", current_pri_color) as null|color
	if(new_pri_color)
		var/list/new_color_rgb_list = hex2rgb(new_pri_color)
		r_tail = new_color_rgb_list[1]
		g_tail = new_color_rgb_list[2]
		b_tail = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_tail2,g_tail2,b_tail2)
	
		var/new_sec_color = input("Pick secondary tail color (only applies to some tails):","Tail Color (sec)", current_sec_color) as null|color
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_tail2 = new_color_rgb_list[1]
			g_tail2 = new_color_rgb_list[2]
			b_tail2 = new_color_rgb_list[3]

	update_tail_showing()

/mob/living/carbon/human/proc/shapeshifter_select_wings()
	set name = "Select Wings"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_wing_styles = list("None" = null)
	for(var/path in wing_styles_list)
		var/datum/sprite_accessory/wing/instance = wing_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_wing_styles[instance.name] = path

	// Present choice to user
	var/new_wing_style = input(src, "Pick some wings!", "Character Preference", wing_style ? wing_style.name : null) as null|anything in pretty_wing_styles
	if(!new_wing_style)
		return
	
	//Set new style
	wing_style = wing_styles_list[pretty_wing_styles[new_wing_style]]
	
	//Allow color picks
	var/current_color = rgb(r_wing,g_wing,b_wing)
	
	var/new_color = input("Pick wing color:","Wing Color", current_color) as null|color
	if(new_color)
		var/list/new_color_rgb_list = hex2rgb(new_color)
		r_wing = new_color_rgb_list[1]
		g_wing = new_color_rgb_list[2]
		b_wing = new_color_rgb_list[3]

	update_wing_showing()
