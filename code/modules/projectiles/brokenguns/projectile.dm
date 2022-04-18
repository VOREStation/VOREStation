
<<<<<<< HEAD
/obj/item/weapon/broken_gun/c20r/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/projectile/automatic/c20r/empty)

/obj/item/weapon/broken_gun/silenced45/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/projectile/silenced/empty)

/obj/item/weapon/broken_gun/pumpshotgun/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/projectile/shotgun/pump/empty)

/obj/item/weapon/broken_gun/pumpshotgun_combat/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/projectile/shotgun/pump/combat/empty)

/obj/item/weapon/broken_gun/z8/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/projectile/automatic/z8/empty)

/obj/item/weapon/broken_gun/dartgun/New(var/newloc)
	..(newloc, /obj/item/weapon/gun/projectile/dartgun)
=======
/obj/item/broken_gun/c20r/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/projectile/automatic/c20r/empty)

/obj/item/broken_gun/silenced45/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/projectile/silenced/empty)

/obj/item/broken_gun/pumpshotgun/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/projectile/shotgun/pump/empty)

/obj/item/broken_gun/pumpshotgun_combat/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/projectile/shotgun/pump/combat/empty)

/obj/item/broken_gun/z8/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/projectile/automatic/z8/empty)

/obj/item/broken_gun/dartgun/Initialize(var/ml)
	. = ..(ml, /obj/item/gun/projectile/dartgun)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
