/mob/living/simple_animal/shadekin //Spawning the prototype spawns a random one, see initialize()
	name = "shadekin"
	desc = "Some sort of fluffer. Big ears, long tail. "
	icon = 'icons/mob/vore_shadekin.dmi'
	icon_state = "map_example"
	icon_living = "map_example"
	faction = "shadekin"
	ui_icons = 'icons/mob/shadekin_hud.dmi'

	maxHealth = 200
	health = 200

	move_to_delay = 2
	speed = -1
	see_in_dark = 10 //SHADEkin
	has_hands = TRUE //Pawbs
	seedarkness = FALSE //SHAAAADEkin
	attack_sound = 'sound/weapons/bladeslice.ogg'
	has_langs = list(LANGUAGE_GALCOM,LANGUAGE_SHADEKIN)

	investigates = TRUE
	reacts = TRUE
	run_at_them = FALSE
	cooperative = FALSE

	melee_damage_lower = 10
	melee_damage_upper = 20

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 900

	speak_chance = 2
	speak = list("Marrr.", "Marrr?", "Marrr!")
	emote_hear = list("chrrrrrs", "wurbles", "wrrrrbles")
	emote_see = list("tailtwitches", "earflicks")
	say_maybe_target = list("...mar?")
	say_got_target = list("MAR!!!")
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("mauled","slashed","clawed")
	friendly = list("boops", "pawbs", "mars softly at", "sniffs on")
	reactions = list("Mar?" = "Marrr!", "Mar!" = "Marrr???", "Mar." = "Marrr.")

	vore_active = TRUE
	vore_pounce_chance = 10
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS
	vore_escape_chance = 25

	//None, they stay as their defaults.
	vore_digest_chance = 0
	vore_absorb_chance = 0
	vore_bump_chance = 0 //They follow people, this would be DENGEROUS

	var/eye_state = RED_EYES //Eye color/energy gain/loss mode
	var/eye_icon_state = "e_red" //Default, changed in init
	var/eye_desc //Eye color description added to examine

	var/mob/living/carbon/human/henlo_human //Human we're stalking currently

	//Behavior
	var/stalker = TRUE //Do we creep up on humans
	var/shy_approach = FALSE //Do we creep up slowly on humans to boop them

	//Icon handling
	var/image/tailimage //Cached tail icon
	var/image/eyeimage //Cached eye icon
	var/prev_fullness = null //Used to avoid needless icon changes when we don't need them

	//Darknesssss
	var/energy = 100 //For abilities
	var/energy_adminbuse = FALSE //For adminbuse infinite energy
	var/dark_gains = 0 //Last tick's change in energy
	var/ability_flags = 0 //Flags for active abilities
	var/obj/screen/darkhud //Holder to update this icon
	var/obj/screen/energyhud //Holder to update this icon

	var/list/shadekin_abilities

/mob/living/simple_animal/shadekin/initialize()
	//You spawned the prototype, and want a totally random one.
	if(type == /mob/living/simple_animal/shadekin)

		//I'm told by VerySoft these are the liklihood values
		var/list/sk_types = list(
			/mob/living/simple_animal/shadekin/red = 20,	//Actively seek people out to nom, so fairly common to see (relatively speaking),
			/mob/living/simple_animal/shadekin/blue = 15,	//Explorers that like to interact with people, so still fairly common,
			/mob/living/simple_animal/shadekin/purple = 15,	//Also explorers that may or may not homf people,
			/mob/living/simple_animal/shadekin/yellow = 1	//Very rare, usually never leaves their home
		)
		var/new_type = pickweight(sk_types)

		new new_type(loc)
		initialized = TRUE
		return INITIALIZE_HINT_QDEL

	if(icon_state == "map_example")
		icon_state = pick("white","dark","brown")

	icon_living = icon_state

	if(eye_desc)
		desc += "This one has [eye_desc]!"

	var/list/ability_types = subtypesof(/obj/effect/shadekin_ability)
	shadekin_abilities = list()
	for(var/type in ability_types)
		shadekin_abilities += new type(src)

	update_icon()

	return ..()

/mob/living/simple_animal/shadekin/Destroy()
	qdel_null_list(shadekin_abilities)
	. = ..()

