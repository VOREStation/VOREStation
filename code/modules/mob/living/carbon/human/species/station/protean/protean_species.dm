#define METAL_PER_TICK SHEET_MATERIAL_AMOUNT/20
/datum/species/protean
	name =             SPECIES_PROTEAN
	name_plural =      "Proteans"
	blurb =            "Sometimes very advanced civilizations will produce the ability to swap into manufactured, robotic bodies. And sometimes \
						" + span_italics("VERY") + " advanced civilizations have the option of 'nanoswarm' bodies. Effectively a single robot body comprised \
						of millions of tiny nanites working in concert to maintain cohesion."
	show_ssd =         "totally quiescent"
	death_message =    "rapidly loses cohesion, retreating into their hardened control module..."
	knockout_message = "collapses inwards, forming a disordered puddle of gray goo."
	remains_type = /obj/effect/decal/cleanable/ash

	selects_bodytype = SELECTS_BODYTYPE_SHAPESHIFTER
	base_species = SPECIES_HUMAN
	digi_allowed = TRUE

	blood_color = "#505050" //This is the same as the 80,80,80 below, but in hex
	flesh_color = "#505050"
	base_color = "#FFFFFF" //Color mult, start out with this

	flags =            NO_DNA | NO_SLEEVE | NO_SLIP | NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT | NO_PAIN
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_LIPS
	spawn_flags		 = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE
	health_hud_intensity = 2
	num_alternate_languages = 3
	species_language = LANGUAGE_EAL
	assisted_langs = list(LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX)
	speech_bubble_appearance = "synthetic"
	color_mult = TRUE

	breath_type = null
	poison_type = null

	// male_scream_sound = null
	// female_scream_sound = null

	virus_immune = 1
	blood_volume = 0
	min_age = 18
	max_age = 200
	oxy_mod = 0
	//radiation_mod = 0	//Can't be assed with fandangling rad protections while blob formed/suited
	siemens_coefficient = 2
	brute_mod =        0.8
	burn_mod =        1.5
	emp_dmg_mod = 0.8
	emp_sensitivity = EMP_BLIND | EMP_DEAFEN | EMP_BRUTE_DMG | EMP_BURN_DMG
	item_slowdown_mod = 1.5	//Gentle encouragement to let others wear you

	hazard_low_pressure = -1 //Space doesn't bother them

	cold_level_1 = -INFINITY
	cold_level_2 = -INFINITY
	cold_level_3 = -INFINITY
	heat_level_1 = 420
	heat_level_2 = 480
	heat_level_3 = 1100

	body_temperature = 290

	rarity_value = 5

	// species_sounds = "Robotic"

	// crit_mod = 4	//Unable to go crit
	var/obj/item/rig/protean/OurRig

	genders = list(MALE, FEMALE, PLURAL, NEUTER)

	has_organ = list(
		O_BRAIN = /obj/item/organ/internal/mmi_holder/posibrain/nano,
		O_ORCH = /obj/item/organ/internal/nano/orchestrator,
		O_FACT = /obj/item/organ/internal/nano/refactory,
		)
	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest/unbreakable/nano),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/nano),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/nano),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/nano),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/nano),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/nano),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/nano),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/nano),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/nano),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/nano),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/nano)
		)

	heat_discomfort_strings = list("WARNING: Temperature exceeding acceptable thresholds!.")
	cold_discomfort_strings = list("You feel too cool.")

	//These verbs are hidden, for hotkey use only
	inherent_verbs = list(
		/mob/living/carbon/human/proc/nano_regenerate, //These verbs are hidden so you can macro them,
		/mob/living/carbon/human/proc/nano_partswap,
		/mob/living/carbon/human/proc/nano_metalnom,
		/mob/living/carbon/human/proc/nano_blobform,
		/mob/living/carbon/human/proc/nano_rig_transform,
		/mob/living/carbon/human/proc/nano_copy_body,
		/mob/living/carbon/human/proc/appearance_switch,
		/mob/living/carbon/human/proc/nano_latch,
		/mob/living/carbon/human/proc/nano_assimilate,
		/mob/living/proc/set_size,
		/mob/living/carbon/human/proc/nano_change_fitting, //These verbs are displayed normally,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_secondary_ears,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/flying_vore_toggle,
		/mob/living/proc/start_wings_hovering,
		) //removed fetish verbs, since non-customs can pick neutral traits now. Also added flight, cause shapeshifter can grow wings.

	var/global/list/abilities = list()

	var/blob_appearance = "puddle1"
	var/blob_color_1 = "#363636"
	var/blob_color_2 = "#ba3636"
	var/list/dragon_overlays = list(
		"dragon_underSmooth" = "#FFFFFF",
		"dragon_bodySmooth" = "#FFFFFF",
		"dragon_earsNormal" = "#FFFFFF",
		"dragon_maneShaggy" = "#FFFFFF",
		"dragon_hornsPointy" = "#FFFFFF",
		"dragon_eyesNormal" = "#FFFFFF"
	)

	var/list/dullahan_overlays = list(
		"dullahanbody" = "#FFFFFF",
		"dullahanhead" = "#FFFFFF",
		"dullahanmetal" = "#FFFFFF",
		"dullahaneyes" = "#FFFFFF",
		"dullahandecals" = "#FFFFFF",
		"dullahanextended" = "#FFFFFF"
		// loads the icons from the DMI file in that order on spawn. they are overlay 1-6.
	)
	var/pseudodead = 0

