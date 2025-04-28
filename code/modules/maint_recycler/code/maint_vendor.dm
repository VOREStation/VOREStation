/obj/machinery/maint_vendor
	name = "Large Decrepit Machine"
	desc = "A long since abandoned \"trash 4 cash\" rewards kiosk. Now featuring a state of the art, monochrome holographic tube display!"
	icon = 'code/modules/maint_recycler/icons/maint_vendor.dmi'
	icon_state = "default"
	clicksound = 'code/modules/maint_recycler/sfx/typing.ogg'

	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10

	description_info = "With the points you get from another, similar machine in maint - you can redeem various goodies! Nothing important, but fun stuff!"
	description_fluff = "While RSG's \"Trash 4 Cash\" recycling campaign came to an end decades ago, the underlying systems still work as well as ever thanks to an underground network of mega-dweebs and other assorted idiots maintaining it."

	//wide sprite
	pixel_x = -8

	var/item_creation_energy_use = 400 //old and clunky

	var/list/product_datums = list() //assoc list of obj spawn type to datum
	var/is_on = FALSE
	var/light_range_on = 2
	var/light_power_on = 1
	light_color = "#0f8f0f"

	var/obj/effect/overlay/recycler/monitor_screen

/obj/machinery/maint_vendor/fall_apart(var/severity = 3, var/scatter = TRUE)
	return FALSE //don't fall apart. you can't fall apart if you don't consent. it works irl too.

/obj/machinery/maint_vendor/dismantle()
	return FALSE //we don't want something as important as this to be able to be disassembled. it's a scene tool, technically.

/obj/machinery/maint_vendor/Initialize(mapload)
	. = ..()
	for(var/t in subtypesof(/datum/maint_recycler_vendor_entry) - /datum/maint_recycler_vendor_entry)
		var/datum/maint_recycler_vendor_entry/entry = new t()
		entry.initialize()
		product_datums += entry
	//move to relevant location
	monitor_screen = new
	monitor_screen.plane = PLANE_LIGHTING_ABOVE
	monitor_screen.layer = src.layer + 0.1
	monitor_screen.icon = src.icon
	monitor_screen.icon_state = "screen_off"

	src.vis_contents |= monitor_screen
	shuffle_inplace(product_datums) //looks weird to have a billion carpet entries right next to eachother
	if(mapload)
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/maint_vendor/LateInitialize()
	move_to_marker()

/obj/machinery/maint_vendor/proc/move_to_marker()
	if(GLOB.recycler_vendor_locations.len > 0)
		var/turf/spot = pick(GLOB.recycler_vendor_locations)
		forceMove(spot)
		dir = SOUTH
		log_admin("[src] has been placed at [loc], [x],[y],[z]")
		testing("[src] has been placed at [loc], [x],[y],[z]")
	else
		log_and_message_admins("[src] tried to move itself, but there was nowhere for it to go! (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)", null)



/obj/machinery/maint_vendor/Destroy()
	. = ..()
	QDEL_LIST(product_datums)
	qdel(monitor_screen)
	monitor_screen = null

/obj/machinery/maint_vendor/power_change()
	update_icon()
	//update icon, remove overlay

/obj/machinery/maint_vendor/attack_hand(mob/user)
	if(..(user))
		return

	add_fingerprint(user)
	tgui_interact(user)

	if(!is_on)
		set_on_state(TRUE)

/obj/machinery/maint_vendor/proc/attempt_purchase(var/mob/user, var/datum/maint_recycler_vendor_entry/entry)
	if(!istype(entry))
		return
	if(entry.purchased_by == null)
		entry.purchased_by = list()
	if(!entry.purchased_by[user.client.ckey])
		entry.purchased_by[user.client.ckey] = 0
	if(!can_user_purchase(user,entry))
		return


	dispense_item_from_datum(user,entry)
	credit_user(user,-entry.item_cost)
	entry.purchased_by[user.client.ckey] += 1

/obj/machinery/maint_vendor/proc/purchase_failed(var/mob/user, var/reason)
	if(prob(95))
		set_screen_state("screen_deny",10)
	else
		set_screen_state("screen_mad",10)
	audible_message("[src] states, \"PURCHASE DENIED: [reason].\" ", "\The [src]'s screen briefly flashes to an X!" , runemessage = "X")
	playsound(src, 'code/modules/maint_recycler/sfx/generaldeny.ogg', 75, 1)
	return

/obj/machinery/maint_vendor/proc/dispense_item_from_datum(var/mob/user, var/datum/maint_recycler_vendor_entry/used_entry)
	if(!used_entry || !used_entry.object_type_to_spawn)
		to_chat(user,span_warning("What the fuck?? this is a scam! Nothing happened!"))
		return;

	playsound(src, 'code/modules/maint_recycler/sfx/ejectgoodies.ogg', 75, 1)
	used_entry.spawn_with_delay(src);
	audible_message("[src] states, \"[used_entry.tagline]\" ", "\The [src]'s screen briefly flashes an $!" , runemessage = "$$$")
	if(prob(95))
		set_screen_state("screen_cashout",10)
	else
		set_screen_state("screen_happy",10)

