/////////////////////////////////////Man-Trap/////////////////////////////////////////

/mob/living/simple_mob/vore/mantrap
	name = "Mantrap"
	desc = "This massive plant lays in wait in the brush, and can be very difficult to spot. When laying open on the ground, the trap mechanism resembles a massive saw-toothed maw."
	catalogue_data = list(/datum/category_item/catalogue/fauna/mantrap)
	tt_desc = "Dionaea Humanis"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "flytrap-dead"
	icon_living = "flytrap"
	icon_state = "flytrap"
	icon_rest = "flytrap"
	faction = FACTION_PLANTS
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	maxHealth = 100
	attacktext = list("flinches at")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/passive/mantrap

	density = 0
	anchored = 1

	vore_bump_chance = 100
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 1000
	vore_active = 1
	vore_icons = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 1
	swallowTime = 1
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_SELECT
	vore_pounce_maxhealth = 1000
	vore_bump_emote = "encloses on"

/mob/living/simple_mob/vore/mantrap/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "trap"
	B.desc = "As you step onto the large leaves of the mantrap, they suddenly shoot up and snap shut around you, encasing you in a fleshy-feeling gut. The saw-toothed spikes around the edge of the leaves interlock with one another and exerts a tremendous pressure on your body. Copious volumes of fluids begin to seep in from the walls themselves, rapidly coating your body and pooling around you, all of your movements only seem to speed up this process.."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "destination_tumby"
	B.belly_fullscreen_color = "#02a802"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digest_oxy = 1
	B.digestchance = 100
	B.absorbchance = 0
	B.escapechance = 10
	B.selective_preference = DM_SELECT
	B.escape_stun = 10

/datum/category_item/catalogue/fauna/mantrap
	name = "Extra-Realspace Flora - Mantrap"
	desc = "Classification: Dionaea Humanis\
	<br><br>\
	The mantrap is a rare carnivorous plant found in redgate locations. The main component of which is a pair of large fan-shaped leaves with serrated dagger like edges, which act as it's main predation mechanism. \
	Despite its size, it is a patient predator that will lay in wait for multiple months before claiming a meal. Whilst it is able to rapidly digest creatures of significant sizes, its metabolism is slow and the nutrients it prey provides can sustain it for a long period of time."
	value = CATALOGUER_REWARD_HARD

/datum/ai_holder/simple_mob/passive/mantrap
	vision_range = 1
	wander = FALSE

/mob/living/simple_mob/vore/mantrap/Crossed(var/atom/movable/AM) // Transplanting this from /mob/living/carbon/human/Crossed()
	if(AM == src || AM.is_incorporeal()) // We're not going to run over ourselves or ghosts
		return
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.devourable && L.allowmobvore && (src.vore_fullness < src.vore_capacity))
			perform_the_nom(src,L,src,src.vore_selected,1)
			return
		else
			return


////////////////////////////PITCHER PLANT////////////////////////////////////////////////


/mob/living/simple_mob/vore/pitcher
	name = "Pitcher Plant"
	desc = "This large pitcher plant looks big enough to fit an entire person, with a little stretching. Long tendrils rest at the entrance."
	catalogue_data = list(/datum/category_item/catalogue/fauna/pitcher)
	tt_desc = "Nepenthes Titanis"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "pitcher-dead"
	icon_living = "pitcher"
	icon_state = "pitcher"
	icon_rest = "pitcher"
	faction = FACTION_PLANTS
	movement_cooldown = 0
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	maxHealth = 100
	attacktext = list("flinches at")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/vore/pitcher

	density = 0
	anchored = 1

	vore_bump_chance = 100
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 0
	vore_active = 1
	vore_icons = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 1
	swallowTime = 1
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_SELECT
	vore_pounce_maxhealth = 0
	vore_bump_emote = "encloses on"

	appendage_color = "#03a319"
	base_attack_cooldown = 5 SECONDS
	projectiletype = /obj/item/projectile/beam/appendage
	projectilesound = 'sound/effects/slime_squish.ogg'

/mob/living/simple_mob/vore/pitcher/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "Walking a little too close to the pitcher plant, you trigger its trap mechanism and a tendril shoots out towards you. Wrapping around your body, you are rapidly dragged into the open mouth of the plant, stuffing your entire body into a fleshy, green stomach filled with a pool of some sort of tingling liquid. The lid of the plant slams down over the mouth, making it far more difficult to escape, all whilst that pool steadily seems to be filling up."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "destination_tumby"
	B.belly_fullscreen_color = "#02a802"
	B.digest_brute = 1
	B.digest_burn = 1
	B.digest_oxy = 0
	B.digestchance = 100
	B.absorbchance = 0
	B.escapechance = 10
	B.selective_preference = DM_SELECT
	B.escape_stun = 10

/datum/category_item/catalogue/fauna/pitcher
	name = "Extra-Realspace Flora - Titan Pitcher Plant"
	desc = "Classification: Nepenthes Titanis\
	<br><br>\
	The titan pitcher plant is a rare carnivorous plant found in redgate locations. Unlike typical pitfall type pitcher plants that we are familiar with in realspace, these variants are far more aggressive. \
	When their defense mechanisms are triggered, by sensing vibrations through their extensive root systems, long tendrils emerge from the mouth of these plants to ensnare living creatures nearby. These creatures are dragged into the stomach-like bell shaped cavity of the plant and the rigid leaf closes as a lid. \
	Despite the size of these plants, they are perfectly capable of trapping an adult human and should be treated with heavy caution. More typically, they predate on small mammals and reptiles in their local ecological environment."
	value = CATALOGUER_REWARD_HARD

/datum/ai_holder/simple_mob/vore/pitcher
	vision_range = 3
	wander = FALSE
	retaliate = FALSE
	pointblank = TRUE

/*/mob/living/simple_mob/vore/pitcher/do_special_attack(atom/A)
	. = TRUE
	if(ckey)
		return
	tongue(A)

/mob/living/simple_mob/vore/pitcher/proc/tongue(atom/A)
	var/obj/item/projectile/P = new /obj/item/projectile/beam/appendage(get_turf(src))
	src.visible_message(span_danger("\The [src] launches a green appendage at \the [A]!"))
	playsound(src, "sound/effects/slime_squish.ogg", 50, 1)
	P.launch_projectile(A, BP_TORSO, src)*/

//NEVER MOVE!!!

/datum/ai_holder/simple_mob/vore/pitcher/walk_to_destination()
	return

/datum/ai_holder/simple_mob/vore/pitcher/give_destination()
	return

/datum/ai_holder/simple_mob/vore/pitcher/walk_path()
	return

/datum/ai_holder/simple_mob/vore/pitcher/move_once()
	return

/datum/ai_holder/simple_mob/vore/pitcher/handle_wander_movement()
	return

/datum/ai_holder/simple_mob/vore/pitcher/walk_to_target()
	return
