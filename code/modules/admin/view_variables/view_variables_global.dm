/proc/readglobal(which)
	. = global.vars[which]
		
/proc/writeglobal(which, newval)
	global.vars[which] = newval

/proc/getallglobals()
	. = list()
	for(var/some_global in global.vars)
		. += some_global

/var/decl/global_vars/global_vars_

/decl/global_vars
	var/name = "<b>Global Variables</b>"

/decl/global_vars/get_view_variables_options()
	return "" // Ensuring changes to the base proc never affect us

/decl/global_vars/get_variables()
	. = getallglobals() - VV_hidden()
	if(!usr || !check_rights(R_ADMIN|R_DEBUG, FALSE))
		. -= VV_secluded()

/decl/global_vars/get_variable_value(varname)
	return readglobal(varname)

/decl/global_vars/set_variable_value(varname, value)
	writeglobal(varname, value)

/decl/global_vars/make_view_variables_variable_entry(varname, value)
	return "(<a href='?_src_=vars;datumedit=\ref[src];varnameedit=[varname]'>E</a>) "

/decl/global_vars/VV_locked()
	return vars

/decl/global_vars/VV_hidden()
	return list(
		"forumsqladdress",
		"forumsqldb",
		"forumsqllogin",
		"forumsqlpass",
		"forumsqlport",
		"sqladdress",
		"sqldb",
		"sqllogin",
		"sqlpass",
		"sqlport",
		"comms_password",
		"ban_comms_password",
		"login_export_addr",
		"admin_verbs_default",
		"admin_verbs_admin",
		"admin_verbs_ban",
		"admin_verbs_sounds",
		"admin_verbs_fun",
		"admin_verbs_spawn",
		"admin_verbs_server",
		"admin_verbs_debug",
		"admin_verbs_paranoid_debug",
		"admin_verbs_possess",
		"admin_verbs_permissions",
		"admin_verbs_rejuv",
		"admin_verbs_hideable",
		"admin_verbs_mod",
		"admin_verbs_event_manager",
		"adminProcCallCount",
		"adminProcCaller",
		"AdminProcCallSpamPrevention",
		"admins",
		"admin_datums",
		"admin_log",
		"admin_ranks",
		"admin_state",
		"alldirs",
		"ahelp_tickets",
		"adminfaxes",
		"adminlogs",
		"cardinal",
		"cardinalz",
		"IClog"
	)

/client/proc/debug_global_variables()
	set category = "Debug"
	set name = "View Global Variables"

	if(!global_vars_)
		global_vars_ = new()
	debug_variables(global_vars_)