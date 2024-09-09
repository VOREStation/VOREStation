/mob/living/simple_mob/vore/meowl
	name = "Meowl"
	desc = "A rather cute looking creature that seems to have the features of both a cat and an owl."
	catalogue_data = list(/datum/category_item/catalogue/fauna/meowl)
	tt_desc = "Strigiline"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "meowl-dead"
	icon_living = "meowl"
	icon_state = "meowl"
	icon_rest = "meowl_rest"
	faction = "meowl"
	friendly = list("nudges", "sniffs on", "rumbles softly at", "nuzzles")
	response_help = "pets"
	response_disarm = "shoves"
	response_harm = "attacks"
	movement_cooldown = 2
	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 2
	maxHealth = 100
	attacktext = list("scratches")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/vore/meowl
	var/well_fed = 0

	vore_bump_chance = 0
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 1000
	vore_active = 1
	vore_icons = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 1
	swallowTime = 50
	vore_ignores_undigestable = FALSE
	vore_default_mode = DM_HOLD
	vore_pounce_maxhealth = 1000
	vore_bump_emote = "pounces on"

/mob/living/simple_mob/vore/meowl/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The strange critter suddenly takes advantage of you being alone to pounce atop you and quickly engulf your head within its maw! Before you even have a chance to react, the world goes dark with the inside of the meowls mouth covering your face, a rough tounge lapping smearing wet hot slobber over you. The rest of the process is pretty quick as the cat-owl begins to gulp your head down through a surprisingly stretchy throat and along the tight, flexing tunnel of its gullet. Before long you are pushing face first into the creature's stomach, the wrinkled walls quickly beginning grind slick flesh across it like any other piece of food. The rest of your body soon follows into the increasingly tight space, forced to curl up over yourself as the stomach lining bears down on you from every angle. At first, the stomach itself seems rather inactive, happily just squeezing and massaging you as the meowl settles down to slowly enjoy their snack. Though, struggling might risk setting off the gut one way or another..."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 1
	B.digest_burn = 1
	B.digest_oxy = 1
	B.selectchance = 25
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 10
	B.selective_preference = DM_DIGEST
	B.escape_stun = 5
	B.transferlocation_absorb = "chub"

	var/obj/belly/chub = new /obj/belly(src)
	chub.immutable = TRUE
	chub.name = "chub"
	chub.desc = "Your body quickly begins to feel very... different? In fact, you can't really feel your body much at all any more, but you certainly still feel something. The pressure of the gut that was practically crushing you before is relieved, but somehow still present as though you were now on the other side of the interaction. Your being feels much more spread out and practically intertwined with the world around, that world being the meowl itself. The strange cat-owl's purring feels like it's reverberating throughout your entire form, whatever that might be. Every time the critter shakes to ruffle its feathers, you feel yourself shake with it. Even the creatures emotions feel tangible to you, as though you share themselves, and mostly they are ones of fullness and content."
	chub.digest_mode = DM_HOLD // like, its got you already, doesn't need to get you more
	chub.mode_flags = DM_FLAG_FORCEPSAY
	chub.escapable = TRUE // good luck
	chub.escapechance = 40 // high chance of STARTING a successful escape attempt
	chub.escapechance_absorbed = 5 // m i n e
	chub.vore_verb = "soak"
	chub.count_absorbed_prey_for_sprite = FALSE
	chub.absorbed_struggle_messages_inside = list(
		"You try and push free from %pred's %belly, but can't seem to will yourself to move.",
		"Your fruitless mental struggles only cause %pred to purr happily.",
		"You can't make any progress freeing yourself from %pred's %belly.")
	chub.escape_attempt_absorbed_messages_owner = list(
		"%prey is attempting to free themselves from your %belly!")

	chub.escape_attempt_absorbed_messages_prey = list(
		"You try to force yourself out of %pred's %belly.",
		"You strain and push, attempting to reach out of %pred's %belly.",
		"You work up the will to try and force yourself free of %pred's clutches.")

	chub.escape_absorbed_messages_owner = list(
		"%prey forces themselves free of your %belly!")

	chub.escape_absorbed_messages_prey = list(
		"You finally manage to wrest yourself free from %pred's %belly, re-asserting your more usual form.",
		"You heave and push, eventually spilling out from %pred's %belly, eliciting a mildly annoyed flurry of wing flapping.")

	chub.escape_absorbed_messages_outside = list(
		"%prey suddenly forces themselves free of %pred's %belly!")

	chub.escape_fail_absorbed_messages_owner = list(
		"%prey's attempt to escape form your %belly has failed!")

	chub.escape_fail_absorbed_messages_prey = list(
		"Before you manage to reach freedom, you feel yourself getting dragged back into %pred's %belly!",
		"%pred cheeps playfully, simply pressing your wrigging form back into their %belly before you get anywhere.",
		"%pred holds a wing down on their %belly, the gentle pressure breaking your concentration and sending you sinking back into its form.",
		"Try as you might, you barely make an impression before %pred simply clenches with the most minimal effort, binding you back into their %belly.",
		"Unfortunately, %pred seems to have absolutely no intention of letting you go, and your futile effort goes nowhere.",
		"Strain as you might, you can't keep up the effort long enough before you sink back into %pred's %belly.")

