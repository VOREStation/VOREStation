/mob/living/simple_mob/vore/zorgoia
	name = "zorgoia"
	desc = "It's a a reptilian mammal hybrid, known for its voracious nature and love for fruits. By more popular terms its referred to as the furry slinky!"
	tt_desc = "Zorgoyuh slinkus"
	icon = 'icons/mob/zorgoia64x32.dmi'
	icon_state = null //Overlay system will make the goias
	icon_living = null
	icon_rest = null
	icon_dead = "zorgoia-death"
	faction = FACTION_ZORGOIA
	maxHealth = 150 //chonk
	health = 150
	melee_damage_lower = 5
	melee_damage_upper = 15 //Don't break my bones bro
	see_in_dark = 5
	response_help = "pets"
	response_disarm = "bops"
	response_harm = "hits"
	attacktext = list("mauled")
	friendly = list("nuzzles", "noses softly at", "noseboops", "headbumps against", "nibbles affectionately on")
	meat_amount = 5
	has_eye_glow = TRUE //(evil)

	old_x = 0
	old_y = 0
	default_pixel_x = 0
	pixel_x = 0
	pixel_y = 0

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_y = 10

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/zorgoia
	var/mob/living/carbon/human/friend
	var/tamed = 0
	var/tame_chance = 50 //It's a fiddy-fiddy default you may get a buddy pal or you may get mauled and ate. Win-win!

	color = null //color is selected when spawned

	vore_active = 1
	vore_capacity = 3
	vore_icons = 0 //The icon system down there handles the vore belly
	vore_pounce_chance = 35
	vore_bump_chance = 25
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_stomach_name = "stomach" //Might make a better vore text but have this one for now.
	vore_stomach_flavor = "You find yourself greedily gulped down into the zorgoia's stomach; the walls are surprisingly roomy in comparison to other critters of this size as their stomach makes up a majority of their long noodle shaped body. Your body contorting with the zorgoias long shape as every inch of you is tightly bound by their glowy walls."
	vore_default_contamination_flavor = "Acrid"
	vore_default_item_mode = IM_DIGEST


	can_be_drop_prey = FALSE
	allow_mind_transfer = TRUE
	species_sounds = "None"
	pain_emote_1p = list("yelp", "whine", "bark", "growl")
	pain_emote_3p = list("yelps", "whines", "barks", "growls")

	//This is copypastad from protean code, hope it isnt too painful lol
	var/list/goia_overlays = list( //all 10 overlays, in order
		"zorgoia_belly" = "#FFFFFF",
		"zorgoia_main" = "#FFFFFF",
		"zorgoia_ears" = "#FFFFFF",
		"zorgoia_spots" = "#FFFFFF",
		"zorgoia_claws" = "#FFFFFF",
		"zorgoia_spines" = "#FFFFFF",
		"zorgoia_fluff" = "#FFFFFF",
		"zorgoia_underbelly" = "#FFFFFF",
		"zorgoia_eyes" = "#FFFFFF",
		"zorgoia_spike" = "#FFFFFF"
	)

	var/list/ear_styles = list(
		"null",
		"zorgoia_ears",
		"zorgoia_ears2"
	)
	var/list/spots_styles = list(
		"null",
		"zorgoia_spots",
		"zorgoia_stripes",
		"zorgoia_backline",
		"zorgoia_stars"
	)
	var/list/claws_styles = list(
		"null",
		"zorgoia_claws",
		"zorgoia_justfangs",
		"zorgoia_feetpaws"
	)
	var/list/spines_styles = list(
		"null",
		"zorgoia_spines",
		"zorgoia_tailfade"
	)
	var/list/fluff_styles = list(
		"null",
		"zorgoia_fluff",
		"zorgoia_fullhead"
	)
	var/list/underbelly_styles = list(
		"zorgoia_underbelly",
		"zorgoia_underbellystripe",
		"null"
	)
	var/list/eyes_styles = list(
		"zorgoia_eyes",
		"zorgoia_eyes2"
	)
	var/list/spiky_styles = list(
		"zorgoia_spike",
		"zorgoia_spike2"
	)
	var/list/belly_styles = list(
		"zorgoia_belly"
	)

