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
	access = access_armory

/datum/supply_pack/security/carriersblack
	name = "Armor - Black modular armor"
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier,
			/obj/item/clothing/accessory/armor/armguards,
			/obj/item/clothing/accessory/armor/legguards,
			/obj/item/clothing/accessory/storage/pouches,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Plate Carrier crate"

/datum/supply_pack/security/carriersblue
	name = "Armor - Blue modular armor"
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier/blue,
			/obj/item/clothing/accessory/armor/armguards/blue,
			/obj/item/clothing/accessory/armor/legguards/blue,
			/obj/item/clothing/accessory/storage/pouches/blue,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Plate Carrier crate"

/datum/supply_pack/security/carriersgreen
	name = "Armor - Green modular armor"
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier/green,
			/obj/item/clothing/accessory/armor/armguards/green,
			/obj/item/clothing/accessory/armor/legguards/green,
			/obj/item/clothing/accessory/storage/pouches/green,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Plate Carrier crate"

/datum/supply_pack/security/carriersnavy
	name = "Armor - Navy modular armor"
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier/navy,
			/obj/item/clothing/accessory/armor/armguards/navy,
			/obj/item/clothing/accessory/armor/legguards/navy,
			/obj/item/clothing/accessory/storage/pouches/navy,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Plate Carrier crate"

/datum/supply_pack/security/carrierstan
	name = "Armor - Tan modular armor"
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier/tan,
			/obj/item/clothing/accessory/armor/armguards/tan,
			/obj/item/clothing/accessory/armor/legguards/tan,
			/obj/item/clothing/accessory/storage/pouches/tan,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Plate Carrier crate"

/datum/supply_pack/security/armorplate
	name = "Armor - Security light armor plate"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate,
			)
	cost = 5
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Armor plate crate"

/datum/supply_pack/security/armorplatestab
	name = "Armor - Security stab armor plate"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/stab,
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Armor plate crate"

/datum/supply_pack/security/armorplatemedium
	name = "Armor - Security armor plate"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/medium,
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Armor plate crate"

/datum/supply_pack/security/armorplatetac
	name = "Armor - Security medium armor plate"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/tactical,
			)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Armor plate crate"

/datum/supply_pack/randomised/security/carriers
	name = "Armor - Surplus plate carriers"
	num_contained = 5
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier,
			/obj/item/clothing/suit/armor/pcarrier/blue,
			/obj/item/clothing/suit/armor/pcarrier/green,
			/obj/item/clothing/suit/armor/pcarrier/navy,
			/obj/item/clothing/suit/armor/pcarrier/tan,
			/obj/item/clothing/suit/armor/pcarrier/press
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/scg
	containername = "Plate Carrier crate"

