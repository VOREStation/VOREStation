/obj/item/clothing/apply_accessories(image/standing)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			standing.add_overlay(A.get_mob_overlay())

/obj/item/clothing/apply_blood(image/standing)
	if(forensic_data?.has_blooddna() && blood_sprite_state && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = blood_sprite_state)
		bloodsies.color		= blood_color
		standing.add_overlay(bloodsies)

//HELMET: May have a lighting overlay
/obj/item/clothing/head/make_worn_icon(body_type,slot_name,inhands,default_icon,default_layer = 0,icon/clip_mask = null)
	var/image/standing = ..()
	if(light_on && slot_name == slot_head_str)
		var/cache_key = "[light_overlay][LAZYACCESS(sprite_sheets, body_type) ? "_[body_type]" : ""]"
		if(standing && GLOB.light_overlay_cache[cache_key])
			standing.add_overlay(GLOB.light_overlay_cache[cache_key])
	return standing

//SUIT: Blood state is slightly different
/obj/item/clothing/suit/apply_blood(image/standing)
	if(forensic_data?.has_blooddna() && blood_sprite_state && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		blood_sprite_state = "[blood_overlay_type]blood"
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = blood_sprite_state)
		bloodsies.color		= blood_color
		standing.add_overlay(bloodsies)
