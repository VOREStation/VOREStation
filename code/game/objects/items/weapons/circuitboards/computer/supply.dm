#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/supplycomp
	name = T_BOARD("supply ordering console")
	build_path = /obj/machinery/computer/supplycomp
	origin_tech = list(TECH_DATA = 2)
	var/contraband_enabled = 0

/obj/item/circuitboard/supplycomp/control
	name = T_BOARD("supply ordering console")
	build_path = /obj/machinery/computer/supplycomp/control
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/supplycomp/construct(var/obj/machinery/computer/supplycomp/SC)
	if (..(SC))
		SC.can_order_contraband = contraband_enabled

/obj/item/circuitboard/supplycomp/deconstruct(var/obj/machinery/computer/supplycomp/SC)
	if (..(SC))
		contraband_enabled = SC.can_order_contraband

/obj/item/circuitboard/supplycomp/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/multitool))
		var/catastasis = src.contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		switch(tgui_alert(usr, "Current receiver spectrum is set to: [catastasis]","Multitool-Circuitboard interface",list("Switch to [opposite_catastasis]","Cancel")))
			if("Switch to STANDARD","Switch to BROAD")
				src.contraband_enabled = !src.contraband_enabled

			if("Cancel", null)
				return
			else
				to_chat(user, "DERP! BUG! Report this (And what you were doing to cause it) to Agouri")
	return
