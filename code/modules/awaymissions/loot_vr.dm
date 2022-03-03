// Legacy version. Need to investigate what the hell lootdrop in loot.dm does later. -Ace
/obj/effect/landmark/loot_spawn
	name = "loot spawner"
	icon_state = "grabbed1"
	var/live_cargo = 1 // So you can turn off aliens.
	var/low_probability = 0
	var/spawned_faction = "hostile" // Spawned mobs can have their faction changed.


/obj/effect/landmark/loot_spawn/low
	name = "low prob loot spawner"
	icon_state = "grabbed"
	low_probability = 1

/obj/effect/landmark/loot_spawn/New()

	switch(pick( \
	low_probability * 1000;"nothing", \
	200 - low_probability * 175;"treasure", \
	25 + low_probability * 75;"remains", \
	50 + low_probability * 50;"clothes", \
	"glasses", \
	100 - low_probability * 50;"weapons", \
	100 - low_probability * 50;"spacesuit", \
	"health", \
	25 + low_probability * 75;"snacks", \
	/*25;"alien", \ */ //VORESTATION AI TEMPORARY REMOVAL
	"lights", \
	25 - low_probability * 25;"engineering", \
	25 - low_probability * 25;"coffin", \
	/*25;"mimic", \ //VORESTATION AI TEMPORARY REMOVAL
	25;"viscerator", \ */ //VORESTATION AI TEMPORARY REMOVAL
	))
		if("treasure")
			var/obj/structure/closet/crate/C = new(src.loc)
			if(prob(33))
				// Smuggled goodies.
				new /obj/item/stolenpackage(C)

			if(prob(33))
				//coins
				var/amount = rand(2,6)
				var/list/possible_spawns = list()
				for(var/coin_type in typesof(/obj/item/weapon/coin))
					possible_spawns += coin_type
				var/coin_type = pick(possible_spawns)
				for(var/i=0,i<amount,i++)
					new coin_type(C)

			else if(prob(50))
				//bars
				var/amount = rand(2,6)
				var/quantity = rand(10,50)
				var/list/possible_spawns = list()
				for(var/bar_type in typesof(/obj/item/stack/material) - /obj/item/stack/material - /obj/item/stack/animalhide - typesof(/obj/item/stack/material/cyborg))
					possible_spawns += bar_type

				var/bar_type = pick(possible_spawns)
				for(var/i=0,i<amount,i++)
					new bar_type(C, quantity)
			else
				//credits
				var/amount = rand(2,6)
				var/list/possible_spawns = list()
				for(var/cash_type in subtypesof(/obj/item/weapon/spacecash))
					possible_spawns += cash_type

				var/cash_type = pick(possible_spawns)
				for(var/i=0,i<amount,i++)
					new cash_type(C)
		if("remains")
			if(prob(50))
				new /obj/effect/decal/remains/human(src.loc)
			else if(prob(50))
				new /obj/effect/decal/remains/mouse(src.loc)
			else
				new /obj/effect/decal/remains/xeno(src.loc)
		if("clothes")
			var/obj/structure/closet/C = new(src.loc)
			if(prob(33))
				new /obj/item/clothing/under/color/rainbow(C)
				new /obj/item/clothing/shoes/rainbow(C)
				new /obj/item/clothing/head/soft/rainbow(C)
				new /obj/item/clothing/gloves/rainbow(C)
			else if(prob(5))
				new /obj/item/weapon/storage/box/syndie_kit/chameleon(C)
			else
				new /obj/item/clothing/under/syndicate/combat(C)
				new /obj/item/clothing/shoes/boots/swat(C)
				new /obj/item/clothing/gloves/swat(C)
				new /obj/item/clothing/mask/balaclava(C)
		if("glasses")
			var/obj/structure/closet/C = new(src.loc)
			var/new_type = pick(
			/obj/item/clothing/glasses/material,\
			/obj/item/clothing/glasses/thermal,\
			/obj/item/clothing/glasses/meson,\
			/obj/item/clothing/glasses/night,\
			/obj/item/clothing/glasses/hud/health)
			new new_type(C)
		if("weapons")
			var/obj/structure/closet/crate/secure/weapon/C = new(src.loc)
			if(prob(50))
				var/new_gun = pick( // Copied from Random.dm
					prob(11);/obj/random/ammo_all,\
					prob(11);/obj/item/weapon/gun/energy/laser,\
					prob(11);/obj/item/weapon/gun/projectile/pirate,\
					prob(10);/obj/item/weapon/material/twohanded/spear,\
					prob(10);/obj/item/weapon/gun/energy/stunrevolver,\
					prob(10);/obj/item/weapon/gun/energy/taser,\
					prob(10);/obj/item/weapon/gun/launcher/crossbow,\
					prob(10);/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet,\
					prob(10);/obj/item/weapon/material/knife,\
					prob(10);/obj/item/weapon/material/knife/tacknife/combatknife,\
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
				/*	prob(10);/obj/item/weapon/gun/projectile/shotgun/pump/rifle/mosin,\ */
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
					prob(7);/obj/item/weapon/gun/energy/captain,\
					prob(7);/obj/item/weapon/gun/energy/sniperrifle,\
					prob(7);/obj/item/weapon/gun/projectile/automatic/p90,\
					prob(7);/obj/item/weapon/gun/projectile/automatic/as24,\
					prob(7);/obj/item/weapon/gun/projectile/automatic/sts35,\
					prob(7);/obj/item/weapon/gun/projectile/automatic/z8,\
					prob(7);/obj/item/weapon/gun/energy/gun/burst,\
					prob(7);/obj/item/weapon/gun/projectile/shotgun/pump/USDF,\
					prob(7);/obj/item/weapon/gun/projectile/deagle,\
					prob(7);/obj/item/weapon/gun/launcher/grenade,\
				/*	prob(6);/obj/item/weapon/gun/projectile/SVD,\*/
					prob(6);/obj/item/weapon/gun/projectile/automatic/l6_saw,\
					prob(6);/obj/item/weapon/gun/energy/lasercannon,\
					prob(5);/obj/item/weapon/gun/projectile/automatic/bullpup,\
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
				new new_gun(C)
			if(prob(50))
				var/new_ammo = pick( // Copied from Random.dm
					prob(5);/obj/item/ammo_magazine/ammo_box/b12g,\
					prob(5);/obj/item/ammo_magazine/ammo_box/b12g/pellet,\
					prob(5);/obj/item/ammo_magazine/s357,\
					prob(5);/obj/item/ammo_magazine/clip/c762,\
					prob(5);/obj/item/ammo_magazine/m45,\
					prob(5);/obj/item/ammo_magazine/m45/rubber,\
					prob(5);/obj/item/ammo_magazine/s38,\
					prob(5);/obj/item/ammo_magazine/s38/rubber,\
					prob(5);/obj/item/weapon/storage/box/flashbangs,\
					prob(5);/obj/item/ammo_magazine/m545,\
					prob(4);/obj/item/ammo_magazine/clip/c545,\
					prob(4);/obj/item/ammo_magazine/clip/c45,\
					prob(4);/obj/item/ammo_magazine/clip/c9mm,\
					prob(4);/obj/item/ammo_magazine/m45uzi,\
					prob(4);/obj/item/ammo_magazine/m545/ext,\
					prob(4);/obj/item/ammo_magazine/m9mm,\
					prob(4);/obj/item/ammo_magazine/m9mml,\
					prob(4);/obj/item/ammo_magazine/m9mmt,\
					prob(4);/obj/item/ammo_magazine/m9mmt/rubber,\
					prob(4);/obj/item/ammo_magazine/m10mm,\
					prob(4);/obj/item/ammo_magazine/m9mmp90,\
					prob(4);/obj/item/ammo_magazine/m545/ext,
					prob(4);/obj/item/ammo_magazine/m762,\
					prob(4);/obj/item/ammo_magazine/ammo_box/b762/surplus/hunter,\
					prob(4);/obj/item/ammo_magazine/ammo_box/b762/surplus,\
					prob(4);/obj/item/ammo_magazine/m545/ext,\
					prob(3);/obj/item/ammo_magazine/ammo_box/b10mm/emp,\
					prob(3);/obj/item/ammo_magazine/ammo_box/b10mm,\
					prob(3);/obj/item/ammo_magazine/clip/c44,\
					prob(3);/obj/item/ammo_magazine/m545,\
					prob(2);/obj/item/ammo_magazine/m44,\
					prob(2);/obj/item/ammo_magazine/m545,\
					prob(1);/obj/item/weapon/storage/box/frags,\
				/*	prob(1);/obj/item/ammo_magazine/m95,\ */
					prob(1);/obj/item/ammo_casing/rocket,\
					prob(1);/obj/item/ammo_magazine/ammo_box/b145,\
					prob(1);/obj/item/ammo_magazine/ammo_box/b12g/flash,\
					prob(1);/obj/item/ammo_magazine/ammo_box/b12g/beanbag,\
					prob(1);/obj/item/ammo_magazine/ammo_box/b12g/practice,\
					prob(1);/obj/item/ammo_magazine/ammo_box/b12g/stunshell,\
					prob(1);/obj/item/ammo_magazine/ammo_box/b12g/blank,\
					prob(1);/obj/item/ammo_magazine/mtg,\
					prob(1);/obj/item/ammo_magazine/m45tommydrum,\
					prob(1);/obj/item/ammo_magazine/m45tommy)
				new new_ammo(C)
		if("spacesuit")
			var/obj/structure/closet/syndicate/C = new(src.loc)
			if(prob(25))
				new /obj/item/clothing/suit/space/syndicate/black(C)
				new /obj/item/clothing/head/helmet/space/syndicate/black(C)
				new /obj/item/weapon/tank/oxygen/red(C)
				new /obj/item/clothing/mask/breath(C)
			else if(prob(33))
				new /obj/item/clothing/suit/space/syndicate/blue(C)
				new /obj/item/clothing/head/helmet/space/syndicate/blue(C)
				new /obj/item/weapon/tank/oxygen/red(C)
				new /obj/item/clothing/mask/breath(C)
			else if(prob(50))
				new /obj/item/clothing/suit/space/syndicate/green(C)
				new /obj/item/clothing/head/helmet/space/syndicate/green(C)
				new /obj/item/weapon/tank/oxygen/red(C)
				new /obj/item/clothing/mask/breath(C)
			else
				new /obj/item/clothing/suit/space/syndicate/orange(C)
				new /obj/item/clothing/head/helmet/space/syndicate/orange(C)
				new /obj/item/weapon/tank/oxygen/red(C)
				new /obj/item/clothing/mask/breath(C)
		if("health")
			//hopefully won't be necessary, but there were an awful lot of hazards to get through...
			var/obj/structure/closet/crate/medical/C = new(src.loc)
			if(prob(50))
				new /obj/item/weapon/storage/firstaid/regular(C)
			if(prob(50))
				new /obj/item/weapon/storage/firstaid/fire(C)
			if(prob(50))
				new /obj/item/weapon/storage/firstaid/o2(C)
			if(prob(50))
				new /obj/item/weapon/storage/firstaid/toxin(C)
			if(prob(25))
				new /obj/item/weapon/storage/firstaid/combat(C)
			if(prob(25))
				new /obj/item/weapon/storage/firstaid/adv(C)
		if("snacks")
			//you're come so far, you must be in need of refreshment
			var/obj/structure/closet/crate/freezer/C = new(src.loc)
			var/num = rand(2,6)
			var/new_type = pick(
			/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer, \
			/obj/item/weapon/reagent_containers/food/drinks/tea, \
			/obj/item/weapon/reagent_containers/food/drinks/dry_ramen, \
			/obj/item/weapon/reagent_containers/food/snacks/candiedapple, \
			/obj/item/weapon/reagent_containers/food/snacks/chocolatebar, \
			/obj/item/weapon/reagent_containers/food/snacks/cookiesnack, \
			/obj/item/weapon/reagent_containers/food/snacks/meatball, \
			/obj/item/weapon/reagent_containers/food/snacks/plump_pie, \
			/obj/item/weapon/reagent_containers/food/snacks/liquidfood)
			for(var/i=0,i<num,i++)
				new new_type(C)
		if("alien")
			//ancient aliens
			var/obj/structure/closet/acloset/C = new(src.loc)
			if(prob(33))
				if(live_cargo) // Carp! Since Facehuggers got removed.
					var/num = rand(1,3)
					for(var/i=0,i<num,i++)
						new /mob/living/simple_mob/animal/space/carp(C)
				else // Just a costume.
					new /obj/item/clothing/suit/storage/hooded/costume/carp(C)
			else if(prob(50))
				if(live_cargo) // Something else very much alive and angry.
					var/spawn_type = pick(/mob/living/simple_mob/animal/space/alien, /mob/living/simple_mob/animal/space/alien/drone, /mob/living/simple_mob/animal/space/alien/sentinel)
					new spawn_type(C)
				else // Just a costume.
					new /obj/item/clothing/head/xenos(C)
					new /obj/item/clothing/suit/xenos(C)

			//33% chance of nothing

		if("lights")
			//flares, candles, matches
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc)
			var/num = rand(2,6)
			for(var/i=0,i<num,i++)
				var/spawn_type = pick(
					/obj/item/device/flashlight/flare, \
					/obj/item/weapon/flame/candle, \
					/obj/item/weapon/storage/box/matches, \
					/obj/item/device/flashlight/glowstick, \
					/obj/item/device/flashlight/glowstick/red, \
					/obj/item/device/flashlight/glowstick/blue, \
					/obj/item/device/flashlight/glowstick/orange, \
					/obj/item/device/flashlight/glowstick/yellow)
				new spawn_type(C)
		if("engineering")
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc)

			//chance to have any combination of up to two electrical/mechanical toolboxes and one cell
			if(prob(33))
				new /obj/item/weapon/storage/toolbox/electrical(C)
			else if(prob(50))
				new /obj/item/weapon/storage/toolbox/mechanical(C)

			if(prob(33))
				new /obj/item/weapon/storage/toolbox/mechanical(C)
			else if(prob(50))
				new /obj/item/weapon/storage/toolbox/electrical(C)

			if(prob(25))
				new /obj/item/weapon/cell(C)

		if("coffin")
			new /obj/structure/closet/coffin(src.loc)
			if(prob(33))
				new /obj/effect/decal/remains/human(src)
			else if(prob(50))
				new /obj/effect/decal/remains/xeno(src)
		if("mimic")
			//a guardian of the tomb!
			// var/mob/living/simple_mob/hostile/mimic/crate/mimic = new(src.loc)
			// mimic.faction = spawned_faction
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc) //VORESTATION AI TEMPORARY EDIT
			new /obj/item/weapon/storage/toolbox/electrical(C) //Placeholder to prevent errors. //VORESTATION AI TEMPORARY EDIT
		if("viscerator")
			//more tomb guardians!
			//var/num = rand(1,3) //VORESTATION AI TEMPORARY REMOVAL
			var/obj/structure/closet/crate/secure/gear/C = new(src.loc) //VORESTATION AI TEMPORARY EDIT
			new /obj/item/weapon/storage/toolbox/electrical(C) //Placeholder to prevent errors. //VORESTATION AI TEMPORARY EDIT
			//for(var/i=0,i<num,i++) //VORESTATION AI TEMPORARY REMOVAL
				//new /mob/living/simple_mob/hostile/viscerator(C)  //VORESTATION AI TEMPORARY REMOVAL

	qdel(src)