/datum/supply_pack/security/carriertags
	name = "Armor - Plate carrier tags"
	contains = list(
			/obj/item/clothing/accessory/armor/tag,
			/obj/item/clothing/accessory/armor/tag/nt,
			/obj/item/clothing/accessory/armor/tag/opos,
			/obj/item/clothing/accessory/armor/tag/oneg,
			/obj/item/clothing/accessory/armor/tag/apos,
			/obj/item/clothing/accessory/armor/tag/aneg,
			/obj/item/clothing/accessory/armor/tag/bpos,
			/obj/item/clothing/accessory/armor/tag/bneg,
			/obj/item/clothing/accessory/armor/tag/abpos,
			/obj/item/clothing/accessory/armor/tag/abneg
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/scg
	containername = "Plate Carrier crate"

/datum/supply_pack/security/helmcovers
	name = "Armor - Helmet covers"
	contains = list(
			/obj/item/clothing/accessory/armor/helmcover/blue,
			/obj/item/clothing/accessory/armor/helmcover/blue,
			/obj/item/clothing/accessory/armor/helmcover/navy,
			/obj/item/clothing/accessory/armor/helmcover/navy,
			/obj/item/clothing/accessory/armor/helmcover/green,
			/obj/item/clothing/accessory/armor/helmcover/green,
			/obj/item/clothing/accessory/armor/helmcover/tan,
			/obj/item/clothing/accessory/armor/helmcover/tan
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/scg
	containername = "Helmet Covers crate"

/datum/supply_pack/randomised/security/armorplates
	name = "Armor - Surplus security armor plates"
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate,
			/obj/item/clothing/accessory/armor/armorplate/stab,
			/obj/item/clothing/accessory/armor/armorplate,
			/obj/item/clothing/accessory/armor/armorplate/stab,
			/obj/item/clothing/accessory/armor/armorplate/medium,
			/obj/item/clothing/accessory/armor/armorplate/medium,
			/obj/item/clothing/accessory/armor/armorplate/tactical,
			/obj/item/clothing/accessory/armor/armorplate/laserproof,
			/obj/item/clothing/accessory/armor/armorplate/riot,
			/obj/item/clothing/accessory/armor/armorplate/bulletproof
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/scg
	containername = "Armor plate crate"

/datum/supply_pack/randomised/security/carrierarms
	name = "Armor - Surplus security armguard attachments"
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/armor/armguards,
			/obj/item/clothing/accessory/armor/armguards/blue,
			/obj/item/clothing/accessory/armor/armguards/navy,
			/obj/item/clothing/accessory/armor/armguards/green,
			/obj/item/clothing/accessory/armor/armguards/tan,
			/obj/item/clothing/accessory/armor/armguards/laserproof,
			/obj/item/clothing/accessory/armor/armguards/riot,
			/obj/item/clothing/accessory/armor/armguards/bulletproof
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/scg
	containername = "Armor plate crate"

/datum/supply_pack/randomised/security/carrierlegs
	name = "Armor - Surplus security legguard attachments"
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/armor/legguards,
			/obj/item/clothing/accessory/armor/legguards/blue,
			/obj/item/clothing/accessory/armor/legguards/navy,
			/obj/item/clothing/accessory/armor/legguards/green,
			/obj/item/clothing/accessory/armor/legguards/tan,
			/obj/item/clothing/accessory/armor/legguards/laserproof,
			/obj/item/clothing/accessory/armor/legguards/riot,
			/obj/item/clothing/accessory/armor/legguards/bulletproof
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/scg
	containername = "Armor plate crate"

/datum/supply_pack/randomised/security/carrierbags
	name = "Armor - Surplus security pouch attachments"
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/storage/pouches,
			/obj/item/clothing/accessory/storage/pouches/blue,
			/obj/item/clothing/accessory/storage/pouches/navy,
			/obj/item/clothing/accessory/storage/pouches/green,
			/obj/item/clothing/accessory/storage/pouches/tan,
			/obj/item/clothing/accessory/storage/pouches/large,
			/obj/item/clothing/accessory/storage/pouches/large/blue,
			/obj/item/clothing/accessory/storage/pouches/large/navy,
			/obj/item/clothing/accessory/storage/pouches/large/green,
			/obj/item/clothing/accessory/storage/pouches/large/tan
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/scg
	containername = "Armor plate crate"

/datum/supply_pack/security/riot_gear
	name = "Gear - Riot"
	contains = list(
			/obj/item/melee/baton = 3,
			/obj/item/shield/riot = 3,
			/obj/item/handcuffs = 3,
			/obj/item/storage/box/flashbangs,
			/obj/item/ammo_magazine/ammo_box/b12g/beanbag,
			/obj/item/storage/box/handcuffs
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
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
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Riot armor crate"
	access = access_armory

/datum/supply_pack/security/riot_plates
	name = "Armor - Riot plates"
	contains = list(
			/obj/item/clothing/head/helmet/riot,
			/obj/item/clothing/suit/armor/pcarrier/riot/full
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Riot armor crate"
	access = access_armory
/*
/datum/supply_pack/security/riot_sprayer
	name = "Gear - Riot sprayer"
	contains = list(
			/obj/item/watertank/pepperspray
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Riot sprayer crate"
	access = access_armory*/

/datum/supply_pack/security/ablative_armor
	name = "Armor - Ablative"
	contains = list(
			/obj/item/clothing/head/helmet/laserproof,
			/obj/item/clothing/suit/armor/laserproof,
			/obj/item/clothing/gloves/arm_guard/laserproof,
			/obj/item/clothing/shoes/leg_guard/laserproof
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Ablative armor crate"
	access = access_armory

/datum/supply_pack/security/ablative_plates
	name = "Armor - Ablative plates"
	contains = list(
			/obj/item/clothing/head/helmet/laserproof,
			/obj/item/clothing/suit/armor/pcarrier/laserproof/full
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/lawson
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
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Ballistic armor crate"
	access = access_armory
/* VOREStation Removal - Howabout no ERT armor being orderable?

/datum/supply_pack/security/bullet_resistant_plates
	name = "Armor - Ballistic plates"
	contains = list(
			/obj/item/clothing/head/helmet/bulletproof,
			/obj/item/clothing/suit/armor/pcarrier/bulletproof/full
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Ballistic armor crate"
	access = access_armory

/datum/supply_pack/security/combat_armor
	name = "Armor - Combat"
	contains = list(
			/obj/item/clothing/head/helmet/combat,
			/obj/item/clothing/suit/armor/combat,
			/obj/item/clothing/gloves/arm_guard/combat,
			/obj/item/clothing/shoes/leg_guard/combat
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/saare
	containername = "Combat armor crate"
	access = access_armory

/datum/supply_pack/security/tactical
	name = "Armor - Tactical"
	containertype = /obj/structure/closet/crate/secure/saare
	containername = "Tactical armor crate"
	cost = 40
	access = access_armory
	contains = list(
			/obj/item/clothing/under/tactical,
			/obj/item/clothing/suit/armor/tactical,
			/obj/item/clothing/head/helmet/tactical,
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical,
			/obj/item/storage/belt/security/tactical,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/under/tactical,
			/obj/item/clothing/suit/armor/tactical,
			/obj/item/clothing/head/helmet/tactical,
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical,
			/obj/item/storage/belt/security/tactical,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/gloves/black
			)
*/

/datum/supply_pack/security/flexitac
	name = "Armor - Tactical Light"
	containertype = /obj/structure/closet/crate/secure/saare
	containername = "Tactical Light armor crate"
	cost = 75
	access = access_armory
	contains = list(
				/obj/item/clothing/suit/storage/vest/heavy/flexitac,
				/obj/item/clothing/head/helmet/flexitac,
				/obj/item/clothing/shoes/leg_guard/flexitac,
				/obj/item/clothing/gloves/arm_guard/flexitac,
				/obj/item/clothing/mask/balaclava/tactical,
				/obj/item/clothing/glasses/sunglasses/sechud/tactical,
				/obj/item/storage/belt/security/tactical,
				/obj/item/clothing/suit/storage/vest/heavy/flexitac,
				/obj/item/clothing/head/helmet/flexitac,
				/obj/item/clothing/shoes/leg_guard/flexitac,
				/obj/item/clothing/gloves/arm_guard/flexitac,
				/obj/item/clothing/mask/balaclava/tactical,
				/obj/item/clothing/glasses/sunglasses/sechud/tactical,
				/obj/item/storage/belt/security/tactical
				)

/datum/supply_pack/security/securitybarriers
	name = "Misc - Security Barriers"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/large/secure/heph
	containername = "Security barrier crate"

/datum/supply_pack/security/securityshieldgen
	name = "Misc - Wall shield generators"
	contains = list(/obj/machinery/shieldwallgen = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Wall shield generators crate"
	access = access_teleporter

/datum/supply_pack/randomised/security/holster
	name = "Gear - Holsters"
	num_contained = 4
	contains = list(
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip,
			/obj/item/clothing/accessory/holster/leg
			)
	cost = 15
	containertype = /obj/structure/closet/crate/hedberg
	containername = "Holster crate"

/datum/supply_pack/security/extragear
	name = "Gear - Security surplus equipment"
	contains = list(
			/obj/item/storage/belt/security = 3,
			/obj/item/clothing/glasses/sunglasses/sechud = 3,
			/obj/item/radio/headset/alt/headset_sec = 3,
			/obj/item/clothing/suit/storage/hooded/wintercoat/security = 3,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical_sec_vis = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/nanothreads
	containername = "Security surplus equipment"

/datum/supply_pack/security/detectivegear
	name = "Forensic - Investigation equipment"
	contains = list(
			/obj/item/storage/box/evidence = 2,
			/obj/item/clothing/suit/storage/vest/detective,
			/obj/item/cartridge/detective,
			/obj/item/radio/headset/headset_sec,
			/obj/item/taperoll/police,
			/obj/item/clothing/glasses/sunglasses,
			/obj/item/camera,
			/obj/item/folder/red,
			/obj/item/folder/blue,
			/obj/item/storage/belt/detective,
			/obj/item/clothing/gloves/black,
			/obj/item/taperecorder,
			/obj/item/mass_spectrometer,
			/obj/item/camera_film = 2,
			/obj/item/storage/photo_album,
			/obj/item/reagent_scanner,
			/obj/item/flashlight/maglight,
			/obj/item/storage/briefcase/crimekit,
			/obj/item/storage/bag/detective
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Forensic equipment"
	access = access_forensics_lockers

/datum/supply_pack/security/detectivescan
	name = "Forensic - Scanning Equipment"
	contains = list(
			/obj/item/mass_spectrometer,
			/obj/item/reagent_scanner,
			/obj/item/storage/briefcase/crimekit,
			/obj/item/detective_scanner
			)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/ward
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
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Investigation clothing"
	access = access_forensics_lockers

/datum/supply_pack/security/officergear
	name = "Gear - Officer equipment"
	contains = list(
			/obj/item/clothing/suit/storage/vest/officer,
			/obj/item/clothing/head/helmet,
			/obj/item/cartridge/security,
			/obj/item/clothing/accessory/badge/holo,
			/obj/item/clothing/accessory/badge/holo/cord,
			/obj/item/radio/headset/headset_sec,
			/obj/item/storage/belt/security,
			/obj/item/flash,
			/obj/item/reagent_containers/spray/pepper,
			/obj/item/grenade/flashbang,
			/obj/item/melee/baton/loaded,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/taperoll/police,
			/obj/item/clothing/gloves/black,
			/obj/item/hailer,
			/obj/item/flashlight/flare,
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/head/soft/sec/corp,
			/obj/item/clothing/under/rank/security/corp,
			/obj/item/gun/energy/taser,
			/obj/item/flashlight/maglight
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Officer equipment"
	access = access_brig

/datum/supply_pack/security/wardengear
	name = "Gear - " + JOB_WARDEN + " equipment"
	contains = list(
			/obj/item/clothing/suit/storage/vest/warden,
			/obj/item/clothing/under/rank/warden,
			/obj/item/clothing/under/rank/warden/corp,
			/obj/item/clothing/suit/storage/vest/wardencoat,
			/obj/item/clothing/suit/storage/vest/wardencoat/alt,
			/obj/item/clothing/suit/storage/vest/wardencoat/alt2, //VOREStation Add,
			/obj/item/clothing/head/helmet/warden,
			/obj/item/cartridge/security,
			/obj/item/radio/headset/headset_sec,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/taperoll/police,
			/obj/item/hailer,
			/obj/item/clothing/accessory/badge/holo/warden,
			/obj/item/storage/box/flashbangs,
			/obj/item/storage/belt/security,
			/obj/item/reagent_containers/spray/pepper,
			/obj/item/melee/baton/loaded,
			/obj/item/storage/box/holobadge,
			/obj/item/clothing/head/beret/sec/corporate/warden,
			/obj/item/flashlight/maglight
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = JOB_WARDEN + " equipment"
	access = access_armory

/datum/supply_pack/security/headofsecgear
	name = "Gear - " + JOB_HEAD_OF_SECURITY + " equipment"
	contains = list(
			/obj/item/clothing/head/helmet/HoS,
			/obj/item/clothing/suit/storage/vest/hos,
			/obj/item/clothing/under/rank/head_of_security/corp,
			/obj/item/clothing/suit/storage/vest/hoscoat,
			/obj/item/clothing/suit/storage/vest/hoscoat/jensen/alt, //VOREStation Add,
			/obj/item/clothing/head/helmet/dermal,
			/obj/item/cartridge/hos,
			/obj/item/radio/headset/heads/hos,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/storage/belt/security,
			/obj/item/flash,
			/obj/item/hailer,
			/obj/item/clothing/accessory/badge/holo/hos,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/melee/telebaton,
			/obj/item/shield/riot/tele,
			/obj/item/clothing/head/beret/sec/corporate/hos,
			/obj/item/flashlight/maglight
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = JOB_HEAD_OF_SECURITY + " equipment"
	access = access_hos

/datum/supply_pack/security/securityclothing
	name = "Misc - Security uniform red"
	contains = list(
			/obj/item/storage/backpack/satchel/sec = 2,
			/obj/item/storage/backpack/security = 2,
			/obj/item/clothing/accessory/armband = 4,
			/obj/item/clothing/under/rank/security = 4,
			/obj/item/clothing/under/rank/security2 = 4,
			/obj/item/clothing/under/rank/warden,
			/obj/item/clothing/under/rank/head_of_security,
			/obj/item/clothing/head/soft/sec = 4,
			/obj/item/clothing/gloves/black = 4,
			/obj/item/storage/box/holobadge
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Security uniform crate"

/datum/supply_pack/security/navybluesecurityclothing
	name = "Misc - Security uniform navy blue"
	contains = list(
			/obj/item/storage/backpack/satchel/sec = 2,
			/obj/item/storage/backpack/security = 2,
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
			/obj/item/storage/box/holobadge
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Navy blue security uniform crate"

/datum/supply_pack/security/corporatesecurityclothing
	name = "Misc - Security uniform corporate"
	contains = list(
			/obj/item/storage/backpack/satchel/sec = 2,
			/obj/item/storage/backpack/security = 2,
			/obj/item/clothing/under/rank/security/corp = 4,
			/obj/item/clothing/head/soft/sec/corp = 4,
			/obj/item/clothing/under/rank/warden/corp,
			/obj/item/clothing/under/rank/head_of_security/corp,
			/obj/item/clothing/head/beret/sec = 4,
			/obj/item/clothing/head/beret/sec/corporate/warden,
			/obj/item/clothing/head/beret/sec/corporate/hos,
			/obj/item/clothing/under/det/corporate = 2,
			/obj/item/clothing/gloves/black = 4,
			/obj/item/storage/box/holobadge
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Corporate security uniform crate"

/datum/supply_pack/security/biosuit
	name = "Gear - Security biohazard gear"
	contains = list(
			/obj/item/clothing/head/bio_hood/security = 3,
			/obj/item/clothing/under/rank/security = 3,
			/obj/item/clothing/suit/bio_suit/security = 3,
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/storage/box/gloves
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Security biohazard gear"
	access = access_security

/datum/supply_pack/security/posters
	name = "Gear - Morale Posters"
	contains = list(
			/obj/item/poster/nanotrasen = 6
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Morale Posters"
	access = access_maint_tunnels

/*/datum/supply_pack/security/guardbeast //VORESTATION AI TEMPORARY REMOVAL
	name = "VARMAcorp autoNOMous security solution"
	cost = 150
	containertype = /obj/structure/largecrate/animal/guardbeast
	containername = "VARMAcorp autoNOMous security solution crate"
	access = list(
			access_security,
			access_xenobiology)
	one_access = TRUE

/datum/supply_pack/security/guardmutant
	name = "VARMAcorp autoNOMous security solution for hostile environments"
	cost = 250
	containertype = /obj/structure/largecrate/animal/guardmutant
	containername = "VARMAcorp autoNOMous security phoron-proof solution crate"
	access = list(
			access_security,
			access_xenobiology)
	one_access = TRUE
*/

/datum/supply_pack/security/biosuit
	contains = list(
			/obj/item/clothing/head/bio_hood/security = 3,
			/obj/item/clothing/under/rank/security = 3,
			/obj/item/clothing/suit/bio_suit/security = 3,
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/storage/box/gloves
			)
	cost = 40

/datum/supply_pack/security/trackingimplant
	name = "Implants - Tracking"
	contains = list(
			/obj/item/storage/box/trackimp = 1
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Tracking implants"
	access = access_security

/datum/supply_pack/security/chemicalimplant
	name = "Implants - Chemical"
	contains = list(
			/obj/item/storage/box/chemimp = 1
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Chemical implants"
	access = access_security
