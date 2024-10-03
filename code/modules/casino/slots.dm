
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

/*
 * Slot Machine
 */

/obj/machinery/slot_machine
	name = "slot machine"
	desc = "A gambling machine designed to give you false hope and rob you of your wealth, hence why it's often called a one armed bandit."
	icon = 'icons/obj/casino.dmi'
	icon_state = "slotmachine"
	anchored = 1
	density = 1
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
	light_power = 0.9
	light_range = 2
	light_color = "#B1FBBFF"
	var/isbroken = 0  //1 if someone banged it with something heavy
	var/ispowered = 1 //starts powered, changes with power_change()
	var/busy = 0
	var/symbol1 = null
	var/symbol2 = null
	var/symbol3 = null

	var/datum/effect/effect/system/confetti_spread
	var/confetti_strength = 8

/obj/machinery/slot_machine/update_icon()
	cut_overlays()
	if(!ispowered || isbroken)
		icon_state = "slotmachine_off"
		if(isbroken) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			add_overlay("slotmachine_broken")
		set_light(0)
		set_light_on(FALSE)
		return

	icon_state = "slotmachine"
	set_light(2)
	set_light_on(TRUE)
	return

/obj/machinery/slot_machine/power_change()
	if(isbroken) //Broken shit can't be powered.
		return
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = 0
			update_icon()

/obj/machinery/slot_machine/attackby(obj/item/W as obj, mob/user as mob)
	if(busy)
		to_chat(user,"<span class='notice'>The slot machine is currently running.</span> ")
		return
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.toolspeed))
			if(!src) return
			to_chat(user, span_notice("You [anchored? "un" : ""]secured \the [src]!"))
			anchored = !anchored
		return

	if(!anchored)
		to_chat(user,span_notice(" The slot machine isn't secured."))
		return

	var/handled = 0
	var/paid = 0

	if(istype(W, /obj/item/spacecasinocash))
		var/obj/item/spacecasinocash/C = W
		paid = insert_chip(C, user)
		handled = 1

		if(paid)
			return
		if(handled)
			SStgui.update_uis(src)
			return // don't smack that machine with your 2 chips

	else if(!(stat & NOPOWER))
		return

	else if(isbroken)
		return

