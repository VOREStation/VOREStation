/obj/item/weapon/robot_module
	languages = list(LANGUAGE_SOL_COMMON= 1,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_UNATHI		= 0,
					LANGUAGE_SIIK		= 0,
					LANGUAGE_SKRELLIAN	= 0,
					LANGUAGE_GUTTER		= 0,
					LANGUAGE_SCHECHI	= 0,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_BIRDSONG	= 0,
					LANGUAGE_SAGARU		= 0,
					LANGUAGE_CANILUNZT	= 0,
					LANGUAGE_ECUREUILIAN= 0,
					LANGUAGE_DAEMON		= 0,
					LANGUAGE_ENOCHIAN	= 0,
					LANGUAGE_DRUDAKAR	= 0
					)
	var/vr_sprites = list()
	var/pto_type = null

/obj/item/weapon/robot_module/robot/clerical
	languages = list(
					LANGUAGE_SOL_COMMON	= 1,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_UNATHI		= 1,
					LANGUAGE_SIIK		= 1,
					LANGUAGE_SKRELLIAN	= 1,
					LANGUAGE_ROOTLOCAL	= 0,
					LANGUAGE_GUTTER		= 1,
					LANGUAGE_SCHECHI	= 1,
					LANGUAGE_EAL		= 1,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_BIRDSONG	= 1,
					LANGUAGE_SAGARU		= 1,
					LANGUAGE_CANILUNZT	= 1,
					LANGUAGE_ECUREUILIAN= 1,
					LANGUAGE_DAEMON		= 1,
					LANGUAGE_ENOCHIAN	= 1,
					LANGUAGE_DRUDAKAR	= 1,
					LANGUAGE_TAVAN		= 1
					)

//Just add a new proc with the robot_module type if you wish to run some other vore code
/obj/item/weapon/robot_module/proc/vr_new() // Any Global modules, just add them before the return (This will also affect all the borgs in this file)
	return

/obj/item/weapon/robot_module/proc/vr_add_sprites() // Adds sprites from this file into list of avialible ones for global modules
	sprites += vr_sprites
	return

/obj/item/weapon/robot_module/robot/medical/surgeon/vr_new() //Surgeon Bot
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	. = ..() //Any Global vore modules will come from here

/obj/item/weapon/robot_module/robot/medical/crisis/vr_new() //Crisis Bot
	src.modules += new /obj/item/device/sleevemate(src) //Lets them scan people.
	. = ..() //Any Global vore modules will come from here

/obj/item/weapon/robot_module/robot/medical
	pto_type = PTO_MEDICAL

/obj/item/weapon/robot_module/robot/medical/surgeon
	vr_sprites = list(
						"Acheron" = "mechoid-Medical",
						"Shellguard Noble" = "Noble-MED",
						"ZOOM-BA" = "zoomba-medical",
						"W02M" = "worm-surgeon",
						"Feminine Humanoid" = "uptall-medical"
					 )

/obj/item/weapon/robot_module/robot/medical/crisis
	vr_sprites = list(
						"Handy" = "handy-med",
						"Acheron" = "mechoid-Medical",
						"Shellguard Noble" = "Noble-MED",
						"ZOOM-BA" = "zoomba-crisis",
						"W02M" = "worm-crisis",
						"Feminine Humanoid" = "uptall-crisis"
					 )

/obj/item/weapon/robot_module/robot/clerical
	pto_type = PTO_CIVILIAN

/obj/item/weapon/robot_module/robot/clerical/butler/general
	vr_sprites = list(
						"Handy - Service" = "handy-service",
						"Handy - Hydro" = "handy-hydro",
						"Acheron" = "mechoid-Service",
						"Shellguard Noble" = "Noble-SRV",
						"ZOOM-BA" = "zoomba-service",
						"W02M" = "worm-service",
						"Feminine Humanoid" = "uptall-service"
					 )

