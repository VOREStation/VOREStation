//The pathfinder doesn't have a OM shuttle that they are in charge of, and so, doesn't need pilot access.
//Mostly to prevent explo from just commandeering the Starstuff as the explo shuttle without involving a pilot every round.
/datum/job/pathfinder
	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_gateway, access_pathfinder)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_gateway, access_pathfinder)

//Same as above, to discorage explo from taking off with the small ship without asking, SAR should not need pilot access.
/datum/job/sar
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_medical, access_medical_equip, access_morgue)