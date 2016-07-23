/obj/structure/frame
	anchored = 0
	name = "frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "machine_0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null
	var/need_circuit = 1
	var/datum/frame/frame_types/frame_type = new /datum/frame/frame_types/machine

	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null

/obj/structure/frame/computer //used for maps
	frame_type = new /datum/frame/frame_types/computer
	anchored = 1
	density = 1

/obj/structure/frame/proc/update_desc()
	var/D
	if(req_components)
		var/list/component_list = new
		for(var/I in req_components)
			if(req_components[I] > 0)
				component_list += "[num2text(req_components[I])] [req_component_names[I]]"
		D = "Requires [english_list(component_list)]."
	desc = D

/obj/structure/frame/update_icon()
	..()
	var/type = lowertext(frame_type.name)
	type = replacetext(type, " ", "_")
	icon_state = "[type]_[state]"

/obj/structure/frame/proc/check_components(mob/user as mob)
	components = list()
	req_components = circuit.req_components.Copy()
	for(var/A in circuit.req_components)
		req_components[A] = circuit.req_components[A]
	req_component_names = circuit.req_components.Copy()
	for(var/A in req_components)
		var/obj/ct = A
		req_component_names[A] = initial(ct.name)

/obj/structure/frame/New(var/loc, var/dir, var/building = 0, var/datum/frame/frame_types/type, mob/user as mob)
	..()
	if(building)
		frame_type = type
		state = 0

		if(dir)
			set_dir(dir)

		if(loc)
			src.loc = loc

		if(frame_type.x_offset)
			pixel_x = (dir & 3)? 0 : (dir == 4 ? -frame_type.x_offset : frame_type.x_offset)

		if(frame_type.y_offset)
			pixel_y = (dir & 3)? (dir == 1 ? -frame_type.y_offset : frame_type.y_offset) : 0

		if(frame_type.circuit)
			need_circuit = 0
			circuit = new frame_type.circuit(src)

	if(frame_type.name == "Computer")
		density = 1

	if(frame_type.frame_class == "machine")
		density = 1

	update_icon()

