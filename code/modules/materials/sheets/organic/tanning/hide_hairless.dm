//Step two - washing..... it's actually in washing machine code, and ere.

/obj/item/stack/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	description_info = "Get it <b><font color='blue'>wet</font></b> to continue tanning this into leather.<br>\
					You could set it in a river, wash it with a sink, or just splash water on it with a bucket."
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"
	no_variants = FALSE
	max_amount = 20
	stacktype = "hairlesshide"

/obj/item/stack/hairlesshide/examine(var/mob/user)
	. = ..()
	. += description_info

/obj/item/stack/hairlesshide/water_act(var/wateramount)
	. = ..()
	wateramount = min(amount, round(wateramount))
	for(var/i in 1 to wateramount)
		var/obj/item/stack/wetleather/H = null
		for(var/obj/item/stack/wetleather/HS in get_turf(src)) // Doesn't have a user, can't just use their loc
			if(HS.get_amount() < HS.max_amount)
				H = HS
				break
			
		 // Either we found a valid stack, in which case increment amount,
		 // Or we need to make a new stack
		if(istype(H))
			H.add(1)
		else
			H = new /obj/item/stack/wetleather(get_turf(src))

		// Increment the amount
		src.use(1)

/obj/item/stack/hairlesshide/proc/rapidcure(var/stacknum = 1)
	stacknum = min(stacknum, amount)

	while(stacknum)
		var/obj/item/stack/wetleather/I = new /obj/item/stack/wetleather(get_turf(src))

		if(istype(I))
			I.dry()

		use(1)
		stacknum -= 1