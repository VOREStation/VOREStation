//Mobs who's primary purpose is to go eat people who have their vore prefs turned on. They're retaliate mobs to everyone else.
/mob/living/simple_mob/vore/vore_hostile
	name = "peeb"
	desc = "REPLACE ME"
	ai_holder_type = /datum/ai_holder/simple_mob/vore

/////ABYSS LURKER/////

/datum/category_item/catalogue/fauna/abyss_lurker
	name = "Alien Wildlife - Abyss Lurker"
	desc = "Halitha Norotanis is a species of endobiotic life form that feeds primarily off of parasites, invaders, and other foreign bodies to its host. It responds to sound and touch, attacking and engulfing anything it deems to be a threat. It hardly makes any noise as it moves in the darkness and it will hunt down and investigate sound as it lurks. It doesn't seem to have any eyes or ears, but the golden antennae on its head seem to ripple in the direction of sounds."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/vore/vore_hostile/abyss_lurker
	name = "abyss lurker"
	desc = "A pale mass of heaving flesh that gropes around in the gloom. It doesn't appear to have any eyes."
	tt_desc = "Halitha Norotanis"
	icon = 'icons/mob/alienanimals_x64.dmi'
	icon_state = "abyss_lurker"
	icon_living = "abyss_lurker"
	icon_dead = "abyss_lurker-dead"
	icon_rest = "abyss_lurker"
	vis_height = 64

	faction = "macrobacteria"
	maxHealth = 600
	health = 600
	movement_cooldown = 3

	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 1

	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	catalogue_data = list(/datum/category_item/catalogue/fauna/abyss_lurker)

	see_in_dark = 8

	pixel_x = -16
	default_pixel_x = -16


	mob_size = MOB_LARGE
	mob_bump_flag = HEAVY
	mob_swap_flags = HEAVY
	mob_push_flags = HEAVY
	mob_size = MOB_LARGE

	attacktext = list("flashes", "slaps", "smothers", "grapples")
	attack_sound = 'sound/effects/attackblob.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/say_aggro

	swallowTime = 2 SECONDS
	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 50
	vore_bump_emote	= "begins to absorb"
	vore_ignores_undigestable = 0
	vore_default_mode = DM_SELECT
	vore_icons = null
	vore_stomach_name = "Stomach"
	vore_default_item_mode = IM_DIGEST
	vore_pounce_chance = 50
	vore_pounce_cooldown = 10
	vore_pounce_successrate	= 75
	vore_pounce_falloff = 0
	vore_pounce_maxhealth = 100
	vore_standing_too = TRUE
	unacidable = TRUE

/mob/living/simple_mob/vore/vore_hostile/abyss_lurker/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "interior"
	B.desc = "It's hot and overwhelmingly tight! The interior of the pale creature groans with the effort of squeezing you. Everything is hot and churning and eager to grind and smother you in thick fluids. The weight of the creature's body pressing in at you makes it hard to move at all, while you are squeezed to the very core of the creature! There seems almost not to even be an organ for this so much as the creature has folded around you, trying to incorporate your matter into its body with vigor!"
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_NUMBING
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 3
	B.digest_burn = 2
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 25
	B.escape_stun = 5

/mob/living/simple_mob/vore/vore_hostile/abyss_lurker/attack_hand(mob/living/user)

	if(client || !user.client || !ai_holder || !isliving(user))
		return ..()
	if(!user.devourable || !user.allowmobvore || !user.can_be_drop_prey)
		return ..()
	ai_holder.give_target(user, TRUE)
	ai_holder.track_target_position()
	ai_holder.set_stance(STANCE_FIGHT)

/datum/ai_holder/simple_mob/say_aggro
	hostile = FALSE
	forgive_resting = TRUE
	cooperative = FALSE

/datum/ai_holder/simple_mob/say_aggro/on_hear_say(mob/living/speaker, message)
	. = ..()
	if(holder.client || !speaker.client)
		return
	if(!speaker.devourable || !speaker.allowmobvore || !speaker.can_be_drop_prey)
		return
	if(speaker.z != holder.z)
		return
	give_target(speaker, TRUE)
	track_target_position()
	set_stance(STANCE_FIGHT)

