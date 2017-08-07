/var/global/list/construction_frame_wall
/var/global/list/construction_frame_floor

/proc/populate_frame_types()
	//Create global frame type list if it hasn't been made already.
	construction_frame_wall = list()
	construction_frame_floor = list()
	for(var/R in typesof(/datum/frame/frame_types) - /datum/frame/frame_types)
		var/datum/frame/frame_types/type = new R
		if(type.frame_style == "wall")
			construction_frame_wall += type
		else
			construction_frame_floor += type

	var/datum/frame/frame_types/cancel/cancel = new /datum/frame/frame_types/cancel
	construction_frame_wall += cancel
	construction_frame_floor += cancel

/datum/frame/frame_types
	var/icon/icon_override		// Icon to set on frame object when building. If null icon is unchanged.
	var/name					// Name assigned to the frame object.
	var/frame_size = 5			// Sheets of metal required to build.
	var/frame_class				// Determines construction method.  "machine", "computer", "alarm", or "display"
	var/circuit					// Type path of the circuit board that comes built in with this frame. Null to require adding a circuit.
	var/frame_style = "floor"	// "floor" or "wall"
	var/x_offset				// For wall frames: pixel_x
	var/y_offset				// For wall frames: pixel_y

// Get the icon state to use at a given state.  Default implementation is based on the frame's name
/datum/frame/frame_types/proc/get_icon_state(var/state)
	var/type = lowertext(name)
	type = replacetext(type, " ", "_")
	return "[type]_[state]"

/datum/frame/frame_types/computer
	name = "Computer"
	frame_class = "computer"

/datum/frame/frame_types/machine
	name = "Machine"
	frame_class = "machine"

/datum/frame/frame_types/conveyor
	name = "Conveyor"
	frame_class = "machine"
	circuit = /obj/item/weapon/circuitboard/conveyor

/datum/frame/frame_types/photocopier
	name = "Photocopier"
	frame_class = "machine"

/datum/frame/frame_types/washing_machine
	name = "Washing Machine"
	frame_class = "machine"

/datum/frame/frame_types/medical_console
	name = "Medical Console"
	frame_class = "computer"

/datum/frame/frame_types/medical_pod
	name = "Medical Pod"
	frame_class = "machine"

/datum/frame/frame_types/dna_analyzer
	name = "DNA Analyzer"
	frame_class = "machine"

/datum/frame/frame_types/mass_driver
	name = "Mass Driver"
	frame_class = "machine"
	circuit = /obj/item/weapon/circuitboard/mass_driver

/datum/frame/frame_types/holopad
	name = "Holopad"
	frame_class = "computer"
	frame_size = 4

/datum/frame/frame_types/microwave
	name = "Microwave"
	frame_class = "machine"
	frame_size = 4

/datum/frame/frame_types/fax
	name = "Fax"
	frame_class = "machine"
	frame_size = 3

/datum/frame/frame_types/recharger
	name = "Recharger"
	frame_class = "machine"
	circuit = /obj/item/weapon/circuitboard/recharger
	frame_size = 3

/datum/frame/frame_types/grinder
	name = "Grinder"
	frame_class = "machine"
	circuit = /obj/item/weapon/circuitboard/grinder
	frame_size = 3

/datum/frame/frame_types/display
	name = "Display"
	frame_class = "display"
	frame_style = "wall"
	x_offset = 32
	y_offset = 32

/datum/frame/frame_types/supply_request_console
	name = "Supply Request Console"
	frame_class = "display"
	frame_style = "wall"
	x_offset = 32
	y_offset = 32

/datum/frame/frame_types/atm
	name = "ATM"
	frame_class = "display"
	frame_size = 3
	frame_style = "wall"
	x_offset = 32
	y_offset = 32

/datum/frame/frame_types/newscaster
	name = "Newscaster"
	frame_class = "display"
	frame_size = 3
	frame_style = "wall"
	x_offset = 28
	y_offset = 30

/datum/frame/frame_types/wall_charger
	name = "Wall Charger"
	frame_class = "machine"
	circuit = /obj/item/weapon/circuitboard/recharger/wrecharger
	frame_size = 3
	frame_style = "wall"
	x_offset = 32
	y_offset = 32

