/datum/proc/CanProcCall(procname)
	return TRUE

/datum/proc/can_vv_get(var_name)
	return TRUE

/datum/proc/vv_edit_var(var_name, var_value) //called whenever a var is edited
	if(var_name == NAMEOF(src, vars) || var_name == NAMEOF(src, parent_type))
		return FALSE
	vars[var_name] = var_value
	datum_flags |= DF_VAR_EDITED
	return TRUE

/datum/proc/vv_get_var(var_name)
	switch(var_name)
		if ("vars")
			return debug_variable(var_name, list(), 0, src)
	return debug_variable(var_name, get_variable_value(var_name), 0, src)

//please call . = ..() first and append to the result, that way parent items are always at the top and child items are further down
//add separaters by doing . += "---"
/datum/proc/vv_get_dropdown()
	. = list()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_CALLPROC, "Call Proc")
	VV_DROPDOWN_OPTION(VV_HK_MARK, "Mark Object")
	VV_DROPDOWN_OPTION(VV_HK_DELETE, "Delete")
	VV_DROPDOWN_OPTION(VV_HK_EXPOSE, "Show VV To Player")
	VV_DROPDOWN_OPTION(VV_HK_ADDCOMPONENT, "Add Component/Element")

//This proc is only called if everything topic-wise is verified. The only verifications that should happen here is things like permission checks!
//href_list is a reference, modifying it in these procs WILL change the rest of the proc in topic.dm of admin/view_variables!
/datum/proc/vv_do_topic(list/href_list)
	if(!usr || !usr.client.holder)
		return			//This is VV, not to be called by anything else.
	IF_VV_OPTION(VV_HK_EXPOSE)
		if(!check_rights(R_ADMIN, FALSE))
			return
		var/value = usr.client.vv_get_value(VV_CLIENT)
		if (value["class"] != VV_CLIENT)
			return
		var/client/C = value["value"]
		if (!C)
			return
		var/prompt = tgui_alert(usr, "Do you want to grant [C] access to view this VV window? (they will not be able to edit or change anysrc nor open nested vv windows unless they themselves are an admin)", "Confirm", list("Yes", "No"))
		if (prompt != "Yes" || !usr.client)
			return
		message_admins("[key_name_admin(usr)] Showed [key_name_admin(C)] a <a href='?_src_=vars;[HrefToken()];datumrefresh=\ref[src]'>VV window</a>")
		log_admin("Admin [key_name(usr)] Showed [key_name(C)] a VV window of a [src]")
		to_chat(C, "[usr.client.holder.fakekey ? "an Administrator" : "[usr.client.key]"] has granted you access to view a View Variables window")
		C.debug_variables(src)
	IF_VV_OPTION(VV_HK_DELETE)
		if(!check_rights(R_DEBUG))
			return
		usr.client.admin_delete(src)
		if (isturf(src))  // show the turf that took its place
			usr.client.debug_variables(src)
	IF_VV_OPTION(VV_HK_MARK)
		usr.client.mark_datum(src)
	IF_VV_OPTION(VV_HK_CALLPROC)
		usr.client.callproc_datum(src)
	IF_VV_OPTION(VV_HK_ADDCOMPONENT)
		if(!check_rights(NONE))
			return
		var/list/names = list()
		var/list/componentsubtypes = sortTim(subtypesof(/datum/component), GLOBAL_PROC_REF(cmp_typepaths_asc))
		names += "---Components---"
		names += componentsubtypes
		names += "---Elements---"
		names += sortTim(subtypesof(/datum/element), GLOBAL_PROC_REF(cmp_typepaths_asc))
		var/result = tgui_input_list(usr, "Choose a component/element to add:", "Add Component/Element", names)
		if(!usr || !result || result == "---Components---" || result == "---Elements---")
			return
		if(QDELETED(src))
			to_chat(usr, "That thing doesn't exist anymore!")
			return
		var/list/lst = usr.client.get_callproc_args()
		if(!lst)
			return
		var/datumname = "error"
		lst.Insert(1, result)
		if(result in componentsubtypes)
			datumname = "component"
			_AddComponent(lst)
		else
			datumname = "element"
			_AddElement(lst)
		log_admin("[key_name(usr)] has added [result] [datumname] to [key_name(src)].")
		message_admins(span_notice("[key_name_admin(usr)] has added [result] [datumname] to [key_name_admin(src)]."))

/datum/proc/vv_get_header()
	. = list()
	if(("name" in vars) && !isatom(src))
		. += "<b>[vars["name"]]</b><br>"

/datum/proc/on_reagent_change(changetype)
	return
