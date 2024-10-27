/mob/living/simple_mob/vore/fluffball
	name = "fluffball"
	desc = "A small, rotund humanoid creature. It is difficult to make out physical features of it as it covers most of its face behind big floppy, fluffy ears with only beady yellow eyes looking out. Most of its body is covered by a thick, soft tail that it wraps around itself and holds onto with small stumpy arms."
	catalogue_data = list(/datum/category_item/catalogue/fauna/fluffball)
	tt_desc = "glamoris fluffalia"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "fluffball-dead"
	icon_living = "fluffball"
	icon_state = "fluffball"
	faction = FACTION_SCRUBBLE
	friendly = list("nudges", "sniffs on", "rumbles softly at", "nuzzles")
	response_help = "bumps"
	response_disarm = "shoves"
	response_harm = "attacks"
	movement_cooldown = 0
	harm_intent_damage = 2
	melee_damage_lower = 1
	melee_damage_upper = 4
	maxHealth = 50
	attacktext = list("tail whips")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/hostile/fluffball
	say_list_type = /datum/say_list/fluffball

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

/mob/living/simple_mob/vore/fluffball/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "tail"
	B.desc = "The small critter seems to suddenly panic, lunging at you with its massive fluffy tail, using it like a weapon. Despite the appearance of the tail, it seems to be much larger on the inside, suddenly engulfing you completely in a world of endless softness. Inside, you are bound up nice and tight in an oddly comfortable prison of hair, it ripples over your body tickling every bit of exposed body on offer."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 1
	B.digest_burn = 1
	B.digest_oxy = 0
	B.digestchance = 10
	B.absorbchance = 60
	B.escapechance = 10
	B.selective_preference = DM_ABSORB
	B.escape_stun = 5
	B.transferlocation_absorb = "fluff"

	var/obj/belly/fluff = new /obj/belly(src)
	fluff.immutable = TRUE
	fluff.name = "fluff"
	fluff.desc = "You find yourself sinking deeper and deeper into the fluff around you, steadily it wraps around your entire body, binding you up. It seems to grow tighter and tigher forever, although never to the point of discomfort. Before long, the tightness goes beyond a physical sensation, it starts to feel like it buries into you, becoming part of you. It is becoming hard to discern yourself from the fluff, you feel floaty, wavy and soft yourself. Eventually, you can't feel yourself at all, there's nothing but fur. Every movement you make feels pointless, simply causing the slightest rustling of fluff as though the hair was moving on its own."
	fluff.digest_mode = DM_HOLD // like, shes got you already, doesn't need to get you more
	fluff.mode_flags = DM_FLAG_FORCEPSAY
	fluff.escapable = TRUE // good luck
	fluff.escapechance = 40 // high chance of STARTING a successful escape attempt
	fluff.escapechance_absorbed = 5 // m i n e
	fluff.vore_verb = "soak"
	fluff.count_absorbed_prey_for_sprite = FALSE
	fluff.absorbed_struggle_messages_inside = list(
		"You try and push free from %pred's %belly, but can't seem to will yourself to move.",
		"Your fruitless mental struggles only cause %pred to giggle lightly.",
		"You can't make any progress freeing yourself from %pred's %belly.")
	fluff.escape_attempt_absorbed_messages_owner = list(
		"%prey is attempting to free themselves from your %belly!")

	fluff.escape_attempt_absorbed_messages_prey = list(
		"You try to force yourself out of %pred's %belly.",
		"You strain and push, attempting to reach out of %pred's %belly.",
		"You work up the will to try and force yourself free of %pred's clutches.")

	fluff.escape_absorbed_messages_owner = list(
		"%prey forces themselves free of your %belly!")

	fluff.escape_absorbed_messages_prey = list(
		"You finally manage to wrest yourself free from %pred's %belly, re-asserting your more usual form.",
		"You heave and push, eventually spilling out from %pred's %belly, eliciting a happy chirp from your former captor.")

	fluff.escape_absorbed_messages_outside = list(
		"%prey suddenly forces themselves free of %pred's %belly!")

	fluff.escape_fail_absorbed_messages_owner = list(
		"%prey's attempt to escape form your %belly has failed!")

	fluff.escape_fail_absorbed_messages_prey = list(
		"Before you manage to reach freedom, you feel yourself getting dragged back into %pred's %belly!",
		"%pred laughs lightly, simply pressing your wrigging form back into her %belly before you get anywhere.",
		"Try as you might, you barely make an impression before %pred simply clenches with the most minimal effort, binding you back into her %belly.",
		"Unfortunately, %pred seems to have absolutely no intention of letting you go, and your futile effort goes nowhere.",
		"Strain as you might, you can't keep up the effort long enough before you sink back into %pred's %belly.")


