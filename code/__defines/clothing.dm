/*
Originally, every piece of clothing defined it's own allowed pocket items.
This was a realm of chaos, that lead to many similar pieces of clothing
being unable to hold the same items. Now there are defines for classes
of pocket types that hold a wide variety of items, shared between clothing.

These are a bit weird to wrap your head around, because it's not possible to
add lists together when defining an item... We instead need to provides the
contents that should be IN the list, and then wrap these macros in a list()

ex: allowed = list(POCKET_GENERIC, POCKET_CULT)
NOTICE: Do not leave trailing commas!!!!
*/

#define POCKET_GENERIC \
	/obj/item/pen, \
	/obj/item/paper, \
	/obj/item/book, \
	/obj/item/flashlight, \
	/obj/item/storage/fancy/cigarettes, \
	/obj/item/storage/box/matches, \
	/obj/item/reagent_containers/food/drinks/flask, \
	/obj/item/toy, \
	/obj/item/cell, \
	/obj/item/spacecash, \
	/obj/item/clothing/head/soft, \
	/obj/item/taperoll, \
	/obj/item/analyzer, \
	/obj/item/reagent_scanner, \
	/obj/item/healthanalyzer, \
	/obj/item/robotanalyzer, \
	/obj/item/analyzer/plant_analyzer, \
	/obj/item/geiger, \
	/obj/item/mass_spectrometer, \
	/obj/item/cataloguer, \
	/obj/item/universal_translator, \
	/obj/item/clipboard, \
	/obj/item/measuring_tape, \
	/obj/item/lightreplacer

#define POCKET_EMERGENCY \
	/obj/item/tank/emergency, \
	/obj/item/tool/prybar, \
	/obj/item/radio, \
	/obj/item/gps, \
	/obj/item/clothing/mask/gas, \
	/obj/item/spaceflare

#define POCKET_ALL_TANKS \
	/obj/item/tank

#define POCKET_STORAGE \
	/obj/item/storage

#define POCKET_SUIT_REGULATORS \
	/obj/item/suit_cooling_unit

#define POCKET_CULT \
	/obj/item/melee/cultblade

#define POCKET_SECURITY \
	/obj/item/gun, \
	/obj/item/ammo_magazine, \
	/obj/item/ammo_casing, \
	/obj/item/melee, \
	/obj/item/material/knife, \
	/obj/item/reagent_containers/spray/pepper, \
	/obj/item/handcuffs, \
	/obj/item/clothing/head/helmet, \
	/obj/item/grenade, \
	/obj/item/flash, \
	/obj/item/hailer, \
	/obj/item/holowarrant, \
	/obj/item/megaphone

#define POCKET_EXPLO \
	/obj/item/gun, \
	/obj/item/ammo_magazine, \
	/obj/item/ammo_casing, \
	/obj/item/melee, \
	/obj/item/material/knife, \
	/obj/item/stack/marker_beacon, \
	/obj/item/beacon_locator, \
	/obj/item/stack/flag

#define POCKET_MERC \
	/obj/item/powersink, \
	/obj/item/radio_jammer

#define POCKET_SLEUTH \
	/obj/item/reagent_containers/food/snacks/candy_corn, \
	/obj/item/pen

#define POCKET_MINING \
	/obj/item/storage/excavation, \
	/obj/item/storage/briefcase/inflatable, \
	/obj/item/storage/bag/ore, \
	/obj/item/pickaxe, \
	/obj/item/shovel, \
	/obj/item/stack/marker_beacon, \
	/obj/item/beacon_locator, \
	/obj/item/stack/flag

#define POCKET_DETECTIVE \
	/obj/item/taperecorder, \
	/obj/item/uv_light, \
	/obj/item/camera_film, \
	/obj/item/camera

#define POCKET_MEDICAL \
	/obj/item/reagent_containers/hypospray, \
	/obj/item/stack/medical, \
	/obj/item/dnainjector, \
	/obj/item/reagent_containers/dropper, \
	/obj/item/reagent_containers/syringe, \
	/obj/item/reagent_containers/glass/bottle, \
	/obj/item/reagent_containers/glass/beaker, \
	/obj/item/reagent_containers/pill, \
	/obj/item/storage/pill_bottle

#define POCKET_SURGERY \
	/obj/item/surgical/scalpel, \
	/obj/item/surgical/retractor, \
	/obj/item/surgical/hemostat, \
	/obj/item/surgical/cautery, \
	/obj/item/surgical/bonegel, \
	/obj/item/surgical/FixOVein

#define POCKET_ENGINEERING \
	/obj/item/storage/briefcase/inflatable, \
	/obj/item/t_scanner, \
	/obj/item/multitool, \
	/obj/item/pipe_painter, \
	/obj/item/clothing/head/hardhat

#define POCKET_HEAVYTOOLS \
	/obj/item/rcd, \
	/obj/item/weldingtool, \
	/obj/item/tool/crowbar, \
	/obj/item/tool/screwdriver, \
	/obj/item/tool/wirecutters, \
	/obj/item/tool/wrench, \
	/obj/item/reagent_containers/hypospray, \
	/obj/item/roller

#define POCKET_HYDROPONICS \
	/obj/item/reagent_containers/spray/plantbgone, \
	/obj/item/seeds, \
	/obj/item/reagent_containers/glass/bottle, \
	/obj/item/material/minihoe

#define POCKET_WIZARD \
	/obj/item/teleportation_scroll

#define POCKET_CE \
	/obj/item/storage/toolbox, \
	/obj/item/rcd, \
	/obj/item/rcd_ammo

#define POCKET_XENOARC \
	/obj/item/ano_scanner, \
	/obj/item/depth_scanner, \
	/obj/item/xenoarch_multi_tool, \
	/obj/item/tool/crowbar, \
	/obj/item/storage/bag/fossils, \
	/obj/item/core_sampler

#define POCKET_BAYSUIT \
	/obj/item/storage/backpack, \
	/obj/item/bluespaceradio, \
	/obj/item/defib_kit
