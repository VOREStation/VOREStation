/*
 * Augments. This file contains the base, and organic-targeting augments.
 */

/obj/item/organ/internal/augment
	name = "augment"

	icon_state = "cell_bay"

	parent_organ = BP_TORSO

	organ_verbs = list()	// Verbs added by the organ when present in the body.
	target_parent_classes = list()	// Is the parent supposed to be organic, robotic, assisted?
	forgiving_class = FALSE	// Will the organ give its verbs when it isn't a perfect match? I.E., assisted in organic, synthetic in organic.

	var/obj/item/integrated_object	// Objects held by the organ, used for deployable things.
	var/integrated_object_type	// Object type the organ will spawn.

/obj/item/organ/internal/augment/Initialize()
	..()
	if(integrated_object_type)
		integrated_object = new integrated_object_type(src)
		integrated_object.canremove = FALSE

/obj/item/organ/internal/augment/handle_organ_mod_special(var/removed = FALSE)
	if(removed && integrated_object && integrated_object.loc != src)
		if(isliving(integrated_object.loc))
			var/mob/living/L = integrated_object.loc
			L.drop_from_inventory(integrated_object)
		integrated_object.forceMove(src)
	..(removed)

// The base organic-targeting augment.

/obj/item/organ/internal/augment/bioaugment
	name = "bioaugmenting implant"

	robotic = ORGAN_ROBOT
	target_parent_classes = list(ORGAN_FLESH)

// Jensen Shades. Your vision can be augmented.

/obj/item/organ/internal/augment/bioaugment/thermalshades
	name = "integrated thermolensing implant"
	desc = "A miniscule implant that houses a pair of thermolensed sunglasses. Don't ask how they deploy, you don't want to know."
	icon_state = "augment_shades"
	dead_icon = "augment_shades_dead"

	w_class = ITEMSIZE_TINY

	organ_tag = O_AUG_TSHADE

	parent_organ = BP_HEAD

	organ_verbs = list(/mob/living/carbon/human/proc/toggle_shades)

	integrated_object_type = /obj/item/clothing/glasses/hud/security/jensenshades

/mob/living/carbon/human/proc/toggle_shades()
	set name = "Toggle Integrated Thermoshades"
	set desc = "Toggle your flash-proof, thermal-integrated sunglasses."
	set category = "Augments"

	var/obj/item/organ/internal/augment/aug = internal_organs_by_name[O_AUG_TSHADE]

	if(glasses)
		if(aug && aug.integrated_object == glasses)
			drop_from_inventory(glasses)
			aug.integrated_object.forceMove(aug)
			if(!glasses)
				to_chat(src, "<span class='alien'>Your [aug.integrated_object] retract into your skull.</span>")
		else if(!istype(glasses, /obj/item/clothing/glasses/hud/security/jensenshades))
			to_chat(src, "<span class='notice'>\The [glasses] block your shades from deploying.</span>")
		else if(istype(glasses, /obj/item/clothing/glasses/hud/security/jensenshades))
			var/obj/item/G = glasses
			if(G.canremove)
				to_chat(src, "<span class='notice'>\The [G] are not your integrated shades.</span>")
			else
				drop_from_inventory(G)
				to_chat(src, "<span class='notice'>\The [G] retract into your skull.</span>")
				qdel(G)

	else
		if(aug && aug.integrated_object)
			to_chat(src, "<span class='alien'>Your [aug.integrated_object] deploy.</span>")
			equip_to_slot(aug.integrated_object, slot_glasses, 0, 1)
			if(!glasses || glasses != aug.integrated_object)
				aug.integrated_object.forceMove(aug)
		else
			var/obj/item/clothing/glasses/hud/security/jensenshades/J = new(get_turf(src))
			equip_to_slot(J, slot_glasses, 1, 1)
			to_chat(src, "<span class='notice'>Your [aug.integrated_object] deploy.</span>")
