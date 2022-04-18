/datum/species/human
	name = SPECIES_HUMAN
	name_plural = "Humans"
	primitive_form = SPECIES_MONKEY
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	blurb = "Humanity originated in the Sol system, and over the last five centuries has spread \
	colonies across a wide swathe of space. They hold a wide range of forms and creeds.<br/><br/> \
	While the central Sol government maintains control of its far-flung people, powerful corporate \
	interests, rampant cyber and bio-augmentation and secretive factions make life on most human \
	worlds tumultous at best."
	catalogue_data = list(/datum/category_item/catalogue/fauna/humans)
	num_alternate_languages = 3
	species_language = LANGUAGE_SOL_COMMON
	secondary_langs = list(LANGUAGE_SOL_COMMON, LANGUAGE_TERMINUS)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_SKRELLIAN, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)

	min_age = 17
	max_age = 130

	economic_modifier = 10

	health_hud_intensity = 1.5

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart,
		O_LUNGS =		/obj/item/organ/internal/lungs,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain,
		O_APPENDIX = 	/obj/item/organ/internal/appendix,
		O_SPLEEN = 		/obj/item/organ/internal/spleen,
		O_EYES =		/obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair)

/datum/species/human/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN

/datum/species/unathi
	name = SPECIES_UNATHI
	name_plural = "Unathi"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	primitive_form = SPECIES_MONKEY_UNATHI
	darksight = 3
	ambiguous_genders = TRUE
	gluttonous = 1
	slowdown = 0.5
	total_health = 125
	brute_mod = 0.85
	burn_mod = 0.85
	metabolic_rate = 0.85
	item_slowdown_mod = 0.25
	mob_size = MOB_LARGE
	blood_volume = 840
	bloodloss_rate = 0.75
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_UNATHI)
	name_language = LANGUAGE_UNATHI
	species_language = LANGUAGE_UNATHI
	health_hud_intensity = 2.5

	min_age = 32
	max_age = 260

	economic_modifier = 7

	blurb = "A heavily reptillian species, Unathi hail from the \
	Uuosa-Eso system, which roughly translates to 'burning mother'.<br/><br/>Coming from a harsh, inhospitable \
	planet, they mostly hold ideals of honesty, virtue, proficiency and bravery above all \
	else, frequently even their own lives. They prefer warmer temperatures than most species and \
	their native tongue is a heavy hissing laungage called Sinta'Unathi."
	catalogue_data = list(/datum/category_item/catalogue/fauna/unathi)

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	breath_cold_level_1 = 260	//Default 240 - Lower is better
	breath_cold_level_2 = 200	//Default 180
	breath_cold_level_3 = 120	//Default 100

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	breath_heat_level_1 = 450	//Default 380 - Higher is better
	breath_heat_level_2 = 530	//Default 450
	breath_heat_level_3 = 1400	//Default 1250

	minimum_breath_pressure = 18	//Bigger, means they need more air

	body_temperature = T20C

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34AF10"
	blood_color = "#b3cbc3"
	base_color = "#066000"

	reagent_tag = IS_UNATHI

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/unathi),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unathi),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unathi),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	//No kidneys or appendix
	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart/unathi,
		O_LUNGS =    /obj/item/organ/internal/lungs/unathi,
		O_LIVER =    /obj/item/organ/internal/liver/unathi,
		O_BRAIN =    /obj/item/organ/internal/brain/unathi,
		O_EYES =     /obj/item/organ/internal/eyes/unathi,
		O_STOMACH =		/obj/item/organ/internal/stomach/unathi,
		O_INTESTINE =	/obj/item/organ/internal/intestine/unathi
		)


	heat_discomfort_level = 320 //VOREStation Edit - 46c (higher than normal humans) Don't spam red text if you're slightly warm.
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 288.15	//VOREStation Edit - 15c Give a little bit of wiggle room here come on.
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)

	descriptors = list(
		/datum/mob_descriptor/height = 2,
		/datum/mob_descriptor/build = 2
		)

	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway
	)

