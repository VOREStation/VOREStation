//The pathfinder doesn't have a OM shuttle that they are in charge of, and so, doesn't need pilot access.
//Mostly to prevent explo from just commandeering the Starstuff as the explo shuttle without involving a pilot every round.
/datum/job/pathfinder
	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_gateway, access_pathfinder)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_gateway, access_pathfinder)

//Same as above, to discorage explo from taking off with the small ship without asking, SAR should not need pilot access.
/datum/job/sar
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_medical, access_medical_equip, access_morgue)

/datum/job/hop
	alt_titles = list("Crew Resources Officer" = /datum/alt_title/cro, "Deputy Manager" = /datum/alt_title/deputy_manager, "Staff Manager" = /datum/alt_title/staff_manager,
						"Facility Steward" = /datum/alt_title/facility_steward, "First Mate" = /datum/alt_title/first_mate)

/datum/alt_title/first_mate
	title = "First Mate"

/datum/job/atmos
	alt_titles = list("Atmospheric Engineer" = /datum/alt_title/atmos_engi, "Atmospheric Maintainer" = /datum/alt_title/atmos_maint, "Disposals Technician" = /datum/alt_title/disposals_tech,
						"Refueling Technician" = /datum/alt_title/refuel_tech)

/datum/alt_title/refuel_tech
	title = "Refueling Technician"

/datum/job/warden
	alt_titles = list("Brig Sentry" = /datum/alt_title/brig_sentry, "Armory Superintendent" = /datum/alt_title/armory_superintendent, "Gunner" = /datum/alt_title/gunner)

/datum/alt_title/gunner
	title = "Gunner"

/datum/job/officer
	alt_titles = list("Patrol Officer" = /datum/alt_title/patrol_officer, "Security Guard" = /datum/alt_title/security_guard, "Security Deputy" = /datum/alt_title/security_guard,
						"Junior Officer" = /datum/alt_title/junior_officer, "Ship Officer" = /datum/alt_title/ship_officer)

/datum/alt_title/ship_officer
	title = "Ship Officer"