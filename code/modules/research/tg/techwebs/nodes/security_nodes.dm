/datum/techweb_node/basic_arms
	id = TECHWEB_NODE_BASIC_ARMS
	starting_node = TRUE
	display_name = "Basic Arms"
	description = "Ballistics can be unpredictable in space."
	design_ids = list(
		"dartgun_r",
		"dartgun_mag_s",
		"dartgun_ammo_s",
		"dartgun_mag_m",
		"dartgun_ammo_m",
		// "toy_armblade",
		// "toygun",
		// "capbox",
		// "foam_dart",
		"knuckledusters",
		"tacknife"
	)

// Basic pistol rounds
/datum/techweb_node/pistol_ammo
	id = TECHWEB_NODE_PISTOL_AMMO
	starting_node = TRUE
	display_name = "Pistol Ammunition"
	description = "The smallest of small arms come in a variety of flavors!"
	design_ids = list(
		// 44
		"pistol_mag_44",
		"pistol_mag_44_rubber",
		// 45
		"pistol_mag_45",
		"pistol_mag_45_practice",
		"pistol_mag_45_rubber",
		"pistol_mag_45_flash",
		"pistol_mag_45_piercing",
		"pistol_mag_45_hollow",
		// 9mm
		"pistol_mag_9mm",
		"pistol_mag_9mm_rubber",
		"pistol_mag_9mm_practice",
		"pistol_mag_9mm_flash",
		// Others
		"pistol_mag_10m",
	)

// Only works with a few pistols
/datum/techweb_node/pistol_special
	id = TECHWEB_NODE_PISTOL_SPECIAL
	starting_node = TRUE
	display_name = "Specialty Pistol Ammunition"
	description = "Special bangs for those special bucks."
	design_ids = list(
		// concealable
		"pistol_mag_compact_9mm",
		"pistol_mag_compact_9mm_rubber",
		"pistol_mag_compact_9mm_practice",
		"pistol_mag_compact_9mm_flash",
	)

// Basic rifles
/datum/techweb_node/rifle_ammo
	id = TECHWEB_NODE_RIFLE_AMMO
	starting_node = TRUE
	display_name = "Rifle Ammunition"
	description = "Shoot for the moon, even if you miss you'll probably hit the intern anyway."
	design_ids = list(
		"rifle_mag_545",
		"rifle_mag_545_practice",
		"rifle_mag_762",
		"smg_mag_9mm",
	)

// Only works with a few specific guns
/datum/techweb_node/rifle_ammo_special
	id = TECHWEB_NODE_RIFLE_SPECIAL
	starting_node = TRUE
	display_name = "Specialty Rifle Ammunition"
	description = "Sometimes you just need more gun."
	design_ids = list(
		// Rattle em boys!
		"uzi_mag_45",
		"tommy_mag_45",
		"tommy_drum_45",
		// big guns
		"machinegun_box_545",
		"rifle_145_sabot",
		// P90
		"pistol_mag_topmount_9mm",
		"pistol_mag_topmount_9mm_rubber",
		"pistol_mag_topmount_9mm_practice",
		"pistol_mag_topmount_9mm_flash",
		"pistol_mag_topmount_9mm_piercing",
	)

// Shotgun shells
/datum/techweb_node/shotgun_ammo
	id = TECHWEB_NODE_SHOTGUN_AMMO
	starting_node = TRUE
	display_name = "Shotgun Ammunition"
	description = "Why aim when you can just shoot more bullet per bullet?"
	design_ids = list(
		"ammo_12g_slug",
		"ammo_12g_blank",
		"ammo_12g_beanbag",
		"ammo_12g_flash",
		"ammo_12g_pellet",
		"ammo_12g_stun",
		"ammo_12g_flechette",
	)

// Faster reloading
/datum/techweb_node/speedloaders
	id = TECHWEB_NODE_SPEEDLOADERS
	starting_node = TRUE
	display_name = "Speedloaders"
	description = "Trying to reload bullet by bullet in the middle of a gunfight is probably a bad idea."
	design_ids = list(
		// Revolvers
		"loader_357",
		"loader_357_flash",
		"loader_357_stun",
		"loader_357_rubber",
		"loader_45",
		"loader_45_rubber",
		"loader_38",
		"loader_38_rubber",
		"loader_44",
		"loader_44_rubber",
		// Shotty
		"loader_12g_beanbag",
		"loader_12g_slug",
		"loader_12g_buck",
		// Stripperclips
		"loader_545",
		"loader_545_practice",
		"loader_762",
		"loader_762_practice",
	)

