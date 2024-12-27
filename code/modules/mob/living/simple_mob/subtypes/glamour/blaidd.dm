/mob/living/simple_mob/vore/blaidd
	name = "blaidd"
	desc = "A wolf like creature with a large, spikey mane."
	tt_desc = "Canis glamoris"
	icon = 'icons/mob/vore64x32.dmi'
	icon_dead = "blaidd-dead"
	icon_living = "blaidd"
	icon_state = "blaidd"
	icon_rest = "blaidd_rest"
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	faction = FACTION_GLAMOUR
	catalogue_data = list(/datum/category_item/catalogue/fauna/blaidd)
	ai_holder_type = /datum/ai_holder/simple_mob/vore/blaidd

	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 20
	maxHealth = 300

	minbodytemp = 0

	max_buckled_mobs = 1
	mount_offset_y = 14
	mount_offset_x = 2
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	var/blaidd_invisibility

	vore_bump_chance = 25
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 100
	vore_active = 1
	vore_icons = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 1
	swallowTime = 50
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_SELECT
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to devour"

/mob/living/simple_mob/vore/blaidd/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	verbs |= /mob/living/simple_mob/vore/blaidd/proc/blaidd_invis
	movement_cooldown = -1

/mob/living/simple_mob/vore/blaidd/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The canine pounces atop you and wastes now time in wrapping its jaws around your entire head. The beast is strong and determined, there is no wriggling out of it's iron grip. Within its maw, the tongue slathers canine drool across you, hot doglike breaths wash across your face, triangular teeth hold you firmly in place. It doesn't take long before the blaidd is gulping you down aggressively, like a big chunk of meat. The creature's stomach distends and hangs beneath it with your weight, swaying heavily not just with your movements, but every step from the wolf. Bound up uncomfortably tight in this sweltering, dark gut, movement is almost impossible and it's hard to tell which way is up."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_THICKBELLY
	B.fancy_vore = 1
	B.selective_preference = DM_DIGEST
	B.vore_verb = "devour"
	B.digest_brute = 1
	B.digest_burn = 1
	B.digest_oxy = 0
	B.selectchance = 50
	B.absorbchance = 0
	B.escapechance = 10
	B.escape_stun = 5
	B.contamination_color = "grey"
	B.contamination_flavor = "Wet"
	B.emote_lists[DM_DIGEST] = list(
		"The blaidd growls as the gut squeeze over your body, smearing caustic oozes into your form!",
		"You are turned over and walls clench around you as the beast moves about, tossing more digestive juices over your body.",
		"You can't make out any sound from the outside as the gut grumbled and reverberates over your body.",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The blaidd presses its gut against the floor, giving you a full body crush deep within its gut. The strain on your body aids digestion, making you all the easier to work down.")

/datum/category_item/catalogue/fauna/blaidd
	name = "Extra-Realspace Fauna - Blaidd"
	desc = "Classification: Canis glamoris\
	<br><br>\
	A large canine found in whitespace or the Glamour, distinguished easily by a large spikey mane and lightly striped pattern. The Blaidd, named from the glamourspeak word for wolf, is known to be a ferocious hunter and predator. It is a carnivore that stalks prey from a distance silently, whilst its otherwise quite striking fur blends it well into the environment through some sort of active camouflage, a less powerful version of that seen in the local Lleill. It generally avoids attacking its prey when it feels it is being watched, but once it is able to finally pounce on a target, it will not retreat until forced."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/blaidd/update_icon()
	. = ..()
	if(vore_active)
		var/voremob_awake = FALSE
		if(icon_state == icon_living)
			voremob_awake = TRUE
			if(blaidd_invisibility)
				icon_state = "[icon_living]_cloaked"
		update_fullness()
		if(!vore_fullness)
			update_transform()
			return 0
		else if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED)) && (vore_icons & SA_ICON_LIVING))
			if(blaidd_invisibility)
				icon_state = "[icon_living]_cloaked-[vore_fullness]"
			else
				icon_state = "[icon_living]-[vore_fullness]"
		else if(stat >= DEAD && (vore_icons & SA_ICON_DEAD))
			icon_state = "[icon_dead]-[vore_fullness]"
		else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest && (vore_icons & SA_ICON_REST))
			icon_state = "[icon_rest]-[vore_fullness]"
		if(vore_eyes && voremob_awake) //Update eye layer if applicable.
			remove_eyes()
			add_eyes()
	update_transform()

