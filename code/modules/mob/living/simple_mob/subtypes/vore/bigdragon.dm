/*
HARK, YON CODE DIVER.
What lays before you is a lot of spaghetti in order to make a fairly unique boss mob.
Scour its code if you dare.

Here's a summary, however.

This is a 128x92px mob with sprites drawn by Przyjaciel (thanks mate) and some codersprites.

The bigdragon is an 800 health hostile boss mob with three special attacks.
The first (disarm intent) is a charge attack that activates when the target is >5 tiles away and requires line of sight.
While charging, the dragon can run up/down cliffs harmlessly, but will thunk into objects for a brief stun.
Charging requires direct line of sight to start the attack.
Charging directly onto someone deals 50 brute and stuns them, likely with vore to follow.
Charging next to someone will deal 20 brute and send them flying.

The second (grab intent) is a tail sweep attack that activates when 2 or more hostiles are within 2 tiles of it.
The tail sweep deals 20 brute to all targets and throws them back a great distance with a brief stun.
Tail sweeping while ontop of a target will deal 50 brute like the charge above.

The third (harm intent) is a telegraphed flame swathe attack. The inidividual flame pellets deal 30 burn each and set mobs and carbons on fire alike.
This attack is the mobs default attack.

When the big dragon is below 1/2 health, or was previously friendly and was pissed off, it will enrage.
While enraged, the dragon will NOT stop and stand still while telegraphing its attacks.
This is exceptionally dangerous, as it will actively breathe fire whilest pursuing a target.

DO NOT challenge this beast in open fields. You need cover to survive.
Unless you're a tesh or something I guess. Speed.

As a flex, this mob has six vore organs.
It will swap between two variants (heal and digest) depending on if it's friendly or not.
It will eat prey with its maw, which has code in place to automatically push prey deeper over time.
The mob will only get increased "fullness" for prey who have made it to its stomach. Y'know. So the fat sprites make sense.

This mob can be made friendly by supplying it with a gold coin or a gold ingot. I'd make it every gold item, but then you could just raid its hoard for an easy tame. And that's lame.

While friendly, it will actively search for players with <95% health and attempt to vore them into its heal bellies.
On success, the targets are also injected with some helpful chemicals. Just to make sure they don't.. y'know, die while being swallowed.

The mobs icons are modular and interchangeable, there's even a neat verb in the abilities tab when player controlled to pick and choose what you want.
Otherwise, when naturally spawned, their icons are picked from a curated list.

I think I covered everything.
*/

///
///		Main type
///

/mob/living/simple_mob/vore/bigdragon
	name = "large dragon"
	desc = "A large, intimidating creature reminiscent of the traditional idea of medieval fire breathing lizards."
	catalogue_data = list(/datum/category_item/catalogue/fauna/bigdragon)
	tt_desc = "S Draco Ignis"
	icon = 'icons/mob/vore128x64.dmi'
	icon_state = "dragon_maneNone"	//Invisible, necessary for examine stuff
	icon_rest = "dragon_maneNone"
	icon_living = "dragon_maneNone"
	player_msg = "You can perform a charge attack by disarm intent clicking somewhere. Grab intent clicking will perform a tail sweep and fling any nearby mobs. You can fire breath with harm intent. Your attacks have cooldowns associated with them. You can heal slowly by resting. Check your abilities tab for other functions!"
	meat_amount = 40
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	old_x = -48
	old_y = 0
	vis_height = 92
	melee_damage_lower = 35
	melee_damage_upper = 25
	melee_miss_chance = 0
	melee_attack_delay = 0
	friendly = list("nudges", "sniffs on", "rumbles softly at", "slobberlicks")
	response_help = "pats"
	response_disarm = "shoves"
	response_harm = "smacks"
	movement_cooldown = 2
	maxHealth = 800
	attacktext = list("slashed")
	see_in_dark = 8
	minbodytemp = 0
	maxbodytemp = 99999
	min_oxy = 0
	heat_resist = 1
	ai_holder_type = /datum/ai_holder/simple_mob/intentional/dragon
	max_buckled_mobs = 1
	mount_offset_y = 32
	mount_offset_x = -16
	can_buckle = 1
	buckle_movable = 1
	buckle_lying = 0
	vore_bump_chance = 50
	vore_pounce_chance = 100
	vore_active = 1
	vore_icons = 2
	vore_capacity = 2
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to snap up"
	icon_dead = "dragon-dead"
	faction = "dragon"
	glow_range = 7
	glow_intensity = 3
	glow_color = "#ED9200"
	say_list_type = /datum/say_list/bigdragon
	devourable = 0	//No
	universal_understand = 1 //So they can hear synth speach
	max_tox = 0 // for virgo3b survivability
	max_co2 = 0 // Also needed for 3b Survivability otherwise it chokes to death

	special_attack_min_range = 1
	special_attack_max_range = 10
	special_attack_cooldown = 80

	plane = ABOVE_MOB_PLANE

	//Dragon vars
	var/notame
	var/norange
	var/nospecial
	var/noenrage
	var/enraged
	var/flametoggle = 1
	var/specialtoggle = 1
	var/gut1
	var/gut2
	var/small = 0
	var/small_icon = 'icons/mob/bigdragon_small.dmi'
	var/small_icon_state = "dragon_small"
	var/flames
	var/firebreathtimer
	var/chargetimer

	tame_items = list(
	/obj/item/weapon/coin/gold = 100,
	/obj/item/stack/material/gold = 100
	)

	//recycling spider lunge with some modifications
	var/charge_warmup = 2 SECOND
	var/charge_sound = 'sound/weapons/spiderlunge.ogg'

	//Modular icons. Lists are referred to when picking styles.

	//Sprites are layered ontop of one-another in order of this list
	var/list/overlay_colors = list(
		"Underbelly" = "#FFFFFF",
		"Body" = "#FFFFFF",
		"Ears" = "#FFFFFF",
		"Mane" = "#FFFFFF",
		"Horns" = "#FFFFFF",
		"Eyes" = "#FFFFFF"
	)
	//If you add any more, it's as easy as adding the icons to these lists
	var/list/underbelly_styles = list(
		"Smooth",
		"Plated"
	)
	var/under
	var/list/body_styles = list(
		"Smooth",
		"Scaled"
	)
	var/body
	var/list/ear_styles = list(
		"Normal"
	)
	var/ears
	var/list/mane_styles = list(
		"None",
		"Shaggy",
		"Dorsalfin"
	)
	var/mane
	var/list/horn_styles = list(
		"Pointy",
		"Curved",
		"Curved2",
		"Jagged",
		"Crown",
		"Skull"
	)
	var/horns
	var/list/eye_styles = list(
		"Normal"
	)
	var/eyes

