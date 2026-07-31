//Gun classifications for locker sanity
#define GUN_SIDEARM	0	//one handed sidearms, pistols and the sort.
#define GUN_LONGARM	1	//shotguns, rifles, etc.
#define GUN_HEAVY	2	//Stuff too large to sprite in the lockers.

//Extra vars for Gun lockers
/* 	IF YOU ADD NEW GUNS THAT DON'T LOOK THE SAME, BE SURE TO UPDATE THEM IN GUNCABINENT.DMI
	PLEASE ADHERE TO THE REFERENCES TO MAKE THE WEAPONS FIT IN NICELY!
*/
//Placeholder fallback
/obj/item/gun
	var/locker_class = GUN_LONGARM
	var/overlay_type = "genericplaceholder"

//these are just rediculous to sprite.
/obj/item/gun/launcher
	locker_class = GUN_HEAVY

/* Side arms */

//Projectile
/obj/item/gun/projectile/colt
	locker_class = GUN_SIDEARM
	overlay_type = "revolver"

/obj/item/gun/projectile/sec
	locker_class = GUN_SIDEARM
	overlay_type = "pistol"

/obj/item/gun/projectile/silenced
	locker_class = GUN_SIDEARM
	overlay_type = "pistol"

/obj/item/gun/projectile/deagle
	locker_class = GUN_SIDEARM
	overlay_type = "silverpistol"

/obj/item/gun/projectile/deagle/gold
	overlay_type = "goldpistol"

/obj/item/gun/projectile/automatic/mini_uzi
	locker_class = GUN_SIDEARM
	overlay_type = "uzi"

/obj/item/gun/projectile/pistol
	locker_class = GUN_SIDEARM
	overlay_type = "pistol"

/obj/item/gun/projectile/aps
	locker_class = GUN_SIDEARM
	overlay_type = "PDW"

/obj/item/gun/projectile/revolver
	locker_class = GUN_SIDEARM
	overlay_type = "revolver"

/obj/item/gun/projectile/lamia
	locker_class = GUN_SIDEARM
	overlay_type = "revolver"

/obj/item/gun/projectile/dartgun/research
	locker_class = GUN_SIDEARM
	overlay_type = "dartgun"

/obj/item/gun/projectile/gyropistol
	locker_class = GUN_SIDEARM
	overlay_type = "pistol"

//Energy
/obj/item/gun/energy/taser
	locker_class = GUN_SIDEARM
	overlay_type = "taser"

/obj/item/gun/energy/stunrevolver
	locker_class = GUN_SIDEARM
	overlay_type = "revolver"

/obj/item/gun/energy/ionrifle/pistol
	locker_class = GUN_SIDEARM
	overlay_type = "ionpistol"

/obj/item/gun/energy/floragun
	locker_class = GUN_SIDEARM
	overlay_type = "floramut"

/obj/item/gun/energy/retro
	locker_class = GUN_SIDEARM
	overlay_type = "retro"

/obj/item/gun/energy/alien
	locker_class = GUN_SIDEARM
	overlay_type = "alien"

/obj/item/gun/energy/captain
	locker_class = GUN_SIDEARM
	overlay_type = "captain"

/obj/item/gun/energy/gun
	locker_class = GUN_SIDEARM
	overlay_type = "energypistol"

/obj/item/gun/energy/gun/compact
	locker_class = GUN_SIDEARM
	overlay_type = "energypistol"

/obj/item/gun/energy/particle
	locker_class = GUN_SIDEARM
	overlay_type = "ppistol"

/obj/item/gun/energy/decloner
	locker_class = GUN_SIDEARM
	overlay_type = "decloner"

/obj/item/gun/projectile/cell_loaded/medical
	locker_class = GUN_SIDEARM
	overlay_type = "ml3m"

/obj/item/gun/energy/sickshot
	locker_class = GUN_SIDEARM
	overlay_type = "sickshot"

/obj/item/gun/projectile/cell_loaded/combat
	locker_class = GUN_SIDEARM
	overlay_type = "nsfw"

/obj/item/gun/energy/phasegun/pistol
	locker_class = GUN_SIDEARM
	overlay_type = "energypistol"

/obj/item/gun/energy/locked/frontier/holdout
	locker_class = GUN_SIDEARM
	overlay_type = "energypistol"

/obj/item/gun/energy/lasertag
	locker_class = GUN_SIDEARM
	overlay_type = "omnitag"

/obj/item/gun/energy/lasertag/blue
	overlay_type = "bluetag"

/obj/item/gun/energy/lasertag/blue/sub
	overlay_type = "bluetwo"

/obj/item/gun/energy/lasertag/red
	overlay_type = "redtag"

/obj/item/gun/energy/lasertag/red/dom
	overlay_type = "redtwo"

