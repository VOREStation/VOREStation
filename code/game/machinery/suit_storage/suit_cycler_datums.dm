GLOBAL_LIST_EMPTY(suit_cycler_departments)
GLOBAL_LIST_EMPTY(suit_cycler_species)
GLOBAL_LIST_EMPTY(suit_cycler_emagged)

/datum/suit_cycler_choice
	var/name = null

/datum/suit_cycler_choice/department
	/// Name of the choice in the suit cycler menu
	name = null
	/// Type path of the suit to produce
	var/suit_becomes
	/// Type path of the helmet to produce
	var/helmet_becomes

/datum/suit_cycler_choice/department/proc/can_refit_helmet(obj/item/clothing/head/helmet/helmet)
	return helmet && !!helmet_becomes

/datum/suit_cycler_choice/department/proc/do_refit_helmet(obj/item/clothing/head/helmet/helmet)
	var/obj/item/clothing/tmp = new helmet_becomes()
	helmet.name = "refitted [tmp.name]"
	helmet.desc = tmp.desc
	helmet.icon = tmp.icon
	helmet.icon_state = tmp.icon_state
	helmet.item_state = tmp.item_state
	helmet.item_state_slots = tmp.item_state_slots?.Copy()
	helmet.sprite_sheets = tmp.sprite_sheets?.Copy()
	helmet.sprite_sheets_obj = tmp.sprite_sheets_obj?.Copy()
	helmet.default_worn_icon = tmp.default_worn_icon

/datum/suit_cycler_choice/department/proc/can_refit_suit(obj/item/clothing/suit/space/suit)
	return suit && !!suit_becomes

/datum/suit_cycler_choice/department/proc/do_refit_suit(obj/item/clothing/suit/space/suit)
	var/obj/item/clothing/tmp = new suit_becomes()
	suit.name = "refitted [tmp.name]"
	suit.desc = tmp.desc
	suit.icon = tmp.icon
	suit.icon_state = tmp.icon_state
	suit.item_state = tmp.item_state
	suit.item_state_slots = tmp.item_state_slots?.Copy()
	suit.sprite_sheets = tmp.sprite_sheets?.Copy()
	suit.sprite_sheets_obj = tmp.sprite_sheets_obj?.Copy()
	suit.default_worn_icon = tmp.default_worn_icon

// Ye olde 'noop' choice for refits
/datum/suit_cycler_choice/department/noop
	name = "No Change"
/datum/suit_cycler_choice/department/noop/can_refit_helmet(obj/item/clothing/head/helmet/helmet)
	return TRUE
/datum/suit_cycler_choice/department/noop/do_refit_helmet(obj/item/clothing/head/helmet/helmet)
	return
/datum/suit_cycler_choice/department/noop/can_refit_suit(obj/item/clothing/suit/space/suit)
	return TRUE
/datum/suit_cycler_choice/department/noop/do_refit_suit(obj/item/clothing/suit/space/suit)
	return



/datum/suit_cycler_choice/department/eng/standard
	name = "Engineering"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/engineering
	suit_becomes = /obj/item/clothing/suit/space/void/engineering
/datum/suit_cycler_choice/department/eng/reinforced
	name = "Reinforced Engineering"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/engineering/alt
	suit_becomes = /obj/item/clothing/suit/space/void/engineering/alt
/datum/suit_cycler_choice/department/eng/commonwealth_standard
	name = "Commonwealth Engineering"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/engineering/alt2
	suit_becomes = /obj/item/clothing/suit/space/void/engineering/alt2
/datum/suit_cycler_choice/department/eng/atmospherics
	name = "Atmospherics"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/atmos
	suit_becomes = /obj/item/clothing/suit/space/void/atmos
/datum/suit_cycler_choice/department/eng/heavyduty
	name = "Heavy Duty Atmos"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/atmos/alt
	suit_becomes = /obj/item/clothing/suit/space/void/atmos/alt
/datum/suit_cycler_choice/department/eng/commonwealth_atmos
	name = "Commonwealth Atmos"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/atmos/alt2
	suit_becomes = /obj/item/clothing/suit/space/void/atmos/alt2
/datum/suit_cycler_choice/department/eng/hazmat
	name = "HAZMAT"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/engineering/hazmat
	suit_becomes = /obj/item/clothing/suit/space/void/engineering/hazmat
/datum/suit_cycler_choice/department/eng/construction
	name = "Construction"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/engineering/construction
	suit_becomes = /obj/item/clothing/suit/space/void/engineering/construction
/datum/suit_cycler_choice/department/eng/salvager
	name = "Salvager"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/engineering/salvage
	suit_becomes = /obj/item/clothing/suit/space/void/engineering/salvage

