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
	resistance_flags = FIRE_PROOF
