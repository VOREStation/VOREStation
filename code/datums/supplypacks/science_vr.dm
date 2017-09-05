/datum/supply_packs/sci/some_robolimbs
	name = "Basic Robolimb Blueprints"
	contains = list(
			/obj/item/weapon/disk/limb/morpheus,
			/obj/item/weapon/disk/limb/xion,
			/obj/item/weapon/disk/limb/talon
			)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "Basic Robolimb Blueprint Crate"
	access = access_robotics

/datum/supply_packs/sci/all_robolimbs
	name = "Advanced Robolimb Blueprints"
	contains = list(
			/obj/item/weapon/disk/limb/bishop,
			/obj/item/weapon/disk/limb/hephaestus,
			/obj/item/weapon/disk/limb/morpheus,
			/obj/item/weapon/disk/limb/veymed,
			/obj/item/weapon/disk/limb/wardtakahashi,
			/obj/item/weapon/disk/limb/xion,
			/obj/item/weapon/disk/limb/zenghu,
			/obj/item/weapon/disk/limb/talon,
			/obj/item/weapon/disk/limb/dsi_tajaran,
			/obj/item/weapon/disk/limb/dsi_lizard,
			/obj/item/weapon/disk/limb/dsi_sergal,
			/obj/item/weapon/disk/limb/dsi_nevrean,
			/obj/item/weapon/disk/limb/dsi_vulpkanin,
			/obj/item/weapon/disk/limb/dsi_akula,
			/obj/item/weapon/disk/limb/dsi_spider,
			/obj/item/weapon/disk/limb/eggnerdltd
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Advanced Robolimb Blueprint Crate"
	access = access_robotics
/*
/datum/supply_packs/sci/dune_buggy
	name = "Exploration Dune Buggy"
	contains = list(
			/obj/vehicle/train/rover/engine/dunebuggy
			)
	cost = 100
	containertype = /obj/structure/largecrate
	containername = "Exploration Dune Buggy Crate"
*/
/datum/supply_packs/sci/pred
	name = "Dangerous Predator crate"
	cost = 40
	containertype = /obj/structure/largecrate/animal/pred
	containername = "Dangerous Predator crate"
	access = access_xenobiology

/datum/supply_packs/sci/pred_doom
	name = "EXTREMELY Dangerous Predator crate"
	cost = 200
	containertype = /obj/structure/largecrate/animal/dangerous
	containername = "EXTREMELY Dangerous Predator crate"
	access = access_xenobiology
	contraband = 1

/* Removed until Otie code is unfucked.
/datum/supply_packs/sci/otie
	name = "V.A.R.M.A.corp adoptable reject (Dangerous!)"
	cost = 100
	containertype = /obj/structure/largecrate/animal/otie
	containername = "V.A.R.M.A.corp adoptable reject (Dangerous!)"
	access = access_xenobiology
*/
