/datum/event2/meta/camera_damage
	name = "random camera damage"
	departments = list(DEPARTMENT_SYNTHETIC, DEPARTMENT_ENGINEERING)
	chaos = 5
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	reusable = TRUE
	event_type = /datum/event2/event/camera_damage

/datum/event2/meta/camera_damage/get_weight()
	return 30 + (GLOB.metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 20) + (GLOB.metric.count_people_in_department(DEPARTMENT_SYNTHETIC) * 40)

/datum/event2/event/camera_damage
	var/camera_range = 7

/datum/event2/event/camera_damage/start()
	var/obj/machinery/camera/C = acquire_random_camera()
	if(!C)
		return

	for(var/obj/machinery/camera/cam in range(camera_range, C))
		if(is_valid_camera(cam))
			cam.wires.cut(WIRE_MAIN_POWER1)
			if(prob(25))
				cam.wires.cut(WIRE_CAM_ALARM)

/datum/event2/event/camera_damage/proc/acquire_random_camera(var/remaining_attempts = 5)
	if(!cameranet.cameras.len)
		return
	if(!remaining_attempts)
		return

	var/obj/machinery/camera/C = pick(cameranet.cameras)
	if(is_valid_camera(C))
		return C
	// It is very important to use --var and not var-- for recursive calls, as var-- will cause an infinite loop.
	return acquire_random_camera(--remaining_attempts)

/datum/event2/event/camera_damage/proc/is_valid_camera(var/obj/machinery/camera/C)
	// Only return a functional camera, not installed in a silicon/hardsuit/circuit/etc, and that exists somewhere players have access
	var/turf/T = get_turf(C)
	return T && C?.can_use() && istype(C.loc, /turf) && (T.z in using_map.player_levels)
