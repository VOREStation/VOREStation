/obj/machinery/maint_vendor
	name = "decrepit machine"
	desc = "A long since abandoned \"trash 4 cash\" rewards kiosk. Now featuring a state of the art, monochrome holographic tube display!"
	icon = 'code/modules/maint_recycler/icons/maint_vendor.dmi'
	icon_state = "default"

	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10

	description_info = "With points you get from another, similar machine in maint - you can redeem various goodies!"
	description_fluff = "While the \"Trash 4 Cash\" recycling campaign came to an end decades ago, the underlying systems still work as well as ever."


	var/item_creation_energy_use = 400 //old and clunky

	var/list/product_datums = list() //assoc list of category = list() of the vendor entries.

	var/is_on = FALSE //are we actively being used by a user?


/obj/machinery/maint_vendor/fall_apart(var/severity = 3, var/scatter = TRUE)
	return FALSE //don't fall apart. you can't fall apart if you don't consent. it works irl too.

/obj/machinery/maint_vendor/dismantle()
	return FALSE //we don't want something as important as this to be able to be disassembled. it's a scene tool, technically.

/obj/machinery/maint_vendor/Initialize(mapload)
	. = ..()
	//select active stock
	//move to relevant location


/obj/machinery/maint_vendor/power_change()
	//update icon, remove overlay

/obj/machinery/maint_vendor/proc/select_items()
	//we're only expecting one of these to ever exist at a time, so we can just iterate over every vendor entry and run logic to determine what we pick.
	// if we WERE expecting to have multiple of these, someone annoy me to refactor this to be global. and to let people have multiple.

/obj/machinery/maint_vendor/attack_hand(mob/user)
	if(..(user))
		return

	add_fingerprint(user)
	tgui_interact(user)



/obj/machinery/maint_vendor/proc/attempt_purchase(var/mob/user)

/obj/machinery/maint_vendor/proc/purchase_failed(var/mob/user)

/obj/machinery/maint_vendor/proc/dispense_item_from_datum(var/mob/user, var/datum/maint_recycler_vendor_entry/used_entry)

/obj/machinery/maint_vendor/proc/can_user_purchase(var/mob/user,var/datum/maint_recycler_vendor_entry/attempted_entry)
	return TRUE //TODO

/obj/machinery/maint_vendor/proc/set_screen_state(var/newstate, var/duration)


//TGUI junk

/obj/machinery/maint_vendor/tgui_act(action,params,datum/tgui/ui)
	if(..())
		return TRUE

/obj/machinery/maint_vendor/tgui_interact(mob/user,datum/tgui/ui)
	ui = SStgui.try_update_ui(user,src,ui)
	if(!ui)
		ui = new(user,src,"RecyclerVendor")
		ui.open()

/obj/machinery/maint_vendor/tgui_data(mob/user)
	var/list/data = list()
	var/list/items = list()
	for(var/datum/maint_recycler_vendor_entry/entry in product_datums)
		UNTYPED_LIST_ADD(items,list(
			"category" = entry.vendor_category,
			"name" = entry.name,
			"cost" = entry.item_cost,
			"desc" = entry.desc
		))
