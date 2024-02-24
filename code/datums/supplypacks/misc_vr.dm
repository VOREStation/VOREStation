
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

/datum/supply_pack/misc/emergency_beacons
	name = "emergency locator beacons (x4)"
	contains = list(
		/obj/item/device/emergency_beacon = 4
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "emergency beacons crate"