/obj/item/integrated_circuit/input/proc/ask_for_input(mob/user)
	return

/obj/item/integrated_circuit/input/button
	name = "button"
	desc = "This tiny button must do something, right?"
	icon_state = "button"
	number_of_inputs = 0
	number_of_outputs = 0
	number_of_activators = 1
	complexity = 1
	activator_names = list(
		"on pressed"
	)

/obj/item/integrated_circuit/input/button/ask_for_input(mob/user) //Bit misleading name for this specific use.
	var/datum/integrated_io/A = activators[1]
	if(A.linked.len)
		for(var/datum/integrated_io/activate/target in A.linked)
			target.holder.work()
	user << "<span class='notice'>You press the button labeled '[src.name]'.</span>"

/obj/item/integrated_circuit/input/numberpad
	name = "number pad"
	desc = "This small number pad allows someone to input a number into the system."
	icon_state = "numberpad"
	number_of_inputs = 0
	number_of_outputs = 1
	number_of_activators = 1
	complexity = 2
	output_names = list(
		"number entered"
	)
	activator_names = list(
		"on entered"
	)

/obj/item/integrated_circuit/input/numberpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter a number, please.","Number pad") as num
	if(new_input && isnum(new_input))
		var/datum/integrated_io/O = outputs[1]
		O.data = new_input
		O.push_data()
		var/datum/integrated_io/A = activators[1]
		if(A.linked)
			A.holder.work()

/obj/item/integrated_circuit/output/screen
	name = "screen"
	desc = "This small screen can display a single piece of data, when the machine is examined closely."
	icon_state = "screen"
	complexity = 4
	number_of_inputs = 1
	number_of_outputs = 0
	number_of_activators = 1
	input_names = list(
		"displayed data"
	)
	activator_names = list(
		"load data"
	)
	var/stuff_to_display = null

/obj/item/integrated_circuit/output/screen/work()
	var/datum/integrated_io/I = inputs[1]
	stuff_to_display = I.data