/datum/species/human
	name = SPECIES_HUMAN
	name_plural = "Humans"
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	deform = 'icons/mob/human_races/r_def_human_vr.dmi'
	primitive_form = SPECIES_MONKEY
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	blurb = "Humanity originated in the Sol system, and over the last three centuries has spread \
	colonies across a wide swathe of space. They hold a wide range of forms and creeds.<br/><br/> \
	While the central Sol government maintains control of its far-flung people, powerful corporate \
	interests, rampant cyber and bio-augmentation and secretive factions make life on most human \
	worlds tumultous at best."
	wikilink="https://wiki.vore-station.net/Human"
	catalogue_data = list(/datum/category_item/catalogue/fauna/humans)
	num_alternate_languages = 3
	species_language = LANGUAGE_SOL_COMMON
	secondary_langs = list(LANGUAGE_SOL_COMMON, LANGUAGE_TERMINUS)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_SKRELLIAN, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN)

	min_age = 18
	max_age = 130
	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	economic_modifier = 10

	health_hud_intensity = 1.5
	base_color = "#EECEB3"
	color_mult = 1


	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

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

	species_sounds = "Human Male"
	gender_specific_species_sounds = TRUE
	species_sounds_male = "Human Male"
	species_sounds_female = "Human Female"

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair)

/datum/species/human/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN

/datum/species/human/vatgrown
	spawn_flags = SPECIES_IS_RESTRICTED

/datum/species/unathi
	name = SPECIES_UNATHI
	name_plural = "Unathi"
	icobase = 'icons/mob/human_races/r_lizard_vr.dmi'
	deform = 'icons/mob/human_races/r_def_lizard_vr.dmi'
	tail_animation = 'icons/mob/species/unathi/tail_vr.dmi'
	tail = "sogtail"
	vore_belly_default_variant = "L"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	primitive_form = SPECIES_MONKEY_UNATHI
	darksight = 3
	ambiguous_genders = TRUE
	slowdown = 0.5
	total_health = 125
	brute_mod = 0.85
	burn_mod = 0.85
	metabolic_rate = 0.85
	item_slowdown_mod = 0.25
	mob_size = MOB_MEDIUM
	blood_volume = 840
	bloodloss_rate = 0.75
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_UNATHI)
	name_language = LANGUAGE_UNATHI
	species_language = LANGUAGE_UNATHI
	health_hud_intensity = 2.5
	chem_strength_alcohol = 1.25
	throwforce_absorb_threshold = 10
	digi_allowed = TRUE
	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	min_age = 18
	max_age = 260

	economic_modifier = 10

	species_sounds = "Lizard" // Species sounds

	pain_verb_1p = list("hiss", "growl")
	pain_verb_3p = list("hisses", "growls")

	blurb = "Heavily reptilian in appearance, the Unathi hail from the Uueoa-Esa system, roughly translated as 'Burning Mother'. \
			Their home planet, Moghes, is an arid climate with hot rocky plains and deserts, and a temperate band of swamps and savannas with \
			massive saltwater lakes being the closest equivalent to oceans. This environment bred a very hardy people who value ideals of honesty, \
			virtue, proficiency and bravery above all else, frequently even one's own life. These same values lend them culturally to imperialistic \
			politics, as well as often being viewed as haughty and arrogant by other interstellar species.<br><br>\
			On the stage of the interstellar political realm the Unathi are noteworthy contenders, the Moghes Hegemony possesses vast technological and \
			material prowess when compared to human contemporaries such as the Sol-Procyon Commonwealth or Ares Confederation. The Hegemony War nearly one \
			hundred years ago is a prime example of this, having engaged in brutal warfare that ultimately fell to a stalemate between all involved parties. \
			Nowadays relations remain cool and somewhat tense, although this does not prevent individual Unathi from finding reasonable career success within Human space."

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

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34AF10"
	blood_color = "#b3cbc3"
	base_color = "#066000"
	color_mult = 1

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

	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway
	)

	footstep = FOOTSTEP_MOB_CLAW

	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair)
	wikilink="https://wiki.vore-station.net/Unathi"

/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/tajaran
	name = SPECIES_TAJARAN
	name_plural = "Tajaran"
	icobase = 'icons/mob/human_races/r_tajaran_vr.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran_vr.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail_vr.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	slowdown = -0.5
	snow_movement = -1		//Ignores half of light snow
	brute_mod = 1.15
	burn_mod =  1.15
	flash_mod = 1.1
	metabolic_rate = 1.1
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_SIIK, LANGUAGE_AKHANI, LANGUAGE_ALAI)
	name_language = LANGUAGE_SIIK
	species_language = LANGUAGE_SIIK
	health_hud_intensity = 2.5
	chem_strength_alcohol = 0.75
	digi_allowed = TRUE
	agility = 90
	can_climb = TRUE
	climbing_delay = 1.00 //Cats are good climbers.

	min_age = 18
	max_age = 80

	economic_modifier = 10

	species_sounds = "Feline"

	pain_verb_1p = list("hiss", "growl", "yowl")
	pain_verb_3p = list("hisses", "growls", "yowls")

	blurb = "The Tajaran are a mammalian species resembling roughly felines, hailing from Meralar in the Rarkajar system. \
	While reaching to the stars independently from outside influences, the humans engaged them in peaceful trade contact \
	and have accelerated the fledgling culture into the interstellar age. Their history is full of war and highly fractious \
	governments, something that permeates even to today's times. They prefer colder, tundra-like climates, much like their \
	home worlds and speak a variety of languages, especially Siik and Akhani."
	wikilink="https://wiki.vore-station.net/Tajaran"
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

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	flesh_color = "#AFA59E"
	base_color = "#333333"
	color_mult = 1

	reagent_tag = IS_TAJARA
	allergens = null

	climb_mult = 0.75

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	heat_discomfort_level = 295 //Prevents heat discomfort spam at 20c
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
	inherent_verbs = list(/mob/living/carbon/human/proc/lick_wounds, /mob/living/carbon/human/proc/tie_hair)