/datum/frame/frame_types/fire_alarm
	name = "Fire Alarm"
	frame_class = "alarm"
	frame_size = 2
	frame_style = "wall"
	x_offset = 24
	y_offset = 24

/datum/frame/frame_types/air_alarm
	name = "Air Alarm"
	frame_class = "alarm"
	frame_size = 2
	frame_style = "wall"
	x_offset = 24
	y_offset = 24

/datum/frame/frame_types/guest_pass_console
	name = "Guest Pass Console"
	frame_class = "display"
	frame_size = 2
	frame_style = "wall"
	x_offset = 30
	y_offset = 30

/datum/frame/frame_types/intercom
	name = "Intercom"
	frame_class = "alarm"
	frame_size = 2
	frame_style = "wall"
	x_offset = 28
	y_offset = 28

/datum/frame/frame_types/keycard_authenticator
	name = "Keycard Authenticator"
	frame_class = "alarm"
	frame_size = 1
	frame_style = "wall"
	x_offset = 24
	y_offset = 24

/datum/frame/frame_types/cancel //used to get out of input dialogue
	name = "Cancel"

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
	if(frame_type.icon_override)
		icon = frame_type.icon_override
	icon_state = frame_type.get_icon_state(state)

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
			playsound(src.loc, P.usesound, 50, 1)
			if(do_after(user, 20 * P.toolspeed))
				anchored = 1
				if(!need_circuit && circuit)
					state = 2
					check_components()
					update_desc()
					user << "<span class='notice'>You wrench the frame into place and set the outer cover.</span>"
				else
					user << "<span class='notice'>You wrench the frame into place.</span>"

		else if(state == 0 && anchored)
			playsound(src, P.usesound, 50, 1)
			if(do_after(user, 20 * P.toolspeed))
				user << "<span class='notice'>You unfasten the frame.</span>"
				anchored = 0

	else if(istype(P, /obj/item/weapon/weldingtool))
		if(state == 0)
			var/obj/item/weapon/weldingtool/WT = P
			if(WT.remove_fuel(0, user))
				playsound(src.loc, P.usesound, 50, 1)
				if(do_after(user, 20 * P.toolspeed))
					if(src && WT.isOn())
						user << "<span class='notice'>You deconstruct the frame.</span>"
						new /obj/item/stack/material/steel(src.loc, frame_type.frame_size)
						qdel(src)
						return
			else if(!WT.remove_fuel(0, user))
				user << "The welding tool must be on to complete this task."
				return

	else if(istype(P, /obj/item/weapon/circuitboard) && need_circuit && !circuit)
		if(state == 0 && anchored)
			var/obj/item/weapon/circuitboard/B = P
			var/datum/frame/frame_types/board_type = B.board_type
			if(board_type.name == frame_type.name)
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
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
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You screw the circuit board into place.</span>"
				state = 2

		else if(state == 2)
			if(need_circuit && circuit)
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You unfasten the circuit board.</span>"
				state = 1

			else if(!need_circuit && circuit)
				playsound(src, P.usesound, 50, 1)
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
					playsound(src, P.usesound, 50, 1)
					var/obj/machinery/new_machine = new circuit.build_path(src.loc, dir)
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
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You fasten the cover.</span>"
				var/obj/machinery/B = new circuit.build_path(src.loc)
				B.pixel_x = pixel_x
				B.pixel_y = pixel_y
				B.set_dir(dir)
				circuit.construct(B)
				circuit.loc = null
				B.circuit = circuit
				qdel(src)
				return

		else if(state == 4)
			if(frame_type.frame_class == "computer")
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You connect the monitor.</span>"
				var/obj/machinery/B = new circuit.build_path(src.loc)
				B.pixel_x = pixel_x
				B.pixel_y = pixel_y
				B.set_dir(dir)
				circuit.construct(B)
				circuit.loc = null
				B.circuit = circuit
				qdel(src)
				return

			else if(frame_type.frame_class == "display")
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You connect the monitor.</span>"
				var/obj/machinery/B = new circuit.build_path(src.loc)
				B.pixel_x = pixel_x
				B.pixel_y = pixel_y
				B.set_dir(dir)
				circuit.construct(B)
				circuit.loc = null
				B.circuit = circuit
				qdel(src)
				return

	else if(istype(P, /obj/item/weapon/crowbar))
		if(state == 1)
			if(need_circuit && circuit)
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You remove the circuit board.</span>"
				state = 0
				circuit.forceMove(src.loc)
				circuit = null
				if(frame_type.frame_class == "machine")
					req_components = null

		else if(state == 3)
			if(frame_type.frame_class == "machine")
				playsound(src, P.usesound, 50, 1)
				if(components.len == 0)
					user << "<span class='notice'>There are no components to remove.</span>"
				else
					user << "<span class='notice'>You remove the components.</span>"
					for(var/obj/item/weapon/W in components)
						W.forceMove(src.loc)
					check_components()
					update_desc()
					user << desc

		else if(state == 4)
			if(frame_type.frame_class == "computer")
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You remove the glass panel.</span>"
				state = 3
				new /obj/item/stack/material/glass(src.loc, 2)

			else if(frame_type.frame_class == "display")
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You remove the glass panel.</span>"
				state = 3
				new /obj/item/stack/material/glass(src.loc, 2)

	else if(istype(P, /obj/item/stack/cable_coil))
		if(state == 2)
			var/obj/item/stack/cable_coil/C = P
			if(C.get_amount() < 5)
				user << "<span class='warning'>You need five coils of wire to add them to the frame.</span>"
				return
			user << "<span class='notice'>You start to add cables to the frame.</span>"
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			if(do_after(user, 20) && state == 2)
				if(C.use(5))
					user << "<span class='notice'>You add cables to the frame.</span>"
					state = 3
					if(frame_type.frame_class == "machine")
						user << desc
		else if(state == 3)
			if(frame_type.frame_class == "machine")
				for(var/I in req_components)
					if(istype(P, I) && (req_components[I] > 0))
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
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

						user.drop_item()
						P.forceMove(src)
						components += P
						req_components[I]--
						update_desc()
						break
				user << desc

	else if(istype(P, /obj/item/weapon/wirecutters))
		if(state == 3)
			if(frame_type.frame_class == "computer")
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				state = 2
				new /obj/item/stack/cable_coil(src.loc, 5)

			else if(frame_type.frame_class == "display")
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				state = 2
				new /obj/item/stack/cable_coil(src.loc, 5)

			else if(frame_type.frame_class == "alarm")
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				state = 2
				new /obj/item/stack/cable_coil(src.loc, 5)

			else if(frame_type.frame_class == "machine")
				playsound(src, P.usesound, 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				state = 2
				new /obj/item/stack/cable_coil(src.loc, 5)

	else if(istype(P, /obj/item/stack/material) && P.get_material_name() == "glass")
		if(state == 3)
			if(frame_type.frame_class == "computer")
				var/obj/item/stack/G = P
				if(G.get_amount() < 2)
					user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
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
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
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
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
						if(istype(P, /obj/item/stack/material/glass/reinforced))
							var/obj/item/stack/material/glass/reinforced/CP = P
							if(CP.get_amount() > 1)
								var/camt = min(CP.amount, req_components[I]) // amount of glass to take, idealy amount required, but limited by amount provided
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
				if(P && P.loc != src && !istype(P, /obj/item/stack/material))
					user << "<span class='warning'>You cannot add that component to the machine!</span>"
					return

	update_icon()

/obj/structure/frame/verb/rotate()
	set name = "Rotate Frame Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	set_dir(turn(dir, 90))

	var/dir_text
	if(dir == 1)
		dir_text = "north"
	else if(dir == 2)
		dir_text = "south"
	else if(dir == 4)
		dir_text = "east"
	else if(dir == 8)
		dir_text = "west"

	usr << "<span class='notice'>You rotate the [src] to face [dir_text]!</span>"

	return


/obj/structure/frame/verb/revrotate()
	set name = "Rotate Frame Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	set_dir(turn(dir, 270))

	var/dir_text
	if(dir == 1)
		dir_text = "north"
	else if(dir == 2)
		dir_text = "south"
	else if(dir == 4)
		dir_text = "east"
	else if(dir == 8)
		dir_text = "west"

	usr << "<span class='notice'>You rotate the [src] to face [dir_text]!</span>"

	return