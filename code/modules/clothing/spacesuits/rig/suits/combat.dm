/obj/item/clothing/head/helmet/space/rig/combat
	light_overlay = "helmet_light_dual_green"

/obj/item/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor = list(melee = 80, bullet = 65, laser = 50, energy = 15, bomb = 80, bio = 100, rad = 60)
	slowdown = 0.5
	offline_slowdown = 1.5
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/helmet/space/rig/combat
	allowed = list(
		/obj/item/gun,
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/melee/baton,
		/obj/item/storage
		)


/obj/item/rig/combat/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat
		)

/obj/item/rig/combat/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		)

/obj/item/rig/military
	name = "military hardsuit control module"
	desc = "An austere hardsuit used by paramilitary groups and real soldiers alike."
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor = list(melee = 80, bullet = 70, laser = 55, energy = 15, bomb = 80, bio = 100, rad = 30)
	slowdown = 0.5
	offline_slowdown = 1.5
	offline_vision_restriction = 1
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/t_scanner,
		/obj/item/rcd,
		/obj/item/weldingtool,
		/obj/item/tool,
		/obj/item/multitool,
		/obj/item/radio,
		/obj/item/analyzer,
		/obj/item/melee/baton,
		/obj/item/gun,
		/obj/item/storage,
		/obj/item/reagent_containers/hypospray,
		/obj/item/roller,
		/obj/item/suit_cooling_unit
		)

	chest_type = /obj/item/clothing/suit/space/rig/military
	helm_type = /obj/item/clothing/head/helmet/space/rig/military
	boot_type = /obj/item/clothing/shoes/magboots/rig/military
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/military

/obj/item/clothing/head/helmet/space/rig/military
	light_overlay = "helmet_light_dual_green"
	species_restricted = list(SPECIES_HUMAN,SPECIES_PROMETHEAN)

/obj/item/clothing/suit/space/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_PROMETHEAN)

/obj/item/clothing/shoes/magboots/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_PROMETHEAN)

/obj/item/clothing/gloves/gauntlets/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_PROMETHEAN)

/obj/item/rig/military/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		)

/obj/item/rig/military/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		)
