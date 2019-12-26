
/datum/species
	//var/vore_numbing = 0
	var/gets_food_nutrition = TRUE // If this is set to 0, the person can't get nutrition from food.
	var/metabolism = 0.0015
	var/lightweight = FALSE //Oof! Nonhelpful bump stumbles.
	var/trashcan = FALSE //It's always sunny in the wrestling ring.
	var/base_species = null // Unused outside of a few species
	var/selects_bodytype = FALSE // Allows the species to choose from body types intead of being forced to be just one.

/datum/species/custom
	name = SPECIES_CUSTOM
	name_plural = "Custom"
	selects_bodytype = TRUE
	base_species = SPECIES_HUMAN

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)

	blurb = "This is a custom species where you can assign various species traits to them as you wish, to \
	create a (hopefully) balanced species. You will see the options to customize them on the VORE tab once \
	you select and set this species as your species. Please look at the VORE tab if you select this species."
	catalogue_data = list(/datum/category_item/catalogue/fauna/custom_species)

	name_language = null // Use the first-name last-name generator rather than a language scrambler
	min_age = 18
	max_age = 200
	health_hud_intensity = 2
	num_alternate_languages = 3
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	var/list/traits = list()

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest, "descriptor" = "torso"),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin, "descriptor" = "groin"),
		BP_HEAD =   list("path" = /obj/item/organ/external/head, "descriptor" = "head"),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm, "descriptor" = "left arm"),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right, "descriptor" = "right arm"),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg, "descriptor" = "left leg"),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right, "descriptor" = "right leg"),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand, "descriptor" = "left hand"),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right, "descriptor" = "right hand"),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot, "descriptor" = "left foot"),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right, "descriptor" = "right foot")
		)

/datum/species/custom/get_bodytype()
	return base_species

/datum/species/custom/get_race_key()
	var/datum/species/real = GLOB.all_species[base_species]
	return real.race_key

/datum/species/custom/proc/produceCopy(var/datum/species/to_copy,var/list/traits,var/mob/living/carbon/human/H)
	ASSERT(to_copy)
	ASSERT(istype(H))

	if(ispath(to_copy))
		to_copy = "[initial(to_copy.name)]"
	if(istext(to_copy))
		to_copy = GLOB.all_species[to_copy]

	var/datum/species/custom/new_copy = new()

	//Initials so it works with a simple path passed, or an instance
	new_copy.base_species = to_copy.name
	new_copy.icobase = to_copy.icobase
	new_copy.deform = to_copy.deform
	new_copy.tail = to_copy.tail
	new_copy.tail_animation = to_copy.tail_animation
	new_copy.icobase_tail = to_copy.icobase_tail
	new_copy.color_mult = to_copy.color_mult
	new_copy.primitive_form = to_copy.primitive_form
	new_copy.appearance_flags = to_copy.appearance_flags
	new_copy.flesh_color = to_copy.flesh_color
	new_copy.base_color = to_copy.base_color
	new_copy.blood_mask = to_copy.blood_mask
	new_copy.damage_mask = to_copy.damage_mask
	new_copy.damage_overlays = to_copy.damage_overlays
	new_copy.traits = traits
	new_copy.move_trail = move_trail
	new_copy.has_floating_eyes = has_floating_eyes

	//If you had traits, apply them
	if(new_copy.traits)
		for(var/trait in new_copy.traits)
			var/datum/trait/T = all_traits[trait]
			T.apply(new_copy,H)

	//Set up a mob
	H.species = new_copy

	if(new_copy.holder_type)
		H.holder_type = new_copy.holder_type

	if(H.dna)
		H.dna.ready_dna(H)

	return new_copy

// Stub species overrides for shoving trait abilities into

//Called when face-down in the water or otherwise over their head.
// Return: TRUE for able to breathe fine in water.
/datum/species/custom/can_breathe_water()
	return ..()

//Called during handle_environment in Life() ticks.
// Return: Not used.
/datum/species/custom/handle_environment_special(var/mob/living/carbon/human/H)
	return ..()

//Called when spawning to equip them with special things.
/datum/species/custom/equip_survival_gear(var/mob/living/carbon/human/H)
	/* Example, from Vox:
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/vox(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/vox(H), slot_r_hand)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/vox(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/vox(H.back), slot_in_backpack)
		H.internal = H.r_hand
	H.internal = locate(/obj/item/weapon/tank) in H.contents
	if(istype(H.internal,/obj/item/weapon/tank) && H.internals)
		H.internals.icon_state = "internal1"
	*/
	return ..()
