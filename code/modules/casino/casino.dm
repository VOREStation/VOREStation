
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

//
//Roulette Table
//
/obj/structure/casino_table
	name = "casino table"
	desc = "This is an unremarkable table for a casino."
	icon = 'icons/obj/casino.dmi'
	icon_state = "roulette_table"
	density = 1
	anchored = 1
	climbable = 1
	layer = TABLE_LAYER
	throwpass = 1
	var/item_place = 1 //allows items to be placed on the table, but not on benches.

	var/busy = 0

/obj/structure/casino_table/attackby(obj/item/W as obj, mob/user as mob)
	if(item_place)
		user.drop_item(src.loc)
	return

/obj/structure/casino_table/roulette_table
	name = "roulette"
	desc = "The roulette. Spin to try your luck."
	icon_state = "roulette_wheel"
	var/spin_state = "roulette_wheel_spinning"

	var/obj/item/roulette_ball/ball

/obj/structure/casino_table/roulette_table/Initialize()
	.=..()
	ball = new(src)
	return

/obj/structure/casino_table/roulette_table/examine(mob/user)
	.=..()
	if(ball)
		. += "It's currently using [ball.get_ball_desc()]."
	else
		. += "It doesn't have a ball."

/obj/structure/casino_table/roulette_table/attack_hand(mob/user as mob)
	if(busy)
		to_chat(user,"<span class='notice'>You cannot spin now! The roulette is already spinning.</span> ")
		return
	if(!ball)
		to_chat(user,"<span class='notice'>This roulette wheel has no ball!</span> ")
		return
	visible_message("<span class='notice'>\The [user] spins the roulette and throws [ball.get_ball_desc()] into it.</span>")
	playsound(src.loc, 'sound/machines/roulette.ogg', 40, 1)
	busy = 1
	ball.on_spin()
	icon_state = spin_state
	var/result = rand(0,37)
	if(ball.cheatball)
		result = ball.get_cheated_result()
	var/color = "green"
	add_fingerprint(user)
	if((result > 0 && result < 11) || (result > 18 && result < 29))
		if(result % 2)
			color="red"
		else
			color="black"
	if((result > 10 && result < 19) || (result > 28 && result < 37))
		if(result % 2)
			color="black"
		else
			color="red"
	if(result == 37)
		result = "00"
	spawn(5 SECONDS)
		visible_message("<span class='notice'>The roulette stops spinning, the ball landing on [result], [color].</span>")
		busy = 0
		icon_state = initial(icon_state)

/obj/structure/casino_table/roulette_table/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/roulette_ball))
		if(!ball)
			user.drop_from_inventory(W)
			W.forceMove(src)
			ball = W
			to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
			return
	..()

/obj/structure/casino_table/roulette_table/verb/remove_ball()
	set name = "Remove Roulette Ball"
	set category = "Object"
	set src in oview(1)

	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(ismouse(usr) || (isobserver(usr)))
		return

	if(busy)
		to_chat(usr, "<span class='warning'>You cannot remove \the [ball] while [src] is spinning!</span>")
		return

	if(ball)
		usr.put_in_hands(ball)
		to_chat(usr, "<span class='notice'>You remove \the [ball] from [src].</span>")
		ball = null
		return
	else
		to_chat(usr, "<span class='notice'>There is no ball in [src]!</span>")
		return

/obj/structure/casino_table/roulette_table/long
	icon_state = "roulette_wheel_long"
	spin_state = "roulette_wheel_long_spinning"

/obj/structure/casino_table/roulette_long
	name = "roulette table"
	desc = "Roulette table."
	icon_state = "roulette_long"

/obj/structure/casino_table/roulette_chart
	name = "roulette chart"
	desc = "Roulette chart. Place your bets!"
	icon_state = "roulette_table"

/obj/item/roulette_ball
	name = "roulette ball"
	desc = "A small ball used for roulette wheel. This one is made of regular metal."
	var/ball_desc = "a small metal ball"
	icon = 'icons/obj/casino.dmi'
	icon_state = "roulette_ball"

	var/cheatball = FALSE

/obj/item/roulette_ball/proc/get_cheated_result()
	return rand(0,37)		// No cheating by default

/obj/item/roulette_ball/proc/get_ball_desc()
	return ball_desc

/obj/item/roulette_ball/proc/on_spin()
	return