/obj/item/weapon/robot_module/robot/clerical/general
	vr_sprites = list(
						"Handy" = "handy-clerk",
						"Acheron" = "mechoid-Service",
						"Shellguard Noble" = "Noble-SRV",
						"ZOOM-BA" = "zoomba-clerical",
						"W02M" = "worm-service",
						"Feminine Humanoid" = "uptall-service"
					 )

/obj/item/weapon/robot_module/robot/janitor
	pto_type = PTO_CIVILIAN

/obj/item/weapon/robot_module/robot/janitor/general
	vr_sprites = list(
						"Handy" = "handy-janitor",
						"Acheron" = "mechoid-Janitor",
						"Shellguard Noble" = "Noble-CLN",
						"ZOOM-BA" = "zoomba-janitor",
						"W02M" = "worm-janitor",
						"Feminine Humanoid" = "uptall-janitor"
					 )

/obj/item/weapon/robot_module/robot/security
	pto_type = PTO_SECURITY

/obj/item/weapon/robot_module/robot/security/general
	vr_sprites = list(
						"Handy" = "handy-sec",
						"Acheron" = "mechoid-Security",
						"Shellguard Noble" = "Noble-SEC",
						"ZOOM-BA" = "zoomba-security",
						"W02M" = "worm-security",
						"Feminine Humanoid" = "uptall-security"
					 )

/obj/item/weapon/robot_module/robot/security/combat
	vr_sprites = list(
						"Acheron" = "mechoid-Combat",
						"ZOOM-BA" = "zoomba-combat",
						"W02M" = "worm-combat",
						"Feminine Humanoid" = "uptall-security"
					 )

/obj/item/weapon/robot_module/robot/miner
	pto_type = PTO_CARGO

/obj/item/weapon/robot_module/robot/miner/general
	vr_sprites = list(
						"Handy" = "handy-miner",
						"Acheron" = "mechoid-Miner",
						"Shellguard Noble" = "Noble-DIG",
						"ZOOM-BA" = "zoomba-miner",
						"W02M" = "worm-miner",
						"Feminine Humanoid" = "uptall-miner"
					 )

/obj/item/weapon/robot_module/robot/standard
	pto_type = PTO_CIVILIAN
	vr_sprites = list(
						"Handy" = "handy-standard",
						"Acheron" = "mechoid-Standard",
						"Shellguard Noble" = "Noble-STD",
						"ZOOM-BA" = "zoomba-standard",
						"W02M" = "worm-standard",
						"Feminine Humanoid" = "uptall-standard",
						"Feminine Humanoid, Variant 2" = "uptall-standard2"
					 )

/obj/item/weapon/robot_module/robot/engineering
	pto_type = PTO_ENGINEERING

/obj/item/weapon/robot_module/robot/engineering/general
	vr_sprites = list(
						"Acheron" = "mechoid-Engineering",
						"Shellguard Noble" = "Noble-ENG",
						"ZOOM-BA" = "zoomba-engineering",
						"W02M" = "worm-engineering",
						"Feminine Humanoid" = "uptall-engineering"
					 )

/obj/item/weapon/robot_module/robot/research
	pto_type = PTO_SCIENCE

/obj/item/weapon/robot_module/robot/research/general
	vr_sprites = list(
						"Acheron" = "mechoid-Science",
						"ZOOM-BA" = "zoomba-research",
						"XI-GUS" = "spiderscience",
						"W02M" = "worm-janitor",
						"Feminine Humanoid" = "uptall-science"
					 )

/obj/item/weapon/robot_module/Reset(var/mob/living/silicon/robot/R)
	R.pixel_x = initial(pixel_x)
	R.pixel_y = initial(pixel_y)
	R.icon = initial(R.icon)
	R.dogborg = FALSE
	R.wideborg = FALSE
	R.ui_style_vr = FALSE
	R.default_pixel_x = initial(pixel_x)
	R.scrubbing = FALSE
	R.verbs -= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs -= /mob/living/silicon/robot/proc/robot_mount
	R.verbs -= /mob/living/proc/toggle_rider_reins
	R.verbs -= /mob/living/proc/shred_limb
	R.verbs -= /mob/living/silicon/robot/proc/rest_style
	..()
