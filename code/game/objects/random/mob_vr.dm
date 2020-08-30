/obj/random/weapon // For Gateway maps and Syndicate. Can possibly spawn almost any gun in the game.
	name = "Random Illegal Weapon"
	desc = "This is a random illegal weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "p08"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(/obj/random/ammo_all,\
					/obj/item/weapon/gun/energy/laser,\
					/obj/item/weapon/gun/projectile/pirate,\
					prob(90);/obj/item/weapon/material/twohanded/spear,\
					prob(90);/obj/item/weapon/gun/energy/stunrevolver,\
					prob(90);/obj/item/weapon/gun/energy/taser,\
					prob(90);/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet,\
					prob(90);/obj/item/weapon/material/knife,\
					prob(90);/obj/item/weapon/gun/projectile/luger,\
				/*	prob(90);/obj/item/weapon/gun/projectile/pipegun,\ */
					prob(90);/obj/item/weapon/gun/projectile/revolver/detective,\
					prob(90);/obj/item/weapon/gun/projectile/revolver/judge,\
					prob(90);/obj/item/weapon/gun/projectile/colt,\
					prob(90);/obj/item/weapon/gun/projectile/shotgun/pump,\
					prob(90);/obj/item/weapon/gun/projectile/shotgun/pump/rifle,\
					prob(90);/obj/item/weapon/melee/baton,\
					prob(90);/obj/item/weapon/melee/telebaton,\
					prob(90);/obj/item/weapon/melee/classic_baton,\
					prob(80);/obj/item/weapon/gun/projectile/automatic/wt550/lethal,\
					prob(80);/obj/item/weapon/gun/projectile/automatic/pdw,\
					prob(80);/obj/item/weapon/gun/projectile/automatic/sol, \
					prob(80);/obj/item/weapon/gun/energy/crossbow/largecrossbow,\
					prob(80);/obj/item/weapon/gun/projectile/pistol,\
					prob(80);/obj/item/weapon/gun/projectile/shotgun/pump,\
					prob(80);/obj/item/weapon/cane/concealed,\
					prob(80);/obj/item/weapon/gun/energy/gun,\
					prob(70);/obj/item/weapon/gun/energy/retro,\
					prob(70);/obj/item/weapon/gun/energy/gun/eluger,\
					prob(70);/obj/item/weapon/gun/energy/xray,\
					prob(70);/obj/item/weapon/gun/projectile/automatic/c20r,\
					prob(70);/obj/item/weapon/melee/energy/sword,\
					prob(70);/obj/item/weapon/gun/projectile/derringer,\
					prob(70);/obj/item/weapon/gun/projectile/revolver/lemat,\
				/*	prob(70);/obj/item/weapon/gun/projectile/shotgun/pump/rifle/mosin,\ */
				/*	prob(70);/obj/item/weapon/gun/projectile/automatic/m41a,\ */
					prob(60);/obj/item/weapon/material/butterfly,\
					prob(60);/obj/item/weapon/material/butterfly/switchblade,\
					prob(60);/obj/item/weapon/gun/projectile/giskard,\
					prob(60);/obj/item/weapon/gun/projectile/automatic/p90,\
					prob(60);/obj/item/weapon/gun/projectile/automatic/sts35,\
					prob(60);/obj/item/weapon/gun/projectile/shotgun/pump/combat,\
					prob(50);/obj/item/weapon/gun/energy/sniperrifle,\
					prob(50);/obj/item/weapon/gun/projectile/automatic/z8,\
					prob(50);/obj/item/weapon/gun/energy/captain,\
					prob(50);/obj/item/weapon/material/knife/tacknife,\
					prob(40);/obj/item/weapon/gun/projectile/shotgun/pump/USDF,\
					prob(40);/obj/item/weapon/gun/projectile/giskard/olivaw,\
					prob(40);/obj/item/weapon/gun/projectile/revolver/consul,\
					prob(40);/obj/item/weapon/gun/projectile/revolver/mateba,\
					prob(40);/obj/item/weapon/gun/projectile/revolver,\
					prob(30);/obj/item/weapon/gun/projectile/deagle,\
					prob(30);/obj/item/weapon/material/knife/tacknife/combatknife,\
					prob(30);/obj/item/weapon/melee/energy/sword,\
					prob(30);/obj/item/weapon/gun/projectile/automatic/mini_uzi,\
					prob(30);/obj/item/weapon/gun/projectile/contender,\
					prob(30);/obj/item/weapon/gun/projectile/contender/tacticool,\
					prob(20);/obj/item/weapon/gun/projectile/SVD,\
					prob(20);/obj/item/weapon/gun/energy/lasercannon,\
					prob(20);/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever,\
					prob(20);/obj/item/weapon/gun/projectile/automatic/bullpup,\
					prob(10);/obj/item/weapon/gun/energy/pulse_rifle,\
					prob(10);/obj/item/weapon/gun/energy/gun/nuclear,\
					prob(10);/obj/item/weapon/gun/projectile/automatic/l6_saw,\
					prob(10);/obj/item/weapon/gun/energy/gun/burst,\
					prob(10);/obj/item/weapon/storage/box/frags,\
					prob(10);/obj/item/weapon/twohanded/fireaxe,\
					prob(10);/obj/item/weapon/gun/projectile/luger/brown,\
					prob(10);/obj/item/weapon/gun/launcher/crossbow,\
				/*	prob(5);/obj/item/weapon/gun/projectile/automatic/battlerifle,\ */ // Too OP
					prob(5);/obj/item/weapon/gun/projectile/deagle/gold,\
					prob(5);/obj/item/weapon/gun/energy/imperial,\
					prob(5);/obj/item/weapon/gun/projectile/automatic/as24,\
					prob(5);/obj/item/weapon/gun/launcher/rocket,\
					prob(5);/obj/item/weapon/gun/launcher/grenade,\
					prob(5);/obj/item/weapon/gun/projectile/gyropistol,\
					prob(5);/obj/item/weapon/gun/projectile/heavysniper,\
					prob(5);/obj/item/weapon/plastique,\
					prob(5);/obj/item/weapon/gun/energy/ionrifle,\
					prob(5);/obj/item/weapon/material/sword,\
					prob(5);/obj/item/weapon/cane/concealed,\
					prob(5);/obj/item/weapon/material/sword/katana)

