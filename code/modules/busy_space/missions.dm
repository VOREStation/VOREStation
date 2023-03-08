/datum/lore/mission
	var/prefix = ""
	var/mission_strings = list()
	var/mission_type = ""

/datum/lore/mission/New(_prefix,_mission_strings,_mission_type)
	prefix = _prefix
	mission_strings = _mission_strings
	mission_type = _mission_type

/datum/lore/mission/prebuilt
/datum/lore/mission/prebuilt/New(a)
	prefix = a

//Default mission types for ease of populating organizations
//Most orgs that do medical missions are going to run comperable kinds of medical mission
/datum/lore/mission/prebuilt/medical
	mission_strings = list("medical", "medical resupply", "hospital", "vaccine distribution")
	mission_type = ATC_MED

/datum/lore/mission/prebuilt/transport
	mission_strings = list("transport", "passenger transport", "general transport", "courier")
	mission_type = ATC_TRANS

/datum/lore/mission/prebuilt/freight
	mission_strings = list("freight", "hauling", "bulk transport", "materials delivery")
	mission_type = ATC_FREIGHT

/datum/lore/mission/prebuilt/defense
	mission_strings = list("defense", "asset protection", "patrol")
	mission_type = ATC_DEF

/datum/lore/mission/prebuilt/industrial
	mission_strings = list("industrial", "construction", "repair", "maintence", "factory resupply")
	mission_type = ATC_INDU

/datum/lore/mission/prebuilt/scientific
	mission_strings = list("scientific", "research", "data collection", "survey")
	mission_type = ATC_SCI

/datum/lore/mission/prebuilt/diplomatic
	mission_strings = list("diplomatic", "dignitary transport", "cultural exchange")
	mission_type = ATC_DIPLO

/datum/lore/mission/prebuilt/luxury
	mission_strings = list("luxury cruise", "pleasure cruise", "VIP transport", "sight-seeing", "vacation")
	mission_type = ATC_LUX

/datum/lore/mission/prebuilt/salvage
	mission_strings = list("salvage", "scrap gathering", "damage assessment", "material recovery", "data recovery", "effects recovery", "in-situ repair")
	mission_type = ATC_SALVAGE

/datum/lore/mission/prebuilt/medical_response
	mission_strings = list("medical response", "emergency triage", "first response", "pathogen containment")
	mission_type = ATC_MED

/datum/lore/mission/prebuilt/defense_response
	mission_strings = list("crisis response", "SOS investigation", "high-priority escort", "rescue")
	mission_type = ATC_DEF

/datum/lore/mission/prebuilt/transport/default
	prefix = "ITV"