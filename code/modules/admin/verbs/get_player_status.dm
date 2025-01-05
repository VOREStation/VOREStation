#define INACTIVITY_CAP 15 MINUTES //Creating a define for this for more straight forward finagling.


//TGUI functionality planned for easier readability, so creating a new file for this
//TGUI functionality will call a datum to handle things separately
/client/proc/getPlayerStatus()
	set name = "Report Player Status"
	set desc = "Get information on all active players in-game."
	set category = "Fun.Event Kit"

	if(!check_rights(R_FUN)) return

	var/player_list_local = player_list //Copying player list so we don't touch a global var all the time
	var/list/area_list = list() //An associative list, where key is area name, value is a list of mob references
	var/inactives = 0
	var/players = 0

	//Initializing our working list
	for(var/player in player_list_local)

		if(!isliving(player)) continue //We only care for living players
		var/mob/living/L = player
		players += 1
		if(L.client.inactivity > INACTIVITY_CAP)
			inactives += 1
			continue //Anyone who hasn't done anything in 15 minutes is likely too busy
		var/area_name = get_area_name(L)
		if(area_name in area_list)
			area_list[area_name] += L // area_name:list(A,B,C); we add L to (A,B,C)
		else
			area_list[area_name] = list(L)

	var/message = "#### The Following Players Are Likely Available #### \n"
	for(var/cur_area in area_list)
		var/area_players = area_list[cur_area]
		message += "**** There are currently [LAZYLEN(area_players)] in [cur_area] **** \n"


		for(var/mob/living/L in area_players)
			message += "[L.name] ([L.key]) at ([L.x];[L.y]) has been inactive for [round(L.client.inactivity / (60 SECONDS))] minutes. \n"


	message += "#### Over all, there are [players] eligible players, of which [inactives] were hidden due to inactivity.  ####"
	to_chat(usr, span_notice(message))

#undef INACTIVITY_CAP
