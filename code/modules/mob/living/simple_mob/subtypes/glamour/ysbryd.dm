// Spooky glamour ghost that's only visible to one player at a time

/mob/living/simple_mob/ysbryd
	name = "ysbryd"
	desc = "This isn't right, you shouldn't be seeing this, is anyone else seeing this?"

	icon_dead = "ysbryd"
	icon_living = "ysbryd"
	icon_state = "ysbryd"
	icon = 'icons/mob/vore.dmi'

	ai_holder_type = /datum/ai_holder/simple_mob/passive

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 1000

	plane = PLANE_INVIS_EVENT

	movement_cooldown = 20 // Very slow
	harm_intent_damage = 10
	melee_damage_lower = 8
	melee_damage_upper = 12
	maxHealth = 150
	attacktext = list("haunts")
	see_in_dark = 8
	ai_holder_type = /datum/ai_holder/simple_mob/ysbryd
	catalogue_data = list(/datum/category_item/catalogue/fauna/ysbryd)

	var/list/emote_threats = list(
								"I have come to collect a meal, now that your people have broken the seal.",
								"The sight of me should make you fly, but know that regardless you will die.",
								"Escape all this frustrating clamour, come sink with me into the glamour.",
								"My face may now be made of bone, but I should not experience it alone.",
								"I can hear the racing of your heart, it is approaching my favourite part.",
								"You will not be left to suffer, is it not that life is so much tougher.",
								"Your boxes of cold metal, a place where I will not settle.",
								"I can see in your eyes you wish to be free, so step forward and become one with me."
	)

	faction = FACTION_GLAMOUR

	vore_bump_chance = 25
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 1000
	vore_active = 1
	vore_icons = 1
	vore_icons = SA_ICON_LIVING
	vore_capacity = 1
	swallowTime = 50
	vore_ignores_undigestable = FALSE
	vore_default_mode = DM_SELECT
	vore_pounce_maxhealth = 1000
	vore_bump_emote = "pounces on"
	vore_pounce_falloff = 0 //Always eat someone at full health
	vore_standing_too = 1

	var/mob/living/chosen_target
	var/last_effect = 0
	var/boost_health = 50

	status_flags = null
	density = 0

/datum/category_item/catalogue/fauna/ysbryd
	name = "Extra-Realspace Fauna - Ysbryd"
	desc = "Classification: Phantasma glamoris\
	<br><br>\
	An unusual creature originating from whitespace. Observation has been very limited due to it's physics defying behaviour, only appearing to one observer at any time, and due to it's highly aggressive behaviour. Xenobiologists have not been able to reliably encounter the creature and the few recorded encounters resulted in serious injury or death to the researcher in question. One particular study revealed that it seemed to be agitated by high frequency electromagnetic radiation, outside of the visible sprectrum of light, but results were not conclusive."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/ysbryd/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The horrifying beast yawns it's skull maw wide before your face, unveiling a dark but surprisingly fleshy interior. Not that you have much time to appreciate it before your head is engulfed in the void, and dragged roughly into the depths beyond it. Before long, you're trapped in pitch darkness. Intense pressure binding you from every possible direction, fleshy walls grinding over your form. Despite this, it's quiet in here, uncomfortably so. No bodily functions can be heard, no groaning guts, merely the sound of your own body pressing against the stomach lining."
	B.digest_brute = 3
	B.digest_burn = 3
	B.digestchance = 40
	B.absorbchance = 1
	B.escapechance = 3
	B.escape_stun = 5
	B.belly_fullscreen = "VBO_belly8"

	B.emote_lists[DM_HOLD] = list(
		"The creature idly runs what feels like bony hands over your form.",
		"The pressure from the walls around you suddenly increases.",
		"Amongst the silence you hear chains rattling, muffled.",
		"There's no noise at all, you can only hear yourself for the moment.",
		"It's hot in here, intensely so, and it's hard to think straight.",
		"You feel the gut lurch about you as if the creature were casually moving.")

	B.emote_lists[DM_DIGEST] = list(
		"The pressure squeezes the life out of your curled up body.",
		"You can't orient yourself, the grinding of the walls roughly turns you over and over.",
		"You can finally hear some bodily functions as the stomach you're inside begins to gurgle and churn.",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant assault from mechanically grinding flesh and pooling caustic fluids is breaking down your body.",
		"The feeling of body hands from beyond the walls crush in on you possessively.")


