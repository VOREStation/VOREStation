/obj/item/device/integrated_electronics/debugger
	name = "debugger"
	desc = "This can be used to learn about, test, or find issues with your circuit designs."
	icon_state = "multitool"
	flags = CONDUCT
	w_class = 2
	var/datum/integrated_io/probe
	var/mode = "string"
	var/options = list("string", "number", "reference", "type", "null")

/obj/item/device/integrated_electronics/debugger/New()
	..()
	probe = new(src)

/obj/item/device/integrated_electronics/debugger/attack_self(mob/user)
	var/temporary_data = null
	var/choice = input(user, "Please select a data type to use as input.", "data type", "string") as null|anything in options
	if(choice)
		switch(choice)
			if("string")
				temporary_data = sanitize(input(user, "Please write something in text.", "string input") as null|text)
				if(istext(temporary_data))
					probe.data = temporary_data
			if("number")
				temporary_data = sanitize(input(user, "Please a number.", "number input") as null|num)
				if(isnum(temporary_data))
					probe.data = temporary_data
			if("reference")
				return
			if("type")
				return
			if("null")
				probe.data = null

/obj/item/device/integrated_electronics/proc/select_io(mob/user, var/obj/target)
	var/obj/item/integrated_circuit/selected_circuit = null
	if(!istype(/obj/item/integrated_circuit, target))
		var/list/possible_circuits = list()
		for(var/obj/item/integrated_circuit/IC in target)
			possible_circuits.Add(IC)
		if(possible_circuits.len)
			selected_circuit = input(user, "Choose the circuit you want to work on.", "Circuit Selection") as null|anything in possible_circuits
	else if(istype(/obj/item/integrated_circuit, target))
		selected_circuit = target

	if(selected_circuit)
		var/list/possible_io = list()
		for(var/datum/integrated_io/I in selected_circuit.inputs)
			possible_io.Add(I)
		for(var/datum/integrated_io/O in selected_circuit.outputs)
			possible_io.Add(O)
		for(var/datum/integrated_io/A in selected_circuit.activators)
			possible_io.Add(A)
		if(possible_io.len)
			var/choice = input(user, "Choose the data channel you wish to select.", "Data Selection Selection") as null|anything in possible_io
			if(choice)
				return choice

#define WIRE		"wire"
#define WIRING		"wiring"
#define UNWIRE		"unwire"
#define UNWIRING	"unwiring"


/obj/item/device/integrated_electronics/wirer
	name = "data wirer"
	desc = "Used to connect various inputs and outputs together."
	icon_state = "multitool"
	flags = CONDUCT
	w_class = 2
	var/datum/integrated_io/selected_io = null
	var/mode = WIRE

/obj/item/device/integrated_electronics/wirer/New()
	..()

/obj/item/device/integrated_electronics/wirer/afterattack(atom/target, mob/user)
	if(isobj(target))
		if(mode == WIRE)
			selected_io = select_io(user, target)
			if(!selected_io)
				return
			user << "<span class='notice'>You attach a data wire to \the [target]'s [selected_io.name] data channel.</span>"
			mode = WIRING
			return

		else if(mode == WIRING)
			var/datum/integrated_io/second_io = select_io(user, target)
			if(selected_io == second_io)
				user << "<span class='warning'>Wiring \the [target]'s [selected_io.name] into itself is rather pointless.<span>"
				return
			else if(second_io)
				if(second_io.io_type != selected_io.io_type)
					user << "<span class='warning'>Those two types of channels are incompatable.  The first is a [selected_io.io_type], \
					while the second is a [second_io.io_type].<span>"
					return

				selected_io.linked |= second_io
				second_io.linked |= selected_io

//				selected_io.linked = second_io
//				second_io.linked = selected_io
				user << "<span class='notice'>You connect \the [selected_io.holder]'s [selected_io.name] to \the [target]'s [second_io.name].</span>"
				mode = WIRE
				selected_io = null
		else if(mode == UNWIRE)
			selected_io = select_io(user, target)
			if(!selected_io)
				return
			if(!selected_io.linked.len)
				user << "<span class='warning'>There is nothing connected to \the [selected_io] data channel.</span>"
				return
			user << "<span class='notice'>You prepare to detach a data wire from \the [target]'s [selected_io.name] data channel.</span>"
			mode = UNWIRING
			return

		else if(mode == UNWIRING)
			var/datum/integrated_io/second_io = select_io(user, target)
			if(selected_io == second_io)
				user << "<span class='warning'>You can't wire a pin into each other, so unwiring \the [selected_io.holder] from \
				the same pin is rather moot.<span>"
				return
			else if(second_io)
				if(selected_io in second_io.linked)
					second_io.linked.Remove(selected_io)
					selected_io.linked.Remove(second_io)
					user << "<span class='notice'>You disconnect \the [selected_io.holder]'s [selected_io.name] from \
					\the [second_io.holder]'s [second_io.name].</span>"
				else
					user << "<span class='warning'>\The [selected_io.holder]'s [selected_io.name] and \the [second_io.holder]'s \
					[second_io.name] are not connected.<span>"
					return
/*
				var/datum/integrated_io/third_io = select_io(user, second_io.linked)
				if(third_io && selected_io in third_io.linked)
					third_io.linked.Remove(selected_io)
					selected_io.linked.Remove(second_io)
*/
				mode = UNWIRE
			return
/*
			var/datum/integrated_io/target_io = select_io(user, target)
			if(target_io && target_io.linked)
				user << "<span class='notice'>You disconnect \the [target_io.holder]'s [target_io.name] \
				from \the [target_io.linked.holder]'s [target_io.linked.linked].<span>"
				if(target_io.linked.linked && target_io.linked.linked == target_io)
					target_io.linked.linked = null
				target_io.linked = null
*/
/obj/item/device/integrated_electronics/wirer/attack_self(mob/user)
	switch(mode)
		if(WIRE)
			mode = UNWIRE
		if(WIRING)
			if(selected_io)
				user << "<span class='notice'>You decide not to wire the data channel.</span>"
			selected_io = null
			mode = UNWIRE
		if(UNWIRE)
			mode = WIRE
	user << "<span class='notice'>You set \the [src] to [mode].<span>"

#undef WIRE
#undef WIRING
#undef UNWIRE
#undef UNWIRING

/obj/item/weapon/storage/bag/circuits
	name = "circuit satchel"
	desc = "This bag's essential for any circuitry projects."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = 2
	storage_slots = 200
	max_storage_space = 400
	max_w_class = 3
	display_contents_with_number = 1
	can_hold = list(/obj/item/integrated_circuit)

/obj/item/weapon/storage/bag/circuits/pre_filled/New()
	..()
	var/i = 10
	while(i)
		new /obj/item/integrated_circuit/arithmetic/addition(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/arithmetic/subtraction(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/arithmetic/multiplication(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/arithmetic/division(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/arithmetic/absolute(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/arithmetic/average(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/logic/equals(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/logic/less_than(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/logic/less_than_or_equal(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/logic/greater_than(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/logic/greater_than_or_equal(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/logic/not(src)
		i--
	i = 10
	while(i)
		new /obj/item/integrated_circuit/memory(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/memory/medium(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/memory/large(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/memory/huge(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/input/numberpad(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/input/button(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/output/screen(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/transfer/splitter(src)
		i--
	i = 5
	while(i)
		new /obj/item/integrated_circuit/transfer/activator_splitter(src)
		i--
	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/integrated_electronics/wirer(src)