/obj/machinery/slot_machine/proc/insert_chip(var/obj/item/spacecasinocash/cashmoney, mob/user)
	if (ispowered == 0)
		return
	if (isbroken)
		return
	if (busy)
		to_chat(user,"<span class='notice'>The slot machine is currently rolling.</span> ")
		return
	if(cashmoney.worth < 5)
		to_chat(user,"<span class='notice'>You dont have enough chips to gamble!</span> ")
		return

	to_chat(user,span_notice("You puts 5 credits in the slot machine and presses start."))
	cashmoney.worth -= 5
	cashmoney.update_icon()

	if(cashmoney.worth <= 0)
		usr.drop_from_inventory(cashmoney)
		qdel(cashmoney)
		cashmoney.update_icon()

	busy = 1
	icon_state = "slotmachine_rolling"
	playsound(src.loc, 'sound/machines/slotmachine_pull.ogg', 15, 1)

	var/slot1 = rand(0,9)
	switch(slot1)
		if(0 to 3) symbol1 = "cherry"
		if(4 to 4) symbol1 = "lemon"
		if(5 to 5) symbol1 = "bell"
		if(6 to 6) symbol1 = "four leaf clover"
		if(7 to 7) symbol1 = "seven"
		if(8 to 8) symbol1 = "diamond"
		if(9 to 9) symbol1 = "platinum coin"

	var/slot2 = rand(0,16)
	switch(slot2)
		if(0 to 5) symbol2 = "cherry"
		if(6 to 7) symbol2 = "lemon"
		if(8 to 9) symbol2 = "bell"
		if(10 to 11) symbol2 = "four leaf clover"
		if(12 to 13) symbol2 = "seven"
		if(14 to 15) symbol2 = "diamond"
		if(16) symbol2 = "platinum coin"

	var/slot3 = rand(0,9)
	switch(slot3)
		if(0 to 3) symbol3 = "cherry"
		if(4 to 4) symbol3 = "lemon"
		if(5 to 5) symbol3 = "bell"
		if(6 to 6) symbol3 = "four leaf clover"
		if(7 to 7) symbol3 = "seven"
		if(8 to 8) symbol3 = "diamond"
		if(9 to 9) symbol3 = "platinum coin"

	var/output //Output variable to send out in chat after the large if statement.
	var/winnings = 0 //How much money will be given if any.
	var/platinumwin = 0 // If you win the platinum chip or not
	var/celebrate = 0
	var/delaytime = 5 SECONDS


	spawn(delaytime)
		to_chat(user,span_notice("The slot machine flashes with bright colours as the slots lights up with a [symbol1], a [symbol2] and a [symbol3]!"))

		if (symbol1 == "cherry" && symbol2 == "cherry" && symbol3 == "cherry")
			output = span_notice("Three cherries! The slot machine deposits chips worth 25 credits!")
			winnings = 25

		if ((symbol1 != "cherry" && symbol2 == "cherry" && symbol3 == "cherry") || (symbol1 == "cherry" && symbol2 != "cherry" && symbol3 == "cherry") ||(symbol1 == "cherry" && symbol2 == "cherry" && symbol3 != "cherry"))
			output = span_notice("Two cherries! The slot machine deposits a 10 credit chip!")
			winnings = 10

		if (symbol1 == "lemon" && symbol2 == "lemon" && symbol3 == "lemon")
			output = span_notice("Three lemons! The slot machine deposits a 50 credit chip!")
			winnings = 50

		if (symbol1 == "watermelon" && symbol2 == "watermelon" && symbol3 == "watermelon")
			output = span_notice("Three watermelons! The slot machine deposits chips worth 75 credits!")
			winnings = 75

		if (symbol1 == "bell" && symbol2 == "bell" && symbol3 == "bell")
			output = span_notice("Three bells! The slot machine deposits chips a 100 credit chip!")
			winnings = 100

		if (symbol1 == "four leaf clover" && symbol2 == "four leaf clover" && symbol3 == "four leaf clover")
			output = span_notice("Three four leaf clovers! The slot machine deposits a 200 credit chip!")
			winnings = 200

		if (symbol1 == "seven" && symbol2 == "seven" && symbol3 == "seven")
			output = span_notice("Three sevens! The slot machine deposits a 500 credit chip!")
			winnings = 500
			celebrate = 1

		if (symbol1 == "diamond" && symbol2 == "diamond" && symbol3 == "diamond")
			output = span_notice("Three diamonds! The slot machine deposits a 1000 credit chip!")
			winnings = 1000
			celebrate = 1

		if (symbol1 == "platinum coin" && symbol2 == "platinum coin" && symbol3 == "platinum coin")
			output = span_notice("Three platinum coins! The slot machine deposits a platinum chip!")
			platinumwin = TRUE
			celebrate = 1

		icon_state = initial(icon_state) // Set it back to the original iconstate.

		if(!output) // Is there anything to output? If not, consider it a loss.
			to_chat(user,"Better luck next time!")
			busy = FALSE
			return

		to_chat(user,output) //Output message

		if(platinumwin) // Did they win the platinum chip?
			new /obj/item/casino_platinum_chip(src.loc)
			playsound(src.loc, 'sound/machines/slotmachine.ogg', 25, 1)

		if(winnings) //Did the person win?
			icon_state = "slotmachine_winning"
			playsound(src.loc, 'sound/machines/slotmachine.ogg', 25, 1)
			spawn(delaytime)
				spawn_casinochips(winnings, src.loc)
				icon_state = "slotmachine"

		if(celebrate) // Happy celebrations!
			src.confetti_spread = new /datum/effect/effect/system/confetti_spread()
			src.confetti_spread.attach(src) //If somehow people start dragging slot machine
			spawn(0)
				for(var/i = 1 to confetti_strength)
					src.confetti_spread.start()
					sleep(10)

		busy = FALSE

