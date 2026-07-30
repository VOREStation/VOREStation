/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	req_one_access = list(ACCESS_ARMORY)
	closet_appearance = null

/obj/structure/closet/secure_closet/guncabinet/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/open() //Don't dump everything to the floor, why would this be a good idea?
	if(opened)
		return FALSE
	if(!can_open())
		return FALSE
	opened = TRUE
	playsound(src, open_sound, 15, 1, -3)
	update_icon()
	return TRUE

/obj/structure/closet/secure_closet/guncabinet/close() //Don't auto scoop
	if(!opened)
		return FALSE
	if(!can_close())
		return FALSE
	opened = FALSE
	playsound(src, close_sound, 15, 1, -3)
	update_icon()
	return TRUE

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	cut_overlays()
	if(opened)
		add_overlay("door_openold") //all of these should be considered 'old' sprites, but keep backwards compatability.
	else
		var/lazors = 0
		var/shottas = 0
		for (var/obj/item/gun/G in contents)
			if (istype(G, /obj/item/gun/energy))
				lazors++
			if (istype(G, /obj/item/gun/projectile))
				shottas++
		for (var/i = 0 to 2)
			if(lazors || shottas) // only make icons if we have one of the two types.
				var/image/gun = image(icon(src.icon))
				if (lazors > shottas)
					lazors--
					gun.icon_state = "laserold"
				else if (shottas)
					shottas--
					gun.icon_state = "projectileold"
				gun.pixel_x = i*4
				add_overlay(gun)

		add_overlay("doorold")

		if(sealed)
			add_overlay("sealedold")

		if(broken)
			add_overlay("brokenold")
		else if (locked)
			add_overlay("lockedold")
		else
			add_overlay("openold")

/obj/structure/closet/secure_closet/guncabinet/excursion
	name = "expedition weaponry cabinet"
	req_one_access = list(ACCESS_ARMORY)

/obj/structure/closet/secure_closet/guncabinet/excursion/Initialize(mapload)
	. = ..()
	for(var/i = 1 to 2)
		new /obj/item/gun/energy/locked/frontier(src)
	for(var/i = 1 to 2)
		new /obj/item/gun/energy/locked/frontier/holdout(src)
// --- Gun Cabinet Defines ---
#define GUN_SIDEARM 0
#define GUN_LONGARM 1
#define GUN_HEAVY   2

#define GUNCABINET_SPACER 3
#define MAX_RACK_SLOTS 4

#define CABINET_NORMAL 0
#define CABINET_REPAIR 1
#define CABINET_BROKEN 2

/obj/structure/closet/secure_closet/guncabinet/fancy
	name = "arms locker"
	desc = "A high-security cabinet designed to store and display firearms."
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "shotguncase"
	anchored = TRUE
	density = TRUE
	store_mobs = FALSE

	var/case_type = GUN_LONGARM
	var/welded = FALSE
	var/emagged = FALSE
	var/repair_material = MAT_PLASTEEL
	var/doorstatus = CABINET_NORMAL

	/// Slot array storing references to placed weapons
	var/list/obj/item/gun/rack_slots = list()
	/// Cached slot data for TGUI transmission
	var/list/guninfo = list()

/obj/structure/closet/secure_closet/guncabinet/fancy/Initialize(mapload)
	. = ..()
	rack_slots.len = MAX_RACK_SLOTS

/obj/structure/closet/secure_closet/guncabinet/fancy/LateInitialize()
	. = ..()
	for(var/obj/item/gun/G in loc)
		if(G.density || G.anchored || G == src)
			continue
		if(lateintgunstuff(G))
			continue

	update_icon()

/obj/structure/closet/secure_closet/guncabinet/fancy/Destroy()
	for(var/i in 1 to MAX_RACK_SLOTS)
		if(rack_slots[i])
			qdel(rack_slots[i])
	rack_slots.Cut()
	guninfo.Cut()
	return ..()

/obj/structure/closet/secure_closet/guncabinet/fancy/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GunLocker", name)
		ui.open()

/obj/structure/closet/secure_closet/guncabinet/fancy/tgui_assets(mob/user)
	var/list/assets = list()

	// Cache weapon icon assets for client rendering
	for(var/i in 1 to MAX_RACK_SLOTS)
		var/obj/item/gun/G = rack_slots[i]
		if(G && G.icon)
			SSassets.transport.register_asset("[G.icon]", G.icon)
			assets += "[G.icon]"

	return assets

