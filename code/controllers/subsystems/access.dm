SUBSYSTEM_DEF(access)
	name = "Access"
	flags = SS_NO_FIRE

	VAR_PRIVATE/list/datum/access/priv_all_access_datums
	VAR_PRIVATE/list/datum/access/priv_all_access
	VAR_PRIVATE/list/datum/access/priv_station_access
	VAR_PRIVATE/list/datum/access/priv_centcom_access
	VAR_PRIVATE/list/datum/access/priv_syndicate_access
	VAR_PRIVATE/list/datum/access/priv_private_access

	VAR_PRIVATE/list/datum/access/priv_all_access_datums_id = list()
	VAR_PRIVATE/list/datum/access/priv_all_access_datums_region = list()
	VAR_PRIVATE/list/datum/access/priv_region_access = list()

/datum/controller/subsystem/access/Initialize()
	priv_all_access_datums = init_subtypes(/datum/access)
	priv_all_access_datums = dd_sortedObjectList(priv_all_access_datums)

	for(var/datum/access/A in get_all_access_datums())
		priv_all_access_datums_id["[A.id]"] = A
		LAZYADD(priv_all_access_datums_region["[A.region]"], A)
		LAZYADD(priv_region_access["[A.region]"], A.id)

	priv_all_access = get_access_ids()
	priv_station_access = get_access_ids(ACCESS_TYPE_STATION)
	priv_centcom_access = get_access_ids(ACCESS_TYPE_CENTCOM)
	priv_syndicate_access = get_access_ids(ACCESS_TYPE_SYNDICATE)
	priv_private_access = get_access_ids(ACCESS_TYPE_PRIVATE)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/access/proc/get_centcom_access(job)
	switch(job)
		if("VIP Guest")
			return list(ACCESS_CENT_GENERAL)
		if("Custodian")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE)
		if("Thunderdome Overseer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER)
		if("Intel Officer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING)
		if("Medical Officer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_MEDICAL)
		if("Death Commando")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE)
		if("Research Officer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_TELEPORTER, ACCESS_CENT_STORAGE)
		if("BlackOps Commander")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE, ACCESS_CENT_CREED)
		if("Supreme Commander")
			return get_all_centcom_access()

/datum/controller/subsystem/access/proc/get_all_access_datums()
	return priv_all_access_datums

/datum/controller/subsystem/access/proc/get_all_access_datums_by_id()
	return priv_all_access_datums_id

/datum/controller/subsystem/access/proc/get_all_access_datums_by_region()
	return priv_all_access_datums_region

/datum/controller/subsystem/access/proc/get_access_ids(access_types = ACCESS_TYPE_ALL)
	var/list/L = list()
	for(var/datum/access/A in get_all_access_datums())
		if(A.access_type & access_types)
			L += A.id
	return L

/datum/controller/subsystem/access/proc/get_all_accesses()
	RETURN_TYPE(/list)
	return priv_all_access

/datum/controller/subsystem/access/proc/get_all_station_access()
	RETURN_TYPE(/list)
	return priv_station_access

/datum/controller/subsystem/access/proc/get_all_centcom_access()
	RETURN_TYPE(/list)
	return priv_centcom_access

/datum/controller/subsystem/access/proc/get_all_syndicate_access()
	RETURN_TYPE(/list)
	return priv_syndicate_access

/datum/controller/subsystem/access/proc/get_all_private_access()
	RETURN_TYPE(/list)
	return priv_private_access

/datum/controller/subsystem/access/proc/get_region_accesses(code)
	if(code == ACCESS_REGION_ALL)
		return get_all_station_access()

	return priv_region_access["[code]"]

/datum/controller/subsystem/access/proc/get_region_accesses_name(code)
	switch(code)
		if(ACCESS_REGION_ALL)
			return "All"
		if(ACCESS_REGION_SECURITY) //security
			return "Security"
		if(ACCESS_REGION_MEDBAY) //medbay
			return "Medbay"
		if(ACCESS_REGION_RESEARCH) //research
			return "Research"
		if(ACCESS_REGION_ENGINEERING) //engineering and maintenance
			return "Engineering"
		if(ACCESS_REGION_COMMAND) //command
			return "Command"
		if(ACCESS_REGION_GENERAL) //station general
			return "Station General"
		if(ACCESS_REGION_SUPPLY) //supply
			return "Supply"

/datum/controller/subsystem/access/proc/get_access_desc(id)
	var/list/access_list = get_all_access_datums_by_id()
	var/datum/access/access_datum = access_list["[id]"]

	return access_datum ? access_datum.desc : ""

/datum/controller/subsystem/access/proc/get_centcom_access_desc(A)
	return get_access_desc(A)

/datum/controller/subsystem/access/proc/get_access_by_id(id)
	var/list/access_list = get_all_access_datums_by_id()
	return access_list["[id]"]
