var/global/list/prevent_respawns = list()

/hook/death/proc/quit_notify(mob/dead)
	if(ishuman(dead))
		to_chat(dead,span_notice("You're dead! If you don't intend to continue playing this round as this character, please use the <b>Quit This Round</b> verb in the OOC tab to free your job slot. Otherwise, you can use the <b>Notify Transcore</b> verb to let medical know you need resleeving, or <b>Find Auto Resleever</b> verb to be taken to an auto resleever, which you can click on to be resleeved automatically after a time."))

	return TRUE

/mob/observer/dead/verb/cleanup()
	set name = "Quit This Round"
	set category = "OOC"
	set desc = "Free your job slot, remove yourself from the manifest, and prevent respawning as this character for this round."

	var/confirm = tgui_alert(usr, "This will free up your job slot, remove you from the manifest, and allow you to respawn as this character. You can rejoin as another \
	character if you like. Do this now?","Quit This Round",list("Quit Round","Cancel"))
	if(confirm != "Quit Round")
		return

	//Why are you clicking this button?
	if(!mind || !mind.assigned_role)
		to_chat(src,span_warning("Either you haven't played this round, you already used this verb or you left round properly already."))
		return

	//Add them to the nope list
	//prevent_respawns += mind.name //Replaced by PR 4785

	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in all_objectives)
		if(O.target == src.mind)
			if(O.owner && O.owner.current)
				to_chat(O.owner.current,span_warning("You get the feeling your target is no longer within your reach..."))
			qdel(O)

	//Resleeving cleanup
	if(mind)
		SStranscore.leave_round(src)

	//Job slot cleanup
	var/job = src.mind.assigned_role
	job_master.FreeRole(job)

	//Their objectives cleanup
	if(src.mind.objectives.len)
		qdel(src.mind.objectives)
		src.mind.special_role = null

	//Cut the PDA manifest (ugh)
	if(PDA_Manifest.len)
		PDA_Manifest.Cut()
	for(var/datum/data/record/R in data_core.medical)
		if((R.fields["name"] == src.real_name))
			qdel(R)
	for(var/datum/data/record/T in data_core.security)
		if((T.fields["name"] == src.real_name))
			qdel(T)
	for(var/datum/data/record/G in data_core.general)
		if((G.fields["name"] == src.real_name))
			qdel(G)

	//This removes them from being 'active' list on join screen
	src.mind.assigned_role = null

	//Feedback
	to_chat(src,span_notice("Your job has been free'd up, and you can rejoin as another character or quit. Thanks for using this verb, it helps the server!"))
