// I placed this here because of how relevant it is.
// You place this in your uplinkable item to check if an uplink is active or not.
// If it is, it will display the uplink menu and return 1, else it'll return false.
// If it returns true, I recommend closing the item's normal menu with "user << browse(null, "window=name")"
/obj/item/proc/active_uplink_check(mob/user as mob)
	// Activates the uplink if it's active
	if(hidden_uplink)
		if(hidden_uplink.active)
			hidden_uplink.trigger(user)
			return TRUE
	return FALSE

/obj/item/device/uplink
	var/welcome = "Welcome, Operative"	// Welcoming menu message
	var/list/ItemsCategory				// List of categories with lists of items
	var/list/ItemsReference				// List of references with an associated item
	var/list/nanoui_items				// List of items for NanoUI use
	var/faction = ""					//Antag faction holder.

	var/offer_time = 10 MINUTES			//The time increment per discount offered
	var/next_offer_time
	var/datum/uplink_item/discount_item	//The item to be discounted
	var/discount_amount					//The amount as a percent the item will be discounted by
	var/compact_mode = FALSE

/obj/item/device/uplink/Initialize(var/mapload)
	. = ..()
	addtimer(CALLBACK(src, .proc/next_offer), offer_time) //It seems like only the /hidden type actually makes use of this...

/obj/item/device/uplink/get_item_cost(var/item_type, var/item_cost)
	return (discount_item && (item_type == discount_item)) ? max(1, round(item_cost*discount_amount)) : item_cost

/obj/item/device/uplink/proc/next_offer()
	return //Stub, used on children.

// HIDDEN UPLINK - Can be stored in anything but the host item has to have a trigger for it.
/* How to create an uplink in 3 easy steps!

 1. All obj/item 's have a hidden_uplink var. By default it's null. Give the item one with "new(src)", it must be in it's contents. Feel free to add "uses".

 2. Code in the triggers. Use check_trigger for this, I recommend closing the item's menu with "usr << browse(null, "window=windowname") if it returns true.
 The var/value is the value that will be compared with the var/target. If they are equal it will activate the menu.

 3. If you want the menu to stay until the users locks his uplink, add an active_uplink_check(mob/user as mob) in your interact/attack_hand proc.
 Then check if it's true, if true return. This will stop the normal menu appearing and will instead show the uplink menu.
*/

/obj/item/device/uplink/hidden
	name = "hidden uplink"
	desc = "There is something wrong if you're examining this."
	var/active = 0
	var/exploit_id								// Id of the current exploit record we are viewing
	var/selected_cat

// The hidden uplink MUST be inside an obj/item's contents.
/obj/item/device/uplink/hidden/Initialize()
	. = ..()
	if(!isitem(loc))
		return INITIALIZE_HINT_QDEL

/obj/item/device/uplink/hidden/next_offer()
	discount_item = default_uplink_selection.get_random_item(INFINITY)
	discount_amount = pick(90;0.9, 80;0.8, 70;0.7, 60;0.6, 50;0.5, 40;0.4, 30;0.3, 20;0.2, 10;0.1)
	next_offer_time = world.time + offer_time
	SStgui.update_uis(src)
	addtimer(CALLBACK(src, .proc/next_offer), offer_time)

// Toggles the uplink on and off. Normally this will bypass the item's normal functions and go to the uplink menu, if activated.
/obj/item/device/uplink/hidden/proc/toggle()
	active = !active

// Directly trigger the uplink. Turn on if it isn't already.
/obj/item/device/uplink/hidden/proc/trigger(mob/user as mob)
	if(!active)
		toggle()
	tgui_interact(user)

// Checks to see if the value meets the target. Like a frequency being a traitor_frequency, in order to unlock a headset.
// If true, it accesses trigger() and returns 1. If it fails, it returns false. Use this to see if you need to close the
// current item's menu.
/obj/item/device/uplink/hidden/proc/check_trigger(mob/user as mob, var/value, var/target)
	if(value == target)
		trigger(user)
		return TRUE
	return FALSE

// Legacy
/obj/item/device/uplink/hidden/interact(mob/user)
	tgui_interact(user)

/*****************
 * Uplink TGUI
 *****************/
/obj/item/device/uplink/tgui_host()
	return loc

/obj/item/device/uplink/hidden/tgui_state(mob/user)
	return GLOB.tgui_deep_inventory_state

