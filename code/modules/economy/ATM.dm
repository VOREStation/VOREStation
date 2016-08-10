/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/
/obj/item/weapon/card/id/var/money = 2000

/obj/machinery/atm
	name = "Automatic Teller Machine"
	desc = "For all your monetary needs!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	circuit =  /obj/item/weapon/circuitboard/atm
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/account_num = 0
	var/pin_num = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/weapon/card/held_card
	var/editing_security_level = 0
	var/withdrawal_type = 1
	var/withdrawal = 0
	var/target_account_num = 0
	var/transaction_amount = 0
	var/transaction_purpose = 0
	var/view_screen = 0
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/machinery/atm/New()
	..()
	machine_id = "[station_name()] RT #[num_financial_terminals++]"
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/machinery/atm/process()
	if(stat & NOPOWER)
		return

	if(ticks_left_timeout > 0)
		ticks_left_timeout--
		if(ticks_left_timeout <= 0)
			authenticated_account = null
	if(ticks_left_locked_down > 0)
		ticks_left_locked_down--
		if(ticks_left_locked_down <= 0)
			number_incorrect_tries = 0

	for(var/obj/item/weapon/spacecash/S in src)
		S.loc = src.loc
		if(prob(50))
			playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
		break

/obj/machinery/atm/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		return

	//short out the machine, shoot sparks, spew money!
	emagged = 1
	spark_system.start()
	spawn_money(rand(100,500),src.loc)
	//we don't want to grief people by locking their id in an emagged ATM
	release_held_id(user)

	//display a message to the user
	var/response = pick("Initiating withdraw. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.","PIN Code accepted! Emptying account balance.", "Jackpot!")
	user << "<span class='warning'>\icon[src] The [src] beeps: \"[response]\"</span>"
	return 1

/obj/machinery/atm/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver) && circuit)
		user << "<span class='notice'>You start disconnecting the monitor.</span>"
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/frame/A = new /obj/structure/frame( src.loc )
			var/obj/item/weapon/circuitboard/M = new circuit( A )
			A.frame_type = "atm"
			A.pixel_x = pixel_x
			A.pixel_y = pixel_y
			A.circuit = M
			A.anchored = 1
			for (var/obj/C in src)
				C.forceMove(loc)
			user << "<span class='notice'>You disconnect the monitor.</span>"
			A.state = 4
			A.icon_state = "atm_4"
			M.deconstruct(src)
			qdel(src)
		return
	if(istype(I, /obj/item/weapon/card))
		if(emagged > 0)
			//prevent inserting id into an emagged ATM
			user << "\icon[src]<span class='warning'>CARD READER ERROR. This system has been compromised!</span>"
			return
		else if(istype(I,/obj/item/weapon/card/emag))
			I.resolve_attackby(src, user)
			return

		var/obj/item/weapon/card/id/idcard = I
		if(!held_card)
			usr.drop_item()
			idcard.loc = src
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
	else if(authenticated_account)
		if(istype(I,/obj/item/weapon/spacecash))
			//consume the money
			authenticated_account.money += I:worth
			if(prob(50))
				playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

			//create a transaction log entry
			var/datum/transaction/T = new()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Credit deposit"
			T.amount = I:worth
			T.source_terminal = machine_id
			T.date = current_date_string
			T.time = stationtime2text()
			authenticated_account.transaction_log.Add(T)

			user << "<span class='info'>You insert [I] into [src].</span>"
			src.attack_hand(user)
			qdel(I)
	else
		..()

/obj/machinery/atm/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/silicon))
		user << "\icon[src]<span class='warning'>Artificial unit recognized. Artificial units do not currently receive monetary compensation, as per system banking regulation #1005.</span>"
		return
	tg_ui_interact(user)

/obj/machinery/atm/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "atm", "[name] [machine_id]", 550, 650, master_ui, state)
		ui.open()

/obj/machinery/atm/ui_data(mob/user)
	var/list/data = list()
	if(authenticated_account)
		var/list/authAccount = list()
		var/list/transactions = list()
		authAccount["suspended"] = authenticated_account.suspended
		authAccount["securityLevel"] = authenticated_account.security_level
		for(var/datum/transaction/T in authenticated_account.transaction_log)
			var/list/log_list = list()
			log_list["date"] = T.date
			log_list["time"] = T.time
			log_list["target_name"] = T.target_name
			log_list["purpose"] = T.purpose
			log_list["amount"] = T.amount
			log_list["source_terminal"] = T.source_terminal
			transactions[++transactions.len] = log_list
		authAccount["transactionLog"] = transactions
		authAccount["money"] = authenticated_account.money
		authAccount["name"] = authenticated_account.owner_name
		data["authAccount"] = authAccount
	else
		data["authAccount"] = null
	data["emagged"] = emagged
	data["lockdown"] = ticks_left_locked_down > 0 ? TRUE : null
	data["screen"] = view_screen
	data["transactionTargetNumber"] = target_account_num
	data["transactionTargetAmount"] = transaction_amount
	data["transactionPurpose"] = transaction_purpose
	data["card"] = held_card
	data["cardName"] = held_card ? held_card.name : "Insert Card"
	data["account"] = account_num
	data["pin"] = pin_num
	data["withdrawal"] = withdrawal
	data["withdrawalType"] = withdrawal_type

	return data

