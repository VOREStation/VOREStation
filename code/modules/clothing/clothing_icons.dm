/obj/item/clothing/apply_accessories(var/image/standing)
	if(LAZYLEN(accessories))
		for(var/obj/item/clothing/accessory/A in accessories)
			standing.add_overlay(A.get_mob_overlay())

/obj/item/clothing/apply_blood(var/image/standing)
	if(blood_DNA && blood_sprite_state && ishuman(loc))
		var/mob/living/human/H = loc
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = blood_sprite_state)
		bloodsies.color		= blood_color
		standing.add_overlay(bloodsies)

//HELMET: May have a lighting overlay
/obj/item/clothing/head/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer = 0,var/icon/clip_mask = null)
	var/image/standing = ..()
	if(light_on && slot_name == slot_head_str)
		var/cache_key = "[light_overlay][LAZYACCESS(sprite_sheets, body_type) ? "_[body_type]" : ""]"
		if(standing && light_overlay_cache[cache_key])
			standing.add_overlay(light_overlay_cache[cache_key])
	return standing

//SUIT: Blood state is slightly different
/obj/item/clothing/suit/apply_blood(var/image/standing)
	if(blood_DNA && blood_sprite_state && ishuman(loc))
		var/mob/living/human/H = loc
		blood_sprite_state = "[blood_overlay_type]blood"
		var/image/bloodsies	= image(icon = H.species.get_blood_mask(H), icon_state = blood_sprite_state)
		bloodsies.color		= blood_color
		standing.add_overlay(bloodsies)
