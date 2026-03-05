/obj/item/retail_scanner
	name = "retail scanner"
	desc = "Swipe your ID card to make purchases electronically."
	icon = 'icons/obj/device.dmi'
	icon_state = "retail_idle"
	flags = NOBLUDGEON
	slot_flags = SLOT_BELT
	req_access = list(ACCESS_HEADS)
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1)

	var/locked = 1
	var/emagged = 0
	var/machine_id = ""
	var/transaction_amount = 0 // cumulatd amount of money to pay in a single purchase
	var/transaction_purpose = "" // text that gets used in ATM transaction logs
	var/list/transaction_logs = list() // list of strings using html code to visualise data
	var/list/item_list = list()  // entities and according
	var/list/price_list = list() // prices for each purchase

	var/obj/item/confirm_item
	var/datum/money_account/linked_account
	var/account_to_connect = null

// Claim machine ID
/obj/item/retail_scanner/Initialize(mapload)
	. = ..()
	machine_id = "[station_name()] RETAIL #[GLOB.num_financial_terminals++]"
	if(locate(/obj/structure/table) in loc)
		pixel_y = 3
	GLOB.transaction_devices += src // Global reference list to be properly set up by /proc/setup_economy()

/obj/item/retail_scanner/Destroy()
	GLOB.transaction_devices -= src
	. = ..()

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

/obj/item/retail_scanner/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	tgui_interact(user)

/obj/item/retail_scanner/click_alt(mob/user)
	if(Adjacent(user))
		tgui_interact(user)

/obj/item/retail_scanner/examine(mob/user)
	. = ..()
	if(transaction_amount)
		. += "It has a purchase of [transaction_amount] pending[transaction_purpose ? " for [transaction_purpose]" : ""]."

/obj/item/retail_scanner/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RetailScanner", name)
		ui.open()

/obj/item/retail_scanner/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	return list(
		"locked" = locked,
		"linked_account" = linked_account?.owner_name,
		"machine_id" = machine_id,
		"transaction_logs" = transaction_logs,
		"current_transactioon" = get_current_transaction()
	)

/obj/item/retail_scanner/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle_lock")
			if(allowed(ui.user))
				locked = !locked
				return TRUE
			to_chat(ui.user, "[icon2html(src, ui.user.client)]" + span_warning("Insufficient access."))
			return FALSE
	return access_action(action, params, ui.user)

/obj/item/retail_scanner/proc/access_action(action, list/params, mob/user)
	if(locked)
		return FALSE

	switch(action)
		if("link_account")
			var/attempt_account_num = text2num(params["name"])
			if(isnull(attempt_account_num))
				return FALSE
			var/attempt_pin = text2num(params["pin"])
			if(isnull(attempt_pin))
				return FALSE
			linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
			if(linked_account)
				if(linked_account.suspended)
					linked_account = null
					visible_message("[icon2html(src, viewers(src))]" + span_warning("Account has been suspended."))
					return FALSE
				return TRUE
			to_chat(user, "[icon2html(src, user.client)]" + span_warning("Account not found."))
			return FALSE
		if("custom_order")
			var/t_purpose = sanitize(params["purpose"], 200)
			if (!t_purpose)
				return FALSE
			transaction_purpose = t_purpose
			var/amount = params["amount"]
			if(!isnum(amount))
				return FALSE
			amount = CLAMP(amount, 1, 20)
			item_list[t_purpose] = amount
			var/price = params["price"]
			if (!price)
				return FALSE
			transaction_amount += amount * price
			price_list[t_purpose] = price
			playsound(src, 'sound/machines/twobeep.ogg', 25)
			visible_message("[icon2html(src, viewers(src))][transaction_purpose][amount > 1 ? "[amount] x" : ""]: [amount * price] Thaler\s.")
			return TRUE
		if("set_amount")
			var/item_name = params["item"]
			if(!item_name)
				return FALSE
			var/n_amount = text2num(params["amount"])
			if(!isnum(n_amount))
				return FALSE
			n_amount = CLAMP(n_amount, 0, 20)
			if(!item_list[item_name])
				return FALSE
			transaction_amount += (n_amount - item_list[item_name]) * price_list[item_name]
			if(!n_amount)
				item_list -= item_name
				price_list -= item_name
				return TRUE
			item_list[item_name] = n_amount
			return TRUE
		if("subtract")
			var/item_name = params["item"]
			if(!item_name)
				return FALSE
			transaction_amount -= price_list[item_name]
			item_list[item_name]--
			if(item_list[item_name] <= 0)
				item_list -= item_name
				price_list -= item_name
			return TRUE
		if("add")
			var/item_name = params["item"]
			if(!item_name)
				return FALSE
			if(item_list[item_name] >= 20)
				return FALSE
			transaction_amount += price_list[item_name]
			item_list[item_name]++
			return TRUE
		if("clear")
			var/item_name = params["item"]
			if(!item_name)
				return FALSE
			transaction_amount -= price_list[item_name] * item_list[item_name]
			item_list -= item_name
			price_list -= item_name
			return TRUE
		if("clear_entry")
			transaction_amount = 0
			item_list.Cut()
			price_list.Cut()
			return TRUE
		if("reset_log")
			transaction_logs.Cut()
			to_chat(user, "[icon2html(src, user.client)]" + span_notice("Transaction log reset."))
			return TRUE

