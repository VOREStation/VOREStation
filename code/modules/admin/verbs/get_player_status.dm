#define INACTIVITY_CAP 15 MINUTES //Creating a define for this for more straight forward finagling.


//TGUI functionality planned for easier readability, so creating a new file for this
//TGUI functionality will call a datum to handle things separately
ADMIN_VERB(getPlayerStatus, R_FUN, "Report Player Status", "Get information on all active players in-game.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/list/area_list = list() //An associative list, where key is area name, value is a list of mob references
	var/inactives = 0
	var/players = 0

	//Initializing our working list
	for(var/mob/living/player in GLOB.player_list)
		players += 1
		if(player.client.inactivity > INACTIVITY_CAP)
			inactives += 1
			continue //Anyone who hasn't done anything in 15 minutes is likely too busy
		var/area_name = get_area_name(player)
		if(area_name in area_list)
			area_list[area_name] += player // area_name:list(A,B,C); we add player to (A,B,C)
		else
			area_list[area_name] = list(player)

	var/message = "#### The Following Players Are Likely Available #### \n"
	for(var/cur_area in area_list)
		var/area_players = area_list[cur_area]
		message += "**** There are currently [LAZYLEN(area_players)] in [cur_area] **** \n"


		for(var/mob/living/player in area_players)
			message += "[player.name] ([player.key]) at ([player.x];[player.y]) has been inactive for [round(player.client.inactivity / (60 SECONDS))] minutes. \n"


	message += "#### Over all, there are [players] eligible players, of which [inactives] were hidden due to inactivity.  ####"
	to_chat(user, span_notice(message))

#undef INACTIVITY_CAP
