////////////////////////////
//		Basic Cultist
////////////////////////////

/datum/category_item/catalogue/fauna/cultist
	name = "Cultists"
	desc = "The Galactic Awakening unlocked the psionic potential of many \
	from rim to rim. The first to notice this font of power were those who \
	were already the faithful devotees of esoteric religions. The rise of Blood \
	Cultists in service to the Geometer quickly became an intergalactic incident. \
	Although NanoTrasen and other entities have risen to combat these foes, a \
	vast array of Hermetic Orders now command frightening power."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/cultist)

// Obtained by scanning all X.
/datum/category_item/catalogue/fauna/all_cultists
	name = "Collection - Cultists"
	desc = "You have scanned a large array of different types of Cultist, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_SUPERHARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/cultist/human,
		/datum/category_item/catalogue/fauna/cultist/tesh,
		/datum/category_item/catalogue/fauna/cultist/lizard,
		/datum/category_item/catalogue/fauna/cultist/caster,
		/datum/category_item/catalogue/fauna/cultist/initiate,
		/datum/category_item/catalogue/fauna/cultist/castertesh,
		/datum/category_item/catalogue/fauna/cultist/elite,
		/datum/category_item/catalogue/fauna/cultist/magus,
		/datum/category_item/catalogue/fauna/cultist/hunter
		)

/mob/living/simple_mob/humanoid/cultist //Do not spawn this on in directly it is simply a base for the rest namely the unique death animations.
	name = "Cultist"
	desc = "An awfully frail and ghastly looking individual"
	tt_desc = "NULL"
	icon = 'icons/mob/cultists.dmi'
	icon_state = "initiate"
	faction = "cult"
	mob_class = MOB_CLASS_DEMONIC

/datum/category_item/catalogue/fauna/cultist/human
	name = "Cultists - Human"
	desc = "The first wave of zealots faced by many on the Frontier were \
	human. For a short while it was assumed that humans were somehow more \
	susecptible to Paracausal influence. Although this belief has long since \
	been disproven, the large Human population on the Frontier has ensured \
	that the species is overrepresented amongst the ranks of Cult aggressors."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/humanoid/cultist/human
	name = "cultist"
	desc = "A fanatical zealot armed with a darkly colored sword."
	icon_state = "cultist"
	icon_living = "cultist"
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/human)

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30	//Cult Sword Damage
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 80, bomb = 30, bio = 100, rad = 100)	// Same armor are cult armor, may nerf since DAMN THAT IS GOOD ARMOR
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 3

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/human/death()
	new /obj/effect/decal/remains/human (src.loc)
	..(null,"let's out a maddening laugh as his body crumbles away.")
	ghostize()
	qdel(src)

/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt //Teleporting Cultists

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	var/jaunt_warning = 0.5 SECONDS	// How long the jaunt telegraphing is.
	var/jaunt_tile_speed = 20		// How long to wait between each tile. Higher numbers result in an easier to dodge tunnel attack.

// In Theory this Jury Rigged Code form Tunneler Spiders Should Allow Wraiths to Jaunt
	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 10 SECONDS

