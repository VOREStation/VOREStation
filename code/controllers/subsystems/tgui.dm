 /**
  * tgui subsystem
  *
  * Contains all tgui state and subsystem code.
 **/


SUBSYSTEM_DEF(tgui)
	name = "TGUI"
	wait = 9
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_TGUI
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

<<<<<<< HEAD
	/// A list of UIs scheduled to process
	var/list/current_run = list()
	/// A list of open UIs
	var/list/open_uis = list()
	/// A list of open UIs, grouped by src_object and ui_key.
	var/list/open_uis_by_src = list()
	/// The HTML base used for all UIs.
	var/basehtml
=======
	var/list/currentrun = list()
	var/list/open_uis = list() // A list of open UIs, grouped by src_object and ui_key.
	var/list/processing_uis = list() // A list of processing UIs, ungrouped.
	var/basehtml // The HTML base used for all UIs.
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

/datum/controller/subsystem/tgui/PreInit()
	basehtml = file2text('tgui/packages/tgui/public/tgui.html')

/datum/controller/subsystem/tgui/Shutdown()
	close_all_uis()

/datum/controller/subsystem/tgui/stat_entry()
<<<<<<< HEAD
	..("P:[open_uis.len]")

/datum/controller/subsystem/tgui/fire(resumed = 0)
	if(!resumed)
		src.current_run = open_uis.Copy()
	// Cache for sanic speed (lists are references anyways)
	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/tgui/ui = current_run[current_run.len]
		current_run.len--
		// TODO: Move user/src_object check to process()
		if(ui && ui.user && ui.src_object)
			ui.process()
		else
			open_uis.Remove(ui)
		if(MC_TICK_CHECK)
			return

/**
 * public
 *
 * Requests a usable tgui window from the pool.
 * Returns null if pool was exhausted.
 *
 * required user mob
 * return datum/tgui
 */
/datum/controller/subsystem/tgui/proc/request_pooled_window(mob/user)
	if(!user.client)
		return null
	var/list/windows = user.client.tgui_windows
	var/window_id
	var/datum/tgui_window/window
	var/window_found = FALSE
	// Find a usable window
	for(var/i in 1 to TGUI_WINDOW_HARD_LIMIT)
		window_id = TGUI_WINDOW_ID(i)
		window = windows[window_id]
		// As we are looping, create missing window datums
		if(!window)
			window = new(user.client, window_id, pooled = TRUE)
		// Skip windows with acquired locks
		if(window.locked)
			continue
		if(window.status == TGUI_WINDOW_READY)
			return window
		if(window.status == TGUI_WINDOW_CLOSED)
			window.status = TGUI_WINDOW_LOADING
			window_found = TRUE
			break
	if(!window_found)
		return null
	return window

/**
 * public
 *
 * Force closes all tgui windows.
 *
 * required user mob
 */
/datum/controller/subsystem/tgui/proc/force_close_all_windows(mob/user)
	if(user.client)
		user.client.tgui_windows = list()
		for(var/i in 1 to TGUI_WINDOW_HARD_LIMIT)
			var/window_id = TGUI_WINDOW_ID(i)
			user << browse(null, "window=[window_id]")

/**
 * public
 *
 * Force closes the tgui window by window_id.
 *
 * required user mob
 * required window_id string
 */
/datum/controller/subsystem/tgui/proc/force_close_window(mob/user, window_id)
	// Close all tgui datums based on window_id.
	for(var/datum/tgui/ui in user.tgui_open_uis)
		if(ui.window && ui.window.id == window_id)
			ui.close(can_be_suspended = FALSE)
	// Unset machine just to be sure.
	user.unset_machine()
	// Close window directly just to be sure.
	user << browse(null, "window=[window_id]")

=======
	..("P:[processing_uis.len]")

/datum/controller/subsystem/tgui/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing_uis.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/tgui/ui = currentrun[currentrun.len]
		currentrun.len--
		if(ui && ui.user && ui.src_object)
			ui.process()
		else
			processing_uis.Remove(ui)
		if (MC_TICK_CHECK)
			return

>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
 /**
  * public
  *
  * Get a open UI given a user, src_object, and ui_key and try to update it with data.
  *
  * required user mob The mob who opened/is using the UI.
  * required src_object datum The object/datum which owns the UI.
  * required ui_key string The ui_key of the UI.
<<<<<<< HEAD
  *
  * return datum/tgui The found UI.
 **/
