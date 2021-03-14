//Define a macro that we can use to assemble all the circuit board names
#ifdef T_BOARD
#error T_BOARD already defined elsewhere, we can't use it.
#endif
#define T_BOARD(name)	"circuit board (" + (name) + ")"

/obj/item/weapon/circuitboard
	name = "circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	origin_tech = list(TECH_DATA = 2)
	density = 0
	anchored = 0
	w_class = ITEMSIZE_SMALL
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	var/build_path = null
	var/board_type = new /datum/frame/frame_types/computer
	var/list/req_components = null
	var/contain_parts = 1
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'

	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50, MAT_COPPER = 100)

//Called when the circuitboard is used to contruct a new machine.
/obj/item/weapon/circuitboard/proc/construct(var/obj/machinery/M)
	if(istype(M, build_path))
		return 1
	return 0

//Called when a computer is deconstructed to produce a circuitboard.
//Only used by computers, as other machines store their circuitboard instance.
/obj/item/weapon/circuitboard/proc/deconstruct(var/obj/machinery/M)
	if(istype(M, build_path))
		return 1
	return 0

//Should be called from the constructor of any machine to automatically populate the default parts
/obj/item/weapon/circuitboard/proc/apply_default_parts(var/obj/machinery/M)
	if(!istype(M))
		return
	if(!req_components)
		return
	M.component_parts = list()
	for(var/comp_path in req_components)
		var/comp_amt = req_components[comp_path]
		if(!comp_amt)
			continue

		if(ispath(comp_path, /obj/item/stack))
			M.component_parts += new comp_path(contain_parts ? M : null, comp_amt)
		else
			for(var/i in 1 to comp_amt)
				M.component_parts += new comp_path(contain_parts ? M : null)
	return
