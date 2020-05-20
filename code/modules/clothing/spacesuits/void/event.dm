//Refurbished Set
//Voidsuits from old Terran exploration vessels and naval ships.

//Standard Crewsuit (GRAY)
//Nothing really special here. Some light resists for mostly-non-combat purposes. The rad protection ain't bad?
//The reduced slowdown is an added bonus - something to make it worth considering using if you do find it.
/obj/item/clothing/head/helmet/space/void/refurb
	name = "vintage crewman's voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. This one is devoid of any identifying markings or rank indicators."
	icon_state = "rig0-vintagecrew"
	icon = 'icons/obj/clothing/helmets_vr.dmi'
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 30, bullet = 15, laser = 15,energy = 5, bomb = 20, bio = 100, rad = 50)
	light_overlay = "helmet_light"
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/helmet_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/helmet_vr.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/helmet_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/helmet_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ 			= 'icons/obj/clothing/species/tajaran/helmets_vr.dmi', // Copied from void.dm
		SPECIES_SKRELL			= 'icons/obj/clothing/species/skrell/helmets_vr.dmi',  // Copied from void.dm
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/helmets_vr.dmi',  // Copied from void.dm
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/species/unathi/helmets_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/unathi/helmets_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/unathi/helmets_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/species/vulpkanin/helmets_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/species/vulpkanin/helmets_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/species/vulpkanin/helmets_vr.dmi'
		)
	sprite_sheets_refit = list()	//have to nullify this as well just to be thorough

/obj/item/clothing/suit/space/void/refurb
	name = "vintage crewman's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. This one is devoid of any identifying markings or rank indicators."
	icon_state = "rig-vintagecrew"
	icon = 'icons/obj/clothing/spacesuits_vr.dmi'
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	slowdown = 0.5
	armor = list(melee = 30, bullet = 15, laser = 15,energy = 5, bomb = 20, bio = 100, rad = 50)
	allowed = list(/obj/item/device/flashlight,
			/obj/item/weapon/tank,
			/obj/item/device/suit_cooling_unit,
			/obj/item/weapon/storage/briefcase/inflatable,
			/obj/item/device/gps,
			/obj/item/device/radio/beacon,
			/obj/item/weapon/pickaxe,
			/obj/item/weapon/shovel
			)
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/spacesuit_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/suit_vr.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/suit_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/suit_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ			= 'icons/obj/clothing/species/tajaran/spacesuits_vr.dmi', // Copied from void.dm
		SPECIES_SKRELL			= 'icons/obj/clothing/species/skrell/spacesuits_vr.dmi',  // Copied from void.dm
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/spacesuits_vr.dmi',  // Copied from void.dm
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/species/unathi/spacesuits_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/unathi/spacesuits_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/unathi/spacesuits_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/species/vulpkanin/spacesuits_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/species/vulpkanin/spacesuits_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/species/vulpkanin/spacesuits_vr.dmi'
		)

//Engineering Crewsuit (ORANGE, RING)
//This is probably the most appealing to get your hands on for basic protection and the specialist stuff
//Don't expect it to stand up to modern assault/laser rifles, but it'll make you a fair bit tougher against most low-end pistols and SMGs
/obj/item/clothing/head/helmet/space/void/refurb/engineering
	name = "vintage engineering voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. This one in particular seems to be an ode to the Ship of Theseus, but the insulation and radiation proofing are top-notch, and it has several oily stains that seem to be impossible to scrub off."
	icon_state = "rig0-vintageengi"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 40, bullet = 20, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 100)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/void/refurb/engineering
	name = "vintage engineering voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. This one in particular seems to be an ode to the Ship of Theseus, but the insulation and radiation proofing are top-notch. The chestplate bears the logo of an old shipyard - though you don't recognize the name."
	icon_state = "rig-vintageengi"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	slowdown = 1
	armor = list(melee = 40, bullet = 20, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 100)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	allowed = list(/obj/item/device/flashlight,
			/obj/item/weapon/tank,
			/obj/item/device/suit_cooling_unit,
			/obj/item/device/t_scanner,
			/obj/item/weapon/rcd,
			/obj/item/weapon/rcd_ammo,
			/obj/item/weapon/storage/toolbox,
			/obj/item/weapon/storage/briefcase/inflatable,
			/obj/item/device/gps,
			/obj/item/device/radio/beacon,
			/obj/item/weapon/tool,
			/obj/item/weapon/weldingtool,
			/obj/item/weapon/cell,
			/obj/item/weapon/pickaxe,
			/obj/item/weapon/shovel
			)

