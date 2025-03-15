/datum/config_entry/number/health_threshold_softcrit
	default = 0

/datum/config_entry/number/health_threshold_crit
	default = 0

/datum/config_entry/number/health_threshold_dead
	default = -100

/datum/config_entry/flag/bones_can_break

/datum/config_entry/flag/limbs_can_break

/datum/config_entry/number/organ_health_multiplier
	integer = FALSE
	default = 1.0

/datum/config_entry/number/organ_regeneration_multiplier
	integer = FALSE
	default = 1.0

// FIXME: Unused
///datum/config_entry/flag/revival_pod_plants
//	default = TRUE

/datum/config_entry/flag/revival_cloning
	default = TRUE

/datum/config_entry/number/revival_brain_life
	default = -1

/// Used for modifying movement speed for mobs.
/// Universal modifiers
/datum/config_entry/number/run_speed
	default = 0

/datum/config_entry/number/walk_speed
	default = 0

///Mob specific modifiers. NOTE: These will affect different mob types in different ways
/datum/config_entry/number/human_delay
	default = 0

/datum/config_entry/number/robot_delay
	default = 0

// FIXME: Unused
///datum/config_entry/number/monkey_delay
//	default = 0

// FIXME: Unused
///datum/config_entry/number/alien_delay
//	default = 0

// FIXME: Unused
//datum/config_entry/number/slime_delay
//	default = 0

/datum/config_entry/number/animal_delay
	default = 0

/datum/config_entry/number/footstep_volume
	default = 0

/// In future see about making a function to adjust volume serverside in config.txt, easy to do with reenable values. - Jack
/datum/config_entry/number/vorefootstep_volume
	default = 75

/datum/config_entry/flag/use_loyalty_implants

/datum/config_entry/flag/show_human_death_message
	default = TRUE

/datum/config_entry/string/alert_desc_green
	default = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."

/datum/config_entry/string/alert_desc_yellow_upto
	default = "A minor security emergency has developed. Security personnel are to report to their supervisor for orders and may have weapons visible on their person. Privacy laws are still enforced."

/datum/config_entry/string/alert_desc_yellow_downto
	default = "Code yellow procedures are now in effect. Security personnel are to report to their supervisor for orders and may have weapons visible on their person. Privacy laws are still enforced."

/datum/config_entry/string/alert_desc_violet_upto
	default = "A major medical emergency has developed. Medical personnel are required to report to their supervisor for orders, and non-medical personnel are required to obey all relevant instructions from medical staff."

/datum/config_entry/string/alert_desc_violet_downto
	default = "Code violet procedures are now in effect; Medical personnel are required to report to their supervisor for orders, and non-medical personnel are required to obey relevant instructions from medical staff."

/datum/config_entry/string/alert_desc_orange_upto
	default = "A major engineering emergency has developed. Engineering personnel are required to report to their supervisor for orders, and non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."

/datum/config_entry/string/alert_desc_orange_downto
	default = "Code orange procedures are now in effect; Engineering personnel are required to report to their supervisor for orders, and non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."

/datum/config_entry/string/alert_desc_blue_upto
	default = "A major security emergency has developed. Security personnel are to report to their supervisor for orders, are permitted to search staff and facilities, and may have weapons visible on their person."

/datum/config_entry/string/alert_desc_blue_downto
	default = "Code blue procedures are now in effect. Security personnel are to report to their supervisor for orders, are permitted to search staff and facilities, and may have weapons visible on their person."

/datum/config_entry/string/alert_desc_red_upto
	default = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."

/datum/config_entry/string/alert_desc_red_downto
	default = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."

/datum/config_entry/string/alert_desc_delta
	default = "The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."
