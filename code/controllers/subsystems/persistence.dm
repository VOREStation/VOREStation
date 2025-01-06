SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE
	var/list/tracking_values = list()
	var/list/persistence_datums = list()

	/// Places our subsystem can spawn paintings (helps with art spawning differently across maps)
	var/list/obj/structure/sign/painting/painting_frames = list()
	var/list/all_paintings = list()
	var/list/unpicked_paintings = list()

/datum/controller/subsystem/persistence/Initialize()
	for(var/datum/persistent/P as anything in subtypesof(/datum/persistent))
		if(initial(P.name))
			P = new P
			persistence_datums[P.type] = P
			P.Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/persistence/Shutdown()
	for(var/thing in persistence_datums)
		var/datum/persistent/P = persistence_datums[thing]
		P.Shutdown()

/datum/controller/subsystem/persistence/proc/track_value(var/atom/value, var/track_type)

	if(CONFIG_GET(flag/persistence_disabled)) //if the config is set to persistence disabled, nothing will save or load.
		return

	var/turf/T = get_turf(value)
	if(!T)
		return

	var/area/A = get_area(T)
	if(!A || (A.flag_check(AREA_FLAG_IS_NOT_PERSISTENT)))
		return

	if(!(T.z in using_map.persist_levels))
		return

	if(!tracking_values[track_type])
		tracking_values[track_type] = list()
	tracking_values[track_type] += value

/datum/controller/subsystem/persistence/proc/forget_value(var/atom/value, var/track_type)
	if(tracking_values[track_type])
		tracking_values[track_type] -= value


/datum/controller/subsystem/persistence/proc/show_info(var/mob/user)
	if(!user.client.holder)
		return

	var/list/dat = list("<table width = '100%'>")
	var/can_modify = check_rights(R_ADMIN, 0, user)
	for(var/thing in persistence_datums)
		var/datum/persistent/P = persistence_datums[thing]
		if(P.has_admin_data)
			dat += P.GetAdminSummary(user, can_modify)
	dat += "</table>"
	var/datum/browser/popup = new(user, "admin_persistence", "Persistence Data")
	popup.set_content(jointext(dat, null))
	popup.open()
