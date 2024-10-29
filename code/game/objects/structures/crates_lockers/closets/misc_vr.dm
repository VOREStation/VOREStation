/*
 * Closets for Virgo
 * Contains:
 *		Gun Cabinets
 *		Explorer
 *		Pathfinder
 *		SAR/Field Medic
 *		Pilot/Navigator
 *		Exotic Seeds
 *		Autolok Suit
 *		Emergency Suit (Wall)
 *
 */

/*
 * Gun Cabinets
 */
/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "emergency weapon cabinet"
	req_one_access = list(access_armory,access_captain)

	starts_with = list(
		/obj/item/gun/energy/gun = 4)

/obj/structure/closet/secure_closet/guncabinet/rifle
	name = "rifle cabinet"
	req_one_access = list(access_brig)

	starts_with = list(
		/obj/item/ammo_magazine/clip/c762/hunter = 9,
		/obj/item/gun/projectile/shotgun/pump/rifle = 2)

/obj/structure/closet/secure_closet/guncabinet/rifle/Initialize()
	if(prob(85))
		starts_with += /obj/item/gun/projectile/shotgun/pump/rifle
	else
		starts_with += /obj/item/gun/projectile/shotgun/pump/rifle/lever
	return ..()

/obj/structure/closet/secure_closet/guncabinet/phase
	name = "away team weapon cabinet"
	req_one_access = list(access_brig)

	starts_with = list(
		/obj/item/gun/energy/phasegun = 2,
		/obj/item/gun/energy/phasegun/pistol,
		/obj/item/cell/device/weapon = 2,
		/obj/item/clothing/accessory/permit/gun/planetside)

/*
 * Explorer
 */
/obj/structure/closet/secure_closet/explorer
	name = "away team locker"
	req_access = list(access_explorer)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/explorer

	starts_with = list(
		/obj/item/clothing/under/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/storage/belt/explorer,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/explorer,
		/obj/item/radio/headset/explorer/alt,
		/obj/item/cartridge/explorer,
		/obj/item/flashlight,
		/obj/item/gps/explorer,
		/obj/item/storage/box/flare,
		/obj/item/geiger,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/material/knife/tacknife/survival,
		/obj/item/material/knife/machete,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/reagent_containers/food/snacks/liquidfood,
		/obj/item/reagent_containers/food/snacks/liquidprotein,
		/obj/item/cataloguer)

/obj/structure/closet/secure_closet/explorer/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/explorer
	else
		starts_with += /obj/item/storage/backpack/satchel/explorer
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/explorer
	return ..()

/*
 * Pathfinder
 */
/obj/structure/closet/secure_closet/pathfinder
	name = "pathfinder locker"
	req_access = list(access_explorer)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/pathfinder

	starts_with = list(
		/obj/item/clothing/under/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/storage/belt/explorer/pathfinder,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/pathfinder,
		/obj/item/radio/headset/pathfinder/alt,
		/obj/item/cartridge/explorer,
		/obj/item/flashlight,
		/obj/item/gps/explorer,
		/obj/item/storage/box/flare,
		/obj/item/storage/box/explorerkeys,
		/obj/item/geiger,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/material/knife/tacknife/survival,
		/obj/item/material/knife/machete/deluxe,
		/obj/item/clothing/accessory/holster/machete,
		/obj/random/explorer_shield,
		/obj/item/reagent_containers/food/snacks/liquidfood,
		/obj/item/reagent_containers/food/snacks/liquidprotein,
		/obj/item/cataloguer/compact/pathfinder,
		/obj/item/mapping_unit)

/obj/structure/closet/secure_closet/pathfinder/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	return ..()

/*
 * SAR/Field Medic
 */