/*
 * Station Slot Machine (takes space cash instead of chips)
 */

/obj/machinery/station_slot_machine
	name = "station slot machine"
	desc = "A gambling machine owned by NanoTrasen, designed to take Thalers as opposed to casino chips."
	icon = 'icons/obj/casino.dmi'
	icon_state = "ntslotmachine"
	anchored = 1
	density = 1
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
	light_power = 0.9
	light_range = 2
	light_color = "#B1FBBFF"
	var/isbroken = 0  //1 if someone banged it with something heavy
	var/ispowered = 1 //starts powered, changes with power_change()
	var/busy = 0
	var/symbol1 = null
	var/symbol2 = null
	var/symbol3 = null

	var/datum/effect/effect/system/confetti_spread
	var/confetti_strength = 8

/obj/machinery/station_slot_machine/update_icon()
	cut_overlays()
	if(!ispowered || isbroken)
		icon_state = "ntslotmachine_off"
		if(isbroken) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			add_overlay("ntslotmachine_broken")
		set_light(0)
		set_light_on(FALSE)
		return

	icon_state = "ntslotmachine"
	set_light(2)
	set_light_on(TRUE)
	return

/obj/machinery/station_slot_machine/power_change()
	if(isbroken) //Broken shit can't be powered.
		return
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = 0
			update_icon()

/obj/machinery/station_slot_machine/attackby(obj/item/W as obj, mob/user as mob)
	if(busy)
		to_chat(user,"<span class='notice'>The slot machine is currently running.</span> ")
		return
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.toolspeed))
			if(!src) return
			to_chat(user, span_notice("You [anchored? "un" : ""]secured \the [src]!"))
			anchored = !anchored
		return

	if(!anchored)
		to_chat(user,span_notice(" The slot machine isn't secured."))
		return

	var/handled = 0
	var/paid = 0

	if(istype(W, /obj/item/spacecash))
		var/obj/item/spacecash/C = W
		paid = insert_cash(C, user)
		handled = 1
		if(paid)
			return
		if(handled)
			SStgui.update_uis(src)
			return // don't smack that machine with your 2 chips

	else if(!(stat & NOPOWER))
		return

	else if(isbroken)
		return

