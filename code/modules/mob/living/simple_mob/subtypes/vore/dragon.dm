/mob/living/simple_mob/vore/aggressive/dragon
	name = "red dragon"
	desc = "Here to pillage stations and kidnap princesses, and there probably aren't any princesses."

	icon_dead = "reddragon-dead"
	icon_living = "reddragon"
	icon_state = "reddragon"
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64

	faction = FACTION_DRAGON
	maxHealth = 500 // Boss
	health = 500
	see_in_dark = 8

	melee_damage_lower = 5
	melee_damage_upper = 30

	meat_amount = 15
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	//Space dragons aren't affected by atmos.
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

	response_help = "pats"
	response_disarm = "tries to shove"
	response_harm = "hits"

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	mount_offset_y = 15
	mount_offset_x = -12
	max_buckled_mobs = 1
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

	ai_holder_type = /datum/ai_holder/simple_mob/melee
	say_list_type = /datum/say_list/dragonboss

/mob/living/simple_mob/vore/aggressive/dragon/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space dragons!
/*
/mob/living/simple_mob/vore/aggressive/dragon/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"snaps at [.]")
*/
// Activate Noms!
/mob/living/simple_mob/vore/aggressive/dragon
	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 0 // Beat them into crit before eating.
	vore_icons = SA_ICON_LIVING

/datum/category_item/catalogue/fauna/phoron_dragon
	name = "Virgo 3b Fauna - Phoron Dragon"
	desc = "Classification: Phoron Draconinae\
	<br><br>\
	A cousin to the dragons of space, Phoron Dragons are a rare and rather unique sight to see in the wilds of Virgo 3b. \
	Their terrifying appearance isn't just for looks, the black scales with mutated Phoron deposits in the skin are meant \
	to intimidate and frighten potential prey. They are mainly carnivorous in nature but can survive off of a mixed diet \
	of meats and plant based foods in certain circumstances - usually these circumstances are not ideal for the predator. \
	It is unknown still how the Phoron Dragon came to be but scientists speculate that common Dragons such as Red Dragons \
	somehow ended up on Virgo 3b and through a period of evolutionary mutation became the modern day Phoron Dragon.\
	<br>\
	Female dragons will often lay a clutch of eggs similar to that of other reptilian species after she is properly mated. \
	Females will go through a heat cycle once every season and will actively seek a mate in order to copulate. Males during \
	this time of season have been known to be increasingly hostile. Travellers are warned against traversing in the wilds \
	during these seasons because of the increased hostility.\
	<br>\
	Unlike their more fiery cousins, these dragons do not breathe flames as it would ignite both the surrounding Phoron and \
	the internal Phoron deposits of its body. Scientists still do not know how or when in the evolutionary chain they lost \
	their signature fire breath but it was likely very early in the chain otherwise the entire species would be extinct."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/aggressive/dragon/virgo3b
	name = "phoron dragon"
	tt_desc = "Phoron Draconinae"
	catalogue_data = list(/datum/category_item/catalogue/fauna/phoron_dragon)
	maxHealth = 300
	health = 300
	faction = FACTION_VIRGO3B
	icon_dead = "phoron_dragon_dead"
	icon_living = "phoron_dragon"
	icon_state = "phoron_dragon"
	mount_offset_y = 24
	mount_offset_x = -9
	has_eye_glow = TRUE
	vore_eyes = TRUE

/mob/living/simple_mob/vore/aggressive/dragon/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = 0

/mob/living/simple_mob/vore/aggressive/dragon/MouseDrop_T(mob/living/M, mob/living/user)
	return

/datum/say_list/dragonboss
	say_got_target = list("roars and snaps it jaws!")

/mob/living/simple_mob/vore/aggressive/dragon/space
	name = "space dragon"
	tt_desc = "Astra Draconinae"
	maxHealth = 300
	health = 300
	faction = FACTION_DRAGON
	icon_dead = "space_dragon_dead"
	icon_living = "space_dragon"
	icon_state = "space_dragon"
	mount_offset_y = 24
	mount_offset_x = -9
	has_eye_glow = TRUE
	vore_eyes = TRUE
