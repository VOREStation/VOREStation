/obj/item/retail_scanner
	name = "retail scanner"
	desc = "Swipe your ID card to make purchases electronically."
	icon = 'icons/obj/device.dmi'
	icon_state = "retail_idle"
	flags = NOBLUDGEON
	slot_flags = SLOT_BELT
	req_access = list(access_heads)
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1)

	var/locked = 1
	var/emagged = 0
	var/machine_id = ""
	var/transaction_amount = 0 // cumulatd amount of money to pay in a single purchase
	var/transaction_purpose = null // text that gets used in ATM transaction logs
	var/list/transaction_logs = list() // list of strings using html code to visualise data
	var/list/item_list = list()  // entities and according
	var/list/price_list = list() // prices for each purchase

	var/obj/item/confirm_item
	var/datum/money_account/linked_account
	var/account_to_connect = null


// Claim machine ID
/obj/item/retail_scanner/New()
	machine_id = "[station_name()] RETAIL #[num_financial_terminals++]"
	if(locate(/obj/structure/table) in loc)
		pixel_y = 3
	transaction_devices += src // Global reference list to be properly set up by /proc/setup_economy()


// Always face the user when put on a table
/obj/item/retail_scanner/afterattack(atom/movable/AM, mob/user, proximity)
	if(!proximity)	return
	if(istype(AM, /obj/structure/table))
		src.pixel_y = 3 // Shift it up slightly to look better on table
		src.dir = get_dir(src, user)
	else
		scan_item_price(AM)

// Reset dir when picked back up
/obj/item/retail_scanner/pickup(mob/user)
	src.dir = SOUTH
	src.pixel_y = 0


/obj/item/retail_scanner/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)


/obj/item/retail_scanner/AltClick(var/mob/user)
	if(Adjacent(user))
		user.set_machine(src)
		interact(user)

/obj/item/retail_scanner/examine(mob/user as mob)
	. = ..()
	if(transaction_amount)
		. += "It has a purchase of [transaction_amount] pending[transaction_purpose ? " for [transaction_purpose]" : ""]."

/obj/item/retail_scanner/interact(mob/user as mob)
	var/dat = "<h2>Retail Scanner<hr></h2>"
	if (locked)
		dat += "<a href='byond://?src=\ref[src];choice=toggle_lock'>Unlock</a><br>"
		dat += "Linked account: <b>[linked_account ? linked_account.owner_name : "None"]</b><br>"
	else
		dat += "<a href='byond://?src=\ref[src];choice=toggle_lock'>Lock</a><br>"
		dat += "Linked account: <a href='byond://?src=\ref[src];choice=link_account'>[linked_account ? linked_account.owner_name : "None"]</a><br>"
	dat += "<a href='byond://?src=\ref[src];choice=custom_order'>Custom Order</a><hr>"

	if(item_list.len)
		dat += get_current_transaction()
		dat += "<br>"

	for(var/i=transaction_logs.len, i>=1, i--)
		dat += "[transaction_logs[i]]<br>"

	if(transaction_logs.len)
		dat += locked ? "<br>" : "<a href='byond://?src=\ref[src];choice=reset_log'>Reset Log</a><br>"
		dat += "<br>"
	dat += "<i>Device ID:</i> [machine_id]"
	user << browse(dat, "window=retail;size=350x500")
	onclose(user, "retail")


