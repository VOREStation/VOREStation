/*
*	Here is where any supply packs
*	related to security tasks live
*/


/datum/supply_pack/security
	group = "Security"
	access = access_security

/datum/supply_pack/randomised/security
	group = "Security"
	access = access_security

/datum/supply_pack/randomised/security/armor
	name = "Armor - Security armor"
	num_contained = 5
	contains = list(
			/obj/item/clothing/suit/storage/vest,
			/obj/item/clothing/suit/storage/vest/officer,
			/obj/item/clothing/suit/storage/vest/warden,
			/obj/item/clothing/suit/storage/vest/hos,
			/obj/item/clothing/suit/storage/vest/pcrc,
			/obj/item/clothing/suit/storage/vest/detective,
			/obj/item/clothing/suit/storage/vest/heavy,
			/obj/item/clothing/suit/storage/vest/heavy/officer,
			/obj/item/clothing/suit/storage/vest/heavy/warden,
			/obj/item/clothing/suit/storage/vest/heavy/hos,
			/obj/item/clothing/suit/storage/vest/heavy/pcrc
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Armor crate"
	access_armory //VOREStation Add - Armor is for the armory.

/datum/supply_pack/security/riot_gear
	name = "Gear - Riot"
	contains = list(
			/obj/item/weapon/melee/baton = 3,
			/obj/item/weapon/shield/riot = 3,
			/obj/item/weapon/handcuffs = 3,
			/obj/item/weapon/storage/box/flashbangs,
			/obj/item/weapon/storage/box/beanbags,
			/obj/item/weapon/storage/box/handcuffs
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Riot gear crate"
	access = access_armory

/datum/supply_pack/security/riot_armor
	name = "Armor - Riot"
	contains = list(
			/obj/item/clothing/head/helmet/riot,
			/obj/item/clothing/suit/armor/riot,
			/obj/item/clothing/gloves/arm_guard/riot,
			/obj/item/clothing/shoes/leg_guard/riot
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Riot armor crate"
	access = access_armory

/datum/supply_pack/security/ablative_armor
	name = "Armor - Ablative"
	contains = list(
			/obj/item/clothing/head/helmet/laserproof,
			/obj/item/clothing/suit/armor/laserproof,
			/obj/item/clothing/gloves/arm_guard/laserproof,
			/obj/item/clothing/shoes/leg_guard/laserproof
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Ablative armor crate"
	access = access_armory

/datum/supply_pack/security/bullet_resistant_armor
	name = "Armor - Ballistic"
	contains = list(
			/obj/item/clothing/head/helmet/bulletproof,
			/obj/item/clothing/suit/armor/bulletproof,
			/obj/item/clothing/gloves/arm_guard/bulletproof,
			/obj/item/clothing/shoes/leg_guard/bulletproof
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Ballistic armor crate"
	access = access_armory
/* VOREStation Removal - Howabout no ERT armor being orderable?
/datum/supply_pack/security/combat_armor
	name = "Armor - Combat"
	contains = list(
			/obj/item/clothing/head/helmet/combat,
			/obj/item/clothing/suit/armor/combat,
			/obj/item/clothing/gloves/arm_guard/combat,
			/obj/item/clothing/shoes/leg_guard/combat
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Combat armor crate"
	access = access_armory

/datum/supply_pack/security/tactical
	name = "Armor - Tactical"
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Tactical armor crate"
	cost = 40
	access = access_armory
	contains = list(
			/obj/item/clothing/under/tactical,
			/obj/item/clothing/suit/armor/tactical,
			/obj/item/clothing/head/helmet/tactical,
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical,
			/obj/item/weapon/storage/belt/security/tactical,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/under/tactical,
			/obj/item/clothing/suit/armor/tactical,
			/obj/item/clothing/head/helmet/tactical,
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical,
			/obj/item/weapon/storage/belt/security/tactical,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/gloves/black
			)
*/
/datum/supply_pack/security/securitybarriers
	name = "Misc - Security Barriers"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	containertype = /obj/structure/largecrate
	containername = "Security barrier crate"
	access = null

/datum/supply_pack/security/securityshieldgen
	name = "Misc - Wall shield generators"
	contains = list(/obj/machinery/shieldwallgen = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Wall shield generators crate"
	access = access_teleporter

/datum/supply_pack/randomised/security/holster
	name = "Gear - Holsters"
	num_contained = 4
	contains = list(
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip
			)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Holster crate"

/datum/supply_pack/security/extragear
	name = "Gear - Security surplus equipment"
	contains = list(
			/obj/item/weapon/storage/belt/security = 3,
			/obj/item/clothing/glasses/sunglasses/sechud = 3,
			/obj/item/device/radio/headset/headset_sec/alt = 3,
			/obj/item/clothing/suit/storage/hooded/wintercoat/security = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Security surplus equipment"

/datum/supply_pack/security/detectivegear
	name = "Forensic - Investigation equipment"
	contains = list(
			/obj/item/weapon/storage/box/evidence = 2,
			/obj/item/clothing/suit/storage/vest/detective,
			/obj/item/weapon/cartridge/detective,
			/obj/item/device/radio/headset/headset_sec,
			/obj/item/taperoll/police,
			/obj/item/clothing/glasses/sunglasses,
			/obj/item/device/camera,
			/obj/item/weapon/folder/red,
			/obj/item/weapon/folder/blue,
			/obj/item/weapon/storage/belt/detective,
			/obj/item/clothing/gloves/black,
			/obj/item/device/taperecorder,
			/obj/item/device/mass_spectrometer,
			/obj/item/device/camera_film = 2,
			/obj/item/weapon/storage/photo_album,
			/obj/item/device/reagent_scanner,
			/obj/item/device/flashlight/maglight,
			/obj/item/weapon/storage/briefcase/crimekit
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Forensic equipment"
	access = access_forensics_lockers

/datum/supply_pack/security/detectiveclothes
	name = "Forensic - Investigation apparel"
	contains = list(
			/obj/item/clothing/under/det/black = 2,
			/obj/item/clothing/under/det/grey = 2,
			/obj/item/clothing/head/det/grey = 2,
			/obj/item/clothing/under/det/skirt = 2,
			/obj/item/clothing/under/det = 2,
			/obj/item/clothing/head/det = 2,
			/obj/item/clothing/suit/storage/det_trench,
			/obj/item/clothing/suit/storage/det_trench/grey,
			/obj/item/clothing/suit/storage/forensics/red,
			/obj/item/clothing/suit/storage/forensics/blue,
			/obj/item/clothing/under/det/corporate = 2,
			/obj/item/clothing/accessory/badge/holo/detective = 2,
			/obj/item/clothing/gloves/black = 2
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Investigation clothing"
	access = access_forensics_lockers

/datum/supply_pack/security/officergear
	name = "Gear - Officer equipment"
	contains = list(
			/obj/item/clothing/suit/storage/vest/officer,
			/obj/item/clothing/head/helmet,
			/obj/item/weapon/cartridge/security,
			/obj/item/clothing/accessory/badge/holo,
			/obj/item/clothing/accessory/badge/holo/cord,
			/obj/item/device/radio/headset/headset_sec,
			/obj/item/weapon/storage/belt/security,
			/obj/item/device/flash,
			/obj/item/weapon/reagent_containers/spray/pepper,
			/obj/item/weapon/grenade/flashbang,
			/obj/item/weapon/melee/baton/loaded,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/taperoll/police,
			/obj/item/clothing/gloves/black,
			/obj/item/device/hailer,
			/obj/item/device/flashlight/flare,
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/head/soft/sec/corp,
			/obj/item/clothing/under/rank/security/corp,
			/obj/item/weapon/gun/energy/taser,
			/obj/item/device/flashlight/maglight
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Officer equipment"
	access = access_brig

/datum/supply_pack/security/wardengear
	name = "Gear - Warden equipment"
	contains = list(
			/obj/item/clothing/suit/storage/vest/warden,
			/obj/item/clothing/under/rank/warden,
			/obj/item/clothing/under/rank/warden/corp,
			/obj/item/clothing/suit/storage/vest/wardencoat,
			/obj/item/clothing/suit/storage/vest/wardencoat/alt,
			/obj/item/clothing/head/helmet/warden,
			/obj/item/weapon/cartridge/security,
			/obj/item/device/radio/headset/headset_sec,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/taperoll/police,
			/obj/item/device/hailer,
			/obj/item/clothing/accessory/badge/holo/warden,
			/obj/item/weapon/storage/box/flashbangs,
			/obj/item/weapon/storage/belt/security,
			/obj/item/weapon/reagent_containers/spray/pepper,
			/obj/item/weapon/melee/baton/loaded,
			/obj/item/weapon/storage/box/holobadge,
			/obj/item/clothing/head/beret/sec/corporate/warden,
			/obj/item/device/flashlight/maglight
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Warden equipment"
	access = access_armory

/datum/supply_pack/security/headofsecgear
	name = "Gear - Head of security equipment"
	contains = list(
			/obj/item/clothing/head/helmet/HoS,
			/obj/item/clothing/suit/storage/vest/hos,
			/obj/item/clothing/under/rank/head_of_security/corp,
			/obj/item/clothing/suit/storage/vest/hoscoat,
			/obj/item/clothing/head/helmet/dermal,
			/obj/item/weapon/cartridge/hos,
			/obj/item/device/radio/headset/heads/hos,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/weapon/storage/belt/security,
			/obj/item/device/flash,
			/obj/item/device/hailer,
			/obj/item/clothing/accessory/badge/holo/hos,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/weapon/melee/telebaton,
			/obj/item/weapon/shield/riot/tele,
			/obj/item/clothing/head/beret/sec/corporate/hos,
			/obj/item/device/flashlight/maglight
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Head of security equipment"
	access = access_hos

/datum/supply_pack/security/securityclothing
	name = "Misc - Security uniform red"
	contains = list(
			/obj/item/weapon/storage/backpack/satchel/sec = 2,
			/obj/item/weapon/storage/backpack/security = 2,
			/obj/item/clothing/accessory/armband = 4,
			/obj/item/clothing/under/rank/security = 4,
			/obj/item/clothing/under/rank/security2 = 4,
			/obj/item/clothing/under/rank/warden,
			/obj/item/clothing/under/rank/head_of_security,
			/obj/item/clothing/head/soft/sec = 4,
			/obj/item/clothing/gloves/black = 4,
			/obj/item/weapon/storage/box/holobadge
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Security uniform crate"

/datum/supply_pack/security/navybluesecurityclothing
	name = "Misc - Security uniform navy blue"
	contains = list(
			/obj/item/weapon/storage/backpack/satchel/sec = 2,
			/obj/item/weapon/storage/backpack/security = 2,
			/obj/item/clothing/under/rank/security/navyblue = 4,
			/obj/item/clothing/suit/security/navyofficer = 4,
			/obj/item/clothing/under/rank/warden/navyblue,
			/obj/item/clothing/suit/security/navywarden,
			/obj/item/clothing/under/rank/head_of_security/navyblue,
			/obj/item/clothing/suit/security/navyhos,
			/obj/item/clothing/head/beret/sec/navy/officer = 4,
			/obj/item/clothing/head/beret/sec/navy/warden,
			/obj/item/clothing/head/beret/sec/navy/hos,
			/obj/item/clothing/gloves/black = 4,
			/obj/item/weapon/storage/box/holobadge
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Navy blue security uniform crate"

/datum/supply_pack/security/corporatesecurityclothing
	name = "Misc - Security uniform corporate"
	contains = list(
			/obj/item/weapon/storage/backpack/satchel/sec = 2,
			/obj/item/weapon/storage/backpack/security = 2,
			/obj/item/clothing/under/rank/security/corp = 4,
			/obj/item/clothing/head/soft/sec/corp = 4,
			/obj/item/clothing/under/rank/warden/corp,
			/obj/item/clothing/under/rank/head_of_security/corp,
			/obj/item/clothing/head/beret/sec = 4,
			/obj/item/clothing/head/beret/sec/corporate/warden,
			/obj/item/clothing/head/beret/sec/corporate/hos,
			/obj/item/clothing/under/det/corporate = 2,
			/obj/item/clothing/gloves/black = 4,
			/obj/item/weapon/storage/box/holobadge
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Corporate security uniform crate"

/datum/supply_pack/security/biosuit
	name = "Gear - Security biohazard gear"
	contains = list(
			/obj/item/clothing/head/bio_hood/security = 3,
			/obj/item/clothing/under/rank/security = 3,
			/obj/item/clothing/suit/bio_suit/security = 3,
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/weapon/tank/oxygen = 3,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/weapon/storage/box/gloves
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Security biohazard gear"
	access = access_security