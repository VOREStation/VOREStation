GLOBAL_DATUM_INIT(gear_tweak_free_color_choice, /datum/gear_tweak/color, new)
GLOBAL_DATUM_INIT(gear_tweak_implant_location, /datum/gear_tweak/implant_location, new)
GLOBAL_DATUM_INIT(gear_tweak_collar_tag, /datum/gear_tweak/collar_tag, new)

//Underwear
GLOBAL_DATUM_INIT(global_underwear, /datum/category_collection/underwear, new)

//Global Datums
GLOBAL_DATUM_INIT(icon_manager, /datum/pipe_icon_manager, new)
GLOBAL_DATUM_INIT(emergency_shuttle, /datum/emergency_shuttle_controller, new)

// We manually initialize the alarm handlers instead of looping over all existing types
// to make it possible to write: camera_alarm.triggerAlarm() rather than SSalarm.managers[datum/alarm_handler/camera].triggerAlarm() or a variant thereof.
GLOBAL_DATUM_INIT(atmosphere_alarm, /datum/alarm_handler/atmosphere, new)
GLOBAL_DATUM_INIT(camera_alarm, /datum/alarm_handler/camera, new)
GLOBAL_DATUM_INIT(fire_alarm, /datum/alarm_handler/fire, new)
GLOBAL_DATUM_INIT(motion_alarm, /datum/alarm_handler/motion, new)
GLOBAL_DATUM_INIT(power_alarm, /datum/alarm_handler/power, new)
