/mob/living/simple_mob/vore/stalker
	name = "cave stalker"
	desc = "A strange slim creature that lurks in the dark. It's features could be described as a mix of feline and canine, but it's most notable alien property is the second set of forelegs. Additionally, it has a series of boney blue spikes running down it's spine, a similarly hard tip to it's tail and dark blue fangs hanging from it's snout."
	catalogue_data = list(/datum/category_item/catalogue/fauna/stalker)
	tt_desc = "Canidfelanis"
	icon = 'icons/mob/vore64x32.dmi'
	icon_dead = "stalker-dead"
	icon_living = "stalker"
	icon_state = "stalker"
	icon_rest = "stalker-rest"
	faction = FACTION_STALKER
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	friendly = list("nudges", "sniffs on", "rumbles softly at", "nuzzles")
	response_help = "bumps"
	response_disarm = "shoves"
	response_harm = "attacks"
	movement_cooldown = 0
	harm_intent_damage = 7
	melee_damage_lower = 3
	melee_damage_upper = 10
	maxHealth = 100
	attacktext = list("bites")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/vore/stalker
	say_list_type = /datum/say_list/stalker

	vore_bump_chance = 25
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 1000
	vore_active = 1
	vore_icons = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 1
	swallowTime = 50
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_DIGEST
	vore_pounce_maxhealth = 1000
	vore_bump_emote = "pounces on"

/mob/living/simple_mob/vore/stalker/init_vore()
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The lithe creature spends only minimal time with you pinned beneath it, before it's jaws stretch wide ahead of your face. The slightly blue hued interior squelches tightly over your head as the stalker's teeth prod against you, threatening to become much more of a danger if you put up too much of a fight. However, the process is quick, your body is efficiently squeezed through that tight gullet, contractions dragging you effortlessly towards the creature's gut. The stomach swells and hangs beneath the animal, swaying like a hammock under the newfound weight. The walls wrap incredibly tightly around you, compressing you tightly into a small ball as it grinds caustic juices over you."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digest_oxy = 1
	B.digestchance = 100
	B.absorbchance = 0
	B.escapechance = 5
	B.selective_preference = DM_DIGEST
	B.escape_stun = 5

/datum/say_list/stalker
	emote_hear = list("hisses","growls","chuffs")
	emote_see = list("watches you carefully","scratches at the ground","whips it's tail","paces")

/datum/category_item/catalogue/fauna/stalker
	name = "Extra-Realspace Fauna - Cave Stalker"
	desc = "Classification: Canidfelanis\
	<br><br>\
	Cave Stalker's an unusual alien animal found at a number of redgate locations, suspected to have originated from locations other than those that they are found at. \
	They are carnivorous and highly aggressive beasts that spend the majority of their time skulking in dark locations with long lines of sight, they're known to spend a lot of time stalking their prey to assess their vulnerability. \
	Typically they will follow their prey from a distance, and when they are not paying attention, will rush in to tackle their meal. However, they're stealth hunters and are easily startled if spotted. They will not attack their prey head on unless physically provoked to defend themselves."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/stalker/PounceTarget(var/mob/living/M, var/successrate = 100)
	vore_pounce_cooldown = world.time + 1 SECONDS // don't attempt another pounce for a while
	if(prob(successrate)) // pounce success!
		M.Weaken(5)
		M.visible_message(span_danger("\The [src] pounces on \the [M]!"))
	else // pounce misses!
		M.visible_message(span_danger("\The [src] attempts to pounce \the [M] but misses!"))
		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

	if(will_eat(M) && (!M.canmove || vore_standing_too)) //if they're edible then eat them too
		return EatTarget(M)
	else
		return //just leave them

//AI

/datum/ai_holder/simple_mob/vore/stalker
	can_flee = TRUE
	vision_range = 15 //They rush you from off-screen, but easily countered if you are aware
	var/watched = 0