/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Save where we're gonna go soon.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)

	// Telegraph to give a small window to dodge if really close.
	flick("bloodout",A)
	icon_state = "bloodout"
	sleep(jaunt_warning) // For the telegraphing.

	// Do the dig!
	visible_message(span_danger("\The [src] sinks into a puddle of blood \the [A]!"))
	new /obj/effect/decal/cleanable/blood (src.loc)
	flick("blood_out",A)
	icon_state = "bloodout"

	if(handle_jaunt(destination) == FALSE)
		set_AI_busy(FALSE)
		flick("bloodin",A)
		icon_state = "bloodin"
		return FALSE

	// Did we make it?
	if(!(src in destination))
		set_AI_busy(FALSE)
		icon_state = "bloodin"
		flick("bloodin",A)
		return FALSE

	var/overshoot = TRUE

	// Test if something is at destination.
	for(var/mob/living/L in destination)
		if(L == src)
			continue

		visible_message(span_danger("\The [src] suddenly rises from a pool of blood \the [L]!"))
		new /obj/effect/decal/cleanable/blood (src.loc)
		playsound(L, 'sound/weapons/heavysmash.ogg', 75, 1)
		L.add_modifier(/datum/modifier/entangled, 1 SECONDS) //L.Weaken(3) CHOMPedit: Trying to remove hardstuns, replacing it with slow down
		overshoot = FALSE

	if(!overshoot) // We hit the target, or something, at destination, so we're done.
		set_AI_busy(FALSE)
		icon_state = "bloodin"
		flick("bloodin",A)
		return TRUE

	// Otherwise we need to keep going.
	to_chat(src, span_warning("You overshoot your target!"))
	playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
	var/dir_to_go = get_dir(starting_turf, destination)
	for(var/i = 1 to rand(2, 4))
		destination = get_step(destination, dir_to_go)

	if(handle_jaunt(destination) == FALSE)
		set_AI_busy(FALSE)
		icon_state = "bloodin"
		flick("bloodin",A)
		return FALSE

	set_AI_busy(FALSE)
	icon_state = "bloodin"
	flick("bloodin",A)
	return FALSE

// Does the jaunt movement
/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/proc/handle_jaunt(turf/destination)
	var/turf/T = get_turf(src) // Hold our current tile.

	// Regular tunnel loop.
	for(var/i = 1 to get_dist(src, destination))
		if(stat)
			return FALSE // We died or got knocked out on the way.
		if(loc == destination)
			break // We somehow got there early.

		// Update T.
		T = get_step(src, get_dir(src, destination))
		if(T.check_density(ignore_mobs = TRUE))
			to_chat(src, span_critical("You hit something really solid!"))
			playsound(src, "punch", 75, 1)
			Weaken(5)
			add_modifier(/datum/modifier/tunneler_vulnerable, 10 SECONDS)
			return FALSE // Hit a wall.

		// Get into the tile.
		forceMove(T)


/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/should_special_attack(atom/A)
	// Make sure its possible for the wraith to reach the target so it doesn't try to go through a window.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)
	var/turf/T = starting_turf
	for(var/i = 1 to get_dist(starting_turf, destination))
		if(T == destination)
			break

		T = get_step(T, get_dir(T, destination))
		if(T.check_density(ignore_mobs = TRUE))
			return FALSE
	return T == destination

////////////////////////////
//		Teshari Cultist
////////////////////////////

/datum/category_item/catalogue/fauna/cultist/tesh
	name = "Cultists - Teshari"
	desc = "Teshari cultists project a curiously sinister air. Perhaps \
	due to their diminutive stature, these creatures are sometimes not \
	regarded as genuine threats when compared to their more imposing companions. \
	To ignore a Teshari fanatic is a fool's errand. Fast, hard to hit, and \
	tenacious, Teshari form the vanguard of many fanatical assaults."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/humanoid/cultist/tesh
	name = "cultist"
	desc = "A sinister looking hooded Teshari armed with a curved knife."
	icon_state = "culttesh"
	icon_living = "culttesh"
	maxHealth = 75
	health = 75
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/tesh)

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_armor_pen = 25
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 45, bullet = 40, laser = 30, energy = 80, bomb = 20, bio = 100, rad = 100)	// Reduced Resistance to Approximate increased Tesh damage.
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 2

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/tesh/death()
	new /obj/effect/decal/cleanable/ash (src.loc)
	..(null,"let's out a shrill chirp as his body turns to dust.")
	ghostize()
	qdel(src)

////////////////////////////
//		Lizard Cultist
////////////////////////////

