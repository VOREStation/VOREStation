//Hijacking this file for BS12 playernotes functions. I like this ^ one systemm alright, but converting sounds too bothersome~ Chinsky.
/proc/notes_add(var/key, var/note, var/mob/user)
	if (!key || !note)
		return

	//Loading list of notes for this key
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos) infos = list()

	//Overly complex timestamp creation
	var/modifyer = "th"
	switch(time2text(world.timeofday, "DD"))
		if("01","21","31")
			modifyer = "st"
		if("02","22",)
			modifyer = "nd"
		if("03","23")
			modifyer = "rd"
	var/day_string = "[time2text(world.timeofday, "DD")][modifyer]"
	if(copytext(day_string,1,2) == "0")
		day_string = copytext(day_string,2)
	var/full_date = time2text(world.timeofday, "DDD, Month DD of YYYY")
	var/day_loc = findtext(full_date, time2text(world.timeofday, "DD"))

	var/datum/player_info/P = new
	if (user)
		P.author = user.key
		P.rank = user.client.holder.rank_names()
	else
		P.author = "Adminbot"
		P.rank = "Friendly Robot"
	P.content = note
	P.timestamp = "[copytext(full_date,1,day_loc)][day_string][copytext(full_date,day_loc+2)]"

	infos += P
	info << infos

	message_admins(span_blue("[key_name_admin(user)] has edited [key]'s notes."))
	log_admin("[key_name(user)] has edited [key]'s notes.")
	admin_action_message(P.author, key, "added note on", note, 0) //VOREStation Add
	del(info) // savefile, so NOT qdel

	//Updating list of keys with notes on them
	var/savefile/note_list = new("data/player_notes.sav")
	var/list/note_keys
	note_list >> note_keys
	if(!note_keys) note_keys = list()
	if(!note_keys.Find(key)) note_keys += key
	note_list << note_keys
	del(note_list) // savefile, so NOT qdel


/proc/notes_del(var/key, var/index)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos || infos.len < index) return

	var/datum/player_info/item = infos[index]
	infos.Remove(item)
	info << infos

	message_admins(span_blue("[key_name_admin(usr)] deleted one of [key]'s notes."))
	log_admin("[key_name(usr)] deleted one of [key]'s notes.")
	admin_action_message(usr.key, key, "deleted note on", "\[Note gone\]", 0) //VOREStation Add
	qdel(info)

/proc/show_player_info_irc(var/key as text)
	var/dat = "          Info on [key]\n"
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		dat = "No information found on the given key."
	else
		for(var/datum/player_info/I in infos)
			dat += "[I.content]\nby [I.author] ([I.rank]) on [I.timestamp]\n\n"

	return list2params(list(dat))