/obj/item/retail_scanner/Topic(var/href, var/href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["choice"])
		switch(href_list["choice"])
			if("toggle_lock")
				if(allowed(usr))
					locked = !locked
				else
					to_chat(usr, "[icon2html(src, usr.client)]" + span_warning("Insufficient access."))
			if("link_account")
				var/attempt_account_num = tgui_input_number(usr, "Enter account number", "New account number")
				var/attempt_pin = tgui_input_number(usr, "Enter PIN", "Account PIN")
				linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
				if(linked_account)
					if(linked_account.suspended)
						linked_account = null
						src.visible_message("[icon2html(src,viewers(src))]" + span_warning("Account has been suspended."))
				else
					to_chat(usr, "[icon2html(src, usr.client)]" + span_warning("Account not found."))
			if("custom_order")
				var/t_purpose = sanitize(tgui_input_text(usr, "Enter purpose", "New purpose"))
				if (!t_purpose || !Adjacent(usr)) return
				transaction_purpose = t_purpose
				item_list += t_purpose
				var/t_amount = round(tgui_input_number(usr, "Enter price", "New price"))
				if (!t_amount || !Adjacent(usr)) return
				transaction_amount += t_amount
				price_list += t_amount
				playsound(src, 'sound/machines/twobeep.ogg', 25)
				src.visible_message("[icon2html(src,viewers(src))][transaction_purpose]: [t_amount] Thaler\s.")
			if("set_amount")
				var/item_name = locate(href_list["item"])
				var/n_amount = round(tgui_input_number(usr, "Enter amount", "New amount", 0, 20, 0))
				n_amount = CLAMP(n_amount, 0, 20)
				if (!item_list[item_name] || !Adjacent(usr)) return
				transaction_amount += (n_amount - item_list[item_name]) * price_list[item_name]
				if(!n_amount)
					item_list -= item_name
					price_list -= item_name
				else
					item_list[item_name] = n_amount
			if("subtract")
				var/item_name = locate(href_list["item"])
				if(item_name)
					transaction_amount -= price_list[item_name]
					item_list[item_name]--
					if(item_list[item_name] <= 0)
						item_list -= item_name
						price_list -= item_name
			if("add")
				var/item_name = locate(href_list["item"])
				if(item_list[item_name] >= 20) return
				transaction_amount += price_list[item_name]
				item_list[item_name]++
			if("clear")
				var/item_name = locate(href_list["item"])
				if(item_name)
					transaction_amount -= price_list[item_name] * item_list[item_name]
					item_list -= item_name
					price_list -= item_name
				else
					transaction_amount = 0
					item_list.Cut()
					price_list.Cut()
			if("reset_log")
				transaction_logs.Cut()
				to_chat(usr, "[icon2html(src, usr.client)]" + span_notice("Transaction log reset."))
	updateDialog()



/obj/item/retail_scanner/attackby(obj/O as obj, user as mob)
	// Check for a method of paying (ID, PDA, e-wallet, cash, ect.)
	var/obj/item/card/id/I = O.GetID()
	if(I)
		scan_card(I, O)
	else if (istype(O, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = O
		scan_wallet(E)
	else if (istype(O, /obj/item/spacecash))
		to_chat(usr, span_warning("This device does not accept cash."))

	else if(istype(O, /obj/item/card/emag))
		return ..()
	// Not paying: Look up price and add it to transaction_amount
	else
		scan_item_price(O)


/obj/item/retail_scanner/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];clickitem=\ref[src]>Swipe card or item.</a>",1)


/obj/item/retail_scanner/proc/confirm(var/obj/item/I)
	if(confirm_item == I)
		return 1
	else
		confirm_item = I
		src.visible_message("[icon2html(src,viewers(src))]<b>Total price:</b> [transaction_amount] Thaler\s. Swipe again to confirm.")
		playsound(src, 'sound/machines/twobeep.ogg', 25)
		return 0


/obj/item/retail_scanner/proc/scan_card(var/obj/item/card/id/I, var/obj/item/ID_container)
	if (!transaction_amount)
		return

	if((item_list.len > 1 || item_list[item_list[1]] > 1) && !confirm(I))
		return

	if (!linked_account)
		usr.visible_message("[icon2html(src,viewers(src))]" + span_warning("Unable to connect to linked account."))
		return

	// Access account for transaction
	if(check_account())
		var/datum/money_account/D = get_account(I.associated_account_number)
		var/attempt_pin = ""
		if(D && D.security_level)
			attempt_pin = tgui_input_number(usr, "Enter PIN", "Transaction")
			D = null
		D = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!D)
			src.visible_message("[icon2html(src,viewers(src))]" + span_warning("Unable to access account. Check security settings and try again."))
		else
			if(D.suspended)
				src.visible_message("[icon2html(src,viewers(src))]" + span_warning("Your account has been suspended."))
			else
				if(transaction_amount > D.money)
					src.visible_message("[icon2html(src,viewers(src))]" + span_warning("Not enough funds."))
				else
					// Transfer the money
					D.money -= transaction_amount
					linked_account.money += transaction_amount

					// Create log entry in client's account
					var/datum/transaction/T = new()
					T.target_name = "[linked_account.owner_name]"
					T.purpose = transaction_purpose
					T.amount = "([transaction_amount])"
					T.source_terminal = machine_id
					T.date = current_date_string
					T.time = stationtime2text()
					D.transaction_log.Add(T)

					// Create log entry in owner's account
					T = new()
					T.target_name = D.owner_name
					T.purpose = transaction_purpose
					T.amount = "[transaction_amount]"
					T.source_terminal = machine_id
					T.date = current_date_string
					T.time = stationtime2text()
					linked_account.transaction_log.Add(T)

					// Save log
					add_transaction_log(I.registered_name ? I.registered_name : "n/A", "ID Card", transaction_amount)

					// Confirm and reset
					transaction_complete()


