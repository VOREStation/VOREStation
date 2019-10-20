/obj/item/organ/external/chest/unathi
	max_damage = 100
	min_broken_damage = 40
	encased = "upper ribplates"

/obj/item/organ/external/groin/unathi
	max_damage = 100
	min_broken_damage = 40
	encased = "lower ribplates"

/obj/item/organ/external/head/unathi
	max_damage = 75
	min_broken_damage = 35
	eye_icon = "eyes_s"
	force = 5
	throwforce = 10


/obj/item/organ/internal/heart/unathi
	icon_state = "unathi_heart-on"
	dead_icon = "unath_heart-off"

/obj/item/organ/internal/lungs/unathi
	color = "#b3cbc3"

/obj/item/organ/internal/liver/unathi
	name = "filtration organ"
	icon_state = "unathi_liver"

//Unathi liver acts as kidneys, too.
/obj/item/organ/internal/liver/unathi/process()
	..()
	if(!owner) return

	var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
		else if(is_broken())
			owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

	var/datum/reagent/sugar = locate(/datum/reagent/sugar) in owner.reagents.reagent_list
	if(sugar)
		if(is_bruised())
			owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
		else if(is_broken())
			owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

/obj/item/organ/internal/brain/unathi
	color = "#b3cbc3"

/obj/item/organ/internal/stomach/unathi
	color = "#b3cbc3"
	max_acid_volume = 40

/obj/item/organ/internal/intestine/unathi
	color = "#b3cbc3"
