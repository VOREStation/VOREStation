//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = TRUE
	anchored = FALSE
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/circuitboard/circuit = null
//	weight = 1.0E8

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(P.has_tool_quality(TOOL_WRENCH))
				playsound(src, P.usesound, 50, 1)
				if(do_after(user, 20 * P.toolspeed))
					to_chat(user, span_notice("You wrench the frame into place."))
					src.anchored = TRUE
					src.state = 1
			if(P.has_tool_quality(TOOL_WELDER))
				var/obj/item/weldingtool/WT = P.get_welder()
				if(!WT.remove_fuel(0, user))
					to_chat(user, "The welding tool must be on to complete this task.")
					return
				playsound(src, WT.usesound, 50, 1)
				if(do_after(user, 20 * WT.toolspeed))
					if(!src || !WT.isOn()) return
					to_chat(user, span_notice("You deconstruct the frame."))
					new /obj/item/stack/material/steel( src.loc, 5 )
					qdel(src)
		if(1)
			if(P.has_tool_quality(TOOL_WRENCH))
				playsound(src, P.usesound, 50, 1)
				if(do_after(user, 20 * P.toolspeed))
					to_chat(user, span_notice("You unfasten the frame."))
					src.anchored = FALSE
					src.state = 0
			if(istype(P, /obj/item/circuitboard) && !circuit)
				var/obj/item/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, span_notice("You place the circuit board inside the frame."))
					src.icon_state = "1"
					src.circuit = P
					user.drop_item()
					P.loc = src
				else
					to_chat(user, span_warning("This frame does not accept circuit boards of this type!"))
			if(P.has_tool_quality(TOOL_SCREWDRIVER) && circuit)
				playsound(src, P.usesound, 50, 1)
				to_chat(user, span_notice("You screw the circuit board into place."))
				src.state = 2
				src.icon_state = "2"
			if(P.has_tool_quality(TOOL_CROWBAR)) && circuit)
				playsound(src, P.usesound, 50, 1)
				to_chat(user, span_notice("You remove the circuit board."))
				src.state = 1
				src.icon_state = "0"
				circuit.loc = src.loc
				src.circuit = null
		if(2)
			if(P.has_tool_quality(TOOL_SCREWDRIVER) && circuit)
				playsound(src, P.usesound, 50, 1)
				to_chat(user, span_notice("You unfasten the circuit board."))
				src.state = 1
				src.icon_state = "1"
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					to_chat(user, span_warning("You need five coils of wire to add them to the frame."))
					return
				to_chat(user, span_notice("You start to add cables to the frame."))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20) && state == 2)
					if (C.use(5))
						to_chat(user, span_notice("You add cables to the frame."))
						state = 3
						icon_state = "3"
		if(3)
			if(P.has_tool_quality(TOOL_WIRECUTTER))
				playsound(src, P.usesound, 50, 1)
				to_chat(user, span_notice("You remove the cables."))
				src.state = 2
				src.icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5

			if(istype(P, /obj/item/stack/material) && P.get_material_name() == "glass")
				var/obj/item/stack/G = P
				if (G.get_amount() < 2)
					to_chat(user, span_warning("You need two sheets of glass to put in the glass panel."))
					return
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, span_notice("You start to put in the glass panel."))
				if(do_after(user, 20) && state == 3)
					if (G.use(2))
						to_chat(user, span_notice("You put in the glass panel."))
						src.state = 4
						src.icon_state = "4"
		if(4)
			if(P.has_tool_quality(TOOL_CROWBAR))
				playsound(src, P.usesound, 50, 1)
				to_chat(user, span_notice("You remove the glass panel."))
				src.state = 3
				src.icon_state = "3"
				new /obj/item/stack/material/glass( src.loc, 2 )
			if(P.has_tool_quality(TOOL_SCREWDRIVER))
				playsound(src, P.usesound, 50, 1)
				to_chat(user, span_notice("You connect the monitor."))
				var/B = new src.circuit.build_path ( src.loc )
				src.circuit.construct(B)
				qdel(src)
