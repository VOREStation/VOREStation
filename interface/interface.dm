//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = "Type what you want to know about.  This will open the wiki on your web browser."
	set category = "OOC.Resources"
	if(CONFIG_GET(string/wikiurl))
		if(query)
			if(CONFIG_GET(string/wikisearchurl))
				var/output = replacetext(CONFIG_GET(string/wikisearchurl), "%s", url_encode(query))
				src << link(output)
			else
				to_chat(src, span_warning(" The wiki search URL is not set in the server configuration."))
		else
			src << link(CONFIG_GET(string/wikiurl))
	else
		to_chat(src, span_warning("The wiki URL is not set in the server configuration."))
		return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if(CONFIG_GET(string/forumurl))
		if(tgui_alert(usr, "This will open the forum in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/forumurl))
	else
		to_chat(src, span_warning("The forum URL is not set in the server configuration."))
		return

/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1

	if(CONFIG_GET(string/rulesurl))
		if(tgui_alert(usr, "This will open the rules in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/rulesurl))
	else
		to_chat(src, span_danger("The rules URL is not set in the server configuration."))
	return

/client/verb/map()
	set name = "Map"
	set desc = "See the map."
	set hidden = 1

	if(CONFIG_GET(string/mapurl))
		if(tgui_alert(usr, "This will open the map in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/mapurl))
	else
		to_chat(src, span_danger("The map URL is not set in the server configuration."))
	return

/client/verb/github()
	set name = "GitHub"
	set desc = "Visit the GitHub"
	set hidden = 1

	if(CONFIG_GET(string/githuburl))
		if(tgui_alert(usr, "This will open the GitHub in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/githuburl))
	else
		to_chat(src, span_danger("The GitHub URL is not set in the server configuration."))
	return

/client/verb/discord()
	set name = "Discord"
	set desc = "Visit the discord"
	set hidden = 1

	if(CONFIG_GET(string/discordurl))
		if(tgui_alert(usr, "This will open the Discord in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/discordurl))
	else
		to_chat(src, span_danger("The Discord URL is not set in the server configuration."))
	return

/client/verb/patreon()
	set name = "Patreon"
	set desc = "Visit the patreon"
	set hidden = 1

	if(CONFIG_GET(string/patreonurl))
		if(tgui_alert(usr, "This will open the Patreon in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
			return
		src << link(CONFIG_GET(string/patreonurl))
	else
		to_chat(src, span_danger("The Patreon URL is not set in the server configuration."))
	return

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC.Resources"

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
\tu = Rest
\tb = Resist
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
\tCtrl+u = Rest
\tCtrl+b = Resist
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
		to_chat(src,robot_hotkey_mode)
		to_chat(src,robot_other)
	else
		to_chat(src,hotkey_mode)
		to_chat(src,other)
	if(holder)
		to_chat(src,admin)

// Set the DreamSeeker input macro to the type appropriate for its mob
/client/proc/set_hotkeys_macro(macro_name = "macro", hotkey_macro_name = "hotkeymode", hotkeys_enabled = null)
	// If hotkeys mode was not specified, fall back to choice of default in client preferences.
	if(isnull(hotkeys_enabled))
		hotkeys_enabled = prefs?.read_preference(/datum/preference/toggle/hotkeys_default)

	if(hotkeys_enabled)
		winset(src, null, "mainwindow.macro=[hotkey_macro_name] hotkey_toggle.is-checked=true mapwindow.map.focus=true")
	else
		winset(src, null, "mainwindow.macro=[macro_name] hotkey_toggle.is-checked=false input.focus=true")
