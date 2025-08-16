/datum/proc/CanProcCall(procname)
	return TRUE

/datum/proc/can_vv_get(var_name)
	if(var_name == NAMEOF(src, vars))
		return FALSE
	return TRUE

/// Called when a var is edited with the new value to change to
/datum/proc/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, vars))
		return FALSE
	vars[var_name] = var_value
	datum_flags |= DF_VAR_EDITED
	return TRUE

/datum/proc/vv_get_var(var_name)
	switch(var_name)
		if (NAMEOF(src, vars))
			return debug_variable(var_name, list(), 0, src)
	return debug_variable(var_name, vars[var_name], 0, src)

/datum/proc/can_vv_mark()
	return TRUE

/**
 * Gets all the dropdown options in the vv menu.
 * When overriding, make sure to call . = ..() first and append to the result, that way parent items are always at the top and child items are further down.
 * Add separators by doing VV_DROPDOWN_OPTION("", "---")
 */
/datum/proc/vv_get_dropdown()
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_CALLPROC, "Call Proc")
	VV_DROPDOWN_OPTION(VV_HK_MARK, "Mark Object")
	VV_DROPDOWN_OPTION(VV_HK_TAG, "Tag Datum")
	VV_DROPDOWN_OPTION(VV_HK_DELETE, "Delete")
	VV_DROPDOWN_OPTION(VV_HK_EXPOSE, "Show VV To Player")
	VV_DROPDOWN_OPTION(VV_HK_ADDCOMPONENT, "Add Component/Element")
	VV_DROPDOWN_OPTION(VV_HK_REMOVECOMPONENT, "Remove Component/Element")
	VV_DROPDOWN_OPTION(VV_HK_MASS_REMOVECOMPONENT, "Mass Remove Component/Element")
	//VV_DROPDOWN_OPTION(VV_HK_MODIFY_TRAITS, "Modify Traits")

/**
 * This proc is only called if everything topic-wise is verified. The only verifications that should happen here is things like permission checks!
 * href_list is a reference, modifying it in these procs WILL change the rest of the proc in topic.dm of admin/view_variables!
 * This proc is for "high level" actions like admin heal/set species/etc/etc. The low level debugging things should go in admin/view_variables/topic_basic.dm in case this runtimes.
 */
/datum/proc/vv_do_topic(list/href_list)
	if(!usr || !usr.client || !usr.client.holder || !check_rights(R_VAREDIT))
		return FALSE //This is VV, not to be called by anything else.
	if(SEND_SIGNAL(src, COMSIG_VV_TOPIC, usr, href_list) & COMPONENT_VV_HANDLED)
		return FALSE
	//if(href_list[VV_HK_MODIFY_TRAITS])
	//	usr.client.holder.modify_traits(src)
	return TRUE

//This proc is only called if everything topic-wise is verified. The only verifications that should happen here is things like permission checks!
//href_list is a reference, modifying it in these procs WILL change the rest of the proc in topic.dm of admin/view_variables!
/*
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
		message_admins("[key_name_admin(usr)] Showed [key_name_admin(C)] a <a href='byond://?_src_=vars;[HrefToken()];datumrefresh=\ref[src]'>VV window</a>")
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
*/

/datum/proc/vv_get_header()
	. = list()
	if(("name" in vars) && !isatom(src))
		. += span_bold("[vars["name"]]") + "<br>"

/datum/proc/on_reagent_change(changetype)
	return
