//Refurbished Set
//Voidsuits from old Terran exploration vessels and naval ships.

//Standard Crewsuit (GRAY)
//Nothing really special here. Some light resists for mostly-non-combat purposes. The rad protection ain't bad?
//The reduced slowdown is an added bonus - something to make it worth considering using if you do find it.
/obj/item/clothing/head/helmet/space/void/refurb
	name = "vintage crewman's voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. This one is devoid of any identifying markings or rank indicators."
	icon_state = "rig0-vintagecrew"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 30, bullet = 15, laser = 15,energy = 5, bomb = 20, bio = 100, rad = 50)
	light_overlay = "helmet_light"

/obj/item/clothing/suit/space/void/refurb
	name = "vintage crewman's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. This one is devoid of any identifying markings or rank indicators."
	icon_state = "rig-vintagecrew"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	armor = list(melee = 30, bullet = 15, laser = 15,energy = 5, bomb = 20, bio = 100, rad = 50)
	allowed = list(/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/storage/briefcase/inflatable,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/pickaxe,
			/obj/item/shovel
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
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE+10000

/obj/item/clothing/suit/space/void/refurb/engineering
	name = "vintage engineering voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. This one in particular seems to be an ode to the Ship of Theseus, but the insulation and radiation proofing are top-notch. The chestplate bears the logo of an old shipyard - though you don't recognize the name."
	icon_state = "rig-vintageengi"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	slowdown = 1
	armor = list(melee = 40, bullet = 20, laser = 20, energy = 5, bomb = 35, bio = 100, rad = 100)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE+10000
	breach_threshold = 14 //These are kinda thicc
	allowed = list(/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/t_scanner,
			/obj/item/rcd,
			/obj/item/rcd_ammo,
			/obj/item/storage/toolbox,
			/obj/item/storage/briefcase/inflatable,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/robotanalyzer,
			/obj/item/geiger,
			/obj/item/tool,
			/obj/item/weldingtool,
			/obj/item/cell,
			/obj/item/pickaxe,
			/obj/item/measuring_tape,
			/obj/item/lightreplacer,
			/obj/item/shovel
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

/obj/item/clothing/head/helmet/space/void/refurb/medical/alt
	name = "vintage medical voidsuit bubble helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor on this model has been expanded to the full bubble design to improve visibility. Wouldn't want to lose a scalpel in someone's abdomen because your visor fogged over!"
	icon_state = "rig0-vintagepilot"

/obj/item/clothing/suit/space/void/refurb/medical
	name = "vintage medical voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. The green and white markings indicate this as a medic's suit."
	icon_state = "rig-vintagemedic"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	armor = list(melee = 30, bullet = 15, laser = 15, energy = 5, bomb = 25, bio = 100, rad = 75)
	allowed = list(/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/storage/firstaid,
			/obj/item/healthanalyzer,
			/obj/item/robotanalyzer,
			/obj/item/mass_spectrometer,
			/obj/item/halogen_counter,
			/obj/item/stack/medical,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/cell
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
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15 //Armored
	siemens_coefficient = 0.8
	allowed = list(/obj/item/gun,
			/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/melee,
			/obj/item/grenade,
			/obj/item/flash,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/handcuffs,
			/obj/item/hailer,
			/obj/item/holowarrant,
			/obj/item/megaphone,
			/obj/item/ammo_magazine,
			/obj/item/cell
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
	breach_threshold = 16 //Extra Thicc
	resilience = 0.1 //Heavily Armored
	siemens_coefficient = 0.7
	allowed = list(/obj/item/gun,
			/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/melee,
			/obj/item/grenade,
			/obj/item/flash,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/handcuffs,
			/obj/item/hailer,
			/obj/item/holowarrant,
			/obj/item/megaphone,
			/obj/item/ammo_magazine,
			/obj/item/cell
			)

//Pilot Crewsuit (ROYAL BLUE, I)
//The lightest weight of the lot, but protection is about the same as the crew variant's. It has an extra helmet variant for those who prefer that design.
/obj/item/clothing/head/helmet/space/void/refurb/pilot
	name = "vintage pilot's voidsuit bubble helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The standard pilot model has a nice clear bubble helmet that doesn't fog up easily and has much better visibility, at the cost of relatively poor protection."
	icon_state = "rig0-vintagepilot"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 5, bomb = 20, bio = 100, rad = 50)
	siemens_coefficient = 0.9

//fluff alt-variant helmet, no changes to protection or anything despite the desc (and it wouldn't matter unless you found a base-type since armor values aren't transferred during refits)
/obj/item/clothing/head/helmet/space/void/refurb/pilot/alt
	name = "vintage pilot's voidsuit helmet"
	desc = "For pilots who don't like the increased fracture vulnerability of the huge visor, overrides exist in certain cyclers that allow pilots to use the conventional helmet design. It's a little more claustrophobic, but some find the all-round protection to be worth the loss in visibility."
	icon_state = "rig0-vintagepilotalt"

/obj/item/clothing/suit/space/void/refurb/pilot
	name = "vintage pilot's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. The royal blue markings indicate this is the pilot's variant; low protection but ultra-lightweight."
	icon_state = "rig-vintagepilot"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	slowdown = 0
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 5, bomb = 20, bio = 100, rad = 50)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/storage/briefcase/inflatable,
			/obj/item/gps,
			/obj/item/radio/beacon,
			)

//Scientist Crewsuit (PURPLE, O)
//Baseline values are slightly worse than the gray crewsuit, but it has significantly better Energy protection and is the only other suit with 100% rad immunity besides the engi suit
/obj/item/clothing/head/helmet/space/void/refurb/research
	name = "vintage research voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. The purple markings indicate this as a scientist's helmet. Got your crowbar handy?"
	icon_state = "rig0-vintagescientist"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 25, bullet = 10, laser = 10, energy = 50, bomb = 10, bio = 100, rad = 100)
	siemens_coefficient = 0.8

