/mob/living/proc/regenerate_limbs(noheal = FALSE, list/excluded_zones = list())
	SEND_SIGNAL(src, COMSIG_LIVING_REGENERATE_LIMBS, noheal, excluded_zones)

/mob/living/carbon/human/regenerate_limbs(noheal = FALSE, list/excluded_zones = list())
	var/list/zone_list = BP_ALL
	if(length(excluded_zones))
		zone_list -= excluded_zones
	for(var/organ in zone_list)
		regenerate_limb(organ)
	for(var/obj/item/organ/external/stump/stump in organs)
		qdel(stump)

/mob/living/proc/regenerate_limb(limb_zone, noheal)
	return

/mob/living/carbon/human/regenerate_limb(limb_zone, noheal)
	var/obj/item/organ/external/bodypart
	if(get_organ(limb_zone))
		bodypart = get_organ(limb_zone)
		if(!bodypart.is_stump())
			return FALSE
		bodypart.removed()
		qdel(bodypart)
		bodypart = null
	var/list/organ_data = species.has_limbs[limb_zone]
	var/limb_path = organ_data["path"]
	var/obj/item/organ/O = new limb_path(src)
	organ_data["descriptor"] = O.name

	update_icons_body()
	return TRUE
