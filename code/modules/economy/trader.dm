/obj/trader
	name = "trader"
	desc = "Some kind of trade thing."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	var/accepts = "coin"				// "coin" - "money" - "item" - determines the 'kind' of thing the machine will accept
	var/accepted_itemtype				//only for use with "item" mode - if set to a type path, it will count anything with that type path
	var/accepted_item_worth = 1			//only for use with "item" mode - when counted, things of the appropriate type will add this much to the banked funds
	var/list/bank = list()					//Anything accepted by "money" or "item" mode will be marked down here
	var/coinbalance = 0					//only for use with coin mode - when you put a curious coin in, it adds the coins value to this number
	var/list/start_products = list()	//Type paths entered here will spawn inside the trader and add themselves to the products list.
	var/list/products = list()			//Anything in this list will be listed for sale
	var/list/prices = list()			//Enter a type path with an associated number, and if the trader tries to sell something of that type, it will expect the number as the cost for that product
	var/list/multiple = list()			//Enter a type path with an associated number, and the trader will have however many of that type to sell as the number you entered
	var/trading = FALSE					//'Busy' - Only one person can trade at a time.
	var/welcome_msg = "This machine accepts"	//The first part of the welcome message
	var/welcome_accepts_name = "curious coins"	//The name of the kind of thing the trader expects, automatically set except on "item" mode, where if you enter a value it will not change it.
	var/welcome_msg_finish = ". Would you like to browse the wares?"	//The final part of the welcome message.
	var/list/interact_sound = list()	//The sounds that may play when you click it. It will pick one at random from this list. It only thinks about this if there's anything in the list.
	var/sound_cooldown = 0				//The sound can only play this often in deciseconds. Use '10 SECONDS' format to make it easier to read
	var/sound_lastplayed = 0			//Automatically set when the sound is played.
	var/pick_inventory = FALSE			//If true, when initialized the trader will randomly pick things from its start products list to set up
	var/pick_inventory_quantity = 0		//This is how many things will be picked if pick_inventory is TRUE
	var/move_trader = FALSE

/obj/trader/Initialize(mapload)
	. = ..()
	if(pick_inventory)
		while(pick_inventory_quantity > 0)
			var/t = pickweight(start_products)
			var/i = new t(src)
			start_products -= t
			products += i
			pick_inventory_quantity --
	else
		for(var/item in start_products)
			var/obj/p = new item(src)
			products += p
			start_products -= item
	if(move_trader)
		move_trader()

/obj/trader/Destroy()
	. = ..()
	LAZYCLEARLIST(products)
	LAZYCLEARLIST(bank)
	LAZYCLEARLIST(start_products)
	LAZYCLEARLIST(prices)
	LAZYCLEARLIST(multiple)
	for(var/item in contents)
		qdel(item)

