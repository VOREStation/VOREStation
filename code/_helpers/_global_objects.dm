//Global Datums
GLOBAL_DATUM_INIT(gear_tweak_free_color_choice, /datum/gear_tweak/color, new)
GLOBAL_DATUM_INIT(gear_tweak_implant_location, /datum/gear_tweak/implant_location, new)
GLOBAL_DATUM_INIT(gear_tweak_collar_tag, /datum/gear_tweak/collar_tag, new)

//Underwear
GLOBAL_DATUM_INIT(global_underwear, /datum/category_collection/underwear, new)

// Pipe colors, needs to be inited before our pipe icon_manager
GLOBAL_LIST_INIT(pipe_colors, list("grey" = PIPE_COLOR_GREY, "red" = PIPE_COLOR_RED, "blue" = PIPE_COLOR_BLUE, "cyan" = PIPE_COLOR_CYAN, "green" = PIPE_COLOR_GREEN, "yellow" = PIPE_COLOR_YELLOW, "black" = PIPE_COLOR_BLACK, "orange" = PIPE_COLOR_ORANGE, "white" = PIPE_COLOR_WHITE, "purple" = PIPE_COLOR_PURPLE))
GLOBAL_DATUM_INIT(icon_manager, /datum/pipe_icon_manager, new)
GLOBAL_DATUM_INIT(emergency_shuttle, /datum/emergency_shuttle_controller, new)

GLOBAL_LIST_EMPTY(comm_message_listeners) //We first have to initialize list then we can use it.
GLOBAL_DATUM_INIT(global_message_listener, /datum/comm_message_listener, new) //May be used by admins
GLOBAL_DATUM_INIT(ntnet_global, /datum/ntnet, new)
GLOBAL_VAR_INIT(last_message_id, 0)

// We manually initialize the alarm handlers instead of looping over all existing types
// to make it possible to write: camera_alarm.triggerAlarm() rather than SSalarm.managers[datum/alarm_handler/camera].triggerAlarm() or a variant thereof.
GLOBAL_DATUM_INIT(atmosphere_alarm, /datum/alarm_handler/atmosphere, new)
GLOBAL_DATUM_INIT(camera_alarm, /datum/alarm_handler/camera, new)
GLOBAL_DATUM_INIT(fire_alarm, /datum/alarm_handler/fire, new)
GLOBAL_DATUM_INIT(motion_alarm, /datum/alarm_handler/motion, new)
GLOBAL_DATUM_INIT(power_alarm, /datum/alarm_handler/power, new)

// Visual nets
GLOBAL_LIST_EMPTY_TYPED(visual_nets, /datum/visualnet)
GLOBAL_DATUM_INIT(cameranet, /datum/visualnet/camera, new)
GLOBAL_DATUM_INIT(cultnet, /datum/visualnet/cult, new)
GLOBAL_DATUM_INIT(ghostnet, /datum/visualnet/ghost, new)

GLOBAL_DATUM_INIT(all_locations, /datum/locations/milky_way, new)

GLOBAL_DATUM_INIT(news_network, /datum/feed_network, new) //The global news-network, which is coincidentally a global list.

GLOBAL_DATUM_INIT(loremaster, /datum/lore/loremaster, new)