/datum/category_item/catalogue/fauna/cultist/lizard
	name = "Cultists - Lizard"
	desc = "The Unathi Kingdom of Moghes has stamped down heavily on the \
	heretical activities of religious sects not approved by the State. Due \
	to this, many Unathi seeking religious freedom have fled to the Frontier. \
	Unfortunately, some of those who took this path have fallen prey to true \
	evil. Possessing the zeal of the oppressed, Unathi cultists are deadly \
	fanatics, eager to shred their enemies apart in close quarters, regardless \
	of what damage they themselves incur."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/humanoid/cultist/lizard
	name = "cultist"
	desc = "With a knife in each hand, this lizard looks ready to disect you."
	icon_state = "cultliz"
	icon_living = "cultliz"
	maxHealth = 200
	health = 200
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/lizard)

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 70, bullet = 60, laser = 30, energy = 80, bomb = 35, bio = 100, rad = 100)	// Better Armor to match lizard brute resist
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 4
	base_attack_cooldown = 7.5 //Two knives mean double stab.

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/lizard/death()
	new /obj/effect/decal/remains/unathi (src.loc)
	..(null,"hisses as he collapses into a pile of bones.")
	ghostize()
	qdel(src)

////////////////////////////
//		Blood Mage
////////////////////////////

/datum/category_item/catalogue/fauna/cultist/caster
	name = "Cultists - Blood Mage"
	desc = "For those servants of a Cult who possess enough latent ability, \
	the channelling of Paracausal power is a very real skill to be honed and \
	exploited. Blood Mages learn to fuel paranatural assaults using their own \
	life force. Necessarily short lived, these cultists believe that bleeding \
	themselves dry is a statement of faith. Able to fire beams of dark energy \
	at their foes, these fanatics should be primarily engaged by PMD response \
	teams."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/humanoid/cultist/caster
	name = "Blood Mage"
	desc = "A Robed individual whose hands pulsate with unnatural power."
	icon_state = "caster"
	icon_living = "caster"
	maxHealth = 150
	health = 150
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/caster)

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 100, rad = 100)	//Armor Rebalanced for Cult Robes.
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 4
	projectiletype = /obj/item/projectile/beam/inversion
	projectilesound = 'sound/weapons/spiderlunge.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged

/mob/living/simple_mob/humanoid/cultist/caster/death()
	new /obj/effect/decal/remains/human (src.loc)
	new /obj/effect/decal/cleanable/blood/gibs (src.loc)
	..(null,"melts into a pile of blood and bones.")
	ghostize()
	qdel(src)

////////////////////////////
//		Blood Initiate
////////////////////////////

/datum/category_item/catalogue/fauna/cultist/initiate
	name = "Cultists - Initiate"
	desc = "After the Awakening, some who thirst for power or belonging \
	saw an opportunity to have their darker desires fulfilled. These converts \
	are accepted into the ranks of Cults across the galaxy regardless of whether \
	they possess psionic potential are not. Those that do ascend through the \
	ranks, whereas those that don't may still serve as cannon fodder and sacrifices."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/humanoid/cultist/initiate
	name = "Blood Intiate"
	desc = "A Novice Amongst his betters, he still seems determined to slice you to bits."
	icon_state = "initiate"
	icon_living = "initiate"
	maxHealth = 150
	health = 150
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/initiate)

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 100, rad = 100)	//Armor Rebalanced for Cult Robes.
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 4

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/initiate/death()
	new /obj/effect/decal/remains/human (src.loc)
	..(null,"lets out a horrified scream as his body crumbles away.")
	ghostize()
	qdel(src)

////////////////////////////
//		Teshari Mage
////////////////////////////

/datum/category_item/catalogue/fauna/cultist/castertesh
	name = "Cultists - Teshari Mage"
	desc = "Similar in skill to their human counter parts, Teshari mages \
	are regarded as more ferocious combatants. Able to cast paracausal beams \
	at a rapid pace with ease, Teshari Mages are a priority target of any \
	response team, and any who discount their threat are quickly shown the \
	error of their ways."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/humanoid/cultist/castertesh
	name = "Teshari Mage"
	desc = "This Teshari seems to have forsoken weapons for unfanthomable power."
	icon_state = "castertesh"
	icon_living = "castertesh"
	maxHealth = 75
	health = 75
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/castertesh)

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 35, bullet = 20, laser = 35, energy = 60, bomb = 20, bio = 100, rad = 100)	//Rebalanced for Robes and Tesh damage
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 2
	base_attack_cooldown = 7.5
	projectiletype = /obj/item/projectile/beam/inversion
	projectilesound = 'sound/weapons/spiderlunge.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/humanoid/cultist/castertesh/death()
	new /obj/effect/decal/cleanable/ash (src.loc)
	..(null,"burns away into nothing.")
	ghostize()
	qdel(src)