/datum/species/tajaran/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/skrell
	name = SPECIES_SKRELL
	name_plural = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell_vr.dmi'
	deform = 'icons/mob/human_races/r_def_skrell_vr.dmi'
	primitive_form = SPECIES_MONKEY_SKRELL
	unarmed_types = list(/datum/unarmed_attack/punch)
	blurb = "An amphibious species, Skrell come from the star system known as Qerr'Vallis, which translates to 'Star of \
	the royals' or 'Light of the Crown'.<br/><br/>Skrell are a highly advanced and logical race who live under the rule \
	of the Qerr'Katish, a caste within their society which keeps the empire of the Skrell running smoothly. Skrell are \
	herbivores on the whole and tend to be co-operative with the other species of the galaxy, although they rarely reveal \
	the secrets of their empire to their allies."
	wikilink="https://wiki.vore-station.net/Skrell"
	catalogue_data = list(/datum/category_item/catalogue/fauna/skrell)
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_SKRELLIAN, LANGUAGE_SCHECHI)
	name_language = LANGUAGE_SKRELLIAN
	species_language = LANGUAGE_SKRELLIAN
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN)
	health_hud_intensity = 2
	chem_strength_alcohol = 0.2

	water_movement = -3

	min_age = 18
	max_age = 130

	economic_modifier = 10

	darksight = 4
	flash_mod = 1.2
	chemOD_mod = 0.9

	blood_reagents = REAGENT_ID_COPPER
	bloodloss_rate = 1.5

	ambiguous_genders = TRUE

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR

	flesh_color = "#8CD7A3"
	blood_color = "#0081CD"
	base_color = "#006666"
	color_mult = 1

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

	reagent_tag = null //I am going to just NUKE reagent_tag omfg...This is ridiculous
	allergens = null

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	water_breather = TRUE
	water_movement = -4 //Negates shallow. Halves deep.

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

	default_emotes = list(
		/decl/emote/audible/warble,
		/decl/emote/audible/lwarble,
		/decl/emote/audible/croon,
		/decl/emote/audible/croak
	)
	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair, /mob/living/carbon/human/proc/water_stealth, /mob/living/carbon/human/proc/underwater_devour)


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
	item_slowdown_mod = 0.30
	taste_sensitivity = TASTE_SENSITIVE
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_ZADDAT, LANGUAGE_UNATHI)
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN) //limited vocal range; can talk Unathi and magical Galcom but not much else
	name_language = LANGUAGE_ZADDAT
	species_language = LANGUAGE_ZADDAT
	health_hud_intensity = 2.5
	throwforce_absorb_threshold = 5

	minimum_breath_pressure = 20 //have fun with underpressures. any higher than this and they'll be even less suitible for life on the station

	economic_modifier = 3

	min_age = 18
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
	poison_type = GAS_N2      // technically it's a partial pressure thing but IDK if we can emulate that
	ideal_air_type = /datum/gas_mixture/belly_air/zaddat

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	spawn_flags = SPECIES_CAN_JOIN
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


	default_emotes = list(
		/decl/emote/audible/chirp
	)
	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair)

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
			H.apply_damage(light_amount/4, BURN, K, 0, 0)

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
	chem_strength_alcohol = 10000	//a little hacky, maybe? but whatever. nobody plays diona anyway.
	throwforce_absorb_threshold = 5

	num_alternate_languages = 3
	name_language = LANGUAGE_ROOTLOCAL
	species_language = LANGUAGE_ROOTLOCAL
	secondary_langs = list(LANGUAGE_ROOTGLOBAL)
	assisted_langs = list(LANGUAGE_VOX)	// Diona are weird, let's just assume they can use basically any language.
	min_age = 18
	max_age = 300

	economic_modifier = 10

	blurb = "Commonly referred to (erroneously) as 'plant people', the Dionaea are a strange space-dwelling collective \
	species hailing from Epsilon Ursae Minoris. Each 'diona' is a cluster of numerous cat-sized organisms called nymphs; \
	there is no effective upper limit to the number that can fuse in gestalt, and reports exist	of the Epsilon Ursae \
	Minoris primary being ringed with a cloud of singing space-station-sized entities.<br/><br/>The Dionaea coexist peacefully with \
	all known species, especially the Skrell. Their communal mind makes them slow to react, and they have difficulty understanding \
	even the simplest concepts of other minds. Their alien physiology allows them survive happily off a diet of nothing but light, \
	water and other radiation."
	wikilink="https://wiki.vore-station.net/Diona"
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
		/mob/living/carbon/human/proc/regenerate,
		/mob/proc/adjust_hive_range	//VOREStation Add
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

	flags = NO_DNA | NO_SLEEVE | IS_PLANT | NO_PAIN | NO_SLIP | NO_MINOR_CUT | NO_DEFIB
	spawn_flags = SPECIES_CAN_JOIN

	blood_color = "#004400"
	flesh_color = "#907E4A"

	reagent_tag = IS_DIONA

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

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
		H.visible_message(span_danger("\The [H] collapses into parts, revealing a solitary diona nymph at the core."))

		H.species = GLOB.all_species[SPECIES_HUMAN] // This is hard-set to default the body to a normal FBP, without changing anything.

		for(var/obj/item/organ/internal/diona/Org in H.internal_organs) // Remove Nymph organs.
			qdel(Org)

		// Purge the diona verbs.
		remove_verb(H, /mob/living/carbon/human/proc/diona_split_nymph)
		remove_verb(H, /mob/living/carbon/human/proc/regenerate)

		return

	for(var/mob/living/carbon/alien/diona/D in H.contents)
		if(D.client)
			D.forceMove(get_turf(H))
		else
			qdel(D)

	H.visible_message(span_danger("\The [H] splits apart with a wet slithering noise!"))

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



/datum/species/sergal
	name = SPECIES_SERGAL
	name_plural = "Sergals"
	icobase = 'icons/mob/human_races/r_sergal.dmi'
	deform = 'icons/mob/human_races/r_def_sergal.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_SAGARU)
	name_language = LANGUAGE_SAGARU
	species_language = LANGUAGE_SAGARU
	color_mult = 1
	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair)
	digi_allowed = TRUE

	min_age = 18
	max_age = 110

	species_sounds = "Canine"

	blurb = "There are two subspecies of Sergal; Southern and Northern. Northern sergals are a highly aggressive race \
	that lives in the plains and tundra of their homeworld. They are characterized by long, fluffy fur bodies with cold colors; \
	usually with white abdomens, somewhat short ears, and thick faces. Southern sergals are much more docile and live in the \
	Gold Ring City and are scattered around the outskirts in rural areas and small towns. They usually have short, brown or yellow \
	(or other 'earthy' colors) fur, long ears, and a long, thin face. They are smaller than their Northern relatives. Both have strong \
	racial tensions which has resulted in more than a number of wars and outright attempts at genocide. Sergals have an incredibly long \
	lifespan, but due to their lust for violence, only a handful have ever survived beyond the age of 80, such as the infamous and \
	legendary General Rain Silves who is claimed to have lived to 5000."

	wikilink="https://wiki.vore-station.net/Backstory#Sergal"

	catalogue_data = list(/datum/category_item/catalogue/fauna/sergal)

	primitive_form = SPECIES_MONKEY_SERGAL

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#777777"

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/sergal),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

