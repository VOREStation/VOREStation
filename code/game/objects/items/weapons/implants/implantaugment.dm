//////////////////////////////
//	Nanite Organ Implant
//////////////////////////////
/obj/item/implant/organ
	name = "nanite fabrication implant"
	desc = "A buzzing implant covered in a writhing layer of metal insects."
	icon_state = "implant_evil"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ILLEGAL = 2)

	var/organ_to_implant = /obj/item/organ/internal/augment/bioaugment/thermalshades
	var/organ_display_name = "unknown organ"

/obj/item/implant/organ/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> \"GreyDoctor\" Class Nanite Hive<BR>
<b>Life:</b> Activates upon implantation, destroying itself in the process.<BR>
<b>Important Notes:</b> Nanites will fail to complete their task if a suitable location cannot be found for the organ.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Nanites will fabricate: <span class='alien'>[organ_display_name]</span><BR>
<b>Special Features:</b> Organ identification protocols.<BR>
<b>Integrity:</b> N/A"}
	return dat

/obj/item/implant/organ/post_implant(var/mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/obj/item/organ/NewOrgan = new organ_to_implant()

		var/obj/item/organ/external/E = H.get_organ(NewOrgan.parent_organ)
		to_chat(H, span_notice("You feel a tingling sensation in your [part]."))
		if(E && !(H.internal_organs_by_name[NewOrgan.organ_tag]))
			spawn(rand(1 SECONDS, 30 SECONDS))
				to_chat(H, span_alien("You feel a pressure in your [E] as the tingling fades, the lump caused by the implant now gone."))

			NewOrgan.forceMove(H)
			NewOrgan.owner = H
			if(E.internal_organs == null)
				E.internal_organs = list()
			E.internal_organs |= NewOrgan
			H.internal_organs_by_name[NewOrgan.organ_tag] = NewOrgan
			H.internal_organs |= NewOrgan
			NewOrgan.handle_organ_mod_special()

			spawn(1)
				if(!QDELETED(src))
					qdel(src)

		else
			qdel(NewOrgan)
			to_chat(H, span_warning("You feel a pinching sensation in your [part]. The implant remains."))

/obj/item/implant/organ/islegal()
	return 0

/*
 * Arm / leg mounted augments.
 */

/obj/item/implant/organ/limbaugment
	name = "nanite implant"

	organ_to_implant = /obj/item/organ/internal/augment/armmounted/taser
	organ_display_name = "physiological augment"

	var/list/possible_targets = list(O_AUG_L_FOREARM, O_AUG_R_FOREARM)

/obj/item/implant/organ/limbaugment/post_implant(var/mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/obj/item/organ/NewOrgan = new organ_to_implant()

		var/obj/item/organ/external/E = setup_augment_slots(H, NewOrgan)
		to_chat(H, span_notice("You feel a tingling sensation in your [part]."))
		NewOrgan.forceMove(H)
		NewOrgan.owner = H
		if(E && istype(E) && !(H.internal_organs_by_name[NewOrgan.organ_tag]) && NewOrgan.check_verb_compatability())
			spawn(rand(1 SECONDS, 30 SECONDS))
				to_chat(H, span_alien("You feel a pressure in your [E] as the tingling fades, the lump caused by the implant now gone."))

			if(E.internal_organs == null)
				E.internal_organs = list()
			E.internal_organs |= NewOrgan
			H.internal_organs_by_name[NewOrgan.organ_tag] = NewOrgan
			H.internal_organs |= NewOrgan
			NewOrgan.handle_organ_mod_special()

			spawn(1)
				if(!QDELETED(src))
					qdel(src)

		else
			qdel(NewOrgan)
			to_chat(H, span_warning("You feel a pinching sensation in your [part]. The implant remains."))

/obj/item/implant/organ/limbaugment/proc/setup_augment_slots(var/mob/living/carbon/human/H, var/obj/item/organ/internal/augment/armmounted/I)
	var/list/Choices = possible_targets.Copy()

	for(var/targ in possible_targets)
		if(H.internal_organs_by_name[targ])
			Choices -= targ

	var/target_choice = null
	if(Choices && Choices.len)
		if(Choices.len == 1)
			target_choice = Choices[1]
		else
			target_choice = tgui_input_list(usr, "Choose augment location:", "Choose Location", Choices)

	else
		return FALSE

	if(target_choice)
		switch(target_choice)
			if(O_AUG_R_HAND)
				I.organ_tag = O_AUG_R_HAND
				I.parent_organ = BP_R_HAND
				I.target_slot = slot_r_hand
			if(O_AUG_L_HAND)
				I.organ_tag = O_AUG_L_HAND
				I.parent_organ = BP_L_HAND
				I.target_slot = slot_l_hand

			if(O_AUG_R_FOREARM)
				I.organ_tag = O_AUG_R_FOREARM
				I.parent_organ = BP_R_ARM
				I.target_slot = slot_r_hand
			if(O_AUG_L_FOREARM)
				I.organ_tag = O_AUG_L_FOREARM
				I.parent_organ = BP_L_ARM
				I.target_slot = slot_l_hand

			if(O_AUG_R_UPPERARM)
				I.organ_tag = O_AUG_R_UPPERARM
				I.parent_organ = BP_R_ARM
				I.target_slot = slot_r_hand
			if(O_AUG_L_UPPERARM)
				I.organ_tag = O_AUG_L_UPPERARM
				I.parent_organ = BP_L_ARM
				I.target_slot = slot_l_hand

		. = H.get_organ(I.parent_organ)

/*
 * Limb implant primary subtypes.
 */

/obj/item/implant/organ/limbaugment/upperarm
	organ_to_implant = /obj/item/organ/internal/augment/armmounted/shoulder/multiple
	organ_display_name = "multi-use augment"

	possible_targets = list(O_AUG_R_UPPERARM,O_AUG_L_UPPERARM)

/obj/item/implant/organ/limbaugment/wrist
	organ_to_implant = /obj/item/organ/internal/augment/armmounted/hand
	organ_display_name = "wrist augment"

	possible_targets = list(O_AUG_R_HAND,O_AUG_L_HAND)

/*
 * Limb implant general subtypes.
 */

// Wrist
/obj/item/implant/organ/limbaugment/wrist/sword
	organ_to_implant = /obj/item/organ/internal/augment/armmounted/hand/sword
	organ_display_name = "weapon augment"

/obj/item/implant/organ/limbaugment/wrist/blade
	organ_to_implant = /obj/item/organ/internal/augment/armmounted/hand/blade
	organ_display_name = "weapon augment"

// Fore-arm
/obj/item/implant/organ/limbaugment/laser
	organ_to_implant = /obj/item/organ/internal/augment/armmounted
	organ_display_name = "weapon augment"

/obj/item/implant/organ/limbaugment/dart
	organ_to_implant = /obj/item/organ/internal/augment/armmounted/dartbow
	organ_display_name = "weapon augment"

// Upper-arm.
/obj/item/implant/organ/limbaugment/upperarm/medkit
	organ_to_implant = /obj/item/organ/internal/augment/armmounted/shoulder/multiple/medical

/obj/item/implant/organ/limbaugment/upperarm/surge
	organ_to_implant = /obj/item/organ/internal/augment/armmounted/shoulder/surge

/obj/item/implant/organ/limbaugment/upperarm/blade
	organ_to_implant = /obj/item/organ/internal/augment/armmounted/shoulder/blade
	organ_display_name = "weapon augment"

/*
 * Others
 */

/obj/item/implant/organ/pelvic
	name = "nanite fabrication implant"

	organ_to_implant = /obj/item/organ/internal/augment/bioaugment/sprint_enhance
	organ_display_name = "pelvic augment"
