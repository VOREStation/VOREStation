/mob/living/silicon/ai/death(gibbed)

	if(stat == DEAD)
		return

	if(controlling_drone)
		controlling_drone.release_ai_control("<b>WARNING: Primary control loop failure.</b> Session terminated.")
	. = ..(gibbed)

	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))

	remove_ai_verbs(src)

	for(var/obj/machinery/ai_status_display/O in machines)
		spawn( 0 )
		O.mode = 2
		if (istype(loc, /obj/item/device/aicard))
			var/obj/item/device/aicard/card = loc
			card.update_icon()

	. = ..(gibbed,"gives one shrill beep before falling lifeless.")
	density = 1