/datum/say_list/fluffball
	emote_hear = list("makes a shy squeal","whimpers","lets out a little squeak")
	emote_see = list("hides its face","cuddles up to its own tail","stands there awkwardly","avoids eye contact")

/datum/category_item/catalogue/fauna/fluffball
	name = "Extra-Realspace Fauna - Fluffball"
	desc = "Classification: Glamoris Fluffalia\
	<br><br>\
	A stout creature with an apparently quite round figure, known to habit the location known as the Glamour. It is generally difficult to identify any physical features on the creature \
	due to its anxiety around other creatures, it hides itself beneath its heavily furred ears and tail. Most creatures that approach it will find the fluffball fleeing quickly, \
	though it is known to act more calm around those carrying food, which it is quick to steal from people's hands if offered. However, they have been observed to use their tails as weapons when panicked and unable to flee."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/fluffball/PounceTarget(var/mob/living/M, var/successrate = 100)
	vore_pounce_cooldown = world.time + 20 SECONDS // don't attempt another pounce for a while
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

/mob/living/simple_mob/vore/fluffball/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W,/obj/item/reagent_containers/food))
		user.drop_item(W)
		qdel(W)
		visible_message("<span class='notice'>\The [src] quickly steals \the [W] into its fluff, it seems to have become a little less shy!</span>!")
		var/datum/ai_holder/simple_mob/hostile/fluffball/A = ai_holder
		if(istype(A))
			A.friend_list |= user

//AI

/datum/ai_holder/simple_mob/hostile/fluffball
	can_flee = TRUE
	vision_range = 3 //Only react if you get close
	can_flee = TRUE					// If they're even allowed to flee.
	flee_when_dying = TRUE			// If they should flee when low on health.
	dying_threshold = 1.1			// Flee at max health
	var/list/friend_list = list()

/datum/ai_holder/simple_mob/hostile/fluffball/flee_from_target()
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
		if(H.will_eat(L) && H.CanPounceTarget(L))
			H.face_atom(L)
			H.PounceTarget(L)
			return

	ai_log("flee_from_target() : Stepping away.", AI_LOG_TRACE)
	step_away(holder, target, 5)
	ai_log("flee_from_target() : Exiting.", AI_LOG_DEBUG)

/datum/ai_holder/simple_mob/hostile/fluffball/find_target(list/possible_targets, has_targets_list)
	if(!isanimal(holder))	//Only simplemobs have the vars we need
		return ..()
	var/list/L = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	var/list/valid_mobs = list()
	for(var/mob/living/possible_target in possible_targets)
		var/mob/living/carbon/human/H = possible_target
		if(istype(H))
			var/obj/item/reagent_containers/food/B = H.get_active_hand()
			var/obj/item/reagent_containers/food/R = H.get_inactive_hand()
			if(istype(R) || istype(B))
				continue
		if(!can_attack(possible_target))
			continue
		if((possible_target in friend_list) && !check_attacker(possible_target))
			continue
		L |= possible_target
		if(!isliving(possible_target))
			continue
		if(vore_check(possible_target))
			valid_mobs |= possible_target

	var/new_target
	if(valid_mobs.len)
		new_target = pick(valid_mobs)
	else if(hostile && L.len)
		new_target = pick(L)
	if(!new_target)
		return null
	give_target(new_target)
	return new_target

/datum/ai_holder/simple_mob/vore/fluffball
	vision_range = 4
	hostile = FALSE
	retaliate = TRUE
	vore_hostile = FALSE
	forgive_resting = TRUE
	cooperative = FALSE
