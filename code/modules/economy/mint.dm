/**********************Mint**************************/
/obj/machinery/mineral/mint
	name = "coin press"
	desc = "A relatively crude hand-operated coin press that turns sheets (or ingots, as the case may be) of materials into fresh coins. They're <i>probably</i> not going to be considered legal tender in most polities, but you might fool a vending machine with one..?"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"
	density = TRUE
	anchored = TRUE
	var/coinsToProduce = 6	//how many coins do we make per sheet? a sheet is 2000 units whilst a coin is 250, and some material should be lost in the process

/obj/machinery/mineral/mint/attackby(obj/item/stack/material/M, mob/user)
	if(!anchored)
		user.visible_message(span_warning("\The [src] must be properly secured to operate!"))
		return
	if(!M.coin_type)
		user.visible_message(span_notice("You can't make coins out of that."))
		return
	else if(M.coin_type)
		user.visible_message("[user] starts to feed a sheet of [M.default_type] into \the [src].")
		while(M.amount > 0)
			icon_state = "coinpress1"
			if(do_after(user, 2 SECONDS, src))
				M.amount--
				while(coinsToProduce-- > 0)
					new M.coin_type(user.loc)
				src.visible_message(span_notice("\The [src] rattles and dispenses several [M.default_type] coins!"))
				coinsToProduce = initial(coinsToProduce)
				if(M.amount == 0)
					icon_state = "coinpress0"
					qdel(M)	//clean it up just to be sure
					src.visible_message(span_notice("\The [src] has run out of usable materials."))
					break
			else
				to_chat(user,span_warning("\The [src] is hand-operated and requires your full attention!"))
				icon_state = "coinpress0"
				break
