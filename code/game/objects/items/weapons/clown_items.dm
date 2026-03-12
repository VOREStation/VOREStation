/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Soap
 *		Bike Horns
 */

/*
 * Banana Peels
 */
/obj/item/bananapeel/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(isliving(AM))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
