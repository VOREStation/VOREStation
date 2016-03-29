/obj/structure/frame
	anchored = 0
	name = "frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "machine_0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null
	var/need_circuit = 1
	var/frame_type = "machine"

	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null

	var/list/alarms = list("firealarm", "airalarm", "intercom", "keycard")
	var/list/machines = list("machine", "photocopier", "fax", "microwave", "conveyor", "vending", "recharger", "wrecharger", "washing", "grinder")
	var/list/computers = list("computer", "holopad")
	var/list/displays = list("display", "guestpass", "newscaster", "atm")
	var/list/no_circuit = list("wrecharger", "recharger", "grinder","conveyor")

/obj/structure/frame/proc/update_desc()
	var/D
	if(req_components)
		var/list/component_list = new
		for(var/I in req_components)
			if(req_components[I] > 0)
				component_list += "[num2text(req_components[I])] [req_component_names[I]]"
		D = "Requires [english_list(component_list)]."
	desc = D

/obj/structure/frame/proc/check_components(mob/user as mob)
	components = list()
	req_components = circuit.req_components.Copy()
	for(var/A in circuit.req_components)
		req_components[A] = circuit.req_components[A]
	req_component_names = circuit.req_components.Copy()
	for(var/A in req_components)
		var/cp = text2path(A)
		var/obj/ct = new cp() // have to quickly instantiate it get name
		req_component_names[A] = ct.name

/obj/structure/frame/New(var/loc, var/dir, var/building = 0, var/obj/item/frame/frame_type, mob/user as mob)
	..()
	if(building)
		src.frame_type = frame_type
		icon_state = "[frame_type]_0"

		if(frame_type in alarms)
			if(loc)
				src.loc = loc

			state = 0
			if(frame_type == "airalarm" || frame_type == "firealarm" || frame_type == "keycard")
				if(dir)
					src.set_dir(dir)
				pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
				pixel_y = (dir & 3)? (dir == 1 ? -24 : 24) : 0

			if(frame_type == "intercom")
				if(dir)
					src.set_dir(dir)
				pixel_x = (dir & 3)? 0 : (dir == 4 ? -28 : 28)
				pixel_y = (dir & 3)? (dir == 1 ? -28 : 28) : 0

			update_icon()
			return

		if(frame_type in displays)
			if(loc)
				src.loc = loc

			if(frame_type == "display" || frame_type == "atm")
				pixel_x = (dir & 3)? 0 : (dir == 4 ? -32 : 32)
				pixel_y = (dir & 3)? (dir == 1 ? -32 : 32) : 0

			if(frame_type == "newscaster")
				pixel_x = (dir & 3)? 0 : (dir == 4 ? -28 : 28)
				pixel_y = (dir & 3)? (dir == 1 ? -30 : 30) : 0

			if(frame_type == "guestpass")
				pixel_x = (dir & 3)? 0 : (dir == 4 ? -30 : 30)
				pixel_y = (dir & 3)? (dir == 1 ? -30 : 30) : 0

			update_icon()
			return

		if(frame_type in no_circuit)
			need_circuit = 0
			if(frame_type == "wrecharger")
				circuit = new /obj/item/weapon/circuitboard/recharger/wrecharger(src)
				if(loc)
					src.loc = loc

				state = 0

				pixel_x = (dir & 3)? 0 : (dir == 4 ? -26 : 32)
				pixel_y = (dir & 3)? (dir == 1 ? -32 : 32) : 0

				update_icon()
				return
			if(frame_type == "recharger")
				circuit = new /obj/item/weapon/circuitboard/recharger(src)
			if(frame_type == "grinder")
				circuit = new /obj/item/weapon/circuitboard/grinder(src)
			if(frame_type == "conveyor")
				circuit = new /obj/item/weapon/circuitboard/conveyor(src)
				if(dir)
					src.set_dir(dir)

	if(frame_type == "computer")
		density = 1
	if(frame_type in machines)
		density = 1
	return

