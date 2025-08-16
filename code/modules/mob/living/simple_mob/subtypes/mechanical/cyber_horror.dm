//Fodder
/mob/living/simple_mob/mechanical/cyber_horror
	name = "Cyber horror"
	desc = "What was once a man, twisted and warped by machine."
	icon = 'icons/mob/cyber_horror.dmi'
	icon_state = "cyber_horror"
	icon_dead = "cyber_horror_dead"
	icon_gib = "cyber_horror_dead"

	faction = "synthtide"

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/cyber_horror

	maxHealth = 175
	health = 175

	melee_damage_lower = 5
	melee_damage_upper = 10

	movement_cooldown = 3
	movement_sound = 'sound/effects/houndstep.ogg'
	// To promote a more diverse weapon selection.
	armor = list(melee = 25, bullet = 25, laser = -20, bio = 100, rad = 100)
	hovering = FALSE

	say_list_type = /datum/say_list/cyber_horror

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	attacktext = list ("wildly struck", "lunged against", "battered")
	attack_sound = 'sound/weapons/punch3.ogg'

	var/emp_damage = 0
	var/nanobot_chance = 40

/datum/say_list/cyber_horror
	speak = list("H@!#$$P M@!$#",
					"GHAA!@@#",
					"KR@!!N",
					"K!@@##L!@@ %!@#E",
					"G@#!$ H@!#%",
					"H!@%%@ @!E")
	emote_hear = list("sparks!", "groans.", "wails.", "sobs.")
	emote_see = list ("stares unblinkingly.", "jitters and twitches.", "emits a synthetic scream.", "rapidly twitches.", "convulses.", "twitches uncontrollably.", "goes stock still.")
	say_threaten = list ("FR@#DOM","EN@ T#I$-$","N0$ M^> B@!#")
	say_got_target = list("I *#@ Y@%","!E@#$P","F#RR @I","D0@#$ ##OK %","IT $##TS")
	threaten_sound = 'sound/mob/robots/Cyber_Horror.ogg'

/datum/ai_holder/simple_mob/melee/evasive/cyber_horror
	threaten = TRUE
	threaten_delay = 1 SECOND
	threaten_timeout = 30 SECONDS

/datum/ai_holder/simple_mob/melee/cyber_horror
	threaten = TRUE
	threaten_delay = 1 SECOND
	threaten_timeout = 30 SECONDS

/datum/ai_holder/simple_mob/melee/hit_and_run/cyber_horror
	threaten = TRUE
	threaten_delay = 1 SECOND
	threaten_timeout = 30 SECONDS

/datum/ai_holder/simple_mob/ranged/kiting/cyber_horror
	threaten = TRUE
	threaten_delay = 1 SECOND
	threaten_timeout = 30 SECONDS

// Fragile but dangerous
/mob/living/simple_mob/mechanical/cyber_horror/plasma_cyber_horror
	name = "Nanite husk"
	desc = "What was once a phoronoid, now a empty shell of malfunctioning nanites."
	icon_state = "plasma_cyber_horror"
	icon_dead = "plasma_cyber_horror_dead"
	say_list_type = /datum/say_list/cyber_horror/plasma

	armor = list(melee = 40, bullet = -10, laser = 40, bio = 100, rad = 100)
	maxHealth = 75
	health = 75

	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = "splattered on"
	attack_sound = 'sound/effects/slime_squish.ogg'

// Do y'like brain damage?
	var/poison_chance = 100
	var/poison_per_bite = 3
	var/poison_type = "neurophage_nanites"

/datum/say_list/cyber_horror/plasma
	threaten_sound = 'sound/mob/robots/Cyber_Horror_Plasma.ogg'

/mob/living/simple_mob/mechanical/cyber_horror/plasma_cyber_horror/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/mechanical/cyber_horror/plasma_cyber_horror/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, span_warning("You feel nanites digging into your skin!"))
		L.reagents.add_reagent(poison_type, poison_per_bite)


// Mech Shredder
/mob/living/simple_mob/mechanical/cyber_horror/ling_cyber_horror
	name = "Nanite abomination"
	desc = "What was once something, now an exposed shell with lashing cables."
	icon_state = "ling_cyber_horror"
	icon_dead = "ling_cyber_horror_dead"
	say_list_type = /datum/say_list/cyber_horror/ling

	maxHealth = 250
	health = 250