/mob/living/simple_mob/vore/zorgoia/proc/recolor() //Base sprite wont need a radical menu selection
	set name = "Change Color"
	set desc = "Change your main color."
	set category = "Abilities.General"
	var/new_color = tgui_color_picker(src, "Pick new colors:","Color", goia_overlays["zorgoia_main"])
	if(!new_color)
		return 0
	goia_overlays["zorgoia_main"] = new_color
	update_icon()

/mob/living/simple_mob/vore/zorgoia/proc/appearance_switch() //This is just copypastas of the radial menu code, each block of code is the options for each bit of customisation... all 9 of them
	set name = "Adjust Mob Markings"
	set desc = "Change your markings and mob colors."
	set category = "Abilities.General"

	var/list/options = list("Belly","Spike","Ears","Spots","Claws","Spines","Fluff","Underbelly","Eyes")
	for(var/option in options)
		LAZYSET(options, option, image('modular_chomp/icons/effects/goia_labels.dmi', option))
	var/choice = show_radial_menu(src, src, options, radius = 60)
	if(!choice || QDELETED(src) || src.incapacitated())
		return FALSE
	. = TRUE
	switch(choice)

		if("Ears")
			options = ear_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4, pixel_x = -16)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick ears spike color:","Ears Color", goia_overlays["zorgoia_ears"])
			if(!new_color)
				return 0
			goia_overlays["ears"] = choice
			goia_overlays["zorgoia_ears"] = new_color
			update_icon()

		if("Spots")
			options = spots_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4, pixel_x = -16)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick spot colors:","Spots Color", goia_overlays["zorgoia_spots"])
			if(!new_color)
				return 0
			goia_overlays["spots"] = choice
			goia_overlays["zorgoia_spots"] = new_color
			update_icon()

		if("Claws")
			options = claws_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4, pixel_x = -16)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick claw colors:","Claws Color", goia_overlays["zorgoia_claws"])
			if(!new_color)
				return 0
			goia_overlays["claws"] = choice
			goia_overlays["zorgoia_claws"] = new_color
			update_icon()

		if("Spines")
			options = spines_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4, pixel_x = -16)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick spines colors:","Spines Color", goia_overlays["zorgoia_spines"])
			if(!new_color)
				return 0
			goia_overlays["spines"] = choice
			goia_overlays["zorgoia_spines"] = new_color
			update_icon()

		if("Fluff")
			options = fluff_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4, pixel_x = -16)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick fluff colors:","Fluff Color", goia_overlays["zorgoia_fluff"])
			if(!new_color)
				return 0
			goia_overlays["fluff"] = choice
			goia_overlays["zorgoia_fluff"] = new_color
			update_icon()

		if("Underbelly")
			options = underbelly_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4, pixel_x = -16)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick underbelly colors:","Underbelly Color", goia_overlays["zorgoia_underbelly"])
			if(!new_color)
				return 0
			goia_overlays["underbelly"] = choice
			goia_overlays["zorgoia_underbelly"] = new_color
			update_icon()

		if("Eyes")
			options = eyes_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4, pixel_x = -16)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick eye color:","Eye Color", goia_overlays["zorgoia_eyes"])
			if(!new_color)
				return 0
			goia_overlays["eyes"] = choice
			goia_overlays["zorgoia_eyes"] = new_color
			update_icon()

		if("Spike")
			options = spiky_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick tail spike color:","Tail Color", goia_overlays["zorgoia_spike"]) //This is overlay 10, not 2, swapped with main body, im not rewriting this array
			if(!new_color)
				return 0
			goia_overlays["spike"] = choice
			goia_overlays["zorgoia_spike"] = new_color
			update_icon()

		if("Belly")
			options = belly_styles
			for(var/option in options)
				var/image/I = image('modular_chomp/icons/mob/zorgoia64x32.dmi', option, dir = 4)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = tgui_color_picker(src, "Pick belly color:","Belly Color", goia_overlays["zorgoia_belly"])
			if(!new_color)
				return 0
			goia_overlays["belly"] = choice
			goia_overlays["zorgoia_belly"] = new_color
			update_icon()