/obj/item/device/uplink/hidden/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!active)
		toggle()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Uplink", "Remote Uplink")
		// This UI is only ever opened by one person,
		// and never is updated outside of user input.
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/item/device/uplink/hidden/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	if(!user.mind)
		return

	var/list/data = ..()

	data["telecrystals"] = user.mind.tcrystals
	data["lockable"] = TRUE
	data["compactMode"] = compact_mode

	data["discount_name"] = discount_item ? discount_item.name : ""
	data["discount_amount"] = (1-discount_amount)*100
	data["offer_expiry"] = worldtime2stationtime(next_offer_time)

	data["exploit"] = null
	data["locked_records"] = null

	if(exploit_id)
		for(var/datum/data/record/L in data_core.locked)
			if(L.fields["id"] == exploit_id)
				data["exploit"] = list()  // Setting this to equal L.fields passes it's variables that are lists as reference instead of value.
								 // We trade off being able to automatically add shit for more control over what gets passed to json
								 // and if it's sanitized for html.
				data["exploit"]["nanoui_exploit_record"] = html_encode(L.fields["exploit_record"])                         		// Change stuff into html
				data["exploit"]["nanoui_exploit_record"] = replacetext(data["exploit"]["nanoui_exploit_record"], "\n", "<br>")    // change line breaks into <br>
				data["exploit"]["name"] =  html_encode(L.fields["name"])
				data["exploit"]["sex"] =  html_encode(L.fields["sex"])
				data["exploit"]["age"] =  html_encode(L.fields["age"])
				data["exploit"]["species"] =  html_encode(L.fields["species"])
				data["exploit"]["rank"] =  html_encode(L.fields["rank"])
				data["exploit"]["home_system"] =  html_encode(L.fields["home_system"])
				data["exploit"]["birthplace"] =  html_encode(L.fields["birthplace"])
				data["exploit"]["citizenship"] =  html_encode(L.fields["citizenship"])
				data["exploit"]["faction"] =  html_encode(L.fields["faction"])
				data["exploit"]["religion"] =  html_encode(L.fields["religion"])
				data["exploit"]["fingerprint"] =  html_encode(L.fields["fingerprint"])
				if(L.fields["antagvis"] == ANTAG_KNOWN || (faction == L.fields["antagfac"] && (L.fields["antagvis"] == ANTAG_SHARED)))
					data["exploit"]["antagfaction"] = html_encode(L.fields["antagfac"])
				else
					data["exploit"]["antagfaction"] = html_encode("None")
				break
	else
		var/list/permanentData = list()
		for(var/datum/data/record/L in sortRecord(data_core.locked))
			permanentData.Add(list(list(
				"name" = L.fields["name"],
				"id" = L.fields["id"]
			)))
		data["locked_records"] = permanentData

	return data

/obj/item/device/uplink/hidden/tgui_static_data(mob/user)
	var/list/data = ..()

	data["categories"] = list()
	for(var/datum/uplink_category/category in uplink.categories)
		var/list/cat = list(
				"name" = category.name,
				"items" = (category == selected_cat ? list() : null)
			)
		for(var/datum/uplink_item/item in category.items)
			var/cost = item.cost(src, user) || "???"
			cat["items"] += list(list(
				"name" = item.name,
				"cost" = cost,
				"desc" = item.description(),
				"ref" = REF(item),
			))
		data["categories"] += list(cat)

	return data

/obj/item/device/uplink/hidden/tgui_status(mob/user, datum/tgui_state/state)
	if(!active)
		return STATUS_CLOSE
	return ..()

/obj/item/device/uplink/hidden/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("buy")
			var/datum/uplink_item/UI = (locate(params["ref"]) in uplink.items)
			UI.buy(src, usr)
			return TRUE
		if("lock")
			toggle()
			SStgui.close_uis(src)
		if("select")
			selected_cat = params["category"]
			return TRUE
		if("compact_toggle")
			compact_mode = !compact_mode
			return TRUE
		if("view_exploits")
			exploit_id = params["id"]
			return TRUE

// PRESET UPLINKS
// A collection of preset uplinks.
//
// Includes normal radio uplink, multitool uplink,
// implant uplink (not the implant tool) and a preset headset uplink.
/obj/item/device/radio/uplink/New()
	..()
	hidden_uplink = new(src)
	icon_state = "radio"

/obj/item/device/radio/uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/multitool/uplink/New()
	..()
	hidden_uplink = new(src)

/obj/item/device/multitool/uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/radio/headset/uplink
	traitor_frequency = 1445

/obj/item/device/radio/headset/uplink/New()
	..()
	hidden_uplink = new(src)
