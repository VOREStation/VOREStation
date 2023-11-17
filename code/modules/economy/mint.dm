/**********************Mint**************************/
/obj/machinery/mineral/mint
	name = "Coin press"
	desc = "A relatively crude hand-operated coin press that turns sheets (or ingots, as the case may be) of materials into fresh coins. They're <i>probably</i> not going to be considered legal tender in most polities, but you might fool a vending machine with one..?<br><br><i>It looks like it'll accept silver, gold, diamond, iron, solid phoron, and uranium.</i>"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"
	density = TRUE
	anchored = TRUE
	var/coinsToProduce = 6	//how many coins do we make per sheet? a sheet is 2000 units whilst a coin is 250, and some material should be lost in the process
	var/list/validMats = list("silver", "gold", "diamond", "iron", "phoron", "uranium")	//what's valid stuff to make coins out of?

/obj/machinery/mineral/mint/attackby(obj/item/stack/material/M as obj, mob/user as mob)
	if(M.default_type in validMats)
		user.visible_message("[user] starts to feed a sheet of [M.default_type] into \the [src].")
		while(M.amount > 0)
			icon_state = "coinpress1"
			if(do_after(user, 2 SECONDS, src))
				M.amount--
				if(M.default_type == "silver")
					while(coinsToProduce-- > 0)
						new /obj/item/weapon/coin/silver(user.loc)
				else if(M.default_type == "gold")
					while(coinsToProduce-- > 0)
						new /obj/item/weapon/coin/gold(user.loc)
				else if(M.default_type == "diamond")
					while(coinsToProduce-- > 0)
						new /obj/item/weapon/coin/diamond(user.loc)
				else if(M.default_type == "iron")
					while(coinsToProduce-- > 0)
						new /obj/item/weapon/coin/iron(user.loc)
				else if(M.default_type == "phoron")
					while(coinsToProduce-- > 0)
						new /obj/item/weapon/coin/phoron(user.loc)
				else if(M.default_type == "uranium")
					while(coinsToProduce-- > 0)
						new /obj/item/weapon/coin/uranium(user.loc)
				src.visible_message("<span class='notice'>\The [src] rattles and dispenses several [M.default_type] coins!</span>")
				coinsToProduce = initial(coinsToProduce)
				if(M.amount == 0)
					icon_state = "coinpress0"
					qdel(M)	//clean it up just to be sure
					src.visible_message("<span class='notice'>\The [src] has run out of usable materials.</span>")
					break
			else
				to_chat(usr,"<span class='warning'>\The [src] is hand-operated and requires your full attention!</span>")
				icon_state = "coinpress0"
				break
	else
		src.visible_message("<span class='notice'>\The [src] doesn't look like it'll accept that material.</span>")