/datum/controller/subsystem/tgui/proc/try_update_ui(
		mob/user,
		datum/src_object,
		datum/tgui/ui)
	// Look up a UI if it wasn't passed.
	if(isnull(ui))
		ui = get_open_ui(user, src_object)
	// Couldn't find a UI.
	if(isnull(ui))
		return null
	ui.process_status()
	// UI ended up with the closed status
	// or is actively trying to close itself.
	// FIXME: Doesn't actually fix the paper bug.
	if(ui.status <= STATUS_CLOSE)
		ui.close()
		return null
	ui.send_update()
	return ui
=======
  * optional ui datum/tgui The UI to be updated, if it exists.
  * optional force_open bool If the UI should be re-opened instead of updated.
  *
  * return datum/tgui The found UI.
 **/
/datum/controller/subsystem/tgui/proc/try_update_ui(mob/user, datum/src_object, ui_key, datum/tgui/ui, force_open = FALSE)
	if(isnull(ui)) // No UI was passed, so look for one.
		ui = get_open_ui(user, src_object, ui_key)

	if(!isnull(ui))
		var/data = src_object.tgui_data(user) // Get data from the src_object.
		if(!force_open) // UI is already open; update it.
			ui.push_data(data)
		else // Re-open it anyways.
			ui.reinitialize(null, data)
		return ui // We found the UI, return it.
	else
		return null // We couldn't find a UI.
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

 /**
  * private
  *
  * Get a open UI given a user, src_object, and ui_key.
  *
  * required user mob The mob who opened/is using the UI.
  * required src_object datum The object/datum which owns the UI.
  * required ui_key string The ui_key of the UI.
  *
  * return datum/tgui The found UI.
 **/
<<<<<<< HEAD
/datum/controller/subsystem/tgui/proc/get_open_ui(mob/user, datum/src_object)
	var/key = "[REF(src_object)]"
	// No UIs opened for this src_object
	if(isnull(open_uis_by_src[key]) || !istype(open_uis_by_src[key], /list))
		return null // No UIs open.
	for(var/datum/tgui/ui in open_uis_by_src[key]) // Find UIs for this object.
		// Make sure we have the right user
		if(ui.user == user)
			return ui