/obj/structure/closet/secure_closet/guncabinet/fancy/tgui_data(mob/user)
	var/list/data = list()
	data["welded"] = welded
	data["locked"] = locked
	data["emagged"] = emagged
	data["open"] = opened

	var/list/icons_map = list()

	// Populate slot keys matching React component props
	for(var/i in 1 to MAX_RACK_SLOTS)
		var/slot_key = "rackslot[i]"
		var/obj/item/gun/G = rack_slots[i]
		if(G)
			data[slot_key] = G.name
			var/list/info = guninfo[slot_key]
			if(info)
				icons_map[slot_key] = info["iconFile"]
		else
			data[slot_key] = null

	data["icons"] = icons_map
	data["guninfo"] = guninfo
	return data

/obj/structure/closet/secure_closet/guncabinet/fancy/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	switch(action)
		if("open")
			if(!locked && !welded)
				if(opened)
					close(ui.user)
				else
					open(ui.user)
				return TRUE

		if("lock")
			if(!opened && !emagged)
				locked = !locked
				to_chat(ui.user, span_notice("You [locked ? "lock" : "unlock"] [src]."))
				return TRUE

	if(findtext(action, "rackslot"))
		var/slot_idx = text2num(replacetext(action, "rackslot", ""))
		if(!slot_idx || slot_idx < 1 || slot_idx > MAX_RACK_SLOTS)
			return FALSE

		if(!opened)
			to_chat(ui.user, span_notice("The cabinet doors are closed."))
			return TRUE

		var/obj/item/gun/occupant = rack_slots[slot_idx]
		if(occupant)
			ui.user.put_in_hands(occupant)
			to_chat(ui.user, span_notice("You take [occupant.name] from slot [slot_idx]."))
			rack_slots[slot_idx] = null
			update_slot_ui_data(slot_idx, null)
		else
			var/obj/item/gun/held_gun = ui.user.get_active_held_item()
			if(istype(held_gun) && check_weapon(held_gun, ui.user))
				if(ui.user.transferItemToLoc(held_gun, src))
					rack_slots[slot_idx] = held_gun
					update_slot_ui_data(slot_idx, held_gun)
					to_chat(ui.user, span_notice("You place [held_gun.name] into slot [slot_idx]."))

		update_icon()
		return TRUE

	return FALSE

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/lateintgunstuff(obj/item/gun/G)
	if(!istype(G) || (G.locker_class != case_type))
		return FALSE

	for(var/i in 1 to MAX_RACK_SLOTS)
		if(!rack_slots[i])
			G.forceMove(src)
			rack_slots[i] = G
			update_slot_ui_data(i, G)
			return TRUE

	return FALSE

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/check_weapon(obj/item/gun/G, mob/user)
	if(!istype(G))
		return FALSE
	if(G.locker_class != case_type)
		to_chat(user, span_warning("[G] doesn't fit into this type of rack!"))
		return FALSE
	return TRUE

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/update_slot_ui_data(slot_idx, obj/item/gun/G)
	var/key = "rackslot[slot_idx]"
	if(!G)
		guninfo.Remove(key)
		return

	SSassets.transport.register_asset("[G.icon]", G.icon)

	var/current_charge = get_gun_ammo(G)
	var/max_charge = get_gun_max_ammo(G)
	var/is_depleted = (current_charge <= 0)
	var/display_state = G.icon_state

	if(is_depleted && ("[G.icon_state]_empty" in icon_states(G.icon)))
		display_state = "[G.icon_state]_empty"

	guninfo[key] = list(
		"name" = capitalize(G.name),
		"charge" = current_charge,
		"maxCharge" = max_charge,
		"depleted" = is_depleted,
		"iconFile" = "[G.icon]",
		"iconState" = display_state
	)

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/get_gun_ammo(obj/item/gun/G)
	if(!G)
		return 0
	if(hascall(G, "get_ammo_count"))
		return G.get_ammo_count()
	return 0

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/get_gun_max_ammo(obj/item/gun/G)
	if(!G)
		return 0
	if(hascall(G, "get_max_ammo_count"))
		return G.get_max_ammo_count()
	return 0

