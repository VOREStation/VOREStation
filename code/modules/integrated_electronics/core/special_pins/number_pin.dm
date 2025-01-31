// These pins can only contain numbers (int and floating point) or null.
/datum/integrated_io/number
	name = "number pin"
//	data = 0

/datum/integrated_io/number/ask_for_pin_data(mob/user)
	var/new_data = tgui_input_number(user, "Please type in a number.","[src] number writing")
	if(isnum(new_data) && holder.check_interactivity(user) )
		to_chat(user, span_notice("You input [new_data] into the pin."))
		write_data_to_pin(new_data)

/datum/integrated_io/number/write_data_to_pin(var/new_data)
	if(isnull(new_data) || isnum(new_data))
		data = new_data
		holder.on_data_written()

/datum/integrated_io/number/display_pin_type()
	return IC_FORMAT_NUMBER
