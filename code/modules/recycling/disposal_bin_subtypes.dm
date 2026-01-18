// Cleaner subtype
/obj/machinery/disposal/cleaner
	name = "resleeving equipment deposit"
	desc = "Automatically cleans and transports items to the local resleeving facilities."
	icon_state = "blue"

/obj/machinery/disposal/cleaner/flush()
	if(flushing)
		return
	clean_items()
	. = ..()

/obj/machinery/disposal/wall/cleaner
	name = "resleeving equipment deposit"
	desc = "Automatically cleans and transports items to the local resleeving facilities."
	icon_state = "bluewall"

/obj/machinery/disposal/wall/cleaner/flush()
	if(flushing)
		return
	clean_items()
	. = ..()

// Incin/space
/obj/machinery/disposal/burn_pit
	name = "disposal (hazardous)"
	desc = "A pneumatic waste disposal unit. This unit is either connected directly to the station's waste processor or dumped into space."
	icon_state = "red"

/obj/machinery/disposal/wall/burn_pit
	name = "disposal (hazardous)"
	desc = "A pneumatic waste disposal unit. This unit is either connected directly to the station's waste processor or dumped into space."
	icon_state = "redwall"

// Amnesty box
/obj/machinery/disposal/turn_in
	name = "amnesty bin"
	desc = "A pneumatic waste disposal unit. A place to legally turn in contraban to security."
	icon_state = "green"

/obj/machinery/disposal/wall/turn_in
	name = "amnesty bin"
	desc = "A pneumatic waste disposal unit. A place to legally turn in contraban to security."
	icon_state = "greenwall"

// Gets mail
/obj/machinery/disposal/mail_reciever
	name = "disposal mail destination"
	desc = "A pneumatic waste disposal unit. This unit is marked for receiving mail."
	icon_state = "white"

/obj/machinery/disposal/wall/mail_reciever
	name = "disposal mail destination"
	desc = "A pneumatic waste disposal unit. This unit is marked for receiving mail."
	icon_state = "whitewall"
