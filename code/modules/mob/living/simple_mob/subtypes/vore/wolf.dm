/datum/category_item/catalogue/fauna/wolf		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Creature - Wolf"
	desc = "Some sort of wolf, a descendent or otherwise of regular Earth canidae. They look almost exactly like their \
	Earth counterparts, except for the fact that their fur is a uniform grey. Some do show signs of unique coloration, and they \
	love to nip and bite at things, as well as sniffing around. They seem to mark their territory by way of scent-marking/urinating on things."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/vore/wolf
	name = "grey wolf"
	desc = "My, what big jaws it has!"
	tt_desc = "Canis lupus"

	icon_dead = "wolf-dead"
	icon_living = "wolf"
	icon_state = "wolf"
	icon = 'icons/mob/vore.dmi'

	response_help = "pets"
	response_disarm = "bops"
	response_harm = "hits"

	movement_cooldown = 1.5

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 12

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 5

	minbodytemp = 200

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive
	catalogue_data = list(/datum/category_item/catalogue/fauna/wolf)

	allow_mind_transfer = TRUE

// Activate Noms!
/mob/living/simple_mob/vore/wolf
	vore_active = 1
	vore_icons = SA_ICON_LIVING

// Space edition, stronger and bitier
/mob/living/simple_mob/vore/wolf/space
	name = "space wolf"
	tt_desc = "Canis lupus aetherius"

	health = 40
	maxHealth = 40

	movement_cooldown = 0

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 700

/mob/living/simple_mob/vore/wolf/space/Process_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_mob/vore/wolf/direwolf
	name = "dire wolf"
	desc = "The biggest and baddest wolf around."
	tt_desc = "Canis maxdirus"
	icon = 'icons/mob/vore64x32.dmi'
	icon_dead = "direwolf-dead"
	icon_living = "direwolf"
	icon_state = "direwolf"
	icon_rest = "direwolf_rest"
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 20
	maxHealth = 300

	minbodytemp = 0

	max_buckled_mobs = 1
	mount_offset_y = 14
	mount_offset_x = 2
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_mob/vore/wolf/direwolf/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = -1

/mob/living/simple_mob/vore/wolf/direwolf/MouseDrop_T(mob/living/M, mob/living/user)
	return

/mob/living/simple_mob/vore/wolf/direwolf/dog
	name = "large dog"
	desc = "The biggest and goodest dog around."
	tt_desc = "Canis maxdirus familiaris"
	icon_dead = "diredog-dead"
	icon_living = "diredog"
	icon_state = "diredog"
	icon_rest = "diredog_rest"

/mob/living/simple_mob/vore/wolf/direwolf/dog/sec
	name = "large guard dog"
	desc = "The biggest and goodest guard dog around."
	icon_dead = "diredogs-dead"
	icon_living = "diredogs"
	icon_state = "diredogs"
	icon_rest = "diredogs_rest"

/mob/living/simple_mob/vore/wolf/direwolf/sec
	name = "dire guard wolf"
	desc = "The biggest and baddest guard wolf around."
	icon_dead = "direwolfs-dead"
	icon_living = "direwolfs"
	icon_state = "direwolfs"
	icon_rest = "direwolfs_rest"

/mob/living/simple_mob/vore/wolf/direwolf/rykka
	name = "Rykka"
	desc = "This big canine looks like a GSD. It has a collar tagged, 'Bitch'"
	tt_desc = "Canidae"

	icon_dead = "rykka-dead"
	icon_living = "rykka"
	icon_state = "rykka"
	icon_rest = "rykka_rest"
	faction = FACTION_UNDERDARK
	has_eye_glow = TRUE

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 700

	vore_bump_chance = 100
	vore_bump_emote = "clamps down on with iron jaws"
	vore_default_contamination_color = "purple"
	vore_default_contamination_flavor = "Acrid"
	vore_digest_chance = 85
	vore_escape_chance = 5
	vore_pounce_chance = 100
	vore_pounce_maxhealth = 100
	vore_stomach_name = "Gut"
	vore_stomach_flavor = "A black-and-purple veined gut, pulsing warmly around you. Loud gurgles sound around you as the gut squishes inwards and attempts to crush you - Rykka seems intent on digesting you, like the meat you are."

/mob/living/simple_mob/vore/wolf/direwolf/andrews
	name = "andrewsarchus"
	desc = "That's one massive mean-looking piece of long extinct megafauna."
	tt_desc = "Andrewsarchus mongoliensis"

	icon_dead = "andrews-dead"
	icon_living = "andrews"
	icon_state = "andrews"
	icon_rest = "andrews_rest"

	mount_offset_y = 17
