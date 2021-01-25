/obj/item/device/tvcamera
	name = "press camera drone"
	desc = "A Ward-Takahashi EyeBuddy media streaming hovercam. Weapon of choice for war correspondents and reality show cameramen."
	icon_state = "camcorder"
	item_state = "camcorder"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BELT
	var/channel = "NCS Northern Star News Feed"
	var/obj/machinery/camera/network/thunder/camera
	var/obj/item/device/radio/radio

/obj/item/device/tvcamera/New()
	..()
	listening_objects += src

/obj/item/device/tvcamera/Destroy()
	listening_objects -= src
	qdel(camera)
	qdel(radio)
	camera = null
	radio = null
	..()

/obj/item/device/tvcamera/examine()
	. = ..()
	. += "Video feed is [camera.status ? "on" : "off"]"
	. += "Audio feed is [radio.broadcasting ? "on" : "off"]"

/obj/item/device/tvcamera/Initialize()
	. = ..()
	camera = new(src)
	camera.c_tag = channel
	camera.status = FALSE
	radio = new(src)
	radio.listening = FALSE
	radio.set_frequency(ENT_FREQ)
	radio.icon = src.icon
	radio.icon_state = src.icon_state
	update_icon()

/obj/item/device/tvcamera/hear_talk(mob/M, list/message_pieces, verb)
	radio.hear_talk(M, message_pieces, verb)
	. = ..()

/obj/item/device/tvcamera/attack_self(mob/user)
	add_fingerprint(user)
	user.set_machine(src)
	var/dat = list()
	dat += "Channel name is: <a href='?src=\ref[src];channel=1'>[channel ? channel : "unidentified broadcast"]</a><br>"
	dat += "Video streaming is <a href='?src=\ref[src];video=1'>[camera.status ? "on" : "off"]</a><br>"
	dat += "Mic is <a href='?src=\ref[src];sound=1'>[radio.broadcasting ? "on" : "off"]</a><br>"
	dat += "Sound is being broadcasted on frequency [format_frequency(radio.frequency)] ([get_frequency_name(radio.frequency)])<br>"
	var/datum/browser/popup = new(user, "Hovercamera", "Eye Buddy", 300, 390, src)
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/item/device/tvcamera/Topic(bred, href_list, state = GLOB.tgui_physical_state)
	if(..())
		return 1
	if(href_list["channel"])
		var/nc = input(usr, "Channel name", "Select new channel name", channel) as text|null
		if(nc)
			channel = nc
			camera.c_tag = channel
			to_chat(usr, "<span class='notice'>New channel name - '[channel]' is set</span>")
	if(href_list["video"])
		camera.set_status(!camera.status)
		if(camera.status)
			to_chat(usr,"<span class='notice'>Video streaming activated. Broadcasting on channel '[channel]'</span>")
		else
			to_chat(usr,"<span class='notice'>Video streaming deactivated.</span>")
		update_icon()
	if(href_list["sound"])
		radio.ToggleBroadcast()
		if(radio.broadcasting)
			to_chat(usr,"<span class='notice'>Audio streaming activated. Broadcasting on frequency [format_frequency(radio.frequency)].</span>")
		else
			to_chat(usr,"<span class='notice'>Audio streaming deactivated.</span>")
	if(!href_list["close"])
		attack_self(usr)

/obj/item/device/tvcamera/update_icon()
	..()
	if(camera.status)
		icon_state = "camcorder_on"
		item_state = "camcorder_on"
	else
		icon_state = "camcorder"
		item_state = "camcorder"
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		H.update_inv_r_hand()
		H.update_inv_l_hand()
		H.update_inv_belt()

