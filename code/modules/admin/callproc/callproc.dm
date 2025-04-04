/client/proc/callproc()
	set category = "Debug.Events"
	set name = "Advanced ProcCall"
	set waitfor = 0

	if(!check_rights(R_DEBUG))
		return

	var/datum/target = null
	var/targetselected = 0
	var/returnval = null

	switch(tgui_alert(usr, "Proc owned by something?","Call Proc",list("Yes","No")))
		if(null)
			return
		if("Yes")
			targetselected = 1
			var/list/value = vv_get_value(default_class = VV_ATOM_REFERENCE, classes = list(VV_ATOM_REFERENCE, VV_DATUM_REFERENCE, VV_MOB_REFERENCE, VV_CLIENT))
			if (!value["class"] || !value["value"])
				return
			target = value["value"]
		if("No")
			target = null
			targetselected = 0

	var/procname = tgui_input_text(usr, "Proc path, eg: /proc/fake_blood","Path:", null)
	if(!procname)
		return

	//hascall() doesn't support proc paths (eg: /proc/gib(), it only supports "gib")
	var/testname = procname
	if(targetselected)
		//Find one of the 3 possible ways they could have written /proc/PROCNAME
		if(findtext(procname, "/proc/"))
			testname = replacetext(procname, "/proc/", "")
		else if(findtext(procname, "/proc"))
			testname = replacetext(procname, "/proc", "")
		else if(findtext(procname, "proc/"))
			testname = replacetext(procname, "proc/", "")
		//Clear out any parenthesis if they're a dummy
		testname = replacetext(testname, "()", "")

	if(targetselected && !hascall(target,testname))
		to_chat(usr, span_filter_adminlog(span_red("Error: callproc(): type [target.type] has no proc named [procname].")))
		return
	else
		var/procpath = text2path(procname)
		if (!procpath)
			to_chat(usr, span_filter_adminlog(span_red("Error: callproc(): proc [procname] does not exist. (Did you forget the /proc/ part?)")))
			return
	var/list/lst = get_callproc_args()
	if(!lst)
		return

	if(targetselected)
		if(!target)
			to_chat(usr, span_filter_adminlog(span_red("Error: callproc(): owner of proc no longer exists.")))
			return
		var/msg = "[key_name(src)] called [target]'s [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"]."
		log_admin(msg)
		//message_admins(msg)				//Proccall announce removed.
		admin_ticket_log(target, msg)
		returnval = WrapAdminProcCall(target, procname, lst) // Pass the lst as an argument list to the proc
	else
		//this currently has no hascall protection. wasn't able to get it working.
		log_admin("[key_name(src)] called [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"].")
		//message_admins("[key_name(src)] called [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"].")			//Proccall announce removed.
		returnval = WrapAdminProcCall(GLOBAL_PROC, procname, lst) // Pass the lst as an argument list to the proc
	. = get_callproc_returnval(returnval, procname)
	if(.)
		to_chat(usr, .)
	feedback_add_details("admin_verb","APC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

GLOBAL_VAR(AdminProcCaller)
GLOBAL_PROTECT(AdminProcCaller)
GLOBAL_VAR_INIT(AdminProcCallCount, 0)
GLOBAL_PROTECT(AdminProcCallCount)
GLOBAL_VAR(LastAdminCalledTargetRef)
GLOBAL_PROTECT(LastAdminCalledTargetRef)
GLOBAL_VAR(LastAdminCalledTarget)
GLOBAL_PROTECT(LastAdminCalledTarget)
GLOBAL_VAR(LastAdminCalledProc)
GLOBAL_PROTECT(LastAdminCalledProc)
GLOBAL_LIST_EMPTY(AdminProcCallSpamPrevention)
GLOBAL_PROTECT(AdminProcCallSpamPrevention)

/proc/WrapAdminProcCall(datum/target, procname, list/arguments)
	if(target && procname == "Del")
		to_chat(usr, span_filter_adminlog("Calling Del() is not allowed"))
		return

	if(target != GLOBAL_PROC && !target.CanProcCall(procname))
		to_chat(usr, span_filter_adminlog("Proccall on [target.type]/proc/[procname] is disallowed!"))
		return
	var/current_caller = GLOB.AdminProcCaller
	var/ckey = usr ? usr.client.ckey : GLOB.AdminProcCaller
	if(!ckey)
		CRASH("WrapAdminProcCall with no ckey: [target] [procname] [english_list(arguments)]")
	if(current_caller && current_caller != ckey)
		if(!GLOB.AdminProcCallSpamPrevention[ckey])
			to_chat(usr, span_adminnotice("Another set of admin called procs are still running, your proc will be run after theirs finish."))
			GLOB.AdminProcCallSpamPrevention[ckey] = TRUE
			UNTIL(!GLOB.AdminProcCaller)
			to_chat(usr, span_adminnotice("Running your proc"))
			GLOB.AdminProcCallSpamPrevention -= ckey
		else
			UNTIL(!GLOB.AdminProcCaller)
	GLOB.LastAdminCalledProc = procname
	if(target != GLOBAL_PROC)
		GLOB.LastAdminCalledTargetRef = "\ref[target]"
	GLOB.AdminProcCaller = ckey	//if this runtimes, too bad for you
	++GLOB.AdminProcCallCount
	. = world.WrapAdminProcCall(target, procname, arguments)
	if(--GLOB.AdminProcCallCount == 0)
		GLOB.AdminProcCaller = null

//adv proc call this, ya nerds
/world/proc/WrapAdminProcCall(datum/target, procname, list/arguments)
	if(target == GLOBAL_PROC)
		return call(procname)(arglist(arguments))
	else if(target != world)
		return call(target, procname)(arglist(arguments))
	else
		log_admin("[key_name(usr)] attempted to call world/proc/[procname] with arguments: [english_list(arguments)]")

/proc/IsAdminAdvancedProcCall()
#ifdef TESTING
	return FALSE
#else
	return usr && usr.client && GLOB.AdminProcCaller == usr.client.ckey
#endif

/client/proc/callproc_datum(datum/A as null|area|mob|obj|turf)
	set category = "Debug.Events"
	set name = "Atom ProcCall"
	set waitfor = 0

	if(!check_rights(R_DEBUG))
		return

	var/procname = tgui_input_text(usr, "Proc name, eg: fake_blood","Proc:")
	if(!procname)
		return
	if(!hascall(A,procname))
		to_chat(usr, span_filter_adminlog(span_red("Error: callproc_datum(): type [A.type] has no proc named [procname].")))
		return
	var/list/lst = get_callproc_args()
	if(!lst)
		return

	if(!A || !IsValidSrc(A))
		to_chat(usr, span_warning("Error: callproc_datum(): owner of proc no longer exists."))
		return
	var/msg = "[key_name(src)] called [A]'s [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"]."
	log_admin(msg)
	//message_admins(msg)
	admin_ticket_log(A, msg)
	feedback_add_details("admin_verb","TPC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	var/returnval = WrapAdminProcCall(A, procname, lst) // Pass the lst as an argument list to the proc
	. = get_callproc_returnval(returnval,procname)
	if(.)
		to_chat(usr, .)

/client/proc/get_callproc_args()
	var/argnum = tgui_input_number(usr, "Number of arguments","Number:",0)
	if(isnull(argnum))
		return null					//Cancel

	. = list()
	//var/list/named_args = list()			//Named arguments are removed, due to them making proccalling take too long.
	while(argnum--)
		/*						//Named arguments are removed, due to them making proccalling take too long.
		var/named_arg = tgui_input_text(usr,"Leave blank for positional argument. Positional arguments will be considered as if they were added first.", "Named argument")
		if(isnull(named_arg))
			return null				//Cancel
		*/
		var/value = vv_get_value(restricted_classes = list(VV_RESTORE_DEFAULT))
		if (!value["class"])
			return null				//Cancel
		/*						//Named arguments are removed, due to them making proccalling take too long.
		if(named_arg)
			named_args[named_arg] = value["value"]
		else
			. += value["value"]
	if(LAZYLEN(named_args))
		. += named_args
		*/
		. += value["value"]

/client/proc/get_callproc_returnval(returnval,procname)
	. = ""
	if(islist(returnval))
		var/list/returnedlist = returnval
		if(returnedlist.len)
			var/assoc_check = returnedlist[1]
			if(istext(assoc_check) && (returnedlist[assoc_check] != null))
				. += "[procname] returned an associative list:"
				for(var/key in returnedlist)
					. += "\n[key] = [returnedlist[key]]"

			else
				. += "[procname] returned a list:"
				for(var/elem in returnedlist)
					. += "\n[elem]"
		else
			. = "[procname] returned an empty list"
		. = span_blue(.)

	else
		. = span_blue("[procname] returned: [!isnull(returnval) ? returnval : "null"]")