/////Leaper/////

/datum/category_item/catalogue/fauna/leaper
	name = "Alien Wildlife - Abyss Leaper"
	desc = "Halitha Tannerack is a species of endobiotic life form that feeds primarily off of parasites, invaders, and other foreign bodies to its host. It pounces upon threats using its powerful legs to leap great distances. It has expressed higher thinking, though it seems not to act entirely in its own interest, serving its host organism's well-being before any other priorities. This means that it is capable of picking its targets, and will not attack indiscriminately. It chooses only to attack those it senses to be a threat to its host, though what exactly it qualifies to be a threat has not been fully explored. This creature radiates a strange energy from within, and while this energy has been studied, it is very poorly understood."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/vore/vore_hostile/leaper
	name = "abyss leaper"
	desc = "A tall, pale creature with blood red markings. It has powerful legs and long dexterous tentacles. Its eyes and tentacles appear to glow from within with some unknown energy."
	tt_desc = "Halitha Tannerack"
	icon = 'icons/mob/alienanimals_x64.dmi'
	icon_state = "filter"
	icon_living = "filter"
	icon_dead = "filter-dead"
	icon_rest = "filter"
	vis_height = 64

	faction = "macrobacteria"
	maxHealth = 600
	health = 600

	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 1

	movement_cooldown = 1
	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	catalogue_data = list(/datum/category_item/catalogue/fauna/leaper)

	see_in_dark = 8

	pixel_x = -16
	default_pixel_x = -16

	mob_size = MOB_LARGE
	mob_bump_flag = HEAVY
	mob_swap_flags = HEAVY
	mob_push_flags = HEAVY
	mob_size = MOB_LARGE

	has_eye_glow = TRUE

	attacktext = list("pushes", "slaps", "whips", "grapples")
	attack_sound = 'sound/effects/attackblob.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/vore

	swallowTime = 1 SECONDS
	vore_active = 1
	vore_capacity = 2
	vore_bump_chance = 75
	vore_bump_emote	= "grabs ahold of"
	vore_ignores_undigestable = 0
	vore_default_mode = DM_SELECT
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "stomach"
	vore_default_item_mode = IM_DIGEST
	vore_pounce_chance = 75
	vore_pounce_cooldown = 10
	vore_pounce_successrate	= 75
	vore_pounce_falloff = 0
	vore_pounce_maxhealth = 100
	vore_standing_too = TRUE
	can_be_drop_prey = FALSE
	can_be_drop_pred = TRUE
	throw_vore = TRUE
	unacidable = TRUE

	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 10 SECONDS

	var/leap_warmup = 1 SECOND // How long the leap telegraphing is.
	var/leap_sound = 'sound/weapons/spiderlunge.ogg'

/mob/living/simple_mob/vore/vore_hostile/leaper/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The flesh of the tall creature's stomach folds over you in doughy waves, squeezing you into the tightest shape it can manage with idle flexes churning down on you. Your limbs often find themselves lost between folds and tugged this way or that, held in a skin tight press that is not painful, but is hard to pull away from. You can see a strange, glittering pink and purple light glimmering through the flesh of the monster all around you, like your very own sea of stars. The walls rush in to fill all the space, squeezing you from head to toe no matter how you might wiggle, the weight of the semi-transparent interior flesh keeping you neatly secured deep inside while wringing the fight out of you."
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_NUMBING
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 25
	B.colorization_enabled = TRUE
	B.belly_fullscreen_color = "#591579"
	B.escape_stun = 3

