/mob/living/simple_mob/vore/devil
	name = "Statue of Temptation"
	desc = "A tall statue made of red-tinted metal in the shape of some sort of demon or devil."
	catalogue_data = list(/datum/category_item/catalogue/fauna/devil)
	tt_desc = "Metal Statue"
	icon = 'icons/mob/vore64x64.dmi'
	icon_dead = "devil-dead"
	icon_living = "devil"
	icon_state = "devil"
	icon_rest = "devil"
	faction = FACTION_DEVIL
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
	ai_holder_type = /datum/ai_holder/simple_mob/vore/devil

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

/mob/living/simple_mob/vore/devil/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "It turns out that this was not just any old statue, but some form of android waiting for its chance to ambush you. The moment that it laid its hands on you, your fate was decided. The jaws of the machine parted, if you could call them that, and immediately enveloped your head. The inside was hot and slick, but dry. The textures were startlingly realistic, the base was clearly a tongue, the top palate of the mouth was hard but somewhat pliable. Not that you had time to admire it before the rest of your body was stuffed inside. Through a short passage down through a rubbery tube of a gullet, mechanical contractions squeezing you down from behind, you're quickly deposited in something much resembling a stomach. Amid the sounds of mechanical whirrs, you can heard glorping, gurgling and burbling from unknown sources. The walls wrap firmly around your body, deliberately dramping you up into the smallest space that the machine can crush you into, whilst the synthetic lining around you ripples across your hunched up form. You can even see yourself, the gut itself is backlit by some eerie red glow, just enough to tell exactly what is happening to you. It doesn't help that you can see the drooling fluids glistening in the dim light."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "a_synth_flesh_mono_hole"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digest_oxy = 1
	B.digestchance = 100
	B.absorbchance = 0
	B.escapechance = 5
	B.selective_preference = DM_DIGEST
	B.escape_stun = 5

/datum/category_item/catalogue/fauna/devil
	name = "Extra-Realspace Machine - Statue of Temptation"
	desc = "Classification: Synthetic Lifeform\
	<br><br>\
	The origin of this machine is not well understood, neither is its purpose nor whether it is sapient. However, we have been able to study a little about their behaviour. \
	These creatures seem to disquise themselves as statues, making no movement what so ever when being directly observed. There is little to suggest they move at all when there is nobody present either. \
	However, when lifeforms exist nearby, these oddly curvaceous devils spring to life, lighting up and attempting to devour all living things. We assume they reduce their targets to biofuel to sustain themselves, but they have been known to break their disguise when attacked to defend themselves."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/devil/PounceTarget(var/mob/living/M, var/successrate = 100)
	vore_pounce_cooldown = world.time + 1 SECONDS // don't attempt another pounce for a while
	if(prob(successrate)) // pounce success!
		M.Weaken(5)
		M.visible_message("<span class='danger'>\The [src] pounces on \the [M]!</span>!")
	else // pounce misses!
		M.visible_message("<span class='danger'>\The [src] attempts to pounce \the [M] but misses!</span>!")
		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

	if(will_eat(M) && (!M.canmove || vore_standing_too)) //if they're edible then eat them too
		return EatTarget(M)
	else
		return //just leave them

//AI

/datum/ai_holder/simple_mob/vore/devil
	wander = FALSE

/datum/ai_holder/simple_mob/vore/devil/proc/check_witness(list/possible_targets, has_targets_list)
	if(!has_targets_list)
		possible_targets = list_targets()
	for(var/mob/living/L in possible_targets)
		if(!check_attacker(L) && !L.stat) //If that person is awake and hasn't attacked the mob.
			if((L.dir == 1 && holder.y >= L.y) || (L.dir == 2 && holder.y <= L.y) || (L.dir == 4 && holder.x >= L.x) || (L.dir == 8 && holder.x <= L.x)) //stop attacking if they look at you
				return TRUE
	return FALSE

/datum/ai_holder/simple_mob/vore/devil/find_target(list/possible_targets, has_targets_list)
	if(!vore_hostile)
		return ..()
	if(!isanimal(holder))	//Only simplemobs have the vars we need
		return ..()
	var/mob/living/simple_mob/vore/H = holder
	if(H.vore_fullness >= H.vore_capacity)	//Don't beat people up if we're full
		return ..()
	ai_log("find_target() : Entered.", AI_LOG_TRACE)

	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	var/list/valid_mobs = list()
	for(var/mob/living/possible_target in possible_targets)
//		if(check_witness())
//			set_stance(STANCE_IDLE)
//			continue
		if(!can_attack(possible_target))
			continue
		. |= possible_target
		if(!isliving(possible_target))
			continue
		if(vore_check(possible_target))
			valid_mobs |= possible_target

	var/new_target
	if(valid_mobs.len)
		if(H.icon_state != "devil_target" || H.icon_state != "devil_target-1")
			H.icon_living = "devil_target"
			H.update_icon()
		new_target = pick(valid_mobs)
	else if(hostile)
		if(H.icon_state != "devil_target" || H.icon_state != "devil_target-1")
			H.icon_living = "devil_target"
			H.update_icon()
		new_target = pick(.)
	if(!new_target)
		if(H.icon_state == "devil_target" || H.icon_state == "devil_target-1")
			H.icon_living = "devil"
			H.update_icon()
		return null
	give_target(new_target)
	return new_target

/datum/ai_holder/simple_mob/vore/devil/can_attack(atom/movable/the_target, var/vision_required = TRUE)
	ai_log("can_attack() : Entering.", AI_LOG_TRACE)
	if(!can_see_target(the_target) && vision_required)
		return FALSE
	if(!belly_attack)
		if(isbelly(holder.loc))
			return FALSE
	if(check_witness()) //If anyone is looking, cancel the attack
		set_stance(STANCE_IDLE)
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

/datum/ai_holder/simple_mob/vore/devil/engage_target()
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