/datum/species/akula
	name = SPECIES_AKULA
	name_plural = "Akula"
	icobase = 'icons/mob/human_races/r_akula.dmi'
	deform = 'icons/mob/human_races/r_def_akula.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_SPACER)
	name_language = LANGUAGE_SPACER
	species_language = LANGUAGE_SPACER
	color_mult = 1
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN)
	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair, /mob/living/carbon/human/proc/water_stealth, /mob/living/carbon/human/proc/underwater_devour)
	min_age = 18
	max_age = 80
	digi_allowed = TRUE

	blurb = "The Akula are a species of amphibious humanoids like the Skrell, but have an appearance very similar to that of a shark. \
	They were first discovered as a primitive race of underwater dwelling tribal creatures by the Skrell. At first they were not believed \
	to be noteworthy, but the Akula proved to be such swift and clever learners that the Skrell reclassified them as sentients. Allegedly, \
	the Akula were also the first sentient life that the Skrell had ever encountered beside themselves, and thus the two species became swift \
	allies over the next few hundred years. With the help of Skrellean technology, the Akula had their genome modified to be capable of \
	surviving in open air for long periods of time. However, Akula even today still require a high humidity environment to avoid drying out \
	after a few days, which would make life on an arid world like Virgo-Prime nearly impossible if it were not for Skrellean technology to aid them."

	wikilink="https://wiki.vore-station.net/Backstory#Akula"

	catalogue_data = list(/datum/category_item/catalogue/fauna/akula)

	primitive_form = SPECIES_MONKEY_AKULA

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	water_breather = TRUE
	water_movement = -4 //Negates shallow. Halves deep.
	swim_mult = 0.5

	flesh_color = "#AFA59E"
	base_color = "#777777"
	blood_color = "#1D2CBF"

/datum/species/nevrean
	name = SPECIES_NEVREAN
	name_plural = "Nevreans"
	icobase = 'icons/mob/human_races/r_nevrean.dmi'
	deform = 'icons/mob/human_races/r_def_nevrean.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	soft_landing = TRUE
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_BIRDSONG)
	name_language = LANGUAGE_BIRDSONG
	species_language = LANGUAGE_BIRDSONG
	color_mult = 1
	inherent_verbs = list(/mob/living/proc/flying_toggle,
		/mob/living/proc/flying_vore_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair)
	min_age = 18
	max_age = 80
	digi_allowed = TRUE

	blurb = "Nevreans are a race of avian and dinosaur-like creatures living on Tal. They belong to a group of races that hails from Eltus, \
	in the Vilous system. Unlike sergals whom they share a star system with, their species is a very peaceful one. They possess remarkable \
	intelligence and very skillful hands that are put use for constructing precision instruments, but tire-out fast when repeatedly working \
	over and over again. Consequently, they struggle to make copies of same things. Both genders have a voice that echoes a lot. Their natural \
	tone oscillates between tenor and soprano. They are excessively noisy when they quarrel in their native language."

	wikilink="https://wiki.vore-station.net/Backstory#Nevrean"

	catalogue_data = list(/datum/category_item/catalogue/fauna/nevrean)

	primitive_form = SPECIES_MONKEY_NEVREAN

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

/datum/species/hi_zoxxen
	name = SPECIES_ZORREN_HIGH
	name_plural = "Zorren"
	icobase = 'icons/mob/human_races/r_fox_vr.dmi'
	deform = 'icons/mob/human_races/r_def_fox.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_TERMINUS)
	name_language = LANGUAGE_TERMINUS
	species_language = LANGUAGE_TERMINUS
	inherent_verbs = list(/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair)
	digi_allowed = TRUE

	min_age = 18
	max_age = 80

	blurb = "The fennec-like, blue-blooded Zorren are native to Virgo 4/Menhir and are descendants of a precursor species \
			that is thought to be responsible for the near-collapse of the biosphere of the planet. \
			With societies organised around hierarchal caste systems (such as the Royal Zorren) or freedom and strength (such as the Free Tribe Zorren), \
			they now slowly recover from their previous hubris and aim to revitalize their planet. While many Zorren live in pre-industrial conditions by necessity, \
			they are an interstellar species known for their pride and stubbornness and doggedly hold out on a Deathworld of their own creation. \
			As local species, they hold moderate sway on local corporations and are hired by NT and other companies, although they find \"Outlander\" culture deeply weird."
	wikilink="https://wiki.vore-station.net/Zorren"

	catalogue_data = list(/datum/category_item/catalogue/fauna/zorren)

	//primitive_form = "" //We don't have fox-monkey sprites.

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	flesh_color = "#AFA59E"
	base_color = "#333333"
	blood_color = "#240bc4"
	blood_reagents = REAGENT_ID_COPPER
	reagent_tag = IS_ZORREN
	color_mult = 1

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

/datum/species/vulpkanin
	name = SPECIES_VULPKANIN
	name_plural = "Vulpkanin"
	blurb = "Vulpkanin are a species of sapient canine bipeds, who are the descendants of a lost colony during the waning days of a Precursor species, \
	from which their distant cousins, the Zorren, also originate from. Independent and iconoclast, they have abandoned the ideals of their forefathers \
	largely and prefer to look outwards as explorers and scientists to forge their own identity. They speak a guttural language known as 'Canilunzt' \
	which has a heavy emphasis on utilizing tail positioning and ear twitches to communicate intent."
	icobase = 'icons/mob/human_races/r_vulpkanin.dmi'
	deform = 'icons/mob/human_races/r_vulpkanin.dmi'
	secondary_langs = list(LANGUAGE_CANILUNZT)
	name_language = LANGUAGE_CANILUNZT
	species_language = LANGUAGE_CANILUNZT
	primitive_form = SPECIES_MONKEY_VULPKANIN
	tail = "vulptail"
	tail_animation = 'icons/mob/species/vulpkanin/tail.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 5
	num_alternate_languages = 3
	color_mult = 1
	inherent_verbs = list(/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/carbon/human/proc/tie_hair)
	digi_allowed = TRUE

	wikilink="https://wiki.vore-station.net/Backstory#Vulpkanin"

	catalogue_data = list(/datum/category_item/catalogue/fauna/vulpkanin)

	//Furry fox-like animals shouldn't start freezing at 5 degrees celsius.
	//Minor cold is resisted, but not severe frost.
	cold_discomfort_level = 263 //Not as good at surviving the frost as tajara, but still better than humans.

	cold_level_1 = 243 //Default 260, other values remain at default. Starts taking damage at -30 celsius. Default tier 2 is -70 and tier 3 is -150


	breath_cold_level_1 = 220 // Default 240, lower is better.

	//While foxes can survive in deserts, that's handled by zorren. It's a good contrast that our vulp find heat a little uncomfortable.

	heat_discomfort_level = 295 //Just above standard 20 C to avoid heat message spam, same as Taj

	heat_level_1 = 345 //Default 360
	heat_level_2 = 390 //Default 400
	heat_level_3 = 900 //Default 1000

	breath_heat_level_1 = 370	//Default 380 - Higher is better
	breath_heat_level_2 = 445	//Default 450
	breath_heat_level_3 = 1125	//Default 1250

	primitive_form = SPECIES_MONKEY_VULPKANIN

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	flesh_color = "#966464"
	base_color = "#B43214"

	min_age = 18
	max_age = 80

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

/datum/species/skrell
	spawn_flags = SPECIES_CAN_JOIN
	icobase = 'icons/mob/human_races/r_skrell_vr.dmi'
	deform = 'icons/mob/human_races/r_def_skrell_vr.dmi'
	color_mult = 1
	min_age = 18
	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair, /mob/living/carbon/human/proc/water_stealth, /mob/living/carbon/human/proc/underwater_devour)
	reagent_tag = null
	allergens = null
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN)
	genders = list(MALE, FEMALE, PLURAL, NEUTER)
	wikilink="https://wiki.vore-station.net/Skrell"

	water_breather = TRUE
	water_movement = -4 //Negates shallow. Halves deep.

