/mob/living/simple_mob/animal/space/alien
	name = "skathari soldier"
	desc = "Terrible insects from beyond this galaxy!"
	description_fluff = "Also know as the 'Bluespace Bugs', these insectoid invaders began to manifest suddenly around 2565 and their ravenous hunger for the very particles upon which modern FTL technology relies brought much of galactic society to a standstill. Their ravenous hunger for physical matter on the other hand, got people moving again fast - in the other direction!"
	tt_desc = "X Extraneus Tarlevi"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_living = "alienh_running"
	icon_dead = "alien_dead"
	icon_gib = "syndicate_gib"
	icon_rest = "alienh_sleep"

	faction = "xeno"

	mob_class = MOB_CLASS_ABERRATION

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	organ_names = /decl/mob_organ_names/skathari

	maxHealth = 120
	health = 120
	see_in_dark = 7

	turn_sound = "skathari_chitter"

	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE

	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'

<<<<<<< HEAD
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat
	meat_amount = 5
=======
	// meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat //Make this something special in full implementation
>>>>>>> 34b2b686f80... Merge pull request #8386 from Cerebulon/BuggyCode

/mob/living/simple_mob/animal/space/alien/drone
	name = "skathari worker"
	icon_state = "aliend_running"
	icon_living = "aliend_running"
	icon_dead = "aliend_l"
	icon_rest = "aliend_sleep"
	health = 80
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/skathari

/*
To be replaced with equivalents later
/mob/living/simple_mob/animal/space/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_running"
	icon_living = "aliens_running"
	icon_dead = "aliens_l"
	icon_rest = "aliens_sleep"
	health = 120
	melee_damage_lower = 15
	melee_damage_upper = 15


/mob/living/simple_mob/animal/space/alien/sentinel/praetorian
	name = "alien praetorian"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "prat_s"
	icon_living = "prat_s"
	icon_dead = "prat_dead"
	icon_rest = "prat_sleep"
	maxHealth = 200
	health = 200

	pixel_x = -16
	old_x = -16
	icon_expected_width = 64
	icon_expected_height = 64
	meat_amount = 8

/mob/living/simple_mob/animal/space/alien/queen
	name = "alien queen"
	icon_state = "alienq_running"
	icon_living = "alienq_running"
	icon_dead = "alienq_l"
	icon_rest = "alienq_sleep"
	health = 250
	maxHealth = 250
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'


	movement_cooldown = 10

/mob/living/simple_mob/animal/space/alien/queen/empress
	name = "alien empress"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	icon_rest = "queen_sleep"
	maxHealth = 400
	health = 400
	meat_amount = 15

	pixel_x = -16
	old_x = -16
	icon_expected_width = 64
	icon_expected_height = 64

*/

/mob/living/simple_mob/animal/space/alien/queen/empress/mother
	name = "skathari tyrant"
	desc = "Sweet mother of bugs!"
	icon = 'icons/mob/96x96.dmi'
	icon_state = "tyrant_s"
	icon_living = "tyrant_s"
	icon_dead = "tyrant_dead"
	icon_rest = "tyrant_rest"
	maxHealth = 600
	health = 600
	meat_amount = 40
	melee_damage_lower = 15
	melee_damage_upper = 25
	movement_cooldown = 8

	projectiletype = /obj/item/projectile/energy/skathari

	pixel_x = -32
	old_x = -32
	icon_expected_width = 96
	icon_expected_height = 96

/mob/living/simple_mob/animal/space/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green ichor bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)
	new /obj/effect/decal/cleanable/blood/skathari(src.loc)
	new /obj/effect/temp_visual/bluespace_tear(src.loc)


/decl/mob_organ_names/skathari
	hit_zones = list("carapace", "abdomen", "left forelegs", "right forelegs", "left hind legs", "right hind legs", "head")