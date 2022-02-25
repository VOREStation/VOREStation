/obj/trader
	name = "trader"
	desc = "Some kind of trade thing."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	var/accepts = "coin"		// "coin" - "money" - "item"
	var/accepted_itemtype		//only for use with item mode
	var/accepted_item_worth = 1	//only for use with item mode
	var/bank = list()
	var/coinbalance = 0			//only for use with coin mode
	var/list/start_products = list()
	var/list/products = list()
	var/list/prices = list()
	var/list/multiple = list()
	var/trading = FALSE
	var/welcome_msg = "This machine accepts"
	var/welcome_accepts_name = "curious coins"
	var/welcome_msg_finish = "Would you like to browse the wares?"
	var/list/interact_sound = list()
	var/sound_cooldown = 0
	var/sound_lastplayed = 0

/obj/trader/Initialize(mapload)
	. = ..()
	for(var/item in start_products)
		var/obj/p = new item
		contents += p
		products += p
		start_products -= item

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
		var/ask = tgui_alert(user, "[welcome_msg] [welcome_accepts_name]. [welcome_msg_finish]", "[src]",list("Yes","No","Return banked funds"), timeout = 10 SECONDS)
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
			visible_message("<span class='notice'>\The [src] drops the banked [welcome_accepts_name].</span>")
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
		if("item")
			var/v = amount
			while(v > 0)
				for(var/obj/c in bank)
					if(istype(c, accepted_itemtype))
						c.forceMove(get_turf(loc))
						qdel(c)
						v -= accepted_item_worth

/obj/trader/proc/return_funds()
	switch(accepts)
		if("coin")
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
					coinbalance -= 1
		if("money")
			for(var/obj/c in bank)
				c.forceMove(get_turf(loc))
				bank -= c
		if("item")
			for(var/obj/c in bank)
				c.forceMove(get_turf(loc))
				bank -= c

/obj/trader/capture_crystal
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
		/obj/item/capture_crystal/basic = 1,
		/obj/item/capture_crystal/great = 2,
		/obj/item/capture_crystal/ultra = 5,
		/obj/item/capture_crystal/master = 50,
		/obj/item/capture_crystal/random = 3
	)
	multiple = list(
		/obj/item/capture_crystal/basic = 10,
		/obj/item/capture_crystal/great = 5,
		/obj/item/capture_crystal/ultra = 2)

/obj/trader/capture_crystal/cash
	accepts = "money"
/obj/trader/capture_crystal/item
	accepts = "item"