/obj/trader/attack_hand(mob/living/user)
	. = ..()
	if(trading)
		to_chat(user, "<span class='notice'>\The [src] is busy with someone else at the moment...</span>")
		return
	var/coin_value = get_value(accepts)
	if(products.len > 0)
		trading = TRUE
		switch(accepts)
			if("coin")
				welcome_accepts_name = "curious coins"
			if("money")
				welcome_accepts_name = "Thalers"
			if("item")
				if(welcome_accepts_name == "curious coins")
					welcome_accepts_name = "a kind of item"
		var/ask = tgui_alert(user, "[welcome_msg][welcome_accepts_name][welcome_msg_finish]", "[src]",list("Yes","No","Return banked funds"), timeout = 10 SECONDS)
		if (ask == "Return banked funds")
			if(!Adjacent(user))
				to_chat(user, "<span class='notice'>You aren't close enough.</span>")
				trading = FALSE
				return
			return_funds()
			trading = FALSE
			return
		else if(ask != "Yes")
			trading = FALSE
			return
		if(!Adjacent(user))
			to_chat(user, "<span class='notice'>You decided not to get anything.</span>")
			trading = FALSE
			return
		if(interact_sound.len > 0)
			if((world.time- sound_lastplayed) > sound_cooldown)
				var/sound = pick(interact_sound)
				playsound(src, sound, 25, FALSE, ignore_walls = FALSE)
				sound_lastplayed = world.time
		var/obj/input = tgui_input_list(user, "What would you like? You have [coin_value] banked with this trader.", "Trader", products, timeout = 30 SECONDS)
		if(!input || !Adjacent(user))
			to_chat(user, "<span class='notice'>You decided not to get anything.</span>")
			trading = FALSE
			return
		var/p = 0
		var/t = input.type
		if(t in prices)
			p = prices[t]
		if(p > 0)
			if(tgui_alert(user, "Are you sure? This costs [p].", "Confirm",list("Yes","No")) != "Yes")
				to_chat(user, "<span class='notice'>You decided not to.</span>")
				trading = FALSE
				return
			else if (coin_value < p)
				to_chat(user, "<span class='warning'>You haven't provided enough funds!</span>")
				trading = FALSE
				return
		if(!Adjacent(user))
			to_chat(user, "<span class='notice'>You decided not to get anything.</span>")
			trading = FALSE
			return
		if(t in multiple)
			multiple[t] -= 1
			var/temp = input
			input = new t(get_turf(user))
			if(multiple[t] <= 0)
				for(var/obj/d in products)
					if(istype(d, temp))
						d.forceMove(get_turf(loc))
						qdel(d)
		input.forceMove(get_turf(user))
		user.put_in_hands(input)
		products -= input
		deduct_value(p)
		if(tgui_alert(user, "Would you like your change back, or would you like it to remain banked for later use? (Anyone can use banked funds)", "[src]",list("Keep it banked","I want my change"), timeout = 10 SECONDS) == "I want my change")
			if(!Adjacent(user))
				to_chat(user, "<span class='notice'>You aren't close enough.</span>")
				trading = FALSE
				return
			return_funds()
		else
			to_chat(user, "<span class='notice'>You decided leave your change banked.</span>")
		trading = FALSE
	else
		to_chat(user, "<span class='notice'>\The [src] hasn't got anything to sell.</span>")
		return

/obj/trader/attackby(obj/item/O, mob/user)
	. = ..()
	switch(accepts)
		if("coin")
			if(istype(O, /obj/item/weapon/aliencoin))
				var/obj/item/weapon/aliencoin/a = O
				coinbalance += a.value
				visible_message("<span class='notice'>\The [src] accepts \the [user]'s [O].</span>")
				qdel(a)
		if("money")
			if(istype(O, /obj/item/weapon/spacecash))
				var/obj/item/weapon/spacecash/w = O
				for(var/obj/item/weapon/spacecash/c in bank)
					var/loadsamoney = w.worth
					qdel(w)
					c.worth += loadsamoney
					c.update_icon()
					loadsamoney = null
					visible_message("<span class='notice'>\The [src] accepts \the [user]'s [O].</span>")
					return
				user.drop_item()
				w.forceMove(src.contents)
				bank += w
				visible_message("<span class='notice'>\The [src] accepts \the [user]'s [w].</span>")
		if("item")
			if(istype(O, /obj))
				user.drop_item()
				O.forceMove(src.contents)
				bank += O
				visible_message("<span class='notice'>\The [src] accepts \the [user]'s [O].</span>")

/obj/trader/proc/get_value(kind)
	var/value = 0
	switch(kind)
		if("coin")
			value = coinbalance
		if("money")
			for(var/obj/c in bank)
				if(istype(c, /obj/item/weapon/spacecash))
					var/obj/item/weapon/spacecash/a = c
					value += a.worth
				else
					c.forceMove(get_turf(src))
					visible_message("<span class='warning'>\The [src] drops the worthless [c]...</span>")
		if("item")
			for(var/obj/c in bank)
				if(istype(c, accepted_itemtype))
					value += accepted_item_worth
				else
					c.forceMove(get_turf(src))
					visible_message("<span class='warning'>\The [src] drops the worthless [c]...</span>")
	return value

