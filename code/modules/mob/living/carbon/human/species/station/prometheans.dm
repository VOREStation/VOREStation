var/datum/species/shapeshifter/promethean/prometheans

// Species definition follows.
/datum/species/shapeshifter/promethean

	name =             SPECIES_PROMETHEAN
	name_plural =      "Prometheans"
	blurb =            "Prometheans (Macrolimus artificialis) are a species of artificially-created gelatinous humanoids, \
	chiefly characterized by their primarily liquid bodies and ability to change their bodily shape and color in order to  \
	mimic many forms of life. Derived from the Aetolian giant slime (Macrolimus vulgaris) inhabiting the warm, tropical planet \
	of Aetolus, they are a relatively new lab-created sapient species, and as such many things about them have yet to be comprehensively studied. \
	What has Science done?"
	catalogue_data = list(/datum/category_item/catalogue/fauna/promethean)
	show_ssd =         "totally quiescent"
	death_message =    "rapidly loses cohesion, splattering across the ground..."
	knockout_message = "collapses inwards, forming a disordered puddle of goo."
	remains_type = /obj/effect/decal/cleanable/ash

	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	hunger_factor =    0.2
	reagent_tag =      IS_SLIME
	mob_size =         MOB_SMALL
	bump_flag =        SLIME
	swap_flags =       MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags =       MONKEY|SLIME|SIMPLE_ANIMAL
	flags =            NO_SCAN | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT | NO_DEFIB
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS | HAS_UNDERWEAR
	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	health_hud_intensity = 2
	num_alternate_languages = 3
	language = LANGUAGE_PROMETHEAN
	species_language = LANGUAGE_PROMETHEAN
	secondary_langs = list(LANGUAGE_PROMETHEAN, LANGUAGE_SOL_COMMON)	// For some reason, having this as their species language does not allow it to be chosen.
	assisted_langs = list(LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)	// Prometheans are weird, let's just assume they can use basically any language.

	blood_name = "gelatinous ooze"

	breath_type = null
	poison_type = null

	speech_bubble_appearance = "slime"

	male_cough_sounds = list('sound/effects/slime_squish.ogg')
	female_cough_sounds = list('sound/effects/slime_squish.ogg')

	min_age =		1
	max_age =		16

	economic_modifier = 3

	gluttonous =	1
	virus_immune =	1
	blood_volume =	560
	brute_mod =		0.75
	burn_mod =		2
	oxy_mod =		0
	flash_mod =		0.5 //No centralized, lensed eyes.
	item_slowdown_mod = 1.33

	chem_strength_alcohol = 2

	cloning_modifier = /datum/modifier/cloning_sickness/promethean

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 320 //Default 360
	heat_level_2 = 370 //Default 400
	heat_level_3 = 600 //Default 1000

	body_temperature = T20C	// Room temperature

	rarity_value = 5
	siemens_coefficient = 0.8

	water_resistance = 0
	water_damage_mod = 0.3

	genders = list(MALE, FEMALE, NEUTER, PLURAL)

	unarmed_types = list(/datum/unarmed_attack/slime_glomp)

	has_organ =     list(O_BRAIN = /obj/item/organ/internal/brain/slime,
						O_HEART = /obj/item/organ/internal/heart/grey/colormatch/slime,
						O_REGBRUTE = /obj/item/organ/internal/regennetwork,
						O_REGBURN = /obj/item/organ/internal/regennetwork/burn,
						O_REGOXY = /obj/item/organ/internal/regennetwork/oxy,
						O_REGTOX = /obj/item/organ/internal/regennetwork/tox)

	dispersed_eyes = TRUE

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/unbreakable/slime),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/slime),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/slime),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/slime),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/slime),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/slime),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/slime),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/slime),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/slime),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/slime),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/slime)
		)
	heat_discomfort_strings = list("You feel too warm.")
	cold_discomfort_strings = list("You feel too cool.")

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/regenerate
		)

	valid_transform_species = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_TESHARI, SPECIES_MONKEY)

	var/heal_rate = 0.5 // Temp. Regen per tick.

	default_emotes = list(
		/decl/emote/audible/squish,
		/decl/emote/audible/chirp,
		/decl/emote/visible/bounce,
		/decl/emote/visible/jiggle,
		/decl/emote/visible/lightup,
		/decl/emote/visible/vibrate
	)

/datum/species/shapeshifter/promethean/New()
	..()
	prometheans = src

