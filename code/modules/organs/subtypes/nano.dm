// // // External Organs
/obj/item/organ/external/chest/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 50 // <-- This is different from the rest
	min_broken_damage = 1000
	vital = TRUE // <-- This is different from the rest
/obj/item/organ/external/groin/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 30 // <-- This is different from the rest
	min_broken_damage = 1000 //Multiple
	vital = FALSE
/obj/item/organ/external/head/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000 //Inheritance
	vital = FALSE
/obj/item/organ/external/arm/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000 //Please
	vital = FALSE
/obj/item/organ/external/arm/right/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000
	vital = FALSE
/obj/item/organ/external/leg/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000
	vital = FALSE
/obj/item/organ/external/leg/right/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000
	vital = FALSE
/obj/item/organ/external/hand/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000
	vital = FALSE
/obj/item/organ/external/hand/right/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000
	vital = FALSE
/obj/item/organ/external/foot/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000
	vital = FALSE
/obj/item/organ/external/foot/right/unbreakable/nano
	robotic = ORGAN_NANOFORM
	encased = FALSE
	max_damage = 10
	min_broken_damage = 1000
	vital = FALSE

// // // Internal Organs
/obj/item/organ/internal/nano
	robotic = ORGAN_ROBOT

/obj/item/organ/internal/nano/orchestrator
	name = "orchestrator module"
	desc = "A small computer, designed for highly parallel workloads."
	icon = 'icons/mob/species/protean/protean.dmi'
	icon_state = "orchestrator"
	organ_tag = O_ORCH
	parent_organ = BP_TORSO
	vital = TRUE

/obj/item/organ/internal/nano/refactory
	name = "refactory module"
	desc = "A miniature metal processing unit and nanite factory."
	icon = 'icons/mob/species/protean/protean.dmi'
	icon_state = "refactory"
	organ_tag = O_FACT
	parent_organ = BP_TORSO

	var/list/materials = list(DEFAULT_WALL_MATERIAL = 0)
	var/max_storage = 10000

/obj/item/organ/internal/nano/refactory/proc/get_stored_material(var/material)
	if(status & ORGAN_DEAD)
		return 0
	return materials[material] || 0

/obj/item/organ/internal/nano/refactory/proc/add_stored_material(var/material,var/amt)
	if(status & ORGAN_DEAD)
		return 0
	var/increase = min(amt,max(max_storage-materials[material],0))
	if(isnum(materials[material]))
		materials[material] += increase
	else
		materials[material] = increase

	return increase

/obj/item/organ/internal/nano/refactory/proc/use_stored_material(var/material,var/amt)
	if(status & ORGAN_DEAD)
		return 0
		
	var/available = materials[material]
	
	//Success
	if(available >= amt)
		var/new_amt = available-amt
		if(new_amt == 0)
			materials -= material
		else
			materials[material] = new_amt
		return amt

	//Failure
	return 0

/obj/item/organ/internal/mmi_holder/posibrain/nano
	name = "protean posibrain"
	desc = "A more advanced version of the standard posibrain, typically found in protean bodies."
	icon = 'icons/mob/species/protean/protean.dmi'
	icon_state = "posi"
	parent_organ = BP_TORSO

/obj/item/organ/internal/mmi_holder/posibrain/nano/update_from_mmi()
	..()
	icon = initial(icon)
	icon_state = "posi1"
	
	stored_mmi.brainmob.languages = owner.languages
