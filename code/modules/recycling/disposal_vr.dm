/obj/machinery/disposal/wall/cleaner
	name = "resleeving equipment deposit"
	desc = "Automatically cleans and transports items to the local resleeving facilities."
	icon = 'icons/obj/pipes/disposal_vr.dmi'
	icon_state = "bluewall"

/obj/machinery/disposal/wall/cleaner/flush()
	flick("[icon_state]-flush", src)
	for(var/obj/item/i in src)
		if(istype(i, /obj/item))
			i.decontaminate()
	. = ..()