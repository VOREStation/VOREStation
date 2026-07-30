//Gun classifications for locker sanity
#define GUN_SIDEARM	0	//one handed sidearms, pistols and the sort.
#define GUN_LONGARM	1	//shotguns, rifles, etc.
#define GUN_HEAVY	2	//Stuff too large to sprite in the lockers.

//Extra vars for Gun lockers

/obj/item/weapon/gun/
	var/locker_class = GUN_LONGARM
	var/overlay_type = "genericplaceholder"

/obj/item/weapon/gun/launcher
	locker_class = GUN_HEAVY
/* Side arms */

//Projectile
/obj/item/weapon/gun/projectile/colt
	locker_class = GUN_SIDEARM
	overlay_type = "revolver"

/obj/item/weapon/gun/projectile/sec
	locker_class = GUN_SIDEARM
	overlay_type = "pistol"

/obj/item/weapon/gun/projectile/silenced
	locker_class = GUN_SIDEARM
	overlay_type = "pistol"

/obj/item/weapon/gun/projectile/deagle
	locker_class = GUN_SIDEARM
	overlay_type = "silverpistol"

/obj/item/weapon/gun/projectile/deagle/gold
	overlay_type = "goldpistol"

/obj/item/weapon/gun/projectile/automatic/mini_uzi
	locker_class = GUN_SIDEARM
	overlay_type = "uzi"

/obj/item/weapon/gun/projectile/pistol
	locker_class = GUN_SIDEARM
	overlay_type = "pistol"

/obj/item/weapon/gun/projectile/aps
	locker_class = GUN_SIDEARM
	overlay_type = "PDW"

/obj/item/weapon/gun/projectile/revolver
	locker_class = GUN_SIDEARM
	overlay_type = "revolver"

/obj/item/weapon/gun/projectile/lamia
	locker_class = GUN_SIDEARM
	overlay_type = "revolver"

/obj/item/weapon/gun/projectile/dartgun/research
	locker_class = GUN_SIDEARM
	overlay_type = "dartgun"

/obj/item/weapon/gun/projectile/gyropistol
	locker_class = GUN_SIDEARM
	overlay_type = "pistol"

//Energy
/obj/item/weapon/gun/energy/taser
	locker_class = GUN_SIDEARM
	overlay_type = "taser"

/obj/item/weapon/gun/energy/stunrevolver
	locker_class = GUN_SIDEARM
	overlay_type = "revolver"

/obj/item/weapon/gun/energy/ionrifle/pistol
	locker_class = GUN_SIDEARM
	overlay_type = "ionpistol"

/obj/item/weapon/gun/energy/floragun
	locker_class = GUN_SIDEARM
	overlay_type = "floramut"

/obj/item/weapon/gun/energy/retro
	locker_class = GUN_SIDEARM
	overlay_type = "retro"

/obj/item/weapon/gun/energy/alien
	locker_class = GUN_SIDEARM
	overlay_type = "alien"

/obj/item/weapon/gun/energy/captain
	locker_class = GUN_SIDEARM
	overlay_type = "captain"

/obj/item/weapon/gun/energy/gun
	locker_class = GUN_SIDEARM
	overlay_type = "energypistol"

/obj/item/weapon/gun/energy/gun/compact
	locker_class = GUN_SIDEARM
	overlay_type = "energypistol"

/obj/item/weapon/gun/energy/particle
	locker_class = GUN_SIDEARM
	overlay_type = "ppistol"

/obj/item/weapon/gun/energy/decloner
	locker_class = GUN_SIDEARM
	overlay_type = "decloner"

/obj/item/weapon/gun/projectile/cell_loaded/medical
	locker_class = GUN_SIDEARM
	overlay_type = "ml3m"

/obj/item/weapon/gun/energy/sickshot
	locker_class = GUN_SIDEARM
	overlay_type = "sickshot"

/obj/item/weapon/gun/projectile/cell_loaded/combat
	locker_class = GUN_SIDEARM
	overlay_type = "nsfw"

/obj/item/weapon/gun/energy/phasegun/pistol
	locker_class = GUN_SIDEARM
	overlay_type = "energypistol"

/obj/item/weapon/gun/energy/locked/frontier/holdout
	locker_class = GUN_SIDEARM
	overlay_type = "energypistol"

/obj/item/weapon/gun/energy/lasertag
	locker_class = GUN_SIDEARM
	overlay_type = "omnitag"

/obj/item/weapon/gun/energy/lasertag/blue
	overlay_type = "bluetag"

/obj/item/weapon/gun/energy/lasertag/blue/sub
	overlay_type = "bluetwo"

/obj/item/weapon/gun/energy/lasertag/red
	overlay_type = "redtag"

/obj/item/weapon/gun/energy/lasertag/red/dom
	overlay_type = "redtwo"

/obj/item/weapon/gun/energy/mouseray
	overlay_type = "mouseray"
	locker_class = GUN_SIDEARM

