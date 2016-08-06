//These circuits convert one variable to another.
/obj/item/integrated_circuit/converter
	complexity = 2
	number_of_inputs = 1
	number_of_outputs = 1
	number_of_activators = 1
	input_names = list(
		"input",
		)
	output_names = list(
		"result"
	)
	activator_names = list(
		"convert"
	)

/obj/item/integrated_circuit/converter/num2text
	name = "number to string"
	desc = "This circuit can convert a number variable into a string."
	icon_state = "addition"

/obj/item/integrated_circuit/converter/num2text/work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && isnum(incoming.data))
		result = num2text(incoming.data)

	outgoing.data = result
	outgoing.push_data()

	..()

/obj/item/integrated_circuit/converter/text2num
	name = "number to string"
	desc = "This circuit can convert a string variable into a number."
	icon_state = "addition"

/obj/item/integrated_circuit/converter/text2num/work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && istext(incoming.data))
		result = text2num(incoming.data)

	outgoing.data = result
	outgoing.push_data()

	..()

/obj/item/integrated_circuit/converter/ref2text
	name = "reference to string"
	desc = "This circuit can convert a reference to something else to a string, specifically the name of that reference."
	icon_state = "addition"

/obj/item/integrated_circuit/converter/ref2text/work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && istype(incoming.data, /atom/))
		var/atom/A = incoming.data
		result = A.name

	outgoing.data = result
	outgoing.push_data()

	..()

/obj/item/integrated_circuit/converter/lowercase
	name = "lowercase string converter"
	desc = "this will cause a string to come out in all lowercase."
	icon_state = "addition"

/obj/item/integrated_circuit/converter/lowercase/work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && istext(incoming.data))
		result = lowertext(incoming.data)

	outgoing.data = result
	outgoing.push_data()

	..()

/obj/item/integrated_circuit/converter/uppercase
	name = "uppercase string converter"
	desc = "THIS WILL CAUSE A STRING TO COME OUT IN ALL UPPERCASE."
	icon_state = "addition"

/obj/item/integrated_circuit/converter/uppercase/work()
	var/result = null
	var/datum/integrated_io/incoming = inputs[1]
	var/datum/integrated_io/outgoing = outputs[1]
	if(incoming.data && istext(incoming.data))
		result = uppertext(incoming.data)

	outgoing.data = result
	outgoing.push_data()

	..()