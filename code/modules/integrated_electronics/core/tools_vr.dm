/obj/item/device/multitool/wire(datum/integrated_io/io, mob/user)
	..()
	if(io.holder.record_editors)
		io.holder.last_editor = user
		if(!(user in io.holder.all_editors))
			io.holder.all_editors += user

/obj/item/device/integrated_electronics/wirer/wire(datum/integrated_io/io, mob/user)
	..()
	if(io.holder.record_editors)
		io.holder.last_editor = user
		if(!(user in io.holder.all_editors))
			io.holder.all_editors += user

/obj/item/device/integrated_electronics/debugger/write_data(datum/integrated_io/io, mob/user)
	..()
	if(io.holder.record_editors)
		io.holder.last_editor = user
		if(!(user in io.holder.all_editors))
			io.holder.all_editors += user