/obj/machinery/geiger
	name = "portable geiger"
	desc = "A portable device used for detecting and measuring radiation in an area."
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "geiger_off"
	anchored = 0
	density = 1
	var/scanning = 0
	var/radiation_count = 0
	var/datum/looping_sound/geiger/soundloop

/obj/machinery/geiger/Initialize()
	soundloop = new(list(src), FALSE)
	update_icon()
	update_sound()
	return ..()

/obj/machinery/geiger/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/geiger/process()
	get_radiation()

/obj/machinery/geiger/proc/get_radiation()
	if(!scanning)
		return
	radiation_count = SSradiation.get_rads_at_turf(get_turf(src))
	update_icon()
	update_sound()

/obj/machinery/geiger/examine(mob/user)
	. = ..()
	get_radiation()
	. += "<span class='warning'>[scanning ? "Ambient" : "Stored"] radiation level: [radiation_count ? radiation_count : "0"]Bq.</span>"

/obj/machinery/geiger/rad_act(amount)
	if(!amount || !scanning)
		return FALSE

	if(amount > radiation_count)
		radiation_count = amount

	update_icon()
	update_sound()

/obj/machinery/flasher/portable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_wrench())
		add_fingerprint(user)
		anchored = !anchored

		if(!anchored)
			user.show_message(text("<span class='warning'>[src] can now be moved.</span>"))
		else if(anchored)
			user.show_message(text("<span class='warning'>[src] is now secured.</span>"))

/obj/machinery/geiger/proc/update_sound()
	var/datum/looping_sound/geiger/loop = soundloop
	if(!scanning)
		loop.stop()
		return
	if(!radiation_count)
		loop.stop()
		return
	loop.last_radiation = radiation_count
	loop.start()

/obj/machinery/geiger/attack_hand(var/mob/user)
	scanning = !scanning
	if(scanning)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	update_icon()
	update_sound()
	to_chat(user, "<span class='notice'>[bicon(src)] You switch [scanning ? "on" : "off"] \the [src].</span>")

/obj/machinery/geiger/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		return 1

	switch(radiation_count)
		if(null)
			icon_state = "geiger_on_1"
		if(-INFINITY to RAD_LEVEL_LOW)
			icon_state = "geiger_on_1"
		if(RAD_LEVEL_LOW to RAD_LEVEL_MODERATE)
			icon_state = "geiger_on_2"
		if(RAD_LEVEL_MODERATE to RAD_LEVEL_HIGH)
			icon_state = "geiger_on_3"
		if(RAD_LEVEL_HIGH to RAD_LEVEL_VERY_HIGH)
			icon_state = "geiger_on_4"
		if(RAD_LEVEL_VERY_HIGH to INFINITY)
			icon_state = "geiger_on_5"