/obj/item/retail_scanner/attackby(obj/O, mob/user)
	// Check for a method of paying (ID, PDA, e-wallet, cash, ect.)
	var/obj/item/card/id/I = O.GetID()
	if(I)
		scan_card(I, O, user)
	else if (istype(O, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = O
		scan_wallet(E)
	else if (istype(O, /obj/item/spacecash))
		to_chat(user, span_warning("This device does not accept cash."))

	else if(istype(O, /obj/item/card/emag))
		return ..()
	// Not paying: Look up price and add it to transaction_amount
	else
		scan_item_price(O, user)

/obj/item/retail_scanner/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF='byond://?src=\ref[M];clickitem=\ref[src]'>Swipe card or item.</a>",1)

/obj/item/retail_scanner/proc/confirm(obj/item/I)
	if(confirm_item == I)
		return 1
	else
		confirm_item = I
		src.visible_message("[icon2html(src, viewers(src))]<b>Total price:</b> [transaction_amount] Thaler\s. Swipe again to confirm.")
		playsound(src, 'sound/machines/twobeep.ogg', 25)
		return 0


/obj/item/retail_scanner/proc/scan_card(obj/item/card/id/I, obj/item/ID_container, mob/user)
	if (!transaction_amount)
		return

	if((length(item_list) > 1 || item_list[item_list[1]] > 1) && !confirm(I))
		return

	if (!linked_account)
		user.visible_message("[icon2html(src, viewers(src))]" + span_warning("Unable to connect to linked account."))
		return

	// Access account for transaction
	if(check_account())
		var/datum/money_account/D = get_account(I.associated_account_number)
		var/attempt_pin = ""
		if(D && D.security_level)
			attempt_pin = tgui_input_number(user, "Enter PIN", "Transaction")
			D = null
		D = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!D)
			src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Unable to access account. Check security settings and try again."))
		else
			if(D.suspended)
				src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Your account has been suspended."))
			else
				if(transaction_amount > D.money)
					src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Not enough funds."))
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
					T.date = GLOB.current_date_string
					T.time = stationtime2text()
					D.transaction_log.Add(T)

					// Create log entry in owner's account
					T = new()
					T.target_name = D.owner_name
					T.purpose = transaction_purpose
					T.amount = "[transaction_amount]"
					T.source_terminal = machine_id
					T.date = GLOB.current_date_string
					T.time = stationtime2text()
					linked_account.transaction_log.Add(T)

					// Save log
					add_transaction_log(I.registered_name ? I.registered_name : "n/A", "ID Card", transaction_amount)

					// Confirm and reset
					transaction_complete()

/obj/item/retail_scanner/proc/scan_wallet(obj/item/spacecash/ewallet/E)
	if (!transaction_amount)
		return

	if((length(item_list) > 1 || item_list[item_list[1]] > 1) && !confirm(E))
		return

	// Access account for transaction
	if(check_account())
		if(transaction_amount > E.worth)
			src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Not enough funds."))
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
			T.date = GLOB.current_date_string
			T.time = stationtime2text()
			linked_account.transaction_log.Add(T)

			// Save log
			add_transaction_log(E.owner_name, "E-Wallet", transaction_amount)

			// Confirm and reset
			transaction_complete()

/obj/item/retail_scanner/proc/scan_item_price(obj/O)
	if(!istype(O))	return
	if(length(item_list) > 10)
		src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Only up to ten different items allowed per purchase."))
		return

	// First check if item has a valid price
	var/price = O.get_item_cost()
	if(isnull(price))
		src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Unable to find item in database."))
		return
	// Call out item cost
	src.visible_message("[icon2html(src, viewers(src))]\A [O]: [price ? "[price] Thaler\s" : "free of charge"].")
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
	if(!length(item_list))
		return list()

	var/list/current_transactioon = list(
		"items" = item_list,
		"prices" = price_list,
		"amount" = transaction_amount,

	)
	return current_transactioon

/obj/item/retail_scanner/proc/add_transaction_log(c_name, p_method, t_amount)
	var/list/new_entry = list(
		"log_id" = length(transaction_logs) + 1,
		"customer" = c_name,
		"payment_method" = p_method,
		"trans_time" = stationtime2text(),
		"items" = item_list,
		"prices" = price_list,
		"amount" = transaction_amount
	)
	UNTYPED_LIST_ADD(transaction_logs, new_entry)

/obj/item/retail_scanner/proc/check_account()
	if (!linked_account)
		visible_message("[icon2html(src, viewers(src))]" + span_warning("Unable to connect to linked account."))
		return FALSE

	if(linked_account.suspended)
		visible_message("[icon2html(src, viewers(src))]" + span_warning("Connected account has been suspended."))
		return FALSE
	return TRUE

/obj/item/retail_scanner/proc/transaction_complete()
	/// Visible confirmation
	playsound(src, 'sound/machines/chime.ogg', 25)
	visible_message("[icon2html(src, viewers(src))]" + span_notice("Transaction complete."))
	flick("retail_approve", src)
	reset_memory()

/obj/item/retail_scanner/proc/reset_memory()
	transaction_amount = null
	transaction_purpose = ""
	item_list.Cut()
	price_list.Cut()
	confirm_item = null

/obj/item/retail_scanner/emag_act(remaining_charges, mob/user)
	if(emagged)
		return
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
