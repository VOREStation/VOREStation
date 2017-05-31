/obj/random/weapon // For Gateway maps and Syndicate. Can possibly spawn almost any gun in the game.
	name = "Random Illegal Weapon"
	desc = "This is a random illegal weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "p08"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(11);/obj/random/ammo_all,\
					prob(11);/obj/item/weapon/gun/energy/laser,\
					prob(11);/obj/item/weapon/gun/projectile/pirate,\
					prob(10);/obj/item/weapon/material/twohanded/spear,\
					prob(10);/obj/item/weapon/gun/energy/stunrevolver,\
					prob(10);/obj/item/weapon/gun/energy/taser,\
					prob(10);/obj/item/weapon/gun/launcher/crossbow,\
					prob(10);/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet,\
					prob(10);/obj/item/weapon/material/knife,\
					prob(10);/obj/item/weapon/material/hatchet/tacknife/combatknife,\
					prob(10);/obj/item/weapon/material/butterfly/switchblade,\
					prob(10);/obj/item/weapon/gun/projectile/luger,\
					prob(10);/obj/item/weapon/gun/projectile/luger/brown,\
				/*	prob(10);/obj/item/weapon/gun/projectile/pipegun,\ */
					prob(10);/obj/item/weapon/gun/projectile/revolver,\
					prob(10);/obj/item/weapon/gun/projectile/revolver/detective,\
					prob(10);/obj/item/weapon/gun/projectile/revolver/mateba,\
					prob(10);/obj/item/weapon/gun/projectile/revolver/judge,\
					prob(10);/obj/item/weapon/gun/projectile/colt,\
					prob(10);/obj/item/weapon/gun/projectile/shotgun/pump,\
					prob(10);/obj/item/weapon/gun/projectile/shotgun/pump/rifle,\
					prob(10);/obj/item/weapon/gun/projectile/shotgun/pump/rifle/mosin,\
					prob(10);/obj/item/weapon/melee/baton,\
					prob(10);/obj/item/weapon/melee/telebaton,\
					prob(10);/obj/item/weapon/melee/classic_baton,\
					prob(10);/obj/item/weapon/melee/energy/sword,\
					prob(9);/obj/item/weapon/gun/projectile/automatic/wt550/lethal,\
					prob(9);/obj/item/weapon/gun/projectile/automatic/pdw,\
					prob(9);/obj/item/weapon/gun/projectile/derringer,\
					prob(9);/obj/item/weapon/gun/energy/crossbow/largecrossbow,\
					prob(9);/obj/item/weapon/gun/projectile/automatic/mini_uzi,\
					prob(9);/obj/item/weapon/gun/projectile/pistol,\
					prob(9);/obj/item/weapon/gun/projectile/shotgun/pump/combat,\
					prob(9);/obj/item/weapon/twohanded/fireaxe,\
					prob(9);/obj/item/weapon/cane/concealed,\
					prob(9);/obj/item/weapon/gun/energy/gun,\
					prob(8);/obj/item/weapon/gun/energy/ionrifle,\
					prob(8);/obj/item/weapon/gun/energy/retro,\
					prob(8);/obj/item/weapon/gun/energy/gun/eluger,\
					prob(8);/obj/item/weapon/gun/energy/xray,\
					prob(8);/obj/item/weapon/gun/projectile/automatic/c20r,\
					prob(8);/obj/item/weapon/gun/projectile/automatic/stg,\
					prob(8);/obj/item/weapon/melee/energy/sword,\
				/*	prob(8);/obj/item/weapon/gun/projectile/automatic/m41a,\ */
					prob(7);/obj/item/weapon/gun/energy/captain,\
					prob(7);/obj/item/weapon/gun/energy/sniperrifle,\
					prob(7);/obj/item/weapon/gun/projectile/automatic/p90,\
					prob(7);/obj/item/weapon/gun/projectile/automatic/as24,\
					prob(7);/obj/item/weapon/gun/projectile/automatic/sts35,\
					prob(7);/obj/item/weapon/gun/projectile/automatic/z8,\
					prob(7);/obj/item/weapon/gun/energy/gun/burst,\
					prob(7);/obj/item/weapon/gun/projectile/shotgun/pump/unsc,\
					prob(7);/obj/item/weapon/gun/projectile/deagle,\
					prob(7);/obj/item/weapon/gun/launcher/grenade,\
					prob(6);/obj/item/weapon/gun/projectile/SVD,\
					prob(6);/obj/item/weapon/gun/projectile/automatic/l6_saw,\
					prob(6);/obj/item/weapon/gun/energy/lasercannon,\
					prob(5);/obj/item/weapon/gun/projectile/automatic/carbine,\
					prob(5);/obj/item/weapon/gun/energy/pulse_rifle,\
				/*	prob(4);/obj/item/weapon/gun/projectile/automatic/battlerifle,\ */
					prob(3);/obj/item/weapon/gun/projectile/deagle/camo,\
					prob(3);/obj/item/weapon/gun/energy/gun/nuclear,\
					prob(2);/obj/item/weapon/gun/projectile/deagle/gold,\
					prob(1);/obj/item/weapon/gun/launcher/rocket,\
					prob(1);/obj/item/weapon/gun/launcher/grenade,\
					prob(1);/obj/item/weapon/gun/projectile/gyropistol,\
					prob(1);/obj/item/weapon/gun/projectile/heavysniper,\
					prob(1);/obj/item/weapon/plastique,\
					prob(1);/obj/item/weapon/material/sword,\
					prob(1);/obj/item/weapon/cane/concealed,\
					prob(1);/obj/item/weapon/material/sword/katana)

