
// Spaceproof clothing sets go in here

/obj/random/multiple/voidsuit
	name = "Random Voidsuit"
	desc = "This is a random voidsuit."
	icon = 'icons/inventory/suit/item.dmi'
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
				/obj/item/clothing/suit/space/void/engineering/hazmat,
				/obj/item/clothing/head/helmet/space/void/engineering/hazmat
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
				/obj/item/clothing/suit/space/void/medical/veymed,
				/obj/item/clothing/head/helmet/space/void/medical/veymed
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
				/obj/item/clothing/suit/space/void/merc/fire,
				/obj/item/clothing/head/helmet/space/void/merc/fire
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
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/exploration,
				/obj/item/clothing/head/helmet/space/void/exploration
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/pilot,
				/obj/item/clothing/head/helmet/space/void/pilot
			)
		)

/obj/random/multiple/voidsuit/mining
	name = "Random Mining Voidsuit"
	desc = "This is a random mining voidsuit."
	icon = 'icons/inventory/suit/item.dmi'
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

/obj/random/multiple/voidsuit/engineering
	name = "Random Engineering Voidsuit"
	desc = "This is a random engineering voidsuit."
	icon = 'icons/inventory/suit/item.dmi'
	icon_state = "rig-engineering"

/obj/random/multiple/voidsuit/engineering/item_to_spawn()
	return pick(
			prob(35);list(
				/obj/item/clothing/suit/space/void/engineering,
				/obj/item/clothing/head/helmet/space/void/engineering
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering/alt,
				/obj/item/clothing/head/helmet/space/void/engineering/alt
			),
			prob(15);list(
				/obj/item/clothing/suit/space/void/engineering/hazmat,
				/obj/item/clothing/head/helmet/space/void/engineering/hazmat
			),
			prob(15);list(
				/obj/item/clothing/suit/space/void/engineering/construction,
				/obj/item/clothing/head/helmet/space/void/engineering/construction
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/engineering/salvage,
				/obj/item/clothing/head/helmet/space/void/engineering/salvage
			)
		)

/obj/random/multiple/voidsuit/security
	name = "Random Security Voidsuit"
	desc = "This is a random security voidsuit."
	icon = 'icons/inventory/suit/item.dmi'
	icon_state = "rig-sec"

/obj/random/multiple/voidsuit/security/item_to_spawn()
	return pick(
			prob(10);list(
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

/obj/random/multiple/voidsuit/medical
	name = "Random Medical Voidsuit"
	desc = "This is a random medical voidsuit."
	icon = 'icons/inventory/suit/item.dmi'
	icon_state = "rig-medical"

/obj/random/multiple/voidsuit/medical/item_to_spawn()
	return pick(
			prob(5);list(
				/obj/item/clothing/suit/space/void/medical,
				/obj/item/clothing/head/helmet/space/void/medical
			),
			prob(1);list(
				/obj/item/clothing/suit/space/void/medical/veymed,
				/obj/item/clothing/head/helmet/space/void/medical/veymed
			),
			prob(3);list(
				/obj/item/clothing/suit/space/void/medical/bio,
				/obj/item/clothing/head/helmet/space/void/medical/bio
			),
			prob(4);list(
				/obj/item/clothing/suit/space/void/medical/emt,
				/obj/item/clothing/head/helmet/space/void/medical/emt
			)
		)

/obj/random/multiple/voidsuit/vintage
	name = "Random Vintage Voidsuit"
	desc = "This is a random vintage voidsuit."
	icon = 'icons/inventory/suit/item.dmi'
	icon_state = "rig-vintagecrew"

/obj/random/multiple/voidsuit/vintage/item_to_spawn()
	return pick(
			prob(20);list(
				/obj/item/clothing/suit/space/void/refurb,
				/obj/item/clothing/head/helmet/space/void/refurb
			),
			prob(20);list(
				/obj/item/clothing/suit/space/void/refurb/engineering,
				/obj/item/clothing/head/helmet/space/void/refurb/engineering
			),
			prob(10);list(
				/obj/item/clothing/suit/space/void/refurb/medical,
				/obj/item/clothing/head/helmet/space/void/refurb/medical
			),
			prob(10);list(
				/obj/item/clothing/suit/space/void/refurb/medical,
				/obj/item/clothing/head/helmet/space/void/refurb/medical/alt
			),
			prob(10);list(
				/obj/item/clothing/suit/space/void/refurb/marine,
				/obj/item/clothing/head/helmet/space/void/refurb/marine
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/refurb/officer,
				/obj/item/clothing/head/helmet/space/void/refurb/officer
			),
			prob(10);list(
				/obj/item/clothing/suit/space/void/refurb/pilot,
				/obj/item/clothing/head/helmet/space/void/refurb/pilot
			),

			prob(10);list(
				/obj/item/clothing/suit/space/void/refurb/pilot,
				/obj/item/clothing/head/helmet/space/void/refurb/pilot/alt
			),
			prob(10);list(
				/obj/item/clothing/suit/space/void/refurb/research,
				/obj/item/clothing/head/helmet/space/void/refurb/research
			),
			prob(10);list(
				/obj/item/clothing/suit/space/void/refurb/research,
				/obj/item/clothing/head/helmet/space/void/refurb/research/alt
			),
			prob(10);list(
				/obj/item/clothing/suit/space/void/refurb/mining,
				/obj/item/clothing/head/helmet/space/void/refurb/mining
			),
			prob(5);list(
				/obj/item/clothing/suit/space/void/refurb/mercenary,
				/obj/item/clothing/head/helmet/space/void/refurb/mercenary
			)
		)

/obj/random/rigsuit
	name = "Random rigsuit"
	desc = "This is a random rigsuit."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"

/obj/random/rigsuit/item_to_spawn()
	return pick(prob(4);/obj/item/rig/light/hacker,
				prob(5);/obj/item/rig/industrial,
				prob(5);/obj/item/rig/eva,
				prob(4);/obj/item/rig/light/stealth,
				prob(3);/obj/item/rig/hazard,
				prob(1);/obj/item/rig/merc/empty)
//VOREStation Add Start
/obj/random/rigsuit/chancetofail
	spawn_nothing_percentage = 50
//VOREStation Add End