/obj/item/roulette_ball/gold
	name = "golden roulette ball"
	desc = "A small ball used for roulette wheel. This one is particularly gaudy."
	ball_desc = "a shiny golden ball"
	icon_state = "roulette_ball_gold"

/obj/item/roulette_ball/red
	name = "red roulette ball"
	desc = "A small ball used for roulette wheel. This one is ornate red."
	ball_desc = "a striped red ball"
	icon_state = "roulette_ball_red"

/obj/item/roulette_ball/orange
	name = "orange roulette ball"
	desc = "A small ball used for roulette wheel. This one is ornate orange."
	ball_desc = "a striped orange ball"
	icon_state = "roulette_ball_orange"

/obj/item/roulette_ball/green
	name = "green roulette ball"
	desc = "A small ball used for roulette wheel. This one is ornate green."
	ball_desc = "a smooth green ball"
	icon_state = "roulette_ball_green"

/obj/item/roulette_ball/blue
	name = "blue roulette ball"
	desc = "A small ball used for roulette wheel. This one is ornate blue."
	ball_desc = "a striped blue ball"
	icon_state = "roulette_ball_blue"

/obj/item/roulette_ball/yellow
	name = "yellow roulette ball"
	desc = "A small ball used for roulette wheel. This one is ornate yellow."
	ball_desc = "a smooth yellow ball"
	icon_state = "roulette_ball_yellow"

/obj/item/roulette_ball/purple
	name = "purple roulette ball"
	desc = "A small ball used for roulette wheel. This one is ornate purple."
	ball_desc = "a dotted purple ball"
	icon_state = "roulette_ball_purple"

/obj/item/roulette_ball/planet
	name = "planet roulette ball"
	desc = "A small ball used for roulette wheel. This one looks like a small earth-like planet."
	ball_desc = "a planet-like ball"
	icon_state = "roulette_ball_earth"

/obj/item/roulette_ball/moon
	name = "moon roulette ball"
	desc = "A small ball used for roulette wheel. This one looks like a small moon."
	ball_desc = "a moon-like ball"
	icon_state = "roulette_ball_moon"

/obj/item/roulette_ball/hollow
	name = "glass roulette ball"
	desc = "A small ball used for roulette wheel. This one is made of glass and seems to be openable."
	ball_desc = "a small glass ball"
	icon_state = "roulette_ball_glass"

	var/obj/item/weapon/holder/trapped

/obj/item/roulette_ball/hollow/examine(mob/user)
	.=..()
	if(trapped)
		. += "You can see [trapped] trapped inside!"
	else
		. += "It appears to be empty."

/obj/item/roulette_ball/hollow/get_ball_desc()
	.=..()
	if(trapped && trapped.held_mob)
		. += " with [trapped.name] trapped within"
	return

/obj/item/roulette_ball/hollow/attackby(var/obj/item/W, var/mob/user)
	if(trapped)
		to_chat(user, "<span class='notice'>This ball already has something trapped in it!</span>")
		return
	if(istype(W, /obj/item/weapon/holder))
		var/obj/item/weapon/holder/H = W
		if(!H.held_mob)
			to_chat(user, "<span class='warning'>This holder has nobody in it? Yell at a developer!</span>")
			return
		if(H.held_mob.get_effective_size(TRUE) > 50)
			to_chat(user, "<span class='warning'>\The [H] is too big to fit inside!</span>")
			return
		user.drop_from_inventory(H)
		H.forceMove(src)
		trapped = H
		to_chat(user, "<span class='notice'>You trap \the [H] inside the glass roulette ball.</span>")
		to_chat(H.held_mob, "<span class='warning'>\The [user] traps you inside a glass roulette ball!</span>")
		update_icon()

/obj/item/roulette_ball/hollow/update_icon()
	if(trapped && trapped.held_mob)
		icon_state = "roulette_ball_glass_full"
	else
		icon_state = "roulette_ball_glass"

/obj/item/roulette_ball/hollow/attack_self(mob/user as mob)
	if(!trapped)
		to_chat(user, "<span class='notice'>\The [src] is empty!</span>")
		return
	else
		user.put_in_hands(trapped)
		if(trapped.held_mob)
			to_chat(user, "<span class='notice'>You take \the [trapped] out of the glass roulette ball.</span>")
			to_chat(trapped.held_mob, "<span class='notice'>\The [user] takes you out of a glass roulette ball.</span>")
		trapped = null
		update_icon()

