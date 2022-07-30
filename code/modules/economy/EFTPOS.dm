/obj/item/eftpos
	name = "\improper EFTPOS scanner"
	desc = "Swipe your ID card to make purchases electronically."
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"
	var/machine_id = ""
	var/eftpos_name = "Default EFTPOS scanner"
	var/transaction_locked = 0
	var/transaction_paid = 0
	var/transaction_amount = 0
	var/transaction_purpose = "Default charge"
	var/access_code = 0
	var/datum/money_account/linked_account

/obj/item/eftpos/Initialize()
	. = ..()
	//by default, connect to the station account
	//the user of the EFTPOS device can change the target account though, and no-one will be the wiser (except whoever's being charged)
	linked_account = station_account

	machine_id = "[station_name()] EFTPOS #[num_financial_terminals++]"
	access_code = rand(1111,111111)
	print_reference()

	//create a short manual as well
	var/obj/item/paper/R = new(src.loc)
	R.name = "Steps to success: Correct EFTPOS Usage"
	//Temptative new manual:
	R.info += "<b>First EFTPOS setup:</b><br>"
	R.info += "1. Memorise your EFTPOS command code (provided with all EFTPOS devices).<br>"
	R.info += "2. Connect the EFTPOS to the account in which you want to receive the funds.<br><br>"
	R.info += "<b>When starting a new transaction:</b><br>"
	R.info += "1. Enter the amount of money you want to charge and a purpose message for the new transaction.<br>"
	R.info += "2. Lock the new transaction. If you want to modify or cancel the transaction, you simply have to reset your EFTPOS device.<br>"
	R.info += "3. Give the EFTPOS device to your customer, he/she must finish the transaction by swiping their ID card or a charge card with enough funds.<br>"
	R.info += "4. If everything is done correctly, the money will be transferred. To unlock the device you will have to reset the EFTPOS device.<br>"

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.offset_x += 0
	R.offset_y += 0
	R.ico += "paper_stamp-cent"
	R.stamped += /obj/item/stamp
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the EFTPOS device.</i>"

/obj/item/eftpos/Destroy()
	linked_account = null
	return ..()

/obj/item/eftpos/proc/print_reference()
	var/obj/item/paper/R = new(src.loc)
	R.name = "Reference: [eftpos_name]"
	R.info = "<b>[eftpos_name] reference</b><br><br>"
	R.info += "Access code: [access_code]<br><br>"
	R.info += "<b>Do not lose or misplace this code.</b><br>"

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the EFTPOS device.</i>"
	var/obj/item/smallDelivery/D = new(R.loc)
	R.loc = D
	D.wrapped = R
	D.name = "small parcel - 'EFTPOS access code'"

/obj/item/eftpos/attack_self(mob/user as mob)
	if(get_dist(src,user) <= 1)
		var/dat = "<b>[eftpos_name]</b><br>"
		dat += "<i>This terminal is</i> [machine_id]. <i>Report this code when contacting IT Support</i><br>"
		if(transaction_locked)
			dat += "<a href='?src=\ref[src];choice=toggle_lock'>Back[transaction_paid ? "" : " (authentication required)"]</a><br><br>"

			dat += "Transaction purpose: <b>[transaction_purpose]</b><br>"
			dat += "Value: <b>$[transaction_amount]</b><br>"
			dat += "Linked account: <b>[linked_account ? linked_account.owner_name : "None"]</b><hr>"
			if(transaction_paid)
				dat += "<i>This transaction has been processed successfully.</i><hr>"
			else
				dat += "<i>Swipe your card below the line to finish this transaction.</i><hr>"
				dat += "<a href='?src=\ref[src];choice=scan_card'>\[------\]</a>"
		else
			dat += "<a href='?src=\ref[src];choice=toggle_lock'>Lock in new transaction</a><br><br>"

			dat += "<a href='?src=\ref[src];choice=trans_purpose'>Transaction purpose: [transaction_purpose]</a><br>"
			dat += "Value: <a href='?src=\ref[src];choice=trans_value'>$[transaction_amount]</a><br>"
			dat += "Linked account: <a href='?src=\ref[src];choice=link_account'>[linked_account ? linked_account.owner_name : "None"]</a><hr>"
			dat += "<a href='?src=\ref[src];choice=change_code'>Change access code</a><br>"
			dat += "<a href='?src=\ref[src];choice=change_id'>Change EFTPOS ID</a><br>"
			dat += "Scan card to reset access code <a href='?src=\ref[src];choice=reset'>\[------\]</a>"
		user << browse(dat,"window=eftpos")
	else
		user << browse(null,"window=eftpos")