/obj/trader/proc/deduct_value(amount)
	switch(accepts)
		if("coin")
			coinbalance -= amount
		if("money")
			for(var/obj/c in bank)
				if(istype(c, /obj/item/weapon/spacecash))
					var/obj/item/weapon/spacecash/a = c
					a.worth -= amount
					a.update_icon()
					if(a.worth <= 0)
						bank -= a
						qdel(a)
		if("item")
			var/v = amount
			while(v > 0)
				for(var/obj/c in bank)
					if(istype(c, accepted_itemtype))
						c.forceMove(get_turf(loc))
						qdel(c)
						v -= accepted_item_worth

/obj/trader/proc/return_funds()
	var/u_get_refund = FALSE
	switch(accepts)
		if("coin")
			if(coinbalance)
				u_get_refund = TRUE
			while(coinbalance > 0)
				if(coinbalance >= 20)
					new /obj/item/weapon/aliencoin/phoron(get_turf(loc))
					coinbalance -= 20
				else if(coinbalance >= 10)
					new /obj/item/weapon/aliencoin/gold(get_turf(loc))
					coinbalance -= 10
				else if(coinbalance >= 5)
					new /obj/item/weapon/aliencoin/silver(get_turf(loc))
					coinbalance -= 5
				else
					new /obj/item/weapon/aliencoin/basic(get_turf(loc))
					coinbalance --
		if("money")
			for(var/obj/c in bank)
				u_get_refund = TRUE
				c.forceMove(get_turf(loc))
				bank -= c
		if("item")
			for(var/obj/c in bank)
				u_get_refund = TRUE
				c.forceMove(get_turf(loc))
				bank -= c
	if(u_get_refund)
		visible_message("<span class='notice'>\The [src] drops the banked [welcome_accepts_name].</span>")
	else
		visible_message("<span class='notice'>\The [src] doesn't have anything banked for you.</span>")

/obj/trader/proc/move_trader()
	var/list/pt = list()
	for(var/obj/move_trader_landmark/t in world)
		if(t.trader_type == type)
			pt += t
	if(pt.len > 0)
		var/obj/dt = pick(pt)
		forceMove(get_turf(dt))
		dir = dt.dir
		log_admin("[src] has been placed at [loc], [x],[y],[z]")
	else
		log_and_message_admins("[src] tried to move itself but its target pick list was empty, so it was not moved. (<A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")

/obj/move_trader_landmark //You need to place the trader somewhere in the world and enable the 'move_trader' var. When the trader initializes, it will make a list of these landmarks and then move itself.
	name = "trader mover"
	desc = "A trader can be moved to here!"
	icon = 'icons/obj/landmark_vr.dmi'
	icon_state = "blue-x"
	invisibility = 101
	mouse_opacity = 0
	density = 0
	anchored = 1
	var/trader_type			//The type path for the trader you want to be able to land here.

/obj/trader/capture_crystal
	name = "curious trader"
	desc = "A tall metal cylander on a squarish base. It looks almost like a vending machine, but there's nowhere to swipe your card. It appears to accept some kind of triangle currency..."
	icon = 'icons/obj/vending_vr.dmi'
	icon_state = "cap_crys"
	interact_sound = list('sound/music/capture_crystal_1.ogg', 'sound/music/capture_crystal_2.ogg')
	sound_cooldown = 1 MINUTE
	start_products = list(
		/obj/item/capture_crystal/basic,
		/obj/item/capture_crystal/great,
		/obj/item/capture_crystal/ultra,
		/obj/item/capture_crystal/master,
		/obj/item/capture_crystal/random
	)
	prices = list(
		/obj/item/capture_crystal/basic = 5,
		/obj/item/capture_crystal/great = 10,
		/obj/item/capture_crystal/ultra = 15,
		/obj/item/capture_crystal/master = 100,
		/obj/item/capture_crystal/random = 10
	)
	multiple = list(
		/obj/item/capture_crystal/basic = 10,
		/obj/item/capture_crystal/great = 5,
		/obj/item/capture_crystal/ultra = 2)

/obj/trader/capture_crystal/cash
	accepts = "money"
	prices = list(
		/obj/item/capture_crystal/basic = 500,
		/obj/item/capture_crystal/great = 1000,
		/obj/item/capture_crystal/ultra = 1500,
		/obj/item/capture_crystal/master = 10000,
		/obj/item/capture_crystal/random = 1000
	)