/obj/item/roulette_ball/hollow/on_holder_escape()
	trapped = null
	update_icon()

/obj/item/roulette_ball/hollow/on_spin()
	if(trapped && trapped.held_mob)
		to_chat(trapped.held_mob, "<span class='critical'>THE WHOLE WORLD IS SENT WHIRLING AS THE ROULETTE SPINS!!!</span>")

/obj/item/roulette_ball/hollow/Destroy()
	if(trapped)
		trapped.forceMove(src.loc)
		trapped = null
	return ..()

/obj/item/roulette_ball/cheat
	cheatball = TRUE

/obj/item/roulette_ball/cheat/first_twelve
	desc = "A small ball used for roulette wheel. This one is made of regular metal. Its weighted to only land on first 12."

/obj/item/roulette_ball/cheat/first_twelve/get_cheated_result()
	return pick(list(1,2,3,4,5,6,7,8,9,10,11,12))

/obj/item/roulette_ball/cheat/second_twelve
	desc = "A small ball used for roulette wheel. This one is made of regular metal. Its weighted to only land on second 12."

/obj/item/roulette_ball/cheat/second_twelve/get_cheated_result()
	return pick(list(13,14,15,16,17,18,19,20,21,22,23,24))

/obj/item/roulette_ball/cheat/third_twelve
	desc = "A small ball used for roulette wheel. This one is made of regular metal. Its weighted to only land on third 12."

/obj/item/roulette_ball/cheat/third_twelve/get_cheated_result()
	return pick(list(25,26,27,28,29,30,31,32,33,34,35,36))

/obj/item/roulette_ball/cheat/zeros
	desc = "A small ball used for roulette wheel. This one is made of regular metal. Its weighted to only land on 0 or 00."

/obj/item/roulette_ball/cheat/zeros/get_cheated_result()
	return pick(list(0, 37))

/obj/item/roulette_ball/cheat/red
	desc = "A small ball used for roulette wheel. This one is made of regular metal. Its weighted to only land on red."

/obj/item/roulette_ball/cheat/red/get_cheated_result()
	return pick(list(1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36))

/obj/item/roulette_ball/cheat/black
	desc = "A small ball used for roulette wheel. This one is made of regular metal. Its weighted to only land on black."

/obj/item/roulette_ball/cheat/black/get_cheated_result()
	return pick(list(2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35))

/obj/item/roulette_ball/cheat/even
	desc = "A small ball used for roulette wheel. This one is made of regular metal. Its weighted to only land on even."

/obj/item/roulette_ball/cheat/even/get_cheated_result()
	return pick(list(2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36))

/obj/item/roulette_ball/cheat/odd
	desc = "A small ball used for roulette wheel. This one is made of regular metal. Its weighted to only land on odd."

/obj/item/roulette_ball/cheat/odd/get_cheated_result()
	return pick(list(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35))

//
//Blackjack table
//
/obj/structure/casino_table/blackjack_l
	name = "gambling table"
	desc = "Gambling table, try your luck and skills!"
	icon_state = "blackjack_l"

/obj/structure/casino_table/blackjack_m
	name = "gambling table"
	desc = "Gambling table, try your luck and skills!"
	icon_state = "blackjack_m"

/obj/structure/casino_table/blackjack_r
	name = "gambling table"
	desc = "Gambling table, try your luck and skills!"
	icon_state = "blackjack_r"

//
//Craps table
//
/obj/structure/casino_table/craps
	name = "craps table"
	desc = "A padded table designed for dice games!"
	icon_state = "craps_table"

//
//Wheel. Of. FORTUNE!
//
/obj/machinery/wheel_of_fortune
	name = "wheel of fortune"
	desc = "The Wheel of Fortune! Insert chips and may fortune favour the lucky one at the next lottery!"
	icon = 'icons/obj/64x64.dmi'
	icon_state = "wheel_of_fortune"
	density = 1
	anchored = 1
	pixel_x = -16

	req_access = list(300)
	var/interval = 1
	var/busy = 0
	var/public_spin = 0
	var/lottery_sale = "disabled"
	var/lottery_price = 100
	var/lottery_entries = 0
	var/lottery_tickets = list()
	var/lottery_tickets_ckeys = list()

	var/datum/effect/effect/system/confetti_spread
	var/confetti_strength = 15