/obj/item/eftpos/attackby(obj/item/O as obj, user as mob)

	var/obj/item/card/id/I = O.GetID()

	if(I)
		if(linked_account)
			scan_card(I, O)
		else
			to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Unable to connect to linked account.</span>")
	else if (istype(O, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = O
		if (linked_account)
			if(!linked_account.suspended)
				if(transaction_locked && !transaction_paid)
					if(transaction_amount <= E.worth)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)
						src.visible_message("\icon[src][bicon(src)] \The [src] chimes.")
						transaction_paid = 1

						//transfer the money
						E.worth -= transaction_amount
						linked_account.money += transaction_amount

						//create entry in the EFTPOS linked account transaction log
						var/datum/transaction/T = new()
						T.target_name = E.owner_name //D.owner_name
						T.purpose = (transaction_purpose ? transaction_purpose : "None supplied.")
						T.amount = transaction_amount
						T.source_terminal = machine_id
						T.date = current_date_string
						T.time = stationtime2text()
						linked_account.transaction_log.Add(T)
					else
						to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>\The [O] doesn't have that much money!</span>")
			else
				to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Connected account has been suspended.</span>")
		else
			to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>EFTPOS is not connected to an account.</span>")

	else
		..()

/obj/item/eftpos/Topic(var/href, var/href_list)
	if(href_list["choice"])
		switch(href_list["choice"])
			if("change_code")
				var/attempt_code = tgui_input_number(usr, "Re-enter the current EFTPOS access code", "Confirm old EFTPOS code")
				if(attempt_code == access_code)
					var/trycode = tgui_input_number(usr, "Enter a new access code for this device (4-6 digits, numbers only)", "Enter new EFTPOS code", null, 999999, 1000)
					if(trycode >= 1000 && trycode <= 999999)
						access_code = trycode
					else
						tgui_alert_async(usr, "That is not a valid code!")
					print_reference()
				else
					to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Incorrect code entered.</span>")
			if("change_id")
				var/attempt_code = text2num(input(usr, "Re-enter the current EFTPOS access code", "Confirm EFTPOS code"))
				if(attempt_code == access_code)
					eftpos_name = sanitize(input(usr, "Enter a new terminal ID for this device", "Enter new EFTPOS ID"), MAX_NAME_LEN) + " EFTPOS scanner"
					print_reference()
				else
					to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Incorrect code entered.</span>")
			if("link_account")
				var/attempt_account_num = tgui_input_number(usr, "Enter account number to pay EFTPOS charges into", "New account number")
				var/attempt_pin = tgui_input_number(usr, "Enter pin code", "Account pin")
				linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
				if(linked_account)
					if(linked_account.suspended)
						linked_account = null
						to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Account has been suspended.</span>")
				else
					to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Account not found.</span>")
			if("trans_purpose")
				var/choice = sanitize(input(usr, "Enter reason for EFTPOS transaction", "Transaction purpose"))
				if(choice) transaction_purpose = choice
			if("trans_value")
				var/try_num = tgui_input_number(usr, "Enter amount for EFTPOS transaction", "Transaction amount")
				if(try_num < 0)
					tgui_alert_async(usr, "That is not a valid amount!")
				else
					transaction_amount = try_num
			if("toggle_lock")
				if(transaction_locked)
					if (transaction_paid)
						transaction_locked = 0
						transaction_paid = 0
					else
						var/attempt_code = tgui_input_number(usr, "Enter EFTPOS access code", "Reset Transaction")
						if(attempt_code == access_code)
							transaction_locked = 0
							transaction_paid = 0
				else if(linked_account)
					transaction_locked = 1
				else
					to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>No account connected to send transactions to.</span>")
			if("scan_card")
				if(linked_account)
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card))
						scan_card(I)
				else
					to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Unable to link accounts.</span>")
			if("reset")
				//reset the access code - requires HoP/captain access
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card))
					var/obj/item/card/id/C = I
					if((access_cent_captain in C.access) || (access_hop in C.access) || (access_captain in C.access))
						access_code = 0
						to_chat(usr, "\icon[src][bicon(src)]<span class='info'>Access code reset to 0.</span>")
				else if (istype(I, /obj/item/card/emag))
					access_code = 0
					to_chat(usr, "\icon[src][bicon(src)]<span class='info'>Access code reset to 0.</span>")

	src.attack_self(usr)