/datum/ai_holder/simple_mob/vore/stalker/proc/check_witness(list/possible_targets, has_targets_list)
	if(!has_targets_list)
		possible_targets = list_targets()

	for(var/mob/living/L in possible_targets)
		var/distance = get_dist(holder, L)
		if(!check_attacker(L) && !L.stat && distance <= 9) //Stop approaching just off screen if they're looking in your direction
			if((L.dir == 1 && holder.y >= L.y) || (L.dir == 2 && holder.y <= L.y) || (L.dir == 4 && holder.x >= L.x) || (L.dir == 8 && holder.x <= L.x)) //stop attacking if they look at you
				set_stance(STANCE_IDLE)
				if(!watched)
					watched = 1
					spawn(40) //run away if they keep staring
						watched = 0
						if((L.dir == 1 && holder.y >= L.y) || (L.dir == 2 && holder.y <= L.y) || (L.dir == 4 && holder.x >= L.x) || (L.dir == 8 && holder.x <= L.x) && distance <= 8)
							if(!L.stat) //If the prey is weakened in any way, don't run
								step_away(holder, L, 8) //Flee if they stare at you within normal view range
								holder.face_atom(L)
				return TRUE
	return FALSE

/datum/ai_holder/simple_mob/vore/stalker/find_target(list/possible_targets, has_targets_list)
	if(!vore_hostile)
		return ..()
	if(!isanimal(holder))	//Only simplemobs have the vars we need
		return ..()
	var/mob/living/simple_mob/H = holder
	if(H.vore_fullness >= H.vore_capacity)	//Don't beat people up if we're full
		return ..()
	ai_log("find_target() : Entered.", AI_LOG_TRACE)

	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	var/list/valid_mobs = list()
	for(var/mob/living/possible_target in possible_targets)
		if(!can_attack(possible_target))
			continue
		. |= possible_target
		if(!isliving(possible_target))
			continue
		if(vore_check(possible_target))
			valid_mobs |= possible_target

	var/new_target
	if(valid_mobs.len)
		new_target = pick(valid_mobs)
	else if(hostile)
		new_target = pick(.)
	if(!new_target)
		return null
	give_target(new_target)
	return new_target

/datum/ai_holder/simple_mob/vore/stalker/can_attack(atom/movable/the_target, var/vision_required = TRUE)
	ai_log("can_attack() : Entering.", AI_LOG_TRACE)
	if(!can_see_target(the_target) && vision_required)
		return FALSE
	if(!belly_attack)
		if(isbelly(holder.loc))
			return FALSE
	if(check_witness())
		return FALSE
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(ishuman(L) || issilicon(L))
			if(L.key && !L.client)	// SSD players get a pass
				return FALSE
		if(L.stat)
			if(L.stat == DEAD && !handle_corpse) // Leave dead things alone
				return FALSE
			if(L.stat == UNCONSCIOUS)	// Do we have mauling? Yes? Then maul people who are sleeping but not SSD
				if(mauling)
					return TRUE
				//VOREStation Add Start
				else if(unconscious_vore && L.allowmobvore)
					var/mob/living/simple_mob/vore/eater = holder
					if(eater.will_eat(L))
						return TRUE
					else
						return FALSE
				//VOREStation Add End
				else
					return FALSE
