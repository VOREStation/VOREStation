/mob/living/simple_mob/vore/sonadile
	name = "Sonadile"
	desc = "A strange slim creature that lurks in the dark. It's features could be described as a mix of feline and canine, but it's most notable alien property is the second set of forelegs. Additionally, it has a series of boney blue spikes running down it's spine, a similarly hard tip to it's tail and dark blue fangs hanging from it's snout."
	catalogue_data = list(/datum/category_item/catalogue/fauna/stalker)
	tt_desc = "Crocodylidae "
	icon = 'icons/mob/vore64x64.dmi'
	icon_dead = "sonadile-dead"
	icon_living = "sonadile"
	icon_state = "sonadile"
	icon_rest = "sonadile"
	faction = "sonadile"
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	friendly = list("nudges", "sniffs on", "rumbles softly at", "nuzzles")
	response_help = "bumps"
	response_disarm = "shoves"
	response_harm = "attacks"
	movement_cooldown = 0
	harm_intent_damage = 7
	melee_damage_lower = 3
	melee_damage_upper = 10
	maxHealth = 100
	attacktext = list("bites")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/say_aggro
	say_list_type = /datum/say_list/sonadile

	vore_bump_chance = 25
	vore_digest_chance = 50
	vore_escape_chance = 5
	vore_pounce_chance = 1000
	vore_active = 1
	vore_icons = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 1
	swallowTime = 50
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_DIGEST
	vore_pounce_maxhealth = 1000
	vore_bump_emote = "pounces on"

/mob/living/simple_mob/vore/sonadile/init_vore()
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
	B.escapechance = 5
	B.selective_preference = DM_DIGEST
	B.escape_stun = 5

/datum/say_list/sonadile
	emote_hear = list("hisses","growls","chuffs")
	emote_see = list("watches you carefully","scratches at the ground","whips it's tail","paces")

/datum/category_item/catalogue/fauna/sonadile
	name = "Extra-Realspace Fauna - Cave Stalker"
	desc = "Classification: Canidfelanis\
	<br><br>\
	Cave Stalker's an unusual alien animal found at a number of redgate locations, suspected to have originated from locations other than those that they are found at. \
	They are carnivorous and highly aggressive beasts that spend the majority of their time skulking in dark locations with long lines of sight, they're known to spend a lot of time stalking their prey to assess their vulnerability. \
	Typically they will follow their prey from a distance, and when they are not paying attention, will rush in to tackle their meal. However, they're stealth hunters and are easily startled if spotted. They will not attack their prey head on unless physically provoked to defend themselves."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/sonadile/update_icon()
	. = ..()
	if(vore_active)
		var/voremob_awake = FALSE
		if(icon_state == icon_living)
			voremob_awake = TRUE
		update_fullness()
		if(!vore_fullness)
			update_transform()
			return 0
		else if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED)) && (vore_icons & SA_ICON_LIVING))
			icon_state = "[icon_living]-[vore_fullness]"
			spawn(100)
				if(vore_fullness)
					icon_state = "[icon_living]-2"
					update_transform()
					return 0
		else if(stat >= DEAD && (vore_icons & SA_ICON_DEAD))
			icon_state = "[icon_dead]-[vore_fullness]"
		else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest && (vore_icons & SA_ICON_REST))
			icon_state = "[icon_rest]-[vore_fullness]"
			spawn(100)
				if(vore_fullness)
					icon_state = "[icon_living]-2"
					update_transform()
					return 0
		if(vore_eyes && voremob_awake) //Update eye layer if applicable.
			remove_eyes()
			add_eyes()
	update_transform()