// Four attacks per second.
	melee_damage_lower = 10
	melee_damage_upper = 20
	attack_armor_pen = 50
	base_attack_cooldown = 2.5
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/mob/robots/Cyber_Horror_ChangelingMelee.ogg'
	attacktext = list ("sliced", "diced", "lashed", "shredded")
// Slow as all sin
	movement_cooldown = 9
	movement_sound = 'sound/effects/houndstep.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/melee/cyber_horror

// You do NOT Want to get in touchy range of this thing.
	armor = list(melee = 75, bullet = -10, laser = -25, bio = 100, rad = 100)
	hovering = FALSE


// Leaping is a special attack, so these values determine when leap can happen.
// Leaping won't occur if its on cooldown, set to a minute due to it purely break formations.
	special_attack_min_range = 2
	special_attack_max_range = 7
	special_attack_cooldown = 60 SECONDS
// How long the leap telegraphing is.
	var/leap_warmup = 2 SECOND
	var/leap_sound = 'sound/mob/robots/Cyber_Horror_ChangelingLeap.ogg'

/datum/say_list/cyber_horror/ling
	threaten_sound = 'sound/mob/robots/Cyber_Horror_Changeling.ogg'

// Multiplies damage if the victim is stunned in some form, including a successful leap.
/mob/living/simple_mob/mechanical/cyber_horror/ling_cyber_horror/apply_bonus_melee_damage(atom/A, damage_amount)
	if(isliving(A))
		var/mob/living/L = A
		if(L.incapacitated(INCAPACITATION_DISABLED))
			return damage_amount * 2.5
	return ..()

// The actual leaping attack.
/mob/living/simple_mob/mechanical/cyber_horror/ling_cyber_horror/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
// For the telegraphing.
	sleep(leap_warmup)

// Do the actual leap.
// Lets us pass over everything.
	status_flags |= LEAPING
	visible_message(span_danger("\The [src] leaps at \the [A]!"))
	throw_at(get_step(get_turf(A), get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, leap_sound, 75, 1)
// For the throw to complete. It won't hold up the AI SSticker due to waitfor being false.
	sleep(5)

// Revert special passage ability.
	if(status_flags & LEAPING)
		status_flags &= ~LEAPING
// Where we landed. This might be different than A's turf.
	var/turf/T = get_turf(src)

	. = FALSE

// Now for the stun.
	var/mob/living/victim = null
// So player-controlled cyber horrors only need to click the tile to stun them.
	for(var/mob/living/L in T)
		if(L == src)
			continue

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.check_shields(damage = 0, damage_source = src, attacker = src, def_zone = null, attack_text = "the leap"))
// We were blocked.
				continue

		victim = L
		break

	if(victim)
		victim.Weaken(2)
		victim.visible_message(span_danger("\The [src] knocks down \the [victim]!"))
		to_chat(victim, span_critical("\The [src] jumps on you!"))
		. = TRUE

	set_AI_busy(FALSE)


//Slightly more durable fodder
/mob/living/simple_mob/mechanical/cyber_horror/vox
	name = "Vox shambles"
	desc = "Once a Vox now torn and changed, peices of a Durand has been grafted onto it."
	icon_state = "vox_cyber_horror"
	icon_dead = "vox_cyber_horror_dead"
	say_list_type = /datum/say_list/cyber_horror/vox

	armor = list(melee = 40, bullet = 30, laser = 30, bio = 100, rad = 100)
	ai_holder_type = /datum/ai_holder/simple_mob/melee/cyber_horror

/datum/say_list/cyber_horror/vox
	threaten_sound = 'sound/mob/robots/Cyber_Horror_Vox.ogg'


// Hit and run mob
/mob/living/simple_mob/mechanical/cyber_horror/tajaran
	name = "Tajaran cyber stalker"
	desc = "A mangled mess of machine and fur, light seems to bounce off it."
	icon_state = "tajaran_cyber_horror"
	icon_dead = "tajaran_cyber_horror_dead"
	say_list_type = /datum/say_list/cyber_horror/tajaran
	attack_sound = 'sound/weapons/meleetear.ogg'


	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run/cyber_horror

	var/cloaked_alpha = 30
	var/cloaked_bonus_damage = 30
	var/cloaked_weaken_amount = 3
	var/cloak_cooldown = 10 SECONDS
	var/last_uncloak = 0

