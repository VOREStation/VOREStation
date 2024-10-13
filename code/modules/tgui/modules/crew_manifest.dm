/datum/tgui_module/crew_manifest
	name = "Crew Manifest"
	tgui_id = "CrewManifest"

/datum/tgui_module/crew_manifest/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	if(data_core)
		data_core.get_manifest_list()
	data["manifest"] = PDA_Manifest
	return data

/datum/tgui_module/crew_manifest/robot
/datum/tgui_module/crew_manifest/robot/tgui_state(mob/user)
	return GLOB.tgui_self_state

// Module that deletes itself when it's closed
/datum/tgui_module/crew_manifest/self_deleting

/datum/tgui_module/crew_manifest/self_deleting/tgui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tgui_module/crew_manifest/self_deleting/tgui_state(mob/user)
	return GLOB.tgui_always_state