//Medical Crewsuit (GREEN, CROSS)
//This thing is basically tissuepaper, but it has very solid rad protection for its age
//It also has the bonus of not slowing you down quite as much as other suits, same as the crew suit
/obj/item/clothing/head/helmet/space/void/refurb/medical
	name = "vintage medical voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. The green and white markings indicate this as a medic's suit."
	icon_state = "rig0-vintagemedic"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 30, bullet = 15, laser = 15, energy = 5, bomb = 25, bio = 100, rad = 75)

/obj/item/clothing/suit/space/void/refurb/medical
	name = "vintage medical voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. The green and white markings indicate this as a medic's suit."
	icon_state = "rig-vintagemedic"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	slowdown = 0.5
	armor = list(melee = 30, bullet = 15, laser = 15, energy = 5, bomb = 25, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight,
			/obj/item/weapon/tank,
			/obj/item/device/suit_cooling_unit,
			/obj/item/weapon/storage/firstaid,
			/obj/item/device/healthanalyzer,
			/obj/item/stack/medical,
			/obj/item/device/gps,
			/obj/item/device/radio/beacon,
			/obj/item/weapon/cell
			)

//Marine Crewsuit (BLUE, SHIELD)
//Really solid, balance between Sec and Sec EVA, but it has slightly worse shock protection
/obj/item/clothing/head/helmet/space/void/refurb/marine
	name = "vintage marine's voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. The blue markings indicate this as the marine/guard variant, likely from a merchant ship."
	icon_state = "rig0-vintagemarine"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 40, bullet = 35, laser = 35, energy = 5, bomb = 40, bio = 100, rad = 50)
	siemens_coefficient = 0.8

/obj/item/clothing/suit/space/void/refurb/marine
	name = "vintage marine's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer marines swear by these old things, even if new powered hardsuits have more features and better armor. The blue markings indicate this as the marine/guard variant, likely from a merchant ship."
	icon_state = "rig-vintagemarine"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	slowdown = 1
	armor = list(melee = 40, bullet = 35, laser = 35, energy = 5, bomb = 40, bio = 100, rad = 50)
	siemens_coefficient = 0.8
	allowed = list(/obj/item/weapon/gun,
			/obj/item/device/flashlight,
			/obj/item/weapon/tank,
			/obj/item/device/suit_cooling_unit,
			/obj/item/weapon/melee,
			/obj/item/device/gps,
			/obj/item/device/radio/beacon,
			/obj/item/weapon/handcuffs,
			/obj/item/ammo_magazine,
			/obj/item/weapon/cell
			)

//Officer Crewsuit (GOLD, X)
//The best of the bunch - at the time, this would have been almost cutting edge
//Now it's good, but it's badly outclassed by the hot shit that the TSCs and such can get 
/obj/item/clothing/head/helmet/space/void/refurb/officer
	name = "vintage officer's voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. This variant appears to be an officer's, and has the best protection of all the old models."
	icon_state = "rig0-vintageofficer"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 50, bullet = 45, laser = 45, energy = 10, bomb = 30, bio = 100, rad = 60)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/space/void/refurb/officer
	name = "vintage officer's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. This variant appears to be an officer's, and has the best protection of all the old models."
	icon_state = "rig-vintageofficer"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	slowdown = 1
	armor = list(melee = 50, bullet = 45, laser = 45, energy = 10, bomb = 30, bio = 100, rad = 60)
	siemens_coefficient = 0.7
	allowed = list(/obj/item/weapon/gun,
			/obj/item/device/flashlight,
			/obj/item/weapon/tank,
			/obj/item/device/suit_cooling_unit,
			/obj/item/weapon/melee,
			/obj/item/device/gps,
			/obj/item/device/radio/beacon,
			/obj/item/weapon/handcuffs,
			/obj/item/ammo_magazine,
			/obj/item/weapon/cell
			)