/*
	Datum-based species. Should make for much cleaner and easier to maintain race code.
*/

/datum/species

	// Descriptors and strings.
	var/name												// Species name.
	var/name_plural											// Pluralized name (since "[name]s" is not always valid)
	var/blurb = "A completely nondescript species."			// A brief lore summary for use in the chargen screen.
	var/list/catalogue_data = null							// A list of /datum/category_item/catalogue datums, for the cataloguer, or null.

	// Icon/appearance vars.
	var/icobase = 'icons/mob/human_races/r_human.dmi'		// Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi'	// Mutated icon set.

	var/speech_bubble_appearance = "normal"					// Part of icon_state to use for speech bubbles when talking.	See talk.dmi for available icons.
	var/fire_icon_state = "humanoid"						// The icon_state used inside OnFire.dmi for when on fire.
	var/suit_storage_icon = 'icons/inventory/suit_store/mob.dmi' // Icons used for worn items in suit storage slot.

	// Damage overlay and masks.
	var/damage_overlays = 'icons/mob/human_races/masks/dam_human.dmi'
	var/damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	var/blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'

	var/prone_icon											// If set, draws this from icobase when mob is prone.
	var/blood_color = "#A10808"								// Red.
	var/flesh_color = "#FFC896"								// Pink.
	var/base_color											// Used by changelings. Should also be used for icon previews.

	var/tail												// Name of tail state in species effects icon file.
	var/tail_animation										// If set, the icon to obtain tail animation states from.
	var/tail_hair

	var/icon_scale_x = DEFAULT_ICON_SCALE_X										// Makes the icon wider/thinner.
	var/icon_scale_y = DEFAULT_ICON_SCALE_Y										// Makes the icon taller/shorter.

	var/race_key = 0										// Used for mob icon cache string.
	var/icon/icon_template									// Used for mob icon generation for non-32x32 species.
	var/mob_size	= MOB_MEDIUM
	var/show_ssd = "fast asleep"
	var/virus_immune
	var/short_sighted										// Permanent weldervision.
	var/blood_name = REAGENT_ID_BLOOD								// Name for the species' blood.
	var/blood_reagents = REAGENT_ID_IRON								// Reagent(s) that restore lost blood. goes by reagent IDs.
	var/blood_volume = 560									// Initial blood volume.
	var/bloodloss_rate = 1									// Multiplier for how fast a species bleeds out. Higher = Faster
	var/blood_level_safe = 0.85								//"Safe" blood level; above this, you're OK
	var/blood_level_warning = 0.75								//"Warning" blood level; above this, you're a bit woozy and will have low-level oxydamage (no more than 20, or 15 with inap)
	var/blood_level_danger = 0.6								//"Danger" blood level; above this, you'll rapidly take up to 50 oxyloss, and it will then steadily accumulate at a lower rate
	var/blood_level_fatal = 0.4								//"Fatal" blood level; below this, you take extremely high oxydamage
	var/hunger_factor = 0.05								// Multiplier for hunger.
	var/active_regen_mult = 1								// Multiplier for 'Regenerate' power speed, in human_powers.dm

	var/taste_sensitivity = TASTE_NORMAL							// How sensitive the species is to minute tastes.
	var/allergens = null									// Things that will make this species very sick
	var/allergen_reaction = AG_TOX_DMG|AG_OXY_DMG|AG_EMOTE|AG_PAIN|AG_BLURRY|AG_CONFUSE	// What type of reactions will you have? These the 'main' options and are intended to approximate anaphylactic shock at high doses.
	var/allergen_damage_severity = 2.5							// How bad are reactions to the allergen? Touch with extreme caution.
	var/allergen_disable_severity = 10							// Whilst this determines how long nonlethal effects last and how common emotes are.

	var/min_age = 18
	var/max_age = 70

	var/icodigi = 'icons/mob/human_races/r_digi.dmi'
	var/digi_allowed = FALSE

	// Language/culture vars.
	var/default_language = LANGUAGE_GALCOM					// Default language is used when 'say' is used without modifiers.
	var/language = LANGUAGE_GALCOM							// Default racial language, if any.
	var/list/species_language = list(LANGUAGE_GALCOM)		// Used on the Character Setup screen
	var/list/secondary_langs = list()						// The names of secondary languages that are available to this species.
	var/list/speech_sounds = list()							// A list of sounds to potentially play when speaking.
	var/list/speech_chance = list()							// The likelihood of a speech sound playing.
	var/num_alternate_languages = 0							// How many secondary languages are available to select at character creation
	var/name_language = LANGUAGE_GALCOM						// The language to use when determining names for this species, or null to use the first name/last name generator

	// The languages the species can't speak without an assisted organ.
	// This list is a guess at things that no one other than the parent species should be able to speak
	var/list/assisted_langs = list(LANGUAGE_EAL, LANGUAGE_SKRELLIAN, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_PROMETHEAN) //VOREStation Edit

	//Soundy emotey things.
	var/scream_verb_1p = "scream"
	var/scream_verb_3p = "screams"
	var/male_scream_sound		//= 'sound/goonstation/voice/male_scream.ogg' Removed due to licensing, replace!
	var/female_scream_sound		//= 'sound/goonstation/voice/female_scream.ogg' Removed due to licensing, replace!
	var/male_cough_sounds = list('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg')
	var/female_cough_sounds = list('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg')
	var/male_sneeze_sound = 'sound/effects/mob_effects/sneeze.ogg'
	var/female_sneeze_sound = 'sound/effects/mob_effects/f_sneeze.ogg'

	var/footstep = FOOTSTEP_MOB_HUMAN
	var/list/special_step_sounds = null

	// Combat/health/chem/etc. vars.
	var/total_health = 100								// How much damage the mob can take before entering crit.
	var/list/unarmed_types = list(							// Possible unarmed attacks that the mob will use in combat,
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
		)
	var/list/unarmed_attacks = null							// For empty hand harm-intent attack
	var/brute_mod =     1								// Physical damage multiplier.
	var/burn_mod =      1								// Burn damage multiplier.
	var/oxy_mod =       1								// Oxyloss modifier
	var/toxins_mod =    1								// Toxloss modifier. overridden by NO_POISON flag.
	var/radiation_mod = 1								// Radiation modifier, determines the practically negligable burn damage from direct exposure to extreme sources.
	var/flash_mod =     1								// Stun from blindness modifier (flashes and flashbangs)
	var/flash_burn =    0								// how much damage to take from being flashed if light hypersensitive
	var/sound_mod =     1								// Multiplier to the effective *range* of flashbangs. a flashbang's bang hits an entire screen radius, with some falloff.
	var/throwforce_absorb_threshold = 0					// Ignore damage of thrown items below this value

	var/chem_strength_heal =    1						// Multiplier to most beneficial chem strength
	var/chem_strength_pain =    1						// Multiplier to painkiller strength (could be used in a negative trait to simulate long-term addiction reducing effects, etc.)
	var/chem_strength_tox =	    1						// Multiplier to the strength of toxic or deabilitating chemicals (inc. chloral/sopo/mindbreaker/ambrosia/etc. thresholds)
	var/chem_strength_alcohol = 1						// Multiplier to alcohol effect thresholds; higher means more is needed to reach a given effect tier

	var/chemOD_threshold =		1						// Multiplier to overdose threshold; lower = easier overdosing
	var/chemOD_mod =		1						// Damage modifier for overdose; higher = more damage from ODs
	var/pain_mod =			1						// Multiplier to pain effects; 0.5 = half, 0 = no effect (equal to NO_PAIN, really), 2 = double, etc.
	var/spice_mod =			1						// Multiplier to spice/capsaicin/frostoil effects; 0.5 = half, 0 = no effect (immunity), 2 = double, etc.
	var/trauma_mod = 		1						// Affects traumatic shock (how fast pain crit happens). 0 = no effect (immunity to pain crit), 2 = double etc.Overriden by "can_feel_pain" var
	// set below is EMP interactivity for nonsynth carbons
	var/emp_sensitivity =		0			// bitflag. valid flags are: EMP_PAIN, EMP_BLIND, EMP_DEAFEN, EMP_CONFUSE, EMP_STUN, and EMP_(BRUTE/BURN/TOX/OXY)_DMG
	var/emp_dmg_mod =		1			// Multiplier to all EMP damage sustained by the mob, if it's EMP-sensitive
	var/emp_stun_mod = 		1			// Multiplier to all EMP disorient/etc. sustained by the mob, if it's EMP-sensitive
	var/vision_flags = SEE_SELF							// Same flags as glasses.
	var/has_vibration_sense = FALSE 	// Motion tracker subsystem

	// Death vars.
	var/meat_type = /obj/item/reagent_containers/food/snacks/meat/human
	var/remains_type = /obj/effect/decal/remains/xeno
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	var/knockout_message = "has been knocked unconscious!"
	var/cloning_modifier = /datum/modifier/cloning_sickness

	// Environment tolerance/life processes vars.
	var/reagent_tag											//Used for metabolizing reagents.
	var/breath_type = GAS_O2								// Non-oxygen gas breathed, if any.
	var/poison_type = GAS_PHORON								// Poisonous air.
	var/exhale_type = GAS_CO2								// Exhaled gas type.
	var/water_breather = FALSE
	var/suit_inhale_sound = 'sound/effects/mob_effects/suit_breathe_in.ogg'
	var/suit_exhale_sound = 'sound/effects/mob_effects/suit_breathe_out.ogg'
	var/bad_swimmer = FALSE

	var/body_temperature = 310.15							// Species will try to stabilize at this temperature. (also affects temperature processing)

	// Cold
	var/cold_level_1 = 260									// Cold damage level 1 below this point.
	var/cold_level_2 = 200									// Cold damage level 2 below this point.
	var/cold_level_3 = 120									// Cold damage level 3 below this point.

	var/breath_cold_level_1 = 240							// Cold gas damage level 1 below this point.
	var/breath_cold_level_2 = 180							// Cold gas damage level 2 below this point.
	var/breath_cold_level_3 = 100							// Cold gas damage level 3 below this point.

	var/cold_discomfort_level = 285							// Aesthetic messages about feeling chilly.
	var/list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
		)

	// Hot
	var/heat_level_1 = 360									// Heat damage level 1 above this point.
	var/heat_level_2 = 400									// Heat damage level 2 above this point.
	var/heat_level_3 = 1000									// Heat damage level 3 above this point.

	var/breath_heat_level_1 = 380							// Heat gas damage level 1 below this point.
	var/breath_heat_level_2 = 450							// Heat gas damage level 2 below this point.
	var/breath_heat_level_3 = 1250							// Heat gas damage level 3 below this point.

	var/heat_discomfort_level = 315							// Aesthetic messages about feeling warm.
	var/list/heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)

	var/water_resistance = 0.1								// How wet the species gets from being splashed.
	var/water_damage_mod = 0								// How much water damage is multiplied by when splashing this species.

	var/passive_temp_gain = 0								// Species will gain this much temperature every second
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE			// Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE		// High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE			// Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE			// Dangerously low pressure.
	var/safe_pressure = ONE_ATMOSPHERE
	var/light_dam											// If set, mob will be damaged in light over this value and heal in light below its negative.
	var/minimum_breath_pressure = 16						// Minimum required pressure for breath, in kPa


	var/metabolic_rate = 1

	// HUD data vars.
	var/datum/hud_data/hud
	var/hud_type
	var/health_hud_intensity = 1							// This modifies how intensely the health hud is colored.

	// Body/form vars.
	var/list/inherent_verbs = list()									// Species-specific verbs.
	var/has_fine_manipulation = 1							// Can use small items.
	var/siemens_coefficient = 1								// The lower, the thicker the skin and better the insulation.
	var/darksight = 2										// Native darksight distance.
	var/flags = 0											// Various specific features.
	var/appearance_flags = 0								// Appearance/display related features.
	var/spawn_flags = 0										// Flags that specify who can spawn as this species

	var/slowdown = 0										// Passive movement speed malus (or boost, if negative)
	var/obj/effect/decal/cleanable/blood/tracks/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // What marks are left when walking
	var/list/skin_overlays = list()
	var/has_floating_eyes = 0								// Whether the eyes can be shown above other icons
	var/has_glowing_eyes = 0								// Whether the eyes are shown above all lighting
	var/water_movement = 0									// How much faster or slower the species is in water
	var/snow_movement = 0									// How much faster or slower the species is on snow
	var/dirtslip = FALSE									// If we slip over dirt or not.
	var/can_space_freemove = FALSE							// Can we freely move in space?
	var/can_zero_g_move	= FALSE								// What about just in zero-g non-space?

	var/swim_mult = 1										//multiplier to our z-movement rate for swimming
	var/climb_mult = 1										//multiplier to our z-movement rate for lattices/catwalks

	var/item_slowdown_mod = 1								// How affected by item slowdown the species is.
	var/primitive_form										// Lesser form, if any (ie. monkey for humans)
	var/greater_form										// Greater form, if any, ie. human for monkeys.
	var/holder_type = /obj/item/holder/micro 				//This allows you to pick up crew
	var/gluttonous											// Can eat some mobs. 1 for mice, 2 for monkeys, 3 for people.
	var/soft_landing = FALSE								// Can fall down and land safely on small falls.

	var/drippy = FALSE 										// If we drip or not. Primarily for goo beings.
	var/photosynthesizing = FALSE							// If we get nutrition from light or not.
	var/shrinks = FALSE										// If we shrink when we have no nutrition. Not added but here for downstream's sake.
	var/grows = FALSE										// Same as above but if we grow when >1000 nutrition.
	var/crit_mod = 1										// Used for when we go unconscious. Used downstream.
	var/list/env_traits = list()
	var/pixel_offset_x = 0									// Used for offsetting 64x64 and up icons.
	var/pixel_offset_y = 0									// Used for offsetting 64x64 and up icons.
	var/rad_levels = NORMAL_RADIATION_RESISTANCE		//For handle_mutations_and_radiation
	var/rad_removal_mod = 1


	var/rarity_value = 1									// Relative rarity/collector value for this species.
	var/economic_modifier = 2								// How much money this species makes

	var/vanity_base_fit 									//when shapeshifting using vanity_copy_to, this allows you to have add something so they can go back to their original species fit

	var/mudking = FALSE										// If we dirty up tiles quicker

	var/vore_belly_default_variant = "H"

	var/list/default_emotes = list()

	// Determines the organs that the species spawns with and
	var/list/has_organ = list(								// which required-organ checks are conducted.
		O_HEART =		/obj/item/organ/internal/heart,
		O_LUNGS =		/obj/item/organ/internal/lungs,
		O_VOICE = 		/obj/item/organ/internal/voicebox,
		O_LIVER =		/obj/item/organ/internal/liver,
		O_KIDNEYS =	/obj/item/organ/internal/kidneys,
		O_BRAIN =		/obj/item/organ/internal/brain,
		O_APPENDIX = /obj/item/organ/internal/appendix,
		O_EYES =		 /obj/item/organ/internal/eyes,
		O_STOMACH =		/obj/item/organ/internal/stomach,
		O_INTESTINE =	/obj/item/organ/internal/intestine
		)
	var/vision_organ										// If set, this organ is required for vision. Defaults to "eyes" if the species has them.
	var/dispersed_eyes            // If set, the species will be affected by flashbangs regardless if they have eyes or not, as they see in large areas.

	var/list/has_limbs = list(
		BP_TORSO =	list("path" = /obj/item/organ/external/chest),
		BP_GROIN =	list("path" = /obj/item/organ/external/groin),
		BP_HEAD =	 list("path" = /obj/item/organ/external/head),
		BP_L_ARM =	list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =	list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =	list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =	list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	var/list/genders = list(MALE, FEMALE)
	var/ambiguous_genders = FALSE // If true, people examining a member of this species whom are not also the same species will see them as gender neutral.	Because aliens.

	// Bump vars
	var/bump_flag = HUMAN			// What are we considered to be when bumped?
	var/push_flags = ~HEAVY			// What can we push?
	var/swap_flags = ~HEAVY			// What can we swap place with?

	var/pass_flags = 0

	var/list/descriptors = list()

	//This is used in character setup preview generation (prefences_setup.dm) and human mob
	//rendering (update_icons.dm)
	var/color_mult = 0

	//This is for overriding tail rendering with a specific icon in icobase, for static
	//tails only, since tails would wag when dead if you used this
	var/icobase_tail = 0

	var/wing_hair
	var/wing
	var/wing_animation
	var/icobase_wing
	var/wikilink = null //link to wiki page for species
	var/icon_height = 32
	var/agility = 20 //prob() to do agile things
	var/gun_accuracy_mod = 0	// More is better
	var/gun_accuracy_dispersion_mod = 0	// More is worse

	var/sort_hint = SPECIES_SORT_NORMAL
	//This is so that if a race is using the chimera revive they can't use it more than once.
	//Shouldn't really be seen in play too often, but it's case an admin event happens and they give a non chimera the chimera revive. Only one person can use the chimera revive at a time per race.
	//var/reviving = 0 //commented out 'cause moved to mob

	var/organic_food_coeff = 1
	var/synthetic_food_coeff = 0
	var/robo_ethanol_proc = 0 //can we get fuel from booze, as a synth?
	var/robo_ethanol_drunk = 0 //can we get *drunk* from booze, as a synth?
	var/digestion_efficiency = 1 //VORE specific digestion var
	//var/vore_numbing = 0
	var/metabolism = 0.0015
	var/lightweight = FALSE //Oof! Nonhelpful bump stumbles.
	var/trashcan = FALSE //It's always sunny in the wrestling ring.
	var/eat_minerals = FALSE //HEAVY METAL DIET
	var/base_species = null // Unused outside of a few species
	var/selects_bodytype = SELECTS_BODYTYPE_FALSE // Allows the species to choose from body types like custom species can, affecting suit fitting and etcetera as you would expect.

	var/bloodsucker = FALSE // Allows safely getting nutrition from blood.
	var/bloodsucker_controlmode = "always loud" //Allows selecting between bloodsucker control modes. Always Loud corresponds to original implementation.

	var/is_weaver = FALSE
	var/silk_production = FALSE
	var/silk_reserve = 100
	var/silk_max_reserve = 500
	var/silk_color = "#FFFFFF"

	var/list/traits = list()
	//Vars that need to be copied when producing a copy of species.
	var/list/copy_vars = list("base_species", "icobase", "deform", "tail", "tail_animation", "icobase_tail", "color_mult", "primitive_form", "appearance_flags", "flesh_color", "base_color", "blood_mask", "damage_mask", "damage_overlays", "move_trail", "has_floating_eyes")
	var/trait_points = 0

	var/ideal_air_type = null	// Set to something else if you breathe something else from default composition. Used for inbelly air.

	var/micro_size_mod = 0		// How different is our size for interactions that involve us being small?
	var/macro_size_mod = 0		// How different is our size for interactions that involve us being big?
	var/digestion_nutrition_modifier = 1
	var/center_offset = 0.5
	var/can_climb = FALSE
	var/climbing_delay = 1.5	// We climb with a quarter delay

	var/list/food_preference = list() //RS edit
	var/food_preference_bonus = 0


	// For Lleill and Hanner
	var/lleill_energy = 200
	var/lleill_energy_max = 200

	var/bite_mod = 1 //NYI - Used Downstream
	var/grab_resist_divisor_victims = 1 //NYI - Used Downstream
	var/grab_resist_divisor_self = 1 //NYI - Used Downstream
	var/grab_power_victims = 0 //NYI - Used Downstream
	var/grab_power_self = 0 //NYI - Used Downstream
	var/waking_speed = 1 //NYI - Used Downstream
	var/lightweight_light = 0 //NYI - Used Downstream

/datum/species/proc/update_attack_types()
	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	// Prep the descriptors for the species
	if(LAZYLEN(descriptors))
		var/list/descriptor_datums = list()
		for(var/desctype in descriptors)
			var/datum/mob_descriptor/descriptor = new desctype
			descriptor.comparison_offset = descriptors[desctype]
			descriptor_datums[descriptor.name] = descriptor
		descriptors = descriptor_datums

	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ[O_EYES])
		vision_organ = O_EYES

	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

	if(gluttonous)
		if(!inherent_verbs)
			inherent_verbs = list()

	update_sort_hint()

