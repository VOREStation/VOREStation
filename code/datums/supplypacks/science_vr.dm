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
			/obj/item/weapon/disk/limb/talon
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Advanced Robolimb Blueprint Crate"
	access = access_robotics

/datum/supply_packs/sci/dune_buggy
	name = "Exploration Dune Buggy"
	contains = list(
			/obj/vehicle/train/rover/engine/dunebuggy
			)
	cost = 100
	containertype = /obj/structure/largecrate
	containername = "Exploration Dune Buggy Crate"