/datum/species/zaddat/equip_survival_gear(var/mob/living/carbon/human/H)
	.=..()
	var/obj/item/storage/toolbox/lunchbox/survival/zaddat/L = new(get_turf(H))
	if(H.backbag == 1)
		H.equip_to_slot_or_del(L, slot_r_hand)
	else
		H.equip_to_slot_or_del(L, slot_in_backpack)

/datum/species/human/vatgrown
	spawn_flags = SPECIES_IS_RESTRICTED
/datum/species/harpy
	name = SPECIES_RAPALA
	name_plural = "Rapalans"
	icobase = 'icons/mob/human_races/r_harpy_vr.dmi'
	deform = 'icons/mob/human_races/r_def_harpy_vr.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_BIRDSONG, LANGUAGE_UNATHI)
	species_language = LANGUAGE_UNATHI
	name_language = null
	color_mult = 1
	genders = list(MALE, FEMALE, PLURAL, NEUTER)
	inherent_verbs = list(/mob/living/proc/flying_toggle,/mob/living/proc/flying_vore_toggle,/mob/living/proc/start_wings_hovering,/mob/living/carbon/human/proc/tie_hair)
	digi_allowed = TRUE

	min_age = 18
	max_age = 80

	soft_landing = TRUE

	base_color = "#EECEB3"

	blurb = "An Avian species, coming from a distant planet, the Rapalas are the very proud race.\
	Sol researchers have commented on them having a very close resemblance to the mythical race called 'Harpies',\
	who are known for having massive winged arms and talons as feet. They've been clocked at speeds of over 35 miler per hour chasing the planet's many fish-like fauna.\
	The Rapalan's home-world 'Verita' is a strangely habitable gas giant, while no physical earth exists, there are fertile floating islands orbiting around the planet from past asteroid activity."

	wikilink="https://wiki.vore-station.net/Backstory#Rapala"

	catalogue_data = list(/datum/category_item/catalogue/fauna/rapala)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR


	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

/datum/species/teshari
	name = SPECIES_TESHARI
	name_plural = "Tesharii"
	blurb = "A race of feathered raptors who developed alongside the Skrell, inhabiting \
	the polar tundral regions outside of Skrell territory. Extremely fragile, they developed \
	hunting skills that emphasized taking out their prey without themselves getting hit. They \
	are only recently becoming known on human stations after reaching space with Skrell assistance."
	wikilink="https://wiki.vore-station.net/Teshari"
	catalogue_data = list(/datum/category_item/catalogue/fauna/teshari)

	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_SCHECHI, LANGUAGE_SKRELLIAN)
	name_language = LANGUAGE_SCHECHI
	species_language = LANGUAGE_SCHECHI

	min_age = 18
	max_age = 45

	economic_modifier = 6

	health_hud_intensity = 3

	species_sounds = "Teshari"
	center_offset = 0

	blood_color = "#D514F7"
	flesh_color = "#5F7BB0"
	base_color = "#001144"
	color_mult = 1
	tail = "seromitail"
	icobase_tail = 1
	reagent_tag = IS_TESHARI

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	icobase = 'icons/mob/human_races/r_teshari_vr.dmi'
	deform = 'icons/mob/human_races/r_teshari_vr.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_teshari.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_teshari.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_teshari.dmi'
	suit_storage_icon = 'icons/inventory/suit_store/mob_teshari.dmi'
	vore_belly_default_variant = "T" //Teshari belly sprite

	fire_icon_state = "generic" // Humanoid is too big for them and spriting a new one is really annoying.

	slowdown = -1
	snow_movement = -2	// Ignores light snow
	item_slowdown_mod = 2	// Tiny birds don't like heavy things
	total_health = 50
	brute_mod = 1.35
	burn_mod =  1.35
	mob_size = MOB_MEDIUM
	pass_flags = PASSTABLE
	holder_type = /obj/item/holder/human
//	short_sighted = 1
	has_vibration_sense = TRUE
	blood_volume = 400
	hunger_factor = 0.2
	soft_landing = TRUE
	agility = 90

	ambiguous_genders = TRUE
	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	body_temperature = 270

	cold_level_1 = 180	//Default 260
	cold_level_2 = 130	//Default 200
	cold_level_3 = 70	//Default 120

	breath_cold_level_1 = 180	//Default 240 - Lower is better
	breath_cold_level_2 = 100	//Default 180
	breath_cold_level_3 = 60	//Default 100

	heat_level_1 = 330	//Default 360
	heat_level_2 = 370	//Default 400
	heat_level_3 = 600	//Default 1000

	breath_heat_level_1 = 350	//Default 380 - Higher is better
	breath_heat_level_2 = 400	//Default 450
	breath_heat_level_3 = 800	//Default 1250

	heat_discomfort_level = 295
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		"Your hands and feet feel hot as your body tries to regulate heat",
		)
	cold_discomfort_level = 180
	cold_discomfort_strings = list(
		"You feel a bit chilly.",
		"You fluff up your feathers against the cold.",
		"You move your arms closer to your body to shield yourself from the cold.",
		"You press your ears against your head to conserve heat",
		"You start to feel the cold on your skin",
		)

	minimum_breath_pressure = 12	//Smaller, so needs less air

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/teshari),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/teshari),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/teshari),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/teshari),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/teshari)
		)

	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_LUNGS =    /obj/item/organ/internal/lungs,
		O_VOICE = 	/obj/item/organ/internal/voicebox,
		O_LIVER =    /obj/item/organ/internal/liver,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_EYES =     /obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	unarmed_types = list(
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp,
		/datum/unarmed_attack/stomp/weak
		)

	inherent_verbs = list(
		///mob/living/carbon/human/proc/sonar_ping,
		/mob/living/proc/hide,
		/mob/living/proc/toggle_pass_table
		)

	default_emotes = list(
		/decl/emote/audible/teshsqueak,
		/decl/emote/audible/teshchirp,
		/decl/emote/audible/teshtrill
	)

	footstep = FOOTSTEP_MOB_TESHARI

