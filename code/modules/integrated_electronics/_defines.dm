#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "template"
	w_class = 1
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/activators = list()
	var/number_of_inputs = 0 //This is how many input pins are created
	var/number_of_outputs = 0 //Likewise for output
	var/number_of_activators = 0 //Guess
	var/list/input_names = list()
	var/list/output_names = list()
	var/list/activator_names = list()
	var/last_used = 0 //Uses world.time
	var/complexity = 1 //This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/power_required = 5 //w

/obj/item/integrated_circuit/examine(mob/user)
	..()
	user << "This board has [inputs.len] input [inputs.len != 1 ? "pins" : "pin"] and \
	[outputs.len] output [outputs.len != 1 ? "pins" : "pin"]."
	for(var/datum/integrated_io/input/I in inputs)
		if(I.linked.len)
			user << "\The [I.name] is connected to [I.get_linked_to_desc()]."
	for(var/datum/integrated_io/output/O in outputs)
		if(O.linked.len)
			user << "\The [O.name] is connected to [O.get_linked_to_desc()]."
	for(var/datum/integrated_io/activate/A in activators)
		if(A.linked.len)
			user << "\The [A.name] is connected to [A.get_linked_to_desc()]."

/obj/item/integrated_circuit/New()
	..()
	var/i = 0
	if(number_of_inputs)
		for(i = number_of_inputs, i > 0, i--)
			inputs.Add(new /datum/integrated_io/input(src))

	if(number_of_outputs)
		for(i = number_of_outputs, i > 0, i--)
			outputs.Add(new /datum/integrated_io/output(src))

	if(number_of_activators)
		for(i = number_of_activators, i > 0, i--)
			activators.Add(new /datum/integrated_io/activate(src))

	apply_names_to_io()

/obj/item/integrated_circuit/proc/apply_names_to_io()
	var/i = 1
	if(input_names.len)
		for(var/datum/integrated_io/input/I in inputs)
			I.name = "[input_names[i]]"
			i++
	i = 1
	if(output_names.len)
		for(var/datum/integrated_io/output/O in outputs)
			O.name = "[output_names[i]]"
			i++

	i = 1
	if(activator_names.len)
		for(var/datum/integrated_io/activate/A in outputs)
			A.name = "[activator_names[i]]"
			i++

/obj/item/integrated_circuit/Destroy()
	for(var/datum/integrated_io/I in inputs)
		qdel(I)
	for(var/datum/integrated_io/O in outputs)
		qdel(O)
	for(var/datum/integrated_io/A in activators)
		qdel(A)
	..()

/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr

	var/input = sanitizeSafe(input("What do you want to name the circuit?", ,""), MAX_NAME_LEN)

	if(src && input)
		M << "<span class='notice'>The circuit '[src.name]' is now labeled '[input]'.</span>"
		name = input

/datum/integrated_io
	var/name = "input/output"
	var/obj/item/integrated_circuit/holder = null
	var/data = null
//	var/datum/integrated_io/linked = null
	var/list/linked = list()
	var/io_type = DATA_CHANNEL

/datum/integrated_io/New(var/newloc)
	..()
	holder = newloc
	if(!holder)
		message_admins("ERROR: An integrated_io ([src.name]) spawned without a holder!  This is a bug.")

/datum/integrated_io/Destroy()
	disconnect()
	holder = null
	..()

/datum/integrated_io/proc/push_data()
	if(linked.len)
		for(var/datum/integrated_io/io in linked)
			io.data = data

/datum/integrated_io/activate/push_data()
	if(linked.len)
		for(var/datum/integrated_io/io in linked)
			io.holder.work()

/datum/integrated_io/proc/pull_data()
	if(linked.len)
		for(var/datum/integrated_io/io in linked)
			data = io.data

/datum/integrated_io/proc/get_linked_to_desc()
	if(linked.len)
		var/result = english_list(linked)
		return "the [result]"
	return "nothing"

/datum/integrated_io/proc/disconnect()
	if(linked.len)
		//First we iterate over everything we are linked to.
		for(var/datum/integrated_io/their_io in linked)
			//While doing that, we iterate them as well, and disconnect ourselves from them.
			for(var/datum/integrated_io/their_linked_io in their_io.linked)
				if(their_linked_io == src)
					their_io.linked.Remove(src)
				else
					continue
			//Now that we're removed from them, we gotta remove them from us.
			src.linked.Remove(their_io)

/datum/integrated_io/input
	name = "input pin"

/datum/integrated_io/output
	name = "output pin"

/datum/integrated_io/activate
	name = "activation pin"
	io_type = PULSE_CHANNEL

/obj/item/integrated_circuit/proc/push_data()
	for(var/datum/integrated_io/output/O in outputs)
		O.push_data()

/obj/item/integrated_circuit/proc/pull_data()
	for(var/datum/integrated_io/input/I in inputs)
		I.push_data()

/obj/item/integrated_circuit/proc/work()
	last_used = world.time
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	for(var/datum/integrated_io/input/I in inputs)
		I.disconnect()
	for(var/datum/integrated_io/output/O in outputs)
		O.disconnect()
	for(var/datum/integrated_io/activate/A in activators)
		A.disconnect()