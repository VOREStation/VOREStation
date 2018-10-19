//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = "Type what you want to know about.  This will open the wiki on your web browser."
	set category = "OOC"
	if(config.wikiurl)
		if(query)
			if(config.wikisearchurl)
				var/output = replacetext(config.wikisearchurl, "%s", url_encode(query))
				src << link(output)
			else
				src << "<span class='warning'> The wiki search URL is not set in the server configuration.</span>"
		else
			src << link(config.wikiurl)
	else
		src << "<span class='warning'>The wiki URL is not set in the server configuration.</span>"
		return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		src << "<span class='warning'>The forum URL is not set in the server configuration.</span>"
		return

/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1

	if(config.rulesurl)
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.rulesurl)
	else
		src << "<span class='danger'>The rules URL is not set in the server configuration.</span>"
	return

/client/verb/map()
	set name = "Map"
	set desc = "See the map."
	set hidden = 1

	if(config.mapurl)
		if(alert("This will open the map in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.mapurl)
	else
		src << "<span class='danger'>The map URL is not set in the server configuration.</span>"
	return

/client/verb/github()
	set name = "GitHub"
	set desc = "Visit the GitHub"
	set hidden = 1

	if(config.githuburl)
		if(alert("This will open the GitHub in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.githuburl)
	else
		src << "<span class='danger'>The GitHub URL is not set in the server configuration.</span>"
	return

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\t5 = emote
\tx = swap-hand
\tz = activate held object (or y)
\tj = toggle-aiming-mode
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
\tCtrl+Click = pull
\tShift+Click = examine
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = stop pulling
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	var/robot_hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = unequip active module
\tt = say
\tx = cycle active modules
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = activate module 1
\t2 = activate module 2
\t3 = activate module 3
\t4 = toggle intents
\t5 = emote
\tCtrl+Click = pull
\tShift+Click = examine
</font>"}

	var/robot_other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = unequip active module
\tCtrl+x = cycle active modules
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = activate module 1
\tCtrl+2 = activate module 2
\tCtrl+3 = activate module 3
\tCtrl+4 = toggle intents
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = stop pulling
\tINS = toggle intents
\tPGUP = cycle active modules
\tPGDN = activate held object
</font>"}

	if(isrobot(src.mob))
		src << robot_hotkey_mode
		src << robot_other
	else
		src << hotkey_mode
		src << other
	if(holder)
		src << admin

// Set the DreamSeeker input macro to the type appropriate for its mob
/client/proc/set_hotkeys_macro(macro_name = "macro", hotkey_macro_name = "hotkeymode", hotkeys_enabled = null)
	// If hotkeys mode was not specified, fall back to choice of default in client preferences.
	if(isnull(hotkeys_enabled))
		hotkeys_enabled = is_preference_enabled(/datum/client_preference/hotkeys_default)

	if(hotkeys_enabled)
		winset(src, null, "mainwindow.macro=[hotkey_macro_name] hotkey_toggle.is-checked=true mapwindow.map.focus=true")
	else
		winset(src, null, "mainwindow.macro=[macro_name] hotkey_toggle.is-checked=false input.focus=true")