/obj/machinery/atm/ui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("screen")
			view_screen = text2num(params["new_screen"])

		if("security_level")
			if(authenticated_account)
				var/new_sec_level = max(min(text2num(params["new_security_level"]), 2), 0)
				authenticated_account.security_level = new_sec_level

		if("print")
			if(params["print_type"] == "transaction")
				if(authenticated_account)
					var/obj/item/weapon/paper/R = new(src.loc)
					R.name = "Transaction logs: [authenticated_account.owner_name]"
					R.info = "<b>Transaction logs</b><br>"
					R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
					R.info += "<i>Account number:</i> [authenticated_account.account_number]<br>"
					R.info += "<i>Date and time:</i> [stationtime2text()], [current_date_string]<br><br>"
					R.info += "<i>Service terminal ID:</i> [machine_id]<br>"
					R.info += "<table border=1 style='width:100%'>"
					R.info += "<tr>"
					R.info += "<td><b>Date</b></td>"
					R.info += "<td><b>Time</b></td>"
					R.info += "<td><b>Target</b></td>"
					R.info += "<td><b>Purpose</b></td>"
					R.info += "<td><b>Value</b></td>"
					R.info += "<td><b>Source terminal ID</b></td>"
					R.info += "</tr>"
					for(var/datum/transaction/T in authenticated_account.transaction_log)
						R.info += "<tr>"
						R.info += "<td>[T.date]</td>"
						R.info += "<td>[T.time]</td>"
						R.info += "<td>[T.target_name]</td>"
						R.info += "<td>[T.purpose]</td>"
						R.info += "<td>$[T.amount]</td>"
						R.info += "<td>[T.source_terminal]</td>"
						R.info += "</tr>"
					R.info += "</table>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/weapon/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"

					if(prob(50))
						playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
					else
						playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

			if(params["print_type"] == "balance")
				if(authenticated_account)
					var/obj/item/weapon/paper/R = new(src.loc)
					R.name = "Account balance: [authenticated_account.owner_name]"
					R.info = "<b>NT Automated Teller Account Statement</b><br><br>"
					R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
					R.info += "<i>Account number:</i> [authenticated_account.account_number]<br>"
					R.info += "<i>Balance:</i> $[authenticated_account.money]<br>"
					R.info += "<i>Date and time:</i> [stationtime2text()], [current_date_string]<br><br>"
					R.info += "<i>Service terminal ID:</i> [machine_id]<br>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/weapon/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"

					if(prob(50))
						playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
					else
						playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

		if("input")
			var/response = input("ATM input.", "ATM input.", params["input_current"])
			switch(params["input_name"])
				if("transactiontarget")
					target_account_num = text2num(response)
				if("transactionamount")
					transaction_amount = text2num(response)
				if("transactionpurpose")
					transaction_purpose = response
				if("account")
					account_num = text2num(response)
				if("pin")
					pin_num = text2num(response)
				if("withdrawalamount")
					withdrawal = text2num(response)

		if("submit")
			if(params["submit_type"] == "transaction")
				if(authenticated_account)
					var/transfer_amount = transaction_amount
					transfer_amount = round(transfer_amount, 0.01)
					if(transfer_amount <= 0)
						alert("That is not a valid amount.")
					else if(transfer_amount <= authenticated_account.money)
						var/target_account_number = target_account_num
						var/transfer_purpose = transaction_purpose
						if(charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
							usr << "\icon[src]<span class='info'>Funds transfer successful.</span>"
							authenticated_account.money -= transfer_amount

							//create an entry in the account transaction log
							var/datum/transaction/T = new()
							T.target_name = "Account #[target_account_number]"
							T.purpose = transfer_purpose
							T.source_terminal = machine_id
							T.date = current_date_string
							T.time = stationtime2text()
							T.amount = "([transfer_amount])"
							authenticated_account.transaction_log.Add(T)
						else
							usr << "\icon[src]<span class='warning'>Funds transfer failed.</span>"

					else
						usr << "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>"

			if(params["submit_type"] == "login")
				// check if they have low security enabled
				scan_user(usr)

				if(!ticks_left_locked_down && held_card)
					var/tried_account_num = account_num
					if(!tried_account_num)
						tried_account_num = held_card.associated_account_number
					var/tried_pin = pin_num

					authenticated_account = attempt_account_access(tried_account_num, tried_pin, held_card && held_card.associated_account_number == tried_account_num ? 2 : 1)
					if(!authenticated_account)
						number_incorrect_tries++
						if(previous_account_number == tried_account_num)
							if(number_incorrect_tries > max_pin_attempts)
								//lock down the atm
								ticks_left_locked_down = 30
								playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)

								//create an entry in the account transaction log
								var/datum/money_account/failed_account = get_account(tried_account_num)
								if(failed_account)
									var/datum/transaction/T = new()
									T.target_name = failed_account.owner_name
									T.purpose = "Unauthorised login attempt"
									T.source_terminal = machine_id
									T.date = current_date_string
									T.time = stationtime2text()
									failed_account.transaction_log.Add(T)
							else
								usr << "\icon[src]<span class='warning'>Incorrect pin/account combination entered, [max_pin_attempts - number_incorrect_tries] attempts remaining.</span>"
								previous_account_number = tried_account_num
								playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
						else
							usr << "\icon[src]<span class='warning'>incorrect pin/account combination entered.</span>"
							number_incorrect_tries = 0
					else
						playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
						ticks_left_timeout = 120
						view_screen = "home"

						//create a transaction log entry
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Remote terminal access"
						T.source_terminal = machine_id
						T.date = current_date_string
						T.time = stationtime2text()
						authenticated_account.transaction_log.Add(T)

						usr << "\icon[src]<span class='info'>Access granted. Welcome user '[authenticated_account.owner_name].'</span>"

					previous_account_number = tried_account_num

		if("withdrawal_type")
			withdrawal_type = text2num(params["type"])

		if("withdraw")
			if(withdrawal_type == 1)
				var/amount = max(withdrawal,0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount

						spawn_money(amount,src.loc,usr)

						//create an entry in the account transaction log
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Credit withdrawal"
						T.amount = "([amount])"
						T.source_terminal = machine_id
						T.date = current_date_string
						T.time = stationtime2text()
						authenticated_account.transaction_log.Add(T)
					else
						usr << "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>"

			else if(withdrawal_type == 2)
				var/amount = max(withdrawal,0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount

						//	spawn_money(amount,src.loc)
						spawn_ewallet(amount,src.loc,usr)

						//create an entry in the account transaction log
						var/datum/transaction/T = new()
						T.target_name = authenticated_account.owner_name
						T.purpose = "Credit withdrawal"
						T.amount = "([amount])"
						T.source_terminal = machine_id
						T.date = current_date_string
						T.time = stationtime2text()
						authenticated_account.transaction_log.Add(T)
					else
						usr << "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>"
			else
				usr << "<span class='warning'>Error! Select a withdrawal method!</span>"

			withdrawal = 0

		if("insert_card")
			if(!held_card)
				//this might happen if the user had the browser window open when somebody emagged it
				if(emagged > 0)
					usr << "\icon[src]<span class='warning'>The ATM card reader rejected your ID because this machine has been sabotaged!</span>"
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id))
						usr.drop_item()
						I.loc = src
						held_card = I
			else
				release_held_id(usr)

		if("logout")
			authenticated_account = null
			account_num = 0
			pin_num = 0
			view_screen = 0
			target_account_num = 0
			transaction_purpose = 0
			transaction_amount = 0
			withdrawal = 0

	return TRUE

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user as mob)
	if(!authenticated_account)
		if(human_user.wear_id)
			var/obj/item/weapon/card/id/I
			if(istype(human_user.wear_id, /obj/item/weapon/card/id) )
				I = human_user.wear_id
			else if(istype(human_user.wear_id, /obj/item/device/pda) )
				var/obj/item/device/pda/P = human_user.wear_id
				I = P.id
			if(I)
				authenticated_account = attempt_account_access(I.associated_account_number)
				if(authenticated_account)
					human_user << "\icon[src]<span class='info'>Access granted. Welcome user '[authenticated_account.owner_name].'</span>"

					//create a transaction log entry
					var/datum/transaction/T = new()
					T.target_name = authenticated_account.owner_name
					T.purpose = "Remote terminal access"
					T.source_terminal = machine_id
					T.date = current_date_string
					T.time = stationtime2text()
					authenticated_account.transaction_log.Add(T)

					view_screen = 0

// put the currently held id on the ground or in the hand of the user
/obj/machinery/atm/proc/release_held_id(mob/living/carbon/human/human_user as mob)
	if(!held_card)
		return

	held_card.loc = src.loc
	authenticated_account = null

	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(held_card)
	held_card = null


/obj/machinery/atm/proc/spawn_ewallet(var/sum, loc, mob/living/carbon/human/human_user as mob)
	var/obj/item/weapon/spacecash/ewallet/E = new /obj/item/weapon/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name
