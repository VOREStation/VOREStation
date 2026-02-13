/datum/anomaly_modifiers
	var/name
	var/description
	var/value
	var/obj/effect/anomaly/attached_anomaly = null

/datum/anomaly_modifiers/proc/get_description()
	return description

/datum/anomaly_modifiers/proc/get_value()
	return value

/datum/anomaly_modifiers/proc/on_add(datum/weakref/anomaly)
	attached_anomaly = anomaly.resolve()
	if(!istype(attached_anomaly))
		return FALSE
	return TRUE

/datum/anomaly_modifiers/proc/on_remove(datum/weakref/anomaly)
	attached_anomaly = anomaly.resolve()
	if(!istype(attached_anomaly))
		return FALSE
	return TRUE

/datum/anomaly_modifiers/reflective
	name = "Reflective"
	description = "A protective coating was detected."
	value = 0.1

/datum/anomaly_modifiers/reflective/on_add(datum/weakref/anomaly)
	var/datum/anomaly_stats/stats = attached_anomaly.stats
	stats.flags |= ANOMALY_MOD_REFLECTIVE

/datum/anomaly_modifiers/reflective/on_remove(datum/weakref/anomaly)
	var/datum/anomaly_stats/stats = attached_anomaly.stats
	stats.flags &= ~ANOMALY_MOD_REFLECTIVE

/datum/anomaly_modifiers/invisible
	name = "Invisible"
	description = "Light wave distortion was detected."
	value = 0.6

/datum/anomaly_modifiers/invisible/on_add(datum/weakref/anomaly)
	if(!..())
		return
	attached_anomaly.cloak()

/datum/anomaly_modifiers/invisible/on_remove(datum/weakref/anomaly)
	if(!..())
		return
	attached_anomaly.uncloak()

/*
/datum/anomaly_modifiers/hidden
	name = "Hidden"
	description = "Interference detected. Some data cannot be read."
	value = 0.15
*/

/datum/anomaly_modifiers/move
	name = "Move"
	description = "Anomalous anchoring could not be detected."
	value = 0.2

/datum/anomaly_modifiers/move/on_add(datum/weakref/anomaly)
	if(!..())
		return
	attached_anomaly.move_chance = ANOMALY_MOVECHANCE

/datum/anomaly_modifiers/move/on_remove(datum/weakref/anomaly)
	if(!..())
		return
	attached_anomaly.move_chance = 0