////////////////////////////
//		Elite Cultist
////////////////////////////

/datum/category_item/catalogue/fauna/cultist/elite
	name = "Cultists - Elite"
	desc = "Cultists who preceded the Great Awakening are often regarded \
	with immense respect. Truly devoted, these adherents learned many rites \
	and rituals before they ever bore true power. As such, Elite Cultists \
	possess a working knowledge of many arcane arts, and are trusted with \
	the rare Paracausal artifacts possessed by their orders. From mirror \
	shields to arcane sets of armor, Elites command fear, and inspire the \
	fanaticism of their subordinates."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/humanoid/cultist/elite
	name = "Elite Cultist"
	desc = "A heavily armed cultist with a mirror shield that hurts to look at."
	icon_state = "cult_elite"
	icon_living = "cult_elite"
	faction = "cult"
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/elite)

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30	//Cult Sword Damage
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 80, bomb = 30, bio = 100, rad = 100)	// Same armor are cult armor, may nerf since DAMN THAT IS GOOD ARMOR
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 3

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/elite/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(30))
			visible_message(span_danger("\The [src] blocks \the [O] with its shield!"))
			if(user)
				ai_holder.react_to_attack(user)
			return
		else
			..()
	else
		to_chat(user, span_warning("This weapon is ineffective, it does no damage."))
		visible_message(span_warning("\The [user] gently taps [src] with \the [O]."))

/mob/living/simple_mob/humanoid/cultist/elite/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(50))
		visible_message(span_bolddanger("[Proj] disappears into the mirror world as it hits the shield."))
		if(Proj.firer)
			ai_holder.react_to_attack(Proj.firer)
		return
	else
		..()

/mob/living/simple_mob/humanoid/cultist/elite/death()
	new /obj/effect/decal/remains/human (src.loc)
	new /obj/effect/decal/cleanable/blood/gibs (src.loc)
	new /obj/item/material/shard (src.loc)
	..(null,"shatters into bone and blood like pieces like the now shattered mirror.")
	playsound(src, 'sound/effects/Glassbr2.ogg', 100, 1)
	ghostize()
	qdel(src)

////////////////////////////
//		Cult Magus
////////////////////////////

/datum/category_item/catalogue/fauna/cultist/magus
	name = "Cultists - Blood Magus"
	desc = "The Blood Magus commands their local chapter with total authority. \
	These religious leaders possess an unparalleled knowledge of their cult's \
	secrets, rituals, and tenets. To attain the rank of Magus, a Cultist must \
	possess great psionic power. Their ability to channel Paracausal energy is \
	unparalled amongst their peers. Wielding dark gifts granted by darker gods, \
	the Magus is a priority target in any engagement."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/humanoid/cultist/magus
	name = "Blood Magus"
	desc = "A leader of the bloody cult and master of the forbidden arts, wielding powers beyond that of mortal men."
	icon_state = "magus"
	icon_living = "magus"
	maxHealth = 300 //Boss Mobs should be tanky.
	health = 300
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/magus)

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30	//Ritual Knife
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 50, energy = 80, bomb = 30, bio = 100, rad = 100)	//Super Armor since Boss Mob
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 4

	projectiletype = /obj/item/projectile/beam/inversion
	base_attack_cooldown = 5
	projectilesound = 'sound/weapons/spiderlunge.ogg'
	var/obj/item/shield_projector/shields = null

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/humanoid/cultist/magus/death()
	new /obj/effect/decal/cleanable/blood/gibs (src.loc)
	..(null,"let's out a dark laugh as it collapses into a puddle of blood.")
	ghostize()
	qdel(src)

