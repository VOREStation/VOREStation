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
	var/suit_storage_icon = 'icons/mob/belt_mirror.dmi'		// Icons used for worn items in suit storage slot.

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

	var/icon_scale_x = 1										// Makes the icon wider/thinner.
	var/icon_scale_y = 1										// Makes the icon taller/shorter.

	var/race_key = 0										// Used for mob icon cache string.
	var/icon/icon_template									// Used for mob icon generation for non-32x32 species.
	var/mob_size	= MOB_MEDIUM
	var/show_ssd = "fast asleep"
	var/virus_immune
	var/short_sighted										// Permanent weldervision.
	var/blood_volume = 560									// Initial blood volume.
	var/bloodloss_rate = 1									// Multiplier for how fast a species bleeds out. Higher = Faster
	var/hunger_factor = 0.05								// Multiplier for hunger.
	var/active_regen_mult = 1								// Multiplier for 'Regenerate' power speed, in human_powers.dm

	var/taste_sensitivity = TASTE_NORMAL					// How sensitive the species is to minute tastes.

	var/min_age = 17
	var/max_age = 70

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
	var/list/assisted_langs = list(LANGUAGE_EAL, LANGUAGE_SKRELLIAN, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX) //VOREStation Edit

	//Soundy emotey things.
	var/scream_verb = "screams"
	var/male_scream_sound		//= 'sound/goonstation/voice/male_scream.ogg' Removed due to licensing, replace!
	var/female_scream_sound		//= 'sound/goonstation/voice/female_scream.ogg' Removed due to licensing, replace!
	var/male_cough_sounds = list('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg')
	var/female_cough_sounds = list('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg')
	var/male_sneeze_sound = 'sound/effects/mob_effects/sneeze.ogg'
	var/female_sneeze_sound = 'sound/effects/mob_effects/f_sneeze.ogg'

	// Combat vars.
	var/total_health = 100									// Point at which the mob will enter crit.
	var/list/unarmed_types = list(							// Possible unarmed attacks that the mob will use in combat,
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
		)
	var/list/unarmed_attacks = null							// For empty hand harm-intent attack
	var/brute_mod =     1									// Physical damage multiplier.
	var/burn_mod =      1									// Burn damage multiplier.
	var/oxy_mod =       1									// Oxyloss modifier
	var/toxins_mod =    1									// Toxloss modifier
	var/radiation_mod = 1									// Radiation modifier
	var/flash_mod =     1									// Stun from blindness modifier.
	var/flash_burn =    0									// how much damage to take from being flashed if light hypersensitive
	var/sound_mod =     1									// Stun from sounds, I.E. flashbangs.
	var/chemOD_mod =	1									// Damage modifier for overdose
	var/vision_flags = SEE_SELF								// Same flags as glasses.

	// Death vars.
	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/human
	var/remains_type = /obj/effect/decal/remains/xeno
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	var/knockout_message = "has been knocked unconscious!"
	var/cloning_modifier = /datum/modifier/cloning_sickness

	// Environment tolerance/life processes vars.
	var/reagent_tag											//Used for metabolizing reagents.
	var/breath_type = "oxygen"								// Non-oxygen gas breathed, if any.
	var/poison_type = "phoron"								// Poisonous air.
	var/exhale_type = "carbon_dioxide"						// Exhaled gas type.

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


	var/item_slowdown_mod = 1								// How affected by item slowdown the species is.
	var/primitive_form										// Lesser form, if any (ie. monkey for humans)
	var/greater_form										// Greater form, if any, ie. human for monkeys.
	var/holder_type
	var/gluttonous											// Can eat some mobs. 1 for mice, 2 for monkeys, 3 for people.

	var/rarity_value = 1									// Relative rarity/collector value for this species.
	var/economic_modifier = 2								// How much money this species makes

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

	var/list/descriptors = list(
		/datum/mob_descriptor/height,
		/datum/mob_descriptor/build
		)

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
		inherent_verbs |= /mob/living/carbon/human/proc/regurgitate

/datum/species/proc/sanitize_name(var/name, var/robot = 0)
	return sanitizeName(name, MAX_NAME_LEN, robot)

/datum/species/proc/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 0,var/comprehensive = 0)
	var/boxtype = /obj/item/weapon/storage/box/survival //Default survival box

	var/synth = H.isSynthetic()

	//Empty box for synths
	if(synth)
		boxtype = /obj/item/weapon/storage/box/survival/synth

	//Special box with extra equipment
	else if(comprehensive)
		boxtype = /obj/item/weapon/storage/box/survival/comp

	//Create the box
	var/obj/item/weapon/storage/box/box = new boxtype(H)

	//If not synth, they get an air tank (if they breathe)
	if(!synth && breath_type)
		//Create a tank (if such a thing exists for this species)
		var/tanktext = "/obj/item/weapon/tank/emergency/" + "[breath_type]"
		var/obj/item/weapon/tank/emergency/tankpath //Will force someone to come look here if they ever alter this path.
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
		new /obj/item/device/fbp_backup_cell(box)

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

	if(H.organs)									H.organs.Cut()
	if(H.internal_organs)				 H.internal_organs.Cut()
	if(H.organs_by_name)					H.organs_by_name.Cut()
	if(H.internal_organs_by_name) H.internal_organs_by_name.Cut()

	H.organs = list()
	H.internal_organs = list()
	H.organs_by_name = list()
	H.internal_organs_by_name = list()

	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/O = new limb_path(H)
		organ_data["descriptor"] = O.name

	for(var/organ_tag in has_organ)
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H,1)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.internal_organs_by_name[organ_tag] = O


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
	//VOREStation Edit Start - Headpats and Handshakes.
	if(H.zone_sel.selecting == "head")
		H.visible_message( \
			"<span class='notice'>[H] pats [target] on the head.</span>", \
			"<span class='notice'>You pat [target] on the head.</span>", )
	else if(H.zone_sel.selecting == "r_hand" || H.zone_sel.selecting == "l_hand")
		H.visible_message( \
			"<span class='notice'>[H] shakes [target]'s hand.</span>", \
			"<span class='notice'>You shake [target]'s hand.</span>", )
	//TFF 15/12/19 - Port nose booping from CHOMPStation
	else if(H.zone_sel.selecting == "mouth")
		H.visible_message( \
			"<span class='notice'>[H] boops [target]'s nose.</span>", \
			"<span class='notice'>You boop [target] on the nose.</span>", )
	//VOREStation Edit End
	else H.visible_message("<span class='notice'>[H] hugs [target] to make [t_him] feel better!</span>", \
					"<span class='notice'>You hug [target] to make [t_him] feel better!</span>") //End VOREStation Edit

/datum/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/datum/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	add_inherent_verbs(H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	return

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/datum/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
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
	return FALSE

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
/datum/species/proc/Stat(var/mob/living/carbon/human/H)
	return

/datum/species/proc/handle_water_damage(var/mob/living/carbon/human/H, var/amount = 0)
	amount *= 1 - H.get_water_protection()
	amount *= water_damage_mod
	if(amount > 0)
		H.adjustToxLoss(amount)