/datum/species/protean/New()
	..()
	if(!LAZYLEN(abilities))
		var/list/powertypes = subtypesof(/obj/effect/protean_ability)
		for(var/path in powertypes)
			abilities += new path()

/datum/species/protean/create_organs(var/mob/living/carbon/human/H)
	var/obj/item/nif/saved_nif = H.nif
	if(saved_nif)
		H.nif.unimplant(H) //Needs reference to owner to unimplant right.
		H.nif.moveToNullspace()
	..()
	if(saved_nif)
		saved_nif.quick_implant(H)

/datum/species/protean/get_race_key()
	var/datum/species/real = GLOB.all_species[base_species]
	return real.race_key

/datum/species/protean/get_bodytype(var/mob/living/carbon/human/H)
	if(!H || base_species == name) return ..()
	var/datum/species/S = GLOB.all_species[base_species]
	return S.get_bodytype(H)

/datum/species/protean/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	if(!H || base_species == name) return ..(null, get_deform)
	var/datum/species/S = GLOB.all_species[base_species]
	return S.get_icobase(H, get_deform)

/datum/species/protean/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	var/list/protean_shapeshifting_forms = GLOB.playable_species.Copy() - SPECIES_PROMETHEAN //Removing the 'static' here fixes it returning an empty list. I do not know WHY that is the case, but it is for some reason. This needs to be investigated further, but this fixes the issue at the moment.
	return protean_shapeshifting_forms

/datum/species/protean/get_tail(var/mob/living/carbon/human/H)
	if(!H || base_species == name) return ..()
	var/datum/species/S = GLOB.all_species[base_species]
	return S.get_tail(H)

/datum/species/protean/get_tail_animation(var/mob/living/carbon/human/H)
	if(!H || base_species == name) return ..()
	var/datum/species/S = GLOB.all_species[base_species]
	return S.get_tail_animation(H)

/datum/species/protean/get_tail_hair(var/mob/living/carbon/human/H)
	if(!H || base_species == name) return ..()
	var/datum/species/S = GLOB.all_species[base_species]
	return S.get_tail_hair(H)

/datum/species/protean/get_blood_mask(var/mob/living/carbon/human/H)
	if(!H || base_species == name) return ..()
	var/datum/species/S = GLOB.all_species[base_species]
	return S.get_blood_mask(H)

/datum/species/protean/get_damage_mask(var/mob/living/carbon/human/H)
	if(!H || base_species == name) return ..()
	var/datum/species/S = GLOB.all_species[base_species]
	return S.get_damage_mask(H)

/datum/species/protean/get_damage_overlays(var/mob/living/carbon/human/H)
	if(!H || base_species == name) return ..()
	var/datum/species/S = GLOB.all_species[base_species]
	return S.get_damage_overlays(H)

/datum/species/protean/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.synth_color = TRUE

/datum/species/protean/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	var/obj/item/stack/material/steel/metal_stack = new()
	metal_stack.set_amount(5)

	var/obj/item/clothing/accessory/permit/nanotech/permit = new()
	permit.set_name(H.real_name)

	if(H.backbag == 1) //Somewhat misleading, 1 == no bag (not boolean)
		H.equip_to_slot_or_del(permit, slot_l_hand)
		H.equip_to_slot_or_del(metal_stack, slot_r_hand)
	else
		H.equip_to_slot_or_del(permit, slot_in_backpack)
		H.equip_to_slot_or_del(metal_stack, slot_in_backpack)

	spawn(0) //Let their real nif load if they have one
		if(!H) //Human could have been deleted in this amount of time. Observing does this, mannequins, etc.
			return
		if(!H.nif)
			var/obj/item/nif/protean/new_nif = new()
			new_nif.quick_implant(H)
		else
			H.nif.durability = 25

		new /obj/item/rig/protean(H,H)

