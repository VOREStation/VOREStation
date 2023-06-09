/datum/category_item/catalogue/fauna/space_ghost
	name = "Alien Wildlife - Space Ghost"
	desc = "A mysterious and unknown creature made of radical energy.\
	This creature's energy interferes the nervous system in many kinds of creatures, which may result in hallucinations.\
	This creature's lack of a physical form leaves it quite resistant to physical damage.\
	Smaller variants of this creature seem to be vulnerable to bright light.\
	While both variants are quite vulnerable to laser and energy weapons."
	value = CATALOGUER_REWARD_EASY


/mob/living/simple_mob/vore/alienanimals/space_ghost
	name = "space ghost"
	desc = "A pulsing mass of darkness that seems to have gained sentience."
	tt_desc = "?????"
	catalogue_data = list(/datum/category_item/catalogue/fauna/space_ghost)

	icon = 'icons/mob/alienanimals_x32.dmi'
	icon_state = "space_ghost"
	icon_living = "space_ghost"
	icon_dead = "space_ghost_dead"
	has_eye_glow = TRUE
	hovering = TRUE
	pass_flags = PASSTABLE

	faction = "space ghost"
	maxHealth = 50
	health = 50
	movement_cooldown = 0

	see_in_dark = 10

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"

	harm_intent_damage = 0
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_sharp = FALSE
	attacktext = list("spooked", "startled", "jumpscared", "screamed at")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/space_ghost

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 999999

	armor = list(
			"melee" = 100,
			"bullet" = 100,
			"laser" = 0,
			"energy" = 0,
			"bomb" = 0,
			"bio" = 0,
			"rad" = 100)

	armor_soak = list(
		"melee" = 100,
		"bullet" = 100,
		"laser" = 0,
		"energy" = 0,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 100
		)

	loot_list = list(/obj/item/weapon/ore/diamond = 100, /obj/item/weapon/ectoplasm = 3)

	speak_emote = list("rumbles")

	vore_active = 0

	projectiletype = /mob/living/simple_mob/vore/alienanimals/spooky_ghost
	projectilesound = null
	projectile_accuracy = 0
	projectile_dispersion = 0

	needs_reload = TRUE
	reload_max = 1
	reload_count = 0
	reload_time = 7 SECONDS


/datum/ai_holder/simple_mob/ranged/kiting/space_ghost
	hostile = TRUE
	retaliate = TRUE
	destructive = TRUE
	violent_breakthrough = TRUE
	speak_chance = 0

/mob/living/simple_mob/vore/alienanimals/space_ghost/apply_melee_effects(var/atom/A)
	var/mob/living/L = A
	L.hallucination += 50

/mob/living/simple_mob/vore/alienanimals/space_ghost/shoot(atom/A) //We're shooting ghosts at people and need them to have the same faction as their parent, okay?
	if(!projectiletype)
		return
	if(A == get_turf(src))
		return
	face_atom(A)
	if(reload_count >= reload_max)
		return
	var/mob/living/simple_mob/P = new projectiletype(loc, src)

	if(!P)
		return
	if(needs_reload)
		reload_count++

	P.faction = faction
	playsound(src, projectilesound, 80, 1)

/mob/living/simple_mob/vore/alienanimals/space_ghost/death(gibbed, deathmessage = "fades away!")
	. = ..()
	qdel(src)

/mob/living/simple_mob/vore/alienanimals/spooky_ghost
	name = "space ghost"
	desc = "A pulsing mass of darkness that seems to have gained sentience."
	tt_desc = "?????"
	catalogue_data = list(/datum/category_item/catalogue/fauna/space_ghost)

	icon = 'icons/mob/alienanimals_x32.dmi'
	icon_state = "spookyghost-1"
	icon_living = "spookyghost-1"
	icon_dead = "space_ghost_dead"
	hovering = TRUE
	pass_flags = PASSTABLE

	faction = "space ghost"
	maxHealth = 5
	health = 5
	movement_cooldown = -1

	see_in_dark = 10
	alpha = 128

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"

	harm_intent_damage = 0
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_sharp = FALSE
	attacktext = list("spooked", "startled", "jumpscared", "screamed at")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 999999

	armor = list(
			"melee" = 100,
			"bullet" = 100,
			"laser" = 0,
			"energy" = 0,
			"bomb" = 0,
			"bio" = 0,
			"rad" = 100)

	armor_soak = list(
		"melee" = 100,
		"bullet" = 100,
		"laser" = 0,
		"energy" = 0,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 100
		)

	speak_emote = list("rumbles")

	vore_active = 0

	ai_holder_type = /datum/ai_holder/simple_mob/melee/space_ghost

/mob/living/simple_mob/vore/alienanimals/spooky_ghost/Initialize()
	. = ..()
	icon_living = "spookyghost-[rand(1,2)]"
	icon_state = icon_living
	addtimer(CALLBACK(src, PROC_REF(death)), 35 SECONDS)
	update_icon()

/datum/ai_holder/simple_mob/melee/space_ghost
	hostile = TRUE
	retaliate = TRUE
	destructive = TRUE
	violent_breakthrough = TRUE
	speak_chance = 0

/mob/living/simple_mob/vore/alienanimals/spooky_ghost/death(gibbed, deathmessage = "fades away!")
	. = ..()
	qdel(src)

/mob/living/simple_mob/vore/alienanimals/spooky_ghost/apply_melee_effects(var/atom/A)
	var/mob/living/L = A
	if(L && istype(L))
		L.hallucination += rand(1,50)

/mob/living/simple_mob/vore/alienanimals/spooky_ghost/Life()
	. = ..()
	var/turf/T = get_turf(src)
	if(!T)
		return
	if(T.get_lumcount() >= 0.5)
		adjustBruteLoss(1)