/datum/species/proc/get_footsep_sounds()
	return footstep

/datum/species/proc/update_sort_hint()
	if(spawn_flags & SPECIES_IS_RESTRICTED)
		sort_hint = SPECIES_SORT_RESTRICTED
	else if(spawn_flags & SPECIES_IS_WHITELISTED)
		sort_hint = SPECIES_SORT_WHITELISTED

/datum/species/proc/sanitize_name(var/name, var/robot = 0)
	return sanitizeName(name, MAX_NAME_LEN, robot)

/datum/species/proc/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 0,var/comprehensive = 0)
	var/boxtype = /obj/item/storage/box/survival //Default survival box

	var/synth = H.isSynthetic()

	//Empty box for synths
	if(synth)
		boxtype = /obj/item/storage/box/survival/synth

	//Special box with extra equipment
	else if(comprehensive)
		boxtype = /obj/item/storage/box/survival/comp

	//Create the box
	var/obj/item/storage/box/box = new boxtype(H)

	//If not synth, they get an air tank (if they breathe)
	if(!synth && breath_type)
		//Create a tank (if such a thing exists for this species)
		var/tanktext = "/obj/item/tank/emergency/" + "[breath_type]"
		var/obj/item/tank/emergency/tankpath //Will force someone to come look here if they ever alter this path.
		if(extendedtank)
			tankpath = text2path(tanktext + "/engi")
			if(!tankpath) //Is it just that there's no /engi?
				tankpath = text2path(tanktext + "/double")

		if(!tankpath)
			tankpath = text2path(tanktext)

		if(tankpath)
			new tankpath(box)

	//If they are synth, they get a smol battery
	else if(synth)
		new /obj/item/fbp_backup_cell(box)

	box.calibrate_size()

	if(H.backbag == 1)
		H.equip_to_slot_or_del(box, slot_r_hand)
	else
		H.equip_to_slot_or_del(box, slot_in_backpack)

