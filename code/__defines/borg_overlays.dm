/// This file contains everything that involves the borg overlay system that is applied to borgs in robot/sprites_sprite_datum.dm

/// These are applied ON /datum/robot_sprite to tell it what overlays it can or can not have.

/// If you make a borg that has a laser, taser, and shield, here's an Example:
/// sprite_flags = ROBOT_HAS_LASER_SPRITE | ROBOT_HAS_TASER_SPRITE | ROBOT_HAS_SHIELD_SPRITE

/// NOTES: You are NOT EXPECTED TO HAVE A GUN SPRITE IF YOU HAVE A DEDICATED LASER/TASER/DISABLER SPRITE. Doing so will cause BAD THINGS to happen!!!
/// IMPORTANT: Flags operate on a 1 2 4 8 10 20 40 80 100 200 400 800 1000 2000 4000 8000 etc system. Not 1 2 4 8 16 32 64 like I thought at first (oops)
#define ROBOT_HAS_SPEED_SPRITE 0x1	//Ex:		/obj/item/borg/combat/mobility Replaces old has_speed_sprite
#define ROBOT_HAS_SHIELD_SPRITE 0x2	//Ex:		/obj/item/borg/combat/shield Replaces old has_shield_sprite
#define ROBOT_HAS_SHIELD_SPEED_SPRITE 0x4		//Ex: Has a sprite for when both is activated AND has /obj/item/borg/combat/mobility
#define ROBOT_HAS_LASER_SPRITE 0x8	//Ex:		/obj/item/gun/energy/robotic/laser Replaces old has_laser_sprite
#define ROBOT_HAS_TASER_SPRITE 0x10	//Ex:		/obj/item/gun/energy/robotic/taser Replaces old has_taser_sprite
#define ROBOT_HAS_GUN_SPRITE 0x20	//Ex:		Has a general gun sprite. Replaces old has_gun_sprite
#define ROBOT_HAS_DISABLER_SPRITE 0x40 //Ex:	/obj/item/gun/energy/taser/mounted/cyborg/ertgun HOWEVER it is not used on this codebase (Virgo) but may be used downstream.

/// For sanity's sake for you spriters out there that don't want to dig through the code, attach the below as a suffix for your sprites:
/// Speed: -roll
/// Shield: -shield
/// Both: -speed_shield
/// Laser: -laser
/// Taser: -taser
/// Gun: -gun
/// Disabler: -disabler


/// These are applied on GUNS to classify them as a GUN, TASER, OR LASER.
/// So every borg weapon is a child of '/obj/item/gun/energy/robotic' and given the 'laser' 'taser' 'gun' etc flag. ALL guns have 'gun' by default.
#define COUNTS_AS_ROBOT_GUN 0x1
#define COUNTS_AS_ROBOT_TASER 0x2
#define COUNTS_AS_ROBOT_LASER 0x4
#define COUNTS_AS_ROBOT_DISABLER 0x8

/// ADDITIONAL NOTES:
/// If you want to have a special type of item that will be used on borgs that is NOT a gun that causes an overlay, have no fear!
/// Currently, the SHIELD, SPEED, and both are included. If you want your borg to have a cool special overlay, use 'handle_extra_icon_updates'!
/// Here's an example:

/*
/datum/robot_sprite/combat/fluff/foopwotch/handle_extra_icon_updates(var/mob/living/silicon/robot/ourborg) //Make sure the path is correct!
	..() //THIS IS ESSENTIAL. IF YOU FORGET THIS LINE, YOU WILL NOT GET THE NORMAL SPRITES.
    if(ourborg.has_active_type(/obj/item/weapon/combat_borgblade))
        ourborg.add_overlay("[sprite_icon_state]-dagger")
*/
