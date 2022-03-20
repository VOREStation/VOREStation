/mob/living/simple_mob/animal/space/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_living = "alienh_running"
	icon_dead = "alien_l"
	icon_gib = "syndicate_gib"
	icon_rest = "alienh_sleep"
	faction = "xeno"
	mob_class = MOB_CLASS_ABERRATION
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
<<<<<<< HEAD

	maxHealth = 100
	health = 100
	see_in_dark = 7

=======
	organ_names = /decl/mob_organ_names/skathari
	maxHealth = 120
	health = 120
	see_in_dark = 7
	turn_sound = "skathari_chitter"
>>>>>>> b1403016542... skathari disappear with a flash when killed (#8449)
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_armor_pen = 15	//It's a freaking alien.
	attack_sharp = TRUE
	attack_edge = TRUE
	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'

<<<<<<< HEAD
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat
	meat_amount = 5
=======

/mob/living/simple_mob/animal/space/alien/death()
	var/turf/center = get_turf(src)
	if (isturf(center))
		playsound(center, 'sound/effects/mob_effects/skathari_teleport.ogg', 75, TRUE)
		for (var/mob/living/carbon/victim in oviewers(5, center))
			victim.flash_eyes(3)
		visible_message(
			SPAN_WARNING("\The [src] disappears with a screech and a flash of light!"),
			SPAN_WARNING("You hear a thin, high screech, ended by a sudden echoing snap!")
		)
		new /obj/effect/decal/cleanable/blood/skathari (center)
		new /obj/effect/temp_visual/bluespace_tear (center)
	qdel(src)
	..()

>>>>>>> b1403016542... skathari disappear with a flash when killed (#8449)

/mob/living/simple_mob/animal/space/alien/drone
	name = "alien drone"
	icon_state = "aliend_running"
	icon_living = "aliend_running"
	icon_dead = "aliend_l"
	icon_rest = "aliend_sleep"
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 15

<<<<<<< HEAD
/mob/living/simple_mob/animal/space/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_running"
	icon_living = "aliens_running"
	icon_dead = "aliens_l"
	icon_rest = "aliens_sleep"
	health = 120
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'

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
=======
>>>>>>> b1403016542... skathari disappear with a flash when killed (#8449)

/mob/living/simple_mob/animal/space/alien/queen/empress/mother
	name = "alien mother"
	icon = 'icons/mob/96x96.dmi'
	icon_state = "empress_s"
	icon_living = "empress_s"
	icon_dead = "empress_dead"
	icon_rest = "empress_rest"
	maxHealth = 600
	health = 600
	meat_amount = 40
	melee_damage_lower = 15
	melee_damage_upper = 25
<<<<<<< HEAD

=======
	movement_cooldown = 8
	projectiletype = /obj/item/projectile/energy/skathari
>>>>>>> b1403016542... skathari disappear with a flash when killed (#8449)
	pixel_x = -32
	old_x = -32
	icon_expected_width = 96
	icon_expected_height = 96

<<<<<<< HEAD
/mob/living/simple_mob/animal/space/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)
=======

/decl/mob_organ_names/skathari
	hit_zones = list("carapace", "abdomen", "left forelegs", "right forelegs", "left hind legs", "right hind legs", "head")
>>>>>>> b1403016542... skathari disappear with a flash when killed (#8449)