/datum/species/proc/create_organs(var/mob/living/carbon/human/H) //Handles creation of mob organs.

	H.mob_size = mob_size
	for(var/obj/item/organ/organ in H.contents)
		if((organ in H.organs) || (organ in H.internal_organs))
			qdel(organ)

	if(H.organs)					H.organs.Cut()
	if(H.internal_organs)			H.internal_organs.Cut()
	if(H.organs_by_name)			H.organs_by_name.Cut()
	if(H.internal_organs_by_name) 	H.internal_organs_by_name.Cut()
	if(H.bad_external_organs)		H.bad_external_organs.Cut()

	H.organs = list()
	H.internal_organs = list()
	H.organs_by_name = list()
	H.internal_organs_by_name = list()
	H.bad_external_organs = list()

	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/O = new limb_path(H)
		organ_data["descriptor"] = O.name
		if(O.parent_organ)
			organ_data = has_limbs[O.parent_organ]
			organ_data["has_children"] = organ_data["has_children"]+1

	for(var/organ_tag in has_organ)
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H,1)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.internal_organs_by_name[organ_tag] = O

	// set butcherable meats from species
	for(var/obj/item/organ/O in H.organs)
		O.set_initial_meat()
	for(var/obj/item/organ/O in H.internal_organs)
		O.set_initial_meat()

