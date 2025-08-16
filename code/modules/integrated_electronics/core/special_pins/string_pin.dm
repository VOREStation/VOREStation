// These pins can only contain text and null.
/datum/integrated_io/string
	name = "string pin"

/datum/integrated_io/string/ask_for_pin_data(mob/user)
	var/new_data = tgui_input_text(user, "Please type in a string.","[src] string writing")
	new_data = sanitizeSafe(new_data, MAX_MESSAGE_LEN, 0, 0)

	if(new_data && holder.check_interactivity(user) )
		to_chat(user, span_notice("You input [new_data ? "new_data" : "NULL"] into the pin."))
		write_data_to_pin(new_data)

/datum/integrated_io/string/write_data_to_pin(var/new_data)
	new_data = sanitizeSafe(new_data, MAX_MESSAGE_LEN, 0, 0)
	if(isnull(new_data) || istext(new_data))
		data = new_data
		holder.on_data_written()

// This makes the text go "from this" to "#G&*!HD$%L"
/datum/integrated_io/string/scramble()
	if(!is_valid())
		return
	var/string_length = length(data)
	var/list/options = list("!","@","#","$","%","^","&","*") + GLOB.alphabet_upper
	var/new_data = ""
	while(string_length)
		new_data += pick(options)
		string_length--
	push_data()

/datum/integrated_io/string/display_pin_type()
	return IC_FORMAT_STRING