/datum/species/teshari/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	if(!(H.client?.prefs?.shoe_hater))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)
/*
/datum/species/teshari/handle_falling(mob/living/carbon/human/H, atom/hit_atom, damage_min, damage_max, silent, planetary)

	// Tesh can glide to save themselves from some falls. Basejumping bird
	// without parachute, or falling bird without free wings, goes splat.

	// Are we landing from orbit, or handcuffed/unconscious/tied to something?
	if(planetary || !istype(H) || H.incapacitated(INCAPACITATION_DEFAULT|INCAPACITATION_DISABLED))
		return ..()

	// Are we landing on a turf? Not sure how this could not be the case, but let's be safe.
	var/turf/landing = get_turf(hit_atom)
	if(!istype(landing))
		return ..()

	if(H.buckled)
		if(!silent)
			to_chat(H, span_warning("You try to spread your wings to slow your fall, but \the [H.buckled] weighs you down!"))
		return ..()

	// Is there enough air to flap against?
	var/datum/gas_mixture/environment = landing.return_air()
	if(!environment || environment.return_pressure() < (ONE_ATMOSPHERE * 0.75))
		if(!silent)
			to_chat(H, span_warning("You spread your wings to slow your fall, but the air is too thin!"))
		return ..()

	// Are we wearing a space suit?
	if(H.wear_suit)
		for(var/blacklisted_type in flight_suit_blacklisted_types)
			if(istype(H.wear_suit, blacklisted_type))
				if(!silent)
					to_chat(H, span_warning("You try to spread your wings to slow your fall, but \the [H.wear_suit] is in the way!"))
				return ..()

	// Do we have working wings?
	for(var/bp in flight_bodyparts)
		var/obj/item/organ/external/E = H.organs_by_name[bp]
		if(!istype(E) || !E.is_usable() || E.is_broken() || E.is_stump())
			if(!silent)
				to_chat(H, span_warning("You try to spread your wings to slow your fall, but they won't hold your weight!"))
			return ..()

	// Handled!
	if(!silent)
		to_chat(H, span_notice("You catch the air in your wings and greatly slow your fall."))
		landing.visible_message(span_infoplain(span_bold("\The [H]") + " glides down from above, landing safely."))
		H.Stun(1)
		playsound(H, "rustle", 25, 1)
	return TRUE
*/



/datum/species/crew_shadekin
	name = SPECIES_SHADEKIN_CREW
	name_plural = "Black-Eyed Shadekin"
	icobase = 'icons/mob/human_races/r_shadekin_vr.dmi'
	deform = 'icons/mob/human_races/r_shadekin_vr.dmi'
	tail = "tail"
	icobase_tail = 1
	blurb = "Very little is known about these creatures. They appear to be largely mammalian in appearance. \
	Seemingly very rare to encounter, there have been widespread myths of these creatures the galaxy over, \
	but next to no verifiable evidence to their existence. However, they have recently been more verifiably \
	documented in the Virgo system, following a mining bombardment of Virgo 3. The crew of NSB Adephagia have \
	taken to calling these creatures 'Shadekin', and the name has generally stuck and spread. "		//TODO: Something more fitting for black-eyes
	wikilink = "https://wiki.vore-station.net/Shadekin"
	catalogue_data = list(/datum/category_item/catalogue/fauna/shadekin)
	digi_allowed = TRUE

	language = LANGUAGE_SHADEKIN
	name_language = LANGUAGE_SHADEKIN
	species_language = LANGUAGE_SHADEKIN
	secondary_langs = list(LANGUAGE_SHADEKIN)
	num_alternate_languages = 3
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	rarity_value = 5	//INTERDIMENSIONAL FLUFFERS

	inherent_verbs = list(/mob/proc/adjust_hive_range)

	siemens_coefficient = 0
	darksight = 10

	slowdown = 0.5
	item_slowdown_mod = 1.5

	total_health = 75
	brute_mod = 1.25 // Frail
	burn_mod = 1.25	// Furry
	blood_volume = 500
	hunger_factor = 0.2

	warning_low_pressure = 50
	hazard_low_pressure = -1

	warning_high_pressure = 300
	hazard_high_pressure = INFINITY

	cold_level_1 = -1	//Immune to cold
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 850	//Resistant to heat
	heat_level_2 = 1000
	heat_level_3 = 1150

	flags =  NO_DNA | NO_SLEEVE
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE

	reagent_tag = IS_SHADEKIN		// for shadekin-unqiue chem interactions

	flesh_color = "#FFC896"
	blood_color = "#A10808"
	base_color = "#f0f0f0"
	color_mult = 1

	//has_glowing_eyes = TRUE			// Applicable through traits.

	speech_bubble_appearance = "ghost"

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	breath_type = null
	poison_type = null
	water_breather = TRUE //They do not quite breathe...

	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_SKIN_COLOR | HAS_UNDERWEAR

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	has_organ = list(
		O_HEART =		/obj/item/organ/internal/heart,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain,
		O_EYES =		/obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/crewkin),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/crewkin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/crewkin),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/crewkin),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/crewkin),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/crewkin),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/crewkin),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/crewkin),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/crewkin),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/crewkin),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/crewkin)
		)

/datum/species/crew_shadekin/get_bodytype()
	return SPECIES_SHADEKIN

//These species are not really species but are just there for custom species selection

/datum/species/fl_zorren
	name = SPECIES_FENNEC
	name_plural = "Fennec"
	icobase = 'icons/mob/human_races/r_fennec_vr.dmi'
	deform = 'icons/mob/human_races/r_def_fennec.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_TERMINUS)
	name_language = LANGUAGE_TERMINUS
	species_language = LANGUAGE_TERMINUS
	inherent_verbs = list(/mob/living/carbon/human/proc/lick_wounds,/mob/living/proc/shred_limb,/mob/living/carbon/human/proc/tie_hair)
	digi_allowed = TRUE

	min_age = 18
	max_age = 80

	//primitive_form = "" //We don't have fennec-monkey sprites.
	spawn_flags = SPECIES_IS_RESTRICTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	flesh_color = "#AFA59E"
	base_color = "#333333"
	blood_color = "#240bc4"
	color_mult = 1

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

/datum/species/xenohybrid
	name = SPECIES_XENOHYBRID
	name_plural = "Xenomorphs"
	icobase = 'icons/mob/human_races/r_xenomorph.dmi'
	deform = 'icons/mob/human_races/r_def_xenomorph.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 4 //Better hunters in the dark.
	hunger_factor = 0.1 //In exchange, they get hungry a tad faster.
	num_alternate_languages = 3
	digi_allowed = TRUE

	min_age = 18
	max_age = 80

	blurb = "Xenomorphs hybrids are a mixture of xenomorph DNA and some other humanoid species. \
	Xenomorph hyrids mostly have had had their natural aggression removed due to the gene modification process \
	although there are some exceptions, such as when they are harmed. Most xenomorph hybrids are female, due to their natural xenomorph genes, \
	but there are multiple exceptions. All xenomorph hybrids have had their ability to lay eggs containing facehuggers \
	removed if they had the ability to, although hybrids that previously contained this ability is extremely rare."
	// No wiki page for xenohybrids at present

	//primitive_form = "" //None for these guys

	spawn_flags = SPECIES_IS_RESTRICTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	blood_color = "#12ff12"
	flesh_color = "#201730"
	base_color = "#201730"

	heat_discomfort_strings = list(
		"Your chitin feels extremely warm.",
		"You feel uncomfortably warm.",
		"Your chitin feels hot."
		)

