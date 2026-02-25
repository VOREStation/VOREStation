/obj/machinery/cash_register
	name = "cash register"
	desc = "Swipe your ID card to make purchases electronically."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "register_idle"
	flags = NOBLUDGEON
	req_access = list(ACCESS_HEADS)
	anchored = TRUE

	var/locked = 1
	var/cash_locked = 1
	var/cash_open = 0
	var/machine_id = ""
	var/transaction_amount = 0 // cumulatd amount of money to pay in a single purchase
	var/transaction_purpose = null // text that gets used in ATM transaction logs
	var/list/transaction_logs = list() // list of strings using html code to visualise data
	var/list/item_list = list()  // entities and according
	var/list/price_list = list() // prices for each purchase
	var/manipulating = 0

	var/cash_stored = 0
	var/obj/item/confirm_item
	var/datum/money_account/linked_account
	var/account_to_connect = null


// Claim machine ID
/obj/machinery/cash_register/Initialize(mapload)
	machine_id = "[station_name()] RETAIL #[GLOB.num_financial_terminals++]"
	. = ..()
	cash_stored = rand(10, 70)*10
	GLOB.transaction_devices += src // Global reference list to be properly set up by /proc/setup_economy()

/obj/machinery/cash_register/Destroy()
	GLOB.transaction_devices -= src
	. = ..()

/obj/machinery/cash_register/examine(mob/user)
	. = ..(user)
	if(transaction_amount)
		. += "It has a purchase of [transaction_amount] pending[transaction_purpose ? " for [transaction_purpose]" : ""]."
	if(cash_open)
		if(cash_stored)
			. += "It holds [cash_stored] Thaler\s."
		else
			. += "It's completely empty."

/obj/machinery/cash_register/attack_hand(mob/user)
	// Don't be accessible from the wrong side of the machine
	if(get_dir(src, user) & GLOB.reverse_dir[src.dir]) return

	if(cash_open)
		if(cash_stored)
			spawn_money(cash_stored, loc, user)
			cash_stored = 0
			cut_overlay("register_cash")
			return
		open_cash_box(user)
		return
	tgui_interact(user)

/obj/machinery/cash_register/click_alt(mob/user)
	if(Adjacent(user))
		open_cash_box(user)

/obj/machinery/cash_register/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RetailScanner", name)
		ui.open()

/obj/machinery/cash_register/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	return list(
		"locked" = locked,
		"cash_locked" = cash_locked,
		"linked_account" = linked_account?.owner_name,
		"machine_id" = machine_id,
		"transaction_logs" = transaction_logs,
		"current_transactioon" = get_current_transaction()
	)

/obj/machinery/cash_register/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
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

/obj/machinery/cash_register/proc/access_action(action, list/params, mob/user)
	if(locked)
		return FALSE

	switch(action)
		if("toggle_cash_lock")
			cash_locked = !cash_locked
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

