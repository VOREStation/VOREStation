//These circuits do not-so-simple math.
/obj/item/integrated_circuit/trig
	complexity = 1
	inputs = list("A","B","C","D","E","F","G","H")
	outputs = list("result")
	activators = list("compute")
	category_text = "Trig"
	extended_desc = "Input and output are in degrees."
	autopulse = 1
	power_draw_per_use = 1 // Still cheap math.

/obj/item/integrated_circuit/trig/on_data_written()
	if(autopulse == 1)
		check_then_do_work()

// Sine //

/obj/item/integrated_circuit/trig/sine
	name = "sin circuit"
	desc = "Has nothing to do with evil, unless you consider trigonometry to be evil.  Outputs the sine of A."
	icon_state = "sine"
	inputs = list("A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/sine/do_work()
	var/result = null
	var/datum/integrated_io/input/A = inputs[1]
	A.pull_data()
	if(isnum(A.data))
		result = sin(A.data)

	var/datum/integrated_io/output/O = outputs[1]
	O.data = result
	O.push_data()

// Cosine //

/obj/item/integrated_circuit/trig/cosine
	name = "cos circuit"
	desc = "Outputs the cosine of A."
	icon_state = "cosine"
	inputs = list("A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cosine/do_work()
	var/result = null
	var/datum/integrated_io/input/A = inputs[1]
	A.pull_data()
	if(isnum(A.data))
		result = cos(A.data)

	var/datum/integrated_io/output/O = outputs[1]
	O.data = result
	O.push_data()

// Tangent //

/obj/item/integrated_circuit/trig/tangent
	name = "tan circuit"
	desc = "Outputs the tangent of A.  Guaranteed to not go on a tangent about its existance."
	icon_state = "tangent"
	inputs = list("A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/tangent/do_work()
	var/result = null
	var/datum/integrated_io/input/A = inputs[1]
	A.pull_data()
	if(isnum(A.data))
		result = Tan(A.data)

	var/datum/integrated_io/output/O = outputs[1]
	O.data = result
	O.push_data()

// Cosecant //

/obj/item/integrated_circuit/trig/cosecant
	name = "csc circuit"
	desc = "Outputs the cosecant of A."
	icon_state = "cosecant"
	inputs = list("A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cosecant/do_work()
	var/result = null
	var/datum/integrated_io/input/A = inputs[1]
	A.pull_data()
	if(isnum(A.data))
		result = Csc(A.data)

	var/datum/integrated_io/output/O = outputs[1]
	O.data = result
	O.push_data()


// Secant //

/obj/item/integrated_circuit/trig/secant
	name = "sec circuit"
	desc = "Outputs the secant of A.  Has nothing to do with the security department."
	icon_state = "secant"
	inputs = list("A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/secant/do_work()
	var/result = null
	var/datum/integrated_io/input/A = inputs[1]
	A.pull_data()
	if(isnum(A.data))
		result = Sec(A.data)

	var/datum/integrated_io/output/O = outputs[1]
	O.data = result
	O.push_data()


// Cotangent //

/obj/item/integrated_circuit/trig/cotangent
	name = "cot circuit"
	desc = "Outputs the cotangent of A."
	icon_state = "cotangent"
	inputs = list("A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cotangent/do_work()
	var/result = null
	var/datum/integrated_io/input/A = inputs[1]
	A.pull_data()
	if(isnum(A.data))
		result = Cot(A.data)

	var/datum/integrated_io/output/O = outputs[1]
	O.data = result
	O.push_data()