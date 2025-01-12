/**********************Mint**************************/
/obj/machinery/mineral/mint
	name = "Coin press"
	desc = "A relatively crude hand-operated coin press that turns sheets (or ingots, as the case may be) of materials into fresh coins. They're <i>probably</i> not going to be considered legal tender in most polities, but you might fool a vending machine with one..?<br><br><i>It looks like it'll accept silver, gold, diamond, iron, solid phoron, and uranium.</i>"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"
	density = TRUE
	anchored = TRUE
	var/coinsToProduce = 6	//how many coins do we make per sheet? a sheet is 2000 units whilst a coin is 250, and some material should be lost in the process
	var/list/validMats = list(MAT_SILVER, MAT_GOLD, MAT_DIAMOND, MAT_IRON, MAT_PHORON, MAT_URANIUM)	//what's valid stuff to make coins out of?

/obj/machinery/mineral/mint/attackby(obj/item/stack/material/M, mob/user)
	if(M.default_type in validMats)
		user.visible_message("[user] starts to feed a sheet of [M.default_type] into \the [src].")
		while(M.amount > 0)
			icon_state = "coinpress1"
			if(do_after(user, 2 SECONDS, src))
				M.amount--
				if(M.default_type == MAT_SILVER)
					while(coinsToProduce-- > 0)
						new /obj/item/coin/silver(user.loc)
				else if(M.default_type == MAT_GOLD)
					while(coinsToProduce-- > 0)
						new /obj/item/coin/gold(user.loc)
				else if(M.default_type == MAT_DIAMOND)
					while(coinsToProduce-- > 0)
						new /obj/item/coin/diamond(user.loc)
				else if(M.default_type == MAT_IRON)
					while(coinsToProduce-- > 0)
						new /obj/item/coin/iron(user.loc)
				else if(M.default_type == MAT_PHORON)
					while(coinsToProduce-- > 0)
						new /obj/item/coin/phoron(user.loc)
				else if(M.default_type == MAT_URANIUM)
					while(coinsToProduce-- > 0)
						new /obj/item/coin/uranium(user.loc)
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
	else
		src.visible_message(span_notice("\The [src] doesn't look like it'll accept that material."))
