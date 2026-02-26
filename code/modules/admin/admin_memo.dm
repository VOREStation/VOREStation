#define MEMOFILE "data/memo.sav"	//where the memos are saved
#define ENABLE_MEMOS // this is so stupid

//switch verb so we don't spam up the verb lists with like, 3 verbs for this feature.
ADMIN_VERB(admin_memo, R_ADMIN|R_MOD|R_EVENT, "Memo", "Manage admin memos.", ADMIN_CATEGORY_SERVER_ADMIN)
	#ifndef ENABLE_MEMOS
	return
	#endif

	var/task = tgui_input_list(user, "Select Action", "Select the Memo Action.", list("write","show","delete"))
	if(!task)
		return

	switch(task)
		if("write")
			user.admin_memo_write()
		if("show")
			user.admin_memo_show()
		if("delete")
			user.admin_memo_delete()

//write a message
/client/proc/admin_memo_write()
	var/savefile/F = new(MEMOFILE)
	if(F)
		var/memo = tgui_input_text(src,"Type your memo\n(Leaving it blank will delete your current memo):","Write Memo",null, multiline = TRUE, prevent_enter = TRUE)
		switch(memo)
			if(null)
				return
			if("")
				F.dir.Remove(ckey)
				to_chat(src, span_filter_adminlog(span_bold("Memo removed")))
				return
		if( findtext(memo,"<script",1,0) )
			return
		to_chat(F[ckey], span_filter_adminlog("[key] on [time2text(world.realtime,"(DDD) DD MMM hh:mm")]<br>[memo]"))
		message_admins("[key] set an admin memo:<br>[memo]")

//show all memos
/client/proc/admin_memo_show()
	#ifndef ENABLE_MEMOS
	return
	#endif
	var/savefile/F = new(MEMOFILE)
	if(F)
		for(var/ckey in F.dir)
			to_chat(src, span_filter_adminlog("<center><span class='motd'><b>Admin Memo</b><i> by [F[ckey]]</i></span></center>"))

//delete your own or somebody else's memo
/client/proc/admin_memo_delete()
	var/savefile/F = new(MEMOFILE)
	if(F)
		var/ckey
		if(check_rights(R_SERVER,0))	//high ranking admins can delete other admin's memos
			ckey = tgui_input_list(src,"Whose memo shall we remove?","Remove Memo", F.dir)
		else
			ckey = src.ckey
		if(ckey)
			F.dir.Remove(ckey)
			to_chat(src, span_filter_adminlog(span_bold("Removed Memo created by [ckey].")))

#undef MEMOFILE
#undef ENABLE_MEMOS