/obj/machinery/wheel_of_fortune/attack_hand(mob/user as mob)
	if (busy)
		to_chat(user,"<span class='notice'>The wheel of fortune is already spinning!</span> ")
		return

	if(usr.incapacitated())
		return
	if(ishuman(usr) || istype(usr, /mob/living/silicon/robot))
		switch(input(user,"Choose what to do","Wheel Of Fortune") in list("Spin the Wheel! (Not Lottery)", "Set the interval", "Cancel"))
			if("Cancel")
				return
			if("Spin the Wheel! (Not Lottery)")
				if(public_spin == 0)
					to_chat(user,"<span class='notice'>The Wheel makes a sad beep, public spins are not enabled right now..</span> ")
					return
				else
					to_chat(user,"<span class='notice'>You spin the wheel!</span> ")
					spin_the_wheel("not_lottery")
			if("Set the interval")
				setinterval()


/obj/machinery/wheel_of_fortune/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (busy)
		to_chat(user,"<span class='notice'>The wheel of fortune is already spinning!</span> ")
		return

	if(usr.incapacitated())
		return

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/pda))
		if(!check_access(W))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return
		else
			to_chat(user, "<span class='warning'>Proper access, allowed staff controls.</span>")
			if(ishuman(usr) || istype(usr, /mob/living/silicon/robot))
				switch(input(user,"Choose what to do (Management)","Wheel Of Fortune (Management)") in list("Spin the Lottery Wheel!", "Toggle Lottery Sales", "Toggle Public Spins", "Reset Lottery", "Cancel"))
					if("Cancel")
						return
					if("Spin the Lottery Wheel!")
						to_chat(user,"<span class='notice'>You spin the wheel for the lottery!</span> ")
						spin_the_wheel("lottery")

					if("Toggle Lottery Sales")
						if(lottery_sale == "disabled")
							lottery_sale = "enabled"
							to_chat(user,"<span class='notice'>Public Lottery sale has been enabled.</span> ")
						else
							lottery_sale = "disabled"
							to_chat(user,"<span class='notice'>Public Lottery sale has been disabled.</span> ")

					if("Toggle Public Spins")
						if(public_spin == 0)
							public_spin = 1
							to_chat(user,"<span class='notice'>Public spins has been enabled.</span> ")
						else
							public_spin = 0
							to_chat(user,"<span class='notice'>Public spins has been disabled.</span> ")

					if("Reset Lottery")
						var/confirm = tgui_alert(usr, "Are you sure you want to reset Lottery?", "Confirm Lottery Reset", list("Yes", "No"))
						if(confirm == "Yes")
							to_chat(user, "<span class='warning'>Lottery has been Reset!</span>")
							lottery_entries = 0
							lottery_tickets = list()
							lottery_tickets_ckeys = list()

	if(istype(W, /obj/item/weapon/spacecasinocash))
		if(lottery_sale == "disabled")
			to_chat(user, "<span class='warning'>Lottery sales are currently disabled.</span>")
			return
		else
			if(user.client.ckey in lottery_tickets_ckeys)
				to_chat(user, "<span class='warning'>The scanner beeps in an upset manner, you already have a ticket!</span>")
				return

			var/obj/item/weapon/spacecasinocash/C = W
			insert_chip(C, user)

/obj/machinery/wheel_of_fortune/proc/insert_chip(var/obj/item/weapon/spacecasinocash/cashmoney, mob/user)
	if (busy)
		to_chat(user,"<span class='notice'>The Wheel of Fortune is busy, wait for it to be done to buy a lottery ticket.</span> ")
		return
	if(cashmoney.worth < lottery_price)
		to_chat(user,"<span class='notice'>You dont have enough chips to buy a lottery ticket!</span> ")
		return

	to_chat(user,"<span class='notice'>You put [lottery_price] credits worth of chips into the Wheel of Fortune and it pings to notify of your lottery ticket registered!</span>")
	cashmoney.worth -= lottery_price
	cashmoney.update_icon()

	if(cashmoney.worth <= 0)
		usr.drop_from_inventory(cashmoney)
		qdel(cashmoney)
		cashmoney.update_icon()

	lottery_entries++
	lottery_tickets += "Number.[lottery_entries] [user.name]"
	lottery_tickets_ckeys += user.client.ckey

