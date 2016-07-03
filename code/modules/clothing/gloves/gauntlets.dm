/obj/item/clothing/gloves/gauntlets	//Used to cover gloves, otherwise act as gloves. Currently the base item has some weird issues, not worth fixing until it's needed elsewhere.
	name = "gauntlets"
	desc = "These gloves go over regular gloves."
	icon_state = "black"
	item_state = "bgloves"
	slot_flags = SLOT_GLOVES
	overgloves = 1
	var/obj/item/clothing/gloves/gloves = null	//Undergloves

/obj/item/clothing/gloves/gauntlets/mob_can_equip(mob/user)
	var/mob/living/carbon/human/H = user

	if(H.gloves)
		gloves = H.gloves
		if(gloves.overgloves)
			user << "You are unable to wear \the [src] as \the [H.gloves] are in the way."
			gloves = null
			return 0
		H.drop_from_inventory(gloves)
		gloves.forceMove(src)

	if(!..())
		if(gloves)
			if(H.equip_to_slot_if_possible(gloves, slot_gloves))
				gloves = null
			return 0
	if(gloves)
		user << "You slip \the [src] on over \the [gloves]."
//	user.set_slowdown()	//Needs to be converted from magboots, doesn't need to be done until there are gauntlets with slowdown
	return 1