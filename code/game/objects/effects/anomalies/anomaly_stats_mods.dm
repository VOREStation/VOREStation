/datum/anomaly_modifiers
	var/name
	var/description
	var/value

/datum/anomaly_modifiers/proc/get_description()
	return description

/datum/anomaly_modifiers/proc/get_value()
	return value

/datum/anomaly_modifiers/proc/on_add(datum/anomaly_stats/anom_stats)
	return

/datum/anomaly_modifiers/proc/on_remove(datum/anomaly_stats/anom_stats)
	return

/datum/anomaly_modifiers/reflective
	name = "Reflective"
	description = "A protective coating was detected."
	value = 0.1

/datum/anomaly_modifiers/reflective/on_add(datum/anomaly_stats/anom_stats)
	anom_stats.flags |= ANOMALY_MOD_REFLECTIVE

/datum/anomaly_modifiers/reflective/on_remove(datum/anomaly_stats/anom_stats)
	anom_stats.flags &= ~ANOMALY_MOD_REFLECTIVE

/datum/anomaly_modifiers/invisible
	name = "Invisible"
	description = "Light wave distortion was detected."
	value = 0.1

/datum/anomaly_modifiers/invisible/on_add(datum/anomaly_stats/anom_stats)
	var/obj/effect/anomaly/target = anom_stats.attached_anomaly
	target.cloak()

/datum/anomaly_modifiers/invisible/on_remove(datum/anomaly_stats/anom_stats)
	var/obj/effect/anomaly/target = anom_stats.attached_anomaly
	target.uncloak()

/datum/anomaly_modifiers/hidden
	name = "Hidden"
	description = "Interference detected. Some data cannot be read."
	value = 0.15

/datum/anomaly_modifiers/move
	name = "Move"
	description = "Anomalous anchoring could not be detected."
	value = 0.2

/datum/anomaly_modifiers/move/on_add(datum/anomaly_stats/anom_stats)
	var/obj/effect/anomaly/target = anom_stats.attached_anomaly
	target.move_chance = ANOMALY_MOVECHANCE

/datum/anomaly_modifiers/move/on_remove(datum/anomaly_stats/anom_stats)
	var/obj/effect/anomaly/target = anom_stats.attached_anomaly
	target.move_chance = 0