/datum/suit_cycler_choice/department/crg/mining
	name = "Mining"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/mining
	suit_becomes = /obj/item/clothing/suit/space/void/mining
/datum/suit_cycler_choice/department/crg/frontiermining
	name = "Frontier Mining"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/mining/alt
	suit_becomes = /obj/item/clothing/suit/space/void/mining/alt
/datum/suit_cycler_choice/department/crg/commonwealth
	name = "Commonwealth Mining"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/mining/alt2
	suit_becomes = /obj/item/clothing/suit/space/void/mining/alt2


/datum/suit_cycler_choice/department/med/standard
	name = "Medical"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/medical
	suit_becomes = /obj/item/clothing/suit/space/void/medical
/datum/suit_cycler_choice/department/med/streamlined
	name = "Vey-Medical Lightweight"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/medical/veymed_static
	suit_becomes = /obj/item/clothing/suit/space/void/medical/veymed_static
/datum/suit_cycler_choice/department/med/commonwealth
	name = "Commonwealth Medical"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/medical/alt2
	suit_becomes = /obj/item/clothing/suit/space/void/medical/alt2
/datum/suit_cycler_choice/department/med/biohazard
	name = "Biohazard"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/medical/bio
	suit_becomes = /obj/item/clothing/suit/space/void/medical/bio
/datum/suit_cycler_choice/department/med/emt
	name = "Emergency Medical Response"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/medical/emt
	suit_becomes = /obj/item/clothing/suit/space/void/medical/emt


/datum/suit_cycler_choice/department/sec/standard
	name = "Security"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/security
	suit_becomes = /obj/item/clothing/suit/space/void/security
/datum/suit_cycler_choice/department/sec/riot
	name = "Crowd Control"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/security/riot
	suit_becomes = /obj/item/clothing/suit/space/void/security/riot
/datum/suit_cycler_choice/department/sec/commonwealth
	name = "Commonwealth Crowd Control"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/security/riot/alt
	suit_becomes = /obj/item/clothing/suit/space/void/security/riot/alt
/datum/suit_cycler_choice/department/sec/eva
	name = "Security EVA"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/security/alt
	suit_becomes = /obj/item/clothing/suit/space/void/security/alt


/datum/suit_cycler_choice/department/exp/standard
	name = "Exploration"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/exploration
	suit_becomes = /obj/item/clothing/suit/space/void/exploration
/datum/suit_cycler_choice/department/exp/medic
	name = "Field Medic"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/expedition_medical
	suit_becomes = /obj/item/clothing/suit/space/void/expedition_medical
/datum/suit_cycler_choice/department/exp/old
	name = "Old Exploration"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/exploration/alt
	suit_becomes = /obj/item/clothing/suit/space/void/exploration/alt
/datum/suit_cycler_choice/department/exp/commonwealth
	name = "Commonwealth Exploration"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/exploration/alt2
	suit_becomes = /obj/item/clothing/suit/space/void/exploration/alt2


/datum/suit_cycler_choice/department/pil/pilot
	name = "Pilot"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/pilot
	suit_becomes = /obj/item/clothing/suit/space/void/pilot
/datum/suit_cycler_choice/department/pil/pilot_blue
	name = "Pilot Blue"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/pilot/alt
	suit_becomes = /obj/item/clothing/suit/space/void/pilot/alt
/datum/suit_cycler_choice/department/pil/commonwealth
	name = "Commonwealth Pilot"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/pilot/alt2
	suit_becomes = /obj/item/clothing/suit/space/void/pilot/alt2


/datum/suit_cycler_choice/department/captain
	name = "Manager"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/captain
	suit_becomes = /obj/item/clothing/suit/space/void/captain
/datum/suit_cycler_choice/department/captain/commonwealth
	name = "Commonwealth Captain"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/captain/alt
	suit_becomes = /obj/item/clothing/suit/space/void/captain/alt


/datum/suit_cycler_choice/department/prototype
	name = "Prototype"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/security/prototype
	suit_becomes = /obj/item/clothing/suit/space/void/security/prototype


/datum/suit_cycler_choice/department/emag/merc
	name = "^%###^%$" || "Mercenary"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/merc
	suit_becomes = /obj/item/clothing/suit/space/void/merc
/datum/suit_cycler_choice/department/emag/pyro
	name = "Charring"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/merc/fire
	suit_becomes = /obj/item/clothing/suit/space/void/merc/fire


/datum/suit_cycler_choice/department/wizard
	name = "Gem-Encrusted" || "Wizard"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/wizard
	suit_becomes = /obj/item/clothing/suit/space/void/wizard


/datum/suit_cycler_choice/department/vintage/crew
	name = "Vintage Crew"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb
	suit_becomes = /obj/item/clothing/suit/space/void/refurb