/obj/item/retail_scanner/proc/scan_wallet(var/obj/item/spacecash/ewallet/E)
	if (!transaction_amount)
		return

	if((item_list.len > 1 || item_list[item_list[1]] > 1) && !confirm(E))
		return

	// Access account for transaction
	if(check_account())
		if(transaction_amount > E.worth)
			src.visible_message("[icon2html(src,viewers(src))]" + span_warning("Not enough funds."))
		else
			// Transfer the money
			E.worth -= transaction_amount
			linked_account.money += transaction_amount

			// Create log entry in owner's account
			var/datum/transaction/T = new()
			T.target_name = E.owner_name
			T.purpose = transaction_purpose
			T.amount = "[transaction_amount]"
			T.source_terminal = machine_id
			T.date = current_date_string
			T.time = stationtime2text()
			linked_account.transaction_log.Add(T)

			// Save log
			add_transaction_log(E.owner_name, "E-Wallet", transaction_amount)

			// Confirm and reset
			transaction_complete()


/obj/item/retail_scanner/proc/scan_item_price(var/obj/O)
	if(!istype(O))	return
	if(item_list.len > 10)
		src.visible_message("[icon2html(src,viewers(src))]" + span_warning("Only up to ten different items allowed per purchase."))
		return

	// First check if item has a valid price
	var/price = O.get_item_cost()
	if(isnull(price))
		src.visible_message("[icon2html(src,viewers(src))]" + span_warning("Unable to find item in database."))
		return
	// Call out item cost
	src.visible_message("[icon2html(src,viewers(src))]\A [O]: [price ? "[price] Thaler\s" : "free of charge"].")
	// Note the transaction purpose for later use
	if(transaction_purpose)
		transaction_purpose += "<br>"
	transaction_purpose += "[O]: [price] Thaler\s"
	transaction_amount += price
	for(var/previously_scanned in item_list)
		if(price == price_list[previously_scanned] && O.name == previously_scanned)
			. = item_list[previously_scanned]++
	if(!.)
		item_list[O.name] = 1
		price_list[O.name] = price
		. = 1
	// Animation and sound
	flick("retail_scan", src)
	playsound(src, 'sound/machines/twobeep.ogg', 25)
	// Reset confirmation
	confirm_item = null