///
///		Subtypes
///

/mob/living/simple_mob/vore/bigdragon/friendly
	ai_holder_type = /datum/ai_holder/simple_mob/healbelly/retaliate/dragon
	desc = "A large, intimidating creature reminiscent of the traditional idea of medieval fire breathing lizards. This one seems particularly relaxed and jovial."
	faction = "neutral"
	player_msg = "You're a variant of the large dragon stripped of its firebreath attack (harm intent). You can still charge (disarm) and tail sweep (grab). Rest to heal slowly. Check your abilities tab for functions."
	norange = 1
	noenrage = 1
	nom_mob = TRUE

// Weakened variant for maintpreds
/mob/living/simple_mob/vore/bigdragon/friendly/maintpred
	name = "lesser dragon"
	desc = "A large, intimidating creature reminiscent of the traditional idea of medieval fire breathing lizards. This one seems weaker than the rest."
	player_msg = "You're a nerfed variant of the large dragon with reduced health, reduced melee damage and your special attacks disabled. Resting will heal you slowly over time. Check abilities tab for functions."
	nospecial = 1
	maxHealth = 200
	melee_damage_lower = 20
	melee_damage_upper = 15

///
///		Misc define stuff
///

/datum/say_list/bigdragon
	speak = list("Rhf.", "Hrff.", "Grph.", "Rhrrr.")
	emote_hear = list("chuffs", "rawrs", "wehs", "roars", "scoffs", "yawns")
	emote_see = list("licks their chops", "stretches", "yawns", "snarls")
	say_maybe_target = list("Hrmph?")
	say_got_target = list("FOOL.", "+INSOLENT+.", "YOU'VE MADE A MISTAKE TODAY.")

/datum/category_item/catalogue/fauna/bigdragon
	name = "Invasive Fauna - Large Dragon"
	desc = "Classification: S Draco Ignis\
	<br><br>\
	Dragons have long since been a familiar species across the frontier,\
	with origins tracing them all the way back to originating somewhere within the Sol system.\
	While they are in no way an uncommon species in modern times, their innate nomadic and often times hermited tendancies make discovery of \
	all their evolutionary forks troubling.\
	<br>\
	Some have long since evolved to intergrate well within our definitions of society as a whole, while others, such as this one, have maintained a \
	far more \"traditonal\" way of life, in line with ancient history dictating them to be long lifed hermits with great hoardes of wealth. \
	This is not to say that all variants prefer this lifestyle, of course. \
	<br>\
	These dragons, unlike their cousins, have evolved to remain quadrupedal in likeness of their origins. Though some have evolved the necessary opposable grip \
	necessary for tool manipulation.\
	<br>\
	If uptaking a threatening, imposing stance, it is rumoured that these Dragons can be woo'd or otherwise distracted by offering them an item that could be added to their hoard.\
	The most common example of this being gold coins and ingots."
	value = CATALOGUER_REWARD_SUPERHARD //Scan range is the same as flame breath range. Good luck.

/mob/living/simple_mob/vore/bigdragon/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	verbs |= /mob/living/simple_mob/vore/bigdragon/proc/set_style
	verbs |= /mob/living/simple_mob/vore/bigdragon/proc/toggle_glow
	verbs |= /mob/living/simple_mob/vore/bigdragon/proc/sprite_toggle
	verbs |= /mob/living/simple_mob/vore/bigdragon/proc/flame_toggle
	verbs |= /mob/living/simple_mob/vore/bigdragon/proc/special_toggle
	//verbs |= /mob/living/simple_mob/vore/bigdragon/proc/set_name //Implemented upstream
	//verbs |= /mob/living/simple_mob/vore/bigdragon/proc/set_desc //Implemented upstream
	faction = "neutral"

/mob/living/simple_mob/vore/bigdragon/Initialize()
	..()
	src.adjust_nutrition(src.max_nutrition)
	build_icons(1)
	add_language(LANGUAGE_DRUDAKAR)
	add_language(LANGUAGE_UNATHI)
	mob_radio = new /obj/item/device/radio/headset/mob_headset(src)	//We always give radios to spawned mobs anyway

/mob/living/simple_mob/vore/bigdragon/MouseDrop_T(mob/living/M, mob/living/user)
	return

/mob/living/simple_mob/vore/bigdragon/runechat_y_offset(width, height)
	return (..()*size_multiplier) + 40

/mob/living/simple_mob/vore/bigdragon/death()
	. = ..()
	canceltimers()

///
///		Verbs
///

/mob/living/simple_mob/vore/bigdragon/proc/toggle_glow()
	set name = "Toggle Glow"
	set desc = "Switch between glowing and not glowing."
	set category = "Abilities"

	glow_toggle = !glow_toggle

/mob/living/simple_mob/vore/bigdragon/proc/sprite_toggle()
	set name = "Toggle Small Sprite"
	set desc = "Switches your sprite to a smaller variant so you can see what you're doing. Others will always see your standard sprite instead. "
	set category = "Abilities"

	if(!small)
		var/image/I = image(icon = small_icon, icon_state = small_icon_state, loc = src)
		I.override = TRUE
		var/list/L = list(src)
		src.add_alt_appearance("smallsprite", I, displayTo = L)
		small = TRUE
	else
		src.remove_alt_appearance("smallsprite")
		small = FALSE

/mob/living/simple_mob/vore/bigdragon/proc/flame_toggle()
	set name = "Toggle breath attack"
	set desc = "Toggles whether you will breath attack on harm intent (If you have one)."
	set category = "Abilities"

	if(norange)
		to_chat(src, "<span class='userdanger'>You don't have a breath attack!</span>")
		return

	flametoggle = !flametoggle
	to_chat(src, "<span class='notice'>You will [flametoggle?"now breath":"no longer breath"] attack on harm intent.</span>")

/mob/living/simple_mob/vore/bigdragon/proc/special_toggle()
	set name = "Toggle special attacks"
	set desc = "Toggles whether you will tail spin and charge (If you have them)."
	set category = "Abilities"

	if(nospecial)
		to_chat(src, "<span class='userdanger'>You don't have special attacks!</span>")
		return

	specialtoggle = !specialtoggle
	to_chat(src, "<span class='notice'>You will [specialtoggle?"now special":"no longer special"] attack on grab/disarm intent.</span>")


