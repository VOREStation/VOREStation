/mob/living/simple_mob/shadekin //Spawning the prototype spawns a random one, see initialize()
	name = "shadekin"
	desc = "Some sort of fluffer. Big ears, long tail."
	catalogue_data = list(/datum/category_item/catalogue/fauna/shadekin)
	icon = 'icons/mob/vore_shadekin.dmi'
	icon_state = "map_example"
	icon_living = "map_example"
	faction = FACTION_SHADEKIN
	ui_icons = 'icons/mob/shadekin_hud.dmi'
	mob_class = MOB_CLASS_HUMANOID
	mob_bump_flag = HUMAN

	maxHealth = 200
	health = 200

	movement_cooldown = -1.5
	see_in_dark = 10 //SHADEkin
	has_hands = TRUE //Pawbs
	seedarkness = FALSE //SHAAAADEkin
	attack_sound = 'sound/weapons/bladeslice.ogg'
	has_langs = list(LANGUAGE_GALCOM, LANGUAGE_SHADEKIN)

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

	say_list_type = /datum/say_list/shadekin

	response_help = "pets"
	response_disarm = "bops"
	response_harm = "hits"

	attacktext = list("mauled","slashed","clawed")
	friendly = list("boops", "pawbs", "mars softly at", "sniffs on")

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
	var/eye_icon_state = null //Default, changed in init
	var/eye_desc //Eye color description added to examine

	var/mob/living/carbon/human/henlo_human //Human we're stalking currently

	//Behavior
	var/stalker = TRUE //Do we creep up on humans
	var/shy_approach = FALSE //Do we creep up slowly on humans to boop them

	//Icon handling
	var/image/tailimage //Cached tail image

	//Darknesssss
	var/datum/component/shadekin/comp = /datum/component/shadekin //Component that holds all the shadekin vars.
	var/dark_gains = 0 //Last tick's change in energy
	var/ability_flags = 0 //Flags for active abilities

	var/list/shadekin_abilities
	var/check_for_observer = FALSE
	var/check_timer = 0
	var/doing_phase = FALSE // Prevent bugs when spamming phase button

/mob/living/simple_mob/shadekin/Initialize(mapload)
	//You spawned the prototype, and want a totally random one.
	if(type == /mob/living/simple_mob/shadekin)

		//I'm told by VerySoft these are the liklihood values
		var/list/sk_types = list(
			/mob/living/simple_mob/shadekin/red = 20,	//Actively seek people out to nom, so fairly common to see (relatively speaking),
			/mob/living/simple_mob/shadekin/blue = 15,	//Explorers that like to interact with people, so still fairly common,
			/mob/living/simple_mob/shadekin/purple = 15,	//Also explorers that may or may not homf people,
			/mob/living/simple_mob/shadekin/green = 5,
			/mob/living/simple_mob/shadekin/yellow = 1	//Very rare, usually never leaves their home
		)
		var/new_type = pickweight(sk_types)

		new new_type(loc)
		flags |= ATOM_INITIALIZED
		return INITIALIZE_HINT_QDEL
	comp = LoadComponent(comp)
	set_eye_energy()

	if(icon_state == "map_example")
		icon_state = pick("white","dark","brown")

	icon_living = icon_state

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
		else
			eye_icon_state = "e_red"

	tailimage = image('icons/mob/vore_shadekin64.dmi',null,icon_state)
	tailimage.pixel_x = -16

	if(eye_desc)
		desc += " This one has [eye_desc]!"

	update_icon()

	add_verb(src, /mob/proc/adjust_hive_range)

	return ..()

/mob/living/simple_mob/shadekin/Destroy()
	QDEL_LIST_NULL(shadekin_abilities)
	. = ..()

