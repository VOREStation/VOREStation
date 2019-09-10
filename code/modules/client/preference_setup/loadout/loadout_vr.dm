/datum/gear
	var/list/ckeywhitelist
	var/list/character_name

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	var/mob/preference_mob = preference_mob()
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]

		if(G.whitelisted && !is_alien_whitelisted(preference_mob, all_species[G.whitelisted]))
			continue
		if(max_cost && G.cost > max_cost)
			continue
		if(G.ckeywhitelist && !(preference_mob.ckey in G.ckeywhitelist)) 
			continue 
/* Commenting out the charactername check, for now. Easier to do it here, instead of doing it in the individual entries.
		if(G.character_name && !(preference_mob.real_name in G.character_name)) 
			continue 
*/
		. += gear_name