/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything


// creates a new object and deletes itself
/obj/random/New()
	..()
	spawn()
		if(istype(src.loc, /obj/structure/loot_pile)) //Spawning from a lootpile is weird, need to wait until we're out of it to do our work.
			while(istype(src.loc, /obj/structure/loot_pile))
				sleep(1)
		if (!prob(spawn_nothing_percentage))
			spawn_item()
		qdel(src)


// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0


// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()

	var/atom/A = new build_path(src.loc)
	if(pixel_x || pixel_y)
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y


/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start"
	icon_state = "x3"
	var/spawn_object = null

/obj/random/single/item_to_spawn()
	return ispath(spawn_object) ? spawn_object : text2path(spawn_object)


/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"

/obj/random/tool/item_to_spawn()
	return pick(/obj/item/weapon/screwdriver,
				/obj/item/weapon/wirecutters,
				/obj/item/weapon/weldingtool,
				/obj/item/weapon/weldingtool/largetank,
				/obj/item/weapon/crowbar,
				/obj/item/weapon/wrench,
				/obj/item/device/flashlight,
				/obj/item/device/multitool)

/obj/random/tool/power
	name = "random powertool"
	desc = "This is a random powertool"
	icon_state = "jaws_pry"

/obj/random/tool/power/item_to_spawn()
	return pick(/obj/item/weapon/screwdriver/power,
				/obj/item/weapon/wirecutters/power,
				/obj/item/weapon/weldingtool/electric,
				/obj/item/weapon/weldingtool/experimental)

/obj/random/tool/alien
	name = "random alien tool"
	desc = "This is a random tool"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "welder"

/obj/random/tool/alien/item_to_spawn()
	return pick(/obj/item/weapon/screwdriver/alien,
				/obj/item/weapon/wirecutters/alien,
				/obj/item/weapon/weldingtool/alien,
				/obj/item/weapon/crowbar/alien,
				/obj/item/weapon/wrench/alien,
				/obj/item/stack/cable_coil/alien,
				/obj/item/device/multitool/alien)

/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"

/obj/random/technology_scanner/item_to_spawn()
	return pick(prob(5);/obj/item/device/t_scanner,
				prob(2);/obj/item/device/radio,
				prob(5);/obj/item/device/analyzer)

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"

/obj/random/powercell/item_to_spawn()
	return pick(prob(40);/obj/item/weapon/cell,
				prob(25);/obj/item/weapon/cell/device,
				prob(25);/obj/item/weapon/cell/high,
				prob(9);/obj/item/weapon/cell/super,
				prob(1);/obj/item/weapon/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"

/obj/random/bomb_supply/item_to_spawn()
	return pick(/obj/item/device/assembly/igniter,
				/obj/item/device/assembly/prox_sensor,
				/obj/item/device/assembly/signaler,
				/obj/item/device/assembly/timer,
				/obj/item/device/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"

/obj/random/toolbox/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/toolbox/mechanical,
				prob(6);/obj/item/weapon/storage/toolbox/electrical,
				prob(2);/obj/item/weapon/storage/toolbox/emergency,
				prob(1);/obj/item/weapon/storage/toolbox/syndicate)


/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 25

/obj/random/tech_supply/item_to_spawn()
	return pick(prob(3);/obj/random/powercell,
				prob(2);/obj/random/technology_scanner,
				prob(1);/obj/item/weapon/packageWrap,
				prob(2);/obj/random/bomb_supply,
				prob(1);/obj/item/weapon/extinguisher,
				prob(1);/obj/item/clothing/gloves/fyellow,
				prob(3);/obj/item/stack/cable_coil/random,
				prob(2);/obj/random/toolbox,
				prob(2);/obj/item/weapon/storage/belt/utility,
				prob(1);/obj/item/weapon/storage/belt/utility/full,
				prob(5);/obj/random/tool,
				prob(2);/obj/item/weapon/tape_roll,
				prob(2);/obj/item/taperoll/engineering,
				prob(1);/obj/item/taperoll/atmos,
				prob(1);/obj/item/device/flashlight/maglight)

/obj/random/tech_supply/component
	name = "random tech component"
	desc = "This is a random machine component."
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_analyzer"

/obj/random/tech_supply/component/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/stock_parts/gear,
		prob(2);/obj/item/weapon/stock_parts/console_screen,
		prob(1);/obj/item/weapon/stock_parts/spring,
		prob(3);/obj/item/weapon/stock_parts/capacitor,
		prob(2);/obj/item/weapon/stock_parts/capacitor/adv,
		prob(1);/obj/item/weapon/stock_parts/capacitor/super,
		prob(3);/obj/item/weapon/stock_parts/manipulator,
		prob(2);/obj/item/weapon/stock_parts/manipulator/nano,
		prob(1);/obj/item/weapon/stock_parts/manipulator/pico,
		prob(3);/obj/item/weapon/stock_parts/matter_bin,
		prob(2);/obj/item/weapon/stock_parts/matter_bin/adv,
		prob(1);/obj/item/weapon/stock_parts/matter_bin/super,
		prob(3);/obj/item/weapon/stock_parts/scanning_module,
		prob(2);/obj/item/weapon/stock_parts/scanning_module/adv,
		prob(1);/obj/item/weapon/stock_parts/scanning_module/phasic)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "traumakit"

/obj/random/medical/item_to_spawn()
	return pick(prob(21);/obj/random/medical/lite,
				prob(5);/obj/random/medical/pillbottle,
				prob(1);/obj/item/weapon/storage/pill_bottle/tramadol,
				prob(1);/obj/item/weapon/storage/pill_bottle/antitox,
				prob(1);/obj/item/weapon/storage/pill_bottle/carbon,
				prob(3);/obj/item/bodybag/cryobag,
				prob(5);/obj/item/weapon/reagent_containers/syringe/antitoxin,
				prob(3);/obj/item/weapon/reagent_containers/syringe/antiviral,
				prob(5);/obj/item/weapon/reagent_containers/syringe/inaprovaline,
				prob(1);/obj/item/weapon/reagent_containers/hypospray,
				prob(1);/obj/item/weapon/storage/box/freezer,
				prob(2);/obj/item/stack/nanopaste)

/obj/random/medical/pillbottle
	name = "Random Pill Bottle"
	desc = "This is a random pill bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill_canister"

/obj/random/medical/pillbottle/item_to_spawn()
	return pick(prob(1);/obj/item/weapon/storage/pill_bottle/spaceacillin,
				prob(1);/obj/item/weapon/storage/pill_bottle/dermaline,
				prob(1);/obj/item/weapon/storage/pill_bottle/dexalin_plus,
				prob(1);/obj/item/weapon/storage/pill_bottle/bicaridine,
				prob(1);/obj/item/weapon/storage/pill_bottle/iron)

