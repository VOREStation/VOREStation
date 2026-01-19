/proc/send2tgs_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts(requiredflags)
	var/list/activemins = adm["present"]
	. = activemins.len
	if(. <= 0)
		var/final = ""
		var/list/afkmins = adm["afk"]
		var/list/stealthmins = adm["stealth"]
		var/list/powerlessmins = adm["noflags"]
		var/list/allmins = adm["total"]
		if(!afkmins.len && !stealthmins.len && !powerlessmins.len)
			final = "[msg] - No admins online"
		else
			final = "[msg] - All admins stealthed\[[english_list(stealthmins)]\], AFK\[[english_list(afkmins)]\], or lacks +BAN\[[english_list(powerlessmins)]\]! Total: [allmins.len] "
		send2adminchat(source,final)