/datum/say_list/cyber_horror/tajaran
	threaten_sound = 'sound/mob/robots/Cyber_Horror_Tajaran.ogg'

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/cloak()
	if(cloaked)
		return
	animate(src, alpha = cloaked_alpha, time = 1 SECOND)
	cloaked = TRUE

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/uncloak()
	last_uncloak = world.time
	if(!cloaked)
		return
	animate(src, alpha = initial(alpha), time = 1 SECOND)
	cloaked = FALSE

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/proc/can_cloak()
	if(stat)
		return FALSE
	if(last_uncloak + cloak_cooldown > world.time)
		return FALSE

	return TRUE

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/break_cloak()
	uncloak()

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/is_cloaked()
	return cloaked

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/handle_special()
	if(!cloaked && can_cloak())
		cloak()

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/apply_bonus_melee_damage(atom/A, damage_amount)
	if(cloaked)
		return damage_amount + cloaked_bonus_damage
	return ..()

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/apply_melee_effects(atom/A)
	if(cloaked)
		if(isliving(A))
			var/mob/living/L = A
			L.Weaken(cloaked_weaken_amount)
			to_chat(L, span_danger("\The [src] tears into you!"))
			playsound(L, 'sound/weapons/spiderlunge.ogg', 75, 1)
	uncloak()
	..()

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/bullet_act(obj/item/projectile/P)
	. = ..()
	break_cloak()

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	. = ..()
	break_cloak()


//Arcing Ranged Mob
/mob/living/simple_mob/mechanical/cyber_horror/grey
	name = "Twisted cyber horror"
	desc = "A mess of machine and organic, it's hard to even know what it was before."
	icon_state = "grey_cyber_horror"
	icon_dead = "grey_cyber_horror_dead"
	maxHealth = 100
	health = 100
	say_list_type = /datum/say_list/cyber_horror/grey

	projectiletype = /obj/item/projectile/arc/blue_energy
	projectilesound = 'sound/weapons/plasmaNEW.ogg'
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/cyber_horror

	armor = list(melee = -30, bullet = 10, laser = 10, bio = 100, rad = 100)

/datum/say_list/cyber_horror/grey
	threaten_sound = 'sound/mob/robots/Cyber_Horror_Grey.ogg'


//Direct Ranged Mob
/mob/living/simple_mob/mechanical/cyber_horror/corgi
	name = "Malformed Corgi"
	desc = "Pieces of metal and technology is embedded in this Ian."
	icon_state = "corgi_cyber_horror"
	icon_dead = "corgi_cyber_horror_dead"
	maxHealth = 50
	health = 50
	say_list_type = /datum/say_list/cyber_horror/corgi

	base_attack_cooldown = 4
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/SmallLaser.ogg'
	movement_sound = 'sound/effects/servostep.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening

/datum/say_list/cyber_horror/corgi
	threaten_sound = 'sound/mob/robots/Cyber_Horror_Corgi.ogg'


//Cats and mayhem
/mob/living/simple_mob/mechanical/cyber_horror/cat_cyber_horror
	name = "Twisted cat"
	desc = "While most things are acceptable, putting cat legs on this - only made it worse."

	icon_state = "cat_cyber_horror"
	icon_dead = "cat_cyber_horror_dead"
	say_list_type = /datum/say_list/cyber_horror/cat

	maxHealth = 40
	health = 40
	movement_cooldown = 0
	movement_sound = 'sound/effects/servostep.ogg'

	pass_flags = PASSTABLE
	mob_swap_flags = 0
	mob_push_flags = 0

	melee_damage_lower = 2
	melee_damage_upper = 2
// Four attacks per second.
	base_attack_cooldown = 2.5
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/weapons/bite.ogg'

	attacktext = list("jabbed", "injected")

// Do y'like drugs?
	var/poison_chance = 75
	var/poison_per_bite = 3
	var/poison_type = REAGENT_ID_MINDBREAKER

/datum/say_list/cyber_horror/cat
	threaten_sound = 'sound/mob/robots/Cyber_Horror_Cat.ogg'

/mob/living/simple_mob/mechanical/cyber_horror/cat_cyber_horror/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/mechanical/cyber_horror/cat_cyber_horror/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, span_warning("You feel an uncomfortable prick!"))
		L.reagents.add_reagent(poison_type, poison_per_bite)

//These are the projectiles mobs use
/obj/item/projectile/beam/drone
	damage = 3

/obj/item/projectile/arc/blue_energy
	name = "energy missle"
	icon_state = "force_missile"
	damage = 12
	damage_type = BURN