/mob/living/simple_mob/vore/zorgoia/Initialize(mapload)
	. = ..()
	add_verb(src,/mob/living/simple_mob/vore/zorgoia/proc/appearance_switch)
	add_verb(src,/mob/living/simple_mob/vore/zorgoia/proc/recolor)
	add_verb(src,/mob/living/proc/injection) //Poison sting c:
	add_verb(src,/mob/living/simple_mob/vore/zorgoia/proc/export_style)
	add_verb(src,/mob/living/simple_mob/vore/zorgoia/proc/import_style)
	src.trait_injection_reagents += REAGENT_ID_MICROCILLIN			// get small
	src.trait_injection_reagents += REAGENT_ID_MACROCILLIN			// get BIG
	src.trait_injection_reagents += REAGENT_ID_NORMALCILLIN			// normal
	src.trait_injection_reagents += REAGENT_ID_NUMBENZYME			// no feelings
	src.trait_injection_reagents += REAGENT_ID_ANDROROVIR			// -> MALE
	src.trait_injection_reagents += REAGENT_ID_GYNOROVIR			// -> FEMALE
	src.trait_injection_reagents += REAGENT_ID_ANDROGYNOROVIR		// -> PLURAL
	src.trait_injection_reagents += REAGENT_ID_STOXIN				// night night chem
	src.trait_injection_reagents += REAGENT_ID_RAINBOWTOXIN			// Funny flashing lights.
	src.trait_injection_reagents += REAGENT_ID_PARALYSISTOXIN 		// Paralysis!
	src.trait_injection_reagents += REAGENT_ID_PAINENZYME			// Pain INCREASER
	src.trait_injection_reagents += REAGENT_ID_APHRODISIAC			// Horni

	var/list/goia_colors = list("#1a00ff", "#6c5bff", "#ff00fe", "#ff0000", "#00d3ff", "#00ff7c", "#00ff35", "#e1ff00", "#ff9f00", "#393939")
	var/bodycolor = pick(goia_colors)
	var/spines = pick(goia_colors)
	goia_overlays["main"]= "zorgoia_main"
	goia_overlays["zorgoia_main"] = bodycolor
	goia_overlays["ears"] = pick(ear_styles)
	goia_overlays["zorgoia_ears"] = bodycolor
	goia_overlays["spots"] = pick(spots_styles)
	goia_overlays["zorgoia_spots"] = pick(goia_colors)
	goia_overlays["claws"] = pick(claws_styles)
	goia_overlays["zorgoia_claws"] = spines
	goia_overlays["spines"] = pick(spines_styles)
	goia_overlays["zorgoia_spines"] = spines
	goia_overlays["fluff"] = pick(fluff_styles)
	goia_overlays["zorgoia_fluff"] = bodycolor
	goia_overlays["underbelly"] = pick(underbelly_styles)
	goia_overlays["zorgoia_underbelly"] = bodycolor
	goia_overlays["eyes"] = pick(eyes_styles)
	goia_overlays["zorgoia_eyes"] = "#[get_random_colour(1)]"
	goia_overlays["spike"] = pick(spiky_styles)
	goia_overlays["zorgoia_spike"] = "#[get_random_colour(0,0,255)]"
	goia_overlays["belly"] = pick(belly_styles)
	goia_overlays["zorgoia_belly"] = bodycolor
	update_icon()

