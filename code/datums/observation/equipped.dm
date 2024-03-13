//	Observer Pattern Implementation: Equipped
//		Registration type: /mob
//
//		Raised when: A mob equips an item.
//
//		Arguments that the called proc should expect:
//			/mob/equipper:  The mob that equipped the item.
//			/obj/item/item: The equipped item.
//			slot:           The slot equipped to.
/*
GLOBAL_DATUM_INIT(mob_equipped_event, /decl/observ/mob_equipped, new)

/decl/observ/mob_equipped
	name = "Mob Equipped"
	expected_type = /mob

//	Observer Pattern Implementation: Equipped
//		Registration type: /obj/item
//
//		Raised when: A mob equips an item.
//
//		Arguments that the called proc should expect:
//			/obj/item/item: The equipped item.
//			/mob/equipper:  The mob that equipped the item.
//			slot:           The slot equipped to.
GLOBAL_DATUM_INIT(item_equipped_event, /decl/observ/item_equipped, new)

/decl/observ/item_equipped
	name = "Item Equipped"
	expected_type = /obj/item
*/
//Deprecated in favor of comsigs
/********************
* Equipped Handling *
********************/

/obj/item/equipped(var/mob/user, var/slot)
	. = ..()
	SEND_SIGNAL(user, COMSIG_OBSERVER_MOB_EQUIPPED, src, slot)
	SEND_SIGNAL(src, COMSIG_OBSERVER_ITEM_EQUIPPED, user, slot)
