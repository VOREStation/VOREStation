/datum/techweb_node/medbay_equip
	id = TECHWEB_NODE_MEDBAY_EQUIP
	starting_node = TRUE
	display_name = "Medbay Equipment"
	description = "Essential medical tools to patch you up while medbay is still intact."
	design_ids = list(
		"operating",
		"scan_console",
		// "medicalbed",
		// "defibmountdefault",
		// "defibrillator",
		// "surgical_drapes",
		// "scalpel",
		// "retractor",
		// "hemostat",
		// "cautery",
		// "circular_saw",
		// "surgicaldrill",
		// "bonesetter",
		// "blood_filter",
		// "surgical_tape",
		// "penlight",
		// "penlight_paramedic",
		// "stethoscope",
		// "beaker",
		// "large_beaker",
		// "chem_pack",
		// "blood_pack",
		// "syringe",
		// "dropper",
		// "pillbottle",
		// "xlarge_beaker",
		// "organ_jar",
		// "jerrycan",
		// "reflex_hammer",
		// "blood_scanner",
	)

/datum/techweb_node/chem_synthesis
	id = TECHWEB_NODE_CHEM_SYNTHESIS
	display_name = "Chemical Synthesis"
	description = "Synthesizing complex chemicals from electricity and thin air... Don't ask how..."
	prereq_ids = list(TECHWEB_NODE_MEDBAY_EQUIP)
	design_ids = list(
		"chemmaster",
		"reagent_scanner",
		"mass_spectrometer",
		"improved_analyzer",
		"nanopaste",
		// "med_spray_bottle",
		// "medigel",
		// "medipen_refiller",
		// "soda_dispenser",
		// "beer_dispenser",
		// "chem_dispenser",
		// "portable_chem_mixer",
		// "chem_heater",
		// "w-recycler",
		// "meta_beaker",
		// "plumbing_rcd",
		// "plumbing_rcd_service",
		// "plunger",
		// "fluid_ducts",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_MEDICAL)

/datum/techweb_node/medbay_equip_adv
	id = TECHWEB_NODE_MEDBAY_EQUIP_ADV
	display_name = "Advanced Medbay Equipment"
	description = "State-of-the-art medical gear for keeping the crew in one piece — mostly."
	prereq_ids = list(TECHWEB_NODE_CHEM_SYNTHESIS)
	design_ids = list(
		"adv_mass_spectrometer",
		"adv_reagent_scanner",
		"advanced_analyzer",
		"recombobray",
		"vitals",
		"scalpel_laser1",
		"scalpel_laser2",
		"scalpel_laser3",
		"scalpel_manager",
		"advanced_saw",
		"organ_ripper",
		"bone_clamp",
		"roller_bed",
		// "smoke_machine",
		// "healthanalyzer_advanced",
		// "mod_health_analyzer",
		// "crewpinpointer",
		// "defibrillator_compact",
		// "defibmount",
		// "medicalbed_emergency",
		// "piercesyringe",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	required_experiments = list(/datum/experiment/scanning/points/easy_cytology)
	announce_channels = list(CHANNEL_MEDICAL)

/datum/techweb_node/cryostasis
	id = TECHWEB_NODE_CRYOSTASIS
	display_name = "Cryostasis"
	description = "The result of clown accidentally drinking a chemical, now repurposed for safely preserving crew members in suspended animation."
	prereq_ids = list(TECHWEB_NODE_MEDBAY_EQUIP_ADV, TECHWEB_NODE_FUSION)
	design_ids = list(
		"mech_sleeper",
		"splitbeaker",
		// "cryotube",
		// "stasis",
		// "cryo_grenade",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	// discount_experiments = list(/datum/experiment/scanning/reagent/cryostylane = TECHWEB_TIER_4_POINTS)
	announce_channels = list(CHANNEL_MEDICAL)

/datum/techweb_node/medigun
	id = TECHWEB_NODE_MEDIGUN
	display_name = "Cell-Loaded Medigun"
	description = "The ML3M Series Medigun is your one stop solution to all medical problems!"
	prereq_ids = list(TECHWEB_NODE_CRYOSTASIS)
	design_ids = list(
		"rapidsyringe",
		"chemsprayer",
		"cell_medigun",
		"cell_medigun_mag",
		"cell_medigun_mag_advanced",
		"ml3m_cell_brute",
		"ml3m_cell_burn",
		"ml3m_cell_stabilize",
		"ml3m_cell_toxin",
		"ml3m_cell_omni",
		"ml3m_cell_antirad",
		"ml3m_cell_brute2",
		"ml3m_cell_burn2",
		"ml3m_cell_stabilize2",
		"ml3m_cell_omni2",
		"ml3m_cell_toxin2",
		"ml3m_cell_haste",
		"ml3m_cell_resist",
		"ml3m_cell_corpse_mend",
		"ml3m_cell_brute3",
		"ml3m_cell_burn3",
		"ml3m_cell_toxin3",
		"ml3m_cell_omni3",
		"ml3m_cell_shrink",
		"ml3m_cell_grow",
		"ml3m_cell_normalsize",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(CHANNEL_MEDICAL)

/datum/techweb_node/nif
	id = TECHWEB_NODE_NIF
	display_name = "Nanite-Implant Frameworks"
	description = "NIFs are a series of brain implants that are helpful to the user."
	prereq_ids = list(TECHWEB_NODE_CRYOSTASIS)
	design_ids = list(
		"nif",
		"bioadapnif",
		"anrt",
		// "cell_medigun",
		// "cell_medigun_mag",
		// "cell_medigun_mag_advanced",
		// "ml3m_cell_brute",
		// "ml3m_cell_burn",
		// "ml3m_cell_stabilize",
		// "ml3m_cell_toxin",
		// "ml3m_cell_omni",
		// "ml3m_cell_antirad",
		// "ml3m_cell_brute2",
		// "ml3m_cell_burn2",
		// "ml3m_cell_stabilize2",
		// "ml3m_cell_omni2",
		// "ml3m_cell_toxin2",
		// "ml3m_cell_haste",
		// "ml3m_cell_resist",
		// "ml3m_cell_corpse_mend",
		// "ml3m_cell_brute3",
		// "ml3m_cell_burn3",
		// "ml3m_cell_toxin3",
		// "ml3m_cell_omni3",
		// "ml3m_cell_shrink",
		// "ml3m_cell_grow",
		// "ml3m_cell_normalsize",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	announce_channels = list(CHANNEL_MEDICAL)