/obj/structure/closet/secure_closet/sar
	name = "field medic locker"
	desc = "Supplies for a wilderness first responder."
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/sar

	starts_with = list(
		/obj/item/storage/backpack/dufflebag/emt,
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/reagent_containers/glass/bottle/antitoxin,
		/obj/item/storage/belt/medical/emt,
		/obj/item/material/knife/tacknife/survival,
		/obj/item/gun/energy/locked/frontier/holdout,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer/medic,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/radio/headset/sar,
		/obj/item/radio/headset/sar/alt,
		/obj/item/cartridge/sar,
		/obj/item/flashlight,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/healthanalyzer,
		/obj/item/radio/off,
		/obj/random/medical,
		/obj/item/reagent_containers/food/snacks/liquidfood = 2,
		/obj/item/reagent_containers/food/snacks/liquidprotein = 2,
		/obj/item/tool/crowbar,
		/obj/item/extinguisher/mini,
		/obj/item/storage/box/freezer,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/taperoll/medical,
		/obj/item/gps/medical,
		/obj/item/geiger,
		/obj/item/bodybag/cryobag,
		/obj/item/cataloguer/compact)

/obj/structure/closet/secure_closet/sar/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/medic
	else
		starts_with += /obj/item/storage/backpack/satchel/med
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/med
	return ..()

/*
 * Pilot/Navigator
 */
/obj/structure/closet/secure_closet/pilot
	name = "pilot locker"
	req_access = list(access_pilot)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/pilot

	starts_with = list(
		/obj/item/storage/backpack/parachute,
		/obj/item/material/knife/tacknife/survival,
		/obj/item/clothing/head/pilot_vr,
		/obj/item/clothing/under/rank/pilot1/no_webbing,
		/obj/item/clothing/suit/storage/toggle/bomber/pilot,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/radio/headset/pilot,
		/obj/item/radio/headset/pilot/alt,
		/obj/item/flashlight,
		/obj/item/reagent_containers/food/snacks/liquidfood,
		/obj/item/reagent_containers/food/snacks/liquidprotein,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle,
		/obj/item/storage/box/flare,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/gps/explorer,
		/obj/item/gun/energy/gun/protector/pilotgun/locked,
		/obj/item/clothing/accessory/watch/survival,
		/obj/item/clothing/accessory/storage/webbing/pilot1,
		/obj/item/clothing/accessory/storage/webbing/pilot2,
		/obj/item/emergency_beacon
		)

/obj/structure/closet/secure_closet/pilot/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	return ..()

/*
 * Exotic Seeds
 */
/obj/structure/closet/crate/hydroponics/exotic
	name = "exotic seeds crate"
	desc = "All you need to destroy that pesky planet."

	starts_with = list(
		/obj/item/seeds/random = 6,
		/obj/item/seeds/replicapod = 2,
		/obj/item/seeds/ambrosiavulgarisseed = 2,
		/obj/item/seeds/kudzuseed,
		/obj/item/seeds/libertymycelium,
		/obj/item/seeds/reishimycelium)

/*
 * Autolok Suit
 */
/obj/structure/closet/autolok_wall
	name = "autolok suit storage"
	desc = "It's wall-mounted storage unit for an AutoLok suit."
	icon = 'icons/obj/closets/bases/wall_double.dmi'
	closet_appearance = /decl/closet_appearance/wall_double/autolok
	open_sound = 'sound/machines/click.ogg'
	close_sound = 'sound/machines/click.ogg'
	anchored = TRUE
	density = FALSE
	wall_mounted = 1
	store_mobs = 0

	starts_with = list(
		/obj/item/clothing/suit/space/void/autolok,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/suit_cooling_unit/emergency
	)

/*
 * Emergency Suit (Wall)
 */
/obj/structure/closet/emergsuit_wall
	name = "emergency suit storage"
	desc = "It's wall-mounted storage unit for an emergency suit."
	icon = 'icons/obj/closets/bases/wall.dmi'
	closet_appearance = /decl/closet_appearance/wall/emergency
	open_sound = 'sound/machines/click.ogg'
	close_sound = 'sound/machines/click.ogg'
	anchored = TRUE
	density = FALSE
	wall_mounted = 1
	store_mobs = 0

	starts_with = list(
		/obj/item/clothing/head/helmet/space/emergency,
		/obj/item/clothing/suit/space/emergency,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/suit_cooling_unit/emergency
	)