=======
/datum/controller/subsystem/tgui/proc/get_open_ui(mob/user, datum/src_object, ui_key)
	var/src_object_key = "\ref[src_object]"
	if(isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		return null // No UIs open.
	else if(isnull(open_uis[src_object_key][ui_key]) || !istype(open_uis[src_object_key][ui_key], /list))
		return null // No UIs open for this object.

	for(var/datum/tgui/ui in open_uis[src_object_key][ui_key]) // Find UIs for this object.
		if(ui.user == user) // Make sure we have the right user
			return ui

>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
	return null // Couldn't find a UI!

 /**
  * private
  *
  * Update all UIs attached to src_object.
  *
  * required src_object datum The object/datum which owns the UIs.
  *
  * return int The number of UIs updated.
 **/
/datum/controller/subsystem/tgui/proc/update_uis(datum/src_object)
<<<<<<< HEAD
	var/count = 0
	var/key = "[REF(src_object)]"
	if(isnull(open_uis_by_src[key]) || !istype(open_uis_by_src[key], /list))
		return count // Couldn't find any UIs for this object.
	for(var/datum/tgui/ui in open_uis_by_src[key])
		// Check the UI is valid.
		if(ui && ui.src_object && ui.user && ui.src_object.tgui_host(ui.user))
			ui.process(force = 1) // Update the UI.
			count++ // Count each UI we update.
	return count
=======
	var/src_object_key = "\ref[src_object]"
	if(isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		return 0 // Couldn't find any UIs for this object.

	var/update_count = 0
	for(var/ui_key in open_uis[src_object_key])
		for(var/datum/tgui/ui in open_uis[src_object_key][ui_key])
			if(ui && ui.src_object && ui.user && ui.src_object.tgui_host(ui.user)) // Check the UI is valid.
				ui.process(force = 1) // Update the UI.
				update_count++ // Count each UI we update.
	return update_count
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

 /**
  * private
  *
  * Close all UIs attached to src_object.
  *
  * required src_object datum The object/datum which owns the UIs.
  *
  * return int The number of UIs closed.
 **/
/datum/controller/subsystem/tgui/proc/close_uis(datum/src_object)
<<<<<<< HEAD
	var/count = 0
	var/key = "[REF(src_object)]"
	// No UIs opened for this src_object
	if(isnull(open_uis_by_src[key]) || !istype(open_uis_by_src[key], /list))
		return count
	for(var/datum/tgui/ui in open_uis_by_src[key])
		if(ui && ui.src_object && ui.user && ui.src_object.tgui_host(ui.user)) // Check the UI is valid.
			ui.close() // Close the UI.
			count++ // Count each UI we close.
	return count
=======
	var/src_object_key = "\ref[src_object]"
	if(isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		return 0 // Couldn't find any UIs for this object.

	var/close_count = 0
	for(var/ui_key in open_uis[src_object_key])
		for(var/datum/tgui/ui in open_uis[src_object_key][ui_key])
			if(ui && ui.src_object && ui.user && ui.src_object.tgui_host(ui.user)) // Check the UI is valid.
				ui.close() // Close the UI.
				close_count++ // Count each UI we close.
	return close_count
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

 /**
  * private
  *
<<<<<<< HEAD
  * Close all UIs regardless of their attachment to src_object.
=======
  * Close *ALL* UIs
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
  *
  * return int The number of UIs closed.
 **/
/datum/controller/subsystem/tgui/proc/close_all_uis()
<<<<<<< HEAD
	var/count = 0
	for(var/key in open_uis_by_src)
		for(var/datum/tgui/ui in open_uis_by_src[key])
			if(ui && ui.src_object && ui.user && ui.src_object.tgui_host(ui.user)) // Check the UI is valid.
				ui.close() // Close the UI.
				count++ // Count each UI we close.
	return count
=======
	var/close_count = 0
	for(var/src_object_key in open_uis)
		for(var/ui_key in open_uis[src_object_key])
			for(var/datum/tgui/ui in open_uis[src_object_key][ui_key])
				if(ui && ui.src_object && ui.user && ui.src_object.tgui_host(ui.user)) // Check the UI is valid.
					ui.close() // Close the UI.
					close_count++ // Count each UI we close.
	return close_count
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

 /**
  * private
  *
  * Update all UIs belonging to a user.
  *
  * required user mob The mob who opened/is using the UI.
  * optional src_object datum If provided, only update UIs belonging this src_object.
<<<<<<< HEAD
  *
  * return int The number of UIs updated.
 **/
/datum/controller/subsystem/tgui/proc/update_user_uis(mob/user, datum/src_object)
	var/count = 0
	if(length(user?.tgui_open_uis) == 0)
		return count
	for(var/datum/tgui/ui in user.tgui_open_uis)
		if(isnull(src_object) || ui.src_object == src_object)
			ui.process(force = 1)
			count++
	return count
=======
  * optional ui_key string If provided, only update UIs with this UI key.
  *
  * return int The number of UIs updated.
 **/
/datum/controller/subsystem/tgui/proc/update_user_uis(mob/user, datum/src_object = null, ui_key = null)
	if(isnull(user.open_tguis) || !istype(user.open_tguis, /list) || open_uis.len == 0)
		return 0 // Couldn't find any UIs for this user.

	var/update_count = 0
	for(var/datum/tgui/ui in user.open_tguis)
		if((isnull(src_object) || !isnull(src_object) && ui.src_object == src_object) && (isnull(ui_key) || !isnull(ui_key) && ui.ui_key == ui_key))
			ui.process(force = 1) // Update the UI.
			update_count++ // Count each UI we upadte.
	return update_count
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

 /**
  * private
  *
  * Close all UIs belonging to a user.
  *
  * required user mob The mob who opened/is using the UI.
  * optional src_object datum If provided, only close UIs belonging this src_object.
<<<<<<< HEAD
  *
  * return int The number of UIs closed.
 **/
/datum/controller/subsystem/tgui/proc/close_user_uis(mob/user, datum/src_object)
	var/count = 0
	if(length(user?.tgui_open_uis) == 0)
		return count
	for(var/datum/tgui/ui in user.tgui_open_uis)
		if(isnull(src_object) || ui.src_object == src_object)
			ui.close()
			count++
	return count
=======
  * optional ui_key string If provided, only close UIs with this UI key.
  *
  * return int The number of UIs closed.
 **/
/datum/controller/subsystem/tgui/proc/close_user_uis(mob/user, datum/src_object = null, ui_key = null)
	if(isnull(user.open_tguis) || !istype(user.open_tguis, /list) || open_uis.len == 0)
		return 0 // Couldn't find any UIs for this user.

	var/close_count = 0
	for(var/datum/tgui/ui in user.open_tguis)
		if((isnull(src_object) || !isnull(src_object) && ui.src_object == src_object) && (isnull(ui_key) || !isnull(ui_key) && ui.ui_key == ui_key))
			ui.close() // Close the UI.
			close_count++ // Count each UI we close.
	return close_count
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

 /**
  * private
  *
  * Add a UI to the list of open UIs.
  *
  * required ui datum/tgui The UI to be added.
 **/
/datum/controller/subsystem/tgui/proc/on_open(datum/tgui/ui)
<<<<<<< HEAD
	var/key = "[REF(ui.src_object)]"
	if(isnull(open_uis_by_src[key]) || !istype(open_uis_by_src[key], /list))
		open_uis_by_src[key] = list()
	ui.user.tgui_open_uis |= ui
	var/list/uis = open_uis_by_src[key]
	uis |= ui
	open_uis |= ui
=======
	var/src_object_key = "\ref[ui.src_object]"
	if(isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		open_uis[src_object_key] = list(ui.ui_key = list()) // Make a list for the ui_key and src_object.
	else if(isnull(open_uis[src_object_key][ui.ui_key]) || !istype(open_uis[src_object_key][ui.ui_key], /list))
		open_uis[src_object_key][ui.ui_key] = list() // Make a list for the ui_key.

	// Append the UI to all the lists.
	ui.user.open_tguis |= ui
	var/list/uis = open_uis[src_object_key][ui.ui_key]
	uis |= ui
	processing_uis |= ui
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

 /**
  * private
  *
  * Remove a UI from the list of open UIs.
  *
  * required ui datum/tgui The UI to be removed.
  *
  * return bool If the UI was removed or not.
 **/
/datum/controller/subsystem/tgui/proc/on_close(datum/tgui/ui)
<<<<<<< HEAD
	var/key = "[REF(ui.src_object)]"
	if(isnull(open_uis_by_src[key]) || !istype(open_uis_by_src[key], /list))
		return FALSE
	// Remove it from the list of processing UIs.
	open_uis.Remove(ui)
	// If the user exists, remove it from them too.
	if(ui.user)
		ui.user.tgui_open_uis.Remove(ui)
	var/list/uis = open_uis_by_src[key]
	uis.Remove(ui)
	if(length(uis) == 0)
		open_uis_by_src.Remove(key)
	return TRUE
=======
	var/src_object_key = "\ref[ui.src_object]"
	if(isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		return FALSE // It wasn't open.
	else if(isnull(open_uis[src_object_key][ui.ui_key]) || !istype(open_uis[src_object_key][ui.ui_key], /list))
		return FALSE // It wasn't open.

	processing_uis.Remove(ui) // Remove it from the list of processing UIs.
	if(ui.user)	// If the user exists, remove it from them too.
		ui.user.open_tguis.Remove(ui)
	var/Ukey = ui.ui_key
	var/list/uis = open_uis[src_object_key][Ukey] // Remove it from the list of open UIs.
	uis.Remove(ui)
	if(!uis.len)
		var/list/uiobj = open_uis[src_object_key]
		uiobj.Remove(Ukey)
		if(!uiobj.len)
			open_uis.Remove(src_object_key)

	return TRUE // Let the caller know we did it.
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

 /**
  * private
  *
  * Handle client logout, by closing all their UIs.
  *
  * required user mob The mob which logged out.
  *
  * return int The number of UIs closed.
 **/
/datum/controller/subsystem/tgui/proc/on_logout(mob/user)
	return close_user_uis(user)

 /**
  * private
  *
  * Handle clients switching mobs, by transferring their UIs.
  *
  * required user source The client's original mob.
  * required user target The client's new mob.
  *
  * return bool If the UIs were transferred.
 **/
/datum/controller/subsystem/tgui/proc/on_transfer(mob/source, mob/target)
<<<<<<< HEAD
	// The old mob had no open UIs.
	if(length(source?.tgui_open_uis) == 0)
		return FALSE
	if(isnull(target.tgui_open_uis) || !istype(target.tgui_open_uis, /list))
		target.tgui_open_uis = list()
	// Transfer all the UIs.
	for(var/datum/tgui/ui in source.tgui_open_uis)
		// Inform the UIs of their new owner.
		ui.user = target
		target.tgui_open_uis.Add(ui)
	// Clear the old list.
	source.tgui_open_uis.Cut()
	return TRUE
=======
	if(!source || isnull(source.open_tguis) || !istype(source.open_tguis, /list) || open_uis.len == 0)
		return FALSE // The old mob had no open UIs.

	if(isnull(target.open_tguis) || !istype(target.open_tguis, /list))
		target.open_tguis = list() // Create a list for the new mob if needed.

	for(var/datum/tgui/ui in source.open_tguis)
		ui.user = target // Inform the UIs of their new owner.
		target.open_tguis.Add(ui) // Transfer all the UIs.

	source.open_tguis.Cut() // Clear the old list.
	return TRUE // Let the caller know we did it.
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
