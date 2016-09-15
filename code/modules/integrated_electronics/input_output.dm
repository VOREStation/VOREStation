/obj/item/integrated_circuit/input
	var/can_be_asked_input = 0

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
	can_be_asked_input = 1
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
	can_be_asked_input = 1
	output_names = list(
		"number entered"
	)
	activator_names = list(
		"on entered"
	)

/obj/item/integrated_circuit/input/numberpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter a number, please.","Number pad") as num
	if(isnum(new_input))
		var/datum/integrated_io/O = outputs[1]
		O.data = new_input
		O.push_data()
		var/datum/integrated_io/A = activators[1]
		if(A.linked)
			A.holder.work()

/obj/item/integrated_circuit/input/textpad
	name = "text pad"
	desc = "This small text pad allows someone to input a string into the system."
	icon_state = "numberpad"
	number_of_inputs = 0
	number_of_outputs = 1
	number_of_activators = 1
	complexity = 2
	can_be_asked_input = 1
	output_names = list(
		"string entered"
	)
	activator_names = list(
		"on entered"
	)

/obj/item/integrated_circuit/input/textpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter some words, please.","Number pad") as text
	if(new_input && istext(new_input))
		var/datum/integrated_io/O = outputs[1]
		O.data = new_input
		O.push_data()
		var/datum/integrated_io/A = activators[1]
		if(A.linked)
			A.holder.work()

/obj/item/integrated_circuit/input/med_scanner
	name = "integrated medical analyser"
	desc = "A very small version of the common medical analyser.  This allows the machine to know how healthy someone is."
	number_of_inputs = 1
	number_of_outputs = 2
	number_of_activators = 1
	complexity = 4
	input_names = list(
		"target ref"
	)
	output_names = list(
		"total health %",
		"total missing health"
	)
	activator_names = list(
		"scan"
	)

/obj/item/integrated_circuit/input/med_scanner/work()
	if(..())
		var/datum/integrated_io/I = inputs[1]
		if(!I.data || !ishuman(I.data)) //Invalid input
			return
		var/mob/living/carbon/human/H = I.data
		if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
			var/total_health = round(H.health/H.maxHealth)*100
			var/missing_health = H.maxHealth - H.health

			var/datum/integrated_io/total = outputs[1]
			var/datum/integrated_io/missing = outputs[2]

			total.data = total_health
			missing.data = missing_health

		for(var/datum/integrated_io/output/O in outputs)
			O.push_data()

/obj/item/integrated_circuit/input/adv_med_scanner
	name = "integrated advanced medical analyser"
	desc = "A very small version of the common medical analyser.  This allows the machine to know how healthy someone is.  \
	This type is much more precise, allowing the machine to know much more about the target than a normal analyzer."
	number_of_inputs = 1
	number_of_outputs = 7
	number_of_activators = 1
	complexity = 12
	input_names = list(
		"target ref"
	)
	output_names = list(
		"total health %",
		"total missing health",
		"brute damage",
		"burn damage",
		"tox damage",
		"oxy damage",
		"clone damage"
	)
	activator_names = list(
		"scan"
	)

/obj/item/integrated_circuit/input/adv_med_scanner/work()
	if(..())
		var/datum/integrated_io/I = inputs[1]
		if(!I.data || !ishuman(I.data)) //Invalid input
			return
		var/mob/living/carbon/human/H = I.data
		if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
			var/total_health = round(H.health/H.maxHealth)*100
			var/missing_health = H.maxHealth - H.health

			var/datum/integrated_io/total = outputs[1]
			var/datum/integrated_io/missing = outputs[2]
			var/datum/integrated_io/brute = outputs[3]
			var/datum/integrated_io/burn = outputs[4]
			var/datum/integrated_io/tox = outputs[5]
			var/datum/integrated_io/oxy = outputs[6]
			var/datum/integrated_io/clone = outputs[7]

			total.data = total_health
			missing.data = missing_health
			brute.data = H.getBruteLoss()
			burn.data = H.getFireLoss()
			tox.data = H.getToxLoss()
			oxy.data = H.getOxyLoss()
			clone.data = H.getCloneLoss()

		for(var/datum/integrated_io/output/O in outputs)
			O.push_data()

/obj/item/integrated_circuit/input/local_locator
	name = "local locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon.  This type only locates something \
	that is holding the machine containing it."
	number_of_inputs = 0
	number_of_outputs = 1
	number_of_activators = 1
	complexity = 4
	output_names = list(
		"located ref"
	)
	activator_names = list(
		"locate"
	)

/obj/item/integrated_circuit/input/local_locator/work()
	if(..())
		var/mob/living/L = null
		var/datum/integrated_io/O = outputs[1]
		O.data = null
		if(istype(src.loc, /obj/item/device/electronic_assembly)) // Check to make sure we're actually in a machine.
			var/obj/item/device/electronic_assembly/assembly = src.loc
			if(istype(assembly.loc, /mob/living)) // Now check if someone's holding us.
				L = assembly.loc

		if(L)
			O.data = L

		O.push_data()


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