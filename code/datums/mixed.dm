//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/datum/data
	var/name = "data"
	var/size = 1.0


/datum/data/function
	name = "function"
	size = 2.0


/datum/data/function/data_control
	name = "data control"


/datum/data/function/id_changer
	name = "id changer"


/datum/data/record
	name = "record"
	size = 5.0
	var/list/fields = list(  )

// Mostly used for data_core records, but unfortuantely used some other places too.  But mostly here, so lets make a good effort.
// TODO - Some machines/computers might be holding references to us.  Lets look into that, but at least for now lets make sure that the manifest is cleaned up.
/datum/data/record/Destroy(var/force)
	if(data_core.locked.Find(src))
		if(!force)
			stack_trace("Someone tried to qdel a record that was in data_core.locked [log_info_line(src)]")
			return QDEL_HINT_LETMELIVE
		data_core.locked -= src
	data_core.medical -= src
	data_core.general -= src
	data_core.security -= src
	. = ..()

/datum/data/text
	name = "text"
	var/data = null



/datum/debug
	var/list/debuglist
