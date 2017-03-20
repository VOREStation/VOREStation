//These circuits convert one variable to another.
/obj/item/integrated_circuit/converter
	complexity = 2
	inputs = list("input")
	outputs = list("output")
	activators = list("convert")
	category_text = "Converter"
	autopulse = 1
	power_draw_per_use = 10

/obj/item/integrated_circuit/converter/on_data_written()
	if(autopulse == 1)
		check_then_do_work()

/obj/item/integrated_circuit/converter/num2text
	name = "number to string"
	desc = "This circuit can convert a number variable into a string."
	icon_state = "num-string"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/num2text/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && isnum(incoming.data))
		result = num2text(incoming.data)

	outgoing.data = result
	outgoing.push_data()

/obj/item/integrated_circuit/converter/text2num
	name = "string to number"
	desc = "This circuit can convert a string variable into a number."
	icon_state = "string-num"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/text2num/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && istext(incoming.data))
		result = text2num(incoming.data)

	outgoing.data = result
	outgoing.push_data()

/obj/item/integrated_circuit/converter/ref2text
	name = "reference to string"
	desc = "This circuit can convert a reference to something else to a string, specifically the name of that reference."
	icon_state = "ref-string"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/ref2text/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	var/atom/A = incoming.data_as_type(/atom)
	result = A && A.name

	outgoing.data = result
	outgoing.push_data()

/obj/item/integrated_circuit/converter/lowercase
	name = "lowercase string converter"
	desc = "this will cause a string to come out in all lowercase."
	icon_state = "lowercase"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/lowercase/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && istext(incoming.data))
		result = lowertext(incoming.data)

	outgoing.data = result
	outgoing.push_data()

/obj/item/integrated_circuit/converter/uppercase
	name = "uppercase string converter"
	desc = "THIS WILL CAUSE A STRING TO COME OUT IN ALL UPPERCASE."
	icon_state = "uppercase"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/uppercase/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && istext(incoming.data))
		result = uppertext(incoming.data)

	outgoing.data = result
	outgoing.push_data()

/obj/item/integrated_circuit/converter/concatenatior
	name = "concatenatior"
	desc = "This joins many strings together to get one big string."
	complexity = 4
	inputs = list("A","B","C","D","E","F","G","H")
	outputs = list("result")
	activators = list("concatenate")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/concatenatior/do_work()
	var/result = null
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(istext(I.data))
			result = result + I.data

	var/datum/integrated_io/outgoing = outputs[1]
	outgoing.data = result
	outgoing.push_data()

/obj/item/integrated_circuit/converter/radians2degrees
	name = "radians to degrees converter"
	desc = "Converts radians to degrees."
	inputs = list("radian")
	outputs = list("degrees")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/radians2degrees/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	incoming.pull_data()
	if(incoming.data && isnum(incoming.data))
		result = ToDegrees(incoming.data)

	outgoing.data = result
	outgoing.push_data()

/obj/item/integrated_circuit/converter/degrees2radians
	name = "degrees to radians converter"
	desc = "Converts degrees to radians."
	inputs = list("degrees")
	outputs = list("radians")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/degrees2radians/do_work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	incoming.pull_data()
	if(incoming.data && isnum(incoming.data))
		result = ToRadians(incoming.data)

	outgoing.data = result
	outgoing.push_data()


/obj/item/integrated_circuit/converter/abs_to_rel_coords
	name = "abs to rel coordinate converter"
	desc = "Easily convert absolute coordinates to relative coordinates with this."
	complexity = 4
	inputs = list("X1 (abs)", "Y1 (abs)", "X2 (abs)", "Y2 (abs)")
	outputs = list("X (rel)", "Y (rel)")
	activators = list("compute rel coordinates")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/abs_to_rel_coords/do_work()
	var/datum/integrated_io/x1 = inputs[1]
	var/datum/integrated_io/y1 = inputs[2]

	var/datum/integrated_io/x2 = inputs[3]
	var/datum/integrated_io/y2 = inputs[4]

	var/datum/integrated_io/result_x = outputs[1]
	var/datum/integrated_io/result_y = outputs[2]

	if(x1.data && y1.data && x2.data && y2.data)
		result_x.data = x1.data - x2.data
		result_y.data = y1.data - y2.data

	for(var/datum/integrated_io/output/O in outputs)
		O.push_data()