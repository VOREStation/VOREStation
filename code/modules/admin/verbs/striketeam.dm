//STRIKE TEAMS
var/const/commandos_possible = 6 //if more Commandos are needed in the future

/client/proc/strike_team()
	set category = "Fun"
	set name = "Spawn Strike Team"
	set desc = "Spawns a strike team if you want to run an admin event."

	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(!ticker)
		to_chat(usr, span_red("The game hasn't started yet!"))
		return

	if(world.time < 6000)
		to_chat(usr, span_red("There are [(6000-world.time)/10] seconds remaining before it may be called."))
		return

	var/datum/antagonist/deathsquad/team

	var/choice = tgui_input_list(usr, "Select type of strike team:", "Strike Team", list("Heavy Asset Protection", "Mercenaries"))
	if(!choice)
		return

	switch(choice)
		if("Heavy Asset Protection")
			team = deathsquad
		if("Mercenaries")
			team = commandos
		else
			return

	if(team.deployed)
		to_chat(usr, span_red("Someone is already sending a team."))
		return

	if(tgui_alert(usr, "Do you want to send in a strike team? Once enabled, this is irreversible.","Strike Team",list("Yes","No"))!="Yes")
		return

	tgui_alert(usr, "This 'mode' will go on until everyone is dead or the station is destroyed. You may also admin-call the evac shuttle when appropriate. Spawned commandos have internals cameras which are viewable through a monitor inside the Spec. Ops. Office. Assigning the team's detailed task is recommended from there. While you will be able to manually pick the candidates from active ghosts, their assignment in the squad will be random.") // Should remain tgui_alert() (blocking)

	choice = null
	while(!choice)
		choice = sanitize(tgui_input_text(src, "Please specify which mission the strike team shall undertake.", "Specify Mission", ""))
		if(!choice)
			if(tgui_alert(usr, "Error, no mission set. Do you want to exit the setup process?","Strike Team",list("Yes","No"))=="Yes")
				return
	consider_ert_load() //VOREStation Add

	if(team.deployed)
		to_chat(usr, "Looks like someone beat you to it.")
		return

	team.attempt_random_spawn()
