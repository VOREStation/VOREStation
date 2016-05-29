/*
Slime cube lives here.
*/
/obj/item/slime_cube
	name = "slimy monkey cube"
	desc = "Wonder what might come out of this."
	icon = 'icons/mob/slime2.dmi'
	icon_state = "slime cube"
	var/searching = 0

/obj/item/slime_cube/attack_self(mob/user as mob)
	if(!searching)
		user << "<span class='warning'>You stare at the slimy cube, watching as some activity occurs.</span>"
		icon_state = "slime cube active"
		searching = 1
		request_player()
		spawn(600) reset_search()

/obj/item/slime_cube/proc/request_player()
	for(var/mob/observer/dead/O in player_list)
		if(!O.MayRespawn())
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_ALIEN)
				question(O.client)

/obj/item/slime_cube/proc/question(var/client/C)
	spawn(0)
		if(!C)	return
		var/response = alert(C, "Someone is requesting a soul for a promethean. Would you like to play as one?", "Promethean request", "Yes", "No", "Never for this round")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as a promethean?", "Promethean request", "Yes", "No")
		if(!C ||  2 == searching)	return		//handle logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
		if(response == "Yes")
			transfer_personality(C.mob)
		else if (response == "Never for this round")
			C.prefs.be_special ^= BE_ALIEN
			
/obj/item/slime_cube/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	icon_state = "slime cube"
	if(searching == 1)
		searching = 0
		var/turf/T = get_turf_or_move(src.loc)
		for (var/mob/M in viewers(T))
			M.show_message("<span class='warning'>The activity in the cube dies down. Maybe it will spark another time.</span>")
			
/obj/item/slime_cube/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are a promethean now.")
	src.searching = 2
	var/mob/living/carbon/human/S = new(get_turf(src))
	S.client = candidate.client
	S. << "<b>You are a promethean, brought into existence on [station_name()].</b>"
	S.mind.assigned_role = "Promethean"
	S.set_species("Promethean")
	S.shapeshifter_set_colour("#05FF9B")
	for(var/mob/M in  viewers(get_turf_or_move(loc)))
		M.show_message("<span class='warning'>The monkey cube suddenly takes the shape of a humanoid!</span>")
	var/newname = sanitize(input(S, "You are a Promethean. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
	if (newname)
		S.real_name = newname
		S.name = S.real_name
		S.dna.real_name = newname
	if(S.mind) S.mind.name = S.name
	qdel(src)
	