/obj/machinery/wheel_of_fortune/proc/spin_the_wheel(var/mode)
	var/result = 0

	if(mode == "not_lottery")
		busy = 1
		icon_state = "wheel_of_fortune_spinning"
		result = rand(1,interval)

		spawn(5 SECONDS)
			visible_message("<span class='notice'>The wheel of fortune stops spinning, the number is [result]!</span>")
			src.confetti_spread = new /datum/effect/effect/system/confetti_spread()
			src.confetti_spread.attach(src) //If somehow people start dragging slot machine
			spawn(0)
				for(var/i = 1 to confetti_strength)
					src.confetti_spread.start()
					sleep(10)

			flick("[icon_state]-winning",src)
			busy = 0
			icon_state = "wheel_of_fortune"

	if(mode == "lottery")
		if(lottery_entries == 0)
			visible_message("<span class='notice'>There are no tickets in the system!</span>")
			return

		busy = 1
		icon_state = "wheel_of_fortune_spinning"
		result = pick(lottery_tickets)

		spawn(5 SECONDS)
			visible_message("<span class='notice'>The wheel of fortune stops spinning, and the winner is [result]!</span>")
			src.confetti_spread = new /datum/effect/effect/system/confetti_spread()
			src.confetti_spread.attach(src) //If somehow people start dragging slot machine
			spawn(0)
				for(var/i = 1 to confetti_strength)
					src.confetti_spread.start()
					sleep(10)

			flick("[icon_state]-winning",src)
			busy = 0
			icon_state = "wheel_of_fortune"

/obj/machinery/wheel_of_fortune/verb/setinterval()
	set name = "Change interval"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated())
		return
	if(ishuman(usr) || istype(usr, /mob/living/silicon/robot))
		interval = tgui_input_number(usr, "Put the desired interval (1-1000)", "Set Interval", null, 1000, 1)
		if(interval>1000 || interval<1)
			usr << "<span class='notice'>Invalid interval.</span>"
			return
		usr << "<span class='notice'>You set the interval to [interval]</span>"
	return

//
//Slave Terminal
//
/obj/machinery/casinoslave_handler
	name = "Sentient Prize Automated Sales Machinery"
	desc = "The Sentient Prize Automated Sales Machinery, also known as SPASM! Here one can see who is on sale as sentinet prizes, as well as selling self and also buying prizes."
	icon = 'icons/obj/casino.dmi'
	icon_state = "casinoslave_hub_off"
	density = 1
	anchored = 1
	req_access = list(300)

	var/casinoslave_sale = "disabled"
	var/casinoslave_price = 100
	var/collar_list = list()
	var/slaves_ckeys_list = list() //Same trick as lottery, to keep life simple
	var/obj/item/clothing/accessory/collar/casinoslave/selected_collar = null

/obj/machinery/casinoslave_handler/attack_hand(mob/living/user as mob)
	if(usr.incapacitated())
		return
	if(casinoslave_sale == "disabled")
		to_chat(user,"<span class='notice'>The SPASM is disabled.</span> ")
		return

	if(ishuman(usr) || istype(usr, /mob/living/silicon/robot))
		switch(input(user,"Choose what to do","SPASM") in list("Show selected Prize", "Select Prize", "Become Prize (Please examine yourself first)", "Cancel"))
			if("Cancel")
				return
			if("Show selected Prize")
				if(QDELETED(selected_collar))
					collar_list -= selected_collar
					slaves_ckeys_list -= selected_collar.slaveckey
					to_chat(user, "<span class='warning'>No collar is currently selected or the currently selected one has been destroyed or disabled.</span>")
					selected_collar = null
					return
				to_chat(user, "<span class='warning'>Sentient Prize information</span>")
				to_chat(user, "<span class='notice'>Name: [selected_collar.slavename]</span>")
				to_chat(user, "<span class='notice'>Description: [selected_collar.slaveflavor]</span>")
				to_chat(user, "<span class='notice'>OOC: [selected_collar.slaveooc]</span>")
				if(selected_collar.ownername != null)
					to_chat(user, "<span class='warning'>This prize is already owned by [selected_collar.ownername]</span>")

			if("Select Prize")
				selected_collar = tgui_input_list(user, "Select a prize", "Chose a collar", collar_list)
				if(QDELETED(selected_collar))
					collar_list -= selected_collar
					slaves_ckeys_list -= selected_collar.slaveckey
					to_chat(user, "<span class='warning'>No collars to chose, or selected collar has been destroyed or deactived, selection has been removed from list.</span>")
					selected_collar = null
					return

			if("Become Prize (Please examine yourself first)") //Its awkward, but no easy way to obtain flavor_text due to server not loading text of mob until its been examined at least once.
				var/safety_ckey = user.client.ckey
				if(safety_ckey in slaves_ckeys_list)
					to_chat(user, "<span class='warning'>The SPASM beeps in an upset manner, you already have a collar!</span>")
					return
				var/confirm = tgui_alert(usr, "Are you sure you want to become a sentient prize?", "Confirm Sentient Prize", list("Yes", "No"))
				if(confirm == "Yes")
					to_chat(user, "<span class='warning'>You are now a prize!</span>")
				if(safety_ckey in slaves_ckeys_list)
					to_chat(user, "<span class='warning'>The SPASM beeps in an upset manner, you already have a collar!</span>")
					return
				slaves_ckeys_list += user.ckey
				var/obj/item/clothing/accessory/collar/casinoslave/C = new(src.loc)
				C.slavename = "[user.name]"
				C.slaveckey = "[user.ckey]"
				C.slaveflavor = user.flavor_text
				C.slaveooc = user.ooc_notes
				C.name = "Sentient Prize Collar: Available! [user.name] purchaseable at the SPASM!"
				C.desc = "SPASM collar. The tags shows in flashy colorful text the wearer is [user.name] and is currently available to buy at the Sentient Prize Automated Sales Machinery!"
				C.icon_state = "casinoslave_available"
				C.update_icon()
				collar_list += C

				spawn_casinochips(casinoslave_price, src.loc)

