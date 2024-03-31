/////////////////////////////////////Man-Trap/////////////////////////////////////////

/mob/living/simple_mob/vore/mantrap
	name = "Mantrap"
	desc = "A strange slim creature that lurks in the dark. It's features could be described as a mix of feline and canine, but it's most notable alien property is the second set of forelegs. Additionally, it has a series of boney blue spikes running down it's spine, a similarly hard tip to it's tail and dark blue fangs hanging from it's snout."
	catalogue_data = list(/datum/category_item/catalogue/fauna/stalker)
	tt_desc = "Canidfelanis"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "flytrap-dead"
	icon_living = "flytrap"
	icon_state = "flytrap"
	icon_rest = "flytrap"
	faction = "plants"
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
	B.name = "stomach"
	B.desc = "The lithe creature spends only minimal time with you pinned beneath it, before it's jaws stretch wide ahead of your face. The slightly blue hued interior squelches tightly over your head as the stalker's teeth prod against you, threatening to become much more of a danger if you put up too much of a fight. However, the process is quick, your body is efficiently squeezed through that tight gullet, contractions dragging you effortlessly towards the creature's gut. The stomach swells and hangs beneath the animal, swaying like a hammock under the newfound weight. The walls wrap incredibly tightly around you, compressing you tightly into a small ball as it grinds caustic juices over you."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digest_oxy = 1
	B.digestchance = 100
	B.absorbchance = 0
	B.escapechance = 10
	B.selective_preference = DM_SELECT
	B.escape_stun = 10

/datum/category_item/catalogue/fauna/mantrap
	name = "Extra-Realspace Fauna - Cave Stalker"
	desc = "Classification: Canidfelanis\
	<br><br>\
	Cave Stalker's an unusual alien animal found at a number of redgate locations, suspected to have originated from locations other than those that they are found at. \
	They are carnivorous and highly aggressive beasts that spend the majority of their time skulking in dark locations with long lines of sight, they're known to spend a lot of time stalking their prey to assess their vulnerability. \
	Typically they will follow their prey from a distance, and when they are not paying attention, will rush in to tackle their meal. However, they're stealth hunters and are easily startled if spotted. They will not attack their prey head on unless physically provoked to defend themselves."
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
	desc = "A strange slim creature that lurks in the dark. It's features could be described as a mix of feline and canine, but it's most notable alien property is the second set of forelegs. Additionally, it has a series of boney blue spikes running down it's spine, a similarly hard tip to it's tail and dark blue fangs hanging from it's snout."
	catalogue_data = list(/datum/category_item/catalogue/fauna/stalker)
	tt_desc = "Canidfelanis"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "pitcher-dead"
	icon_living = "pitcher"
	icon_state = "pitcher"
	icon_rest = "pitcher"
	faction = "plants"
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
	B.desc = "The lithe creature spends only minimal time with you pinned beneath it, before it's jaws stretch wide ahead of your face. The slightly blue hued interior squelches tightly over your head as the stalker's teeth prod against you, threatening to become much more of a danger if you put up too much of a fight. However, the process is quick, your body is efficiently squeezed through that tight gullet, contractions dragging you effortlessly towards the creature's gut. The stomach swells and hangs beneath the animal, swaying like a hammock under the newfound weight. The walls wrap incredibly tightly around you, compressing you tightly into a small ball as it grinds caustic juices over you."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digest_oxy = 1
	B.digestchance = 100
	B.absorbchance = 0
	B.escapechance = 10
	B.selective_preference = DM_SELECT
	B.escape_stun = 10

/datum/category_item/catalogue/fauna/pitcher
	name = "Extra-Realspace Fauna - Cave Stalker"
	desc = "Classification: Canidfelanis\
	<br><br>\
	Cave Stalker's an unusual alien animal found at a number of redgate locations, suspected to have originated from locations other than those that they are found at. \
	They are carnivorous and highly aggressive beasts that spend the majority of their time skulking in dark locations with long lines of sight, they're known to spend a lot of time stalking their prey to assess their vulnerability. \
	Typically they will follow their prey from a distance, and when they are not paying attention, will rush in to tackle their meal. However, they're stealth hunters and are easily startled if spotted. They will not attack their prey head on unless physically provoked to defend themselves."
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
	src.visible_message("<span class='danger'>\The [src] launches a green appendage at \the [A]!</span>")
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