/obj/item/eftpos/proc/scan_card(var/obj/item/card/I, var/obj/item/ID_container)
	if (istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if(I==ID_container || ID_container == null)
			usr.visible_message("<span class='info'>\The [usr] swipes a card through \the [src].</span>")
		else
			usr.visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
		if(transaction_locked && !transaction_paid)
			if(linked_account)
				if(!linked_account.suspended)
					var/attempt_pin = ""
					var/datum/money_account/D = get_account(C.associated_account_number)
					if(D.security_level)
						attempt_pin = tgui_input_number(usr, "Enter pin code", "EFTPOS transaction")
						D = null
					D = attempt_account_access(C.associated_account_number, attempt_pin, 2)
					if(D)
						if(!D.suspended)
							if(transaction_amount <= D.money)
								playsound(src, 'sound/machines/chime.ogg', 50, 1)
								src.visible_message("\icon[src][bicon(src)] \The [src] chimes.")
								transaction_paid = 1

								//transfer the money
								D.money -= transaction_amount
								linked_account.money += transaction_amount

								//create entries in the two account transaction logs
								var/datum/transaction/T = new()
								T.target_name = "[linked_account.owner_name] (via [eftpos_name])"
								T.purpose = transaction_purpose
								if(transaction_amount > 0)
									T.amount = "([transaction_amount])"
								else
									T.amount = "[transaction_amount]"
								T.source_terminal = machine_id
								T.date = current_date_string
								T.time = stationtime2text()
								D.transaction_log.Add(T)
								//
								T = new()
								T.target_name = D.owner_name
								T.purpose = transaction_purpose
								T.amount = "[transaction_amount]"
								T.source_terminal = machine_id
								T.date = current_date_string
								T.time = stationtime2text()
								linked_account.transaction_log.Add(T)
							else
								to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>You don't have that much money!</span>")
						else
							to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Your account has been suspended.</span>")
					else
						to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Unable to access account. Check security settings and try again.</span>")
				else
					to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>Connected account has been suspended.</span>")
			else
				to_chat(usr, "\icon[src][bicon(src)]<span class='warning'>EFTPOS is not connected to an account.</span>")
	else if (istype(I, /obj/item/card/emag))
		if(transaction_locked)
			if(transaction_paid)
				to_chat(usr, "\icon[src][bicon(src)]<span class='info'>You stealthily swipe \the [I] through \the [src].</span>")
				transaction_locked = 0
				transaction_paid = 0
			else
				usr.visible_message("<span class='info'>\The [usr] swipes a card through \the [src].</span>")
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
				src.visible_message("\icon[src][bicon(src)] \The [src] chimes.")
				transaction_paid = 1

	//emag?
