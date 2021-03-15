/* Diffrent misc types of tiles.
 * If adding anything to this list, ensure it goes into the _vr fiftystack too.
 * Contains:
 *		Jungle Dirt
 *		TBD
 * Put your stuff in fifty_stacks_tiles_vr.dm as well.
 */
 
 /*
 * Jungle Dirt
 */
/obj/item/stack/tile/jungledirt
	name = "jungle soil tile"
	singular_name = "jungle floor tile"
	desc = "A sample of jungle soil, miraculously packed into a tile by space technology."
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile_jungledirt"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'