/datum/species/altevian
	name = SPECIES_ALTEVIAN
	name_plural = "Altevians"
	icobase = 'icons/mob/human_races/r_altevian.dmi'
	deform = 'icons/mob/human_races/r_def_altevian.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_TAVAN)
	species_language = LANGUAGE_TAVAN
	name_language = null
	color_mult = 1
	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair)
	digi_allowed = TRUE

	min_age = 18
	max_age = 80

	blurb = "The Altevian are a species of tall, rodent humanoids that are akin to rats for their features. \
	The Altevian, unlike most species, do not have a home planet, nor system, adopting a fully nomadic lifestyle \
	for their survival across the stars. Instead, they have opted to live in massive super capital-class colony-ships \
	with a flagship as their place they would call home."

	wikilink="https://wiki.vore-station.net/Altevian"

	catalogue_data = list(/datum/category_item/catalogue/fauna/altevian)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#777777"

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	burn_mod =  1.15
	hunger_factor = 0.04
	can_zero_g_move = TRUE

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)


/////////////////////
/////SPIDER RACE/////
/////////////////////
/datum/species/spider //These actually look pretty damn spooky!
	name = SPECIES_VASILISSAN
	name_plural = "Vasilissans"
	icobase = 'icons/mob/human_races/r_spider.dmi'
	deform = 'icons/mob/human_races/r_def_spider.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 8		//Can see completely in the dark. They are spiders, after all. Not that any of this matters because people will be using custom race.
	slowdown = -0.15	//Small speedboost, as they've got a bunch of legs. Or something. I dunno.
	brute_mod = 0.8		//20% brute damage reduction
	burn_mod =  1.15	//15% burn damage increase. They're spiders. Aerosol can+lighter = dead spiders.
	throwforce_absorb_threshold = 10
	digi_allowed = TRUE

	num_alternate_languages = 3
	species_language = LANGUAGE_VESPINAE
	secondary_langs = list(LANGUAGE_VESPINAE)
	color_mult = 1
	tail = "tail" //Spider tail.
	icobase_tail = 1

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_silk_amount,
		/mob/living/carbon/human/proc/toggle_silk_production,
		/mob/living/carbon/human/proc/weave_structure,
		/mob/living/carbon/human/proc/weave_item,
		/mob/living/carbon/human/proc/set_silk_color,
		/mob/living/carbon/human/proc/tie_hair)

	min_age = 18
	max_age = 80

	blurb = "Vasilissans are a tall, lanky, spider like people. \
	Each having four eyes, an extra four, large legs sprouting from their back, and a chitinous plating on their body, and the ability to spit webs \
	from their mandible lined mouths.  They are a recent discovery by Nanotrasen, only being discovered roughly seven years ago.  \
	Before they were found they built great cities out of their silk, being united and subjugated in warring factions under great Star Queens  \
	Who forced the working class to build huge, towering cities to attempt to reach the stars, which they worship as gems of great spiritual and magical significance."

	wikilink = "https://wiki.vore-station.net/Vasilissans"

	catalogue_data = list(/datum/category_item/catalogue/fauna/vasilissan)

	hazard_low_pressure = 20 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -1    // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	//primitive_form = SPECIES_MONKEY //I dunno. Replace this in the future.

	flags = NO_MINOR_CUT
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	flesh_color = "#AFA59E" //Gray-ish. Not sure if this is really needed, but eh.
	base_color 	= "#333333" //Blackish-gray
	blood_color = "#0952EF" //Spiders have blue blood.

	is_weaver = TRUE
	silk_reserve = 500
	silk_max_reserve = 1000

	climb_mult = 0.75

/datum/species/spider/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.stat == DEAD) // If they're dead they won't need anything.
		return

	if(H.bodytemperature <= 260) //If they're really cold, they go into stasis.
		var/coldshock = 0
		if(H.bodytemperature <= 260 && H.bodytemperature >= 200) //Chilly.
			coldshock = 4 //This will begin to knock them out until they run out of oxygen and suffocate or until someone finds them.
			H.eye_blurry = 5 //Blurry vision in the cold.
		if(H.bodytemperature <= 199 && H.bodytemperature >= 100) //Extremely cold. Even in somewhere like the server room it takes a while for bodytemp to drop this low.
			coldshock = 8
			H.eye_blurry = 5
		if(H.bodytemperature <= 99) //Insanely cold.
			coldshock = 16
			H.eye_blurry = 5
		H.shock_stage = min(H.shock_stage + coldshock, 160) //cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage.
		return

/datum/species/werebeast
	name = SPECIES_WEREBEAST
	name_plural = "Werebeasts"
	icobase = 'icons/mob/human_races/r_werebeast.dmi'
	deform = 'icons/mob/human_races/r_def_werebeast.dmi'
	icon_template = 'icons/mob/human_races/r_werebeast.dmi'
	tail = "tail"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	total_health = 200
	brute_mod = 0.85
	burn_mod = 0.85
	metabolic_rate = 2
	item_slowdown_mod = 0.25
	hunger_factor = 0.4
	darksight = 8
	mob_size = MOB_LARGE
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_CANILUNZT)
	name_language = LANGUAGE_CANILUNZT
	species_language = LANGUAGE_CANILUNZT
	primitive_form = SPECIES_MONKEY_VULPKANIN
	color_mult = 1
	icon_height = 64
	can_climb = TRUE
	climbing_delay = 1

	min_age = 18
	max_age = 200

	species_sounds = "Canine"

	blurb = "Big buff werewolves. These are a limited functionality event species that are not balanced for regular gameplay. Adminspawn only."

	wikilink="N/A"

	catalogue_data = list(/datum/category_item/catalogue/fauna/vulpkanin)

	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#777777"

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/werebeast),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)