/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/tajaran
	name = SPECIES_TAJ
	name_plural = "Tajaran"
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	slowdown = -0.5
	snow_movement = -1		//Ignores half of light snow
	brute_mod = 1.15
	burn_mod =  1.15
	flash_mod = 1.1
	metabolic_rate = 1.1
	gluttonous = 1
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_SIIK, LANGUAGE_AKHANI, LANGUAGE_ALAI)
	name_language = LANGUAGE_SIIK
	species_language = LANGUAGE_SIIK
	health_hud_intensity = 2.5

	min_age = 17
	max_age = 80

	economic_modifier = 7

	blurb = "The Tajaran are a mammalian species resembling roughly felines, hailing from Meralar in the Rarkajar system. \
	While reaching to the stars independently from outside influences, the humans engaged them in peaceful trade contact \
	and have accelerated the fledgling culture into the interstellar age. Their history is full of war and highly fractious \
	governments, something that permeates even to today's times. They prefer colder, tundra-like climates, much like their \
	home worlds and speak a variety of languages, especially Siik and Akhani."
	catalogue_data = list(/datum/category_item/catalogue/fauna/tajaran)

	body_temperature = 280.15	//Even more cold resistant, even more flammable

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	breath_cold_level_1 = 180	//Default 240 - Lower is better
	breath_cold_level_2 = 100	//Default 180
	breath_cold_level_3 = 60	//Default 100

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	breath_heat_level_1 = 360	//Default 380 - Higher is better
	breath_heat_level_2 = 430	//Default 450
	breath_heat_level_3 = 1000	//Default 1250

	primitive_form = SPECIES_MONKEY_TAJ

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_TAJARA
	allergens = ALLERGEN_STIMULANT

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

	cold_discomfort_level = 215

	has_organ = list(    //No appendix.
		O_HEART =    /obj/item/organ/internal/heart/tajaran,
		O_LUNGS =    /obj/item/organ/internal/lungs/tajaran,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =    /obj/item/organ/internal/liver/tajaran,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_EYES =     /obj/item/organ/internal/eyes/tajaran,
		O_STOMACH =		/obj/item/organ/internal/stomach/tajaran,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	default_emotes = list(
		//VOREStation Add
		/decl/emote/audible/gnarl,
		/decl/emote/audible/purr,
		/decl/emote/audible/purrlong,
		//VOREStation Add End
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway
	)

/datum/species/tajaran/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/skrell
	name = SPECIES_SKRELL
	name_plural = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	primitive_form = SPECIES_MONKEY_SKRELL
	unarmed_types = list(/datum/unarmed_attack/punch)
	blurb = "An amphibious species, Skrell come from the star system known as Qerr'Vallis, which translates to 'Star of \
	the royals' or 'Light of the Crown'.<br/><br/>Skrell are a highly advanced and logical race who live under the rule \
	of the Qerr'Katish, a caste within their society which keeps the empire of the Skrell running smoothly. Skrell are \
	herbivores on the whole and tend to be co-operative with the other species of the galaxy, although they rarely reveal \
	the secrets of their empire to their allies."
	catalogue_data = list(/datum/category_item/catalogue/fauna/skrell)
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_SKRELLIAN, LANGUAGE_SCHECHI)
	name_language = LANGUAGE_SKRELLIAN
	species_language = LANGUAGE_SKRELLIAN
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_TERMINUS, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)
	health_hud_intensity = 2

	water_movement = -3

	min_age = 19
	max_age = 130

	economic_modifier = 12

	darksight = 4
	flash_mod = 1.2
	chemOD_mod = 0.9

	bloodloss_rate = 1.5

	ambiguous_genders = TRUE

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR

	flesh_color = "#8CD7A3"
	blood_color = "#0081CD"
	base_color = "#006666"

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	breath_cold_level_1 = 250	//Default 240 - Lower is better
	breath_cold_level_2 = 190	//Default 180
	breath_cold_level_3 = 120	//Default 100

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	breath_heat_level_1 = 400	//Default 380 - Higher is better
	breath_heat_level_2 = 500	//Default 450
	breath_heat_level_3 = 1350	//Default 1250

	reagent_tag = IS_SKRELL
	allergens = ALLERGEN_MEAT|ALLERGEN_FISH|ALLERGEN_DAIRY|ALLERGEN_EGGS

	water_breather = TRUE

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/skrell),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart/skrell,
		O_LUNGS =		/obj/item/organ/internal/lungs/skrell,
		O_VOICE = 		/obj/item/organ/internal/voicebox/skrell,
		O_LIVER =		/obj/item/organ/internal/liver/skrell,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys/skrell,
		O_BRAIN =		/obj/item/organ/internal/brain/skrell,
		O_APPENDIX = 	/obj/item/organ/internal/appendix/skrell,
		O_SPLEEN = 		/obj/item/organ/internal/spleen/skrell,
		O_EYES =		/obj/item/organ/internal/eyes/skrell,
		O_STOMACH =		/obj/item/organ/internal/stomach/skrell,
		O_INTESTINE =	/obj/item/organ/internal/intestine/skrell
		)