///
///		Icon generation stuff
///

/mob/living/simple_mob/vore/bigdragon/update_icon()
	update_fullness()
	build_icons()

/mob/living/simple_mob/vore/bigdragon/update_fullness()
	var/new_fullness = 0
	// Only count stomachs to fullness
	for(var/obj/belly/B in vore_organs)
		if(B.name == "Stomach" || B.name == "Second Stomach")
			for(var/mob/living/M in B)
				new_fullness += M.size_multiplier
	new_fullness /= size_multiplier
	new_fullness = round(new_fullness, 1)
	vore_fullness = min(vore_capacity, new_fullness)

/mob/living/simple_mob/vore/bigdragon/proc/build_icons(var/random)
	cut_overlays()
	if(stat == DEAD)
		icon_state = "dragon-dead"
		plane = MOB_LAYER
		return
	if(random)
		var/list/bodycolors = list("#1E1E1E","#3F3F3F","#545454","#969696","#DBDBDB","#ABBBD8","#3D0B00","#3A221D","#77554F","#281D1B","#631F00","#964421","#936B24","#381313","#380000","#682121","#700E00","#44525B","#283035","#29353D","#353E44","#281000","#38261A","#302F3D","#322E3A","#262738")
		under = pick(underbelly_styles)
		overlay_colors["Underbelly"] = pick(bodycolors)
		body = pick(body_styles)
		overlay_colors["Body"] = pick(bodycolors)
		ears = pick(ear_styles)
		overlay_colors["Ears"] = "#[get_random_colour(0, 100, 150)]"
		mane = pick(mane_styles)
		overlay_colors["Mane"] = pick(bodycolors)
		horns = pick(horn_styles)
		var/list/horncolors = list("#000000","#151515","#303030","#606060","#808080","#AAAAAA","#CCCCCC","#EEEEEE","#FFFFFF")
		overlay_colors["Horns"] = pick(horncolors)
		eyes = pick(eye_styles)
		overlay_colors["Eyes"] = "#[get_random_colour(1)]"

	var/image/I = image(icon, "dragon_under[under][resting? "-rest" : (vore_fullness? "-[vore_fullness]" : null)]", pixel_x = -48)
	I.color = overlay_colors["Underbelly"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)

	I = image(icon, "dragon_body[body][resting? "-rest" : null]", pixel_x = -48)
	I.color = overlay_colors["Body"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)

	I = image(icon, "dragon_ears[ears][resting? "-rest" : null]", pixel_x = -48)
	I.color = overlay_colors["Ears"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)

	I = image(icon, "dragon_mane[mane][resting? "-rest" : null]", pixel_x = -48)
	I.color = overlay_colors["Mane"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)

	I = image(icon, "dragon_horns[horns][resting? "-rest" : null]", pixel_x = -48)
	I.color = overlay_colors["Horns"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = MOB_PLANE
	I.layer = MOB_LAYER
	add_overlay(I)

	I = image(icon, "dragon_eyes[eyes][resting? "-rest" : null]", pixel_x = -48)
	I.color = overlay_colors["Eyes"]
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	I.plane = PLANE_LIGHTING_ABOVE
	add_overlay(I)

	if(enraged)
		I = image(icon, "dragon_rage", pixel_x = -48)
		I.appearance_flags |= PIXEL_SCALE
		I.plane = MOB_PLANE
		I.layer = MOB_LAYER
		add_overlay(I)
	if(flames)
		I = image(icon, "dragon_flame[resting? "-rest" : null]", pixel_x = -48)
		I.appearance_flags |= PIXEL_SCALE
		I.plane = PLANE_LIGHTING_ABOVE
		add_overlay(I)

/mob/living/simple_mob/vore/bigdragon/proc/set_style()
	set name = "Set Dragon Style"
	set desc = "Customise your icons."
	set category = "Abilities"

	var/list/options = list("Underbelly","Body","Ears","Mane","Horns","Eyes")
	for(var/option in options)
		LAZYSET(options, option, image('icons/effects/bigdragon_labels.dmi', option))
	var/choice = show_radial_menu(src, src, options, radius = 60)
	if(!choice || QDELETED(src) || src.incapacitated())
		return FALSE
	. = TRUE
	switch(choice)
		if("Underbelly")
			options = underbelly_styles
			for(var/option in options)
				var/image/I = image(icon, "dragon_under[option]", dir = 4, pixel_x = -48)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = input("Pick underbelly color:","Underbelly Color", overlay_colors["Underbelly"]) as null|color
			if(!new_color)
				return 0
			under = choice
			overlay_colors["Underbelly"] = new_color
		if("Body")
			options = body_styles
			for(var/option in options)
				var/image/I = image(icon, "dragon_body[option]", dir = 4, pixel_x = -48)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = input("Pick body color:","Body Color", overlay_colors["Body"]) as null|color
			if(!new_color)
				return 0
			body = choice
			overlay_colors["Body"] = new_color
		if("Ears")
			options = ear_styles
			for(var/option in options)
				var/image/I = image(icon, "dragon_ears[option]", dir = 4, pixel_x = -76, pixel_y = -50)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = input("Pick ear color:","Ear Color", overlay_colors["Ears"]) as null|color
			if(!new_color)
				return 0
			ears = choice
			overlay_colors["Ears"] = new_color
		if("Mane")
			options = mane_styles
			for(var/option in options)
				var/image/I = image(icon, "dragon_mane[option]", dir = 4, pixel_x = -76, pixel_y = -50)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = input("Pick mane color:","Mane Color", overlay_colors["Mane"]) as null|color
			if(!new_color)
				return 0
			mane = choice
			overlay_colors["Mane"] = new_color
		if("Horns")
			options = horn_styles
			for(var/option in options)
				var/image/I = image(icon, "dragon_horns[option]", dir = 4, pixel_x = -86, pixel_y = -50)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = input("Pick horn color:","Horn Color", overlay_colors["Horns"]) as null|color
			if(!new_color)
				return 0
			horns = choice
			overlay_colors["Horns"] = new_color
		if("Eyes")
			options = eye_styles
			for(var/option in options)
				var/image/I = image(icon, "dragon_eyes[option]", dir = 2, pixel_x = -48, pixel_y = -50)
				LAZYSET(options, option, I)
			choice = show_radial_menu(src, src, options, radius = 90)
			if(!choice || QDELETED(src) || src.incapacitated())
				return 0
			var/new_color = input("Pick eye color:","Eye Color", overlay_colors["Eyes"]) as null|color
			if(!new_color)
				return 0
			eyes = choice
			overlay_colors["Eyes"] = new_color
	if(.)
		build_icons()

///
///		Vore stuff
///
///	My thanks to Raeschen for these descriptions

/mob/living/simple_mob/vore/bigdragon/init_vore()
	var/obj/belly/B = new /obj/belly/dragon/maw(src)
	B.emote_lists[DM_HOLD] = list(
		"The dragon's breath continues to pant over you rhythmically, each exhale carrying a bone-shivering growl",
		"The thick, heavy tongue lifts, curling around you, cramming you tightly against it's teeth, to squeeze some flavor out of you.",
		"For a moment, you find yourself slipping underneath the tongue, into the plush silky space beneath. After a momentary squirm, the tongue scoops you back atop itself, twice as slimy as before.",
		"The vast tongue quivers, inching you up close to it's gaping gullet. The slick hatch squeezes on a limb of yours, giving it a plush, sloppy, inviting tug...",
		"Nestled atop the muscle, an array of deep, dull muffled glrrrgles echo up the beast's gullet, a gastric siren-song calling out for you.")
	gut1 = B
	vore_selected = B
	B = new /obj/belly/dragon/throat(src)
	B.emote_lists[DM_HOLD] = list(
		"Gggllrrrk! Another loud, squelching swallow rings out in your ears, dragging you a little deeper into the furnace-like humid heat of the dragon's body.",
		"Nestling in a still throat for a moment, you feel the walls quiver and undulate excitedly in tune with the beast's heartbeat.",
		"A particularly lengthy moment between swallows passes. Perhaps the beast has calmed? Perhaps you might be able to squir-Gggglllk. Squelch. Deeper into the abyss you slide. No escape, probably.",
		"The throat closes in tightly, utterly cocooning you with it's silken spongey embrace. Like this it holds, until you feel like you might pass out... eventually, it would shlllrrk agape and loosen up all around you once more, the beast not wanting to lose the wriggly sensation of live prey.",
		"Blrrbles and squelching pops from it's stomach echo out below you. Each swallow brings greater clarity to those digestive sounds, and stronger acidity to the muggy air around you, inching you closer to it's grasp. Not long now.")
	B = new /obj/belly/dragon/stomach(src)
	B.emote_lists[DM_DIGEST] = list(
		"The stomach walls spontaneously contract! Those wavey, fleshy walls binding your body in their embrace for the moment, slathering you with thick, caustic acids.",
		"You hear a soft rumbling as the dragon’s insides churn around your body, the well-used stomach walls shuddering with a growl as you melt down.",
		"The stomach squishes and squelches over your body, the growling and grumbling of those bowels kneading you into submission like a deafening orchestra. Gradually melting you down into something easier to manage",
		"As your body breaks down into this beasts lunch you feel the walls compress tighter and tighter every moment pressing a crushing weight on your form.",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The drake happily wanders around while digesting its meal, almost like it is trying to show off the hanging gut you've given it.")
	B = new /obj/belly/dragon/maw/heal(src)
	B.emote_lists[DM_HEAL] = list(
		"Gently, the dragon's hot, bumpy tongue cradles you, feeling like a slime-soaked memory-foam bed, twitching with life. The delicacy that the dragon holds you with is quite soothing.",
		"The wide, slick throat infront of you constantly quivers and undulates. Every hot muggy exhale of the beast makes that throat spread, ropes of slime within it's hold shivering in the flow, inhales causing it to clench up somewhat.",
		"That mighty tongue of the dragon's curls itself into a halfpipe shape, cradling you snugly in it. The sides of the muscle hug your own flanks, forming a bed moulded to your contours. It keeps you well clear of those teeth, carrying you gently up against the ridges of it's palate, right before it's throat.",
		"Rhythmically, the tongue nudges you closer and closer to it's slack slimy gullet. It leaves little gaps in the motions, seemingly chances for you to understand it's intentions and escape if you so wish. Remaining calm would result in slithering yet closer...",
		"Saliva soaks the area all around you thickly, lubricating absolutely everything with the hot liquid. From time to time, the beast carefully shifts the rear of it's tongue to piston a cache of the goop down the hatch. The throat seen clenching tightly shut, the tongue's rear bobbing upwards, before down again - showing off a freshly slime-soaked entrance.")
	gut2 = B
	B = new /obj/belly/dragon/throat/heal(src)
	B.emote_lists[DM_HEAL] = list(
		"The tunnel of the gullet closely wraps around you, mummifying you in a hot writhing embrace of silky flesh. The walls are slick, soaked in a lubricating slime, and so very warm.",
		"The walls around you pulse in time with the dragon's heartbeat, which itself pounds in your ears. Rushing wind of calm breaths fill the gaps, and distant squelches of slimy payloads shifted around by soft flesh echo down below.",
		"A tight squeeze of muscle surrounds you as another glllrk rings out, squelching the slimy mass that is yourself a little deeper into it's bulk. The soothing warmth increases the deeper you slide.",
		"Soothing thrumms from the beast sound out, to try help calm you on your way down. The dragon seems to not want you to panic, using surprisingly gentle intent.",
		"Clenchy embraces rhythmically squelch over you. Spreading outwards, the walls would relent, letting you spread a hot, gooey pocket of space around yourself. You linger, before another undulation of a swallow nudges you further down.")
	B = new /obj/belly/dragon/stomach/heal(src)
	B.emote_lists[DM_HEAL] = list(
		"In tune with the beast's heartbeat, the walls heave and spread all around you. In, tight and close, and then outwards, spreading cobwebs of slime all around.",
		"The thick folds of flesh around you blrrrble and sqllrrch, as the flesh itself secretes more of this strange, pure, goopy liquid, clenching it among it's crevices to squeeze it all over you in a mess.",
		"Smooth, happy rumbles echo all around, the dragon seemingly deriving pleasure from the weight and motions you make within it's depths. The walls roll and churn endlessly, happy to hold on to you as long as you wish to stay.",
		"A soft swaying, like the waves of an ocean, squish you to one side, and then to the other. The dragon's gentle movements seem to sway you side to side, as if in a tight possessive hammock on it's underside.",
		"Nearby, a louder cacophany of gushing glrrrbles, deep dull squelches, and even deeper glrrns call out. This safe pocket of flesh seems to be up close and intimate with the dragon's normal, larger stomach, thus you rest safely spectating the sounds it makes.",
		"The rushing breathing of the beast continues at a slow pace, indicating the calm it has. Holding you like this seems quite enjoyable to them, the chamber's folds just as calm and lazy in their motions of squelching the slimy contents all over your form.")
	.=..()

//Making unique belly subtypes for cleanliness and my sanity
/obj/belly/dragon
	autotransferchance = 50
	autotransferwait = 150
	escapable = 1
	escapechance = 100
	escapetime = 15
	fancy_vore = 1
	contamination_color = "grey"
	contamination_flavor = "Wet"
	vore_verb = "slurp"
	//belly_fullscreen_color = "#711e1e"

/obj/belly/dragon/maw
	name = "Maw"
	desc = "Seizing it's opportunity, the dragon's jaws swoop in to scoop you up off of your feet, giving you a view down your body of the glistening, red interior. Vicious looking jaws hover above you like a guillotine, threatening to sink down into you, though such a thing never arrives. Seems it has a slower fate in store for you, as it guides your body along the bumpy mattress of it's tongue until the lowermost parts of your body press around the entrance of it's wide, quivering throat. The jaws snap shut, trapping you within, though thankfully clear of snagging your body between them. It's vast tongue coming to life, lifting to cram you against the insides of it's teeth and against the cathedral-roof ridges of it's palate - lathering you in hot, oily drool. It's panting, growled breaths gust from that wide, eye-catching hatch at the back, blasting you with murky breath and airborne spittle, presenting itself as a place to get up close and intimate with very, very soon...."
	escapechance = 100
	struggle_messages_inside = list(
		"You wriggle and wrestle for purchase against the tongue. It lifts, cocooning and squeezing you hard between itself and the palate.",
		"Reaching out, you try to pry at the beast's interlocked, mighty teeth. A zig-zag crack of light bleeds in to the maw for a moment, presenting you with your current, slimy state, before clicking shut once more.",
		"You try to wriggle to the very front of the jaws to keep safe from that abyssal gullet. It works for a while, before the tongue scoops you right up close to that slick hatch, presenting you with a view of those dark, undulating, sloppy depths.",
		"You brace your back against the spongey mattress of the tongue, and plant your limbs up against the roof. Straining hard, you try to force the jaws agape. A dull growl increases, blasting you in humid murk and drool the more you strain, your efforts ultimately useless.",
		"Struggling for escape, you find yourself able to slip an arm between the beast's teeth and lips, reaching into the colder outside air. It doesn't take long for the beast's tongue to slither out with it, wrap over the limb, tugging it back inside with a noisy slllrrrp of it's lips.")
	autotransferlocation = "Throat"
	belly_fullscreen = "a_tumby"
	vore_sound = "Insertion1"

/obj/belly/dragon/maw/heal
	name = "Maw."
	desc = "With a surprisingly gentle touch, the dragon's jaws descend over your form, gingerly carrying you up high after seeking a hold on your body. The tongue blankets you intimately to keep you safe from it's toothy, vicious jaws, slithering down your torso, hooking up between legs to take your weight. It's head lifts high on up, tilting level, leaving you sprawled flat on your front atop the thick bumpy mattress of it's tongue - that muscle looming outwards, slathering over the beast's scaly lips, snagging your exterior parts to bring you entirely inside. It's hot, humid, and pretty murky - the maw of such a dangerous beast providing quite a hostile environment - though it's delicacy leads you to wonder how much danger you are really in. Urgent pat-pats of it's tongue against your rear usher you closer to it's throat, as the beast makes a soft, concerned rumble at you, trying to get you to slide down. It's gentle touch leaves you aware of just how easy it would be to wriggle free and escape."
	digest_mode = DM_HEAL
	mode_flags = DM_FLAG_NUMBING
	struggle_messages_inside = list(
		"Wriggling around and resisting the beast's efforts to gently devour you, makes them call out to you with a deeply concerned rhhhrrrl. It sounds like it's trying to reassure you, though it seems to relent and let you pry the jaws agape to attempt to slide yourself free.")
	autotransferlocation = "Throat."
	human_prey_swallow_time = 40	//Probably should eat people quick if they're dying

/obj/belly/dragon/throat
	name = "Throat"
	transferchance = 20
	transferlocation = "Maw"
	escapechance = 0
	desc = "...And that 'very, very soon' rapidly becomes 'now'. The mighty tongue lifts, having collected enough of your flavor, squelching your lower body up to your chest inside it's hot gullet, giving you an ample view of itself slithering up over your body. You get to watch it quiver and clench with a resounding glllk, around you, the tongue's fat bumpy rear lifting behind your head to displace you down and inside the clinging tunnel. Tight, crushing pressure embraces you with each of those deep, liquid-sounding swallows, inching you down little by little each time. The flesh of the tunnel wraps you tightly, leaving you mostly unable to move, given short moments of respite between each swallow, to listen to the thudding heartbeat and the distant glrrrbles deep below. The hot scent of acidity grows stronger, the deeper you plunge..."
	struggle_messages_inside = list(
		"With as much effort as you can muster, you squirm and writhe, trying to swim up the passage of soft flesh. You barely peek out the beast's gullet, before the back of it's tongue squelches into your face, forcing you back down.",
		"You struggle and press outwards firmly against the walls. The beast rumbles out over you, shaking you to your bones. Was that a sound of pleasure from the dragon? Perhaps more of this struggling might appease it...",
		"Bracing your back against a wall, you try to press outwards with all the strength you have, to spread the throat agape. For a moment, it affords you a nice view down your body, towards the sealed muscular entryway to it's stomach. Everything clenches back shut around you shortly after.",
		"More squirming and struggling outwards, trying to hold the throat's muscular walls at bay. Every time you press outwards, the walls press back with twice the strength. Much more of this and it might threaten to crush. Perhaps you should just give in...",
		"You frantically writhe upwards a couple of inches, before the beast swallows with a sloppy-sounding glllggk, sending you back down a foot or so. Each struggle you make only seems to hasten your journey down the hatch. ")
	autotransferlocation = "Stomach"
	belly_fullscreen = "another_tumby"
	vore_sound = "Tauric Swallow"


/obj/belly/dragon/throat/heal
	name = "Throat."
	desc = "Giving in to the beast's gentle ministrations, you let yourself get slowly urged forward by the fat tongue, squelched cheek-first against the hot, wet back of it's throat, the gullet guiding you down and inside. Schllorp! You descend into  the jelly-like folds of the dragon's quivering gullet, rhythmic periastaltic motions helping to suckle and drag you inside. the last of your body slides off of it's tongue, the rear of that muscle lifting up against the last of you to help squelch you down. Each swallow leaves a little time inbetween, and the pace down the hatch is slow and gentle - you feel like resistance and squirms would defeat this pace and have you slithering back up the way you came."
	escapechance = 0
	transferchance = 100
	transferlocation = "Maw."
	digest_mode = DM_HEAL
	mode_flags = DM_FLAG_NUMBING
	struggle_messages_inside = list(
		"Writhing firmly inside the tunnel, you try to 'swim' back up the way you came. The swallows relent, and the beast croons softly at you - the walls of the throat tensing to allow for better grip. Slowly but surely, you start wriggling back up towards the dragon's jaws, the beast seeming to permit the action.")
	autotransferlocation = "Second Stomach"

/obj/belly/dragon/stomach
	name = "Stomach"
	escapechance = 0
	transferchance = 10
	transferlocation = "Throat"
	desc = "The final part of your journey arrives, in the form of a tightly squelched, muscular sphincter. Throat pressure crams against you, until abruptly, you find yourself spat into a hot, caustic cauldron of churning doom, the dragon's stomach. After slithering in, the way you entered squelches shut, dissapearing among the folds - impossible for you to find any more. You are trapped, no way out, lounging in a shallow pool of thick sticky juices. endless undulations from thick, pendulous folds of stomach-wall all around continually churn it up into a foamy, bubbling mess, soaking their folds in it to drip in ropes and even shivering sheets of the stuff around you. Clenches gush the digestive slimes all over you from time to time, cradling you in it's noxious embrace. Your ears are filled with such sloppy squelches now, those distant muffled glrrns you heard earlier now sharp, crisp, and thunderous as you nestle in their very source. Settle down for what little time you have left, for your fate rests adding to the powerful beast all around you."
	digest_mode = DM_DIGEST
	digest_brute = 0
	digest_burn = 2
	struggle_messages_inside = list(
		"Eager to try and escape before you lack the strength to do so anymore, you pound firmly against those walls. They clench in twice as hard, the beast letting out a pleased rumble. Seems it wants you to do that again!",
		"You try to stand inside the clinging gut, to force your arms and head upwards towards the way you came in. Searching through each and every fold for the muscled entryway leaves you discovering nothing but caches of goop, soaking over you all the more.",
		"You press all your limbs out firmly into the walls to try and struggle. The softness of the flesh simply envelops over each of them, giving them a close kneading snuggle in hot oily goop.",
		"Each squirm and struggle you try to make just makes the beast rumble deeply in pleasure. It wriggles itself, sloshing and shaking you about, to try goad you into struggling all the more.",
		"Yet more frantic wriggling and squirming from you, pressing and thumping out into walls which themselves greedily devour all the effort you make into them. this deep inside, it doesn't appear to be helping.")
	belly_fullscreen = "da_tumby"
	vore_sound = "Stomach Move"

/obj/belly/dragon/stomach/heal
	name = "Second Stomach"
	desc = "You've kept yourself surrendered and let the beast get you this far, and now you find yourself squelching into the puffy, pillowy clutches of a rather tight chamber, spat slowly inside from the last portion of the gullet. It's pretty cramped in here, though the sheer squishiness of the walls allows you to stretch yourself out into them. Nothing but doughy texture for inches, even feet, deep into the walls. The chamber secretes a thick, clear slime all over you, the walls churning and lathering every single part of you lovingly in it's embrace. Its incessant, kneading affections seems reminiscent of the digestive processes, yet you feel no tingle from the liquid. To the contrary, any injuries or cuts you have, seem to buzz and heat up on touch with the liquids, closing up and healing over at a visibly rapid pace. This hidden space inside the beast seems to be dedicated to holding and healing things within it! The air, although humid and murky, is very breathable in here, though nearby - very close to you, is the constant squelch and churn of the standard processes of the dragon's digestive system. Seems you are right next door to a place you could of gone to! The path you entered remains visible among the undulating squelch of padded walls, and you feel that it wouldn't be too hard to writhe yourself back up into it's snug embrace."
	escapechance = 0
	transferchance = 100
	transferlocation = "Throat."
	digest_mode = DM_HEAL
	mode_flags = DM_FLAG_NUMBING
	struggle_messages_inside = list(
		"Deciding that you've stayed long enough, you wriggle and writhe, stretching yourself out in the chamber, trying to thrust your hands and face up the way you entered. The beast stirs, and this churny pocket of flesh providing you safety clenches hard, aiding your entry back up into the lowermost depths of it's gullet. rhythmic clenches continue to invite you back down, however, should you reconsider.")
	belly_fullscreen = "anim_belly"

///
///		AI handling stuff
///

/datum/ai_holder/simple_mob/intentional/dragon
	intelligence_level = 3
	mauling = 1
	var/yeet_range = 2
	var/yeet_threshold = 2
	var/charge_max = 5

/mob/living/simple_mob/vore/bigdragon/handle_special()
	if(!noenrage)
		if(!enraged)
			if(health <= (maxHealth * 0.5))
				enraged = 1
				say("No more games. COME HERE.")
		if(enraged)
			if(health >= (maxHealth * 0.5))
				enraged = 0
	if(resting)	//Give them a way to slowly heal over time while player controlled
		adjustBruteLoss(-2.5)
		adjustFireLoss(-2.5)
		adjustToxLoss(-5)
		adjustOxyLoss(-5)

/datum/ai_holder/simple_mob/intentional/dragon/pre_special_attack(atom/A)
	if(isliving(A))
		var/mob/living/target = A
		var/tally = 0
		var/list/potential_targets = list_targets()
		//Spin attack if surrounded
		for(var/atom/movable/AM in potential_targets)
			if(get_dist(holder, AM) > yeet_range)
				continue
			if(!can_attack(AM))
				continue
			tally++
		if(tally >= yeet_threshold)
			holder.a_intent = I_GRAB
			return

		//Charge attack if target is far away, but not if there's no line of sight
		if(get_dist(holder, target) > charge_max)
			if(target in check_trajectory(target, holder, pass_flags = PASSTABLE))
				holder.a_intent = I_DISARM
				return

	//Default to firebreath if we can't charge or yeet
	holder.a_intent = I_HURT

/mob/living/simple_mob/vore/bigdragon/do_special_attack(atom/A)
	. = TRUE
	switch(a_intent)
		if(I_DISARM)
			if(!nospecial)
				if(specialtoggle)
					chargestart(A)
		if(I_HURT)
			if(!norange)
				if(flametoggle)
					firebreathstart(A)
		if(I_GRAB)
			if(!nospecial)
				if(specialtoggle)
					repulse()

///
///		AI handling stuff
///
// It hurts me a little to make these mob specific procs instead of effects that can be invoked by any mob, but I'm too lazy to go fix mob attacks like that.
/mob/living/simple_mob/vore/bigdragon/proc/repulse(var/range = 2)
	var/list/thrownatoms = list()
	for(var/mob/living/victim in oview(range, src))
		thrownatoms += victim
	src.spin(12,1)
	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == src || AM.anchored)
			continue
		addtimer(CALLBACK(src, PROC_REF(yeet), am), 1)
	playsound(src, "sound/weapons/punchmiss.ogg", 50, 1)

//Split repulse into two parts so I can recycle this later
/mob/living/simple_mob/vore/bigdragon/proc/yeet(var/atom/movable/AM, var/gentle = 0)
	var/maxthrow = 7
	var/atom/throwtarget
	var/distfromcaster
	throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(AM, src)))
	distfromcaster = get_dist(src, AM)
	if(distfromcaster == 0)
		if(isliving(AM))
			var/mob/living/M = AM
			M.Weaken(5)
			if(!gentle)
				M.adjustBruteLoss(50)	//A dragon just slammed ontop of you
			to_chat(M, "<span class='userdanger'>You're slammed into the floor by [src]!</span>")
	else
		if(isliving(AM))
			var/mob/living/M = AM
			M.Weaken(1.5)
			if(!gentle)
				M.adjustBruteLoss(20)
			to_chat(M, "<span class='userdanger'>You're thrown back by [src]!</span>")
			playsound(src, get_sfx("punch"), 50, 1)
		AM.throw_at(throwtarget, maxthrow, 3, src)