/mob/living/simple_mob/vore/meowl/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food))
		if(health <= 0)
			return
		user.visible_message("<span class='notice'>\The [src] happily gulps down \the [O] right out of \the [user]'s hand, it seems pretty content now.</span>","<span class='notice'>\The [src] happily gulps down \the [O] right out of your hand, it seems pretty content now.</span>")
		user.drop_from_inventory(O)
		qdel(O)
		well_fed = world.time
		return
	return ..()

/mob/living/simple_mob/vore/meowl/PounceTarget(var/mob/living/M, var/successrate = 100)
	vore_pounce_cooldown = world.time + 1 SECONDS // don't attempt another pounce for a while
	if(prob(max(successrate,33))) // pounce success!
		M.Weaken(5)
		M.visible_message("<span class='danger'>\The [src] pounces on \the [M]!</span>!")
	else // pounce misses!
		M.visible_message("<span class='danger'>\The [src] attempts to pounce \the [M] but misses!</span>!")
		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

	if(will_eat(M) && (!M.canmove || vore_standing_too)) //if they're edible then eat them too
		return EatTarget(M)
	else
		return //just leave them

/datum/category_item/catalogue/fauna/meowl
	name = "Extra-Realspace Fauna - Meowl"
	desc = "Classification: Strigiline\
	<br><br>\
	These unusual creatures are sometimes found within redgate locations and seem to exhibit both the characteristics of a cat and of an owl. \
	Whilst these animals at a glance appear to be rather sweet and friendly, they are actually very competent predators and excellent opportunists. \
	They will very rarely attack their prey when there are other creatures nearby, preferring to wait until their target is alone and unprotected. \
	Despite this, these creatues can be rather docile in the right conditions, and will not attack those who it believes it can get food from reliably."
	value = CATALOGUER_REWARD_HARD

/datum/ai_holder/simple_mob/vore/meowl
	var/last_friend_time = 0

/datum/ai_holder/simple_mob/vore/meowl/engage_target()
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

	// Check if there is more than one person nearby and if they allow eating them
	if(!check_attacker(target)) //Only act friendly if you haven't been attacked yet
		var/list/crowd = list_targets()

		var/mob/living/L = target
		if(istype(L))
			if(!L.allowmobvore && vore_hostile && distance <= 8)
				play_friend(target)
				set_stance(STANCE_APPROACH)
				return

		if(crowd.len > 1 && distance <= 8)
			play_friend(target)
			set_stance(STANCE_APPROACH)
			return

	// Don't attack if you're well fed!

		var/mob/living/simple_mob/vore/meowl/M = holder

		if(istype(M))
			if(M.well_fed + 10 MINUTES > world.time)
				set_stance(STANCE_APPROACH)
				return


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

/datum/ai_holder/simple_mob/vore/meowl/proc/play_friend(target)
	if(last_friend_time + 60 SECONDS > world.time)
		return

	var/list/friend_text_close = list("nuzzles its head against \the [target] sweetly.",
								"lets out a cute little chirp and flaps its wings.",
								"wriggles its tail excitedly and begins to purr.",
								"hops up and down on the spot!",
								"looks at \the [target] with the biggest, roundest eyes that it can manage.",
								"claws at the ground for a moment, as if looking for something.",
								"stares off into the distance before letting out a quiet meow.",
								"cheeps a high pitch sound, before looking up.",
								"rubs its head gently against \the [target].",
								"raises a wing to wash under it.",
								"lets out a long, sing-songy mrowl.",
								"purrs happily as it snuggles up to \the [target].",
								"flaps its wings and wiggles its whole body.",
								"shakes rapidly to ruffle its own feathers."
								)
	var/list/friend_text_far = list("lets out a cute little chirp and flaps its wings.",
								"wriggles its tail excitedly and begins to purr.",
								"hops up and down on the spot!",
								"claws at the ground for a moment, as if looking for something.",
								"stares off into the distance before letting out a quiet meow.",
								"cheeps a high pitch sound, before looking up.",
								"raises a wing to wash under it.",
								"lets out a long, sing-songy mrowl.",
								"flaps its wings and wiggles its whole body.",
								"shakes rapidly to ruffle its own feathers."
								)

	var/distance = get_dist(holder, target)
	if(distance <= 1)
		var/talkies = pick(friend_text_close)
		holder.visible_message("<b>\The [holder]</b> [talkies]")
	else
		var/talkies = pick(friend_text_far)
		holder.visible_message("<b>\The [holder]</b> [talkies]")
	last_friend_time = world.time