/datum/species/skrell/can_breathe_water()
	return TRUE

/datum/species/zaddat
	name = SPECIES_ZADDAT
	name_plural = "Zaddat"
	icobase = 'icons/mob/human_races/r_zaddat.dmi'
	deform = 'icons/mob/human_races/r_zaddat.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	brute_mod = 1.15
	burn_mod =  1.15
	toxins_mod = 1.5
	flash_mod = 2
	flash_burn = 15 //flashing a zaddat probably counts as police brutality
	metabolic_rate = 0.7 //did u know if your ancestors starved ur body will actually start in starvation mode?
	gluttonous = 1
	taste_sensitivity = TASTE_SENSITIVE
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_ZADDAT, LANGUAGE_UNATHI)
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_TERMINUS, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_SOL_COMMON, LANGUAGE_AKHANI, LANGUAGE_SIIK, LANGUAGE_GUTTER) //limited vocal range; can talk Unathi and magical Galcom but not much else
	name_language = LANGUAGE_ZADDAT
	species_language = LANGUAGE_ZADDAT
	health_hud_intensity = 2.5

	minimum_breath_pressure = 20 //have fun with underpressures. any higher than this and they'll be even less suitible for life on the station

	economic_modifier = 3

	min_age = 16
	max_age = 90

	blurb = "The Zaddat are an Unathi client race only recently introduced to SolGov space. Having evolved on \
	the high-pressure and post-apocalyptic world of Xohok, Zaddat require an environmental suit called a Shroud \
	to survive in usual planetary and station atmospheres. Despite these restrictions, worsening conditions on \
	Xohok and the blessing of the Moghes Hegemony have lead the Zaddat to enter human space in search of work \
	and living space."
	catalogue_data = list(/datum/category_item/catalogue/fauna/zaddat)

	hazard_high_pressure = HAZARD_HIGH_PRESSURE + 500  // Dangerously high pressure.
	warning_high_pressure = WARNING_HIGH_PRESSURE + 500 // High pressure warning.
	warning_low_pressure = 300   // Low pressure warning.
	hazard_low_pressure = 220     // Dangerously low pressure.
	safe_pressure = 400
	poison_type = "nitrogen"      // technically it's a partial pressure thing but IDK if we can emulate that

	genders = list(FEMALE, PLURAL) //females are polyp-producing, infertile females and males are nigh-identical

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = null

	flesh_color = "#AFA59E"
	base_color = "#e2e4a6"
	blood_color = "#FFCC00" //a gross sort of orange color

	reagent_tag = IS_ZADDAT

	heat_discomfort_strings = list(
		"Your joints itch.",
		"You feel uncomfortably warm.",
		"Your carapace feels like a stove."
		)

	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your antenna ache."
		)

	has_organ = list(    //No appendix.
	O_HEART =    /obj/item/organ/internal/heart,
	O_LUNGS =    /obj/item/organ/internal/lungs,
	O_VOICE = 	 /obj/item/organ/internal/voicebox,
	O_LIVER =    /obj/item/organ/internal/liver,
	O_KIDNEYS =  /obj/item/organ/internal/kidneys,
	O_BRAIN =    /obj/item/organ/internal/brain,
	O_EYES =     /obj/item/organ/internal/eyes,
	O_STOMACH =	 /obj/item/organ/internal/stomach,
	O_INTESTINE =/obj/item/organ/internal/intestine
	)

	descriptors = list(
		/datum/mob_descriptor/height = 0,
		/datum/mob_descriptor/build = -1
		)

	default_emotes = list(
		/decl/emote/audible/chirp
	)