/obj/item/clothing/head/helmet/space/void/refurb/research/alt
	name = "vintage research voidsuit bubble helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. This version has been refitted with the distinctive bubble design to increase visibility, so that you can see what you're sciencing better!"
	icon_state = "rig0-vintagepilot"

/obj/item/clothing/suit/space/void/refurb/research
	name = "vintage research voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. The purple markings indicate this as a scientist's suit. Keep your eyes open for ropes."
	icon_state = "rig-vintagescientist"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	armor = list(melee = 25, bullet = 10, laser = 10, energy = 50, bomb = 10, bio = 100, rad = 100)
	siemens_coefficient = 0.8
	allowed = list(/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/storage/firstaid,
			/obj/item/healthanalyzer,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/ano_scanner,
			/obj/item/depth_scanner,
			/obj/item/xenoarch_multi_tool,
			/obj/item/measuring_tape,
			/obj/item/reagent_scanner,
			/obj/item/robotanalyzer,
			/obj/item/analyzer,
			/obj/item/cataloguer,
			/obj/item/universal_translator,
			/obj/item/tool/crowbar,
			/obj/item/stack/marker_beacon,
			/obj/item/stack/flag,
			/obj/item/clipboard,
			/obj/item/cell
			)

//Miner's Crewsuit (BROWN)
//Basically just the basic suit, but with brown markings. If anyone wants to tweak this, go wild.
/obj/item/clothing/head/helmet/space/void/refurb/mining
	name = "vintage miner's's voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. This one has brown markings, denoting it as a miner's helmet."
	icon_state = "rig0-vintageminer"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 30, bullet = 15, laser = 15,energy = 5, bomb = 20, bio = 100, rad = 50)
	light_overlay = "helmet_light"

/obj/item/clothing/suit/space/void/refurb/mining
	name = "vintage miner's voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer spacers swear by these old things, even if new powered hardsuits have more features and better armor. This one has brown markings, denoting it as a miner's suit."
	icon_state = "rig-vintageminer"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	armor = list(melee = 30, bullet = 15, laser = 15,energy = 5, bomb = 20, bio = 100, rad = 50)
	allowed = list(/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/storage/briefcase/inflatable,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/pickaxe,
			/obj/item/shovel
			)

//Mercenary Crewsuit (RED, CROSS)
//The best of the best, this should be ultra-rare
/obj/item/clothing/head/helmet/space/void/refurb/mercenary
	name = "vintage mercenary voidsuit helmet"
	desc = "A refurbished early contact era voidsuit helmet of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. The visor has a bad habit of fogging up and collecting condensation, but it beats sucking hard vacuum. The red markings indicate this as the mercenary variant. The company ID has been scratched off."
	icon_state = "rig0-vintagemerc"
	item_state_slots = list(slot_r_hand_str = "syndicate-helm-black", slot_l_hand_str = "syndicate-helm-black")
	armor = list(melee = 55, bullet = 45, laser = 45, energy = 25, bomb = 50, bio = 100, rad = 50)
	siemens_coefficient = 0.6

/obj/item/clothing/suit/space/void/refurb/mercenary
	name = "vintage mercenary voidsuit"
	desc = "A refurbished early contact era voidsuit of human design. These things aren't especially good against modern weapons but they're sturdy, incredibly easy to come by, and there are lots of spare parts for repairs. Many old-timer mercs swear by these old things, even if new powered hardsuits have more features and better armor. The red markings indicate this as the mercenary variant. The company ID has been scratched off."
	icon_state = "rig-vintagemerc"
	item_state_slots = list(slot_r_hand_str = "sec_voidsuitTG", slot_l_hand_str = "sec_voidsuitTG")
	slowdown = 1.5 //the tradeoff for being hot shit almost on par with a crimson suit is that it slows you down even more
	armor = list(melee = 55, bullet = 45, laser = 45, energy = 25, bomb = 50, bio = 100, rad = 50)
	breach_threshold = 16 //Extra Thicc
	resilience = 0.05 //Military Armor
	siemens_coefficient = 0.6
	allowed = list(/obj/item/gun,
			/obj/item/flashlight,
			/obj/item/tank,
			/obj/item/suit_cooling_unit,
			/obj/item/melee,
			/obj/item/grenade,
			/obj/item/flash,
			/obj/item/gps,
			/obj/item/radio/beacon,
			/obj/item/handcuffs,
			/obj/item/hailer,
			/obj/item/holowarrant,
			/obj/item/megaphone,
			/obj/item/ammo_magazine,
			/obj/item/spaceflare,
			/obj/item/powersink,
			/obj/item/radio_jammer,
			/obj/item/cell
			)