/datum/techweb_node/sec_equip
	id = TECHWEB_NODE_SEC_EQUIP
	display_name = "Security Equipment"
	description = "All the essentials to subdue a mime."
	prereq_ids = list(TECHWEB_NODE_BASIC_ARMS)
	design_ids = list(
		"seccamera",
		"sec_data",
		"prisonmanage",
		"pointdefense",
		"pointdefense_control",
		"handcuffs",
		"legcuffs",
		"legcuffs_fuzzy",
		// "mining",
		// "rdcamera",
		// "security_photobooth",
		// "photobooth",
		// "scanner_gate",
		// "pepperspray",
		// "dragnet_beacon",
		// "inspector",
		// "evidencebag",
		// "zipties",
		// "seclite",
		// "electropack",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SECURITY)

/datum/techweb_node/riot_supression
	id = TECHWEB_NODE_RIOT_SUPRESSION
	display_name = "Riot Supression"
	description = "When you are on the opposing side of a revolutionary movement."
	prereq_ids = list(TECHWEB_NODE_SEC_EQUIP)
	design_ids = list(
		"netgun",
		"sizenetgun",
		"sickshot",
		"pummeler",
		"protector",
		"fuelrod_gun",
		"chargesword",
		"chargeaxe",
		"riflescope",
		"motion_tracker",
		"hunt_trap",
		"recon_skimmer",
		// "clown_firing_pin",
		// "pin_testing",
		// "pin_loyalty",
		// "tele_shield",
		// "ballistic_shield",
		// "handcuffs_s",
		// "bola_energy",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_SECURITY)

/datum/techweb_node/explosives
	id = TECHWEB_NODE_EXPLOSIVES
	display_name = "Explosives"
	description = "For once, intentional explosions."
	prereq_ids = list(TECHWEB_NODE_RIOT_SUPRESSION)
	design_ids = list(
		"large_Grenade",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	// required_experiments = list(/datum/experiment/ordnance/explosive/lowyieldbomb)
	announce_channels = list(CHANNEL_SECURITY, CHANNEL_MEDICAL)

/datum/techweb_node/exotic_ammo
	id = TECHWEB_NODE_EXOTIC_AMMO
	display_name = "Exotic Ammunition"
	description = "Specialized bullets designed to ignite, freeze, and inflict various other effects on targets, expanding combat capabilities."
	prereq_ids = list(TECHWEB_NODE_EXPLOSIVES)
	design_ids = list(
		"smg",
		"ammo_9mm",
		"magnetic_ammo",
		"stunshell",
		"empshell",
		"ptrshell",
		"monkey_gun",
		// "c38_hotshot",
		// "c38_hotshot_mag",
		// "c38_iceblox",
		// "c38_iceblox_mag",
		// "c38_trac",
		// "c38_trac_mag",
		// "c38_true_strike",
		// "c38_true_strike_mag",
		// "techshotshell",
		// "flechetteshell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	// discount_experiments = list(/datum/experiment/ordnance/explosive/highyieldbomb = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SECURITY)

/datum/techweb_node/electric_weapons
	id = TECHWEB_NODE_ELECTRIC_WEAPONS
	display_name = "Electric Weaponry"
	description = "Energy-based weaponry designed for both lethal and non-lethal applications."
	prereq_ids = list(TECHWEB_NODE_RIOT_SUPRESSION)
	design_ids = list(
		"stunrevolver",
		"temp_gun",
		"vinstunrevolver",
		// "ioncarbine",
		// "lasershell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_SECURITY)

/datum/techweb_node/beam_weapons
	id = TECHWEB_NODE_BEAM_WEAPONS
	display_name = "Advanced Beam Weaponry"
	description = "So advanced, even engineers are baffled by its operational principles."
	prereq_ids = list(TECHWEB_NODE_ELECTRIC_WEAPONS)
	design_ids = list(
		"nuclear_gun",
		"ppistol",
		"lasercannon",
		"decloner",
		"advparticle",
		"pressureinterlock",
		"particlecannon",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SECURITY)

/datum/techweb_node/gun_nsfw
	id = TECHWEB_NODE_NSFW
	display_name = "'NSFW' Gun"
	description = "Experimental N.S.F.W. Revolver."
	prereq_ids = list(TECHWEB_NODE_EXOTIC_AMMO)
	design_ids = list(
		"nsfw_prototype",
		"nsfw_mag_prototype",
		"nsfw_cell_stun",
		"nsfw_cell_lethal",
		"nsfw_cell_net",
		"nsfw_cell_ion",
		"nsfw_cell_shotstun",
		"nsfw_cell_xray",
		"nsfw_cell_stripper",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_SECURITY)
