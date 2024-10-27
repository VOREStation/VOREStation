//	Observer Pattern Implementation: Unequipped (dropped)
//		Registration type: /mob
//
//		Raised when: A mob unequips/drops an item.
//
//		Arguments that the called proc should expect:
//			/mob/equipped:  The mob that unequipped/dropped the item.
//			/obj/item/item: The unequipped item.
/*
GLOBAL_DATUM_INIT(mob_unequipped_event, /decl/observ/mob_unequipped, new)

/decl/observ/mob_unequipped
	name = "Mob Unequipped"
	expected_type = /mob

//	Observer Pattern Implementation: Unequipped (dropped)
//		Registration type: /obj/item
//
//		Raised when: A mob unequips/drops an item.
//
//		Arguments that the called proc should expect:
//			/obj/item/item: The unequipped item.
//			/mob/equipped:  The mob that unequipped/dropped the item.

GLOBAL_DATUM_INIT(item_unequipped_event, /decl/observ/item_unequipped, new)

/decl/observ/item_unequipped
	name = "Item Unequipped"
	expected_type = /obj/item
*/
//Deprecated in favor of comsigs

/**********************
* Unequipped Handling *
**********************/

/obj/item/dropped(var/mob/user)
	. = ..(user)
	//SEND_SIGNAL(user, COMSIG_OBSERVER_MOB_UNEQUIPPED, src)
	//SEND_SIGNAL(src, COMSIG_OBSERVER_ITEM_UNEQUIPPED, user)
	if(user) // Cannot always guarantee that user won't be null
		SEND_SIGNAL(user, COMSIG_OBSERVER_MOB_UNEQUIPPED, src)
		SEND_SIGNAL(src, COMSIG_OBSERVER_ITEM_UNEQUIPPED, user)
	else
		SEND_SIGNAL(src, COMSIG_OBSERVER_ITEM_UNEQUIPPED)