/mob/living/simple_mob/shadekin/init_vore()
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return

	var/obj/belly/B = new /obj/belly(src)
	vore_selected = B
	B.immutable = 1
	B.affects_vore_sprites = TRUE
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
		"The hot, humid air rushes around you for a moment as the creature urps. The walls clench in around you for a moment, before relaxing again.",
		"Your body is soaked in the fluids that cling to the churning walls. They squeeze across your form gently, conforming to your shape.",
		"You can feel the world around you shift and sway as the creature moves! The flesh is stretchy, doughy. You can sink into it a little ways before it bounces back, curling you into a small shape."
		)
	B.emote_lists[DM_DIGEST] = list(
		"The walls slop thick slime across your body! It tingles briefly before the sting and ache sets in!",
		"The sound of your body slipping and sliding against the powerfully churning stomach fills the air!",
		"The grip of that stomach is harsh. Eagerly mushing and rubbing that slime into your body in attempts to break you down!",
		"The intense churning and grinding jostles your around within the thick slime as you're slowly broken down!"
		)
	B.emote_lists[DM_ABSORB] = list(
		"The walls cling to you awfully close... It's almost like you're sinking into them.",
		"You can feel the walls press in tightly against you, clinging to you possessively!",
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
	. = ..()

/mob/living/simple_mob/shadekin/Life()
	. = ..()
	if(comp.in_phase)
		density = FALSE

	//Convert spare nutrition into energy at a certain ratio
	if(. && nutrition > initial(nutrition) && comp.dark_energy < 100)
		nutrition = max(0, nutrition-5)
		comp.dark_energy = min(100,comp.dark_energy+1)
	if(!client && check_for_observer && check_timer++ > 5)
		check_timer = 0
		var/non_kin_count = 0
		for(var/mob/living/M in view(6,src))
			if(!issimplekin(M))
				non_kin_count ++
		// Technically can be combined with ||, they call the same function, but readability is poor
		if(!non_kin_count && (comp.in_phase))
			phase_shift() // shifting back in, nobody present
		else if (non_kin_count && !(comp.in_phase))
			phase_shift() // shifting out, scaredy

/mob/living/simple_mob/shadekin/update_icon()
	. = ..()

	cut_overlay(tailimage)

	tailimage.icon_state = icon_state

	add_overlay(tailimage)
	add_overlay(eye_icon_state)

//They phase back to the dark when killed
/mob/living/simple_mob/shadekin/death(gibbed, deathmessage = "phases to somewhere far away!")
	var/special_handling = FALSE //varswitch for downstream
	if(!special_handling)
		cut_overlays()
		icon_state = ""
		flick("tp_out",src)
		QDEL_IN(src, 1 SECOND)
		. = ..(FALSE, deathmessage)
	else
		if(comp.respite_activating)
			return
		cut_overlays()
		flick("tp_out",src)

		var/area/current_area = get_area(src)
		if((comp.in_dark_respite) || current_area.flag_check(AREA_LIMIT_DARK_RESPITE))
			icon_state = ""
			spawn(1 SECOND)
				qdel(src) //Back from whence you came!

			return ..(FALSE, deathmessage)


		if(!LAZYLEN(GLOB.latejoin_thedark))
			log_and_message_admins("[src] died outside of the dark but there were no valid floors to warp to")
			icon_state = ""
			spawn(1 SECOND)
				qdel(src) //Back from whence you came!

			return ..(FALSE, deathmessage)

		visible_message("<b>\The [src.name]</b> [deathmessage]")
		comp.respite_activating = TRUE

		drop_l_hand()
		drop_r_hand()

		comp.dark_energy = 0
		comp.in_dark_respite = TRUE
		invisibility = INVISIBILITY_LEVEL_TWO

		adjustFireLoss(-(getFireLoss() / 2))
		adjustBruteLoss(-(getBruteLoss() / 2))
		adjustToxLoss(-(getToxLoss() / 2))
		Stun(10)
		movement_cooldown = 5
		nutrition = 0

		if(istype(src.loc, /obj/belly))
			//Yay digestion... presumably...
			var/obj/belly/belly = src.loc
			add_attack_logs(belly.owner, src, "Digested in [lowertext(belly.name)]")
			to_chat(belly.owner, span_notice("\The [src.name] suddenly vanishes within your [belly.name]"))
			forceMove(pick(GLOB.latejoin_thedark))
			flick("tp_in",src)
			comp.respite_activating = FALSE
			comp.in_dark_respite = TRUE
			belly.owner.handle_belly_update()
			clear_fullscreen("belly")
			if(hud_used)
				if(!hud_used.hud_shown)
					toggle_hud_vis()
			stop_sound_channel(CHANNEL_PREYLOOP)

			addtimer(CALLBACK(src, PROC_REF(can_leave_dark)), 10 MINUTES, TIMER_DELETE_ME)
		else
			addtimer(CALLBACK(src, PROC_REF(enter_the_dark)), 1 SECOND, TIMER_DELETE_ME)
			addtimer(CALLBACK(src, PROC_REF(can_leave_dark)), 15 MINUTES, TIMER_DELETE_ME)

/mob/living/simple_mob/shadekin/enter_the_dark()
	comp.respite_activating = FALSE
	comp.in_dark_respite = TRUE

	forceMove(pick(GLOB.latejoin_thedark))
	update_icon()
	flick("tp_in",src)
	invisibility = initial(invisibility)
	comp.respite_activating = FALSE

/mob/living/simple_mob/shadekin/can_leave_dark()
	comp.in_dark_respite = FALSE
	movement_cooldown = initial(movement_cooldown)
	to_chat(src, span_notice("You feel like you can leave the Dark again"))


/* //VOREStation AI Temporary Removal
//Blue-eyes want to nom people to heal them
/mob/living/simple_mob/shadekin/Found(var/atom/A)
	if(specific_targets && isliving(A)) //Healing!
		var/mob/living/L = A
		var/health_percent = (L.health/L.getMaxHealth())*100
		if(health_percent <= 50 && will_eat(A))
			return A
	. = ..()
*/

//They reach nutritional equilibrium (important for blue-eyes healbelly)
/mob/living/simple_mob/shadekin/Life()
	if((. = ..()))
		comp.handle_comp()

/mob/living/simple_mob/shadekin/proc/set_eye_energy()
	switch(eye_state)
		//Blue has constant, steady (slow) regen and ignores darkness.
		if(BLUE_EYES)
			comp.set_light_and_darkness(0.75,0.75)
			comp.nutrition_conversion_scaling = 0.5
		if(RED_EYES)
			comp.set_light_and_darkness(-0.5,0.5)
			comp.nutrition_conversion_scaling = 2
		if(PURPLE_EYES)
			comp.set_light_and_darkness(-0.5,1)
			comp.nutrition_conversion_scaling = 1
		if(YELLOW_EYES)
			comp.set_light_and_darkness(-2,3)
			comp.nutrition_conversion_scaling = 0.5
		if(GREEN_EYES)
			comp.set_light_and_darkness(0.125,2)
			comp.nutrition_conversion_scaling = 0.5
		if(ORANGE_EYES)
			comp.set_light_and_darkness(-0.25,0.75)
			comp.nutrition_conversion_scaling = 1.5

/mob/living/simple_mob/shadekin/is_incorporeal()
	if(comp.in_phase)
		return TRUE
	return FALSE

/mob/living/simple_mob/shadekin/handle_atmos()
	if(comp.in_phase)
		return
	else
		return .=..()
/* //VOREStation AI Removal
//Friendly ones wander towards people, maybe shy-ly if they are set to shy
/mob/living/simple_mob/shadekin/handle_wander_movement()
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
								visible_message(span_notice("\The [src] [pick(friendly)] \the [henlo_human]."))
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
					moving_to = pick(GLOB.cardinal)
					dir = moving_to

				var/turf/T = get_step(src,moving_to)
				if(avoid_turf(T))
					return
				Move(T)
				lifes_since_move = 0
*/

/mob/living/simple_mob/shadekin/speech_bubble_appearance()
	return "ghost"

/mob/living/simple_mob/shadekin/apply_melee_effects(var/atom/A)
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

			comp.dark_energy += gains

// When someone clicks us with an empty hand
/mob/living/simple_mob/shadekin/attack_hand(mob/living/carbon/human/M as mob)
	. = ..()
	if(M.a_intent == I_HELP)
		shy_approach = FALSE //ACCLIMATED

/datum/say_list/shadekin
	speak = list("Marrr.", "Marrr?", "Marrr!")
	emote_hear = list("chrrrrrs", "wurbles", "wrrrrbles")
	emote_see = list("tailtwitches", "earflicks")
	say_maybe_target = list("...mar?")
	say_got_target = list("MAR!!!")
	//reactions = list("Mar?" = "Marrr!", "Mar!" = "Marrr???", "Mar." = "Marrr.")
