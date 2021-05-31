/obj/machinery/power/anomaly
	name = "strange object"
	desc = "A strange grey and purple... machine? It has a blinking button on it that you don't think you should press."
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "rad_anomaly"
	density = 1
	anchored = 0
	var/on = 0
	var/rads = 1000
	var/power_level = 2

/obj/machinery/power/anomaly/New()
	..()
	check_rads()
	set_light(7, 7, "#F6FF00")

/obj/machinery/power/anomaly/attack_hand(mob/user as mob)
	on = !on
	investigate_log("turned [on?"<font color='red'>ON</font>":"<font color='green'>OFF</font>"] by [usr ? usr.key : "outside forces"]","singulo")
	message_admins("Rad anomaly [on ?"ON":"OFF"] by [key_name(usr, usr.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("RAD_ANOMALY([x],[y],[z]) [key_name(usr)] turned [on?"ON":"OFF"].")
	if(on)
		src.visible_message("<span class = 'cult'>All at once, you feel thousands of presences staring at you.</span>")
		set_light(7, 7, "#F6FF00")
		check_rads()
	else
		src.visible_message("<span class = 'cult'>All at once, you witness the deaths of thousands of beings.</span>")
		set_light(0, 0, "#000000")
		rads = 5
	src.add_fingerprint(user)

/obj/machinery/power/anomaly/process()
	SSradiation.radiate(src, rads)

/obj/machinery/power/anomaly/proc/check_rads()
	if(on)
		if(power_level == 0)
			rads = 5
		if(power_level == 1)
			rads = 10
		if(power_level == 2)
			rads = 50
		if(power_level == 3)
			rads = 100
		if(power_level == 4)
			rads = 250
		if(power_level == 5)
			rads = 500
		if(power_level == 6)
			rads = 1000
		if(power_level == 7)
			rads = 2500
		if(power_level == 8)
			rads = 5000


/obj/machinery/power/anomaly/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/device/multitool))
		power_level++
		if(power_level == 0)
			to_chat(user, "<span class = 'notice'>Power level set to 0.</span>")
		if(power_level == 1)
			to_chat(user, "<span class = 'notice'>Power level set to 1.</span>")
		if(power_level == 2)
			to_chat(user, "<span class = 'notice'>Power level set to 2.</span>")
		if(power_level == 3)
			to_chat(user, "<span class = 'notice'>Power level set to 3.</span>")
		if(power_level == 4)
			to_chat(user, "<span class = 'notice'>Power level set to 4.</span>")
		if(power_level == 5)
			to_chat(user, "<span class = 'notice'>Power level set to 5.</span>")
		if(power_level == 6)
			to_chat(user, "<span class = 'notice'>Power level set to 6.</span>")
		if(power_level == 7)
			to_chat(user, "<span class = 'notice'>Power level set to 7.</span>")
		if(power_level == 8)
			to_chat(user, "<span class = 'notice'>Power level set to 8.</span>")
		if(power_level == 9)
			power_level = 0
			to_chat(user, "<span class = 'notice'>Power level set to 0.</span>")
		log_game("RAD_ANOMALY([x],[y],[z]) [key_name(usr)] increased to [power_level]")
		investigate_log("increased to <font color='red'>[power_level]</font> by [usr.key]","singulo")
		check_rads()
	if(istype(O, /obj/item/weapon/tool/wrench))
		add_fingerprint(user)
		anchored = !anchored
		on = 0
		check_rads()
		if(!anchored)
			user.show_message(text("<span class='warning'>[src] can now be moved.</span>"))
		else if(anchored)
			user.show_message(text("<span class='warning'>[src] is now secured.</span>"))
