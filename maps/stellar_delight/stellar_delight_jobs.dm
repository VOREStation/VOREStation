//The pathfinder doesn't have a OM shuttle that they are in charge of, and so, doesn't need pilot access.
//Mostly to prevent explo from just commandeering the Starstuff as the explo shuttle without involving a pilot every round.
/*
/datum/job/pathfinder
	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_gateway, access_pathfinder)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_gateway, access_pathfinder)

//Same as above, to discorage explo from taking off with the small ship without asking, SAR should not need pilot access.
/datum/job/sar
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_medical, access_medical_equip, access_morgue)
*/
/datum/job/hop
	alt_titles = list("Crew Resources Officer" = /datum/alt_title/cro, "Deputy Manager" = /datum/alt_title/deputy_manager, "Staff Manager" = /datum/alt_title/staff_manager,
						"Facility Steward" = /datum/alt_title/facility_steward, "First Mate" = /datum/alt_title/first_mate)

/datum/alt_title/first_mate
	title = "First Mate"

/datum/job/atmos
	alt_titles = list("Atmospheric Engineer" = /datum/alt_title/atmos_engi, "Atmospheric Maintainer" = /datum/alt_title/atmos_maint, "Disposals Technician" = /datum/alt_title/disposals_tech,
						"Fuel Technician" = /datum/alt_title/refuel_tech)

/datum/alt_title/refuel_tech
	title = "Fuel Technician"

/datum/job/warden
	alt_titles = list("Brig Sentry" = /datum/alt_title/brig_sentry, "Armory Superintendent" = /datum/alt_title/armory_superintendent, "Master-at-Arms" = /datum/alt_title/master_at_arms)

/datum/alt_title/master_at_arms
	title = "Master-at-Arms"

/datum/job/pilot/get_request_reasons()
	return list("Moving Stellar Delight")