/obj/random/medical/lite
	name = "Random Medicine"
	desc = "This is a random simple medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25

/obj/random/medical/lite/item_to_spawn()
	return pick(prob(4);/obj/item/stack/medical/bruise_pack,
				prob(4);/obj/item/stack/medical/ointment,
				prob(2);/obj/item/stack/medical/advanced/bruise_pack,
				prob(2);/obj/item/stack/medical/advanced/ointment,
				prob(1);/obj/item/stack/medical/splint,
				prob(4);/obj/item/device/healthanalyzer,
				prob(1);/obj/item/bodybag,
				prob(3);/obj/item/weapon/reagent_containers/hypospray/autoinjector,
				prob(2);/obj/item/weapon/storage/pill_bottle/kelotane,
				prob(2);/obj/item/weapon/storage/pill_bottle/antitox)

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"

/obj/random/firstaid/item_to_spawn()
	return pick(prob(4);/obj/item/weapon/storage/firstaid/regular,
				prob(3);/obj/item/weapon/storage/firstaid/toxin,
				prob(3);/obj/item/weapon/storage/firstaid/o2,
				prob(2);/obj/item/weapon/storage/firstaid/adv,
				prob(3);/obj/item/weapon/storage/firstaid/fire,
				prob(1);/obj/item/weapon/storage/firstaid/combat)

/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 50

//VOREStation Edit - Changed items in this list drastically.
/obj/random/contraband/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/pill_bottle/tramadol,
				//prob(8);/obj/item/weapon/haircomb,
				prob(4);/obj/item/weapon/storage/pill_bottle/happy,
				prob(4);/obj/item/weapon/storage/pill_bottle/zoom,
				//prob(10);/obj/item/weapon/contraband/poster,
				prob(4);/obj/item/weapon/material/butterfly,
				//prob(6);/obj/item/weapon/material/butterflyblade,
				//prob(6);/obj/item/weapon/material/butterflyhandle,
				//prob(6);/obj/item/weapon/material/wirerod,
				prob(2);/obj/item/weapon/material/butterfly/switchblade,
				prob(2);/obj/item/clothing/gloves/knuckledusters,
				prob(1);/obj/item/weapon/material/knife/tacknife,
				prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,
				prob(1);/obj/item/weapon/beartrap,
				prob(1);/obj/item/weapon/handcuffs/fuzzy,
				prob(1);/obj/item/weapon/handcuffs/legcuffs/fuzzy,
				prob(2);/obj/item/weapon/reagent_containers/syringe/drugs,
				prob(1);/obj/item/weapon/reagent_containers/syringe/steroid,
				prob(4);/obj/item/device/radio_jammer,
				prob(2);/obj/item/weapon/storage/box/syndie_kit/spy,
				prob(2);/obj/item/weapon/grenade/anti_photon)

/obj/random/soap
	name = "Random Soap"
	desc = "This is a random bar of soap."
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"

/obj/random/soap/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/soap,
				prob(2);/obj/item/weapon/soap/nanotrasen,
				prob(2);/obj/item/weapon/soap/deluxe,
				prob(1);/obj/item/weapon/soap/syndie,)


/obj/random/drinkbottle
	name = "random drink"
	desc = "This is a random drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"

/obj/random/drinkbottle/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/gin,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/wine,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/patron)

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


/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"

/obj/random/action_figure/item_to_spawn()
	return pick(/obj/item/toy/figure/cmo,
				/obj/item/toy/figure/assistant,
				/obj/item/toy/figure/atmos,
				/obj/item/toy/figure/bartender,
				/obj/item/toy/figure/borg,
				/obj/item/toy/figure/gardener,
				/obj/item/toy/figure/captain,
				/obj/item/toy/figure/cargotech,
				/obj/item/toy/figure/ce,
				/obj/item/toy/figure/chaplain,
				/obj/item/toy/figure/chef,
				/obj/item/toy/figure/chemist,
				/obj/item/toy/figure/clown,
				/obj/item/toy/figure/corgi,
				/obj/item/toy/figure/detective,
				/obj/item/toy/figure/dsquad,
				/obj/item/toy/figure/engineer,
				/obj/item/toy/figure/geneticist,
				/obj/item/toy/figure/hop,
				/obj/item/toy/figure/hos,
				/obj/item/toy/figure/qm,
				/obj/item/toy/figure/janitor,
				/obj/item/toy/figure/agent,
				/obj/item/toy/figure/librarian,
				/obj/item/toy/figure/md,
				/obj/item/toy/figure/mime,
				/obj/item/toy/figure/miner,
				/obj/item/toy/figure/ninja,
				/obj/item/toy/figure/wizard,
				/obj/item/toy/figure/rd,
				/obj/item/toy/figure/roboticist,
				/obj/item/toy/figure/scientist,
				/obj/item/toy/figure/syndie,
				/obj/item/toy/figure/secofficer,
				/obj/item/toy/figure/warden,
				/obj/item/toy/figure/psychologist,
				/obj/item/toy/figure/paramedic,
				/obj/item/toy/figure/ert)

/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"

/obj/random/plushie/item_to_spawn()
	return pick(/obj/structure/plushie/ian,
				/obj/structure/plushie/drone,
				/obj/structure/plushie/carp,
				/obj/structure/plushie/beepsky,
				/obj/item/toy/plushie/nymph,
				/obj/item/toy/plushie/mouse,
				/obj/item/toy/plushie/kitten,
				/obj/item/toy/plushie/lizard)

/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	desc = "This is some random junk."
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag3"

/obj/random/junk/item_to_spawn()
	return get_random_junk_type()

/obj/random/trash //Mostly remains and cleanable decals. Stuff a janitor could clean up
	name = "random trash"
	desc = "This is some random trash."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/random/trash/item_to_spawn()
	return pick(/obj/effect/decal/remains/lizard,
				/obj/effect/decal/cleanable/blood/gibs/robot,
				/obj/effect/decal/cleanable/blood/oil,
				/obj/effect/decal/cleanable/blood/oil/streak,
				/obj/effect/decal/cleanable/spiderling_remains,
				/obj/effect/decal/remains/mouse,
				/obj/effect/decal/cleanable/vomit,
				/obj/effect/decal/cleanable/blood/splatter,
				/obj/effect/decal/cleanable/ash,
				/obj/effect/decal/cleanable/generic,
				/obj/effect/decal/cleanable/flour,
				/obj/effect/decal/cleanable/dirt,
				/obj/effect/decal/remains/robot)

/obj/random/obstruction //Large objects to block things off in maintenance
	name = "random obstruction"
	desc = "This is a random obstruction."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultgirder"

/obj/random/obstruction/item_to_spawn()
	return pick(/obj/structure/barricade,
				/obj/structure/girder,
				/obj/structure/girder/displaced,
				/obj/structure/girder/reinforced,
				/obj/structure/grille,
				/obj/structure/grille/broken,
				/obj/structure/foamedmetal,
				/obj/structure/inflatable,
				/obj/structure/inflatable/door)