/datum/species/zaddat/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	if(H.wear_suit) //get rid of job labcoats so they don't stop us from equipping the Shroud
		qdel(H.wear_suit) //if you know how to gently set it in like, their backpack or whatever, be my guest
	if(H.wear_mask)
		qdel(H.wear_mask)
	if(H.head)
		qdel(H.head)

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/zaddat/(H), slot_wear_mask) // mask has to come first or Shroud helmet will get in the way
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/void/zaddat/(H), slot_wear_suit)

/datum/species/zaddat/handle_environment_special(var/mob/living/carbon/human/H)

	if(H.inStasisNow())
		return

	var/damageable = H.get_damageable_organs()
	var/covered = H.get_coverage()

	var/light_amount = 0 //how much light there is in the place, affects damage
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		light_amount = T.get_lumcount() * 5


	for(var/K in damageable)
		if(!(K in covered))
			H.apply_damage(light_amount/4, BURN, K, 0, 0, "Abnormal growths")

/datum/species/zaddat/get_perfect_belly_air_type()
	return /datum/gas_mixture/belly_air/zaddat

/datum/species/diona
	name = SPECIES_DIONA
	name_plural = "Dionaea"
	icobase = 'icons/mob/human_races/r_diona.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	language = LANGUAGE_ROOTLOCAL
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/diona)
	//primitive_form = "Nymph"
	slowdown = 5
	snow_movement = -2 	//Ignore light snow
	water_movement = -4	//Ignore shallow water
	rarity_value = 3
	hud_type = /datum/hud_data/diona
	siemens_coefficient = 0.3
	show_ssd = "completely quiescent"
	health_hud_intensity = 2.5
	item_slowdown_mod = 0.1

	num_alternate_languages = 2
	name_language = LANGUAGE_ROOTLOCAL
	species_language = LANGUAGE_ROOTLOCAL
	secondary_langs = list(LANGUAGE_ROOTGLOBAL)
	assisted_langs = list(LANGUAGE_VOX)	// Diona are weird, let's just assume they can use basically any language.
	min_age = 1
	max_age = 300

	economic_modifier = 4

	blurb = "Commonly referred to (erroneously) as 'plant people', the Dionaea are a strange space-dwelling collective \
	species hailing from Epsilon Ursae Minoris. Each 'diona' is a cluster of numerous cat-sized organisms called nymphs; \
	there is no effective upper limit to the number that can fuse in gestalt, and reports exist	of the Epsilon Ursae \
	Minoris primary being ringed with a cloud of singing space-station-sized entities.<br/><br/>The Dionaea coexist peacefully with \
	all known species, especially the Skrell. Their communal mind makes them slow to react, and they have difficulty understanding \
	even the simplest concepts of other minds. Their alien physiology allows them survive happily off a diet of nothing but light, \
	water and other radiation."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dionaea)

	has_organ = list(
		O_NUTRIENT = /obj/item/organ/internal/diona/nutrients,
		O_STRATA =   /obj/item/organ/internal/diona/strata,
		O_BRAIN = /obj/item/organ/internal/brain/cephalon,
		O_RESPONSE = /obj/item/organ/internal/diona/node,
		O_GBLADDER = /obj/item/organ/internal/diona/bladder,
		O_POLYP =    /obj/item/organ/internal/diona/polyp,
		O_ANCHOR =   /obj/item/organ/internal/diona/ligament
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/diona/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/diona/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/no_eyes/diona),
		BP_L_ARM =  list("path" = /obj/item/organ/external/diona/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/diona/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/diona/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/diona/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/diona/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/diona/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/diona/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/diona/foot/right)
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/diona_split_nymph,
		/mob/living/carbon/human/proc/regenerate
		)

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	body_temperature = T0C + 15		//make the plant people have a bit lower body temperature, why not

	flags = NO_SCAN | IS_PLANT | NO_PAIN | NO_SLIP | NO_MINOR_CUT | NO_DEFIB
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED

	blood_color = "#004400"
	flesh_color = "#907E4A"

	reagent_tag = IS_DIONA

	genders = list(PLURAL)

	default_emotes = list(
		/decl/emote/audible/chirp,
		/decl/emote/audible/multichirp
	)