/datum/species/proc/hug(var/mob/living/carbon/human/H, var/mob/living/target)

	var/t_him = "them"
	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		if(!T.species.ambiguous_genders || (T.species.ambiguous_genders && H.species == T.species))
			switch(T.identifying_gender)
				if(MALE)
					t_him = "him"
				if(FEMALE)
					t_him = "her"
		else
			t_him = "them"
	else
		switch(target.gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"

	if(target.touch_reaction_flags & SPECIES_TRAIT_PERSONAL_BUBBLE)
		H.visible_message( \
			span_notice("[target] moves to avoid being touched by [H]!"), \
			span_notice("[target] moves to avoid being touched by you!"), )
		return

	//VOREStation Edit Start - Headpats and Handshakes.
	if(H.zone_sel.selecting == "head")
		if(target.touch_reaction_flags & SPECIES_TRAIT_PATTING_DEFENCE)
			H.visible_message( \
				span_warning("[target] reflexively bites the hand of [H] to prevent head patting!"), \
				span_warning("[target] reflexively bites your hand!"), )
			if(H.hand)
				H.apply_damage(1, BRUTE, BP_L_HAND)
			else
				H.apply_damage(1, BRUTE, BP_R_HAND)
		else
			H.visible_message( \
				span_notice("[H] pats [target] on the head."), \
				span_notice("You pat [target] on the head."), )
	else if(H.zone_sel.selecting == "r_hand" || H.zone_sel.selecting == "l_hand")
		H.visible_message( \
			span_notice("[H] shakes [target]'s hand."), \
			span_notice("You shake [target]'s hand."), )
	else if(H.zone_sel.selecting == "mouth")
		if(target.touch_reaction_flags & SPECIES_TRAIT_PATTING_DEFENCE)
			H.visible_message( \
				span_warning("[target] reflexively bites the hand of [H] to prevent nose booping!"), \
				span_warning("[target] reflexively bites your hand!"), )
			if(H.hand)
				H.apply_damage(1, BRUTE, BP_L_HAND)
			else
				H.apply_damage(1, BRUTE, BP_R_HAND)
		else
			H.visible_message( \
				span_notice("[H] boops [target]'s nose."), \
				span_notice("You boop [target] on the nose."), )
	//VOREStation Edit End
	else
		H.visible_message(span_notice("[H] hugs [target] to make [t_him] feel better!"), \
						span_notice("You hug [target] to make [t_him] feel better!"))

/datum/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			remove_verb(H, verb_path)
	return

/datum/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			add_verb(H, verb_path)
	return

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	add_inherent_verbs(H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	return

// Used for traits and species that have special environmental effects.
/datum/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
	for(var/datum/trait/env_trait in env_traits)
		env_trait.handle_environment_special(H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(var/mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(var/mob/living/carbon/human/H)
	return

//Used by xenos understanding larvae and dionaea understanding nymphs.
/datum/species/proc/can_understand(var/mob/other)
	return

// Called when using the shredding behavior.
/datum/species/proc/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)

	if(!ignore_intent && H.a_intent != I_HURT)
		return 0

	for(var/datum/unarmed_attack/attack in unarmed_attacks)
		if(!attack.is_usable(H))
			continue
		if(attack.shredding)
			return 1

	return 0

// Called in life() when the mob has no client.
/datum/species/proc/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS && H.ai_holder)
		if(H.resting)
			H.resting = FALSE
			H.update_canmove()
	return

// Called when lying down on a water tile.
/datum/species/proc/can_breathe_water()
	return water_breather

// Called when standing on a water tile.
/datum/species/proc/is_bad_swimmer()
	return bad_swimmer

// Impliments different trails for species depending on if they're wearing shoes.
/datum/species/proc/get_move_trail(var/mob/living/carbon/human/H)
	if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
		return /obj/effect/decal/cleanable/blood/tracks/footprints
	else
		return move_trail

/datum/species/proc/update_skin(var/mob/living/carbon/human/H)
	return

/datum/species/proc/get_eyes(var/mob/living/carbon/human/H)
	return

/datum/species/proc/can_overcome_gravity(var/mob/living/carbon/human/H)
	return FALSE

// Used for any extra behaviour when falling and to see if a species will fall at all.
/datum/species/proc/can_fall(var/mob/living/carbon/human/H)
	return TRUE

// Used to find a special target for falling on, such as pouncing on someone from above.
/datum/species/proc/find_fall_target_special(src, landing)
	return FALSE

// Used to override normal fall behaviour. Use only when the species does fall down a level.
/datum/species/proc/fall_impact_special(var/mob/living/carbon/human/H, var/atom/A)
	return FALSE

// Allow species to display interesting information in the human stat panels
/datum/species/proc/get_status_tab_items(var/mob/living/carbon/human/H)
	return ""

/datum/species/proc/handle_water_damage(var/mob/living/carbon/human/H, var/amount = 0)
	amount *= 1 - H.get_water_protection()
	amount *= water_damage_mod
	if(amount > 0)
		H.adjustToxLoss(amount)

/datum/species/proc/handle_falling(mob/living/carbon/human/H, atom/hit_atom, damage_min, damage_max, silent, planetary)
	if(soft_landing)
		if(planetary || !istype(H))
			return FALSE

		var/turf/landing = get_turf(hit_atom)
		if(!istype(landing))
			return FALSE

		if(!silent)
			to_chat(H, span_notice("You manage to lower impact of the fall and land safely."))
			landing.visible_message(span_infoplain(span_bold("\The [H]") + " lowers down from above, landing safely."))
			playsound(H, "rustle", 25, 1)
		return TRUE

	return FALSE

/datum/species/proc/post_spawn_special(mob/living/carbon/human/H)
	return

/datum/species/proc/update_misc_tabs(var/mob/living/carbon/human/H)
	return

/datum/species/proc/handle_base_eyes(var/mob/living/carbon/human/H, var/custom_base)
	if(selects_bodytype && custom_base) // only bother if our src species datum allows bases and one is assigned
		var/datum/species/S = GLOB.all_species[custom_base]

		//extract default eye data from species datum
		var/baseHeadPath = S.has_limbs[BP_HEAD]["path"] //has_limbs is a list of lists

		if(!baseHeadPath)
			return // exit if we couldn't find a head path from the base.

		var/obj/item/organ/external/head/baseHead = new baseHeadPath()
		if(!baseHead)
			return // exit if we didn't create the base properly

		var/obj/item/organ/external/head/targetHead = H.get_organ(BP_HEAD)
		if(!targetHead)
			return // don't bother if target mob has no head for whatever reason

		targetHead.eye_icon = baseHead.eye_icon
		targetHead.eye_icon_location = baseHead.eye_icon_location

		if(!QDELETED(baseHead) && baseHead)
			qdel(baseHead)
	return

/datum/species/proc/give_numbing_bite() //Holy SHIT this is hacky, but it works. Updating a mob's attacks mid game is insane.
	unarmed_attacks = list()
	unarmed_types += /datum/unarmed_attack/bite/sharp/numbing
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/create_organs(var/mob/living/carbon/human/H)
	if(H.nif)
		/*var/type = H.nif.type
		var/durability = H.nif.durability
		var/list/nifsofts = H.nif.nifsofts
		var/list/nif_savedata = H.nif.save_data.Copy()*/
		..()
		H.nif = null //A previous call during the rejuvenation path deleted it, so we no longer should have it here
		/*var/obj/item/nif/nif = new type(H,durability,nif_savedata)
		nif.nifsofts = nifsofts*/
	else
		..()

/datum/species/proc/produceCopy(var/list/traits, var/mob/living/carbon/human/H, var/custom_base, var/reset_dna = TRUE) // Traitgenes reset_dna flag required, or genes get reset on resleeve
	ASSERT(src)
	ASSERT(istype(H))
	var/datum/species/new_copy = new src.type()
	new_copy.race_key = race_key
	if (selects_bodytype && custom_base)
		new_copy.base_species = custom_base
		if(selects_bodytype == SELECTS_BODYTYPE_CUSTOM) //If race selects a bodytype, retrieve the custom_base species and copy needed variables.
			var/datum/species/S = GLOB.all_species[custom_base]
			S.copy_variables(new_copy, copy_vars)

		if(selects_bodytype == SELECTS_BODYTYPE_SHAPESHIFTER)
			H.shapeshifter_change_shape(custom_base, FALSE)

	for(var/organ in has_limbs) //Copy important organ data generated by species.
		var/list/organ_data = has_limbs[organ]
		new_copy.has_limbs[organ] = organ_data.Copy()

	new_copy.traits = traits
	//If you had traits, apply them
	if(new_copy.traits)
		for(var/trait in new_copy.traits)
			var/datum/trait/T = all_traits[trait]
			T.apply(new_copy, H, new_copy.traits[trait])

	//Set up a mob
	H.species = new_copy
	H.icon_state = new_copy.get_bodytype()

	if(new_copy.holder_type)
		H.holder_type = new_copy.holder_type

	if(H.dna && reset_dna)
		H.dna.ready_dna(H)
	handle_base_eyes(H, custom_base)

	if(H.species.has_vibration_sense)
		H.motiontracker_subscribe()

	return new_copy

//We REALLY don't need to go through every variable. Doing so makes this lag like hell on 515
/datum/species/proc/copy_variables(var/datum/species/S, var/list/whitelist)
	//List of variables to ignore, trying to copy type will runtime.
	//var/list/blacklist = list("type", "loc", "client", "ckey")
	//Makes thorough copy of species datum.
	for(var/i in whitelist)
		if(!(i in S.vars)) //Don't copy incompatible vars.
			continue
		if(S.vars[i] != vars[i] && !islist(vars[i])) //If vars are same, no point in copying.
			S.vars[i] = vars[i]

/datum/species/get_bodytype()
	return base_species

/datum/species/proc/update_vore_belly_def_variant()
	// Determine the actual vore_belly_default_variant, if the base species in the VORE tab is set
	switch (base_species)
		if("Teshari")
			vore_belly_default_variant = "T"
		if("Unathi")
			vore_belly_default_variant = "L"