/obj/random/material //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal"

/obj/random/material/item_to_spawn()
	return pick(/obj/item/stack/material/steel{amount = 10},
				/obj/item/stack/material/glass{amount = 10},
				/obj/item/stack/material/glass/reinforced{amount = 10},
				/obj/item/stack/material/plastic{amount = 10},
				/obj/item/stack/material/wood{amount = 10},
				/obj/item/stack/material/cardboard{amount = 10},
				/obj/item/stack/rods{amount = 10},
				/obj/item/stack/material/plasteel{amount = 10})

/obj/random/toy
	name = "random toy"
	desc = "This is a random toy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"

/obj/random/toy/item_to_spawn()
	return pick(/obj/item/toy/bosunwhistle,
				/obj/item/toy/plushie/therapy/red,
				/obj/item/toy/plushie/therapy/purple,
				/obj/item/toy/plushie/therapy/blue,
				/obj/item/toy/plushie/therapy/yellow,
				/obj/item/toy/plushie/therapy/orange,
				/obj/item/toy/plushie/therapy/green,
				/obj/item/toy/cultsword,
				/obj/item/toy/katana,
				/obj/item/toy/snappop,
				/obj/item/toy/sword,
				/obj/item/toy/balloon,
				/obj/item/toy/crossbow,
				/obj/item/toy/blink,
				/obj/item/toy/waterflower,
				/obj/item/toy/prize/ripley,
				/obj/item/toy/prize/fireripley,
				/obj/item/toy/prize/deathripley,
				/obj/item/toy/prize/gygax,
				/obj/item/toy/prize/durand,
				/obj/item/toy/prize/honk,
				/obj/item/toy/prize/marauder,
				/obj/item/toy/prize/seraph,
				/obj/item/toy/prize/mauler,
				/obj/item/toy/prize/odysseus,
				/obj/item/toy/prize/phazon)

/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"

/obj/random/tank/item_to_spawn()
	return pick(prob(5);/obj/item/weapon/tank/oxygen,
				prob(4);/obj/item/weapon/tank/oxygen/yellow,
				prob(4);/obj/item/weapon/tank/oxygen/red,
				prob(3);/obj/item/weapon/tank/air,
				prob(4);/obj/item/weapon/tank/emergency/oxygen,
				prob(3);/obj/item/weapon/tank/emergency/oxygen/engi,
				prob(2);/obj/item/weapon/tank/emergency/oxygen/double,
				prob(1);/obj/item/device/suit_cooling_unit)

/obj/random/cigarettes
	name = "random cigarettes"
	desc = "This is a cigarette."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"

/obj/random/cigarettes/item_to_spawn()
	return pick(prob(5);/obj/item/weapon/storage/fancy/cigarettes,
				prob(4);/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/killthroat,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/luckystars,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/jerichos,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/menthols,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/carcinomas,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/professionals,
				prob(1);/obj/item/weapon/storage/fancy/cigar,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/havana)

