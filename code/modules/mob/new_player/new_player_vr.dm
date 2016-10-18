/mob/new_player/proc/spawn_checks_vr()
	var/pass = 1
	if (config.allow_Metadata && client && client.prefs && (isnull(client.prefs.metadata) || length(client.prefs.metadata) < 5))
		src << "<span class='warning'>You must first set your OOC notes before spawning in!</span>"
		pass = 0
	if (!pass)
		alert(src,"There were problems with spawning your character. Check your message log for details.","Error","OK")
	return pass