/**********************************/

/obj/structure/symbol
	anchored = TRUE
	layer = 3.5
	name = "strange symbol"
	icon = 'icons/obj/decals_vr.dmi'

/obj/structure/symbol/ca
	desc = "It looks like a skull, or maybe a crown."
	icon_state = "ca"

/obj/structure/symbol/da
	desc = "It looks like a lightning bolt."
	icon_state = "da"

/obj/structure/symbol/em
	desc = "It looks kind of like a cup. Specifically, a martini glass."
	icon_state = "em"

/obj/structure/symbol/es
	desc = "It looks like two horizontal lines, with a dotted line in the middle, like a highway, or race track."
	icon_state = "es"

/obj/structure/symbol/fe
	desc = "It looks like an arrow pointing upward. Maybe even a spade."
	icon_state = "fe"

/obj/structure/symbol/gu
	desc = "It looks like an unfolded square box from the top with a cross on it."
	icon_state = "gu"

/obj/structure/symbol/lo
	desc = "It looks like the letter 'Y' with an underline."
	icon_state = "lo"

/obj/structure/symbol/pr
	desc = "It looks like a box with a cross on it."
	icon_state = "pr"

/obj/structure/symbol/sa
	desc = "It looks like a right triangle with a dot to the side. It reminds you of a wooden strut between a wall and ceiling."
	icon_state = "sa"

/obj/structure/symbol/maint
	name = "maintenance panel"
	desc = "This sign suggests that the wall it's attached to can be opened somehow."
	icon_state = "maintenance_panel"