/datum/species/protean/hug(var/mob/living/carbon/human/H, var/mob/living/target)
	return ..() //Wut

/datum/species/protean/get_blood_colour(var/mob/living/carbon/human/H)
	return rgb(80,80,80,230)

/datum/species/protean/get_flesh_colour(var/mob/living/carbon/human/H)
	return rgb(80,80,80,230)

/datum/species/protean/handle_death(var/mob/living/carbon/human/H)
	if(!H)
		return //No body?
	if(OurRig)
		if(OurRig.dead)
			return
		OurRig.dead = 1
	var/mob/temp = H
	if(H.temporary_form)
		temp = H.temporary_form
	playsound(temp, 'sound/voice/borg_deathsound.ogg', 50, 1)
	temp.visible_message(span_bold("[temp.name]") + " shudders and retreats inwards, coalescing into a single core componant!")
	to_chat(temp, span_warning("You've died as a Protean! While dead, you will be locked to your core RIG control module until you can be repaired. Instructions to your revival can be found in the Examine tab when examining your module."))
	if(OurRig)
		if(H.temporary_form)
			if(!istype(H.temporary_form.loc, /obj/item/rig/protean))
				H.nano_rig_transform(1)
		else
			H.nano_rig_transform(1)
	pseudodead = 1

/datum/species/protean/handle_environment_special(var/mob/living/carbon/human/H)
	if((H.getActualBruteLoss() + H.getActualFireLoss()) > H.maxHealth*0.5 && isturf(H.loc)) //So, only if we're not a blob (we're in nullspace) or in someone (or a locker, really, but whatever)
		return ..() //Any instakill shot runtimes since there are no organs after this. No point to not skip these checks, going to nullspace anyway.

	var/obj/item/organ/internal/nano/refactory/refactory = locate() in H.internal_organs
	if(refactory && !(refactory.status & ORGAN_DEAD))

		//MHydrogen adds speeeeeed
		if(refactory.get_stored_material(MAT_METALHYDROGEN) >= METAL_PER_TICK)
			H.add_modifier(/datum/modifier/protean/mhydrogen, origin = refactory)

		//Uranium adds brute armor
		if(refactory.get_stored_material(MAT_URANIUM) >= METAL_PER_TICK)
			H.add_modifier(/datum/modifier/protean/uranium, origin = refactory)

		//Gold adds burn armor
		if(refactory.get_stored_material(MAT_GOLD) >= METAL_PER_TICK)
			H.add_modifier(/datum/modifier/protean/gold, origin = refactory)

		//Silver adds accuracy and evasion
		if(refactory.get_stored_material(MAT_SILVER) >= METAL_PER_TICK)
			H.add_modifier(/datum/modifier/protean/silver, origin = refactory)

	return ..()

/datum/species/protean/get_additional_examine_text(var/mob/living/carbon/human/H)
	return ..() //Hmm, what could be done here?

/datum/species/protean/update_misc_tabs(var/mob/living/carbon/human/H)
	..()
	var/list/L = list()
	var/obj/item/organ/internal/nano/refactory/refactory = H.nano_get_refactory()
	if(refactory && !(refactory.status & ORGAN_DEAD))
		L[++L.len] = list("- -- --- Refactory Metal Storage --- -- -", null, null, null, null)
		var/max = refactory.max_storage
		for(var/material in refactory.materials)
			var/amount = refactory.get_stored_material(material)
			L[++L.len] = list("[capitalize(material)]: [amount]/[max]", null, null, null, null)
	else
		L[++L.len] = list("- -- --- REFACTORY ERROR! --- -- -", null, null, null, null)

	L[++L.len] = list("- -- --- Abilities (Shift+LMB Examines) --- -- -", null, null, null, null)
	for(var/obj/effect/protean_ability/A as anything in abilities)
		var/client/C = H.client
		var/img
		if(C && istype(C)) //sanity checks
			if(A.ability_name in C.misc_cache)
				img = C.misc_cache[A.ability_name]
			else
				img = icon2html(A,C,sourceonly=TRUE)
				C.misc_cache[A.ability_name] = img

		L[++L.len] = list("[A.ability_name]", A.ability_name, img, A.atom_button_text(), REF(A))
	H.misc_tabs["Protean"] = L

// Various modifiers
/datum/modifier/protean
	stacks = MODIFIER_STACK_FORBID
	var/material_use = METAL_PER_TICK
	var/material_name = MAT_STEEL