/obj/trader/general
	name = "trader"
	desc = "A large canine woman. She might have a few things to sell."
	icon = 'icons/obj/traderx64.dmi'
	icon_state = "trader1"
	pixel_x = -16
	layer = ABOVE_MOB_LAYER
	plane = ABOVE_MOB_PLANE
	welcome_msg = "Hey there, welcome~ If you've got any"
	welcome_msg_finish = " then I may have something for you. Would you like to browse what I've got?"
	pick_inventory = TRUE
	pick_inventory_quantity = 5
	start_products = list(
		/obj/item/capture_crystal/basic = 100,
		/obj/item/capture_crystal/random = 50,
		/obj/item/device/perfect_tele = 10,
		/obj/item/device/chameleon = 25,
		/obj/item/weapon/gun/energy/sizegun = 25,
		/obj/item/device/slow_sizegun = 25,
		/obj/item/clothing/accessory/collar/shock/bluespace = 25,
		/obj/item/weapon/implant/sizecontrol = 25,
		/obj/item/clothing/under/hyperfiber/bluespace = 25,
		/obj/item/device/nif/authentic = 1,
		/obj/item/toy/bosunwhistle = 50,
		/obj/item/weapon/cell/infinite = 10,
		/obj/item/weapon/cell/void = 15,
		/obj/item/weapon/cell/device/weapon/recharge/alien = 10,
		/obj/item/weapon/reagent_containers/food/snacks/jellyfishcore = 50,
		/obj/item/device/denecrotizer = 10,
		/obj/item/clothing/shoes/boots/speed = 15,
		/obj/item/weapon/bluespace_harpoon = 20,
		/obj/item/weapon/telecube/randomized = 5,
		/obj/item/device/bodysnatcher = 20,
		/obj/item/device/survivalcapsule = 25,
		/obj/item/device/survivalcapsule/luxury = 20,
		/obj/item/device/survivalcapsule/luxurybar = 15,
		/obj/item/device/survivalcapsule/popcabin = 20,
		/obj/item/device/perfect_tele/frontier/unknown/one = 1
		)
	prices = list(
		/obj/item/capture_crystal/basic = 6,
		/obj/item/capture_crystal/random = 15,
		/obj/item/device/perfect_tele = 20,
		/obj/item/device/chameleon = 20,
		/obj/item/weapon/gun/energy/sizegun = 10,
		/obj/item/device/slow_sizegun = 10,
		/obj/item/clothing/accessory/collar/shock/bluespace = 10,
		/obj/item/weapon/implant/sizecontrol = 10,
		/obj/item/clothing/under/hyperfiber/bluespace = 10,
		/obj/item/device/nif/authentic = 100,
		/obj/item/toy/bosunwhistle = 1,
		/obj/item/weapon/cell/infinite = 20,
		/obj/item/weapon/cell/void = 20,
		/obj/item/weapon/cell/device/weapon/recharge/alien = 20,
		/obj/item/weapon/reagent_containers/food/snacks/jellyfishcore = 3,
		/obj/item/device/denecrotizer = 20,
		/obj/item/clothing/shoes/boots/speed = 20,
		/obj/item/weapon/bluespace_harpoon = 20,
		/obj/item/weapon/telecube/randomized = 50,
		/obj/item/device/bodysnatcher = 20,
		/obj/item/device/survivalcapsule = 10,
		/obj/item/device/survivalcapsule/luxury = 20,
		/obj/item/device/survivalcapsule/luxurybar = 25,
		/obj/item/device/survivalcapsule/popcabin = 10,
		/obj/item/device/perfect_tele/frontier/unknown/one = 30
		)
	multiple = list(
		/obj/item/capture_crystal/basic = 10,
		/obj/item/capture_crystal/random = 2,
		/obj/item/weapon/gun/energy/sizegun = 2,
		/obj/item/device/slow_sizegun = 2,
		/obj/item/clothing/accessory/collar/shock/bluespace = 2,
		/obj/item/weapon/implant/sizecontrol = 2,
		/obj/item/clothing/under/hyperfiber/bluespace = 2,
		/obj/item/weapon/reagent_containers/food/snacks/jellyfishcore = 10
		)
