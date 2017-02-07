/mob/living/lobby
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/living/lobby/Login()
	update_details()
	if(join_motd)
		src << "<div class=\"motd\">[join_motd]</div>"

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	my_client = client

	player_list |= src

	client.playtitlemusic()

	src << "<span class='notice'>You are currently inside your residence.  Have a look around, if you want.<br>\
	The <b>wardrobe</b> is used to customize how you look, as well as select the job you plan to go to the Northern Star as (character setup).<br>\
	Your <b>laptop</b> will show you a copy of the Northern Star's manifest.<br>\
	Your <b>HV (Holovision)</b> is also there, assuming you're not busy right now (click it to observe the round as a ghost).<br>\
	When you're ready to leave for the Northern Star (join the round), click the <b>airlock</b>.</span>"