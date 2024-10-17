/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/

#define NO_SCREEN 0
#define CHANGE_SECURITY_LEVEL 1
#define TRANSFER_FUNDS 2
#define VIEW_TRANSACTION_LOGS 3

/obj/item/card/id/var/money = 2000

/obj/machinery/atm
	name = "Automatic Teller Machine"
	desc = "For all your monetary needs!"
	icon = 'icons/obj/terminals_vr.dmi' //VOREStation Edit
	icon_state = "atm"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	circuit =  /obj/item/circuitboard/atm
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/card/held_card
	var/editing_security_level = 0
	var/view_screen = NO_SCREEN
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

	for(var/obj/item/spacecash/S in src)
		S.loc = src.loc
		if(prob(50))
			playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(src, 'sound/items/polaroid2.ogg', 50, 1)
		break

/obj/machinery/atm/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		return

	//short out the machine, shoot sparks, spew money!
	emagged = 1
	spark_system.start()
	spawn_money(rand(100,500),src.loc)
	//we don't want to grief people by locking their id in an emagged ATM
	release_held_id(user)

	//display a message to the user
	var/response = pick("Initiating withdraw. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.","PIN Code accepted! Emptying account balance.", "Jackpot!")
	to_chat(user, span_warning("[icon2html(src, user.client)] The [src] beeps: \"[response]\""))
	return 1

/obj/machinery/atm/attackby(obj/item/I as obj, mob/user as mob)
	if(computer_deconstruction_screwdriver(user, I))
		return
	if(istype(I, /obj/item/card))
		if(emagged > 0)
			//prevent inserting id into an emagged ATM
			to_chat(user, span_boldwarning("[icon2html(src, user.client)] CARD READER ERROR. This system has been compromised!"))
			return
		else if(istype(I,/obj/item/card/emag))
			I.resolve_attackby(src, user)
			return

		var/obj/item/card/id/idcard = I
		if(!held_card)
			usr.drop_item()
			idcard.loc = src
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
	else if(authenticated_account)
		if(istype(I,/obj/item/spacecash))
			//consume the money
			authenticated_account.money += I:worth
			if(prob(50))
				playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(src, 'sound/items/polaroid2.ogg', 50, 1)

			//create a transaction log entry
			var/datum/transaction/T = new()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Credit deposit"
			T.amount = I:worth
			T.source_terminal = machine_id
			T.date = current_date_string
			T.time = stationtime2text()
			authenticated_account.transaction_log.Add(T)

			to_chat(user, span_info("You insert [I] into [src]."))
			src.attack_hand(user)
			qdel(I)
	else
		..()

/obj/machinery/atm/tgui_status(mob/user)
	. = ..()
	if(issilicon(user))
		return STATUS_CLOSE

/obj/machinery/atm/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AutomatedTellerMachine", name)
		ui.open()

/obj/machinery/atm/tgui_static_data(mob/user)
	var/list/data = ..()
	data["machine_id"] = machine_id
	return data

/obj/machinery/atm/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["emagged"] = emagged
	if(emagged > 0)
		return data

	data["held_card"] = held_card
	data["locked_down"] = ticks_left_locked_down
	if(ticks_left_locked_down > 0)
		return data

	data["authenticated_account"] = null
	data["suspended"] = FALSE
	if(authenticated_account)
		if(authenticated_account.suspended)
			data["suspended"] = TRUE
			return data

		var/list/transactions = list()
		for(var/datum/transaction/T as anything in authenticated_account.transaction_log)
			UNTYPED_LIST_ADD(transactions, list(
				"date" = T.date,
				"time" = T.time,
				"target_name" = T.target_name,
				"purpose" = T.purpose,
				"amount" = T.amount,
				"source_terminal" = T.source_terminal
			))

		data["authenticated_account"] = list(
			"owner_name" = authenticated_account.owner_name,
			"money" = authenticated_account.money,
			"security_level" = authenticated_account.security_level,
			"transactions" = transactions,
		)

	return data