/obj/random/weapon/guarenteed
	spawn_nothing_percentage = 0

/obj/random/ammo_all
	name = "Random Ammunition (All)"
	desc = "This is random ammunition. Spawns all ammo types."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "666"
	item_to_spawn()
		return pick(/obj/item/weapon/storage/box/shotgunammo,\
					/obj/item/weapon/storage/box/shotgunshells,\
					/obj/item/ammo_magazine/clip/c762,\
					/obj/item/ammo_magazine/m380,\
					/obj/item/ammo_magazine/m45,\
					/obj/item/ammo_magazine/m9mm,\
					/obj/item/ammo_magazine/s38,\
					prob(80);/obj/item/ammo_magazine/clip/c45,\
					prob(80);/obj/item/ammo_magazine/clip/c9mm,\
					prob(80);/obj/item/ammo_magazine/m45uzi,\
					prob(80);/obj/item/ammo_magazine/m9mml,\
					prob(80);/obj/item/ammo_magazine/m9mmt,\
					prob(80);/obj/item/ammo_magazine/m9mmp90,\
					prob(80);/obj/item/ammo_magazine/m10mm,\
					prob(80);/obj/item/ammo_magazine/m545/small,\
					prob(60);/obj/item/ammo_magazine/clip/c10mm,\
					prob(60);/obj/item/ammo_magazine/clip/c44,\
					prob(60);/obj/item/ammo_magazine/s44,\
					prob(60);/obj/item/ammo_magazine/m762,\
					prob(60);/obj/item/ammo_magazine/m545,\
					prob(60);/obj/item/weapon/cell/device/weapon,\
					prob(40);/obj/item/ammo_magazine/m44,\
					prob(40);/obj/item/ammo_magazine/s357,\
					prob(40);/obj/item/ammo_magazine/m762m,\
					prob(40);/obj/item/ammo_magazine/clip/c12g,
					prob(40);/obj/item/ammo_magazine/clip/c12g/pellet,\
					prob(20);/obj/item/ammo_magazine/m45tommy,\
				/*	prob(20);/obj/item/ammo_magazine/m95,\ */
					prob(20);/obj/item/ammo_casing/rocket,\
					prob(20);/obj/item/weapon/storage/box/sniperammo,\
					prob(20);/obj/item/weapon/storage/box/flashshells,\
					prob(20);/obj/item/weapon/storage/box/beanbags,\
					prob(20);/obj/item/weapon/storage/box/stunshells,\
					prob(20);/obj/item/ammo_magazine/mtg,\
					prob(20);/obj/item/ammo_magazine/m12gdrum,\
					prob(20);/obj/item/ammo_magazine/m12gdrum/pellet,\
					prob(20);/obj/item/ammo_magazine/m45tommydrum
					)

/obj/random/cargopod
	name = "Random Cargo Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 0

/obj/random/cargopod/item_to_spawn()
	return pick(/obj/item/weapon/contraband/poster,\
				prob(80);/obj/item/weapon/haircomb,\
				prob(60);/obj/item/weapon/material/wirerod,\
				prob(60);/obj/item/weapon/storage/pill_bottle/paracetamol,\
				prob(60);/obj/item/weapon/material/butterflyblade,\
				prob(60);/obj/item/weapon/material/butterflyhandle,\
				prob(40);/obj/item/weapon/storage/pill_bottle/happy,\
				prob(40);/obj/item/weapon/storage/pill_bottle/zoom,\
				prob(40);/obj/item/weapon/material/butterfly,\
				prob(20);/obj/item/weapon/material/butterfly/switchblade,\
				prob(20);/obj/item/clothing/gloves/knuckledusters,\
				prob(20);/obj/item/weapon/reagent_containers/syringe/drugs,\
				prob(10);/obj/item/weapon/material/knife/tacknife,\
				prob(10);/obj/item/clothing/suit/storage/vest/heavy/merc,\
				prob(10);/obj/item/weapon/beartrap,\
				prob(10);/obj/item/weapon/handcuffs,\
				prob(10);/obj/item/weapon/handcuffs/legcuffs,\
				prob(10);/obj/item/weapon/reagent_containers/syringe/steroid)

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
	return pick(/obj/item/weapon/storage/firstaid/regular,
				prob(75);/obj/item/weapon/storage/firstaid/toxin,
				prob(75);/obj/item/weapon/storage/firstaid/o2,
				prob(75);/obj/item/weapon/storage/firstaid/fire,
				prob(50);/obj/item/weapon/storage/firstaid/adv
				)

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
	return pick(/obj/random/mre,
				/obj/random/maintenance,
				prob(80);/obj/random/firstaid,
				prob(60);/obj/random/toolbox,
				prob(40);/obj/random/multiple/minevault,
				prob(20);/obj/random/coin,
				prob(20);/obj/random/drinkbottle,
				prob(20);/obj/random/tool/alien)
