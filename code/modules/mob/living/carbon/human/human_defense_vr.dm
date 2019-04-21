/mob/living/carbon/human/proc/check_mouth_coverage_survival()
	var/obj/item/organ/external/H = organs_by_name[BP_HEAD]
	var/list/protective_gear = H.get_covering_clothing(FACE)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_parts_covered & FACE) && !(gear.item_flags & FLEXIBLEMATERIAL) && !(gear.item_flags & ALLOW_SURVIVALFOOD))
			return gear
	return null