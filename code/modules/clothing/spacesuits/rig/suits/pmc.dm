/obj/item/clothing/head/helmet/space/rig/pmc
	light_overlay = "helmet_light_dual"

/obj/item/rig/pmc
	name = "PMC hardsuit control module"
	desc = "A suit worn by private military contractors. Armoured and space ready."
	suit_type = "PMC"
	icon_state = "pmc_commandergrey_rig"

	helm_type = /obj/item/clothing/head/helmet/space/rig/pmc

	req_access = list(access_cent_specops)

	armor = list(melee = 60, bullet = 50, laser = 35,energy = 15, bomb = 30, bio = 100, rad = 95)
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/t_scanner,
		/obj/item/rcd,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/multitool,
		/obj/item/radio,
		/obj/item/analyzer,
		/obj/item/melee/baton,
		/obj/item/gun,
		/obj/item/storage,
		/obj/item/reagent_containers/hypospray,
		/obj/item/roller
		)

/obj/item/rig/pmc/commander
	name = "PMC-C hardsuit control module"
	desc = "A suit worn by private military contractors. Armoured and space ready."
	suit_type = "PMC commander"
	icon_state = "pmc_commandergrey_rig"

/obj/item/rig/pmc/commander/grey/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/datajack,
		)

/obj/item/rig/pmc/commander/green
	icon_state = "pmc_commandergreen_rig"

/obj/item/rig/pmc/commander/green/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/datajack,
		)

/obj/item/rig/pmc/engineer
	name = "PMC-E suit control module"
	desc = "A suit worn by private military contractors. This one is setup for engineering. Armoured and space ready."
	suit_type = "PMC engineer"
	icon_state = "pmc_engineergrey_rig"
	armor = list(melee = 60, bullet = 50, laser = 35,energy = 15, bomb = 30, bio = 100, rad = 100)
	siemens_coefficient = 0

/obj/item/rig/pmc/engineer/grey/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd
		)

/obj/item/rig/pmc/engineer/green
	icon_state = "pmc_engineergreen_rig"

/obj/item/rig/pmc/engineer/green/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd
		)

/obj/item/rig/pmc/medical
	name = "PMC-M suit control module"
	desc = "A suit worn by private military contractors. This one is setup for medical. Armoured and space ready."
	suit_type = "PMC medic"
	icon_state = "pmc_medicalgrey_rig"

/obj/item/rig/pmc/medical/grey/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector/advanced
		)

/obj/item/rig/pmc/medical/green
	icon_state = "pmc_medicalgreen_rig"

/obj/item/rig/pmc/medical/green/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector/advanced
		)

/obj/item/rig/pmc/security
	name = "PMC-S suit control module"
	desc = "A suit worn by private military contractors. This one is setup for security. Armoured and space ready."
	suit_type = "PMC security"
	icon_state = "pmc_securitygrey_rig"

/obj/item/rig/pmc/security/grey/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/egun,
		)

/obj/item/rig/pmc/security/green
	icon_state = "pmc_securitygreen_rig"

/obj/item/rig/pmc/security/green/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/egun,
		)