/obj/item/retail_scanner/proc/get_current_transaction()
	var/dat = {"
	<head><style>
		.tx-title-r {text-align: center; background-color:#ffdddd; font-weight: bold}
		.tx-name-r {background-color: #eebbbb}
		.tx-data-r {text-align: right; background-color: #ffcccc;}
	</head></style>
	<table width=300>
	<tr><td colspan="2" class="tx-title-r">New Entry</td></tr>
	<tr></tr>"}
	var/item_name
	for(var/i=1, i<=item_list.len, i++)
		item_name = item_list[i]
		dat += "<tr><td class=\"tx-name-r\">[item_list[item_name] ? "<a href='byond://?src=\ref[src];choice=subtract;item=\ref[item_name]'>-</a> <a href='byond://?src=\ref[src];choice=set_amount;item=\ref[item_name]'>Set</a> <a href='byond://?src=\ref[src];choice=add;item=\ref[item_name]'>+</a> [item_list[item_name]] x " : ""][item_name] <a href='byond://?src=\ref[src];choice=clear;item=\ref[item_name]'>Remove</a></td><td class=\"tx-data-r\" width=50>[price_list[item_name] * item_list[item_name]] &thorn</td></tr>"
	dat += "</table><table width=300>"
	dat += "<tr><td class=\"tx-name-r\"><a href='byond://?src=\ref[src];choice=clear'>Clear Entry</a></td><td class=\"tx-name-r\" style='text-align: right'><b>Total Amount: [transaction_amount] &thorn</b></td></tr>"
	dat += "</table></html>"
	return dat


/obj/item/retail_scanner/proc/add_transaction_log(var/c_name, var/p_method, var/t_amount)
	var/dat = {"
	<head><style>
		.tx-title {text-align: center; background-color:#ddddff; font-weight: bold}
		.tx-name {background-color: #bbbbee}
		.tx-data {text-align: right; background-color: #ccccff;}
	</head></style>
	<table width=300>
	<tr><td colspan="2" class="tx-title">Transaction #[transaction_logs.len+1]</td></tr>
	<tr></tr>
	<tr><td class="tx-name">Customer</td><td class="tx-data">[c_name]</td></tr>
	<tr><td class="tx-name">Pay Method</td><td class="tx-data">[p_method]</td></tr>
	<tr><td class="tx-name">Station Time</td><td class="tx-data">[stationtime2text()]</td></tr>
	</table>
	<table width=300>
	"}
	var/item_name
	for(var/i=1, i<=item_list.len, i++)
		item_name = item_list[i]
		dat += "<tr><td class=\"tx-name\">[item_list[item_name] ? "[item_list[item_name]] x " : ""][item_name]</td><td class=\"tx-data\" width=50>[price_list[item_name] * item_list[item_name]] &thorn</td></tr>"
	dat += "<tr></tr><tr><td colspan=\"2\" class=\"tx-name\" style='text-align: right'><b>Total Amount: [transaction_amount] &thorn</b></td></tr>"
	dat += "</table>"

	transaction_logs += dat


/obj/item/retail_scanner/proc/check_account()
	if (!linked_account)
		usr.visible_message("[icon2html(src,viewers(src))]" + span_warning("Unable to connect to linked account."))
		return 0

	if(linked_account.suspended)
		src.visible_message("[icon2html(src,viewers(src))]" + span_warning("Connected account has been suspended."))
		return 0
	return 1


/obj/item/retail_scanner/proc/transaction_complete()
	/// Visible confirmation
	playsound(src, 'sound/machines/chime.ogg', 25)
	src.visible_message("[icon2html(src,viewers(src))]" + span_notice("Transaction complete."))
	flick("retail_approve", src)
	reset_memory()
	updateDialog()


/obj/item/retail_scanner/proc/reset_memory()
	transaction_amount = null
	transaction_purpose = ""
	item_list.Cut()
	price_list.Cut()
	confirm_item = null


/obj/item/retail_scanner/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, span_danger("You stealthily swipe the cryptographic sequencer through \the [src]."))
		playsound(src, "sparks", 50, 1)
		req_access = list()
		emagged = 1

//--Premades--//

/obj/item/retail_scanner/command
	account_to_connect = "Command"

/obj/item/retail_scanner/medical
	account_to_connect = "Medical"

/obj/item/retail_scanner/engineering
	account_to_connect = "Engineering"

/obj/item/retail_scanner/science
	account_to_connect = "Science"

/obj/item/retail_scanner/security
	account_to_connect = "Security"

/obj/item/retail_scanner/cargo
	account_to_connect = "Cargo"

/obj/item/retail_scanner/civilian
	account_to_connect = "Civilian"