/obj/structure/frame/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/wrench))
		if(state == 0 && !anchored)
			user << "<span class='notice'>You start to wrench the frame into place.</span>"
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 20))
				anchored = 1
				if(!need_circuit && circuit)
					state = 2
					check_components()
					update_desc()
					user << "<span class='notice'>You wrench the frame into place and set the outer cover.</span>"
				else
					user << "<span class='notice'>You wrench the frame into place.</span>"

		else if(state == 0 && anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 20))
				user << "<span class='notice'>You unfasten the frame.</span>"
				anchored = 0

	else if(istype(P, /obj/item/weapon/weldingtool))
		if(state == 0)
			var/obj/item/weapon/weldingtool/WT = P
			if(WT.remove_fuel(0, user))
				playsound(loc, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20))
					if(src && WT.isOn())
						user << "<span class='notice'>You deconstruct the frame.</span>"
						new /obj/item/stack/material/steel(loc, frame_type.frame_size)
						qdel(src)
						return
			else if(!WT.remove_fuel(0, user))
				user << "The welding tool must be on to complete this task."
				return

	else if(istype(P, /obj/item/weapon/circuitboard) && need_circuit && !circuit)
		if(state == 0 && anchored)
			var/obj/item/weapon/circuitboard/B = P
			if(B.board_type == frame_type)
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You place the circuit board inside the frame.</span>"
				circuit = P
				user.drop_item()
				P.loc = src
				state = 1
				if(frame_type.frame_class == "machine")
					check_components()
					update_desc()
			else
				user << "<span class='warning'>This frame does not accept circuit boards of this type!</span>"
				return

	else if(istype(P, /obj/item/weapon/screwdriver))
		if(state == 1)
			if(need_circuit && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You screw the circuit board into place.</span>"
				state = 2

		else if(state == 2)
			if(need_circuit && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You unfasten the circuit board.</span>"
				state = 1

			else if(!need_circuit && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You unfasten the outer cover.</span>"
				state = 0

		else if(state == 3)
			if(frame_type.frame_class == "machine")
				var/component_check = 1
				for(var/R in req_components)
					if(req_components[R] > 0)
						component_check = 0
						break
				if(component_check)
					playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
					var/obj/machinery/new_machine = new circuit.build_path(loc, dir)
					// Handle machines that have allocated default parts in thier constructor.
					if(new_machine.component_parts)
						for(var/CP in new_machine.component_parts)
							qdel(CP)
						new_machine.component_parts.Cut()
					else
						new_machine.component_parts = list()

					circuit.construct(new_machine)

					for(var/obj/O in components)
						if(circuit.contain_parts)
							O.loc = new_machine
						else
							O.loc = null
						new_machine.component_parts += O

					circuit.loc = null
					new_machine.circuit = circuit

					new_machine.RefreshParts()

					new_machine.pixel_x = pixel_x
					new_machine.pixel_y = pixel_y
					qdel(src)
					return

			else if(frame_type.frame_class == "alarm")
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You fasten the cover.</span>"
				var/obj/machinery/B = new circuit.build_path(loc)
				B.pixel_x = pixel_x
				B.pixel_y = pixel_y
				B.set_dir(dir)
				circuit.construct(B)
				qdel(src)
				return

		else if(state == 4)
			if(frame_type.frame_class == "computer")
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You connect the monitor.</span>"
				var/obj/machinery/B = new circuit.build_path(loc)
				B.pixel_x = pixel_x
				B.pixel_y = pixel_y
				B.set_dir(dir)
				circuit.construct(B)
				qdel(src)
				return

			else if(frame_type.frame_class == "display")
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You connect the monitor.</span>"
				var/obj/machinery/B = new circuit.build_path(loc)
				B.pixel_x = pixel_x
				B.pixel_y = pixel_y
				B.set_dir(dir)
				circuit.construct(B)
				qdel(src)
				return

	else if(istype(P, /obj/item/weapon/crowbar))
		if(state == 1)
			if(need_circuit && circuit)
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the circuit board.</span>"
				state = 0
				circuit.loc = loc
				circuit = null
				if(frame_type.frame_class == "machine")
					req_components = null

		else if(state == 3)
			if(frame_type.frame_class == "machine")
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				if(components.len == 0)
					user << "<span class='notice'>There are no components to remove.</span>"
				else
					user << "<span class='notice'>You remove the components.</span>"
					for(var/obj/item/weapon/W in components)
						W.forceMove(loc)
					check_components()
					update_desc()
					user << desc

		else if(state == 4)
			if(frame_type.frame_class == "computer")
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the glass panel.</span>"
				state = 3
				new /obj/item/stack/material/glass(loc, 2)

			else if(frame_type.frame_class == "display")
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the glass panel.</span>"
				state = 3
				new /obj/item/stack/material/glass(loc, 2)

	else if(istype(P, /obj/item/stack/cable_coil))
		if(state == 2)
			var/obj/item/stack/cable_coil/C = P
			if(C.get_amount() < 5)
				user << "<span class='warning'>You need five coils of wire to add them to the frame.</span>"
				return
			user << "<span class='notice'>You start to add cables to the frame.</span>"
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
			if(do_after(user, 20) && state == 2)
				if(C.use(5))
					user << "<span class='notice'>You add cables to the frame.</span>"
					state = 3
					if(frame_type.frame_class == "machine")
						user << desc

	else if(istype(P, /obj/item/weapon/wirecutters))
		if(state == 3)
			if(frame_type.frame_class == "computer")
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				state = 2
				new /obj/item/stack/cable_coil(loc, 5)

			else if(frame_type.frame_class == "display")
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				state = 2
				new /obj/item/stack/cable_coil(loc, 5)

			else if(frame_type.frame_class == "alarm")
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				state = 2
				new /obj/item/stack/cable_coil(loc, 5)

			else if(frame_type.frame_class == "machine")
				playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				state = 2
				new /obj/item/stack/cable_coil(loc, 5)

	else if(istype(P, /obj/item/stack/material) && P.get_material_name() == "glass")
		if(state == 3)
			if(frame_type.frame_class == "computer")
				var/obj/item/stack/G = P
				if(G.get_amount() < 2)
					user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You start to put in the glass panel.</span>"
				if(do_after(user, 20) && state == 3)
					if(G.use(2))
						user << "<span class='notice'>You put in the glass panel.</span>"
						state = 4

			else if(frame_type.frame_class == "display")
				var/obj/item/stack/G = P
				if(G.get_amount() < 2)
					user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You start to put in the glass panel.</span>"
				if(do_after(user, 20) && state == 3)
					if(G.use(2))
						user << "<span class='notice'>You put in the glass panel.</span>"
						state = 4

	else if(istype(P, /obj/item))
		if(state == 3)
			if(frame_type.frame_class == "machine")
				for(var/I in req_components)
					if(istype(P, I) && (req_components[I] > 0))
						playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
						if(istype(P, /obj/item/stack/cable_coil))
							var/obj/item/stack/cable_coil/CP = P
							if(CP.get_amount() > 1)
								var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
								var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src)
								CC.amount = camt
								CC.update_icon()
								CP.use(camt)
								components += CC
								req_components[I] -= camt
								update_desc()
								break

						else if(istype(P, /obj/item/stack/material/glass/reinforced))
							var/obj/item/stack/material/glass/reinforced/CP = P
							if(CP.get_amount() > 1)
								var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
								var/obj/item/stack/material/glass/reinforced/CC = new /obj/item/stack/material/glass/reinforced(src)
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

	update_icon()
