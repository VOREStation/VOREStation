/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	var/dead_icon // Icon to use when the organ has died.

	var/supply_conversion_value = 0
	var/healing_factor = 0.005 // How much this organ will heal passively

/obj/item/organ/internal/Initialize(mapload, internal)
	. = ..()
	if(supply_conversion_value)
		AddElement(/datum/element/sellable/organ)

/obj/item/organ/internal/process()
	..()
	passive_heal()

// Heals the internal organ passively as long as it's under the bruised threshold
// Not a lot of MATH just yet, but nutrition or other factors could be taken into account
// Per the original PR: 'Allows internal organs to regenerate themselves passively, as long as they're not bruised.'
/obj/item/organ/internal/proc/passive_heal()
	if(is_bruised() || is_broken())
		return

	var/heal_amt = healing_factor * CONFIG_GET(number/organ_regeneration_multiplier)
	damage = max(damage - heal_amt, 0)

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs.Remove(src)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	return ..()

/obj/item/organ/internal/remove_rejuv()
	if(owner)
		owner.internal_organs -= src
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	..()

/obj/item/organ/internal/robotize()
	..()
	name = "prosthetic [initial(name)]"
	icon_state = "[initial(icon_state)]_prosthetic"
	if(dead_icon)
		dead_icon = "[initial(dead_icon)]_prosthetic"

/obj/item/organ/internal/mechassist()
	..()
	name = "assisted [initial(name)]"
	icon_state = "[initial(icon_state)]_assisted"
	if(dead_icon)
		dead_icon = "[initial(dead_icon)]_assisted"

// Brain is defined in brain.dm
/obj/item/organ/internal/handle_germ_effects()
	. = ..() //Should be an interger value for infection level
	if(!.) return

	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]

	if(. >= 2 && antibiotics < ANTIBIO_NORM) //INFECTION_LEVEL_TWO
		if (prob(3))
			take_damage(1,silent=prob(30))

	if(. >= 3 && antibiotics < ANTIBIO_OD)	//INFECTION_LEVEL_THREE
		if (prob(50))
			take_damage(1,silent=prob(15))
