/mob/living/simple_mob/vore/cryptdrake
	name = "crypt drake"
	desc = "A massive drake-like creature with dark purple scales and a seemingly exposed skull."
	tt_desc = "Draconis necrotis"
	icon = 'icons/mob/vore128x64.dmi'
	icon_dead = "cryptdrake-dead"
	icon_living = "cryptdrake"
	icon_state = "cryptdrake"
	icon_rest = "cryptdrake"
	faction = FACTION_DRAGON
	old_x = -48
	old_y = 0
	vis_height = 92
	melee_damage_lower = 20
	melee_damage_upper = 15
	friendly = list("nudges", "sniffs on", "rumbles softly at", "nuzzles")
	default_pixel_x = -48
	pixel_x = -48
	pixel_y = 0
	response_help = "bumps"
	response_disarm = "shoves"
	response_harm = "bites"
	movement_cooldown = -1
	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 20
	maxHealth = 1000
	attacktext = list("mauled")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/vore
	max_buckled_mobs = 1
	mount_offset_y = 32
	mount_offset_x = -16
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	max_tox = 0 // immune to poison

	special_attack_min_range = 2
	special_attack_max_range = 4
	special_attack_cooldown = 30 SECONDS

	var/leap_warmup = 2 SECOND // How long the leap telegraphing is.
	var/leap_sound = 'sound/weapons/spiderlunge.ogg'

/mob/living/simple_mob/vore/cryptdrake

	vore_bump_chance = 25
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 100
	vore_active = 1
	vore_icons = 2
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 2
	swallowTime = 50
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_DIGEST
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to devour"

/mob/living/simple_mob/vore/cryptdrake/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	add_verb(src, /mob/living/simple_mob/proc/animal_mount)
	add_verb(src, /mob/living/proc/toggle_rider_reins)
	movement_cooldown = -1

/mob/living/simple_mob/vore/cryptdrake/init_vore()
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The enormous beast snaps it's boney jaws around your form, effortlessly lifting you from the ground. Throwing it's head backwards, your body is tossed up momentarily as the maw parts wider, only for you to descend rapidly moments later. You're caught in the creature's throat for a moment, contracting dark purple flesh holding tightly onto you, there's no going back at this point. The peristaltic motions squeeze you down this tunnel towards your final destination, where you're soon relieved of the intense squelching to be pushed into a move flexible, stretching chamber. Immediately coated in caustic oozes, the world around you seems more than eager to ensure that you're soaked over every inch, wrinkled walls twisting and grinding around your body. The drake's stomach clenches and compresses over you rhythmically, attempting to eagerly add you to the soup of fluids that fill this sloshing gut. Omnipresent sounds of groaning, gurgling and burbling bodily functions signify just how active this process already is."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_THICKBELLY
	B.fancy_vore = 1
	B.selective_preference = DM_DIGEST
	B.vore_verb = "devour"
	B.digest_brute = 3
	B.digest_burn = 2
	B.digest_oxy = 0
	B.digestchance = 50
	B.absorbchance = 0
	B.escapechance = 3
	B.escape_stun = 5
	B.contamination_color = "grey"
	B.contamination_flavor = "Wet"
	B.emote_lists[DM_DIGEST] = list(
		"The drake growls in annoyance before clenching those wrinkled walls tight against your form, grinding away at you!",
		"As the beast wanders about, you're forced to slip and slide around amidst a pool of thick digestive goop, sinking briefly into the thick, heavy walls!",
		"You can barely hear the drake let out a pleased rumble as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The drake happily wanders around while digesting its meal, almost like it is trying to show off the hanging gut you've given it. Not like it made much of a difference on his already borderline obese form anyway~")

/mob/living/simple_mob/vore/cryptdrake/do_special_attack(atom/A)	//Mostly copied from hunter.dm
	set waitfor = FALSE
	if(!isliving(A))
		return FALSE
	var/mob/living/L = A
	if(!L.devourable || !L.allowmobvore || !L.can_be_drop_prey || !L.throw_vore || L.unacidable)
		return FALSE

	set_AI_busy(TRUE)
	visible_message(span_warning("\The [src]'s eyes flash ominously!"))
	to_chat(L, span_danger("\The [src] focuses on you!"))
	// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
	sleep(leap_warmup) // For the telegraphing.

	if(L.z != z)	//Make sure you haven't disappeared to somewhere we can't go
		set_AI_busy(FALSE)
		return FALSE

	// Do the actual leap.
	status_flags |= LEAPING // Lets us pass over everything.
	visible_message(span_critical("\The [src] leaps at \the [L]!"))
	throw_at(get_step(L, get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, leap_sound, 75, 1)

	sleep(5) // For the throw to complete. It won't hold up the AI ticker due to waitfor being false.

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING // Revert special passage ability.

	set_AI_busy(FALSE)
	if(Adjacent(L))	//We leapt at them but we didn't manage to hit them, let's see if we're next to them
		L.Weaken(2)	//get knocked down, idiot

/mob/living/simple_mob/vore/cryptdrake/albedo //A slight variation of the cryptdrake requested for an event with glowing eyes
	icon_dead = "cryptdrake_albedo-dead"
	icon_living = "cryptdrake_albedo"
	icon_state = "cryptdrake_albedo"
	icon_rest = "cryptdrake_albedo"
	has_eye_glow = TRUE