/obj/machinery/maint_vendor/proc/can_user_purchase(var/mob/user,var/datum/maint_recycler_vendor_entry/attempted_entry)
	if(!user_balance(user) || user_balance(user) < attempted_entry.item_cost)
		purchase_failed(user, "Insufficent Balance")
		return FALSE
	if(attempted_entry.per_person_cap > 0 && attempted_entry.purchased_by[user.client.ckey] >= attempted_entry.per_person_cap)
		purchase_failed(user, "Limited Per-Person Supply")
		return FALSE
	if(attempted_entry.per_round_cap > 0 && attempted_entry.getPurchasedCount() >= attempted_entry.per_round_cap)
		purchase_failed(user, "Out of Stock")
		return FALSE
	if(LAZYLEN(attempted_entry.required_access)) //access check
		req_access = attempted_entry.required_access
		if(!allowed(user))
			purchase_failed(user, "Access Denied")
			return FALSE

	return TRUE

/obj/machinery/maint_vendor/update_icon()
	. = ..()
	cut_overlays()
	if(!(stat & NOPOWER))
		add_overlay(mutable_appearance(src.icon, "passiveGlow")) //product display. screen is distinct.
		add_overlay(emissive_appearance(src.icon, "passiveGlow"))

/obj/machinery/maint_vendor/proc/set_screen_state(var/state, var/duration = 10)
	if(!is_on) return
	monitor_screen.icon_state = state
	addtimer(CALLBACK(src, PROC_REF(reset_screen_state)), duration)


/obj/machinery/maint_vendor/proc/reset_screen_state()
	if(!is_on)
		monitor_screen.icon_state = "screen_off"
	else
		monitor_screen.icon_state = "screen_default"

//TGUI junk

/obj/machinery/maint_vendor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/maint_recycler), //for the logos
		get_asset_datum(/datum/asset/spritesheet_batched/maint_vendor) //for the item icons
	)

/obj/machinery/maint_vendor/tgui_act(action,params,datum/tgui/ui)
	if(..())
		return TRUE

	if(action == "purchase")
		var/datum/maint_recycler_vendor_entry/entry = product_datums[params["index"]]
		attempt_purchase(ui.user,entry)
		return TRUE



/obj/machinery/maint_vendor/tgui_interact(mob/user,datum/tgui/ui)
	ui = SStgui.try_update_ui(user,src,ui)
	if(!ui)
		ui = new(user,src,"RecyclerVendor")
		ui.open()

/obj/machinery/maint_vendor/tgui_close(mob/user)
	. = ..()
	set_on_state(FALSE)

/obj/machinery/maint_vendor/tgui_data(mob/user)
	var/list/data = list()
	var/list/items = list()

	for(var/i = 1 to product_datums.len)
		var/datum/maint_recycler_vendor_entry/entry = product_datums[i]
		UNTYPED_LIST_ADD(items,list(
			"category" = entry.vendor_category,
			"name" = entry.name,
			"cost" = entry.item_cost,
			"desc" = entry.desc,
			"ad" = entry.ad_message,
			"icon" = entry.icon_state,
			"index" = i //TODO
		))
	data["items"] = items
	data["userBalance"] = user_balance(user)
	data["userName"] = user.name

	return data

//utility

/obj/machinery/maint_vendor/proc/user_balance(var/mob/user)
	return user.client?.prefs?.read_preference(/datum/preference/numeric/recycler_points)

/obj/machinery/maint_vendor/proc/credit_user(var/mob/user, var/amount)
	if(!user || !user.client || !user.client.prefs) return
	var/currentValue = 	user.client?.prefs?.read_preference(/datum/preference/numeric/recycler_points)
	user.client?.prefs?.write_preference_by_type(/datum/preference/numeric/recycler_points, currentValue + amount)


/obj/machinery/maint_vendor/proc/set_on_state(var/state)
	if(is_on == state) return
	is_on = state
	if(is_on)
		playsound(src, 'code/modules/maint_recycler/sfx/initialBoot.ogg', 20, 1)
		set_light(light_range_on, light_power_on)
		monitor_screen.icon_state = "screen_default"
	else
		playsound(src, 'sound/machines/terminal_off.ogg', 50, 1)
		set_light(0)
		monitor_screen.icon_state = "screen_off"

/obj/machinery/maint_vendor/power_change()
	..()
	if(stat & NOPOWER)
		set_on_state(FALSE)
	update_icon()