/obj/machinery/atm/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		// This is also a logout
		if("insert_card")
			if(held_card)
				release_held_id(usr)
			else
				if(emagged > 0)
					to_chat(usr, span_boldwarning("[icon2html(src, usr.client)] The ATM card reader rejected your ID because this machine has been sabotaged!"))
				else
					var/obj/item/I = usr.get_active_hand()
					if(istype(I, /obj/item/card/id))
						usr.drop_item(src)
						held_card = I
			. = TRUE

		if("logout")
			if(held_card)
				release_held_id(usr)
			authenticated_account = null
			. = TRUE

		// Balance statement
		if("balance_statement")
			if(!authenticated_account)
				return

			var/obj/item/paper/R = new(loc)
			R.name = "Account balance: [authenticated_account.owner_name]"
			R.info = span_bold("NT Automated Teller Account Statement") + "<br><br>"
			R.info += span_italics("Account holder:") + " [authenticated_account.owner_name]<br>"
			R.info += span_italics("Account number:") + " [authenticated_account.account_number]<br>"
			R.info += span_italics("Balance:") + " $[authenticated_account.money]<br>"
			R.info += span_italics("Date and time:") + " [stationtime2text()], [current_date_string]<br><br>"
			R.info += span_italics("Service terminal ID:") + " [machine_id]<br>"

			//stamp the paper
			var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
			stampoverlay.icon_state = "paper_stamp-cent"
			if(!R.stamped)
				R.stamped = new
			R.stamped += /obj/item/stamp
			R.add_overlay(stampoverlay)
			R.stamps += "<HR>" + span_italics("This paper has been stamped by the Automatic Teller Machine.")

			if(prob(50))
				playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(src, 'sound/items/polaroid2.ogg', 50, 1)
			. = TRUE

		// Transaction logs
		if("print_transaction")
			if(!authenticated_account)
				return

			var/obj/item/paper/R = new(loc)
			R.name = "Transaction logs: [authenticated_account.owner_name]"
			R.info = span_bold("Transaction logs") + "<br>"
			R.info += span_italics("Account holder:") + " [authenticated_account.owner_name]<br>"
			R.info += span_italics("Account number:") + " [authenticated_account.account_number]<br>"
			R.info += span_italics("Date and time:") + " [stationtime2text()], [current_date_string]<br><br>"
			R.info += span_italics("Service terminal ID:") + " [machine_id]<br>"
			R.info += "<table border=1 style='width:100%'>"
			R.info += "<tr>"
			R.info += "<td>" + span_bold("Date") + "</td>"
			R.info += "<td>" + span_bold("Time") + "</td>"
			R.info += "<td>" + span_bold("Target") + "</td>"
			R.info += "<td>" + span_bold("Purpose") + "</td>"
			R.info += "<td>" + span_bold("Value") + "</td>"
			R.info += "<td>" + span_bold("Source terminal ID") + "</td>"
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
			R.stamped += /obj/item/stamp
			R.add_overlay(stampoverlay)
			R.stamps += "<HR>" + span_italics("This paper has been stamped by the Automatic Teller Machine.")

			if(prob(50))
				playsound(src, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(src, 'sound/items/polaroid2.ogg', 50, 1)
			. = TRUE

		if("change_security_level")
			if(authenticated_account)
				var/new_sec_level = clamp(text2num(params["new_security_level"]), 0, 2)
				authenticated_account.security_level = new_sec_level
			. = TRUE

		if("attempt_auth")
			if(ticks_left_locked_down)
				return
			var/tried_account_num = held_card ? held_card.associated_account_number : text2num(params["account_num"])
			var/tried_pin = text2num(params["account_pin"])

			// check if they have low security enabled
			if(!tried_account_num)
				scan_user(usr)
			else
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
						to_chat(usr, span_warning("[icon2html(src, usr.client)] Incorrect pin/account combination entered, [max_pin_attempts - number_incorrect_tries] attempts remaining."))
						previous_account_number = tried_account_num
						playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
				else
					to_chat(usr, span_warning("[icon2html(src, usr.client)] incorrect pin/account combination entered."))
					number_incorrect_tries = 0
			else
				playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
				ticks_left_timeout = 120
				view_screen = NO_SCREEN

				//create a transaction log entry
				var/datum/transaction/T = new()
				T.target_name = authenticated_account.owner_name
				T.purpose = "Remote terminal access"
				T.source_terminal = machine_id
				T.date = current_date_string
				T.time = stationtime2text()
				authenticated_account.transaction_log.Add(T)

				to_chat(usr, span_notice("[icon2html(src, usr.client)] Access granted. Welcome user '[authenticated_account.owner_name].'"))

			previous_account_number = tried_account_num
			. = TRUE

		if("transfer")
			if(!authenticated_account)
				return
			var/transfer_amount = text2num(params["funds_amount"])
			transfer_amount = round(transfer_amount, 0.01)
			if(transfer_amount <= 0)
				tgui_alert_async(usr, "That is not a valid amount.")
			else if(transfer_amount <= authenticated_account.money)
				var/target_account_number = text2num(params["target_acc_number"])
				var/transfer_purpose = params["purpose"]
				if(charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
					to_chat(usr, "[icon2html(src, usr.client)]" + span_info("Funds transfer successful."))
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
					to_chat(usr, "[icon2html(src, usr.client)]" + span_warning("Funds transfer failed."))

			else
				to_chat(usr, "[icon2html(src, usr.client)]" + span_warning("You don't have enough funds to do that!"))
			. = TRUE

		if("e_withdrawal")
			var/amount = max(text2num(params["funds_amount"]),0)
			amount = round(amount, 0.01)
			if(amount <= 0)
				tgui_alert_async(usr, "That is not a valid amount.")
				return

			if(!authenticated_account)
				return

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
				to_chat(usr, "[icon2html(src, usr.client)]" + span_warning("You don't have enough funds to do that!"))
			. = TRUE

		if("withdrawal")
			var/amount = max(text2num(params["funds_amount"]),0)
			amount = round(amount, 0.01)
			if(amount <= 0)
				tgui_alert_async(usr, "That is not a valid amount.")
				return

			if(!authenticated_account)
				return

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
				to_chat(usr, "[icon2html(src, usr.client)]" + span_warning("You don't have enough funds to do that!"))
			. = TRUE

	if(.)
		playsound(src, "keyboard", 50, TRUE)

/obj/machinery/atm/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/silicon))
		to_chat (user, span_warning("A firewall prevents you from interfacing with this device!"))
		return
	if(get_dist(src,user) <= 1)
		tgui_interact(user)

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user as mob)
	if(!authenticated_account)
		if(human_user.wear_id)
			var/obj/item/card/id/I
			if(istype(human_user.wear_id, /obj/item/card/id) )
				I = human_user.wear_id
			else if(istype(human_user.wear_id, /obj/item/pda) )
				var/obj/item/pda/P = human_user.wear_id
				I = P.id
			if(I)
				authenticated_account = attempt_account_access(I.associated_account_number)

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
	var/obj/item/spacecash/ewallet/E = new /obj/item/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name

#undef NO_SCREEN
#undef CHANGE_SECURITY_LEVEL
#undef TRANSFER_FUNDS
#undef VIEW_TRANSACTION_LOGS
