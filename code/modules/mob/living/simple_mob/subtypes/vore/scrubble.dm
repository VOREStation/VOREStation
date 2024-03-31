/mob/living/simple_mob/vore/scrubble
	name = "Cave Stalker"
	desc = "A strange slim creature that lurks in the dark. It's features could be described as a mix of feline and canine, but it's most notable alien property is the second set of forelegs. Additionally, it has a series of boney blue spikes running down it's spine, a similarly hard tip to it's tail and dark blue fangs hanging from it's snout."
	catalogue_data = list(/datum/category_item/catalogue/fauna/stalker)
	tt_desc = "Canidfelanis"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "scrubble-dead"
	icon_living = "scrubble"
	icon_state = "scrubble"
	icon_rest = "scrubble-rest"
	faction = "scrubble"
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
	maxHealth = 50
	attacktext = list("bites")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/hostile/scrubble
	say_list_type = /datum/say_list/scrubble

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

/mob/living/simple_mob/vore/scrubble/init_vore()
	..()
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

/datum/say_list/scrubble
	emote_hear = list("hisses","growls","chuffs")
	emote_see = list("watches you carefully","scratches at the ground","whips it's tail","paces")

/datum/category_item/catalogue/fauna/scrubble
	name = "Extra-Realspace Fauna - Cave Stalker"
	desc = "Classification: Canidfelanis\
	<br><br>\
	Cave Stalker's an unusual alien animal found at a number of redgate locations, suspected to have originated from locations other than those that they are found at. \
	They are carnivorous and highly aggressive beasts that spend the majority of their time skulking in dark locations with long lines of sight, they're known to spend a lot of time stalking their prey to assess their vulnerability. \
	Typically they will follow their prey from a distance, and when they are not paying attention, will rush in to tackle their meal. However, they're stealth hunters and are easily startled if spotted. They will not attack their prey head on unless physically provoked to defend themselves."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/scrubble/PounceTarget(var/mob/living/M, var/successrate = 100)
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

/datum/ai_holder/simple_mob/hostile/scrubble
	can_flee = TRUE
	vision_range = 5 //Only react if you get close
	can_flee = TRUE					// If they're even allowed to flee.
	flee_when_dying = TRUE			// If they should flee when low on health.
	dying_threshold = 1.1			// Flee at max health
	base_wander_delay = 2

/datum/ai_holder/simple_mob/hostile/scrubble/flee_from_target()
	ai_log("flee_from_target() : Entering.", AI_LOG_DEBUG)

	if(!target || !should_flee() || !can_attack(target)) // can_attack() is used since it checks the same things we would need to anyways.
		ai_log("flee_from_target() : Lost target to flee from.", AI_LOG_INFO)
		lose_target()
		set_stance(STANCE_IDLE)
		ai_log("flee_from_target() : Exiting.", AI_LOG_DEBUG)
		return

	var/mob/living/simple_mob/vore/H = holder
	var/mob/living/L = target
	var/distance = get_dist(holder, target)
	if(distance <= 1)
		if(L.devourable && L.allowmobvore && (H.vore_fullness < H.vore_capacity))
			H.face_atom(L)
			H.PounceTarget(L)
			return

	ai_log("flee_from_target() : Stepping away.", AI_LOG_TRACE)
	step_away(holder, target, 7)
	ai_log("flee_from_target() : Exiting.", AI_LOG_DEBUG)

/datum/ai_holder/simple_mob/hostile/scrubble/find_target(list/possible_targets, has_targets_list)
	if(!isanimal(holder))	//Only simplemobs have the vars we need
		return ..()
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