/mob/living/simple_mob/vore/blaidd/proc/blaidd_invis()
	set name = "Invisibility"
	set desc = "Change your appearance to match your surroundings, becoming somewhat invisible to the naked eye."
	set category = "Abilities"

	if(blaidd_invisibility)
		blaidd_invisibility = 0
	else
		blaidd_invisibility = 1

	update_icon()

/datum/ai_holder/simple_mob/vore/blaidd
	can_flee = TRUE
	vision_range = 12 //They rush you from off-screen, but easily countered if you are aware
	var/watched = 0
	var/hiding = 0

/datum/ai_holder/simple_mob/vore/blaidd/hostile
	hostile = TRUE

/datum/ai_holder/simple_mob/vore/blaidd/proc/check_witness(list/possible_targets, has_targets_list)
	if(!has_targets_list)
		possible_targets = list_targets()

	for(var/mob/living/L in possible_targets)
		var/distance = get_dist(holder, L)
		if(!check_attacker(L) && !L.stat && distance <= 9) //Stop approaching just off screen if they're looking in your direction
			if((L.dir == 1 && holder.y >= L.y) || (L.dir == 2 && holder.y <= L.y) || (L.dir == 4 && holder.x >= L.x) || (L.dir == 8 && holder.x <= L.x)) //stop attacking if they look at you
				set_stance(STANCE_IDLE)
				if(!watched)
					watched = 1
					spawn(5) //run away if they keep staring
						watched = 0
						if((L.dir == 1 && holder.y >= L.y) || (L.dir == 2 && holder.y <= L.y) || (L.dir == 4 && holder.x >= L.x) || (L.dir == 8 && holder.x <= L.x) && distance <= 8)
							if(!L.stat) //If the prey is weakened in any way, don't run
								step_away(holder, L, 8) //Flee if they stare at you within normal view range
								holder.face_atom(L)
				return TRUE
	return FALSE

/datum/ai_holder/simple_mob/vore/blaidd/find_target(list/possible_targets, has_targets_list)
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

/datum/ai_holder/simple_mob/vore/blaidd/can_attack(atom/movable/the_target, var/vision_required = TRUE)
	ai_log("can_attack() : Entering.", AI_LOG_TRACE)
	if(!can_see_target(the_target) && vision_required)
		return FALSE
	if(!belly_attack)
		if(isbelly(holder.loc))
			return FALSE
	var/distance = get_dist(holder, target)
	if(distance > 2)
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

/datum/ai_holder/simple_mob/vore/blaidd/engage_target()
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
			var/turf/T = get_step(holder, pick(cardinal))
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

/datum/ai_holder/simple_mob/vore/blaidd/proc/set_invis()
	var/mob/living/simple_mob/vore/blaidd/B = holder
	if(!istype(B))
		return
	var/list/possible_targets = list_targets()
	if(!possible_targets.len)
		if(B.blaidd_invisibility)
			B.blaidd_invisibility = 0
			B.update_icon()
		return
	if(!target)
		return
	var/distance = get_dist(holder, target)
	if(distance <= 1)
		if(B.blaidd_invisibility)
			B.blaidd_invisibility = 0
			B.update_icon()
		return
	else
		if(!B.blaidd_invisibility)
			B.blaidd_invisibility = 1
			B.update_icon()
		return

/datum/ai_holder/simple_mob/vore/blaidd/handle_stance_strategical()
	set_invis()
	return ..()

/mob/living/simple_mob/vore/blaidd/hostile
	ai_holder_type = /datum/ai_holder/simple_mob/vore/blaidd/hostile

/datum/ai_holder/simple_mob/vore/blaidd/hostile
	hostile = TRUE