/obj/machinery/casinoslave_handler/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(usr.incapacitated())
		return

	if(istype(W, /obj/item/weapon/spacecasinocash))
		if(casinoslave_sale == "disabled")
			to_chat(user, "<span class='warning'>Sentient Prize sales are currently disabled.</span>")
			return
		if(!selected_collar.ownername)
			var/obj/item/weapon/spacecasinocash/C = W
			if(user.client.ckey == selected_collar.slaveckey)
				insert_chip(C, user, "selfbuy")
				return
			else
				insert_chip(C, user, "buy")
				return
		else
			to_chat(user, "<span class='warning'>This Sentient Prize is already owned! If you are the owner you can release the prize by swiping the collar on the SPASM!</span>")
			return

	if(istype(W, /obj/item/clothing/accessory/collar/casinoslave))
		var/obj/item/clothing/accessory/collar/casinoslave/C = W
		if(user.name != C.slavename && user.name != C.ownername)
			to_chat(user, "<span class='warning'>This Sentient Prize collar isn't yours, please give it to the one it tagged for, belongs to, or a casino staff member!</span>")
			return
		if(user.name == C.slavename)
			if(!C.ownername)
				to_chat(user,"<span class='notice'>If collar isn't disabled and entry removed, please select your entry and insert chips. Or contact staff if you need assistance.</span> ")
				return
			else
				to_chat(user,"<span class='notice'>If collar isn't disabled and entry removed, please ask your owner to free you with collar swipe on the SPASM, or contact staff if you need assistance.</span> ")
				return
		if(user.name == C.ownername)
			var/confirm = tgui_alert(usr, "Are you sure you want to wipe [C.slavename] entry?", "Confirm Sentient Prize Release", list("Yes", "No"))
			if(confirm == "Yes")
				to_chat(user, "<span class='warning'>[C.slavename] collar has been deleted from registry!</span>")
				C.icon_state = "casinoslave"
				C.update_icon()
				C.name = "a disabled Sentient Prize Collar: [C.slavename]"
				C.desc = "A collar worn by sentient prizes registered to a SPASM. The tag says its registered to [C.slavename], but harsh red text informs you its been disabled."
				slaves_ckeys_list -= C.slaveckey
				C.slaveckey = null
				collar_list -= C

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/pda))
		if(!check_access(W))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return
		else
			to_chat(user, "<span class='warning'>Proper access, allowed staff controls.</span>")
			if(ishuman(usr) || istype(usr, /mob/living/silicon/robot))
				switch(input(user,"Choose what to do (Management)","SPASM (Management)") in list("Toggle Sentient Prize Sales", "Wipe Selected Prize Entry", "Change Prize Value", "Cancel"))
					if("Cancel")
						return

					if("Toggle Sentient Prize Sales")
						if(casinoslave_sale == "disabled")
							casinoslave_sale = "enabled"
							icon_state = "casinoslave_hub_on"
							update_icon()
							to_chat(user,"<span class='notice'>Prize sale has been enabled.</span> ")
						else
							casinoslave_sale = "disabled"
							icon_state = "casinoslave_hub_off"
							update_icon()
							to_chat(user,"<span class='notice'>Prize sale has been disabled.</span> ")

					if("Wipe Selected Prize Entry")
						if(!selected_collar)
							to_chat(user, "<span class='warning'>No collar selected!</span>")
							return
						if(QDELETED(selected_collar))
							collar_list -= selected_collar
							slaves_ckeys_list -= selected_collar.slaveckey
							to_chat(user, "<span class='warning'>Collar has been destroyed!</span>")
							selected_collar = null
							return
						var/safety_ckey = selected_collar.slaveckey
						var/confirm = tgui_alert(usr, "Are you sure you want to wipe [selected_collar.slavename] entry?", "Confirm Sentient Prize", list("Yes", "No"))
						if(confirm == "Yes")
							if(safety_ckey == selected_collar.slaveckey)
								to_chat(user, "<span class='warning'>[selected_collar.slavename] collar has been deleted from registry!</span>")
								selected_collar.icon_state = "casinoslave"
								selected_collar.update_icon()
								selected_collar.name = "a disabled Sentient Prize Collar: [selected_collar.slavename]"
								selected_collar.desc = "A collar worn by sentient prizes registered to a SPASM. The tag says its registered to [selected_collar.slavename], but harsh red text informs you its been disabled."
								slaves_ckeys_list -= selected_collar.slaveckey
								selected_collar.slaveckey = null
								collar_list -= selected_collar
								selected_collar = null
							else
								to_chat(user, "<span class='warning'>Registry deletion aborted! Changed collar selection!</span>")
								return

					if("Change Prize Value")
						setprice(user)