/obj/machinery/station_slot_machine/proc/insert_cash(var/obj/item/spacecash/cashmoney, mob/user)
	if (ispowered == 0)
		return
	if (isbroken)
		return
	if (busy)
		to_chat(user,"<span class='notice'>The slot machine is currently rolling.</span> ")
		return
	if(cashmoney.worth < 5)
		to_chat(user,"<span class='notice'>You dont have enough Thalers to gamble!</span> ")
		return

	to_chat(user,span_notice("You puts 5 Thalers in the slot machine and presses start."))
	cashmoney.worth -= 5
	cashmoney.update_icon()

	if(cashmoney.worth <= 0)
		usr.drop_from_inventory(cashmoney)
		qdel(cashmoney)
		cashmoney.update_icon()

	busy = 1
	icon_state = "ntslotmachine_rolling"
	playsound(src.loc, 'sound/machines/slotmachine_pull.ogg', 15, 1)

	var/slot1 = rand(0,9)
	switch(slot1)
		if(0 to 3) symbol1 = "cherry"
		if(4 to 4) symbol1 = "lemon"
		if(5 to 5) symbol1 = "bell"
		if(6 to 6) symbol1 = "four leaf clover"
		if(7 to 7) symbol1 = "seven"
		if(8 to 8) symbol1 = "diamond"
		if(9 to 9) symbol1 = "platinum coin"

	var/slot2 = rand(0,16)
	switch(slot2)
		if(0 to 5) symbol2 = "cherry"
		if(6 to 7) symbol2 = "lemon"
		if(8 to 9) symbol2 = "bell"
		if(10 to 11) symbol2 = "four leaf clover"
		if(12 to 13) symbol2 = "seven"
		if(14 to 15) symbol2 = "diamond"
		if(16) symbol2 = "platinum coin"

	var/slot3 = rand(0,9)
	switch(slot3)
		if(0 to 3) symbol3 = "cherry"
		if(4 to 4) symbol3 = "lemon"
		if(5 to 5) symbol3 = "bell"
		if(6 to 6) symbol3 = "four leaf clover"
		if(7 to 7) symbol3 = "seven"
		if(8 to 8) symbol3 = "diamond"
		if(9 to 9) symbol3 = "platinum coin"

	var/output //Output variable to send out in chat after the large if statement.
	var/winnings = 0 //How much money will be given if any.
	var/platinumwin = 0 // If you win the platinum chip or not
	var/celebrate = 0
	var/delaytime = 5 SECONDS


	spawn(delaytime)
		to_chat(user,span_notice("The slot machine flashes with bright colours as the slots lights up with a [symbol1], a [symbol2] and a [symbol3]!"))

		if (symbol1 == "cherry" && symbol2 == "cherry" && symbol3 == "cherry")
			output = span_notice("Three cherries! The slot machine deposits 25 Thalers!")
			winnings = 25

		if ((symbol1 != "cherry" && symbol2 == "cherry" && symbol3 == "cherry") || (symbol1 == "cherry" && symbol2 != "cherry" && symbol3 == "cherry") ||(symbol1 == "cherry" && symbol2 == "cherry" && symbol3 != "cherry"))
			output = span_notice("Two cherries! The slot machine deposits 10 Thalers!")
			winnings = 10

		if (symbol1 == "lemon" && symbol2 == "lemon" && symbol3 == "lemon")
			output = span_notice("Three lemons! The slot machine deposits 50 Thalers!")
			winnings = 50

		if (symbol1 == "watermelon" && symbol2 == "watermelon" && symbol3 == "watermelon")
			output = span_notice("Three watermelons! The slot machine deposits 75 Thalers!")
			winnings = 75

		if (symbol1 == "bell" && symbol2 == "bell" && symbol3 == "bell")
			output = span_notice("Three bells! The slot machine deposits 100 Thalers!")
			winnings = 100

		if (symbol1 == "four leaf clover" && symbol2 == "four leaf clover" && symbol3 == "four leaf clover")
			output = span_notice("Three four leaf clovers! The slot machine deposits 200 Thalers!")
			winnings = 200

		if (symbol1 == "seven" && symbol2 == "seven" && symbol3 == "seven")
			output = span_notice("Three sevens! The slot machine deposits 500 Thalers!")
			winnings = 500
			celebrate = 1

		if (symbol1 == "diamond" && symbol2 == "diamond" && symbol3 == "diamond")
			output = span_notice("Three diamonds! The slot machine deposits 1000 Thalers!")
			winnings = 1000
			celebrate = 1

		if (symbol1 == "platinum coin" && symbol2 == "platinum coin" && symbol3 == "platinum coin")
			output = span_notice("Three platinum coins! The slot machine deposits a platinum chip!")
			platinumwin = TRUE;
			celebrate = 1

		icon_state = initial(icon_state) // Set it back to the original iconstate.

		if(!output) // Is there anything to output? If not, consider it a loss.
			to_chat(user,"Better luck next time!")
			busy = FALSE
			return

		to_chat(user,output) //Output message

		if(platinumwin) // Did they win the platinum chip?
			new /obj/item/casino_platinum_chip(src.loc)
			playsound(src.loc, 'sound/machines/slotmachine.ogg', 25, 1)

		if(winnings) //Did the person win?
			icon_state = "ntslotmachine_winning"
			playsound(src.loc, 'sound/machines/slotmachine.ogg', 25, 1)
			spawn(delaytime)
				spawn_money(winnings, src.loc)
				icon_state = "ntslotmachine"

		if(celebrate) // Happy celebrations!
			src.confetti_spread = new /datum/effect/effect/system/confetti_spread()
			src.confetti_spread.attach(src) //If somehow people start dragging slot machine
			spawn(0)
				for(var/i = 1 to confetti_strength)
					src.confetti_spread.start()
					sleep(10)

		busy = FALSE