/obj/item/weapon/gun/energy/mouseray/medical
	overlay_type = "medray"

/* Long arms */
/obj/item/weapon/gun/energy/gun/rifle
	locker_class = GUN_LONGARM
	overlay_type = "erifle"

/obj/item/weapon/gun/energy/phasegun
	locker_class = GUN_LONGARM
	overlay_type = "ecarbine"

/obj/item/weapon/gun/energy/locked/frontier
	locker_class = GUN_LONGARM
	overlay_type = "ecarbine"

/obj/item/weapon/gun/energy/gun/sniperrifle
	locker_class = GUN_LONGARM
	overlay_type = "sniper"

/obj/item/weapon/gun/energy/gun/burst
	locker_class = GUN_LONGARM
	overlay_type = "ecarbine"

/obj/item/weapon/gun/energy/pummeler
	locker_class = GUN_LONGARM
	overlay_type = "pum"

/obj/item/weapon/gun/energy/gun/nuclear
	locker_class = GUN_LONGARM
	overlay_type = "nucgun"

/obj/item/weapon/gun/energy/laser
	locker_class = GUN_LONGARM
	overlay_type = "laser"

/obj/item/weapon/gun/energy/laser/sleek
	overlay_type = "lrifle"

/obj/item/weapon/gun/energy/ionrifle
	locker_class = GUN_LONGARM
	overlay_type = "ionrifle"

/obj/item/weapon/gun/energy/lasercannon
	locker_class = GUN_LONGARM
	overlay_type = "lasercannon"

/obj/item/weapon/gun/energy/xray
	locker_class = GUN_LONGARM
	overlay_type = "xray"

/obj/item/weapon/gun/energy/particle/advanced
	locker_class = GUN_LONGARM
	overlay_type = "particle"

/obj/item/weapon/gun/projectile/automatic/advanced_smg
	locker_class = GUN_LONGARM
	overlay_type = "saber"

/obj/item/weapon/gun/projectile/automatic/sts35
	locker_class = GUN_LONGARM
	overlay_type = "arifle"

/obj/item/weapon/gun/projectile/automatic/z8
	locker_class = GUN_LONGARM
	overlay_type = "arifle"

/obj/item/weapon/gun/projectile/automatic/bullpup
	locker_class = GUN_LONGARM
	overlay_type = "arifle"

/obj/item/weapon/gun/projectile/automatic/c20r
	locker_class = GUN_LONGARM
	overlay_type = "c20r"

/obj/item/weapon/gun/projectile/automatic/pdw
	locker_class = GUN_LONGARM
	overlay_type = "pdw"

/obj/item/weapon/gun/projectile/automatic/wt550
	locker_class = GUN_LONGARM
	overlay_type = "wt550"

/obj/item/weapon/gun/projectile/automatic/tommygun
	locker_class = GUN_LONGARM
	overlay_type = "tommy"

/obj/item/weapon/gun/projectile/automatic/p90
	locker_class = GUN_LONGARM
	overlay_type = "p90"

/obj/item/weapon/gun/projectile/shotgun/doublebarrel
	locker_class = GUN_LONGARM
	overlay_type = "shotgun"

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn
	overlay_type = "shotsawn"

/obj/item/weapon/gun/projectile/shotgun/pump
	locker_class = GUN_LONGARM
	overlay_type = "shotgun"

/obj/item/weapon/gun/projectile/shotgun/pump/combat
	locker_class = GUN_LONGARM
	overlay_type = "riotshotgun"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle
	overlay_type = "leveraction"

/obj/item/weapon/gun/projectile/garand
	locker_class = GUN_LONGARM
	overlay_type = "leveraction"

/obj/item/weapon/gun/energy/medigun
	locker_class = GUN_LONGARM
	overlay_type = "medbeam"

/obj/item/weapon/gun/energy/netgun
	locker_class = GUN_LONGARM
	overlay_type = "netgun"

/obj/item/weapon/gun/energy/pulse_rifle
	locker_class = GUN_LONGARM
	overlay_type = "pulse"

/obj/item/weapon/gun/launcher/syringe/rapid
	locker_class = GUN_LONGARM
	overlay_type = "rapidsyringegun"

/obj/item/weapon/gun/magnetic/fuelrod
	locker_class = GUN_LONGARM
	overlay_type = "fuelrodgun"

/* Heavy Weapons */
//aka, shit usually too big to fit into my armory sprites.

/obj/item/weapon/gun/projectile/automatic/l6_saw
	locker_class = GUN_LONGARM
	overlay_type = "l6"

/obj/item/weapon/gun/energy/particle/cannon
	locker_class = GUN_HEAVY

/obj/item/weapon/gun/projectile/heavysniper
	locker_class = GUN_HEAVY

/obj/item/weapon/gun/launcher
	locker_class = GUN_HEAVY

/obj/item/weapon/gun/projectile/SVD
	locker_class = GUN_HEAVY
