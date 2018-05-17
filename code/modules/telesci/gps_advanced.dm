
// DEPRECATED - The normal GPS has the advanced features, now. This is obsolete.

// These are distinguished from the ordinary "Relay Position Devices" that just print your location
// In that they are also all networked with each other to show each other's locations.
/obj/item/device/gps/advanced
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 1995."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	var/gpstag = "COM0"
	emped = 0

/obj/item/device/gps/advanced/New()
	..()
	GPS_list.Add(src)
	name = "global positioning system ([gpstag])"
	overlays += "working"

/obj/item/device/gps/advanced/Destroy()
	GPS_list.Remove(src)
	. = ..()

/obj/item/device/gps/advanced/emp_act(severity)
	emped = 1
	overlays -= "working"
	overlays += "emp"
	spawn(300)
		emped = 0
		overlays -= "emp"
		overlays += "working"

/obj/item/device/gps/advanced/attack_self(mob/user as mob)

	var/obj/item/device/gps/advanced/t = ""
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A> "
		t += "<BR>Tag: [gpstag]"

		for(var/obj/item/device/gps/advanced/G in GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G.emped == 1)
				t += "<BR>[tracked_gpstag]: ERROR"
			else
				t += "<BR>[tracked_gpstag]: [format_text(gps_area.name)] ([pos.x], [pos.y], [pos.z])"

	var/datum/browser/popup = new(user, "GPS", name, 600, 450)
	popup.set_content(t)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/item/device/gps/advanced/Topic(href, href_list)
	..()
	if(href_list["tag"] )
		var/a = input("Please enter desired tag.", name, gpstag) as text
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(src.loc == usr)
			gpstag = a
			name = "global positioning system ([gpstag])"
			attack_self(usr)

/obj/item/device/gps/advanced/science
	icon_state = "gps-s"
	gpstag = "SCI0"

/obj/item/device/gps/advanced/engineering
	icon_state = "gps-e"
	gpstag = "ENG0"

/obj/item/device/gps/advanced/security
	icon_state = "gps-sec"
	gpstag = "SEC0"
