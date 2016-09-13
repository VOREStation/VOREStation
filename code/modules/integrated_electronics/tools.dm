#define WIRE		"wire"
#define WIRING		"wiring"
#define UNWIRE		"unwire"
#define UNWIRING	"unwiring"


/obj/item/device/integrated_electronics/wirer
	name = "circuit wirer"
	desc = "It's a small wiring tool, with a wire roll, electric soldering iron, wire cutter, and more in one package. \
	The wires used are generally useful for small electronics, such as circuitboards and breadboards, as opposed to larger wires \
	used for power or data transmission."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	flags = CONDUCT
	w_class = 2
	var/datum/integrated_io/selected_io = null
	var/mode = WIRE

/obj/item/device/integrated_electronics/wirer/New()
	..()

/obj/item/device/integrated_electronics/wirer/proc/wire(var/datum/integrated_io/io, mob/user)
	if(mode == WIRE)
		selected_io = io
		user << "<span class='notice'>You attach a data wire to \the [selected_io.holder]'s [selected_io.name] data channel.</span>"
		mode = WIRING
	else if(mode == WIRING)
		if(io == selected_io)
			user << "<span class='warning'>Wiring \the [selected_io.holder]'s [selected_io.name] into itself is rather pointless.<span>"
			return
		if(io.io_type != selected_io.io_type)
			user << "<span class='warning'>Those two types of channels are incompatable.  The first is a [selected_io.io_type], \
			while the second is a [io.io_type].<span>"
			return
		selected_io.linked |= io
		io.linked |= selected_io

		user << "<span class='notice'>You connect \the [selected_io.holder]'s [selected_io.name] to \the [io.holder]'s [io.name].</span>"
		mode = WIRE
		//io.updateDialog()
		//selected_io.updateDialog()
		selected_io.holder.interact(user) // This is to update the UI.
		selected_io = null

	else if(mode == UNWIRE)
		selected_io = io
		if(!io.linked.len)
			user << "<span class='warning'>There is nothing connected to \the [selected_io] data channel.</span>"
			selected_io = null
			return
		user << "<span class='notice'>You prepare to detach a data wire from \the [selected_io.holder]'s [selected_io.name] data channel.</span>"
		mode = UNWIRING
		return

	else if(mode == UNWIRING)
		if(io == selected_io)
			user << "<span class='warning'>You can't wire a pin into each other, so unwiring \the [selected_io.holder] from \
			the same pin is rather moot.<span>"
			return
		if(selected_io in io.linked)
			io.linked.Remove(selected_io)
			selected_io.linked.Remove(io)
			user << "<span class='notice'>You disconnect \the [selected_io.holder]'s [selected_io.name] from \
			\the [io.holder]'s [io.name].</span>"
			//io.updateDialog()
			//selected_io.updateDialog()
			selected_io.holder.interact(user) // This is to update the UI.
			selected_io = null
			mode = UNWIRE
		else
			user << "<span class='warning'>\The [selected_io.holder]'s [selected_io.name] and \the [io.holder]'s \
			[io.name] are not connected.<span>"
			return
	return

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
		if(UNWIRING)
			if(selected_io)
				user << "<span class='notice'>You decide not to disconnect the data channel.</span>"
			selected_io = null
			mode = UNWIRE
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