/obj/random/weapon/guarenteed
	spawn_nothing_percentage = 0

/obj/random/ammo_all
	name = "Random Ammunition (All)"
	desc = "This is random ammunition. Spawns all ammo types."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "666"
	item_to_spawn()
		return pick(prob(5);/obj/item/weapon/storage/box/shotgunammo,\
					prob(5);/obj/item/weapon/storage/box/shotgunshells,\
					prob(5);/obj/item/ammo_magazine/a357,\
					prob(5);/obj/item/ammo_magazine/clip/a762,\
					prob(5);/obj/item/ammo_magazine/c45m,\
					prob(5);/obj/item/ammo_magazine/c45m/rubber,\
					prob(5);/obj/item/ammo_magazine/c38,\
					prob(5);/obj/item/ammo_magazine/c38/rubber,\
					prob(5);/obj/item/weapon/storage/box/flashbangs,\
					prob(5);/obj/item/ammo_magazine/c556,\
					prob(4);/obj/item/ammo_magazine/clip/a556,\
					prob(4);/obj/item/ammo_magazine/clip/c45,\
					prob(4);/obj/item/ammo_magazine/clip/c9mm,\
					prob(4);/obj/item/ammo_magazine/c45uzi,\
					prob(4);/obj/item/ammo_magazine/c556/ext,\
					prob(4);/obj/item/ammo_magazine/mc9mm,\
					prob(4);/obj/item/ammo_magazine/mc9mml,\
					prob(4);/obj/item/ammo_magazine/mc9mmt,\
					prob(4);/obj/item/ammo_magazine/mc9mmt/rubber,\
					prob(4);/obj/item/ammo_magazine/a10mm,\
					prob(4);/obj/item/ammo_magazine/p90,\
				/*	prob(4);/obj/item/ammo_magazine/m14,\
					prob(4);/obj/item/ammo_magazine/m14/large,\ */
					prob(4);/obj/item/ammo_magazine/c556/ext,\
					prob(4);/obj/item/ammo_magazine/s762,\
					prob(4);/obj/item/ammo_magazine/c762,\
					prob(3);/obj/item/ammo_magazine/clip/a10mm,\
					prob(3);/obj/item/ammo_magazine/clip/a50,\
					prob(3);/obj/item/ammo_magazine/c556,\
					prob(2);/obj/item/ammo_magazine/a50,\
					prob(2);/obj/item/ammo_magazine/a556,\
					prob(1);/obj/item/weapon/storage/box/frags,\
				/*	prob(1);/obj/item/ammo_magazine/battlerifle,\ */
					prob(1);/obj/item/ammo_casing/rocket,\
					prob(1);/obj/item/weapon/storage/box/sniperammo,\
					prob(1);/obj/item/weapon/storage/box/flashshells,\
					prob(1);/obj/item/weapon/storage/box/beanbags,\
					prob(1);/obj/item/weapon/storage/box/practiceshells,\
					prob(1);/obj/item/weapon/storage/box/stunshells,\
					prob(1);/obj/item/weapon/storage/box/blanks,\
					prob(1);/obj/item/ammo_magazine/stg,\
					prob(1);/obj/item/ammo_magazine/tommydrum,\
					prob(1);/obj/item/ammo_magazine/tommymag
					)

/obj/random/cargopod
	name = "Random Cargo Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 0
/obj/random/cargopod/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/pill_bottle/tramadol,
				prob(8);/obj/item/weapon/haircomb,
				prob(4);/obj/item/weapon/storage/pill_bottle/happy,
				prob(4);/obj/item/weapon/storage/pill_bottle/zoom,
				prob(10);/obj/item/weapon/contraband/poster,
				prob(4);/obj/item/weapon/material/butterfly,
				prob(6);/obj/item/weapon/material/butterflyblade,
				prob(6);/obj/item/weapon/material/butterflyhandle,
				prob(6);/obj/item/weapon/material/wirerod,
				prob(2);/obj/item/weapon/material/butterfly/switchblade,
				prob(2);/obj/item/weapon/material/knuckledusters,
				prob(1);/obj/item/weapon/material/hatchet/tacknife,
				prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,
				prob(1);/obj/item/weapon/beartrap,
				prob(1);/obj/item/weapon/handcuffs,
				prob(1);/obj/item/weapon/legcuffs,
				prob(2);/obj/item/weapon/reagent_containers/syringe/drugs,
				prob(1);/obj/item/weapon/reagent_containers/syringe/steroid)

//A random thing so that the spawn_nothing_percentage can be used w/o duplicating code.
/obj/random/trash_pile
	name = "Random Trash Pile"
	desc = "Hot Garbage."
	icon = 'icons/obj/trash_piles.dmi'
	icon_state = "randompile"
	spawn_nothing_percentage = 0
/obj/random/trash_pile/item_to_spawn()
	return	/obj/structure/trash_pile