/obj/structure/closet/secure_closet/guncabinet/fancy/attackby(obj/item/I, mob/user, params)
	if(issilicon(user) || isalien(user) || !Adjacent(user))
		return

	if(opened && istype(I, /obj/item/gun))
		tgui_interact(user)
		return

	if(I.is_wrench)
		I.play_tool_sound(src, 100)
		user.visible_message(
			"[user] begins [anchored ? "un" : ""]securing [src] [anchored ? "from" : "to"] the floor.",
			span_notice("You start [anchored ? "un" : ""]securing [src] [anchored ? "from" : "to"] the floor.")
		)
		if(I.use_tool(src, user, 2 SECONDS))
			anchored = !anchored
			to_chat(user, span_notice("You [anchored ? "" : "un"]secured [src]!"))
		return

	if(I.is_welder)
		if(!opened && locked)
			if(!I.use_tool(src, user, 3 SECONDS, volume = 50))
				return
			welded = TRUE
			locked = FALSE
			doorstatus = CABINET_BROKEN
			update_icon()
			user.visible_message(span_warning("[user] cuts through [src]'s lock with [I]!"))
			return

		if(!opened && doorstatus == CABINET_REPAIR)
			if(!I.use_tool(src, user, 3 SECONDS, volume = 50))
				return
			welded = FALSE
			emagged = FALSE
			doorstatus = CABINET_NORMAL
			update_icon()
			to_chat(user, span_notice("You repair the damaged doors on [src]."))
			return

		to_chat(user, span_notice("There is nothing to cut or mend on [src]."))
		return

	if(welded && doorstatus == CABINET_BROKEN && istype(I, repair_material))
		var/obj/item/stack/M = I
		if(M.get_amount() < 2)
			to_chat(user, span_warning("You need at least two sheets to repair the doors."))
			return

		to_chat(user, span_notice("You begin applying materials to repair [src]..."))
		if(do_after(user, 3 SECONDS, target = src) && doorstatus == CABINET_BROKEN)
			if(M.use(2))
				doorstatus = CABINET_REPAIR
				update_icon()
				to_chat(user, span_notice("You reinforced the doors. They are ready to be welded back together."))
		return

	return tgui_interact(user)

/obj/structure/closet/secure_closet/guncabinet/fancy/emag_act(mob/user)
	if(emagged || !locked)
		return FALSE
	emagged = TRUE
	locked = FALSE
	update_icon()
	playsound(src, 'sound/effects/sparks1.ogg', 50, TRUE)
	return TRUE

/obj/structure/closet/secure_closet/guncabinet/fancy/update_icon()
	cut_overlays()

	// Add weapon sprites in fixed slots
	for(var/i in 1 to MAX_RACK_SLOTS)
		var/obj/item/gun/G = rack_slots[i]
		if(!G)
			continue
		var/mutable_appearance/gun_overlay = mutable_appearance(G.icon, G.icon_state)
		gun_overlay.pixel_x = GUNCABINET_SPACER * (i - 1)
		add_overlay(gun_overlay)

	// Add door and security overlays
	if(welded)
		var/state_suffix = (doorstatus == CABINET_BROKEN) ? "cut" : "repair"
		add_overlay("[icon_state]_[opened ? "" : "door"][state_suffix]")
	else if(opened)
		add_overlay("[icon_state]_open")
	else
		add_overlay("[icon_state]_door")
		if(emagged)
			add_overlay("[icon_state]_off")
		else
			add_overlay("[icon_state]_[locked ? "locked" : "unlocked"]")

/obj/structure/closet/secure_closet/guncabinet/fancy/relaymove(mob/user as mob)
	if(user.stat || !isturf(loc))
		return

/obj/structure/closet/secure_closet/guncabinet/fancy/shotgun
	name = "Shotgun locker"
	icon_state = "shotguncase"

/obj/structure/closet/secure_closet/guncabinet/fancy/rifle
	name = "Rifle locker"
	icon_state = "riflecase"
	desc = "A strong cabinet used for securing firearms. This one is for long arms such as rifles and shotguns."

/obj/structure/closet/secure_closet/guncabinet/fancy/rifle/wood
	icon_state = "riflefancy"
	repair_material = MAT_RGLASS

/obj/structure/closet/secure_closet/guncabinet/fancy/pistol
	name = "Small Arms locker"
	icon_state = "pistolcase"
	desc = "A strong cabinet used for securing firearms. This one is for hand-held sidearms."
	case_type = GUN_SIDEARM
	repair_material = MAT_RGLASS

/obj/structure/closet/secure_closet/guncabinet/fancy/pistol/wood
	icon_state = "fancypistol"

#undef MAX_RACK_SLOTS
#undef GUN_SIDEARM
#undef GUN_LONGARM
#undef GUN_HEAVY
#undef GUNCABINET_SPACER
#undef CABINET_NORMAL
#undef CABINET_REPAIR
#undef CABINET_BROKEN
