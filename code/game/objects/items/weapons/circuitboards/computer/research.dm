#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/rdconsole
	name = T_BOARD("R&D control console")
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(src, I.usesound, 50, 1)
		user.visible_message("<b>\The [user]</b> adjusts the jumper on \the [src]'s access protocol pins.", "<span class='notice'>You adjust the jumper on the access protocol pins.</span>")
		if(build_path == /obj/machinery/computer/rdconsole/core)
			name = T_BOARD("RD Console - Robotics")
			build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, "<span class='notice'>Access protocols set to robotics.</span>")
		else
			name = T_BOARD("RD Console")
			build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, "<span class='notice'>Access protocols set to default.</span>")
	return