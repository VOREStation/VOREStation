/// Sends information needed for shared details on individual preferences
/datum/asset/json/preferences
	name = "preferences"

/datum/asset/json/preferences/generate()
	var/list/preference_data = list()

	for(var/middleware_type in subtypesof(/datum/preference_middleware))
		var/datum/preference_middleware/middleware = new middleware_type
		var/data = middleware.get_constant_data()
		if(!isnull(data))
			preference_data[middleware.key] = data

		qdel(middleware)

	for(var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference_entry = GLOB.preference_entries[preference_type]
		var/data = preference_entry.compile_constant_data()
		if(!isnull(data))
			preference_data[preference_entry.savefile_key] = data

	return preference_data