/// XENOCHIMERA
/datum/species/xenochimera //Scree's race.
	name = SPECIES_XENOCHIMERA
	name_plural = "Xenochimeras"
	icobase = 'icons/mob/human_races/r_xenochimera.dmi'
	deform = 'icons/mob/human_races/r_def_xenochimera.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws/chimera, /datum/unarmed_attack/bite/sharp)
	darksight = 8		//critters with instincts to hide in the dark need to see in the dark - about as good as tajara.
	slowdown = -0.2		//scuttly, but not as scuttly as a tajara or a teshari.
	brute_mod = 0.8		//About as tanky to brute as a Unathi. They'll probably snap and go feral when hurt though.
	burn_mod =  1.15	//As vulnerable to burn as a Tajara.
	base_species = "Xenochimera"
	selects_bodytype = SELECTS_BODYTYPE_CUSTOM
	digi_allowed = TRUE
	has_vibration_sense = TRUE

	num_alternate_languages = 3
	species_language = null
	secondary_langs = list("Sol Common")
	//color_mult = 1 //It seemed to work fine in testing, but I've been informed it's unneeded.
	tail = "tail"
	icobase_tail = 1
	inherent_verbs = list(
		/mob/living/carbon/human/proc/reconstitute_form,
		///mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/carbon/human/proc/lick_wounds)		//Xenochimera get all the special verbs since they can't select traits.

	virus_immune = 1 // They practically ARE one.
	min_age = 18
	max_age = 80

	species_sounds = "Unset" // Chimera get a default/safety of unset, going off their icon base if there's none overriding.

	blurb = "Some amalgamation of different species from across the universe,with extremely unstable DNA, making them unfit for regular cloners. \
	Widely known for their voracious nature and violent tendencies when stressed or left unfed for long periods of time. \
	Most, if not all chimeras possess the ability to undergo some type of regeneration process, at the cost of energy."

	wikilink = "https://wiki.vore-station.net/Xenochimera"

	catalogue_data = list(/datum/category_item/catalogue/fauna/xenochimera)

	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.
	cold_level_1 = -1     // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	//primitive_form = SPECIES_MONKEY_TAJ

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE//Whitelisted as restricted is broken.
	flags = NO_SLEEVE | NO_DNA | NO_INFECT // | NO_DEFIB // Dying as a chimera is, quite literally, a death sentence. Well, if it wasn't for their revive, that is. Leaving NO_DEFIB there for the future/in case reversion to old 'chimera no-defib.
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	has_organ = list(    //Same organ list as tajarans, except for their SPECIAL BRAIN.
		O_HEART =		/obj/item/organ/internal/heart,
		O_LUNGS =		/obj/item/organ/internal/lungs,
		O_VOICE =		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =		/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain,
		O_EYES =		/obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)

	flesh_color = "#AFA59E"
	base_color 	= "#333333"
	blood_color = "#14AD8B"

	reagent_tag = IS_CHIMERA

/datum/species/xenochimera/handle_environment_special(var/mob/living/carbon/human/H)
	//If they're KO'd/dead, or reviving, they're probably not thinking a lot about much of anything.
	if(!H.stat || !(H.revive_ready == REVIVING_NOW || H.revive_ready == REVIVING_DONE))
		handle_feralness(H)

	//While regenerating
	if(H.revive_ready == REVIVING_NOW || H.revive_ready == REVIVING_DONE)
		H.stunned = 5
		H.canmove = 0
		H.does_not_breathe = TRUE
		var/regen_sounds = H.regen_sounds
		if(prob(2)) // 2% chance of playing squelchy noise while reviving, which is run roughly every 2 seconds/tick while regenerating.
			playsound(H, pick(regen_sounds), 30)
			H.visible_message(span_danger("<p>" + span_huge("[H.name]'s motionless form shudders grotesquely, rippling unnaturally.") + "</p>"))
		if(!H.lying)
			H.lay_down()
	//Cold/pressure effects when not regenerating
	else
		var/datum/gas_mixture/environment = H.loc.return_air()
		var/pressure2 = environment.return_pressure()
		var/adjusted_pressure2 = H.calculate_affecting_pressure(pressure2)

		//Very low pressure damage
		if(adjusted_pressure2 <= 20)
			H.take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
		//they handle areas where they can't breathe better than most, but it still lowers their effective health as well as all the other bad stuff that comes with unbreathable environments
		if(H.getOxyLoss() >= 50)
			H.does_not_breathe = TRUE

		//Cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage or trigger feral.
		//NB: 'body_temperature' used here is the 'setpoint' species var
		var/temp_diff = body_temperature - H.bodytemperature
		if(temp_diff >= 50)
			H.shock_stage = min(H.shock_stage + (temp_diff/20), 160) // Divided by 20 is the same as previous numbers, but a full scale
			H.eye_blurry = max(5,H.eye_blurry)

/datum/species/xenochimera/proc/handle_feralness(var/mob/living/carbon/human/H)
	//first, calculate how stressed the chimera is
	var/laststress = 0
	var/obj/item/organ/internal/brain/B = H.internal_organs_by_name[O_BRAIN]
	if(B) //if you don't have a chimera brain in a chimera body somehow, you don't get the feraless protection
		laststress = B.laststress

	//Low-ish nutrition has messages and can eventually cause feralness
	var/hunger = max(0, 150 - H.nutrition)

	//pain makes feralness a thing
	var/shock = 0.75*H.traumatic_shock

	//Caffeinated or otherwise overexcited xenochimera can become feral and have special messages
	var/jittery = max(0, H.jitteriness - 100)

	//To reduce distant object references
	var/feral = H.feral

	//Are we in danger of ferality?
	var/danger = FALSE
	var/feral_state = FALSE

	//finally, calculate the current stress total the chimera is operating under, and the cause
	var/currentstress = (hunger + shock + jittery)
	var/cause = "stress"
	if(hunger > shock && hunger > jittery)
		cause = "hunger"
	else if (shock > hunger && shock > jittery)
		cause = "shock"
	else if (jittery > shock && jittery > hunger)
		cause = "jittery"

	//check to see if they go feral if they weren't before
	if(!feral && !isbelly(H.loc))
		// if stress is below 15, no chance of snapping. Also if they weren't feral before, they won't suddenly become feral unless they get MORE stressed
		if((currentstress > laststress) && prob(clamp(currentstress-15, 0, 100)) )
			go_feral(H, currentstress, cause)
			feral = currentstress //update the local var

		//they didn't go feral, give 'em a chance of hunger messages
		else if(H.nutrition <= 200 && prob(0.5))
			switch(H.nutrition)
				if(150 to 200)
					to_chat(H,span_info("You feel rather hungry. It might be a good idea to find some some food..."))
				if(100 to 150)
					to_chat(H,span_warning("You feel like you're going to snap and give in to your hunger soon... It would be for the best to find some [pick("food","prey")] to eat..."))
					danger = TRUE

	//now the check's done, update their brain so it remembers how stressed they were
	if(B && !isbelly(H.loc)) //another sanity check for brain implant shenanigans, also no you don't get to hide in a belly and get your laststress set to a huge amount to skip rolls
		B.laststress = currentstress

	// Handle being feral
	if(feral)
		//We're feral
		feral_state = TRUE

		//If they're still stressed, they stay feral
		if(currentstress >= 15)
			danger = TRUE
			feral = max(feral, currentstress)

		else
			feral = max(0,--feral)

			// Being in a belly or in the darkness decreases stress further. Helps mechanically reward players for staying in darkness + RP'ing appropriately. :9
			var/turf/T = get_turf(H)
			if(feral && (isbelly(H.loc) || T.get_lumcount() <= 0.1))
				feral = max(0,--feral)

		//Set our real mob's var to our temp var
		H.feral = feral

		//Did we just finish being feral?
		if(!feral)
			feral_state = FALSE
			to_chat(H,span_info("Your thoughts start clearing, your feral urges having passed - for the time being, at least."))
			log_and_message_admins("is no longer feral.", H)
			update_xenochimera_hud(H, danger, feral_state)
			return

		//If they lose enough health to hit softcrit, handle_shock() will keep resetting this. Otherwise, pissed off critters will lose shock faster than they gain it.
		H.shock_stage = max(H.shock_stage-(feral/20), 0)

		//Handle light/dark areas
		var/turf/T = get_turf(H)
		if(!T)
			update_xenochimera_hud(H, danger, feral_state)
			return //Nullspace
		var/darkish = T.get_lumcount() <= 0.1

		//Don't bother doing heavy lifting if we weren't going to give emotes anyway.
		if(!prob(1))

			//This is basically the 'lite' version of the below block.
			var/list/nearby = H.living_mobs(world.view)

			//Not in the dark, or a belly, and out in the open.
			if(!darkish && isturf(H.loc) && !isbelly(H.loc)) // Added specific check for if in belly

				//Always handle feral if nobody's around and not in the dark.
				if(!nearby.len)
					H.handle_feral()

				//Rarely handle feral if someone is around
				else if(prob(1))
					H.handle_feral()

			//And bail
			update_xenochimera_hud(H, danger, feral_state)
			return

		// In the darkness, or "hidden", or in a belly. No need for custom scene-protection checks as it's just an occational infomessage.
		if(darkish || !isturf(H.loc) || isbelly(H.loc)) // Specific check for if in belly. !isturf should do this, but JUST in case.
			// If hurt, tell 'em to heal up
			if (cause == "shock")
				to_chat(H,span_info("This place seems safe, secure, hidden, a place to lick your wounds and recover..."))

			//If hungry, nag them to go and find someone or something to eat.
			else if(cause == "hunger")
				to_chat(H,span_info("Secure in your hiding place, your hunger still gnaws at you. You need to catch some food..."))

			//If jittery, etc
			else if(cause == "jittery")
				to_chat(H,span_info("sneakysneakyyesyesyescleverhidingfindthingsyessssss"))

			//Otherwise, just tell them to keep hiding.
			else
				to_chat(H,span_info("...safe..."))

		// NOT in the darkness
		else

			//Twitch twitch
			if(!H.stat)
				H.emote("twitch")

			var/list/nearby = H.living_mobs(world.view)

			// Someone/something nearby
			if(nearby.len)
				var/M = pick(nearby)
				if(cause == "shock")
					to_chat(H,span_danger("You're hurt, in danger, exposed, and [M] looks to be a little too close for comfort..."))
				else
					to_chat(H,span_danger("Every movement, every flick, every sight and sound has your full attention, your hunting instincts on high alert... In fact, [M] looks extremely appetizing..."))

			// Nobody around
			else
				if(cause == "hunger")
					to_chat(H,span_danger("Confusing sights and sounds and smells surround you - scary and disorienting it may be, but the drive to hunt, to feed, to survive, compels you."))
				else if(cause == "jittery")
					to_chat(H,span_danger("yesyesyesyesyesyesgetthethingGETTHETHINGfindfoodsfindpreypounceyesyesyes"))
				else
					to_chat(H,span_danger("Confusing sights and sounds and smells surround you, this place is wrong, confusing, frightening. You need to hide, go to ground..."))

	// HUD update time
	update_xenochimera_hud(H, danger, feral_state)

/datum/species/xenochimera/proc/go_feral(var/mob/living/carbon/human/H, var/stress, var/cause)
	// Going feral due to hunger
	if(cause == "hunger")
		to_chat(H,span_danger(span_large("Something in your mind flips, your instincts taking over, no longer able to fully comprehend your surroundings as survival becomes your primary concern - you must feed, survive, there is nothing else. Hunt. Eat. Hide. Repeat.")))
		log_and_message_admins("has gone feral due to hunger.", H)

	// If they're hurt, chance of snapping.
	else if(cause == "shock")
		//If the majority of their shock is due to halloss, give them a different message (3x multiplier on check as halloss is 2x - meaning t_s must be at least 3x for other damage sources to be the greater part)
		if(3*H.halloss >= H.traumatic_shock)
			to_chat(H,span_danger(span_large("The pain! It stings! Got to get away! Your instincts take over, urging you to flee, to hide, to go to ground, get away from here...")))
			log_and_message_admins("has gone feral due to halloss.", H)

		//Majority due to other damage sources
		else
			to_chat(H,span_danger(span_large("Your fight-or-flight response kicks in, your injuries too much to simply ignore - you need to flee, to hide, survive at all costs - or destroy whatever is threatening you.")))
			log_and_message_admins("has gone feral due to injury.", H)

	//No hungry or shock, but jittery
	else if(cause == "jittery")
		to_chat(H,span_warning(span_large("Suddenly, something flips - everything that moves is... potential prey. A plaything. This is great! Time to hunt!")))
		log_and_message_admins("has gone feral due to jitteriness.", H)

	else // catch-all just in case something weird happens
		to_chat(H,span_warning(span_large("The stress of your situation is too much for you, and your survival instincts kick in!")))
		log_and_message_admins("has gone feral for unknown reasons.", H)
	//finally, set their feral var
	H.feral = stress
	if(!H.stat)
		H.emote("twitch")

/datum/species/xenochimera/get_race_key()
	var/datum/species/real = GLOB.all_species[base_species]
	return real.race_key

/datum/species/xenochimera/proc/update_xenochimera_hud(var/mob/living/carbon/human/H, var/danger, var/feral)
	if(H.xenochimera_danger_display)
		H.xenochimera_danger_display.invisibility = 0
		if(danger && feral)
			H.xenochimera_danger_display.icon_state = "danger11"
		else if(danger && !feral)
			H.xenochimera_danger_display.icon_state = "danger10"
		else if(!danger && feral)
			H.xenochimera_danger_display.icon_state = "danger01"
		else
			H.xenochimera_danger_display.icon_state = "danger00"

	return

/obj/screen/xenochimera
	icon = 'icons/mob/chimerahud.dmi'
	invisibility = 101

/obj/screen/xenochimera/danger_level
	name = "danger level"
	icon_state = "danger00"		//first number is bool of whether or not we're in danger, second is whether or not we're feral
	alpha = 200

/datum/species/sparkledog //Exists primarily as an april fools joke, along with everything tied to it!
	name = SPECIES_SPARKLE
	name_plural = "Sparklies"
	icobase = 'icons/mob/human_races/r_sparkle.dmi'
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	slowdown = -0.5
	brute_mod = 1.5
	burn_mod =  1.5
	bloodloss_rate = 1.5
	toxins_mod =    0.5
	radiation_mod = 0
	flash_mod =     2
	siemens_coefficient = 10

	darksight = 2

	num_alternate_languages = 3
	language = LANGUAGE_SPARKLE
	species_language = LANGUAGE_SPARKLE
	secondary_langs = list(LANGUAGE_SPARKLE, LANGUAGE_SOL_COMMON)
	color_mult = 1
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN)
	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair, /mob/living/proc/toggle_sparkles, /mob/living/proc/healing_rainbows, /mob/living/carbon/human/proc/play_dead)
	min_age = 18
	max_age = 21
	digi_allowed = FALSE //No time for making rainbow legs for the meme, sorry!

	pass_flags = PASSTABLE

	blurb = "Th3 ultimate lifeform, th3 l@st of th3 sp@rkl3 d0gg0s. M0r3 p0w3rful th@nn @ny 0th3r sp3ci3s in th3 3ntir3 un1v3rs3!!! When 3v3ryth1ng is crashing d0wn, y0u c@nn always r3ly 0n th3m to s@v3 th3 d@y. N0 0n3 3ls3 h@s th@t k1nd of str3ngth. R@wr XD #sp@rkl3d0gg0 #s@v1ngth3d@y #n0b0dyc@r3s"

	wikilink="https://wiki.vore-station.net/"

	primitive_form = SPECIES_MONKEY_VULPKANIN

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	flesh_color = "#ffffff"
	base_color = "#ffffff"
	blood_color = "#ff00d9"
