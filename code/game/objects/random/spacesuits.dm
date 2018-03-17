
// Spaceproof clothing sets go in here

/obj/random/multiple/voidsuit
	name = "Random Voidsuit"
	desc = "This is a random voidsuit."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "void"

/obj/random/multiple/voidsuit/item_to_spawn()
	return pick(
			prob(5);list(
				/obj/item/clothing/suit/space/void,
				/obj/item/clothing/head/helmet/space/void
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/atmos,
				/obj/item/clothing/head/helmet/space/void/atmos
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/atmos/alt,
				/obj/item/clothing/head/helmet/space/void/atmos/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering,
				/obj/item/clothing/head/helmet/space/void/engineering
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering/alt,
				/obj/item/clothing/head/helmet/space/void/engineering/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering/construction,
				/obj/item/clothing/head/helmet/space/void/engineering/construction
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering/salvage,
				/obj/item/clothing/head/helmet/space/void/engineering/salvage
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical,
				/obj/item/clothing/head/helmet/space/void/medical
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical/alt,
				/obj/item/clothing/head/helmet/space/void/medical/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical/bio,
				/obj/item/clothing/head/helmet/space/void/medical/bio
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical/emt,
				/obj/item/clothing/head/helmet/space/void/medical/emt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/merc,
				/obj/item/clothing/head/helmet/space/void/merc
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/mining,
				/obj/item/clothing/head/helmet/space/void/mining
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/mining/alt,
				/obj/item/clothing/head/helmet/space/void/mining/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/security,
				/obj/item/clothing/head/helmet/space/void/security
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/security/alt,
				/obj/item/clothing/head/helmet/space/void/security/alt
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/security/riot,
				/obj/item/clothing/head/helmet/space/void/security/riot
			)
		)

/obj/random/multiple/voidsuit/mining
	name = "Random Mining Voidsuit"
	desc = "This is a random mining voidsuit."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "rig-mining"

/obj/random/multiple/voidsuit/mining/item_to_spawn()
	return pick(
			prob(5);list(
				/obj/item/clothing/suit/space/void/mining,
				/obj/item/clothing/head/helmet/space/void/mining
			),
			prob(1);list(
				/obj/item/clothing/suit/space/void/mining/alt,
				/obj/item/clothing/head/helmet/space/void/mining/alt
			)
		)


/obj/random/rigsuit
	name = "Random rigsuit"
	desc = "This is a random rigsuit."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"

/obj/random/rigsuit/item_to_spawn()
	return pick(prob(4);/obj/item/weapon/rig/light/hacker,
				prob(5);/obj/item/weapon/rig/industrial,
				prob(5);/obj/item/weapon/rig/eva,
				prob(4);/obj/item/weapon/rig/light/stealth,
				prob(3);/obj/item/weapon/rig/hazard,
				prob(1);/obj/item/weapon/rig/merc/empty)