/obj/random/maintenance //Clutter and loot for maintenance and away missions
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/item_to_spawn()
	return pick(prob(300);/obj/random/tech_supply,
				prob(200);/obj/random/medical,
				prob(100);/obj/random/firstaid,
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

/obj/random/maintenance/clean
/*Maintenance loot lists without the trash, for use inside things.
Individual items to add to the maintenance list should go here, if you add
something, make sure it's not in one of the other lists.*/
	name = "random clean maintenance item"
	desc = "This is a random clean maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/clean/item_to_spawn()
	return pick(prob(10);/obj/random/contraband,
				prob(2);/obj/item/device/flashlight/flare,
				prob(2);/obj/item/device/flashlight/glowstick,
				prob(2);/obj/item/device/flashlight/glowstick/blue,
				prob(1);/obj/item/device/flashlight/glowstick/orange,
				prob(1);/obj/item/device/flashlight/glowstick/red,
				prob(1);/obj/item/device/flashlight/glowstick/yellow,
				prob(1);/obj/item/device/flashlight/pen,
				prob(4);/obj/item/weapon/cell,
				prob(4);/obj/item/weapon/cell/device,
				prob(3);/obj/item/weapon/cell/high,
				prob(2);/obj/item/weapon/cell/super,
				prob(5);/obj/random/cigarettes,
				prob(3);/obj/item/clothing/mask/gas,
				prob(2);/obj/item/clothing/mask/gas/half,
				prob(4);/obj/item/clothing/mask/breath,
				prob(2);/obj/item/weapon/reagent_containers/glass/rag,
				prob(4);/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
				prob(2);/obj/item/weapon/storage/secure/briefcase,
				prob(4);/obj/item/weapon/storage/briefcase,
				prob(5);/obj/item/weapon/storage/backpack,
				prob(5);/obj/item/weapon/storage/backpack/satchel/norm,
				prob(4);/obj/item/weapon/storage/backpack/satchel,
				prob(3);/obj/item/weapon/storage/backpack/dufflebag,
				prob(1);/obj/item/weapon/storage/backpack/dufflebag/syndie,
				prob(5);/obj/item/weapon/storage/box,
				prob(3);/obj/item/weapon/storage/box/donkpockets,
				prob(2);/obj/item/weapon/storage/box/sinpockets,
				prob(1);/obj/item/weapon/storage/box/cups,
				prob(3);/obj/item/weapon/storage/box/mousetraps,
				prob(3);/obj/item/weapon/storage/wallet,
				prob(1);/obj/item/device/paicard,
				prob(2);/obj/item/clothing/shoes/galoshes,
				prob(1);/obj/item/clothing/shoes/syndigaloshes,
				prob(4);/obj/item/clothing/shoes/black,
				prob(4);/obj/item/clothing/shoes/laceup,
				prob(4);/obj/item/clothing/shoes/black,
				prob(4);/obj/item/clothing/shoes/leather,
				prob(1);/obj/item/clothing/gloves/yellow,
				prob(3);/obj/item/clothing/gloves/botanic_leather,
				prob(2);/obj/item/clothing/gloves/sterile/latex,
				prob(5);/obj/item/clothing/gloves/white,
				prob(5);/obj/item/clothing/gloves/rainbow,
				prob(2);/obj/item/clothing/gloves/fyellow,
				prob(1);/obj/item/clothing/glasses/sunglasses,
				prob(3);/obj/item/clothing/glasses/meson,
				prob(2);/obj/item/clothing/glasses/meson/prescription,
				prob(1);/obj/item/clothing/glasses/welding,
				prob(1);/obj/item/clothing/head/bio_hood/general,
				prob(4);/obj/item/clothing/head/hardhat,
				prob(3);/obj/item/clothing/head/hardhat/red,
				prob(1);/obj/item/clothing/head/ushanka,
				prob(2);/obj/item/clothing/head/welding,
				prob(4);/obj/item/clothing/suit/storage/hazardvest,
				prob(1);/obj/item/clothing/suit/space/emergency,
				prob(3);/obj/item/clothing/suit/storage/toggle/bomber,
				prob(1);/obj/item/clothing/suit/bio_suit/general,
				prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/black,
				prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/blue,
				prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/red,
				prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/yellow,
				prob(3);/obj/item/clothing/suit/storage/toggle/brown_jacket,
				prob(3);/obj/item/clothing/suit/storage/toggle/leather_jacket,
				prob(1);/obj/item/clothing/suit/storage/vest/press,
				prob(3);/obj/item/clothing/suit/storage/apron,
				prob(4);/obj/item/clothing/under/color/grey,
				prob(2);/obj/item/clothing/under/syndicate/tacticool,
				prob(2);/obj/item/clothing/under/pants/camo,
				prob(1);/obj/item/clothing/under/harness,
				prob(1);/obj/item/clothing/under/tactical,
				prob(3);/obj/item/clothing/accessory/storage/webbing,
				prob(4);/obj/item/weapon/spacecash/c1,
				prob(3);/obj/item/weapon/spacecash/c10,
				prob(3);/obj/item/weapon/spacecash/c20,
				prob(1);/obj/item/weapon/spacecash/c50,
				prob(1);/obj/item/weapon/spacecash/c100,
				prob(3);/obj/item/weapon/camera_assembly,
				prob(4);/obj/item/weapon/caution,
				prob(3);/obj/item/weapon/caution/cone,
				prob(1);/obj/item/weapon/card/emag_broken,
				prob(2);/obj/item/device/camera,
				prob(3);/obj/item/device/pda,
				prob(3);/obj/item/device/radio/headset)

/obj/random/maintenance/security
/*Maintenance loot list. This one is for around security areas*/
	name = "random security maintenance item"
	desc = "This is a random security maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/security/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(2);/obj/item/device/flashlight/maglight,
				prob(2);/obj/item/device/flash,
				prob(1);/obj/item/weapon/cell/device/weapon,
				prob(1);/obj/item/clothing/mask/gas/swat,
				prob(1);/obj/item/clothing/mask/gas/syndicate,
				prob(2);/obj/item/clothing/mask/balaclava,
				prob(1);/obj/item/clothing/mask/balaclava/tactical,
				prob(3);/obj/item/weapon/storage/backpack/security,
				prob(3);/obj/item/weapon/storage/backpack/satchel/sec,
				prob(2);/obj/item/weapon/storage/backpack/messenger/sec,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/sec,
				prob(1);/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo,
				prob(1);/obj/item/weapon/storage/backpack/dufflebag/syndie/med,
				prob(2);/obj/item/weapon/storage/box/swabs,
				prob(2);/obj/item/weapon/storage/belt/security,
				prob(1);/obj/item/weapon/grenade/flashbang,
				prob(1);/obj/item/weapon/melee/baton,
				prob(1);/obj/item/weapon/reagent_containers/spray/pepper,
				prob(3);/obj/item/clothing/shoes/boots/jackboots,
				prob(1);/obj/item/clothing/shoes/boots/swat,
				prob(1);/obj/item/clothing/shoes/boots/combat,
				prob(1);/obj/item/clothing/gloves/swat,
				prob(1);/obj/item/clothing/gloves/combat,
				prob(1);/obj/item/clothing/glasses/sunglasses/big,
				prob(2);/obj/item/clothing/glasses/hud/security,
				prob(1);/obj/item/clothing/glasses/sunglasses/sechud,
				prob(1);/obj/item/clothing/glasses/sunglasses/sechud/aviator,
				prob(1);/obj/item/clothing/glasses/sunglasses/sechud/tactical,
				prob(3);/obj/item/clothing/head/beret/sec,
				prob(3);/obj/item/clothing/head/beret/sec/corporate/officer,
				prob(3);/obj/item/clothing/head/beret/sec/navy/officer,
				prob(2);/obj/item/clothing/head/helmet,
				prob(4);/obj/item/clothing/head/soft/sec,
				prob(4);/obj/item/clothing/head/soft/sec/corp,
				prob(3);/obj/item/clothing/suit/armor/vest,
				prob(2);/obj/item/clothing/suit/armor/vest/security,
				prob(2);/obj/item/clothing/suit/storage/vest/officer,
				prob(1);/obj/item/clothing/suit/storage/vest/detective,
				prob(1);/obj/item/clothing/suit/storage/vest/press,
				prob(2);/obj/item/clothing/accessory/storage/black_vest,
				prob(2);/obj/item/clothing/accessory/storage/black_drop_pouches,
				prob(1);/obj/item/clothing/accessory/holster/leg,
				prob(1);/obj/item/clothing/accessory/holster/hip,
				prob(1);/obj/item/clothing/accessory/holster/waist,
				prob(1);/obj/item/clothing/accessory/holster/armpit,
				prob(2);/obj/item/clothing/ears/earmuffs,
				prob(2);/obj/item/weapon/handcuffs,)

/obj/random/maintenance/medical
/*Maintenance loot list. This one is for around medical areas*/
	name = "random medical maintenance item"
	desc = "This is a random medical maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/medical/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(25);/obj/random/medical/lite,
				prob(2);/obj/item/clothing/mask/breath/medical,
				prob(2);/obj/item/clothing/mask/surgical,
				prob(5);/obj/item/weapon/storage/backpack/medic,
				prob(5);/obj/item/weapon/storage/backpack/satchel/med,
				prob(5);/obj/item/weapon/storage/backpack/messenger/med,
				prob(3);/obj/item/weapon/storage/backpack/dufflebag/med,
				prob(1);/obj/item/weapon/storage/backpack/dufflebag/syndie/med,
				prob(2);/obj/item/weapon/storage/box/autoinjectors,
				prob(3);/obj/item/weapon/storage/box/beakers,
				prob(2);/obj/item/weapon/storage/box/bodybags,
				prob(3);/obj/item/weapon/storage/box/syringes,
				prob(3);/obj/item/weapon/storage/box/gloves,
				prob(2);/obj/item/weapon/storage/belt/medical/emt,
				prob(2);/obj/item/weapon/storage/belt/medical,
				prob(1);/obj/item/clothing/shoes/boots/combat,
				prob(3);/obj/item/clothing/shoes/white,
				prob(2);/obj/item/clothing/gloves/sterile/nitrile,
				prob(5);/obj/item/clothing/gloves/white,
				prob(2);/obj/item/clothing/glasses/hud/health,
				prob(1);/obj/item/clothing/glasses/hud/health/prescription,
				prob(1);/obj/item/clothing/head/bio_hood/virology,
				prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,
				prob(1);/obj/item/clothing/suit/bio_suit/general,
				prob(2);/obj/item/clothing/under/rank/medical/paramedic,
				prob(2);/obj/item/clothing/accessory/storage/black_vest,
				prob(2);/obj/item/clothing/accessory/storage/white_vest,
				prob(1);/obj/item/clothing/accessory/storage/white_drop_pouches,
				prob(1);/obj/item/clothing/accessory/storage/black_drop_pouches,
				prob(2);/obj/item/clothing/accessory/stethoscope)

