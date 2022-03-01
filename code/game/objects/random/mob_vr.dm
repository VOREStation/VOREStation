/obj/random/weapon // For Gateway maps and Syndicate. Can possibly spawn almost any gun in the game.
	name = "Random Illegal Weapon"
	desc = "This is a random illegal weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "p08"
	spawn_nothing_percentage = 50
/obj/random/weapon/item_to_spawn()
	return pick(prob(11);/obj/random/ammo_all,\
				prob(11);/obj/item/weapon/gun/energy/laser,\
				prob(11);/obj/item/weapon/gun/projectile/pirate,\
				prob(10);/obj/item/weapon/material/twohanded/spear,\
				prob(10);/obj/item/weapon/gun/energy/stunrevolver,\
				prob(10);/obj/item/weapon/gun/energy/taser,\
				prob(10);/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet,\
				prob(10);/obj/item/weapon/material/knife,\
				prob(10);/obj/item/weapon/gun/projectile/luger,\
			/*	prob(10);/obj/item/weapon/gun/projectile/pipegun,\ */
				prob(10);/obj/item/weapon/gun/projectile/revolver/detective,\
				prob(10);/obj/item/weapon/gun/projectile/revolver/judge,\
				prob(10);/obj/item/weapon/gun/projectile/colt,\
				prob(10);/obj/item/weapon/gun/projectile/shotgun/pump,\
				prob(10);/obj/item/weapon/gun/projectile/shotgun/pump/rifle,\
				prob(10);/obj/item/weapon/melee/baton,\
				prob(10);/obj/item/weapon/melee/telebaton,\
				prob(10);/obj/item/weapon/melee/classic_baton,\
				prob(9);/obj/item/weapon/gun/projectile/automatic/wt550/lethal,\
				prob(9);/obj/item/weapon/gun/projectile/automatic/pdw,\
				prob(9);/obj/item/weapon/gun/projectile/automatic/sol, \
				prob(9);/obj/item/weapon/gun/energy/crossbow/largecrossbow,\
				prob(9);/obj/item/weapon/gun/projectile/pistol,\
				prob(9);/obj/item/weapon/gun/projectile/shotgun/pump,\
				prob(9);/obj/item/weapon/cane/concealed,\
				prob(9);/obj/item/weapon/gun/energy/gun,\
				prob(8);/obj/item/weapon/gun/energy/retro,\
				prob(8);/obj/item/weapon/gun/energy/gun/eluger,\
				prob(8);/obj/item/weapon/gun/energy/xray,\
				prob(8);/obj/item/weapon/gun/projectile/automatic/c20r,\
				prob(8);/obj/item/weapon/melee/energy/sword,\
				prob(8);/obj/item/weapon/gun/projectile/derringer,\
				prob(8);/obj/item/weapon/gun/projectile/revolver/lemat,\
			/*	prob(8);/obj/item/weapon/gun/projectile/shotgun/pump/rifle/mosin,\ */
			/*	prob(8);/obj/item/weapon/gun/projectile/automatic/m41a,\ */
				prob(7);/obj/item/weapon/material/butterfly,\
				prob(7);/obj/item/weapon/material/butterfly/switchblade,\
				prob(7);/obj/item/weapon/gun/projectile/giskard,\
				prob(7);/obj/item/weapon/gun/projectile/automatic/p90,\
				prob(7);/obj/item/weapon/gun/projectile/automatic/sts35,\
				prob(7);/obj/item/weapon/gun/projectile/shotgun/pump/combat,\
				prob(6);/obj/item/weapon/gun/energy/sniperrifle,\
				prob(6);/obj/item/weapon/gun/projectile/automatic/z8,\
				prob(6);/obj/item/weapon/gun/energy/captain,\
				prob(6);/obj/item/weapon/material/knife/tacknife,\
				prob(5);/obj/item/weapon/gun/projectile/shotgun/pump/USDF,\
				prob(5);/obj/item/weapon/gun/projectile/giskard/olivaw,\
				prob(5);/obj/item/weapon/gun/projectile/revolver/consul,\
				prob(5);/obj/item/weapon/gun/projectile/revolver/mateba,\
				prob(5);/obj/item/weapon/gun/projectile/revolver,\
				prob(4);/obj/item/weapon/gun/projectile/deagle,\
				prob(4);/obj/item/weapon/material/knife/tacknife/combatknife,\
				prob(4);/obj/item/weapon/melee/energy/sword,\
				prob(4);/obj/item/weapon/gun/projectile/automatic/mini_uzi,\
				prob(4);/obj/item/weapon/gun/projectile/contender,\
				prob(4);/obj/item/weapon/gun/projectile/contender/tacticool,\
				prob(3);/obj/item/weapon/gun/projectile/SVD,\
				prob(3);/obj/item/weapon/gun/energy/lasercannon,\
				prob(3);/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever,\
				prob(3);/obj/item/weapon/gun/projectile/automatic/bullpup,\
				prob(2);/obj/item/weapon/gun/energy/pulse_rifle,\
				prob(2);/obj/item/weapon/gun/energy/gun/nuclear,\
				prob(2);/obj/item/weapon/gun/projectile/automatic/l6_saw,\
				prob(2);/obj/item/weapon/gun/energy/gun/burst,\
				prob(2);/obj/item/weapon/storage/box/frags,\
				prob(2);/obj/item/weapon/twohanded/fireaxe,\
				prob(2);/obj/item/weapon/gun/projectile/luger/brown,\
				prob(2);/obj/item/weapon/gun/launcher/crossbow,\
			/*	prob(1);/obj/item/weapon/gun/projectile/automatic/battlerifle,\ */ // Too OP
				prob(1);/obj/item/weapon/gun/projectile/deagle/gold,\
				prob(1);/obj/item/weapon/gun/energy/imperial,\
				prob(1);/obj/item/weapon/gun/projectile/automatic/as24,\
				prob(1);/obj/item/weapon/gun/launcher/rocket,\
				prob(1);/obj/item/weapon/gun/launcher/grenade,\
				prob(1);/obj/item/weapon/gun/projectile/gyropistol,\
				prob(1);/obj/item/weapon/gun/projectile/heavysniper,\
				prob(1);/obj/item/weapon/plastique,\
				prob(1);/obj/item/weapon/gun/energy/ionrifle,\
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
/obj/random/ammo_all/item_to_spawn()
	return pick(prob(5);/obj/item/ammo_magazine/ammo_box/b12g,\
				prob(5);/obj/item/ammo_magazine/ammo_box/b12g/pellet,\
				prob(5);/obj/item/ammo_magazine/clip/c762,\
				prob(5);/obj/item/ammo_magazine/m380,\
				prob(5);/obj/item/ammo_magazine/m45,\
				prob(5);/obj/item/ammo_magazine/m9mm,\
				prob(5);/obj/item/ammo_magazine/s38,\
				prob(4);/obj/item/ammo_magazine/clip/c45,\
				prob(4);/obj/item/ammo_magazine/clip/c9mm,\
				prob(4);/obj/item/ammo_magazine/m45uzi,\
				prob(4);/obj/item/ammo_magazine/m9mml,\
				prob(4);/obj/item/ammo_magazine/m9mmt,\
				prob(4);/obj/item/ammo_magazine/m9mmp90,\
				prob(4);/obj/item/ammo_magazine/m10mm,\
				prob(4);/obj/item/ammo_magazine/m545/small,\
				prob(3);/obj/item/ammo_magazine/clip/c44,\
				prob(3);/obj/item/ammo_magazine/ammo_box/b10mm/emp,\
				prob(3);/obj/item/ammo_magazine/ammo_box/b10mm,\
				prob(3);/obj/item/ammo_magazine/s44,\
				prob(3);/obj/item/ammo_magazine/m762,\
				prob(3);/obj/item/ammo_magazine/m545,\
				prob(3);/obj/item/weapon/cell/device/weapon,\
				prob(2);/obj/item/ammo_magazine/m44,\
				prob(2);/obj/item/ammo_magazine/s357,\
				prob(2);/obj/item/ammo_magazine/m762/ext,\
				prob(2);/obj/item/ammo_magazine/clip/c12g,
				prob(2);/obj/item/ammo_magazine/clip/c12g/pellet,\
				prob(1);/obj/item/ammo_magazine/m45tommy,\
			/*	prob(1);/obj/item/ammo_magazine/m95,\ */
				prob(1);/obj/item/ammo_casing/rocket,\
				prob(1);/obj/item/ammo_magazine/ammo_box/b145,\
				prob(1);/obj/item/ammo_magazine/ammo_box/b12g/flash,\
				prob(1);/obj/item/ammo_magazine/ammo_box/b12g/beanbag,\
				prob(1);/obj/item/ammo_magazine/ammo_box/b12g/stunshell,\
				prob(1);/obj/item/ammo_magazine/mtg,\
				prob(1);/obj/item/ammo_magazine/m12gdrum,\
				prob(1);/obj/item/ammo_magazine/m12gdrum/pellet,\
				prob(1);/obj/item/ammo_magazine/m45tommydrum
				)

/obj/random/cargopod
	name = "Random Cargo Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 0

/obj/random/cargopod/item_to_spawn()
	return pick(prob(10);/obj/item/poster,\
				prob(8);/obj/item/weapon/haircomb,\
				prob(6);/obj/item/weapon/storage/pill_bottle/paracetamol,\
				prob(6);/obj/item/weapon/material/butterflyblade,\
				prob(6);/obj/item/weapon/material/butterflyhandle,\
				prob(4);/obj/item/weapon/storage/pill_bottle/happy,\
				prob(4);/obj/item/weapon/storage/pill_bottle/zoom,\
				prob(4);/obj/item/weapon/material/butterfly,\
				prob(2);/obj/item/weapon/material/butterfly/switchblade,\
				prob(2);/obj/item/clothing/gloves/knuckledusters,\
				prob(2);/obj/item/weapon/reagent_containers/syringe/drugs,\
				prob(1);/obj/item/weapon/material/knife/tacknife,\
				prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,\
				prob(1);/obj/item/weapon/beartrap,\
				prob(1);/obj/item/weapon/handcuffs,\
				prob(1);/obj/item/weapon/handcuffs/legcuffs,\
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

/obj/random/outside_mob
	name = "Random Mob"
	desc = "Eek!"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	spawn_nothing_percentage = 10
	var/faction = "wild animal"

/obj/random/outside_mob/item_to_spawn() // Special version for mobs to have the same faction.
	return pick(
				prob(50);/mob/living/simple_mob/animal/passive/gaslamp,
//				prob(50);/mob/living/simple_mob/otie/feral, // Removed until Otie code is unfucked.
				prob(20);/mob/living/simple_mob/vore/aggressive/dino/virgo3b,
				prob(1);/mob/living/simple_mob/vore/aggressive/dragon/virgo3b)

/obj/random/outside_mob/spawn_item()
	. = ..()
	if(istype(., /mob/living/simple_mob))
		var/mob/living/simple_mob/this_mob = .
		this_mob.faction = src.faction
		if (this_mob.minbodytemp > 200) // Temporary hotfix. Eventually I'll add code to change all mob vars to fit the environment they are spawned in.
			this_mob.minbodytemp = 200
		//wander the mobs around so they aren't always in the same spots
		var/turf/T = null
		for(var/i = 1 to 20)
			T = get_step_rand(this_mob) || T
		if(T)
			this_mob.forceMove(T)

//Just overriding this here, no more super medkit so those can be reserved for PoIs and such
/obj/random/tetheraid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit. Does not include Combat Kits."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"

/obj/random/tetheraid/item_to_spawn()
	return pick(prob(4);/obj/item/weapon/storage/firstaid/regular,
				prob(3);/obj/item/weapon/storage/firstaid/toxin,
				prob(3);/obj/item/weapon/storage/firstaid/o2,
				prob(2);/obj/item/weapon/storage/firstaid/adv,
				prob(3);/obj/item/weapon/storage/firstaid/fire)

//Override from maintenance.dm to prevent combat kits from spawning in Tether maintenance
/obj/random/maintenance/item_to_spawn()
	return pick(prob(300);/obj/random/tech_supply,
				prob(200);/obj/random/medical,
				prob(100);/obj/random/tetheraid,
				prob(10);/obj/random/contraband,
				prob(50);/obj/random/action_figure,
				prob(50);/obj/random/plushie,
				prob(200);/obj/random/junk,
				prob(200);/obj/random/material,
				prob(50);/obj/random/toy,
				prob(100);/obj/random/tank,
				prob(50);/obj/random/soap,
				prob(60);/obj/random/drinkbottle,
				prob(500);/obj/random/maintenance/clean)

/obj/random/action_figure/supplypack
	drop_get_turf = FALSE

/obj/random/roguemineloot
	name = "Random Rogue Mines Item"
	desc = "Hot Stuff. Hopefully"
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"
	spawn_nothing_percentage = 0

/obj/random/roguemineloot/item_to_spawn()
	return pick(prob(5);/obj/random/mre,
				prob(5);/obj/random/maintenance,
				prob(4);/obj/random/firstaid,
				prob(3);/obj/random/toolbox,
				prob(2);/obj/random/multiple/minevault,
				prob(1);/obj/random/coin,
				prob(1);/obj/random/drinkbottle,
				prob(1);/obj/random/tool/alien)