/obj/machinery/cash_register/attackby(obj/item/O, mob/user)
	// Check for a method of paying (ID, PDA, e-wallet, cash, ect.)
	var/obj/item/card/id/I = O.GetID()
	if(I)
		scan_card(I, O, user)
	else if (istype(O, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = O
		scan_wallet(E, user)
	else if (istype(O, /obj/item/spacecash))
		var/obj/item/spacecash/SC = O
		if(cash_open)
			to_chat(user, "You neatly sort the cash into the box.")
			cash_stored += SC.worth
			add_overlay("register_cash")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.drop_from_inventory(SC)
			qdel(SC)
		else
			scan_cash(SC, user)
	else if(istype(O, /obj/item/card/emag))
		return ..()
	else if(istype(O) && O.has_tool_quality(TOOL_WRENCH))
		var/obj/item/tool/wrench/W = O
		toggle_anchors(W, user)
	// Not paying: Look up price and add it to transaction_amount
	else
		scan_item_price(O, user)


/obj/machinery/cash_register/MouseDrop_T(atom/dropping, mob/user)
	if(!isobj(dropping))
		return
	if(Adjacent(dropping) && Adjacent(user) && !user.stat)
		attackby(dropping, user)


/obj/machinery/cash_register/proc/confirm(obj/item/I)
	if(confirm_item == I)
		return 1
	else
		confirm_item = I
		src.visible_message(span_infoplain("[icon2html(src,viewers(src))]" + span_bold("Total price:") + " [transaction_amount] Thaler\s. Swipe again to confirm."))
		playsound(src, 'sound/machines/twobeep.ogg', 25)
		return 0


/obj/machinery/cash_register/proc/scan_card(obj/item/card/id/I, obj/item/ID_container, mob/user)
	if (!transaction_amount)
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		to_chat(user, "[icon2html(src, user.client)]" + span_warning("The cash box is open."))
		return

	if((item_list.len > 1 || item_list[item_list[1]] > 1) && !confirm(I))
		return

	if (!linked_account)
		user.visible_message("[icon2html(src,viewers(src))]" + span_warning("Unable to connect to linked account."))
		return

	// Access account for transaction
	if(check_account(user))
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

/obj/machinery/cash_register/proc/scan_wallet(obj/item/spacecash/ewallet/E, mob/user)
	if (!transaction_amount)
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		to_chat(user, "[icon2html(src, user.client)]" + span_warning("The cash box is open."))
		return

	if((item_list.len > 1 || item_list[item_list[1]] > 1) && !confirm(E))
		return

	// Access account for transaction
	if(check_account(user))
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
			T.date = GLOB.current_date_string
			T.time = stationtime2text()
			linked_account.transaction_log.Add(T)

			// Save log
			add_transaction_log(E.owner_name, "E-Wallet", transaction_amount)

			// Confirm and reset
			transaction_complete()

/obj/machinery/cash_register/proc/scan_cash(obj/item/spacecash/SC, mob/user)
	if (!transaction_amount)
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		to_chat(user, "[icon2html(src, user.client)]" + span_warning("The cash box is open."))
		return

	if((item_list.len > 1 || item_list[item_list[1]] > 1) && !confirm(SC))
		return

	if(transaction_amount > SC.worth)
		src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Not enough money."))
	else
		// Insert cash into magical slot
		SC.worth -= transaction_amount
		SC.update_icon()
		if(!SC.worth)
			if(ishuman(SC.loc))
				var/mob/living/carbon/human/H = SC.loc
				H.drop_from_inventory(SC)
			qdel(SC)
		cash_stored += transaction_amount

		// Save log
		add_transaction_log("n/A", "Cash", transaction_amount)

		// Confirm and reset
		transaction_complete()

/obj/machinery/cash_register/proc/scan_item_price(obj/O, mob/user)
	if(!istype(O))	return
	if(item_list.len > 10)
		src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Only up to ten different items allowed per purchase."))
		return
	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		to_chat(user, "[icon2html(src, user.client)]" + span_warning("The cash box is open."))
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
	playsound(src, 'sound/machines/twobeep.ogg', 25)
	// Reset confirmation
	confirm_item = null

/obj/machinery/cash_register/proc/get_current_transaction()
	if(!length(item_list))
		return list()

	var/list/current_transactioon = list(
		"items" = item_list,
		"prices" = price_list,
		"amount" = transaction_amount,

	)
	return current_transactioon

/obj/machinery/cash_register/proc/add_transaction_log(c_name, p_method, t_amount)
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


/obj/machinery/cash_register/proc/check_account(mob/user)
	if (!linked_account)
		user.visible_message("[icon2html(src, viewers(src))]" + span_warning("Unable to connect to linked account."))
		return FALSE

	if(linked_account.suspended)
		src.visible_message("[icon2html(src, viewers(src))]" + span_warning("Connected account has been suspended."))
		return FALSE
	return TRUE

/obj/machinery/cash_register/proc/transaction_complete()
	/// Visible confirmation
	playsound(src, 'sound/machines/chime.ogg', 25)
	src.visible_message("[icon2html(src, viewers(src))]" + span_notice("Transaction complete."))
	flick("register_approve", src)
	reset_memory()

/obj/machinery/cash_register/proc/reset_memory()
	transaction_amount = null
	transaction_purpose = ""
	item_list.Cut()
	price_list.Cut()
	confirm_item = null

/obj/machinery/cash_register/verb/open_cash_box(mob/user)
	set category = "Object"
	set name = "Open Cash Box"
	set desc = "Open/closes the register's cash box."
	set src in view(1)

	if(user.stat) return

	if(cash_open)
		cash_open = 0
		cut_overlay("register_approve")
		cut_overlay("register_open")
		cut_overlay("register_cash")
	else if(!cash_locked)
		cash_open = 1
		add_overlay("register_approve")
		add_overlay("register_open")
		if(cash_stored)
			add_overlay("register_cash")
	else
		to_chat(user, span_warning("The cash box is locked."))


/obj/machinery/cash_register/proc/toggle_anchors(obj/item/tool/wrench/W, mob/user)
	if(manipulating) return
	manipulating = 1
	if(!anchored)
		user.visible_message("\The [user] begins securing \the [src] to the floor.",
							"You begin securing \the [src] to the floor.")
	else
		user.visible_message(span_warning("\The [user] begins unsecuring \the [src] from the floor."),
							"You begin unsecuring \the [src] from the floor.")
	playsound(src, W.usesound, 50, 1)
	if(!do_after(user, 2 SECONDS * W.toolspeed, target = src))
		manipulating = 0
		return
	if(!anchored)
		user.visible_message(span_notice("\The [user] has secured \the [src] to the floor."),
							span_notice("You have secured \the [src] to the floor."))
	else
		user.visible_message(span_warning("\The [user] has unsecured \the [src] from the floor."),
							span_notice("You have unsecured \the [src] from the floor."))
	anchored = !anchored
	manipulating = 0
	return

/obj/machinery/cash_register/emag_act(remaining_charges, mob/user)
	if(!emagged)
		src.visible_message(span_danger("The [src]'s cash box springs open as [user] swipes the card through the scanner!"))
		playsound(src, "sparks", 50, 1)
		req_access = list()
		emagged = 1
		locked = 0
		cash_locked = 0
		open_cash_box(user)


//--Premades--//

/obj/machinery/cash_register/command
	account_to_connect = "Command"

/obj/machinery/cash_register/medical
	account_to_connect = "Medical"

/obj/machinery/cash_register/engineering
	account_to_connect = "Engineering"

/obj/machinery/cash_register/science
	account_to_connect = "Science"

/obj/machinery/cash_register/security
	account_to_connect = "Security"

/obj/machinery/cash_register/cargo
	account_to_connect = "Cargo"

/obj/machinery/cash_register/civilian
	account_to_connect = "Civilian"