/obj/random/maintenance/engineering
/*Maintenance loot list. This one is for around medical areas*/
	name = "random engineering maintenance item"
	desc = "This is a random engineering maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/engineering/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(2);/obj/item/device/flashlight/maglight,
				prob(3);/obj/item/clothing/mask/gas/half,
				prob(2);/obj/item/clothing/mask/balaclava,
				prob(2);/obj/item/weapon/storage/briefcase/inflatable,
				prob(5);/obj/item/weapon/storage/backpack/industrial,
				prob(5);/obj/item/weapon/storage/backpack/satchel/eng,
				prob(5);/obj/item/weapon/storage/backpack/messenger/engi,
				prob(3);/obj/item/weapon/storage/backpack/dufflebag/eng,
				prob(5);/obj/item/weapon/storage/box,
				prob(2);/obj/item/weapon/storage/belt/utility/full,
				prob(3);/obj/item/weapon/storage/belt/utility,
				prob(3);/obj/item/clothing/head/beret/engineering,
				prob(3);/obj/item/clothing/head/soft/yellow,
				prob(2);/obj/item/clothing/head/orangebandana,
				prob(2);/obj/item/clothing/head/hardhat/dblue,
				prob(2);/obj/item/clothing/head/hardhat/orange,
				prob(1);/obj/item/clothing/glasses/welding,
				prob(2);/obj/item/clothing/head/welding,
				prob(4);/obj/item/clothing/suit/storage/hazardvest,
				prob(2);/obj/item/clothing/under/overalls,
				prob(3);/obj/item/clothing/shoes/boots/workboots,
				prob(1);/obj/item/clothing/shoes/magboots,
				prob(2);/obj/item/clothing/accessory/storage/black_vest,
				prob(2);/obj/item/clothing/accessory/storage/brown_vest,
				prob(1);/obj/item/clothing/accessory/storage/brown_drop_pouches,
				prob(3);/obj/item/clothing/ears/earmuffs,
				prob(1);/obj/item/weapon/beartrap,
				prob(2);/obj/item/weapon/handcuffs)

/obj/random/maintenance/research
/*Maintenance loot list. This one is for around medical areas*/
	name = "random research maintenance item"
	desc = "This is a random research maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/research/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(3);/obj/item/device/analyzer/plant_analyzer,
				prob(1);/obj/item/device/flash/synthetic,
				prob(2);/obj/item/weapon/bucket_sensor,
				prob(1);/obj/item/weapon/cell/device/weapon,
				prob(5);/obj/item/weapon/storage/backpack/toxins,
				prob(5);/obj/item/weapon/storage/backpack/satchel/tox,
				prob(5);/obj/item/weapon/storage/backpack/messenger/tox,
				prob(2);/obj/item/weapon/storage/excavation,
				prob(1);/obj/item/weapon/storage/backpack/holding,
				prob(3);/obj/item/weapon/storage/box/beakers,
				prob(3);/obj/item/weapon/storage/box/syringes,
				prob(3);/obj/item/weapon/storage/box/gloves,
				prob(2);/obj/item/clothing/gloves/sterile/latex,
				prob(4);/obj/item/clothing/glasses/science,
				prob(3);/obj/item/clothing/glasses/material,
				prob(1);/obj/item/clothing/head/beret/purple,
				prob(1);/obj/item/clothing/head/bio_hood/scientist,
				prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,
				prob(4);/obj/item/clothing/suit/storage/toggle/labcoat/science,
				prob(1);/obj/item/clothing/suit/bio_suit/scientist,
				prob(4);/obj/item/clothing/under/rank/scientist,
				prob(2);/obj/item/clothing/under/rank/scientist_new)

/obj/random/maintenance/cargo
/*Maintenance loot list. This one is for around cargo areas*/
	name = "random cargo maintenance item"
	desc = "This is a random cargo maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/cargo/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(3);/obj/item/device/flashlight/lantern,
				prob(4);/obj/item/weapon/pickaxe,
				prob(5);/obj/item/weapon/storage/backpack/industrial,
				prob(5);/obj/item/weapon/storage/backpack/satchel/norm,
				prob(3);/obj/item/weapon/storage/backpack/dufflebag,
				prob(1);/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo,
				prob(1);/obj/item/weapon/storage/toolbox/syndicate,
				prob(1);/obj/item/weapon/storage/belt/utility/full,
				prob(2);/obj/item/weapon/storage/belt/utility,
				prob(4);/obj/item/device/toner,
				prob(1);/obj/item/device/destTagger,
				prob(3);/obj/item/clothing/glasses/material,
				prob(3);/obj/item/clothing/head/soft/yellow,
				prob(4);/obj/item/clothing/suit/storage/hazardvest,
				prob(3);/obj/item/clothing/suit/storage/apron/overalls,
				prob(4);/obj/item/clothing/suit/storage/apron,
				prob(2);/obj/item/clothing/under/syndicate/tacticool,
				prob(1);/obj/item/clothing/under/syndicate/combat,
				prob(2);/obj/item/clothing/accessory/storage/black_vest,
				prob(2);/obj/item/clothing/accessory/storage/brown_vest,
				prob(3);/obj/item/clothing/ears/earmuffs,
				prob(1);/obj/item/weapon/beartrap,
				prob(2);/obj/item/weapon/handcuffs,)

/obj/random/sfr
	name = "random SFR headset"
	desc = "This is a headset spawn."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/sfr/item_to_spawn()
	return pick(prob(25);/obj/item/device/radio/headset/heads/captain/sfr,
				prob(25);/obj/item/device/radio/headset/headset_cargo/alt,
				prob(25);/obj/item/device/radio/headset/headset_com/alt,
				prob(25);/obj/item/device/radio/headset)

/obj/random/coin
	name = "random coin"
	desc = "This is a coin spawn."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/coin/item_to_spawn()
	return pick(prob(5);/obj/item/weapon/coin/silver,
				prob(3);/obj/item/weapon/coin/iron,
				prob(4);/obj/item/weapon/coin/gold,
				prob(3);/obj/item/weapon/coin/phoron,
				prob(1);/obj/item/weapon/coin/uranium,
				prob(2);/obj/item/weapon/coin/platinum,
				prob(1);/obj/item/weapon/coin/diamond)