/obj/machinery/casinoslave_handler/proc/insert_chip(var/obj/item/weapon/spacecasinocash/cashmoney, mob/user, var/buystate)
	if(cashmoney.worth < casinoslave_price)
		to_chat(user,"<span class='notice'>You dont have enough chips to pay for the sentient prize!</span> ")
		return

	cashmoney.worth -= casinoslave_price
	cashmoney.update_icon()

	if(cashmoney.worth <= 0)
		usr.drop_from_inventory(cashmoney)
		qdel(cashmoney)
		cashmoney.update_icon()

	if(buystate == "selfbuy")
		to_chat(user,"<span class='notice'>You put [casinoslave_price] credits worth of chips into the SPASM and nullify your collar!</span> ")
		selected_collar.icon_state = "casinoslave"
		selected_collar.update_icon()
		selected_collar.name = "a disabled Sentient Prize Collar: [selected_collar.slavename]"
		selected_collar.desc = "A collar worn by sentient prizes registered to a SPASM. The tag says its registered to [selected_collar.slavename], but harsh red text informs you its been disabled."
		slaves_ckeys_list -= selected_collar.slaveckey
		selected_collar.slaveckey = null
		collar_list -= selected_collar
		selected_collar = null

	if(buystate == "buy")
		to_chat(user,"<span class='notice'>You put [casinoslave_price] credits worth of chips into the SPASM and it pings to inform you bought [selected_collar.slavename]!</span> ")
		selected_collar.icon_state = "casinoslave_owned"
		selected_collar.update_icon()
		selected_collar.ownername = user.name
		selected_collar.name =  "Sentient Prize Collar: [selected_collar.slavename] owned by [selected_collar.ownername]!"
		selected_collar.desc = "A collar worn by sentient prizes registered to a SPASM. The tag says its registered to [selected_collar.slavename] and they are owned by [selected_collar.ownername]."
		selected_collar = null

/obj/machinery/casinoslave_handler/proc/setprice(mob/living/user as mob)
	if(usr.incapacitated())
		return
	if(ishuman(usr) || istype(usr, /mob/living/silicon/robot))
		casinoslave_price = tgui_input_number(usr, "Select the desired price (1-1000)", "Set Price", null, null, 1000, 1)
		if(casinoslave_price>1000 || casinoslave_price<1)
			to_chat(user,"<span class='notice'>Invalid price.</span> ")
			return
		to_chat(user,"<span class='notice'>You set the price to [casinoslave_price]</span> ")
