//Academy Areas

/area/awaymission/academy
	name = "\improper Academy Asteroids"
	icon_state = "away"

/area/awaymission/academy/headmaster
	name = "\improper Academy Fore Block"
	icon_state = "away1"

/area/awaymission/academy/classrooms
	name = "\improper Academy Classroom Block"
	icon_state = "away2"

/area/awaymission/academy/academyaft
	name = "\improper Academy Ship Aft Block"
	icon_state = "away3"

/area/awaymission/academy/academygate
	name = "\improper Academy Gateway"
	icon_state = "away4"

//Academy Items

/obj/machinery/singularity/academy
	dissipate = 0
	move_self = 0
	grav_pull = 1

/obj/machinery/singularity/academy/admin_investigate_setup()
	return

/obj/machinery/singularity/academy/process()
	eat()
	if(prob(1))
		mezzer()


/obj/item/clothing/glasses/meson/truesight
	name = "The Lens of Truesight"
	desc = "I can see forever!"
	icon_state = "monocle"
	item_state = "headset"
	origin_tech = "magnets=6;engineering=6;syndicate=3"
	vision_flags = SEE_OBJS | SEE_MOBS | SEE_TURFS


/obj/effect/landmark/mobcorpse/academy_corpses/bluewizard
	corpseuniform = /obj/item/clothing/under/lightpurple
	corpsesuit = /obj/item/clothing/suit/wizrobe
	corpseshoes = /obj/item/clothing/shoes/sandal
	corpsehelmet = /obj/item/clothing/head/wizard

/obj/effect/landmark/mobcorpse/academy_corpses/redwizard
	corpseuniform = /obj/item/clothing/under/lightpurple
	corpsesuit = /obj/item/clothing/suit/wizrobe/red
	corpseshoes = /obj/item/clothing/shoes/sandal
	corpsehelmet = /obj/item/clothing/head/wizard/red

/obj/effect/landmark/mobcorpse/academy_corpses/marisawizard
	corpseuniform = /obj/item/clothing/under/lightpurple
	corpsesuit = /obj/item/clothing/suit/wizrobe/marisa
	corpseshoes = /obj/item/clothing/shoes/sandal
	corpsehelmet = /obj/item/clothing/head/wizard/marisa

/obj/item/projectile/forcebolt/wizard
	icon_state = "bluespace"
	damage = 30

/mob/living/simple_animal/hostile/wizard
	name = "space wizard"
	desc = "A magical space wizard!"
	icon_state = "bluewizard"
	icon_living = "bluewizard"
	icon_dead = "bluewizard_dead"
	icon_gib = "gibbed"
	faction = "wizard"
	speak_chance = 0
	turns_per_move = 5
	response_help = "shakes hands with the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speak = list("Avada Kedavra!", "Hocus Pocus!", "Welcome to Spacewarts School of Witchcraft and Wizardry!",
	"I'm going to be a great wizard one day!", "Harry Pothead must be in trouble again.", "Restoration IS a valid school of magic!!")
	speak_chance = 1
	a_intent = "harm"
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	speed = -1
	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	ranged = 1
	projectilesound = 'sound/weapons/emitter.ogg'
	projectiletype = /obj/item/projectile/forcebolt/wizard // I should randomize the attack type on spawn.
	attacktext = "attacks"
	attack_sound = 'sound/weapons/genhit2.ogg' // Replace this with whapping people.
	var/corpse = /obj/effect/landmark/mobcorpse/academy_corpses/bluewizard
	var/weapon1 = /obj/item/weapon/staff
	var/weapon2

	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 270
	maxbodytemp = 370
	heat_damage_per_tick = 15
	cold_damage_per_tick = 10
	unsuitable_atoms_damage = 10

/mob/living/simple_animal/hostile/wizard/Die()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	if(weapon2)
		new weapon2 (src.loc)
	del src
	return

/mob/living/simple_animal/hostile/wizard/red
	icon_state = "redwizard"
	icon_living = "redwizard"
	icon_dead = "redwizard_dead"
	corpse = /obj/effect/landmark/mobcorpse/academy_corpses/redwizard

/mob/living/simple_animal/hostile/wizard/marisa
	icon_state = "marisawizard"
	icon_living = "marisawizard"
	icon_dead = "marisawizard_dead"
	corpse = /obj/effect/landmark/mobcorpse/academy_corpses/marisawizard

/obj/random/mob/wizard
	name = "Random Wizard Mob"
	desc = "This is a random wizard spawn. You aren't supposed to see this. Call an admin because reality has broken into the meta."
	icon = 'icons/mob/animal.dmi'
	icon_state = "bluewizard"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(/mob/living/simple_animal/hostile/wizard,\
					/mob/living/simple_animal/hostile/wizard/red,\
					/mob/living/simple_animal/hostile/wizard/marisa)