/mob/living/simple_mob/vore/bigdragon/proc/chargestart(var/atom/A)
	if(!enraged)
		set_AI_busy(TRUE)

	do_windup_animation(A, charge_warmup)
	//callbacks are more reliable than byond's process scheduler
	chargetimer = addtimer(CALLBACK(src, PROC_REF(chargeend), A), charge_warmup, TIMER_STOPPABLE)


/mob/living/simple_mob/vore/bigdragon/proc/chargeend(var/atom/A, var/explicit = 0, var/gentle = 0)
	//make sure our target still exists and is on a turf
	if(QDELETED(A) || !isturf(get_turf(A)))
		set_AI_busy(FALSE)
		return
	status_flags |= LEAPING
	flying  = 1		//So we can thunk into things
	hovering = 1	// So we don't hurt ourselves running off cliffs
	visible_message(span("danger","\The [src] charges at \the [A]!"))
	throw_at(A, 7, 2)
	playsound(src, charge_sound, 75, 1)
	if(status_flags & LEAPING)
		status_flags &= ~LEAPING
	flying = 0
	hovering = 0

	var/mob/living/target = null
	if(explicit)	//Allows specific targetting
		if(Adjacent(A))
			target = A
	if(!target)
		for(var/mob/living/victim in orange(1, src))
			target = victim
			break	//take the first target in range
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.check_shields(0, src, src, null, "the charge"))
			return // We were blocked.
	if(target)
		yeet(target, gentle)
	set_AI_busy(FALSE)