/mob/living/simple_mob/humanoid/cultist/magus/Initialize(mapload)
	shields = new /obj/item/shield_projector/rectangle/automatic/magus(src)
	return ..()

/obj/item/shield_projector/rectangle/automatic/magus
	name = "cult shield stone"
	desc = "A stone wielded by only the most powerful of cult leaders. It projects a shield around the user."
	icon = 'icons/obj/device.dmi'
	icon_state = "implant_melted"
	shield_health = 200
	max_shield_health = 200
	shield_regen_delay = 10 SECONDS
	shield_regen_amount = 10
	size_x = 1
	size_y = 1
	color = "#f50202"
	high_color = "#ff0404"
	low_color = "#690000"
////////////////////////////
//		Blood Hunter
////////////////////////////

/datum/category_item/catalogue/fauna/cultist/hunter
	name = "Cultists - Blood Hunter"
	desc = "Whether the Blood Hunter may be considered human still remains \
	a hotly contested topic. There is further debate regarding whether every \
	instance of the Blood Hunter is the same entity, or whether this condition \
	is some manner of Paranatural affliction or status. It is speculated that \
	the Blood Hunter was once a mortal devotee of the Geometer, and has somehow \
	ascended to the rank of Paracausal Being. The Blood Hunter is a killer without \
	peer. If encountered, retreat and contact the PMD immediately."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/humanoid/cultist/hunter // This Mob is not meant to be fair, he is not meant to fight regular crew he is to be pitted against heavily armed explo teams to see if he can wipe them out.
	name = "Blood Hunter" // TO BE CLEAR: DO NOT SPAWN THIS GUY ON THE SHIP/STATION HE WILL MURDER EVERYTHING.
	desc = "The smell of blood fills the air, how delicious it tastes. Let the hunt begin." // He is a horrifying lovechild of Caleb and a blooborne hunter.
	icon_state = "hunterb" // He probably shouldn't even have other mobs supporting him.
	icon_living = "hunterb"
	maxHealth = 300 //Boss Mobs should be tanky.
	health = 300
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/hunter)

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 42	//Saw Cleaver Brutality
	melee_damage_upper = 42
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 50, energy = 80, bomb = 30, bio = 100, rad = 100)	//Super Armor since Boss Mob
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 0 //This is so he can't be kited well

	projectiletype = /obj/item/projectile/bullet/pellet/shotgun

	base_attack_cooldown = 7.5

	// loot_list = list(/obj/item/material/butterfly/saw = 100, /obj/item/gun/projectile/shotgun/doublebarrel/sawn/alt = 100) // Downstream

	needs_reload = TRUE
	reload_max = 2
	projectilesound = 'sound/weapons/Gunshot_shotgun.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive/blood_hunter

/mob/living/simple_mob/humanoid/cultist/hunter/death()
	new /obj/effect/decal/cleanable/blood/gibs (src.loc)
	..(null,"laughs as he melts away. His laughs echo through the air even after only a dense red goo remains.")
	ghostize()
	qdel(src)


////////////////////////////
//		Hunter AI
////////////////////////////

/datum/ai_holder/simple_mob/ranged/aggressive/blood_hunter //This directs the AI to charge while shooting at its victim then entering Glorious melee combat.
	pointblank = FALSE
	closest_distance = 0

////////////////////////////
//		Ash Hunter
////////////////////////////


/mob/living/simple_mob/humanoid/cultist/hunter/surt // This Mob is not meant to be fair, he is not meant to fight regular crew he is to be pitted against heavily armed explo teams to see if he can wipe them out.
	name = "Itinerant Blood Hunter"
	desc = "This Blood Hunter is far from home. Strange energies course around him, protecting him from the environment. What eldritch influence drew him to this place?" // Blood Hunter on vacation.

	heat_resist = 1 //Might make this 0.75 if 1 is too much resistance for a boss monster. This guy's just a placeholder until we get the Miner in anyways.