/mob/living/simple_animal/shadekin/init_vore()
	if(LAZYLEN(vore_organs))
		return

	var/obj/belly/B = new /obj/belly(src)
	vore_selected = B
	B.immutable = 1
	B.name = vore_stomach_name ? vore_stomach_name : "stomach"
	B.desc = vore_stomach_flavor ? vore_stomach_flavor : "Your surroundings are warm, soft, and slimy. Makes sense, considering you're inside \the [name]."
	B.digest_mode = vore_default_mode
	B.escapable = vore_escape_chance > 0
	B.escapechance = vore_escape_chance
	B.digestchance = vore_digest_chance
	B.absorbchance = vore_absorb_chance
	B.human_prey_swallow_time = swallowTime
	B.nonhuman_prey_swallow_time = swallowTime
	B.vore_verb = "swallow"
	// TODO - Customizable per mob
	B.emote_lists[DM_HOLD] = list(
		"The walls gently squeeze against you. The wet sounds of shifting flesh against your form fill the air.",
		"The hot, humid air rushes around you for a moment as the creature urps. The walls clench in around you for a moment, before relaxxing again.",
		"Your body is soaked in the fluids that cling to the churning walls. They squeeze across your form gently, conforming to your shape.",
		"You can feel the world around you shift and sway as the creature moves! The flesh is stretchy, doughy. You can sink into it a little ways before it bounces back, curling you into a small shape."
		)
	B.emote_lists[DM_DIGEST] = list(
		"The walls slop thick slime across your body! It tingles briefly before the sting and ache sets in!",
		"The sound of your body slipping and sliding against the powerfully churning stomach fills the air!",
		"The grip of that stomach is harsh. Eagerly mushing and rubbing that slime into your body in attempts to break you down!",
		"The intense churning and grinding jostles your around within the thick slime as you're slowly broken down!"
		)
	B.emote_lists[DM_ITEMWEAK] = list(
		"The walls slop thick slime across your body! It tingles briefly before the sting and ache sets in!",
		"The sound of your body slipping and sliding against the powerfully churning stomach fills the air!",
		"The grip of that stomach is harsh. Eagerly mushing and rubbing that slime into your body in attempts to break you down!",
		"The intense churning and grinding jostles your around within the thick slime as you're slowly broken down!"
		)
	B.emote_lists[DM_ABSORB] = list(
		"The walls cling to you awfully close... It's almost like you're sinking into them.",
		"You can feel the walls press in tightly against you, clinging to you posessively!",
		"It almost feels like you're sinking into the soft, doughy flesh!",
		"You can feel the walls press in around you. Almost molten, so squishy!!"
		)
	B.emote_lists[DM_DRAIN] = list(
		"The walls churn down on you heavily!! It's hard to move!",
		"You can feel yourself getting weaker with every moment! The doughy walls sap your strength!",
		"You're practically smothered in the oppressive heat of the creature's stomach!",
		"It's hot, wet and tight!"
		)
	B.emote_lists[DM_HEAL] = list(
		"The walls pulse against you almost rhythmically. It feels nice, almost like a massage.",
		"You're gently squeezed in pleasant warmth, softly churned.",
		"The doughy feel of the heavy flesh clinging to you makes you feel a little stronger with every passing moment.",
		"The flesh caresses across your body gently as you're held."
		)
	B.digest_messages_prey = list(
		"Your body is steadily softened more and more over time! Eventually you pass out. The creature's stomach rumbles powerfully as you are reduced to paste, processed for energy!",
		"The creature's slimy gut lets out a heavy groan as you're slowly melted away. Gushing deeper through the creature.",
		"The stinging and aching gives way to numbness as you're slowly smothered out. Your body is steadily reduced to nutrients and energy for the creature to continue on its way.",
		"The chaos of being digested fades as you're snuffed out by a harsh clench! You're steadily broken down into a thick paste, processed and absorbed by the predator!"
		)

/mob/living/simple_animal/shadekin/Life()
	. = ..()
	if(ability_flags & AB_PHASE_SHIFTED)
		density = FALSE
	
	//Convert spare nutrition into energy at a certain ratio
	if(. && nutrition > initial(nutrition) && energy < 100)
		nutrition = max(0, nutrition-5)
		energy = min(100,energy+1)