/datum/modifier/protean/on_applied()
	. = ..()
	if(holder.temporary_form)
		to_chat(holder.temporary_form,on_created_text)

/datum/modifier/protean/on_expire()
	. = ..()
	if(holder.temporary_form)
		to_chat(holder.temporary_form,on_expired_text)

/datum/modifier/protean/check_if_valid()
	//No origin set
	if(!istype(origin))
		expire()

	//No refactory
	var/obj/item/organ/internal/nano/refactory/refactory = origin.resolve()
	if(!istype(refactory) || refactory.status & ORGAN_DEAD)
		expire()

	//Out of materials
	if(!refactory.use_stored_material(material_name,material_use))
		expire()

/datum/modifier/protean/mhydrogen
	name = "Protean Effect - M.Hydrogen"
	desc = "You're affected by the presence of metallic hydrogen."

	on_created_text = span_notice("You feel yourself accelerate, the metallic hydrogen increasing your speed temporarily.")
	on_expired_text = span_notice("Your refactory finishes consuming the metallic hydrogen, and you return to normal speed.")

	material_name = MAT_METALHYDROGEN

	slowdown = -1

/datum/modifier/protean/uranium
	name = "Protean Effect - Uranium"
	desc = "You're affected by the presence of uranium."

	on_created_text = span_notice("You feel yourself become nearly impervious to physical attacks as uranium is incorporated in your nanites.")
	on_expired_text = span_notice("Your refactory finishes consuming the uranium, and you return to your normal nanites.")

	material_name = MAT_URANIUM

	incoming_brute_damage_percent = 0.8

/datum/modifier/protean/gold
	name = "Protean Effect - Gold"
	desc = "You're affected by the presence of gold."

	on_created_text = span_notice("You feel yourself become more reflective, able to resist heat and fire better for a time.")
	on_expired_text = span_notice("Your refactory finishes consuming the gold, and you return to your normal nanites.")

	material_name = MAT_GOLD

	incoming_fire_damage_percent = 0.8

/datum/modifier/protean/silver
	name = "Protean Effect - Silver"
	desc = "You're affected by the presence of silver."

	on_created_text = span_notice("Your physical control is improved for a time, making it easier to hit targets, and avoid being hit.")
	on_expired_text = span_notice("Your refactory finishes consuming the silver, and your motor control returns to normal.")

	material_name = MAT_SILVER

	accuracy = 30
	evasion = 30

/datum/modifier/protean/steel
	name = "Protean Effect - Steel"
	desc = "You're affected by the presence of steel."

	on_created_text = span_notice("You feel new nanites being produced from your stockpile of steel, healing you slowly.")
	on_expired_text = span_notice("Your steel supply has either run out, or is no longer needed, and your healing stops.")

	material_name = MAT_STEEL

/datum/modifier/protean/steel/tick()
	//Heal a random damaged limb by 1,1 per tick
	holder.adjustBruteLoss(-1,include_robo = TRUE)
	holder.adjustFireLoss(-1,include_robo = TRUE)
	holder.adjustToxLoss(-1)

	var/mob/living/carbon/human/H
	if(ishuman(holder))
		H = holder

	//Then heal every damaged limb by a smaller amount
	if(H)
		for(var/obj/item/organ/external/O in H.organs)
			O.heal_damage(0.5, 0.5, 0, 1)

		//Heal the organs a little bit too, as a treat
		for(var/obj/item/organ/O as anything in H.internal_organs)
			if(O.damage > 0)
				O.damage = max(0,O.damage-0.3)
			else if(O.status & ORGAN_DEAD)
				O.status &= ~ORGAN_DEAD //Unset dead if we repaired it entirely

// PAN Card
/obj/item/clothing/accessory/permit/nanotech
	name = "\improper P.A.N. card"
	desc = "This is a 'Permit for Advanced Nanotechnology' card. It allows the owner to possess and operate advanced nanotechnology on NanoTrasen property. It must be renewed on a monthly basis."
	icon = 'icons/mob/species/protean/protean.dmi'
	icon_state = "permit_pan"

	var/validstring = "VALID THROUGH END OF: "
	var/registring = "REGISTRANT: "

/obj/item/clothing/accessory/permit/nanotech/set_name(var/new_name)
	owner = 1
	if(new_name)
		name += " ([new_name])"
		validstring += "[time2text(world.timeofday, "Month") +" "+ num2text(text2num(time2text(world.timeofday, "YYYY"))+300)]"
		registring += "[new_name]"

/obj/item/clothing/accessory/permit/nanotech/examine(mob/user)
	. = ..()
	. += validstring
	. += registring
#undef METAL_PER_TICK
