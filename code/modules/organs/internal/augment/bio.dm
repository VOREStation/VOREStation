// The base organic-targeting augment.

/obj/item/organ/internal/augment/bioaugment
	name = "bioaugmenting implant"

	icon_state = "augment_hybrid"
	dead_icon = "augment_hybrid_dead"

	robotic = ORGAN_ASSISTED
	target_parent_classes = list(ORGAN_FLESH)

/* Jensen Shades. Your vision can be augmented.
 * This, technically, no longer needs its unique organ verb, however I have chosen to leave it for posterity
 * in the event it needs to be referenced, while still remaining perfectly functional with either system.
 */

/obj/item/organ/internal/augment/bioaugment/thermalshades
	name = "integrated thermolensing implant"
	desc = "A miniscule implant that houses a pair of thermolensed sunglasses. Don't ask how they deploy, you don't want to know."
	icon_state = "augment_shades"
	dead_icon = "augment_shades_dead"

	w_class = ITEMSIZE_TINY

	organ_tag = O_AUG_EYES

	robotic = ORGAN_ROBOT

	parent_organ = BP_HEAD

	organ_verbs = list(
		/mob/living/carbon/human/proc/augment_menu,
		/mob/living/carbon/human/proc/toggle_shades)

	integrated_object_type = /obj/item/clothing/glasses/hud/security/jensenshades

/obj/item/organ/internal/augment/bioaugment/thermalshades/augment_action()
	if(!owner)
		return

	owner.toggle_shades()

// Here for posterity and example.
/mob/living/carbon/human/proc/toggle_shades()
	set name = "Toggle Integrated Thermoshades"
	set desc = "Toggle your flash-proof, thermal-integrated sunglasses."
	set category = "Augments"

	var/obj/item/organ/internal/augment/aug = internal_organs_by_name[O_AUG_EYES]

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

/obj/item/organ/internal/augment/bioaugment/sprint_enhance
	name = "locomotive optimization implant"
	desc = "A chunk of meat and metal that can manage an individual's leg musculature."

	organ_tag = O_AUG_PELVIC

	parent_organ = BP_GROIN

	target_parent_classes = list(ORGAN_FLESH, ORGAN_ASSISTED)

	aug_cooldown = 2 MINUTES

/obj/item/organ/internal/augment/bioaugment/sprint_enhance/augment_action()
	if(!owner)
		return

	if(aug_cooldown)
		if(cooldown <= world.time)
			cooldown = world.time + aug_cooldown
		else
			return

	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		H.add_modifier(/datum/modifier/sprinting, 1 MINUTES)

