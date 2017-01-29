/obj/item/integrated_circuit/transfer
	category_text = "Data Transfer"
	autopulse = 1

/obj/item/integrated_circuit/transfer/on_data_written()
	if(autopulse == 1)
		check_then_do_work()

/obj/item/integrated_circuit/transfer/splitter
	name = "splitter"
	desc = "Splits incoming data into all of the output pins."
	icon_state = "splitter"
	complexity = 3
	inputs = list("data to split")
	outputs = list("A","B")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/transfer/splitter/medium
	name = "four splitter"
	icon_state = "splitter4"
	complexity = 5
	outputs = list("A","B","C","D")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/transfer/splitter/large
	name = "eight splitter"
	icon_state = "splitter8"
	complexity = 9
	outputs = list("A","B","C","D","E","F","G","H")
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/transfer/splitter/do_work()
	var/datum/integrated_io/I = inputs[1]
	for(var/datum/integrated_io/output/O in outputs)
		O.data = I.data

/obj/item/integrated_circuit/transfer/activator_splitter
	name = "activator splitter"
	desc = "Splits incoming activation pulses into all of the output pins."
	icon_state = "splitter"
	complexity = 3
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B"
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/transfer/activator_splitter/do_work()
	for(var/datum/integrated_io/activate/A in outputs)
		if(A == activators[1])
			continue
		if(A.linked.len)
			for(var/datum/integrated_io/activate/target in A.linked)
				target.holder.check_then_do_work()

/obj/item/integrated_circuit/transfer/activator_splitter/medium
	name = "four activator splitter"
	icon_state = "splitter4"
	complexity = 5
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B",
		"outgoing pulse C",
		"outgoing pulse D"
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/transfer/activator_splitter/large
	name = "eight activator splitter"
	icon_state = "splitter4"
	complexity = 9
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B",
		"outgoing pulse C",
		"outgoing pulse D",
		"outgoing pulse E",
		"outgoing pulse F",
		"outgoing pulse G",
		"outgoing pulse H"
		)
	spawn_flags = IC_SPAWN_RESEARCH