/datum/anomaly_modifiers
	var/name
	var/description
	var/value
	var/obj/effect/anomaly/attached_anomaly = null
	var/flags

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
	value = 1.2

/datum/anomaly_modifiers/invisible
	name = "Invisible"
	description = "Light wave distortion was detected."
	value = 1.5

/datum/anomaly_modifiers/invisible/on_add(datum/weakref/anomaly)
	if(!..())
		return
	addtimer(CALLBACK(attached_anomaly, TYPE_PROC_REF(/atom/movable/, cloak)), 2 SECONDS)

/datum/anomaly_modifiers/invisible/on_remove(datum/weakref/anomaly)
	if(!..())
		return
	addtimer(CALLBACK(attached_anomaly, TYPE_PROC_REF(/atom/movable/, uncloak)), 2 SECONDS)

/*
/datum/anomaly_modifiers/hidden
	name = "Hidden"
	description = "Interference detected. Some data cannot be read."
	value = 0.15
*/

/datum/anomaly_modifiers/move
	name = "Move"
	description = "Anomalous anchoring could not be detected."
	value = 1.4

/datum/anomaly_modifiers/move/on_add(datum/weakref/anomaly)
	if(!..())
		return
	attached_anomaly.move_chance = ANOMALY_MOVECHANCE

/datum/anomaly_modifiers/move/on_remove(datum/weakref/anomaly)
	if(!..())
		return
	attached_anomaly.move_chance = 0

/datum/anomaly_modifiers/fast
	name = "Faster Pulses"
	description = "Anomalous pulses are more common."
	value = 0.9

/datum/anomaly_modifiers/fast/on_add(datum/weakref/anomaly)
	if(!..())
		return

	var/datum/anomaly_stats/stats = attached_anomaly.stats
	stats.min_activation = 25 SECONDS
	stats.max_activation = 45 SECONDS

/datum/anomaly_modifiers/fast/on_remove(datum/weakref/anomaly)
	if(!..())
		return

	var/datum/anomaly_stats/stats = attached_anomaly.stats

	stats.min_activation = initial(stats.min_activation)
	stats.max_activation = initial(stats.max_activation)