/obj/random/rigsuit
	name = "Random rigsuit"
	desc = "This is a random rigsuit."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"

/obj/random/rigsuit/item_to_spawn()
	return pick(prob(4);/obj/item/weapon/rig/light/hacker,
				prob(5);/obj/item/weapon/rig/industrial,
				prob(5);/obj/item/weapon/rig/eva,
				prob(4);/obj/item/weapon/rig/light/stealth,
				prob(3);/obj/item/weapon/rig/hazard,
				prob(1);/obj/item/weapon/rig/merc/empty)

/obj/random/landmine
	name = "Random Land Mine"
	desc = "This is a random land mine."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	spawn_nothing_percentage = 25

/obj/random/landmine/item_to_spawn()
	return pick(prob(30);/obj/effect/mine,
				prob(25);/obj/effect/mine/frag,
				prob(25);/obj/effect/mine/emp,
				prob(10);/obj/effect/mine/stun,
				prob(10);/obj/effect/mine/incendiary,)

var/list/random_junk_
var/list/random_useful_
/proc/get_random_useful_type()
	if(!random_useful_)
		random_useful_ = subtypesof(/obj/item/weapon/pen/crayon)
		random_useful_ += /obj/item/weapon/pen
		random_useful_ += /obj/item/weapon/pen/blue
		random_useful_ += /obj/item/weapon/pen/red
		random_useful_ += /obj/item/weapon/pen/multi
		random_useful_ += /obj/item/weapon/storage/box/matches
		random_useful_ += /obj/item/stack/material/cardboard
	return pick(random_useful_)

/proc/get_random_junk_type()
	if(prob(20)) // Misc. clutter
		return /obj/effect/decal/cleanable/generic
	if(prob(70)) // Misc. junk
		if(!random_junk_)
			random_junk_ = subtypesof(/obj/item/trash)
			random_junk_ += typesof(/obj/item/weapon/cigbutt)
			random_junk_ += /obj/effect/decal/cleanable/spiderling_remains
			random_junk_ += /obj/effect/decal/remains/mouse
			random_junk_ += /obj/effect/decal/remains/robot
			random_junk_ += /obj/item/weapon/paper/crumpled
			random_junk_ += /obj/item/inflatable/torn
			random_junk_ += /obj/effect/decal/cleanable/molten_item
			random_junk_ += /obj/item/weapon/material/shard

			random_junk_ -= /obj/item/trash/plate
			random_junk_ -= /obj/item/trash/snack_bowl
			random_junk_ -= /obj/item/trash/syndi_cakes
			random_junk_ -= /obj/item/trash/tray
		return pick(random_junk_)
	// Misc. actually useful stuff
	return get_random_useful_type()

/*
	Selects one spawn point out of a group of points with the same ID and asks it to generate its items
*/
var/list/multi_point_spawns

/obj/random_multi
	name = "random object spawn point"
	desc = "This item type is used to spawn random objects at round-start. Only one spawn point for a given group id is selected."
	icon = 'icons/misc/mark.dmi'
	icon_state = "x3"
	invisibility = INVISIBILITY_MAXIMUM
	var/id     // Group id
	var/weight // Probability weight for this spawn point

/obj/random_multi/initialize()
	. = ..()
	weight = max(1, round(weight))

	if(!multi_point_spawns)
		multi_point_spawns = list()
	var/list/spawnpoints = multi_point_spawns[id]
	if(!spawnpoints)
		spawnpoints = list()
		multi_point_spawns[id] = spawnpoints
	spawnpoints[src] = weight

/obj/random_multi/Destroy()
	var/list/spawnpoints = multi_point_spawns[id]
	spawnpoints -= src
	if(!spawnpoints.len)
		multi_point_spawns -= id
	. = ..()

/obj/random_multi/proc/generate_items()
	return

/obj/random_multi/single_item
	var/item_path  // Item type to spawn

/obj/random_multi/single_item/generate_items()
	//VOREStation Edit - Make this proc check for a closet and spawn in that. This happens after closets are init'd so otherwise it spawns on top
	var/obj/structure/closet/C = locate(/obj/structure/closet) in get_turf(src)
	if(C)
		new item_path(C)
	else
		new item_path(loc)

/hook/roundstart/proc/generate_multi_spawn_items()
	for(var/id in multi_point_spawns)
		var/list/spawn_points = multi_point_spawns[id]
		var/obj/random_multi/rm = pickweight(spawn_points)
		rm.generate_items()
		for(var/entry in spawn_points)
			qdel(entry)
	return 1

/obj/random_multi/single_item/captains_spare_id
	name = "Multi Point - Captain's Spare"
	id = "Captain's spare id"
	item_path = /obj/item/weapon/card/id/gold/captain/spare

/obj/random_multi/single_item/sfr_headset
	name = "Multi Point - headset"
	id = "SFR headset"
	item_path = /obj/random/sfr

//Multiple Object Spawn

/obj/random/multiple

/obj/random/multiple/spawn_item()
	var/list/things_to_make = item_to_spawn()
	for(var/new_type in things_to_make)
		new new_type(src.loc)

/obj/random/multiple/voidsuit
	name = "Random Voidsuit"
	desc = "This is a random voidsuit."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "void"

/obj/random/multiple/voidsuit/item_to_spawn()
	return pick(
			prob(5);list(
				/obj/item/clothing/suit/space/void,
				/obj/item/clothing/head/helmet/space/void
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/atmos,
				/obj/item/clothing/head/helmet/space/void/atmos
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/atmos/alt,
				/obj/item/clothing/head/helmet/space/void/atmos/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering,
				/obj/item/clothing/head/helmet/space/void/engineering
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering/alt,
				/obj/item/clothing/head/helmet/space/void/engineering/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering/construction,
				/obj/item/clothing/head/helmet/space/void/engineering/construction
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering/salvage,
				/obj/item/clothing/head/helmet/space/void/engineering/salvage
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical,
				/obj/item/clothing/head/helmet/space/void/medical
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical/alt,
				/obj/item/clothing/head/helmet/space/void/medical/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical/bio,
				/obj/item/clothing/head/helmet/space/void/medical/bio
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical/emt,
				/obj/item/clothing/head/helmet/space/void/medical/emt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/merc,
				/obj/item/clothing/head/helmet/space/void/merc
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/mining,
				/obj/item/clothing/head/helmet/space/void/mining
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/mining/alt,
				/obj/item/clothing/head/helmet/space/void/mining/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/security,
				/obj/item/clothing/head/helmet/space/void/security
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/security/alt,
				/obj/item/clothing/head/helmet/space/void/security/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/security/riot,
				/obj/item/clothing/head/helmet/space/void/security/riot
			)
		)

/obj/random/multiple/voidsuit/mining
	name = "Random Mining Voidsuit"
	desc = "This is a random mining voidsuit."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "rig-mining"