/mob/living/simple_mob/vore/zorgoia/update_icon()
	..()
	if(stat == DEAD)
		plane = MOB_LAYER
		return
	else
		plane = ABOVE_MOB_PLANE
	cut_overlays()
	icon = 'modular_chomp/icons/mob/zorgoia64x32.dmi'
	vore_capacity = 3
	//Heads up, the order of these overlays stacking on top of each other is different from the array order. So goia_overlay[1] is the belly, but rendering on top of everything at the end instead

	var/image/I = image(icon, "[goia_overlays["main"]][resting? "-rest" : null]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_main"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)

	I = image(icon, "[goia_overlays["ears"]][resting? "-rest" : null]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_ears"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)

	I = image(icon, "[goia_overlays["spots"]][resting? "-rest" : null]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_spots"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)

	I = image(icon, "[goia_overlays["claws"]][resting? "-rest" : null]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_claws"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)

	I = image(icon, "[goia_overlays["spines"]][resting? "-rest" : null]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_spines"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)


	I = image(icon, "[goia_overlays["fluff"]][resting? "-rest" : null]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_fluff"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)

	I = image(icon, "[goia_overlays["eyes"]][resting? "-rest" : null]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_eyes"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = PLANE_LIGHTING_ABOVE
	add_overlay(I)
	qdel(I)

	I = image(icon, "[goia_overlays["spike"]][resting? "-rest" : null]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_spike"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)

	I = image(icon, "[goia_overlays["belly"]][resting? "-rest" : (vore_fullness? "-[vore_fullness]" : null)]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_belly"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)

	I = image(icon, "[goia_overlays["underbelly"]][resting? "-rest" : (vore_fullness? "-[vore_fullness]" : null)]", pixel_x = -16)
	I.color = goia_overlays["zorgoia_underbelly"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)
	qdel(I)

/mob/living/simple_mob/vore/zorgoia/attack_hand(mob/living/carbon/human/M as mob)
	switch(M.a_intent)
		if(I_HELP)
			if(health > 0)
				if(M.zone_sel.selecting == BP_GROIN)
					if(M.vore_bellyrub(src))
						return
				M.visible_message(span_notice("[M] [response_help] \the [src]."))
				if(has_AI())
					var/datum/ai_holder/AI = ai_holder
					AI.set_stance(STANCE_IDLE)
					if(prob(tame_chance))
						AI.violent_breakthrough = FALSE
						AI.hostile = FALSE
						friend = M
						AI.set_follow(friend)
						if(tamed != 1)
							tamed = 1
							faction = M.faction
					sleep(1 SECOND)

		if(I_GRAB)
			if(health > 0)
				if(has_AI())
					var/datum/ai_holder/AI = ai_holder
					audible_emote("growls disapprovingly at [M].")
					if(M == friend)
						AI.lose_follow()
						friend = null
					return
			..()
		else
			..()

/mob/living/simple_mob/vore/zorgoia/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	add_verb(src,/mob/living/simple_mob/proc/animal_mount)
	add_verb(src,/mob/living/proc/toggle_rider_reins)
	movement_cooldown = 0

/mob/living/simple_mob/vore/zorgoia/MouseDrop_T(mob/living/M, mob/living/user)
	return

/mob/living/simple_mob/vore/zorgoia/death() //are they going to be ok?
	. = ..()
	cut_overlays()

/mob/living/simple_mob/vore/zorgoia/tamed
	tamed = TRUE

/datum/ai_holder/simple_mob/melee/evasive/zorgoia

/datum/ai_holder/simple_mob/melee/evasive/zorgoia/New(var/mob/living/simple_mob/vore/zorgoia/new_holder)
	.=..()
	if(new_holder.tamed)
		hostile = FALSE

/mob/living/simple_mob/vore/zorgoia/proc/export_style()
	set name = "Export style string"
	set desc = "Export a string of text that can be used to instantly get the current style back using the import style verb"
	set category = "Abilities.Settings"
	var/output_style = jointext(list(
		goia_overlays["zorgoia_main"],
		goia_overlays["main"], // No alt styles for it currently
		goia_overlays["zorgoia_ears"],
		goia_overlays["ears"],
		goia_overlays["zorgoia_spots"],
		goia_overlays["spots"],
		goia_overlays["zorgoia_claws"],
		goia_overlays["claws"],
		goia_overlays["zorgoia_spines"],
		goia_overlays["spines"],
		goia_overlays["zorgoia_fluff"],
		goia_overlays["fluff"],
		goia_overlays["zorgoia_underbelly"],
		goia_overlays["underbelly"],
		goia_overlays["zorgoia_eyes"],
		goia_overlays["eyes"],
		goia_overlays["zorgoia_spike"],
		goia_overlays["spike"],
		goia_overlays["zorgoia_belly"],
		goia_overlays["belly"]), ";")
	to_chat(src, span_notice("Exported style string is \" [output_style] \". Use this to get the same style in the future with import style"))

/mob/living/simple_mob/vore/zorgoia/proc/import_style()
	set name = "Import style string"
	set desc = "Import a string of text that was made using the import style verb to get back that style"
	set category = "Abilities.Settings"
	var/input_style
	input_style = sanitizeSafe(tgui_input_text(src,"Paste the style string you exported with Export Style.", "Style loading","", 250))
	if(input_style)
		var/list/input_style_list = splittext(input_style, ";")
		if((LAZYLEN(input_style_list) == 20) /* && (input_style_list[2] in main_styles) */ \
					&& (input_style_list[4] in ear_styles) && (input_style_list[6] in spots_styles) && (input_style_list[8] in claws_styles) \
					&& (input_style_list[10] in spines_styles) && (input_style_list[12] in fluff_styles) && (input_style_list[14] in underbelly_styles) \
					&& (input_style_list[16] in eyes_styles) && (input_style_list[18] in spiky_styles) &&  (input_style_list[20] in belly_styles))
			try
				if(rgb2num(input_style_list[1]))
					goia_overlays["zorgoia_main"] = input_style_list[1]
			catch
			// goia_overlays["main"] = input_style_list[2] // We only have one yet
			try
				if(rgb2num(input_style_list[3]))
					goia_overlays["zorgoia_ears"] = input_style_list[3]
			catch
			goia_overlays["ears"] = input_style_list[4]
			try
				if(rgb2num(input_style_list[5]))
					goia_overlays["zorgoia_spots"] = input_style_list[5]
			catch
			goia_overlays["spots"] = input_style_list[6]
			try
				if(rgb2num(input_style_list[7]))
					goia_overlays["zorgoia_claws"] = input_style_list[7]
			catch
			goia_overlays["claws"] = input_style_list[8]
			try
				if(rgb2num(input_style_list[9]))
					goia_overlays["zorgoia_spines"] = input_style_list[9]
			catch
			goia_overlays["spines"] = input_style_list[10]
			try
				if(rgb2num(input_style_list[11]))
					goia_overlays["zorgoia_fluff"] = input_style_list[11]
			catch
			goia_overlays["fluff"] = input_style_list[12]
			try
				if(rgb2num(input_style_list[13]))
					goia_overlays["zorgoia_underbelly"] = input_style_list[13]
			catch
			goia_overlays["underbelly"] = input_style_list[14]
			try
				if(rgb2num(input_style_list[15]))
					goia_overlays["zorgoia_eyes"] = input_style_list[15]
			catch
			goia_overlays["eyes"] = input_style_list[16]
			try
				if(rgb2num(input_style_list[17]))
					goia_overlays["zorgoia_spike"] = input_style_list[17]
			catch
			input_style_list["spike"] = input_style_list[18]
			try
				if(rgb2num(input_style_list[19]))
					goia_overlays["zorgoia_belly"] = input_style_list[19]
			catch
			goia_overlays["belly"] = input_style_list[20]
			update_icon()