/mob/living/simple_animal/shadekin/update_icon()
	. = ..()

	if(!tailimage || prev_fullness != vore_fullness)
		prev_fullness = vore_fullness
		tailimage = image('icons/mob/vore_shadekin64.dmi',null,icon_state)
		tailimage.pixel_x = -16
	tailimage.icon_state = icon_state

	if(!eyeimage || !eye_icon_state)
		switch(eye_state)
			if(BLUE_EYES)
				eye_icon_state = "e_blue"
			if(RED_EYES)
				eye_icon_state = "e_red"
			if(PURPLE_EYES)
				eye_icon_state = "e_purple"
			if(YELLOW_EYES)
				eye_icon_state = "e_yellow"
			if(GREEN_EYES)
				eye_icon_state = "e_green"
			if(ORANGE_EYES)
				eye_icon_state = "e_orange"
	eyeimage = image(icon,null,eye_icon_state)

	var/mutable_appearance/ma = new(src)
	ma.overlays += tailimage
	ma.overlays += eyeimage
	appearance = ma

/mob/living/simple_animal/shadekin/Stat()
	. = ..()
	if(statpanel("Shadekin"))
		abilities_stat()

/mob/living/simple_animal/shadekin/proc/abilities_stat()
	for(var/A in shadekin_abilities)
		var/obj/effect/shadekin_ability/ability = A
		stat("[ability.ability_name]",ability.atom_button_text())

//They phase back to the dark when killed
/mob/living/simple_animal/shadekin/death(gibbed, deathmessage = "phases to somewhere far away!")
	overlays = list()
	icon_state = ""
	flick("tp_out",src)
	spawn(1 SECOND)
		qdel(src) //Back from whence you came!

	. = ..(FALSE, deathmessage)

//Blue-eyes want to nom people to heal them
/mob/living/simple_animal/shadekin/Found(var/atom/A)
	if(specific_targets && isliving(A)) //Healing!
		var/mob/living/L = A
		var/health_percent = (L.health/L.maxHealth)*100
		if(health_percent <= 50)
			return A
	. = ..()

//They reach nutritional equilibrium (important for blue-eyes healbelly)
/mob/living/simple_animal/shadekin/Life()
	if((. = ..()))
		handle_shade()

/mob/living/simple_animal/shadekin/proc/handle_shade()
	//Shifted kin don't gain/lose energy (and save time if we're at the cap)
	var/darkness = 1


	var/turf/T = get_turf(src)
	if(!T)
		dark_gains = 0
		return

	var/brightness = T.get_lumcount() //Brightness in 0.0 to 1.0
	darkness = 1-brightness //Invert

	if(ability_flags & AB_PHASE_SHIFTED)
		dark_gains = 0
	else
		//Heal (very) slowly in good darkness
		if(darkness >= 0.75)
			adjustFireLoss(-0.05)
			adjustBruteLoss(-0.05)
			adjustToxLoss(-0.05)

		switch(eye_state)
			//Blue has constant, steady (slow) regen and ignores darkness.
			if(BLUE_EYES)
				dark_gains = 0.5
			//Red has extremely tiny energy buildup in dark, none in light, and hunts for energy.
			if(RED_EYES)
				if(darkness >= 0.75)
					dark_gains = 0.25
			//Purple eyes have moderate gains in darkness and loss in light.
			if(PURPLE_EYES)
				dark_gains = round((darkness - 0.5) * 2, 0.1)
			//Yellow has extreme gains in darkness and loss in light.
			if(YELLOW_EYES)
				dark_gains = round((darkness - 0.5) * 4, 0.1)
			//Similar to blues, but passive is less, and affected by dark
			if(GREEN_EYES)
				dark_gains = 0.25
				dark_gains += round((darkness - 0.5), 0.1)
			//More able to get energy out of the dark, worse attack gains tho
			if(ORANGE_EYES)
				if(darkness >= 0.65)
					dark_gains = 0.30

	energy = max(0,min(initial(energy),energy + dark_gains))

	if(energy_adminbuse)
		energy = 100

	//Update turf darkness hud
	if(darkhud)
		switch(darkness)
			if(0.80 to 1.00)
				darkhud.icon_state = "dark2"
			if(0.60 to 0.80)
				darkhud.icon_state = "dark1"
			if(0.40 to 0.60)
				darkhud.icon_state = "dark"
			if(0.20 to 0.40)
				darkhud.icon_state = "dark-1"
			if(0.00 to 0.20)
				darkhud.icon_state = "dark-2"

	//Update energy storage hud
	if(energyhud)
		switch(energy)
			if(80 to INFINITY)
				energyhud.icon_state = "energy0"
			if(60 to 80)
				energyhud.icon_state = "energy1"
			if(40 to 60)
				energyhud.icon_state = "energy2"
			if(20 to 40)
				energyhud.icon_state = "energy3"
			if(0 to 20)
				energyhud.icon_state = "energy4"

