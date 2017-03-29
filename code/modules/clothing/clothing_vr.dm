//This is a crazy 'sideways' override.
/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/weapon/holder/micro))
		var/full = 0
		for(var/mob/M in src)
			full++
		if(full >= 2)
			to_chat(user,"<span class='warning'>You can't fit anyone else into \the [src]!</span>")
		else
			var/obj/item/weapon/holder/micro/holder = I
			if(holder.held_mob && holder.held_mob in holder)
				to_chat(holder.held_mob,"<span class='warning'>[user] stuffs you into \the [src]!</span>")
				holder.held_mob.forceMove(src)
				to_chat(user,"<span class='notice'>You stuff \the [holder.held_mob] into \the [src]!</span>")
	else
		..()

/obj/item/clothing/shoes/attack_self(var/mob/user)
	for(var/mob/M in src)
		M.forceMove(get_turf(user))
		to_chat(M,"<span class='warning'>[user] shakes you out of \the [src]!</span>")
		to_chat(user,"<span class='notice'>You shake [M] out of \the [src]!</span>")

	..()
