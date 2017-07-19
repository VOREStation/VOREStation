//These circuits convert one variable to another.
/obj/item/integrated_circuit/converter
	complexity = 2
	inputs = list("input")
	outputs = list("output")
	activators = list("convert" = 1, "on convert" = 0)
	category_text = "Converter"
	autopulse = 1
	power_draw_per_use = 10

/obj/item/integrated_circuit/converter/on_data_written()
	if(autopulse == 1)
		check_then_do_work()

/obj/item/integrated_circuit/converter/num2text
	name = "number to string"
	desc = "This circuit can convert a number variable into a string."
	extended_desc = "Because of game limitations null/false variables will output a '0' string."
	icon_state = "num-string"
	inputs = list("\<NUM\> input")
	outputs = list("\<TEXT\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/num2text/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && isnum(incoming))
		result = num2text(incoming)
	else if(!incoming)
		result = "0"

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/text2num
	name = "string to number"
	desc = "This circuit can convert a string variable into a number."
	icon_state = "string-num"
	inputs = list("\<TEXT\> input")
	outputs = list("\<NUM\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/text2num/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && istext(incoming))
		result = text2num(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/ref2text
	name = "reference to string"
	desc = "This circuit can convert a reference to something else to a string, specifically the name of that reference."
	icon_state = "ref-string"
	inputs = list("\<REF\> input")
	outputs = list("\<TEXT\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/ref2text/do_work()
	var/result = null
	pull_data()
	var/atom/A = get_pin_data(IC_INPUT, 1)
	if(A && istype(A))
		result = A.name

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/lowercase
	name = "lowercase string converter"
	desc = "this will cause a string to come out in all lowercase."
	icon_state = "lowercase"
	inputs = list("\<TEXT\> input")
	outputs = list("\<TEXT\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/lowercase/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && istext(incoming))
		result = lowertext(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/uppercase
	name = "uppercase string converter"
	desc = "THIS WILL CAUSE A STRING TO COME OUT IN ALL UPPERCASE."
	icon_state = "uppercase"
	inputs = list("\<TEXT\> input")
	outputs = list("\<TEXT\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/uppercase/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && istext(incoming))
		result = uppertext(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/concatenator
	name = "concatenator"
	desc = "This joins many strings or numbers together to get one big string."
	complexity = 4
	inputs = list(
		"\<TEXT/NUM\> A",
		"\<TEXT/NUM\> B",
		"\<TEXT/NUM\> C",
		"\<TEXT/NUM\> D",
		"\<TEXT/NUM\> E",
		"\<TEXT/NUM\> F",
		"\<TEXT/NUM\> G",
		"\<TEXT/NUM\> H"
		)
	outputs = list("\<TEXT\> result")
	activators = list("concatenate" = 1, "on concatenated" = 0)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/concatenator/do_work()
	var/result = null
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(istext(I.data))
			result = result + I.data
		else if(!isnull(I.data) && num2text(I.data))
			result = result + num2text(I.data)

	var/datum/integrated_io/outgoing = outputs[1]
	outgoing.data = result
	outgoing.push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/separator
	name = "separator"
	desc = "This splits as single string into two at the relative split point."
	extended_desc = "This circuits splits a given string into two, based on the string, and the index value. \
	The index splits the string <b>after</b> the given index, including spaces. So 'a person' with an index of '3' \
	will split into 'a p' and 'erson'."
	complexity = 4
	inputs = list(
		"\<TEXT\> string",
		"\<NUM\> index",
		)
	outputs = list(
		"\<TEXT\> before split",
		"\<TEXT\> after split"
		)
	activators = list("separate" = 1, "on separated" = 0)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH


/obj/item/integrated_circuit/converter/separator/do_work()
	var/text = get_pin_data(IC_INPUT, 1)
	var/index = get_pin_data(IC_INPUT, 2)

	var/split = min(index+1, length(text))

	var/before_text = copytext(text, 1, split)
	var/after_text = copytext(text, split, 0)

	var/datum/integrated_io/outgoing1 = outputs[1]
	var/datum/integrated_io/outgoing2 = outputs[2]
	outgoing1.data = before_text
	outgoing2.data = after_text
	outgoing1.push_data()
	outgoing2.push_data()

	activate_pin(2)


/obj/item/integrated_circuit/converter/radians2degrees
	name = "radians to degrees converter"
	desc = "Converts radians to degrees."
	inputs = list("\<NUM\> radian")
	outputs = list("\<NUM\> degrees")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/radians2degrees/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && isnum(incoming))
		result = ToDegrees(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/degrees2radians
	name = "degrees to radians converter"
	desc = "Converts degrees to radians."
	inputs = list("\<NUM\> degrees")
	outputs = list("\<NUM\> radians")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/degrees2radians/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && isnum(incoming))
		result = ToRadians(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/converter/abs_to_rel_coords
	name = "abs to rel coordinate converter"
	desc = "Easily convert absolute coordinates to relative coordinates with this."
	complexity = 4
	inputs = list("\<NUM\> X1", "\<NUM\> Y1", "\<NUM\> X2", "\<NUM\> Y2")
	outputs = list("\<NUM\> X", "\<NUM\> Y")
	activators = list("compute rel coordinates" = 1, "on convert" = 0)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/abs_to_rel_coords/do_work()
	var/x1 = get_pin_data(IC_INPUT, 1)
	var/y1 = get_pin_data(IC_INPUT, 2)

	var/x2 = get_pin_data(IC_INPUT, 3)
	var/y2 = get_pin_data(IC_INPUT, 4)

	if(x1 && y1 && x2 && y2)
		set_pin_data(IC_OUTPUT, 1, x1 - x2)
		set_pin_data(IC_OUTPUT, 2, y1 - y2)

	push_data()
	activate_pin(2)