
/mob/living/carbon/proc/get_sensor_level()
	var/obj/item/organ/internal/augment/suit_sensors/sensor_imp = locate() in internal_organs
	if(istype(sensor_imp))
		return sensor_imp.sensor_mode
	return SUIT_SENSOR_OFF

/mob/living/carbon/proc/has_sensor_level(level)
	return get_sensor_level() >= level