//		if(!check_attacker(L))
//			if((L.dir == 1 && holder.y >= L.y) || (L.dir == 2 && holder.y <= L.y) || (L.dir == 4 && holder.x >= L.x) || (L.dir == 8 && holder.x <= L.x)) //stop attacking if they look at you
//				set_stance(STANCE_IDLE)
//				spawn(40) //run away if they keep staring
//					if((L.dir == 1 && holder.y >= L.y) || (L.dir == 2 && holder.y <= L.y) || (L.dir == 4 && holder.x >= L.x) || (L.dir == 8 && holder.x <= L.x))
//						if(!L.stat) //If the prey is weakened in any way, don't run
//							step_away(holder, L, 8)
//							holder.face_atom(L)
//				return FALSE
		//VOREStation add start
		else if(forgive_resting && !isbelly(holder.loc))	//Doing it this way so we only think about the other conditions if the var is actually set
			if((holder.health == holder.maxHealth) && !hostile && (L.resting || L.weakened || L.stunned))	//If our health is full, no one is fighting us, we can forgive
				var/mob/living/simple_mob/vore/eater = holder
				if(!eater.will_eat(L))		//We forgive people we can eat by eating them
					set_stance(STANCE_IDLE)
					return FALSE	//Forgiven
		//VOREStation add end
		if(holder.IIsAlly(L))
			return FALSE
		return TRUE

	if(istype(the_target, /obj/mecha))
		var/obj/mecha/M = the_target
		if(M.occupant)
			return can_attack(M.occupant)
		return destructive // Empty mechs are 'neutral'.

	if(istype(the_target, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/P = the_target
		if(P.stat & BROKEN)
			return FALSE // Already dead.
		if(P.faction == holder.faction)
			return FALSE // Don't shoot allied turrets.
		if(!P.raised && !P.raising)
			return FALSE // Turrets won't get hurt if they're still in their cover.
		return TRUE

	if(istype(the_target, /obj/structure/blob)) // Blob mobs are always blob faction, but the blob can anger other things.
		var/obj/structure/blob/Blob = the_target
		if(holder.faction == Blob.faction)
			return FALSE

	return TRUE

/datum/ai_holder/simple_mob/vore/stalker/engage_target()
	ai_log("engage_target() : Entering.", AI_LOG_DEBUG)

	// Can we still see them?
	if(!target || !can_attack(target))
		ai_log("engage_target() : Lost sight of target.", AI_LOG_TRACE)
		if(lose_target()) // We lost them (returns TRUE if we found something else to do)
			ai_log("engage_target() : Pursuing other options (last seen, or a new target).", AI_LOG_TRACE)
			return

	var/distance = get_dist(holder, target)
	ai_log("engage_target() : Distance to target ([target]) is [distance].", AI_LOG_TRACE)
	holder.face_atom(target)
	last_conflict_time = world.time

	// Do a 'special' attack, if one is allowed.
//	if(prob(special_attack_prob) && (distance >= special_attack_min_range) && (distance <= special_attack_max_range))
	if(holder.ICheckSpecialAttack(target))
		ai_log("engage_target() : Attempting a special attack.", AI_LOG_TRACE)
		on_engagement(target)
		if(special_attack(target)) // If this fails, then we try a regular melee/ranged attack.
			ai_log("engage_target() : Successful special attack. Exiting.", AI_LOG_DEBUG)
			return

	// Stab them.
	else if(distance <= 1 && !pointblank)
		ai_log("engage_target() : Attempting a melee attack.", AI_LOG_TRACE)
		on_engagement(target)
		melee_attack(target)

	else if(distance <= 1 && !holder.ICheckRangedAttack(target)) // Doesn't have projectile, but is pointblank
		ai_log("engage_target() : Attempting a melee attack.", AI_LOG_TRACE)
		on_engagement(target)
		melee_attack(target)

	// Shoot them.
	else if(holder.ICheckRangedAttack(target) && (distance <= max_range(target)) )
		on_engagement(target)
		if(firing_lanes && !test_projectile_safety(target))
			// Nudge them a bit, maybe they can shoot next time.
			var/turf/T = get_step(holder, pick(GLOB.cardinal))
			if(T)
				holder.IMove(T) // IMove() will respect movement cooldown.
				holder.face_atom(target)
			ai_log("engage_target() : Could not safely fire at target. Exiting.", AI_LOG_DEBUG)
			return

		ai_log("engage_target() : Attempting a ranged attack.", AI_LOG_TRACE)
		ranged_attack(target)

	// Run after them.
	else if(!stand_ground)
		ai_log("engage_target() : Target ([target]) too far away. Exiting.", AI_LOG_DEBUG)
		set_stance(STANCE_APPROACH)