/obj/random/multiple/voidsuit/mining/item_to_spawn()
	return pick(
			prob(5);list(
				/obj/item/clothing/suit/space/void/mining,
				/obj/item/clothing/head/helmet/space/void/mining
			),
			prob(1);list(
				/obj/item/clothing/suit/space/void/mining/alt,
				/obj/item/clothing/head/helmet/space/void/mining/alt
			)
		)

/obj/random/multiple/minevault
	name = "random vault loot"
	desc = "Loot for mine vaults."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/multiple/minevault/item_to_spawn()
	return pick(
			prob(5);list(
				/obj/item/clothing/mask/smokable/pipe,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
				/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus,
				/obj/item/weapon/flame/lighter/zippo,
				/obj/structure/closet/crate/hydroponics
			),
			prob(5);list(
				/obj/item/weapon/pickaxe/drill,
				/obj/item/clothing/suit/space/void/mining,
				/obj/item/clothing/head/helmet/space/void/mining,
				/obj/structure/closet/crate/engineering
			),
			prob(5);list(
				/obj/item/weapon/pickaxe/drill,
				/obj/item/clothing/suit/space/void/mining/alt,
				/obj/item/clothing/head/helmet/space/void/mining/alt,
				/obj/structure/closet/crate/engineering
			),
			prob(5);list(
				/obj/item/weapon/reagent_containers/glass/beaker/bluespace,
				/obj/item/weapon/reagent_containers/glass/beaker/bluespace,
				/obj/item/weapon/reagent_containers/glass/beaker/bluespace,
				/obj/structure/closet/crate/science
			),
			prob(5);list(
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/structure/closet/crate/engineering
			),
			prob(5);list(
				/obj/item/weapon/pickaxe/drill,
				/obj/item/clothing/glasses/material,
				/obj/structure/ore_box,
				/obj/structure/closet/crate
			),
			prob(5);list(
				/obj/item/weapon/reagent_containers/glass/beaker/noreact,
				/obj/item/weapon/reagent_containers/glass/beaker/noreact,
				/obj/item/weapon/reagent_containers/glass/beaker/noreact,
				/obj/structure/closet/crate/science
			),
			prob(5);list(
				/obj/item/weapon/storage/secure/briefcase/money,
				/obj/structure/closet/crate/freezer/rations
			),
			prob(5);list(
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/item/clothing/accessory/tie/horrible,
				/obj/structure/closet/crate
			),
			prob(5);list(
				/obj/item/weapon/melee/baton,
				/obj/item/weapon/melee/baton,
				/obj/item/weapon/melee/baton,
				/obj/item/weapon/melee/baton,
				/obj/structure/closet/crate
			),
			prob(5);list(
				/obj/item/clothing/under/shorts/red,
				/obj/item/clothing/under/shorts/blue,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/weapon/melee/baton/cattleprod,
				/obj/item/weapon/melee/baton/cattleprod,
				/obj/item/weapon/cell/high,
				/obj/item/weapon/cell/high,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/latexballon,
				/obj/item/latexballon,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/toy/syndicateballoon,
				/obj/item/toy/syndicateballoon,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/weapon/rig/industrial/equipped,
				/obj/item/weapon/storage/bag/ore,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/clothing/head/kitty,
				/obj/item/clothing/head/kitty,
				/obj/item/clothing/head/kitty,
				/obj/item/clothing/head/kitty,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/random/coin,
				/obj/random/coin,
				/obj/random/coin,
				/obj/random/coin,
				/obj/random/coin,
				/obj/structure/closet/crate/plastic
			),
			prob(2);list(
				/obj/random/multiple/voidsuit,
				/obj/random/multiple/voidsuit,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/clothing/suit/space/syndicate/black/red,
				/obj/item/clothing/head/helmet/space/syndicate/black/red,
				/obj/item/clothing/suit/space/syndicate/black/red,
				/obj/item/clothing/head/helmet/space/syndicate/black/red,
				/obj/item/weapon/gun/projectile/automatic/mini_uzi,
				/obj/item/weapon/gun/projectile/automatic/mini_uzi,
				/obj/item/ammo_magazine/m45uzi,
				/obj/item/ammo_magazine/m45uzi,
				/obj/item/ammo_magazine/m45uzi/empty,
				/obj/item/ammo_magazine/m45uzi/empty,
				/obj/structure/closet/crate/plastic
			),
			prob(2);list(
				/obj/item/clothing/suit/ianshirt,
				/obj/item/clothing/suit/ianshirt,
				/obj/item/weapon/bedsheet/ian,
				/obj/structure/closet/crate/plastic
			),
			prob(2);list(
				/obj/item/clothing/suit/armor/vest,
				/obj/item/clothing/suit/armor/vest,
				/obj/item/weapon/gun/projectile/garand,
				/obj/item/weapon/gun/projectile/garand,
				/obj/item/ammo_magazine/m762garand,
				/obj/item/ammo_magazine/m762garand,
				/obj/structure/closet/crate/plastic
			),
			prob(2);list(
				/obj/mecha/working/ripley/mining
			),
			prob(2);list(
				/obj/mecha/working/hoverpod/combatpod
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/silver,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/drill,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/jackhammer,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/diamond,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/diamonddrill,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/gold,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/pickaxe/plasmacutter,
				/obj/item/weapon/storage/bag/ore,
				/obj/item/clothing/glasses/material,
				/obj/structure/closet/crate/engineering
			),
			prob(2);list(
				/obj/item/weapon/material/sword/katana,
				/obj/item/weapon/material/sword/katana,
				/obj/structure/closet/crate
			),
			prob(2);list(
				/obj/item/weapon/material/sword,
				/obj/item/weapon/material/sword,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/clothing/mask/balaclava,
				/obj/item/weapon/material/star,
				/obj/item/weapon/material/star,
				/obj/item/weapon/material/star,
				/obj/item/weapon/material/star,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weed_extract,
				/obj/item/xenos_claw,
				/obj/structure/closet/crate/science
			),
			prob(1);list(
				/obj/item/clothing/head/bearpelt,
				/obj/item/clothing/under/soviet,
				/obj/item/clothing/under/soviet,
				/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial,
				/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weapon/gun/projectile/revolver/detective,
				/obj/item/weapon/gun/projectile/contender,
				/obj/item/weapon/gun/projectile/p92x,
				/obj/item/weapon/gun/projectile/derringer,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weapon/melee/cultblade,
				/obj/item/clothing/suit/cultrobes,
				/obj/item/clothing/head/culthood,
				/obj/item/device/soulstone,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weapon/vampiric,
				/obj/item/weapon/vampiric,
				/obj/structure/closet/crate/science
			),
			prob(1);list(
				/obj/item/weapon/archaeological_find
			),
			prob(1);list(
				/obj/item/weapon/melee/energy/sword,
				/obj/item/weapon/melee/energy/sword,
				/obj/item/weapon/melee/energy/sword,
				/obj/item/weapon/shield/energy,
				/obj/item/weapon/shield/energy,
				/obj/structure/closet/crate/science
			),
			prob(1);list(
				/obj/item/weapon/storage/backpack/clown,
				/obj/item/clothing/under/rank/clown,
				/obj/item/clothing/shoes/clown_shoes,
				/obj/item/device/pda/clown,
				/obj/item/clothing/mask/gas/clown_hat,
				/obj/item/weapon/bikehorn,
				/obj/item/toy/waterflower,
				/obj/item/weapon/pen/crayon/rainbow,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/clothing/under/mime,
				/obj/item/clothing/shoes/black,
				/obj/item/device/pda/mime,
				/obj/item/clothing/gloves/white,
				/obj/item/clothing/mask/gas/mime,
				/obj/item/clothing/head/beret,
				/obj/item/clothing/suit/suspenders,
				/obj/item/weapon/pen/crayon/mime,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing,
				/obj/structure/closet/crate
			),
			prob(1);list(
				/obj/item/weapon/storage/belt/champion,
				/obj/item/clothing/mask/luchador,
				/obj/item/clothing/mask/luchador/rudos,
				/obj/item/clothing/mask/luchador/tecnicos,
				/obj/structure/closet/crate
			)
		)