/mob/living/simple_mob/vore/bigdragon/proc/firebreathstart(var/atom/A)
	glow_toggle = 1
	set_light(glow_range, glow_intensity, glow_color) //Setting it here so the light starts immediately
	if(!enraged)
		set_AI_busy(TRUE)
	flames = 1
	build_icons()
	firebreathtimer = addtimer(CALLBACK(src, PROC_REF(firebreathend), A), charge_warmup, TIMER_STOPPABLE)
	playsound(src, "sound/magic/Fireball.ogg", 50, 1)

/mob/living/simple_mob/vore/bigdragon/proc/firebreathend(var/atom/A)
	//make sure our target still exists and is on a turf
	if(QDELETED(A) || !isturf(get_turf(A)))
		set_AI_busy(FALSE)
		return
	var/obj/item/projectile/P = new /obj/item/projectile/bullet/dragon(get_turf(src))
	src.visible_message("<span class='danger'>\The [src] spews fire at \the [A]!</span>")
	playsound(src, "sound/weapons/Flamer.ogg", 50, 1)
	P.launch_projectile(A, BP_TORSO, src)
	set_AI_busy(FALSE)
	glow_toggle = 0
	flames = 0
	build_icons()

/obj/item/projectile/bullet/dragon
	use_submunitions = 1
	only_submunitions = 1 	//lmao this var doesn't even do anything
	range = 0				//so instead we circumvent it with this :^)
	embed_chance = 0
	submunition_spread_max = 300
	submunition_spread_min = 150
	submunitions = list(/obj/item/projectile/bullet/incendiary/dragonflame = 5)

