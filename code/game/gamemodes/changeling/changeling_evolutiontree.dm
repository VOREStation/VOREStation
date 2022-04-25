var/global/list/powers = typesof(/datum/power/changeling) - /datum/power/changeling	//needed for the badmin verb for now
var/global/list/datum/power/changeling/powerinstances = list()

/datum/power			//Could be used by other antags too
	var/name = "Power"
	var/desc = "Placeholder"
	var/helptext = ""
	var/enhancedtext = ""
	var/isVerb = 1 	// Is it an active power, or passive?
	var/verbpath // Path to a verb that contains the effects.
	var/make_hud_button = 1 // Is this ability significant enough to dedicate screen space for a HUD button?
	var/ability_icon_state = null // icon_state for icons for the ability HUD.  Must be in screen_spells.dmi.

/datum/power/changeling
	var/allowduringlesserform = 0
	var/genomecost = 500000 // Cost for the changling to evolve this power.
	var/power_category = null // _defines/gamemode.dm

/datum/changeling/proc/EvolutionTree() /// Data is in changelingevolution.dm under managed_browsers
	set name = "-Evolution Tree-"
	set category = "Changeling"
	set desc = "Adapt yourself carefully."

	if(!usr || !usr.mind || !usr.mind.changeling)	return

	if(usr.client.changelingevolution)
		usr.client.changelingevolution.textbody = null
		usr.client.changelingevolution.display()
	else
		usr.client.changelingevolution = new(usr.client)

/// Handles adding ability function. Adding to purchased abilities list & genome cost
/// must be done BEFORE this call.
/datum/changeling/proc/purchasePower(var/datum/mind/M, var/datum/power/changeling/Pname, var/remake_verbs = 1)

	if(!M || !M.changeling)
		return

	if(Pname.genomecost > 0)
		purchased_powers_history.Add("[Pname.name] ([Pname.genomecost] points)")

	if(Pname.make_hud_button && Pname.isVerb)
		if(!M.current.ability_master)
			M.current.ability_master = new /obj/screen/movable/ability_master(null, M.current)
		M.current.ability_master.add_ling_ability(
			object_given = M.current,
			verb_given = Pname.verbpath,
			name_given = Pname.name,
			ability_icon_given = Pname.ability_icon_state,
			arguments = list()
			)

	if(!Pname.isVerb && Pname.verbpath)
		call(M.current, Pname.verbpath)()
	else if(remake_verbs)
		M.current.make_changeling()
