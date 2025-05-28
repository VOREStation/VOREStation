
// DEPRECATED - The normal GPS has the advanced features, now. This is obsolete.

// These are distinguished from the ordinary "Relay Position Devices" that just print your location
// In that they are also all networked with each other to show each other's locations.
/obj/item/gps/advanced
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 1995."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	gps_tag = "COM0"
	emped = 0

/obj/item/gps/advanced/Initialize(mapload)
	. = ..()
	add_overlay("working")

/obj/item/gps/advanced/emp_act(severity)
	emped = 1
	cut_overlay("working")
	add_overlay("emp")
	spawn(300)
		emped = 0
		cut_overlay("emp")
		add_overlay("working")

/obj/item/gps/advanced/attack_self(mob/user as mob)

	var/obj/item/gps/advanced/t = ""
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='byond://?src=\ref[src];advtag=1'>Set Tag</A> "
		t += "<BR>Tag: [gps_tag]"

		for(var/obj/item/gps/advanced/G in GLOB.GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gps_tag
			if(G.emped == 1)
				t += "<BR>[tracked_gpstag]: ERROR"
			else
				t += "<BR>[tracked_gpstag]: [format_text(gps_area.name)] ([pos.x], [pos.y], [pos.z])"

	var/datum/browser/popup = new(user, "GPS", name, 600, 450)
	popup.set_content(t)
	popup.open()

/obj/item/gps/advanced/Topic(href, href_list)
	..()
	if(href_list["advtag"] )
		var/a = tgui_input_text(usr, "Please enter desired tag.", name, gps_tag)
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(src.loc == usr)
			gps_tag = a
			name = "global positioning system ([gps_tag])"
			attack_self(usr)

/obj/item/gps/advanced/science
	icon_state = "gps-s"
	gps_tag = "SCI0"

/obj/item/gps/advanced/engineering
	icon_state = "gps-e"
	gps_tag = "ENG0"

/obj/item/gps/advanced/security
	icon_state = "gps-sec"
	gps_tag = "SEC0"
