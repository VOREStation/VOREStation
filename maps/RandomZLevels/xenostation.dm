// XENOSTATION AREAS //

/area/awaymission/xenostation
	icon_state = "white"

/area/awaymission/xenostation/science
	name = "Science Lab"
	icon_state = "anolab"

/area/awaymission/xenostation/science/gateroom // RD's office.
	name = "Research Director's Office"
	icon_state = "away1"

/area/awaymission/xenostation/science/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/awaymission/xenostation/medbay
	name = "Medbay"
	icon_state = "medbay2"

/area/awaymission/xenostation/medbay/surgery
	name = "Surgery"
	icon_state = "surgery"

/area/awaymission/xenostation/medbay/morgue
	name = "Morgue"
	icon_state = "morgue"

/area/awaymission/xenostation/bridge
	name = "Bridge"
	icon_state = "bridge"

/area/awaymission/xenostation/security
	name = "Security"
	icon_state = "security"

/area/awaymission/xenostation/security/armory
	name = "Armory"
	icon_state = "armory"

/area/awaymission/xenostation/security/brig
	name = "Brig"
	icon_state = "brig"

/area/awaymission/xenostation/cargo // Sort of done anyway.
	name = "Cargo"
	icon_state = "quartoffice"

/area/awaymission/xenostation/cargo/hangar // Put empress in here.
	name = "Cargo Hangar"
	icon_state = "purple"

/area/awaymission/xenostation/cargo/mechbay
	name = "Cargo Mechbay"
	icon_state = "mechbay"

/area/awaymission/xenostation/cargo/warehouse // The prize for the boss battle.
	name = "Cargo Warehouse"
	icon_state = "primarystorage"

/area/awaymission/xenostation/engineering
	name = "Engineering"
	icon_state = "engine"

/area/awaymission/xenostation/engineering/eva
	name = "EVA"
	icon_state = "eva"

/area/awaymission/xenostation/engineering/storage
	name = "Hard Storage"
	icon_state = "engine_storage"

/area/awaymission/xenostation/engineering/power
	name = "Power Plant"
	icon_state = "engine_smes"

/area/awaymission/xenostation/engineering/atmos
	name = "Atmospherics"
	icon_state = "atmos"

/area/awaymission/xenostation/crew/dorms
	name = "Crew Dorms"
	icon_state = "crew_quarters"

/area/awaymission/xenostation/crew/cafe
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/awaymission/xenostation/crew/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/awaymission/xenostation/crew/hydro
	name = "Hydroponics"
	icon_state = "hydro"

/area/awaymission/xenostation/crew/restroom
	name = "Bathrooms"
	icon_state = "restrooms"

/area/awaymission/xenostation/hallway
	name = "Central Corridor"
	icon_state = "hallC"

// Mobs

/obj/random/mob/xeno
	name = "Random Xeno Mob"
	desc = "This is a random xeno spawn. You aren't supposed to see this. Call an admin because reality has broken into the meta."
	icon = 'icons/mob/alien.dmi'
	icon_state = "Hunter Front Half"
	spawn_nothing_percentage = 40
	item_to_spawn()
		return pick(/mob/living/simple_animal/hostile/vore/alien/drone,\
					/mob/living/simple_animal/hostile/vore/alien/drone,\
					/mob/living/simple_animal/hostile/vore/alien/drone,\
					/mob/living/simple_animal/hostile/vore/alien,\
					/mob/living/simple_animal/hostile/vore/alien,\
					/mob/living/simple_animal/hostile/vore/alien/sentinel,\
					/obj/item/clothing/mask/facehugger/xenostation)

/obj/item/clothing/mask/facehugger/xenostation/New() // To prevent deleting it if aliens are disabled globally.
	return // This way the map is still threatening but no one can make more facehumpers if they become a xeno.

// Corpses

/obj/effect/landmark/corpse/xenostation/soldier
	name = "marine"
	corpseuniform = /obj/item/clothing/under/tactical/bdu
	corpsesuit = /obj/item/clothing/suit/armor/tactical/m3
	corpseshoes = /obj/item/clothing/shoes/combat
	corpseradio = /obj/item/device/radio/headset
	corpsehelmet = /obj/item/weapon/storage/helmet/m10
	corpsebelt = /obj/item/weapon/storage/belt/security/tactical/uscm
	corpsepocket1 = /obj/item/ammo_magazine/a10mmc
	corpsepocket2 = /obj/item/ammo_magazine/a10mmc
	corpseback = /obj/item/weapon/storage/backpack
	corpseid = 1
	corpseidjob = "USCM Private"
	corpseidicon = "guest"

/obj/effect/landmark/corpse/xenostation/soldier/nco
	corpseuniform = /obj/item/clothing/under/tactical/bdu/camo
	corpsesuit = /obj/item/clothing/suit/armor/tactical/m3/nco
	corpsemask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	corpsehelmet = /obj/item/weapon/storage/helmet/m10/camo
	corpsepocket1 = /obj/item/clothing/mask/smokable/cigarette
	corpsepocket2 = /obj/item/weapon/flame/lighter/zippo
	corpseidjob = "USCM Sargeant"

/obj/effect/landmark/corpse/xenostation/soldier/medic
	corpsesuit = /obj/item/clothing/suit/armor/tactical/m3/medic
	corpseback = /obj/item/weapon/storage/backpack/medic/full
	corpsepocket1 = /obj/item/weapon/reagent_containers/hypospray/autoinjector
	corpseidjob = "USCM Medic"

/obj/effect/landmark/corpse/xenostation/soldier/engineer
	corpsesuit = /obj/item/clothing/suit/armor/tactical/m3/engineer
	corpsebelt = /obj/item/weapon/storage/belt/utility/full
	corpseidjob = "USCM Combat Engineer"

/obj/effect/landmark/corpse/xenostation/testsubject
	name = "Unfortunate Test Subject"
	corpsehelmet = /obj/item/clothing/head/fluff/xeno

/*
/obj/effect/landmark/corpse/overseer
	name = "Overseer"
	corpseuniform = /obj/item/clothing/under/rank/navyhead_of_security
	corpsesuit = /obj/item/clothing/suit/armor/hosnavycoat
	corpseradio = /obj/item/device/radio/headset/heads/captain
	corpsegloves = /obj/item/clothing/gloves/black/hos
	corpseshoes = /obj/item/clothing/shoes/swat
	corpsehelmet = /obj/item/clothing/head/beret/navyhos
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpseid = 1
	corpseidjob = "Facility Overseer"
	corpseidaccess = "Captain"

/obj/effect/landmark/corpse/officer
	name = "Security Officer"
	corpseuniform = /obj/item/clothing/under/rank/navysecurity
	corpsesuit = /obj/item/clothing/suit/armor/navysecvest
	corpseradio = /obj/item/device/radio/headset/headset_sec
	corpseshoes = /obj/item/clothing/shoes/swat
	corpsehelmet = /obj/item/clothing/head/beret/navysec
	corpseid = 1
	corpseidjob = "Security Officer"
	corpseidaccess = "Security Officer"
*/

// Items and objects for Xenostation

/obj/item/weapon/storage/belt/security/tactical/uscm
	name = "\improper USCM tactical belt"
	New()
		..()
		new /obj/item/ammo_magazine/a10mmc(src)
		new /obj/item/ammo_magazine/a10mmc(src)
		new /obj/item/ammo_magazine/a10mmc(src)
		new /obj/item/weapon/gun/projectile/colt(src)
		new /obj/item/ammo_magazine/c45m(src)
		new /obj/item/ammo_magazine/c45m(src)
		new /obj/item/device/flashlight(src)