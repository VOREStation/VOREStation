// These pins only contain weakrefs or null.
/datum/integrated_io/ref
	name = "ref pin"

/datum/integrated_io/ref/ask_for_pin_data(mob/user, obj/item/I)
    if(istype(I, /obj/item/device/multitool))
        var/obj/item/device/multitool/tool = I
        write_data_to_pin(tool.weakref_wiring)
    else if(istype(I, /obj/item/device/integrated_electronics/debugger))
        var/obj/item/device/integrated_electronics/debugger/tool = I
        write_data_to_pin(tool.data_to_write)
    else
        write_data_to_pin(null)

/datum/integrated_io/ref/write_data_to_pin(var/new_data)
	if(isnull(new_data) || isweakref(new_data))
		data = new_data
		holder.on_data_written()

/datum/integrated_io/ref/display_pin_type()
	return IC_FORMAT_REF