/obj/item/projectile/bullet/dragon/on_range()
	qdel(src)

/obj/item/projectile/bullet/incendiary/dragonflame
	name = "dragon flame"
	icon_state = null
	damage = 30
	embed_chance = 0
	accuracy = 100	//This is a bullet facading as a swathe of fire, how's a wall of fire gonna miss huh?
	speed = 2
	incendiary = 2
	flammability = 2
	range = 12
	penetrating = 5
	var/fire_stacks = 1

//Making it so fire passes through mobs but not walls
/obj/item/projectile/bullet/incendiary/dragonflame/check_penetrate(var/atom/A)
	if(!A || !A.density) return 1

	if(istype(A, /obj/mecha))
		return 1

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		return 1

/obj/item/projectile/bullet/incendiary/dragonflame/on_range()
	qdel(src)

/obj/item/projectile/bullet/incendiary/dragonflame/Move()
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		new /obj/effect/decal/cleanable/liquid_fuel(T,0.2,1)
		T.hotspot_expose(500, 50, 1)
		T.create_fire(700)

//Snowflake on_hit so the bullet can set both mobs and carbons on fire, but still let carbons stop drop and roll out the fire stacks.
/obj/item/projectile/bullet/incendiary/dragonflame/on_hit(atom/target, blocked = 0, def_zone)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.IgniteMob()
	else
		. = ..()

