/datum/species/alraune
	name = SPECIES_ALRAUNE
	name_plural = "Alraunes"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	num_alternate_languages = 2
	language = LANGUAGE_ROOTLOCAL
	slowdown = 1 //slow, they're plants. Not as slow as full diona.
	total_health = 100 //standard
	brute_mod = 1 //nothing special
	burn_mod = 1.5 //plants don't like fire
	metabolic_rate = 0.75 // slow metabolism
	item_slowdown_mod = 0.25 //while they start slow, they don't get much slower
	bloodloss_rate = 0.1 //While they do bleed, they bleed out VERY slowly
	min_age = 18
	max_age = 250
	health_hud_intensity = 1.5

	body_temperature = T20C
	breath_type = "oxygen"
	poison_type = "phoron"
	exhale_type = null // as much as I'd like them to breathe in CO2 and breathe out O2, it'd take completely rewriting breath code

	// Heat and cold resistances are 20 degrees broader on the level 1 range, level 2 is default, level 3 is much weaker, halfway between L2 and normal L3.
	// Essentially, they can tolerate a broader range of comfortable temperatures, but suffer more at extremes.
	cold_level_1 = 240 //Default 260 - Lower is better
	cold_level_2 = 200 //Default 200
	cold_level_3 = 160 //Default 120
	cold_discomfort_level = 260	//they start feeling uncomfortable around the point where humans take damage

	heat_level_1 = 380 //Default 360 - Higher is better
	heat_level_2 = 400 //Default 400
	heat_level_3 = 700 //Default 1000
	heat_discomfort_level = 360

	breath_cold_level_1 = -1 //They don't have lungs, they breathe through their skin
	breath_cold_level_2 = -1 //and we don't want messages about icicles in their nonexistent lungs
	breath_cold_level_3 = -1

	breath_heat_level_1 = INFINITY
	breath_heat_level_2 = INFINITY
	breath_heat_level_3 = INFINITY

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED // whitelist only while WIP
	flags = NO_SCAN | IS_PLANT | NO_MINOR_CUT
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	inherent_verbs = list(
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/bloodsuck) //Give them the voremodes related to wrapping people in vines and sapping their fluids

	color_mult = 1
	icobase = 'icons/mob/human_races/r_human_vr.dmi'
	deform = 'icons/mob/human_races/r_def_human_vr.dmi'
	flesh_color = "#9ee02c"
	blood_color = "#edf4d0" //sap!
	base_color = "#1a5600"

	blurb = "Alraunes are a rare sight in space. Their bodies are reminiscent of that of plants, and yet they share many\
	traits with other humanoid beings.\
	\
	Most Alraunes are not interested in traversing space, their heavy preference for natural environments and general\
	disinterest in things outside it keeps them as a species at a rather primal stage.\
	\
	However, after their discovery by the angels of Sanctum, many alraunes succumbed to their curiosity, and took the offer\
	to learn of the world and venture out, whether it's to Sanctum, or elsewhere in the galaxy."

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

	// limited organs, 'cause they're simple
	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart,
		O_BRAIN =    /obj/item/organ/internal/brain,
		O_EYES =     /obj/item/organ/internal/eyes,
		)

/datum/species/alraune/can_breathe_water()
	return TRUE //eh, why not? Aquatic plants are a thing.


/datum/species/alraune/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.inStasisNow()) // if they're in stasis, they won't need this stuff.
		return

	//They don't have lungs so breathe() will just return. Instead, they breathe through their skin.

	var/datum/gas_mixture/breath = null
	var/fullysealed = FALSE //if they're wearing a fully sealed suit, their internals take priority.
	var/environmentalair = FALSE //if no sealed suit, internals take priority in low pressure environements

	if(H.wear_suit && (H.wear_suit.item_flags & STOPPRESSUREDAMAGE) && H.head && (H.head.item_flags & STOPPRESSUREDAMAGE))
		fullysealed = TRUE
	else // find out if local gas mixture is enough to override use of internals
		var/datum/gas_mixture/environment = H.loc.return_air()
		var/envpressure = environment.return_pressure()
		if(envpressure >= hazard_low_pressure)
			environmentalair = TRUE

	if(fullysealed || !environmentalair)
		breath = H.get_breath_from_internal()

	if(!breath) //No breath from internals so let's try to get air from our location
		// cut-down version of get_breath_from_environment - notably, gas masks provide no benefit
		var/datum/gas_mixture/environment2
		if(H.loc)
			environment2 = H.loc.return_air_for_internal_lifeform(H)

		if(environment2)
			breath = environment2.remove_volume(BREATH_VOLUME)
			H.handle_chemical_smoke(environment2) //handle chemical smoke while we're at it

	H.handle_breath(breath) // everything that needs to be handled is handled in here

	// Now we've handled the usual breathing stuff, check for presence of CO2 in breath, and light levels

	var/co2buff = 0
	if(breath.gas["carbon_dioxide"])
		var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME
		var/CO2_pp = (breath.gas["carbon_dioxide"] / breath.total_moles) * breath_pressure
		co2buff = (Clamp(CO2_pp, 0, minimum_breath_pressure))/minimum_breath_pressure //returns a value between 0 and 1.
		H.adjustOxyLoss(-co2buff*2)

	var/light_amount = fullysealed ? H.getlightlevel() : H.getlightlevel()/3 // if they're covered, they're not going to get much light on them.

	if(co2buff >= 0.2 && light_amount >= 0.4) //if there's enough light and CO2, heal. Note if you're wearing a sealed suit you'll never be able to do this no matter how much CO2 you cheese into your internals tank.
		H.adjustBruteLoss(-(light_amount * co2buff * 2)) //even at a full partial pressure of CO2 and full light, you'll only heal half as fast as diona.
		H.adjustFireLoss(-(light_amount * co2buff)) //this won't let you tank environmental damage from fire.

	if(H.nutrition < (200 + 400*co2buff)) //if no CO2, a fully lit tile gives them 1/tick up to 200. With CO2, potentially up to 600.
		H.nutrition += (light_amount*(1+co2buff*5))