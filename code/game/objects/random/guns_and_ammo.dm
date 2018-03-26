/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"

/obj/random/energy/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/gun/energy/laser,
				prob(4);/obj/item/weapon/gun/energy/gun,
				prob(3);/obj/item/weapon/gun/energy/gun/burst,
				prob(1);/obj/item/weapon/gun/energy/gun/nuclear,
				prob(2);/obj/item/weapon/gun/energy/retro,
				prob(2);/obj/item/weapon/gun/energy/lasercannon,
				prob(3);/obj/item/weapon/gun/energy/xray,
				prob(1);/obj/item/weapon/gun/energy/sniperrifle,
				prob(1);/obj/item/weapon/gun/energy/plasmastun,
				prob(2);/obj/item/weapon/gun/energy/ionrifle,
				prob(2);/obj/item/weapon/gun/energy/ionrifle/pistol,
				prob(3);/obj/item/weapon/gun/energy/toxgun,
				prob(4);/obj/item/weapon/gun/energy/taser,
				prob(2);/obj/item/weapon/gun/energy/crossbow/largecrossbow,
				prob(4);/obj/item/weapon/gun/energy/stunrevolver)

/obj/random/energy/sec
	name = "Random Security Energy Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"

/obj/random/energy/sec/item_to_spawn()
	return pick(prob(2);/obj/item/weapon/gun/energy/laser,
				prob(2);/obj/item/weapon/gun/energy/gun)

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/projectile/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/gun/projectile/automatic/wt550,
				prob(3);/obj/item/weapon/gun/projectile/automatic/mini_uzi,
				prob(3);/obj/item/weapon/gun/projectile/automatic/tommygun,
				prob(2);/obj/item/weapon/gun/projectile/automatic/c20r,
				prob(2);/obj/item/weapon/gun/projectile/automatic/sts35,
				prob(2);/obj/item/weapon/gun/projectile/automatic/z8,
				prob(4);/obj/item/weapon/gun/projectile/colt,
				prob(2);/obj/item/weapon/gun/projectile/deagle,
				prob(1);/obj/item/weapon/gun/projectile/deagle/camo,
				prob(1);/obj/item/weapon/gun/projectile/deagle/gold,
				prob(3);/obj/item/weapon/gun/projectile/derringer,
				prob(1);/obj/item/weapon/gun/projectile/heavysniper,
				prob(4);/obj/item/weapon/gun/projectile/luger,
				prob(3);/obj/item/weapon/gun/projectile/luger/brown,
				prob(4);/obj/item/weapon/gun/projectile/sec,
				prob(3);/obj/item/weapon/gun/projectile/sec/wood,
				prob(4);/obj/item/weapon/gun/projectile/p92x,
				prob(3);/obj/item/weapon/gun/projectile/p92x/brown,
				prob(4);/obj/item/weapon/gun/projectile/pistol,
				prob(5);/obj/item/weapon/gun/projectile/pirate,
				prob(2);/obj/item/weapon/gun/projectile/revolver,
				prob(4);/obj/item/weapon/gun/projectile/revolver/deckard,
				prob(4);/obj/item/weapon/gun/projectile/revolver/detective,
				prob(2);/obj/item/weapon/gun/projectile/revolver/judge,
				prob(3);/obj/item/weapon/gun/projectile/revolver/lemat,
				prob(2);/obj/item/weapon/gun/projectile/revolver/mateba,
				prob(4);/obj/item/weapon/gun/projectile/shotgun/doublebarrel,
				prob(3);/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn,
				prob(3);/obj/item/weapon/gun/projectile/shotgun/pump,
				prob(2);/obj/item/weapon/gun/projectile/shotgun/pump/combat,
				prob(4);/obj/item/weapon/gun/projectile/shotgun/pump/rifle,
				prob(3);/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever,
				prob(2);/obj/item/weapon/gun/projectile/silenced)

/obj/random/projectile/sec
	name = "Random Security Projectile Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/projectile/sec/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/gun/projectile/shotgun/pump,
				prob(2);/obj/item/weapon/gun/projectile/automatic/wt550,
				prob(1);/obj/item/weapon/gun/projectile/shotgun/pump/combat)

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"

/obj/random/handgun/item_to_spawn()
	return pick(prob(4);/obj/item/weapon/gun/projectile/sec,
				prob(4);/obj/item/weapon/gun/projectile/p92x,
				prob(3);/obj/item/weapon/gun/projectile/sec/wood,
				prob(3);/obj/item/weapon/gun/projectile/p92x/brown,
				prob(3);/obj/item/weapon/gun/projectile/colt,
				prob(2);/obj/item/weapon/gun/projectile/luger,
				prob(2);/obj/item/weapon/gun/energy/gun,
				prob(2);/obj/item/weapon/gun/projectile/pistol,
				prob(1);/obj/item/weapon/gun/energy/retro,
				prob(1);/obj/item/weapon/gun/projectile/luger/brown)

/obj/random/handgun/sec
	name = "Random Security Handgun"
	desc = "This is a random security sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"

/obj/random/handgun/sec/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/gun/projectile/sec,
				prob(1);/obj/item/weapon/gun/projectile/sec/wood)

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random security ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"

/obj/random/ammo/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/box/beanbags,
				prob(2);/obj/item/weapon/storage/box/shotgunammo,
				prob(4);/obj/item/weapon/storage/box/shotgunshells,
				prob(1);/obj/item/weapon/storage/box/stunshells,
				prob(2);/obj/item/ammo_magazine/m45,
				prob(4);/obj/item/ammo_magazine/m45/rubber,
				prob(4);/obj/item/ammo_magazine/m45/flash,
				prob(2);/obj/item/ammo_magazine/m9mmt,
				prob(6);/obj/item/ammo_magazine/m9mmt/rubber)