/datum/suit_cycler_choice/department/vintage/eng
	name = "Vintage Engineering"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/engineering
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/engineering
/datum/suit_cycler_choice/department/vintage/marine
	name = "Vintage Marine"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/marine
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/marine
/datum/suit_cycler_choice/department/vintage/officer
	name = "Vintage Officer"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/officer
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/officer
/datum/suit_cycler_choice/department/vintage/research
	name = "Vintage Research (Bubble Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/research/alt
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/research
/datum/suit_cycler_choice/department/vintage/research/ch
	name = "Vintage Research (Closed Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/research
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/research
/datum/suit_cycler_choice/department/vintage/med
	name = "Vintage Medical (Bubble Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/medical/alt
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/medical
/datum/suit_cycler_choice/department/vintage/med/ch
	name = "Vintage Medical (Closed Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/medical
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/medical
/datum/suit_cycler_choice/department/vintage/merc
	name = "Vintage Mercenary"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/mercenary
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/mercenary
/datum/suit_cycler_choice/department/vintage/pilot
	name = "Vintage Pilot (Bubble Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/pilot
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/pilot
/datum/suit_cycler_choice/department/vintage/pilot/ch
	name = "Vintage Pilot (Closed Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/pilot/alt
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/pilot


/datum/suit_cycler_choice/department/talon/crew
	name = "Talon Crew"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/talon
/datum/suit_cycler_choice/department/talon/eng
	name = "Talon Engineering"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/engineering/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/engineering/talon
/datum/suit_cycler_choice/department/talon/med
	name = "Talon Medical (Bubble Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/medical/alt/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/medical/talon
/datum/suit_cycler_choice/department/talon/med/ch
	name = "Talon Medical (Closed Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/medical/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/medical/talon
/datum/suit_cycler_choice/department/talon/officer
	name = "Talon Officer"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/officer/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/officer/talon
/datum/suit_cycler_choice/department/talon/pilot
	name = "Talon Pilot (Bubble Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/pilot/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/pilot/talon
/datum/suit_cycler_choice/department/talon/pilot/ch
	name = "Talon Pilot (Closed Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/pilot/alt/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/pilot/talon
/datum/suit_cycler_choice/department/talon/miner
	name = "Talon Miner"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/mining/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/mining/talon
/datum/suit_cycler_choice/department/talon/res
	name = "Talon Research (Bubble Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/research/alt/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/research/talon
/datum/suit_cycler_choice/department/talon/res/ch
	name = "Talon Research (Closed Helm)"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/research/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/research/talon
/datum/suit_cycler_choice/department/talon/marine
	name = "Talon Marine"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/marine/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/marine/talon
/datum/suit_cycler_choice/department/talon/marine/alt
	name = "Talon Mercenary"
	helmet_becomes = /obj/item/clothing/head/helmet/space/void/refurb/mercenary/talon
	suit_becomes = /obj/item/clothing/suit/space/void/refurb/mercenary/talon



// Uses same logic as it used to, which is that it bases an assumption of 'we should have custom sprites' on
// the presence of the species in the sprite_sheets_obj list on the helmet and suit
/datum/suit_cycler_choice/species/proc/can_refit_to(...)
	for(var/obj/item/clothing/C in args)
		if(LAZYACCESS(C.sprite_sheets_obj, name))
			if(!(C.icon_state in cached_icon_states(C.sprite_sheets_obj[name])))
				return FALSE // Species was in sprite_sheets_obj, but had no sprite for this object in particular

	return TRUE

/datum/suit_cycler_choice/species/proc/do_refit_to(...)
	for(var/obj/item/clothing/C in args)
		C.refit_for_species(name)

/datum/suit_cycler_choice/species/noop
	name = "No Change"
/datum/suit_cycler_choice/species/noop/can_refit_to(obj/item/clothing/head/helmet/helmet, obj/item/clothing/suit/space/suit)
	return TRUE
/datum/suit_cycler_choice/species/noop/do_refit_to(obj/item/clothing/head/helmet/helmet, obj/item/clothing/suit/space/suit)
	return

/datum/suit_cycler_choice/species/human
	name = SPECIES_HUMAN
/datum/suit_cycler_choice/species/skrell
	name = SPECIES_SKRELL
/datum/suit_cycler_choice/species/unathi
	name = SPECIES_UNATHI
/datum/suit_cycler_choice/species/tajaran
	name = SPECIES_TAJARAN
/datum/suit_cycler_choice/species/teshari
	name = SPECIES_TESHARI
/datum/suit_cycler_choice/species/akula
	name = SPECIES_AKULA
/datum/suit_cycler_choice/species/sergal
	name = SPECIES_SERGAL
/datum/suit_cycler_choice/species/vulpkanin
	name = SPECIES_VULPKANIN
/datum/suit_cycler_choice/species/altevian
	name = SPECIES_ALTEVIAN