// The leaping attack.
/mob/living/simple_mob/vore/vore_hostile/leaper/do_special_attack(atom/A)	//Mostly copied from hunter.dm
	set waitfor = FALSE
	if(!isliving(A))
		return FALSE
	var/mob/living/L = A
	if(!L.devourable || !L.allowmobvore || !L.can_be_drop_prey || !L.throw_vore || L.unacidable)
		return FALSE

	set_AI_busy(TRUE)
	visible_message(span("warning","\The [src]'s eyes flash ominously!"))
	to_chat(L, span("danger","\The [src] focuses on you!"))
	// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
	sleep(leap_warmup) // For the telegraphing.

	if(L.z != z)	//Make sure you haven't disappeared to somewhere we can't go
		set_AI_busy(FALSE)
		return FALSE

	// Do the actual leap.
	status_flags |= LEAPING // Lets us pass over everything.
	visible_message(span("critical","\The [src] leaps at \the [L]!"))
	throw_at(get_step(L, get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, leap_sound, 75, 1)

	sleep(5) // For the throw to complete. It won't hold up the AI ticker due to waitfor being false.

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING // Revert special passage ability.

	set_AI_busy(FALSE)
	if(Adjacent(L))	//We leapt at them but we didn't manage to hit them, let's see if we're next to them
		L.Weaken(2)	//get knocked down, idiot

/////Gelatinous Cube/////

/datum/category_item/catalogue/fauna/gelatinous_cube
	name = "Alien Wildlife - Gelatinous Cube"
	desc = "Macrocollagen Vulgaris is a species of slow moving slime. Debate still rages over whether or not it is actually even alive. It is most commonly found in the shape of a cube, while its colors can vary wildly depending upon what it has ingested. The cube is comprised of an extremely thick gel like substance that is highly corrosive, anything caught inside without appropriate protection will only last a few moments. This slime does move around, which is the primary argument for classifying it as alive, but it seems to wander randomly toward sources of nutrients. It seems perfectly indifferent to what it can ingest, and will simply ingest everything, from dirt, to people."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube
	name = "gelatinous cube"
	desc = "A cube of corrosive slime. It seems to slide around very slowly. You're not sure if it's actually moving under its own power, or if it is just sliding around haphazardly. It is somewhat transparent, and you can see clouds of still processing materials inside as they break down."
	tt_desc = "Macrocollagen Vulgaris"
	icon = 'icons/mob/alienanimals_x64.dmi'
	icon_state = "cube"
	icon_living = "cube"
	icon_dead = " "
	icon_rest = "cube"
	vis_height = 64

	faction = "macrobacteria"
	maxHealth = 500
	health = 500

	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 1

	movement_cooldown = 50
	meat_amount = 0
	meat_type = null
	catalogue_data = list(/datum/category_item/catalogue/fauna/gelatinous_cube)

	see_in_dark = 8

	pixel_x = -16
	default_pixel_x = -16

	mob_size = MOB_LARGE
	mob_bump_flag = HUMAN
	mob_swap_flags = HEAVY
	mob_push_flags = HEAVY
	mob_size = MOB_LARGE

	attacktext = list("splashes against", "slaps", "smothers", "engulfs")
	attack_sound = 'sound/effects/attackblob.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/vore

	swallowTime = 0 SECONDS
	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 100
	vore_bump_emote	= "begins to absorb"
	vore_ignores_undigestable = 0
	vore_default_mode = DM_SELECT
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "interior"
	vore_default_item_mode = IM_DIGEST
	vore_pounce_chance = 50
	vore_pounce_cooldown = 10
	vore_pounce_successrate	= 75
	vore_pounce_falloff = 0
	vore_pounce_maxhealth = 100
	vore_standing_too = TRUE
	unacidable = TRUE

/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "interior"
	B.desc = "An incredibly thick oozing slime surrounds you, filling in all the space around your form! It's hard to catch a breath here as the jiggling gel that makes up the body of the creature swiftly fills in the hole you made in its surface by entering. The gel is semi-transparent, and you can see your surroundings though its surface, and similarly you can be seen floating in the gel from the outside. When the cube moves, your whole body is wobbled along with it. There are clouds of still processing material floating all around you as the corrosive substance works on breaking everything down."
	B.mode_flags = DM_FLAG_NUMBING
	B.belly_fullscreen = "yet_another_tumby"
	B.colorization_enabled = TRUE
	B.belly_fullscreen_color = color
	B.digest_brute = 2
	B.digest_burn = 10
	B.digest_oxy = 12
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 10
	B.escapetime = 5 SECONDS
	B.selective_preference = DM_DIGEST
	B.escape_stun = 3

/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube/Initialize()
	. = ..()
	color = random_color(TRUE)

/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube/death()
	. = ..()

	qdel(src)