//Friendly ones wander towards people, maybe shy-ly if they are set to shy
/mob/living/simple_animal/shadekin/handle_wander_movement()
	if(isturf(src.loc) && !resting && !buckled && canmove)
		lifes_since_move++
		if(lifes_since_move >= turns_per_move)
			if(!(stop_when_pulled && pulledby))
				var/moving_to

				if(stalker)
					//Sniff sniff.
					var/list/humans = human_mobs(world.view)

					//Can we see the last person we were following?
					if(henlo_human && !(henlo_human in humans))
						henlo_human = null

					//Can we find a new person to follow?
					if(!henlo_human)
						while(!henlo_human && humans.len)
							henlo_human = pick(humans)
							if(!isturf(henlo_human.loc))
								humans -= henlo_human
								henlo_human = null

					//Boopable hunam?
					if(henlo_human)
						moving_to = get_dir(src,henlo_human)

						if((get_dist(src,henlo_human) <= 1))
							dir = moving_to
							if(prob(speak_chance))
								visible_message("<span class='notice'>\The [src] [pick(friendly)] \the [henlo_human].</span>")
								shy_approach = FALSE //ACCLIMATED
							lifes_since_move = 0
							return //No need to move

						if(shy_approach)
							var/them_to_us = turn(moving_to,180)
							if(abs(dir2angle(henlo_human.dir) - dir2angle(them_to_us)) <= 90)
								dir = them_to_us
								return //AAA!

						dir = moving_to

				//Random walk
				if(!moving_to)
					moving_to = pick(cardinal)
					dir = moving_to

				var/turf/T = get_step(src,moving_to)
				if(avoid_turf(T))
					return
				Move(T)
				lifes_since_move = 0

/mob/living/simple_animal/shadekin/speech_bubble_appearance()
	return "ghost"

/mob/living/simple_animal/shadekin/DoPunch(var/atom/A)
	. = ..(A)
	if(isliving(A)) //We punched something!
		var/mob/living/L = A
		if(L.stat != DEAD)
			var/gains = 0
			switch(eye_state)
				if(RED_EYES)
					gains = 8
				if(BLUE_EYES)
					gains = 1
				if(PURPLE_EYES)
					gains = 4
				if(YELLOW_EYES)
					gains = 3
				if(GREEN_EYES)
					gains = 1
				if(ORANGE_EYES)
					gains = 5

			energy += gains

//Special hud elements for darkness and energy gains
/mob/living/simple_animal/shadekin/extra_huds(var/datum/hud/hud,var/icon/ui_style,var/list/hud_elements)
	//Darkness hud
	darkhud = new /obj/screen()
	darkhud.icon = ui_style
	darkhud.icon_state = "dark"
	darkhud.name = "darkness"
	darkhud.screen_loc = "CENTER-2:16,SOUTH:5" //Left of the left hand
	darkhud.alpha = 150
	hud_elements |= darkhud

	//Energy hud
	energyhud = new /obj/screen()
	energyhud.icon = ui_style
	energyhud.icon_state = "energy0"
	energyhud.name = "energy"
	energyhud.screen_loc = "CENTER+1:16,SOUTH:5" //Right of the right hand
	energyhud.alpha = 150
	hud_elements |= energyhud

// When someone clicks us with an empty hand
/mob/living/simple_animal/shadekin/attack_hand(mob/living/carbon/human/M as mob)
	. = ..()
	if(M.a_intent == I_HELP)
		shy_approach = FALSE //ACCLIMATED

/datum/language/shadekin
	name = "Shadekin Empathy"
	desc = "Shadekin seem to always know what the others are thinking. This is probably why."
	colour = "changeling"
	speech_verb = "mars"
	ask_verb = "mars"
	exclaim_verb = "mars"
	key = "m"
	machine_understands = 0
	flags = RESTRICTED | HIVEMIND
