/obj/item/integrated_circuit/storage
	category_text = "Storage"
/*
/obj/item/integrated_circuit/storage/storage
	name = "item storage"
	desc = "Can store up to 8 medium sized items inside"
	icon_state = "reagent_storage"
	extended_desc = "This is effectively an internal box."
	complexity = 9
	w_class = ITEMSIZE_NORMAL
	inputs = list("mode" = IC_PINTYPE_NUMBER)
	outputs = list("slots used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_REF)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
*/


/obj/item/integrated_circuit/storage/manipulator
	name = "manipulator"
	desc = "A circuit with it's own inventory for items, used to grab and store things."
	icon_state = "grabber"
	extended_desc = "The circuit accepts a reference to an object to be grabbed and can store up to 10 objects. Modes: 1 to grab, 0 to eject the first object, and -1 to eject all objects."
	w_class = WEIGHT_CLASS_SMALL
	size = 3

	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER,"direction" = IC_PINTYPE_DIR)
	outputs = list("item" = IC_PINTYPE_REF,"last" = IC_PINTYPE_REF, "amount" = IC_PINTYPE_NUMBER,"contents" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	var/max_items = 1

/obj/item/integrated_circuit/manipulation/grabber/do_work()
	var/max_w_class = assembly.w_class
	var/atom/movable/acting_object = get_object()
	var/turf/T = get_turf(acting_object)
	var/obj/item/AM = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(AM)
		var/mode = get_pin_data(IC_INPUT, 2)
		if(mode == 1)
			if(check_target(AM))
				var/weightcheck = FALSE
				if (AM.w_class < max_w_class)
					weightcheck = TRUE
				else
					weightcheck = FALSE
				if((contents.len < max_items) && (weightcheck))
					AM.forceMove(src)
		if(mode == 0)
			if(contents.len)
				var/obj/item/U = contents[1]
				U.forceMove(T)
		if(mode == -1)
			if(contents.len)
				var/obj/item/U
				for(U in contents)
					U.forceMove(T)
	if(contents.len)
		set_pin_data(IC_OUTPUT, 1, WEAKREF(contents[1]))
		set_pin_data(IC_OUTPUT, 2, WEAKREF(contents[contents.len]))
	else
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, contents.len)
	set_pin_data(IC_OUTPUT, 4, contents)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/grabber/attack_self(var/mob/user)
	if(contents.len)
		var/turf/T = get_turf(src)
		var/obj/item/U
		for(U in contents)
			U.forceMove(T)
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, contents.len)
	push_data()