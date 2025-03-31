/*
 *	WORKS FOR RIGS, NOT AS A STANDALONE RIGHT NOW
 *
 *	TODO: 	FIX QUICK_EQUIP SO IT DOESN'T EQUIP THESE TO YOUR BACK WHEN YOU HAVE NO GLOVES
 *			CHECK SLOWDOWN ON EQUIP/UNEQUIP
 *			ADD SPRITES FOR ANY ACTUAL GAUNTLET ITEMS, THE BASE GLOVE ITEM HAS NO SPRITE, FOR GOOD REASON
 */

/obj/item/clothing/gloves/gauntlets	//Used to cover gloves, otherwise act as gloves.
	name = DEVELOPER_WARNING_NAME // "gauntlets"
	desc = "These gloves go over regular gloves."
	glove_level = 3
	overgloves = 1
	punch_force = 5

/obj/item/clothing/gloves/gauntlets/mob_can_equip(mob/user, slot, disable_warning = FALSE)
	var/mob/living/carbon/human/H = user
	if(H.gloves)
		gloves = H.gloves
		if(!istype(gloves))
			to_chat(user, "You are unable to wear \the [src] as \the [H.gloves] are in the way.")
			gloves = null
			return 0
		if(gloves.overgloves)
			to_chat(user, "You are unable to wear \the [src] as \the [H.gloves] are in the way.")
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
		to_chat(user, "You slip \the [src] on over \the [gloves].")
	wearer = WEAKREF(H)
	return 1
