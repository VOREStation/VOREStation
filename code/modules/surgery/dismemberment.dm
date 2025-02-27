/mob/living/proc/regenerate_limbs(noheal = FALSE, list/excluded_zones = list())
	SEND_SIGNAL(src, COMSIG_LIVING_REGENERATE_LIMBS, noheal, excluded_zones)

/mob/living/carbon/human/regenerate_limbs(noheal = FALSE, list/excluded_zones = list())
	var/list/zone_list = BP_ALL
	if(length(excluded_zones))
		zone_list -= excluded_zones
	for(var/organ in zone_list)
		regenerate_limb(organ)

/mob/living/proc/regenerate_limb(limb_zone, noheal)
	return

/mob/living/carbon/human/regenerate_limb(limb_zone, noheal)
	var/obj/item/organ/external/bodypart
	if(get_organ(limb_zone))
		return FALSE
	bodypart = get_organ(limb_zone)
	bodypart.rejuvenate()