/obj/structure/frame/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/wrench))
		if(state == 0)
			user << "<span class='notice'>You start to wrench the frame into place.</span>"
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 20))
				src.anchored = 1
				if(!need_circuit && circuit)
					src.state = 2
					check_components()
					update_desc()
					src.icon_state = "[frame_type]_2"
					user << "<span class='notice'>You wrench the frame into place and set the outer cover.</span>"
				else
					src.state = 1
					user << "<span class='notice'>You wrench the frame into place.</span>"
			return

		if(state == 1)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 20))
				user << "<span class='notice'>You unfasten the frame.</span>"
				src.anchored = 0
				src.state = 0
			return

	if(istype(P, /obj/item/weapon/weldingtool))
		if(state == 0)
			var/obj/item/weapon/weldingtool/WT = P
			if(!WT.remove_fuel(0, user))
				user << "The welding tool must be on to complete this task."
				return
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(do_after(user, 20))
				if(!src || !WT.isOn()) return
				user << "<span class='notice'>You deconstruct the frame.</span>"
				if(frame_type == "holopad" || frame_type == "microwave")
					new /obj/item/stack/material/steel( src.loc, 4 )
				else if(frame_type == "fax" || frame_type == "newscaster" || frame_type == "recharger" || frame_type == "wrecharger" || frame_type == "grinder")
					new /obj/item/stack/material/steel( src.loc, 3 )
				else if(frame_type == "firealarm" || frame_type == "airalarm" || frame_type == "intercom" || frame_type == "guestpass")
					new /obj/item/stack/material/steel( src.loc, 2 )
				else if(frame_type == "keycard")
					new /obj/item/stack/material/steel( src.loc, 1 )
				else
					new /obj/item/stack/material/steel( src.loc, 5 )
				qdel(src)
				return

	if(istype(P, /obj/item/weapon/circuitboard) && need_circuit && !circuit)
		if(state == 1)
			var/obj/item/weapon/circuitboard/B = P
			if(B.board_type == frame_type)
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You place the circuit board inside the frame.</span>"
				src.icon_state = "[frame_type]_1"
				src.circuit = P
				user.drop_item()
				P.loc = src
				if(frame_type in machines)  //because machines are assholes
					check_components()
					update_desc()
				return
			else
				user << "<span class='warning'>This frame does not accept circuit boards of this type!</span>"
			return

	if(istype(P, /obj/item/weapon/screwdriver))
		if(state == 1)
			if(need_circuit && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You screw the circuit board into place.</span>"
				src.state = 2
				src.icon_state = "[frame_type]_2"
			return

		if(state == 2)
			if(need_circuit && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You unfasten the circuit board.</span>"
				src.state = 1
				src.icon_state = "[frame_type]_1"
				return

			if(!need_circuit && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You unfasten the outer cover.</span>"
				src.state = 1
				src.icon_state = "[frame_type]_0"
			return

		if(state == 3)
			if(frame_type in machines)
				var/component_check = 1
				for(var/R in req_components)
					if(req_components[R] > 0)
						component_check = 0
						break
				if(component_check)
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
					var/obj/machinery/new_machine = new src.circuit.build_path(src.loc, src.dir)
					if(!new_machine.component_parts)
						for(var/obj/O in src.components)
							O.forceMove(null)
						new_machine.RefreshParts()

					src.circuit.construct(new_machine)
					new_machine.pixel_x = src.pixel_x
					new_machine.pixel_y = src.pixel_y
					qdel(src)
				return

			if(frame_type in alarms)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You fasten the cover.</span>"
				var/obj/machinery/B = new src.circuit.build_path ( src.loc )
				B.pixel_x = src.pixel_x
				B.pixel_y = src.pixel_y
				B.set_dir(dir)
				src.circuit.construct(B)
				qdel(src)
				return

		if(state == 4)
			if(frame_type in computers)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You connect the monitor.</span>"
				var/obj/machinery/B = new src.circuit.build_path ( src.loc )
				B.pixel_x = src.pixel_x
				B.pixel_y = src.pixel_y
				src.circuit.construct(B)
				qdel(src)
				return

			if(frame_type in displays)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You connect the monitor.</span>"
				var/obj/machinery/B = new src.circuit.build_path ( src.loc )
				B.pixel_x = src.pixel_x
				B.pixel_y = src.pixel_y
				src.circuit.construct(B)
				qdel(src)
				return

	if(istype(P, /obj/item/weapon/crowbar))
		if(state == 1)
			if(need_circuit && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the circuit board.</span>"
				src.state = 1
				src.icon_state = "[frame_type]_0"
				circuit.loc = src.loc
				src.circuit = null
				if(frame_type in machines) //becuase machines are assholes
					req_components = null
				return

		if(state == 3)
			if(frame_type in machines)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				if(components.len == 0)
					user << "<span class='notice'>There are no components to remove.</span>"
				else
					user << "<span class='notice'>You remove the components.</span>"
					for(var/obj/item/weapon/W in components)
						W.forceMove(loc)
					check_components()
					update_desc()
					user << desc
				return

		if(state == 4)
			if(frame_type in computers)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the glass panel.</span>"
				src.state = 3
				src.icon_state = "[frame_type]_3"
				new /obj/item/stack/material/glass( src.loc, 2 )
				return

			if(frame_type in displays)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the glass panel.</span>"
				src.state = 3
				src.icon_state = "[frame_type]_3"
				new /obj/item/stack/material/glass( src.loc, 2 )
				return

	if(istype(P, /obj/item/stack/cable_coil))
		if(state == 2)
			var/obj/item/stack/cable_coil/C = P
			if (C.get_amount() < 5)
				user << "<span class='warning'>You need five coils of wire to add them to the frame.</span>"
				return
			user << "<span class='notice'>You start to add cables to the frame.</span>"
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			if(do_after(user, 20) && state == 2)
				if (C.use(5))
					user << "<span class='notice'>You add cables to the frame.</span>"
					state = 3
					icon_state = "[frame_type]_3"
					if(frame_type in machines)
						user << desc
			return

	if(istype(P, /obj/item/weapon/wirecutters))
		if(state == 3)
			if(frame_type in computers)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				src.state = 2
				src.icon_state = "[frame_type]_2"
				new /obj/item/stack/cable_coil( src.loc, 5 )
				return

			if(frame_type in displays)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				src.state = 2
				src.icon_state = "[frame_type]_2"
				new /obj/item/stack/cable_coil( src.loc, 5 )
				return

			if(frame_type in alarms)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				src.state = 2
				src.icon_state = "[frame_type]_2"
				new /obj/item/stack/cable_coil( src.loc, 5 )
				return

			if(frame_type in machines)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				src.state = 2
				src.icon_state = "[frame_type]_2"
				new /obj/item/stack/cable_coil( src.loc, 5 )
				return

	if(istype(P, /obj/item/stack/material) && P.get_material_name() == "glass")
		if(state == 3)
			if(frame_type in computers)
				var/obj/item/stack/G = P
				if (G.get_amount() < 2)
					user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You start to put in the glass panel.</span>"
				if(do_after(user, 20) && state == 3)
					if (G.use(2))
						user << "<span class='notice'>You put in the glass panel.</span>"
						src.state = 4
						src.icon_state = "[frame_type]_4"
				return

			if(frame_type in displays)
				var/obj/item/stack/G = P
				if (G.get_amount() < 2)
					user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You start to put in the glass panel.</span>"
				if(do_after(user, 20) && state == 3)
					if (G.use(2))
						user << "<span class='notice'>You put in the glass panel.</span>"
						src.state = 4
						src.icon_state = "[frame_type]_4"
				return

	if(istype(P, /obj/item))
		if(state == 3)
			if(frame_type in machines)
				for(var/I in req_components)
					if(istype(P, text2path(I)) && (req_components[I] > 0))
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
						if(istype(P, /obj/item/stack))
							var/obj/item/stack/CP = P
							if(CP.get_amount() > 1)
								var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
								var/obj/item/stack/CC = new /obj/item/stack(src)
								CC.amount = camt
								CC.update_icon()
								CP.use(camt)
								components += CC
								req_components[I] -= camt
								update_desc()
								break
						user.drop_item()
						P.forceMove(src)
						components += P
						req_components[I]--
						update_desc()
						break
				user << desc
				if(P && P.loc != src && !istype(P, /obj/item/stack/cable_coil) && !istype(P, /obj/item/stack/material))
					user << "<span class='warning'>You cannot add that component to the machine!</span>"
				return