
/datum/supply_pack/misc/beltminer
	name = "Belt-miner gear crate"
	contains = list(
			/obj/item/weapon/gun/energy/particle = 2,
			/obj/item/weapon/cell/device/weapon = 2,
			/obj/item/weapon/storage/firstaid/regular = 1,
			/obj/item/device/gps = 2,
			/obj/item/weapon/storage/box/traumainjectors = 1,
			/obj/item/device/binoculars = 1
			)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Belt-miner gear crate"
	access = list(access_mining,
				  access_xenoarch)
	one_access = TRUE

/datum/supply_pack/misc/eva_rig
	name = "eva hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/eva = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "eva hardsuit crate"
	access = list(access_mining,
				  access_eva,
				  access_pilot)
	one_access = TRUE

/datum/supply_pack/misc/mining_rig
	name = "industrial hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/industrial = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "industrial hardsuit crate"
	access = list(access_mining,
				  access_eva)
	one_access = TRUE

/datum/supply_pack/misc/medical_rig
	name = "medical hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/medical = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "medical hardsuit crate"
	access = access_medical

/datum/supply_pack/misc/security_rig
	name = "hazard hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/hazard = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "hazard hardsuit crate"
	access = access_armory

/datum/supply_pack/misc/science_rig
	name = "ami hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/hazmat = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "ami hardsuit crate"
	access = access_rd

/datum/supply_pack/misc/ce_rig
	name = "advanced hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/ce = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "advanced hardsuit crate"
	access = access_ce

/datum/supply_pack/misc/com_medical_rig
	name = "commonwealth medical hardsuit (loaded)"
	contains = list(
			/obj/item/weapon/rig/baymed/equipped = 1
			)
	cost = 250
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Commonwealth medical hardsuit crate"
	access = access_medical

/datum/supply_pack/misc/com_engineering_rig
	name = "commonwealth engineering hardsuit (loaded)"
	contains = list(
			/obj/item/weapon/rig/bayeng/equipped = 1
			)
	cost = 250
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Commonwealth engineering hardsuit crate"
	access = access_engine

/datum/supply_pack/misc/breacher_rig
	name = "unathi breacher hardsuit (empty)"
	contains = list(
			/obj/item/weapon/rig/breacher = 1
			)
	cost = 250
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "unathi breacher hardsuit crate"
	access = access_armory

/datum/supply_pack/misc/zero_rig
	name = "null hardsuit (jets)"
	contains = list(
			/obj/item/weapon/rig/zero = 1
			)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "null hardsuit crate"

/datum/supply_pack/misc/jetpack
	name = "jetpack (empty)"
	contains = list(
			/obj/item/weapon/tank/jetpack = 1
			)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "jetpack crate"
	access = list(access_mining,
				  access_xenoarch,
				  access_eva,
				  access_pilot)
	one_access = TRUE

/datum/supply_pack/randomised/misc/explorer_shield
	name = "Away Team shield"
	num_contained = 2
	contains = list(
			/obj/item/weapon/shield/riot/explorer,
			/obj/item/weapon/shield/riot/explorer/purple
			)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "exploration shield crate"
	access = list(access_eva,
				  access_pilot)
	one_access = TRUE

/datum/supply_pack/misc/music_players
	name = "music players (3)"
	contains = list(
		/obj/item/device/walkpod = 3
	)
	cost = 150
	containertype = /obj/structure/closet/crate
	containername = "portable music players crate"

/datum/supply_pack/misc/juke_remotes
	name = "jukebox remote speakers (2)"
	contains = list(
		/obj/item/device/juke_remote = 2
	)
	cost = 300
	containertype = /obj/structure/closet/crate
	containername = "cordless jukebox speakers crate"

/datum/supply_pack/misc/explorer_headsets
	name = "shortwave-capable headsets (x4)"
	contains = list(
		/obj/item/device/radio/headset/explorer = 4
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "exploration radio headsets crate"
	access = list(
		access_explorer,
		access_eva,
		access_pilot
	)
	one_access = TRUE
