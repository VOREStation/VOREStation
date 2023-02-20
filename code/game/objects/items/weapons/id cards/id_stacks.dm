// This is a defines file for card sprite stacks. If a new card set comes in, this file can just be disabled and a new one made to match the new sprites.
// Generally, if the icon file is card_xxx.dmi, this filename should be sprite_stacks_xxx.dm
// Please make sure that only the relevant sprite_stacks_xxx.file is included, if more are made.

/obj/item/weapon/card
	icon = 'icons/obj/card_new.dmi' // These are redefined here so that changing sprites is as easy as clicking the checkbox.
	base_icon = 'icons/obj/card_new.dmi'

	// New sprite stacks can be defined here. You could theoretically change icon-states as well but right now this file compiles before station_ids.dm so those wouldn't be affected.
  
/*
/obj/item/weapon/card/id/generic
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-silhouette", "clip")

// CENTCOM
/obj/item/weapon/card/id/centcom
	initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n", "pips-gold")

/obj/item/weapon/card/id/centcom/vip
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n", "pips-gold")

/obj/item/weapon/card/id/centcom/ERT
	initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n", "pips-red", "stripe-red")

// GENERIC COMMAND
/obj/item/weapon/card/id/silver
	initial_sprite_stack = list("base-stamp-silver", "top-mime", "stamp-n-generic")

/obj/item/weapon/card/id/silver/secretary
	initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n")

/obj/item/weapon/card/id/silver/hop
	initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n", "stripe-white")

// MEDICAL
/obj/item/weapon/card/id/medical
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n")

/obj/item/weapon/card/id/medical/chemist
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "pips-orange")

/obj/item/weapon/card/id/medical/geneticist
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "pips-purple")

/obj/item/weapon/card/id/medical/psych
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "pips-purple")

/obj/item/weapon/card/id/medical/emt
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "pips-blue")

/obj/item/weapon/card/id/medical/head
	initial_sprite_stack = list("base-stamp-silver", "top-medblu", "stamp-n", "stripe-gold")

/obj/item/weapon/card/id/medical/sar
	initial_sprite_stack = list("base-stamp", "top-darkgreen", "stamp-n", "pips-medblu")

// SECURITY
/obj/item/weapon/card/id/security
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n")

/obj/item/weapon/card/id/security/detective
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n", "pips-brown")

/obj/item/weapon/card/id/security/warden
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n", "pips-white")

/obj/item/weapon/card/id/security/head
	initial_sprite_stack = list("base-stamp-silver", "top-red", "stamp-n", "stripe-gold")

// ENGINEERING
/obj/item/weapon/card/id/engineering
	initial_sprite_stack = list("base-stamp", "top-orange", "stamp-n")

/obj/item/weapon/card/id/engineering/atmos
	initial_sprite_stack = list("base-stamp", "top-orange", "pips-medblu", "stamp-n")

/obj/item/weapon/card/id/engineering/head
	initial_sprite_stack = list("base-stamp-silver", "top-orange", "stamp-n", "stripe-gold")

// SCIENCE
/obj/item/weapon/card/id/science
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n")

/obj/item/weapon/card/id/science/roboticist
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n", "pips-orange")

/obj/item/weapon/card/id/science/explorer
	initial_sprite_stack = list("base-stamp", "top-darkgreen", "stamp-n")

/obj/item/weapon/card/id/science/head
	initial_sprite_stack = list("base-stamp-silver", "top-purple", "stamp-n", "stripe-gold")

/obj/item/weapon/card/id/science/head/pathfinder
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "dept-exploration", "stamp-n", "pips-gold")

// CARGO
/obj/item/weapon/card/id/cargo
	initial_sprite_stack = list("base-stamp", "top-brown", "stamp-n")

/obj/item/weapon/card/id/cargo/miner
	initial_sprite_stack = list("base-stamp", "top-brown", "stamp-n", "pips-purple")

/obj/item/weapon/card/id/cargo/head
	initial_sprite_stack = list("base-stamp-silver", "top-brown", "stamp-n", "pips-gold")

// CIVLIAN
/obj/item/weapon/card/id/civilian
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n")

/obj/item/weapon/card/id/civilian/chaplain
	initial_sprite_stack = list("base-stamp-silver", "top-dark", "stamp-cross", "pips-white")

/obj/item/weapon/card/id/civilian/internal_affairs
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n")

/obj/item/weapon/card/id/civilian/botanist
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-brown")

/obj/item/weapon/card/id/civilian/bartender
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-dark")

<<<<<<< HEAD
/obj/item/weapon/card/id/civilian/chef
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-white")		
=======
/obj/item/card/id/civilian/chef
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-white")
>>>>>>> 14a10960b71... Union Rep Office and ID (#8964)

/obj/item/weapon/card/id/civilian/janitor
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-purple")

/obj/item/weapon/card/id/civilian/journalist
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n")

/obj/item/weapon/card/id/civilian/clown
	initial_sprite_stack = list("base-stamp", "top-rainbow", "stamp-n")

/obj/item/weapon/card/id/civilian/mime
	initial_sprite_stack = list("base-stamp", "top-white", "stamp-n", "stripe-black")

/obj/item/weapon/card/id/civilian/pilot
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "pips-blue")

/obj/item/weapon/card/id/civilian/head
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "stripe-white")

/obj/item/weapon/card/id/syndicate
	initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s")

<<<<<<< HEAD
/obj/item/weapon/card/id/syndicate/officer
	initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s", "pips-gold", "stripe-gold")
*/
=======
/obj/item/card/id/syndicate/officer
	initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s", "pips-gold", "stripe-gold")

/obj/item/card/id/union
	initial_sprite_stack = list("base-stamp-gold", "top-dark", "stamp-n", "pips-gold", "stripe-black")
>>>>>>> 14a10960b71... Union Rep Office and ID (#8964)