/datum/species/shapeshifter/promethean/equip_survival_gear(var/mob/living/carbon/human/H)
	var/boxtype = pick(list(/obj/item/weapon/storage/toolbox/lunchbox,
							/obj/item/weapon/storage/toolbox/lunchbox/heart,
							/obj/item/weapon/storage/toolbox/lunchbox/cat,
							/obj/item/weapon/storage/toolbox/lunchbox/nt,
							/obj/item/weapon/storage/toolbox/lunchbox/mars,
							/obj/item/weapon/storage/toolbox/lunchbox/cti,
							/obj/item/weapon/storage/toolbox/lunchbox/nymph,
							/obj/item/weapon/storage/toolbox/lunchbox/syndicate))	//Only pick the empty types
	var/obj/item/weapon/storage/toolbox/lunchbox/L = new boxtype(get_turf(H))
	new /obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar(L)
	new /obj/item/weapon/tool/prybar/red(L) //VOREStation Add,
	if(H.backbag == 1)
		H.equip_to_slot_or_del(L, slot_r_hand)
	else
		H.equip_to_slot_or_del(L, slot_in_backpack)

/datum/species/shapeshifter/promethean/hug(var/mob/living/carbon/human/H, var/mob/living/target)
	var/static/list/parent_handles = list("head", "r_hand", "l_hand", "mouth")

	if(H.zone_sel.selecting in parent_handles)
		return ..()

	var/t_him = "them"
	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		switch(T.identifying_gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
	else
		switch(target.gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"

	H.visible_message("<b>\The [H]</b> glomps [target] to make [t_him] feel better!", \
					"<span class='notice'>You glomp [target] to make [t_him] feel better!</span>")
	H.apply_stored_shock_to(target)

/datum/species/shapeshifter/promethean/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()

/datum/species/shapeshifter/promethean/handle_environment_special(var/mob/living/carbon/human/H)
	var/healing = TRUE	// Switches to FALSE if healing is not possible at all.
	var/regen_brute = TRUE
	var/regen_burn = TRUE
	var/regen_tox = TRUE
	var/regen_oxy = TRUE
	// VOREStation Removal Start
	/*
	if(H.fire_stacks < 0 && H.get_water_protection() <= 0.5)	// If over half your body is soaked, you're melting.
		H.adjustToxLoss(max(0,(3 - (3 * H.get_water_protection())) * heal_rate))	// Tripled because 0.5 is miniscule, and fire_stacks are capped in both directions.
		healing = FALSE
	*/
	//VOREStation Removal End

	//Prometheans automatically clean every surface they're in contact with every life tick - this includes the floor without shoes.
	//They gain nutrition from doing this.
	var/turf/T = get_turf(H)
	if(istype(T))
		if(!(H.shoes || (H.wear_suit && (H.wear_suit.body_parts_covered & FEET))))
			for(var/obj/O in T)
				if(O.clean_blood())
					H.adjust_nutrition(rand(5, 15))
			if (istype(T, /turf/simulated))
				var/turf/simulated/S = T
				if(T.clean_blood())
					H.adjust_nutrition(rand(10, 20))
				if(S.dirt > 50)
					S.dirt = 0
					H.adjust_nutrition(rand(10, 20))
		if(H.feet_blood_color || LAZYLEN(H.feet_blood_DNA))
			LAZYCLEARLIST(H.feet_blood_DNA)
			H.feet_blood_DNA = null
			H.feet_blood_color = null
			H.adjust_nutrition(rand(3, 10))
		if(H.bloody_hands)
			LAZYCLEARLIST(H.blood_DNA)
			H.blood_DNA = null
			H.hand_blood_color = null
			H.bloody_hands = 0
			H.adjust_nutrition(rand(3, 10))
		if(!(H.gloves || (H.wear_suit && (H.wear_suit.body_parts_covered & HANDS))))
			if(H.r_hand)
				if(H.r_hand.clean_blood())
					H.adjust_nutrition(rand(5, 15))
			if(H.l_hand)
				if(H.l_hand.clean_blood())
					H.adjust_nutrition(rand(5, 15))
/*
		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head(0)
				H.adjust_nutrition(rand(5, 15))
		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit(0)
				H.adjust_nutrition(rand(5, 15))
		if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform(0)
				H.adjust_nutrition(rand(5, 15))
*/
		// Prometheans themselves aren't very safe places for other biota.
		H.germ_level = 0
		H.update_bloodied()
		//End cleaning code.

		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment.return_pressure()
		var/affecting_pressure = H.calculate_affecting_pressure(pressure)
		if(affecting_pressure <= hazard_low_pressure) // Dangerous low pressure stops the regeneration of physical wounds. Body is focusing on keeping them intact rather than sealing.
			regen_brute = FALSE
			regen_burn = FALSE

	if(world.time < H.l_move_time + 1 MINUTE)	// Need to stay still for a minute, before passive healing will activate.
		healing = FALSE

	if(H.bodytemperature > heat_level_1 || H.bodytemperature < cold_level_1)	// If you're too hot or cold, you can't heal.
		healing = FALSE

	// Heal remaining damage.
	if(healing)
		if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
			var/nutrition_cost = 0		// The total amount of nutrition drained every tick, when healing
			var/nutrition_debt = 0		// Holder variable used to store previous damage values prior to healing for use in the nutrition_cost equation.
			var/starve_mod = 1			// Lowering this lowers healing and increases agony multiplicatively.

			var/strain_negation = 0		// How much agony is being prevented by the

			if(H.nutrition <= 150)		// This is when the icon goes red
				starve_mod = 0.75
				if(H.nutrition <= 50)	// Severe starvation. Damage repaired beyond this point will cause a stunlock if untreated.
					starve_mod = 0.5

			var/to_pay = 0
			if(regen_brute)
				nutrition_debt = H.getBruteLoss()
				H.adjustBruteLoss(-heal_rate * starve_mod)

				to_pay = nutrition_debt - H.getBruteLoss()

				nutrition_cost += to_pay

				var/obj/item/organ/internal/regennetwork/BrReg = H.internal_organs_by_name[O_REGBRUTE]

				if(BrReg)
					strain_negation += to_pay * max(0, (1 - BrReg.get_strain_percent()))

			if(regen_burn)
				nutrition_debt = H.getFireLoss()
				H.adjustFireLoss(-heal_rate * starve_mod)

				to_pay = nutrition_debt - H.getFireLoss()

				nutrition_cost += to_pay

				var/obj/item/organ/internal/regennetwork/BuReg = H.internal_organs_by_name[O_REGBURN]

				if(BuReg)
					strain_negation += to_pay * max(0, (1 - BuReg.get_strain_percent()))

			if(regen_oxy)
				nutrition_debt = H.getOxyLoss()
				H.adjustOxyLoss(-heal_rate * starve_mod)

				to_pay = nutrition_debt - H.getOxyLoss()

				nutrition_cost += to_pay

				var/obj/item/organ/internal/regennetwork/OxReg = H.internal_organs_by_name[O_REGOXY]

				if(OxReg)
					strain_negation += to_pay * max(0, (1 - OxReg.get_strain_percent()))

			if(regen_tox)
				nutrition_debt = H.getToxLoss()
				H.adjustToxLoss(-heal_rate * starve_mod)

				to_pay = nutrition_debt - H.getToxLoss()

				nutrition_cost += to_pay

				var/obj/item/organ/internal/regennetwork/ToxReg = H.internal_organs_by_name[O_REGTOX]

				if(ToxReg)
					strain_negation += to_pay * max(0, (1 - ToxReg.get_strain_percent()))

			H.adjust_nutrition(-(3 * nutrition_cost)) // Costs Nutrition when damage is being repaired, corresponding to the amount of damage being repaired.

			var/agony_to_apply = ((1 / starve_mod) * (nutrition_cost - strain_negation)) //Regenerating damage causes minor pain over time, if the organs responsible are nonexistant or too high on strain. Small injures will be no issue, large ones will cause problems.

			if((starve_mod <= 0.5 && (H.getHalLoss() + agony_to_apply) <= 90) || ((H.getHalLoss() + agony_to_apply) <= 70))	// Will max out at applying halloss at 70, unless they are starving; starvation regeneration will bring them up to a maximum of 120, the same amount of agony a human receives from three taser hits.
				H.apply_damage(agony_to_apply, HALLOSS)

/datum/species/shapeshifter/promethean/get_blood_colour(var/mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/shapeshifter/promethean/get_flesh_colour(var/mob/living/carbon/human/H)
	return (H ? rgb(H.r_skin, H.g_skin, H.b_skin) : ..())

/datum/species/shapeshifter/promethean/get_additional_examine_text(var/mob/living/carbon/human/H)

	if(!stored_shock_by_ref["\ref[H]"])
		return

	var/t_she = "She is"
	if(H.identifying_gender == MALE)
		t_she = "He is"
	else if(H.identifying_gender == PLURAL)
		t_she = "They are"
	else if(H.identifying_gender == NEUTER)
		t_she = "It is"
	else if(H.identifying_gender == HERM) //VOREStation Edit
		t_she = "Shi is"

	switch(stored_shock_by_ref["\ref[H]"])
		if(1 to 10)
			return "[t_she] flickering gently with a little electrical activity."
		if(11 to 20)
			return "[t_she] glowing gently with moderate levels of electrical activity.\n"
		if(21 to 35)
			return "<span class='warning'>[t_she] glowing brightly with high levels of electrical activity.</span>"
		if(35 to INFINITY)
			return "<span class='danger'>[t_she] radiating massive levels of electrical activity!</span>"