/*
 * Random Mobs
 */

/obj/random/mob
	name = "Random Animal"
	desc = "This is a random animal."
	icon = 'icons/mob/animal.dmi'
	icon_state = "chicken_white"

/obj/random/mob/item_to_spawn()
	return pick(prob(10);/mob/living/simple_animal/lizard,
				prob(6);/mob/living/simple_animal/retaliate/diyaab,
				prob(10);/mob/living/simple_animal/cat/fluff,
				prob(6);/mob/living/simple_animal/cat/kitten,
				prob(10);/mob/living/simple_animal/corgi,
				prob(6);/mob/living/simple_animal/corgi/puppy,
				prob(10);/mob/living/simple_animal/crab,
				prob(10);/mob/living/simple_animal/chicken,
				prob(6);/mob/living/simple_animal/chick,
				prob(10);/mob/living/simple_animal/cow,
				prob(6);/mob/living/simple_animal/retaliate/goat,
				prob(10);/mob/living/simple_animal/penguin,
				prob(10);/mob/living/simple_animal/mouse,
				prob(10);/mob/living/simple_animal/yithian,
				prob(10);/mob/living/simple_animal/tindalos,
				prob(10);/mob/living/simple_animal/corgi/tamaskan,
				prob(3);/mob/living/simple_animal/parrot,
				prob(1);/mob/living/simple_animal/giant_crab)

/obj/random/mob/sif
	name = "Random Sif Animal"
	desc = "This is a random cold weather animal."
	icon_state = "penguin"

/obj/random/mob/sif/item_to_spawn()
	return pick(prob(30);/mob/living/simple_animal/retaliate/diyaab,
				prob(15);/mob/living/simple_animal/crab,
				prob(15);/mob/living/simple_animal/penguin,
				prob(15);/mob/living/simple_animal/mouse,
				prob(15);/mob/living/simple_animal/corgi/tamaskan,
				prob(2);/mob/living/simple_animal/hostile/giant_spider/frost,
				prob(1);/mob/living/simple_animal/hostile/goose,
				prob(20);/mob/living/simple_animal/giant_crab)

/obj/random/mob/sif/hostile
	name = "Random Hostile Sif Animal"
	desc = "This is a random hostile cold weather animal."
	icon_state = "frost"

/obj/random/mob/sif/hostile/item_to_spawn()
	return pick(prob(22);/mob/living/simple_animal/hostile/savik,
				prob(33);/mob/living/simple_animal/hostile/giant_spider/frost,
				prob(45);/mob/living/simple_animal/hostile/shantak)

/obj/random/mob/spider
	name = "Random Spider"
	desc = "This is a random boring spider."
	icon_state = "guard"

/obj/random/mob/spider/item_to_spawn()
	return pick(prob(22);/mob/living/simple_animal/hostile/giant_spider/nurse,
				prob(33);/mob/living/simple_animal/hostile/giant_spider/hunter,
				prob(45);/mob/living/simple_animal/hostile/giant_spider)

/obj/random/mob/spider/mutant
	name = "Random Mutant Spider"
	desc = "This is a random mutated spider."
	icon_state = "phoron"

/obj/random/mob/spider/mutant/item_to_spawn()
	return pick(prob(5);/obj/random/mob/spider,
				prob(10);/mob/living/simple_animal/hostile/giant_spider/webslinger,
				prob(10);/mob/living/simple_animal/hostile/giant_spider/carrier,
				prob(33);/mob/living/simple_animal/hostile/giant_spider/lurker,
				prob(33);/mob/living/simple_animal/hostile/giant_spider/tunneler,
				prob(40);/mob/living/simple_animal/hostile/giant_spider/pepper,
				prob(20);/mob/living/simple_animal/hostile/giant_spider/thermic,
				prob(40);/mob/living/simple_animal/hostile/giant_spider/electric,
				prob(1);/mob/living/simple_animal/hostile/giant_spider/phorogenic,
				prob(40);/mob/living/simple_animal/hostile/giant_spider/frost)

/obj/random/mob/robotic
	name = "Random Robot Mob"
	desc = "This is a random robot."
	icon_state = "drone_dead"

/obj/random/mob/robotic/item_to_spawn() //Hivebots have a total number of 'lots' equal to the lesser drone, at 60.
	return pick(prob(60);/mob/living/simple_animal/hostile/malf_drone/lesser,
				prob(50);/mob/living/simple_animal/hostile/malf_drone,
				prob(15);/mob/living/simple_animal/hostile/mecha/malf_drone,
				prob(10);/mob/living/simple_animal/hostile/hivebot,
				prob(15);/mob/living/simple_animal/hostile/hivebot/swarm,
				prob(10);/mob/living/simple_animal/hostile/hivebot/range,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/rapid,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/ion,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/laser,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/strong,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/guard)

/obj/random/mob/robotic/hivebot
	name = "Random Hivebot"
	desc = "This is a random hivebot."
	icon_state = "drone3"

/obj/random/mob/robotic/hivebot/item_to_spawn()
	return pick(prob(10);/mob/living/simple_animal/hostile/hivebot,
				prob(15);/mob/living/simple_animal/hostile/hivebot/swarm,
				prob(10);/mob/living/simple_animal/hostile/hivebot/range,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/rapid,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/ion,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/laser,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/strong,
				prob(5);/mob/living/simple_animal/hostile/hivebot/range/guard)
