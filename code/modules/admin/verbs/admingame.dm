ADMIN_VERB(lag_switch_panel, R_ADMIN, "Show Lag Switches", "Display the controls for drastic lag mitigation.", ADMIN_CATEGORY_GAME)
	if(!SSlag_switch.initialized)
		to_chat(user, span_notice("The Lag Switch subsystem has not yet been initialized."))
		return
	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Lag Switches</title></head><body><h2><B>Lag (Reduction) Switches</B></h2>")
	//dat += "Automatic Trigger: <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch_option=TOGGLE_AUTO'><b>[SSlag_switch.auto_switch ? "On" : "Off"]</b></a><br/>"
	//dat += "Population Threshold: <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch_option=NUM'><b>[SSlag_switch.trigger_pop]</b></a><br/>"
	//dat += "Slowmode Cooldown (toggle On/Off below): <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch_option=SLOWCOOL'><b>[SSlag_switch.slowmode_cooldown/10] seconds</b></a><br/>"
	dat += "<br/><b>SET ALL MEASURES: <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=ALL_ON'>ON</a> | <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=ALL_OFF'>OFF</a></b><br/>"
	//dat += "<br/>Disable ghosts zoom and t-ray verbs (except staff): <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_GHOST_ZOOM_TRAY]'><b>[SSlag_switch.measures[DISABLE_GHOST_ZOOM_TRAY] ? "On" : "Off"]</b></a><br/>"
	//dat += "Disable late joining: <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_NON_OBSJOBS]'><b>[SSlag_switch.measures[DISABLE_NON_OBSJOBS] ? "On" : "Off"]</b></a><br/>"
	dat += "<br/>============! MAD GHOSTS ZONE !============<br/>"
	dat += "Disable deadmob keyLoop (except staff, informs dchat): <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_DEAD_KEYLOOP]'><b>[SSlag_switch.measures[DISABLE_DEAD_KEYLOOP] ? "On" : "Off"]</b></a><br/>"
	dat += "==========================================<br/>"
	dat += "<br/><b>Measures below can be bypassed with a <abbr title='TRAIT_BYPASS_MEASURES'><u>special trait</u></abbr></b><br/>"
	//dat += "Slowmode say verb (informs world): <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=[SLOWMODE_SAY]'><b>[SSlag_switch.measures[SLOWMODE_SAY] ? "On" : "Off"]</b></a><br/>"
	dat += "Disable runechat: <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_RUNECHAT]'><b>[SSlag_switch.measures[DISABLE_RUNECHAT] ? "On" : "Off"]</b></a> - <span style='font-size:80%'>trait applies to speaker</span><br/>"
	dat += "Disable examine icons: <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_USR_ICON2HTML]'><b>[SSlag_switch.measures[DISABLE_USR_ICON2HTML] ? "On" : "Off"]</b></a> - <span style='font-size:80%'>trait applies to examiner</span><br/>"
	//dat += "Disable parallax: <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_PARALLAX]'><b>[SSlag_switch.measures[DISABLE_PARALLAX] ? "On" : "Off"]</b></a> - <span style='font-size:80%'>trait applies to character</span><br />"
	dat += "Disable footsteps: <a href='byond://?_src_=holder;[HrefToken()];change_lag_switch=[DISABLE_FOOTSTEPS]'><b>[SSlag_switch.measures[DISABLE_FOOTSTEPS] ? "On" : "Off"]</b></a> - <span style='font-size:80%'>trait applies to character</span><br />"
	dat += "</body></html>"
	user << browse(dat.Join(), "window=lag_switch_panel;size=420x480")