/obj/item/gun/energy/mouseray
	overlay_type = "mouseray"
	locker_class = GUN_SIDEARM

/obj/item/gun/energy/mouseray/medical
	overlay_type = "medray"

/* Long arms */
/obj/item/gun/energy/gun/rifle
	locker_class = GUN_LONGARM
	overlay_type = "erifle"

/obj/item/gun/energy/phasegun
	locker_class = GUN_LONGARM
	overlay_type = "ecarbine"

/obj/item/gun/energy/locked/frontier
	locker_class = GUN_LONGARM
	overlay_type = "ecarbine"

/obj/item/gun/energy/gun/sniperrifle
	locker_class = GUN_LONGARM
	overlay_type = "sniper"

/obj/item/gun/energy/gun/burst
	locker_class = GUN_LONGARM
	overlay_type = "ecarbine"

/obj/item/gun/energy/pummeler
	locker_class = GUN_LONGARM
	overlay_type = "pum"

/obj/item/gun/energy/gun/nuclear
	locker_class = GUN_LONGARM
	overlay_type = "nucgun"

/obj/item/gun/energy/laser
	locker_class = GUN_LONGARM
	overlay_type = "laser"

/obj/item/gun/energy/laser/sleek
	overlay_type = "lrifle"

/obj/item/gun/energy/ionrifle
	locker_class = GUN_LONGARM
	overlay_type = "ionrifle"

/obj/item/gun/energy/lasercannon
	locker_class = GUN_LONGARM
	overlay_type = "lasercannon"

/obj/item/gun/energy/xray
	locker_class = GUN_LONGARM
	overlay_type = "xray"

/obj/item/gun/energy/particle/advanced
	locker_class = GUN_LONGARM
	overlay_type = "particle"

/obj/item/gun/projectile/automatic/advanced_smg
	locker_class = GUN_LONGARM
	overlay_type = "saber"

/obj/item/gun/projectile/automatic/sts35
	locker_class = GUN_LONGARM
	overlay_type = "arifle"

/obj/item/gun/projectile/automatic/z8
	locker_class = GUN_LONGARM
	overlay_type = "arifle"

/obj/item/gun/projectile/automatic/bullpup
	locker_class = GUN_LONGARM
	overlay_type = "arifle"

/obj/item/gun/projectile/automatic/c20r
	locker_class = GUN_LONGARM
	overlay_type = "c20r"

/obj/item/gun/projectile/automatic/pdw
	locker_class = GUN_LONGARM
	overlay_type = "pdw"

/obj/item/gun/projectile/automatic/wt550
	locker_class = GUN_LONGARM
	overlay_type = "wt550"

/obj/item/gun/projectile/automatic/tommygun
	locker_class = GUN_LONGARM
	overlay_type = "tommy"

/obj/item/gun/projectile/automatic/p90
	locker_class = GUN_LONGARM
	overlay_type = "p90"

/obj/item/gun/projectile/shotgun/doublebarrel
	locker_class = GUN_LONGARM
	overlay_type = "shotgun"

/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	overlay_type = "shotsawn"

/obj/item/gun/projectile/shotgun/pump
	locker_class = GUN_LONGARM
	overlay_type = "shotgun"

/obj/item/gun/projectile/shotgun/pump/combat
	locker_class = GUN_LONGARM
	overlay_type = "riotshotgun"

/obj/item/gun/projectile/shotgun/pump/rifle
	overlay_type = "leveraction"

/obj/item/gun/projectile/garand
	locker_class = GUN_LONGARM
	overlay_type = "leveraction"

/obj/item/gun/energy/medigun
	locker_class = GUN_LONGARM
	overlay_type = "medbeam"

/obj/item/gun/energy/netgun
	locker_class = GUN_LONGARM
	overlay_type = "netgun"

/obj/item/gun/energy/pulse_rifle
	locker_class = GUN_LONGARM
	overlay_type = "pulse"

/obj/item/gun/launcher/syringe/rapid
	locker_class = GUN_LONGARM
	overlay_type = "rapidsyringegun"

/obj/item/gun/magnetic/fuelrod
	locker_class = GUN_LONGARM
	overlay_type = "fuelrodgun"

/obj/item/gun/projectile/automatic/l6_saw
	locker_class = GUN_LONGARM
	overlay_type = "l6"

/* Heavy Weapons */
//aka, shit usually too big to fit into my armory sprites.

/obj/item/gun/energy/particle/cannon
	locker_class = GUN_HEAVY

/obj/item/gun/projectile/heavysniper
	locker_class = GUN_HEAVY

/obj/item/gun/launcher
	locker_class = GUN_HEAVY

/obj/item/gun/projectile/SVD
	locker_class = GUN_HEAVY

#undef GUN_SIDEARM
#undef GUN_LONGARM
#undef GUN_HEAVY
