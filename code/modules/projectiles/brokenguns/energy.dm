
<<<<<<< HEAD
/obj/item/weapon/broken_gun/laserrifle/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/energy/laser/empty)

/obj/item/weapon/broken_gun/laser_retro/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/energy/retro/empty)

/obj/item/weapon/broken_gun/ionrifle/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/energy/ionrifle/empty)
=======
/obj/item/broken_gun/laserrifle/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/energy/laser/empty)

/obj/item/broken_gun/laser_retro/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/energy/retro/empty)

/obj/item/broken_gun/ionrifle/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/energy/ionrifle/empty)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