/mob/living/simple_mob/ysbryd/decorated
	icon_dead = "ysbryd_deco"
	icon_living = "ysbryd_deco"
	icon_state = "ysbryd_deco"

/mob/living/simple_mob/ysbryd/proc/connect_target(var/mob/living/M)
	if(!isliving(M))
		return
	chosen_target = M
	if(!(VIS_EVENT_INVIS in chosen_target.vis_enabled))
		chosen_target.plane_holder.set_vis(VIS_EVENT_INVIS,TRUE)
		chosen_target.vis_enabled += VIS_EVENT_INVIS

/mob/living/simple_mob/ysbryd/proc/disconnect_target()
	if(!chosen_target)
		return
	if((VIS_EVENT_INVIS in chosen_target.vis_enabled))
		chosen_target.plane_holder.set_vis(VIS_EVENT_INVIS,FALSE)
		chosen_target.vis_enabled -= VIS_EVENT_INVIS
	chosen_target = null

/mob/living/simple_mob/ysbryd/death()
	if(chosen_target)
		disconnect_target()
	qdel(src)

/mob/living/simple_mob/ysbryd/Life()
	if(chosen_target)
		handle_target()
	if(health <= boost_health)
		movement_cooldown = -2
	return ..()

/mob/living/simple_mob/ysbryd/proc/handle_target()
	if(!chosen_target)
		return
	chosen_target.fear = min((chosen_target.fear + 3),102)
	if(world.time >= (last_effect + 30 SECONDS))
		if(prob(5))
			chosen_target.hallucination = max(chosen_target.hallucination,10)
			last_effect = world.time
		if(prob(5))
			var/chosen_threat = pick(emote_threats)
			to_chat(chosen_target,span_danger("The words creep into your mind: [chosen_threat]"))
			last_effect = world.time
		if(prob(5))
			var/chosen_sound = pick(AMBIENCE_GHOSTLY)
			chosen_target << sound(chosen_sound, repeat = 0, wait = 0, volume = 15, channel = CHANNEL_AMBIENCE_FORCED)
			last_effect = world.time

/mob/living/simple_mob/ysbryd/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile/beam/xray) || istype(Proj ,/obj/item/projectile/beam/gamma) || istype(Proj ,/obj/item/projectile/beam/emitter))
		plane = MOB_PLANE


///////////////////////////AI stuff

/datum/ai_holder/simple_mob/ysbryd
	var/find_target_cooldown = 1 MINUTE

/datum/ai_holder/simple_mob/ysbryd/find_target(var/list/possible_targets, var/has_targets_list = FALSE)
	ai_log("find_target() : Entered.", AI_LOG_TRACE)
	if(world.time <= (find_target_cooldown + last_target_time))
		return
	if(!hostile) // So retaliating mobs only attack the thing that hit it.
		return null
	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	for(var/atom/possible_target as anything in possible_targets)
		if(guard_limit)
			if((holder.dir == 1 && holder.y >= possible_target.y) || (holder.dir == 2 && holder.y <= possible_target.y) || (holder.dir == 4 && holder.x >= possible_target.x) || (holder.dir == 8 && holder.x <= possible_target.x)) //Ignore targets that are behind you
				continue
		if(can_attack(possible_target)) // Can we attack it?
			. += possible_target

	var/new_target = pick_target(.)
	give_target(new_target)
	last_target_time = world.time
	return new_target


/datum/ai_holder/simple_mob/ysbryd/lose_target()
	if(istype(holder,/mob/living/simple_mob/ysbryd))
		var/mob/living/simple_mob/ysbryd/Y = holder
		Y.disconnect_target()
	last_target_time = world.time
	..()

/datum/ai_holder/simple_mob/ysbryd/handle_stance_strategical()
	if(istype(holder,/mob/living/simple_mob/ysbryd))
		var/mob/living/simple_mob/ysbryd/Y = holder
		if(target)
			if(target != Y.chosen_target)
				if(Y.chosen_target)
					Y.disconnect_target()
				Y.connect_target(target)
		else if(!target)
			if(Y.chosen_target)
				Y.disconnect_target()
	..()