/datum/species/diona/can_understand(var/mob/other)
	if(istype(other, /mob/living/carbon/alien/diona))
		return TRUE
	return FALSE

/datum/species/diona/equip_survival_gear(var/mob/living/carbon/human/H)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/flashlight/flare(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/flashlight/flare(H.back), slot_in_backpack)

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	return ..()

/datum/species/diona/handle_death(var/mob/living/carbon/human/H)

	var/mob/living/carbon/alien/diona/S = new(get_turf(H))

	if(H.mind)
		H.mind.transfer_to(S)

	if(H.isSynthetic())
		H.visible_message("<span class='danger'>\The [H] collapses into parts, revealing a solitary diona nymph at the core.</span>")

		H.species = GLOB.all_species[SPECIES_HUMAN] // This is hard-set to default the body to a normal FBP, without changing anything.

		for(var/obj/item/organ/internal/diona/Org in H.internal_organs) // Remove Nymph organs.
			qdel(Org)

		// Purge the diona verbs.
		H.verbs -= /mob/living/carbon/human/proc/diona_split_nymph
		H.verbs -= /mob/living/carbon/human/proc/regenerate

		return

	for(var/mob/living/carbon/alien/diona/D in H.contents)
		if(D.client)
			D.forceMove(get_turf(H))
		else
			qdel(D)

	H.visible_message("<span class='danger'>\The [H] splits apart with a wet slithering noise!</span>")

/datum/species/diona/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.inStasisNow())
		return

	var/obj/item/organ/internal/diona/node/light_organ = locate() in H.internal_organs

	if(light_organ && !light_organ.is_broken())
		var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
		if(isturf(H.loc)) //else, there's considered to be no light
			var/turf/T = H.loc
			light_amount = T.get_lumcount() * 10
		// Don't overfeed, just make them full without going over.
		if((H.nutrition + light_amount) < initial(H.nutrition))
			H.adjust_nutrition(light_amount)
		H.shock_stage -= light_amount

		if(light_amount >= 3) //if there's enough light, heal
			H.adjustBruteLoss(-(round(light_amount/2)))
			H.adjustFireLoss(-(round(light_amount/2)))
			H.adjustToxLoss(-(light_amount))
			H.adjustOxyLoss(-(light_amount))
			//TODO: heal wounds, heal broken limbs.

	else if(H.nutrition < 200)
		H.take_overall_damage(2,0)

		//traumatic_shock is updated every tick, incrementing that is pointless - shock_stage is the counter.
		//Not that it matters much for diona, who have NO_PAIN.
		H.shock_stage++