/mob/living/simple_mob/vore/bigdragon/do_tame(var/obj/O, var/mob/user)
	if(!user)
		return
	if(faction == "neutral")
		return	//We're already friendly
	if(enraged || notame)
		say("NO FORGIVENESS")
		return //No talk me I angy

	handle_tame_item(O, user)

	qdel(ai_holder)	//Dragon goes to therapy
	faction = "neutral"
	norange = 1		//Don't start fires while friendly
	vore_selected = gut2 //Just incase it eats someone right after being tamed
	ai_holder = new /datum/ai_holder/simple_mob/healbelly/retaliate/dragon(src)

	//Cancel any charges or firebreaths winding up
	canceltimers()

/datum/ai_holder/simple_mob/healbelly
	intelligence_level = 3
	can_breakthrough = 0
	var/vocal = 1
	var/last_speak

/datum/ai_holder/simple_mob/healbelly/retaliate
	retaliate = 1

//dragon variant that'll swap back to hostile if pissed off
/datum/ai_holder/simple_mob/healbelly/retaliate/dragon
	var/warnings = 0
	var/last_warning

/datum/ai_holder/simple_mob/healbelly/proc/confirmPatient(var/mob/living/P)
	if(istype(holder,/mob/living/simple_mob))
		var/mob/living/simple_mob/H = holder
		if(H.will_eat(P))
			if(issilicon(P))
				return
			if(iscarbon(P))
				if(P.isSynthetic()) //Sorry robits
					return
			else
				if(!P.client)	//Don't target simple mobs that aren't player controlled
					return
			if(P.stat == DEAD)
				return
			if(P.suiciding)
				return
			if(P.health <= (P.maxHealth * 0.95))	//Nom em'
				if(vocal)
					if(last_speak + 30 SECONDS < world.time)
						var/message_options = list(
							"Hey, [P.name]! You are injured, hold still.",
							"[P.name]! Come here, let me help.",
							"[P.name], you need help."
							)
						var/message = pick(message_options)
						H.say(message)
						last_speak = world.time
					return 1

