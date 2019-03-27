#define VV_MSG_MARKED "<br><font size='1' color='red'><b>Marked Object</b></font>"
#define VV_MSG_EDITED "<br><font size='1' color='red'><b>Var Edited</b></font>"
#define VV_MSG_DELETED "<br><font size='1' color='red'><b>Deleted</b></font>"

/datum/proc/CanProcCall(procname)
	return TRUE

/datum/proc/can_vv_get(var_name)
	//Pending refactor of vv_hidden
	//return TRUE

	return !(var_name in VV_hidden())

/datum/proc/vv_edit_var(var_name, var_value) //called whenever a var is edited
	//Pending refactor of vv_static
	//if(var_name == NAMEOF(src, vars))
	//	return FALSE
	if(var_name in VV_static())
		return FALSE
	vars[var_name] = var_value
	return TRUE
