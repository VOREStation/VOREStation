ADMIN_VERB(spawn_panel, R_SPAWN, "Spawn Panel", "Spawn Panel (TGUI).", ADMIN_CATEGORY_GAME)
	var/datum/spawnpanel/panel = user.holder.spawn_panel
	if(!panel)
		panel = new()
		user.holder.spawn_panel = panel
	panel.tgui_interact(user.mob)
	feedback_add_details("admin_verb","SP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