//Attack overrides to let us """Attack""" allies and heal them
/datum/ai_holder/simple_mob/healbelly/can_attack(atom/movable/the_target, vision_required = 1)
	if(!can_see_target(the_target) && vision_required)
		return

	if(isliving(the_target))
		var/mob/living/L = the_target
		if(ishuman(L) || issilicon(L))
			if(!L.client)	// SSD players get a pass
				return
		if(L.stat)
			if(L.stat == DEAD && !handle_corpse) // Leave dead things alone
				return
		if(isanimal(L))	//Don't attack simplemobs unless they are hostile.
			var/mob/living/simple_mob/M = L
			if(M.client)	//Don't attack players for no reason even if they're a traditionally hostile mob
				return 0
			if(M.nom_mob)	//Don't attack mobs that are hostile for their vore functions to work
				return 0
			if(M.ai_holder)	//Don't attack non-hostile mobs
				if(M.ai_holder.hostile)
					return 1
				else return 0
			else return 0
		if(holder.IIsAlly(L))
			if(confirmPatient(L))
				holder.a_intent = I_HELP
				return 1
			else
				return 0
	holder.a_intent = I_HURT
	return 1

/datum/ai_holder/simple_mob/healbelly/retaliate/dragon/can_attack(atom/movable/the_target, var/vision_required = TRUE)
	if(istype(holder,/mob/living/simple_mob/vore/bigdragon))
		var/mob/living/simple_mob/vore/bigdragon/BG = holder
		if(holder.IIsAlly(the_target))
			BG.vore_selected = BG.gut2	//Nom them into the heal guts
		else
			BG.vore_selected = BG.gut1	//Gurgle them if not
	return .=..()

/datum/ai_holder/simple_mob/healbelly/melee_attack(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(holder.a_intent == I_HELP)
			var/mob/living/simple_mob/H = holder
			if(H.will_eat(L))
				H.PounceTarget(L)
				//The following is some reagent injections to cover our bases, since being swallowed and dying from internal injuries sucks
				//If this ends up being op because medbay gets replaced by a voremob buckled to a chair, feel free to remove some.
				//Alternatively bully a coder (me) to make a unique digest_mode for mob healbellies that prevents death, or something.
				if(istype(A, /mob/living/carbon/human))
					var/mob/living/carbon/human/P = L
					var/list/to_inject = list("myelamine","osteodaxon","spaceacillin","peridaxon", "iron", "hyronalin")
					//Lets not OD them...
					for(var/RG in to_inject)
						if(!P.reagents.has_reagent(RG))
							P.reagents.add_reagent(RG, 10)
				L.ExtinguishMob()
			return //Don't attack people if we're on help intent
	return .=..()


/datum/ai_holder/simple_mob/healbelly/retaliate/dragon/handle_special_strategical()
	if(last_warning + 1 MINUTE < world.time)
		warnings = 0	//calm down

/datum/ai_holder/simple_mob/healbelly/retaliate/dragon/react_to_attack(atom/movable/attacker, ignore_timers = FALSE)
	if(holder.stat)
		return
	if(istype(holder,/mob/living/simple_mob/vore/bigdragon))
		var/mob/living/simple_mob/vore/bigdragon/H = holder
		if(!H.noenrage)
			if(H.IIsAlly(attacker))
				switch(warnings)
					if(0)
						H.say("Stop that.")
					if(1)
						H.say("I'm warning you here.")
					if(2)
						H.say("You do that again, and you'll regret it.")
					if(3)
						H.enrage(attacker)
						return
				last_warning = world.time
				warnings += 1
				dissuade(attacker)
				return
	return .=..()

/mob/living/simple_mob/vore/bigdragon/proc/enrage(var/atom/movable/attacker)
	enraged = 1
	norange = 0
	faction = "dragon"
	say("HAVE IT YOUR WAY THEN")
	qdel(ai_holder)
	var/datum/ai_holder/simple_mob/intentional/dragon/D = new /datum/ai_holder/simple_mob/intentional/dragon(src)
	ai_holder = D
	vore_selected = gut1
	D.give_target(attacker)

/mob/living/simple_mob/vore/bigdragon/proc/canceltimers()
	//Cancel any charges or firebreaths winding up
	if(firebreathtimer)
		deltimer(firebreathtimer)
		firebreathtimer = null
	if(chargetimer)
		deltimer(chargetimer)
		chargetimer = null
	//re-enable the AI
	set_AI_busy(FALSE)

//Smack people it warns
/datum/ai_holder/simple_mob/healbelly/retaliate/dragon/proc/dissuade(var/chump)
	if(chump in check_trajectory(chump, holder, pass_flags = PASSTABLE))
		if(istype(holder,/mob/living/simple_mob/vore/bigdragon))
			var/mob/living/simple_mob/vore/bigdragon/H = holder
			H.chargeend(chump,1,1)
