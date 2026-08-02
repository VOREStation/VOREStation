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

#define GUN_SIDEARM 0
#define GUN_LONGARM 1
#define GUN_HEAVY   2

#define DEFAULT_RACK_SLOTS 4
#define DEFAULT_MAX_ROWS 1
#define GUNCABINET_SLOTS_PER_ROW 4
#define GUNCABINET_SPACER_X 3
#define GUNCABINET_SPACER_Y 3

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
	var/repair_material = /obj/item/stack/material/plasteel
	var/doorstatus = CABINET_NORMAL
	/// Future proofing, default one row, four slots, four per row.
	var/max_gun_rows = DEFAULT_MAX_ROWS
	var/max_gun_slots = DEFAULT_RACK_SLOTS
	var/slots_per_row = DEFAULT_RACK_SLOTS
	/// Use these offsets if you add a new type of gunlocker that has a different point for guns to be overlayed onto
	var/gun_sprite_offsetx = 0
	var/gun_sprite_offsety = 0
	/// Use these if you're adjusting how close or wide the slots are, default 3 pixels.
	var/gun_sprite_spacingx = GUNCABINET_SPACER_X
	var/gun_sprite_spacingy = GUNCABINET_SPACER_Y
	/// For our UI updates
	var/atom/movable/overlay/invisible_appearance_holder
	/// Slot array storing references to placed weapons, needed so people can put it whereever instead of defaulting to slot 0
	var/list/slots

/obj/structure/closet/secure_closet/guncabinet/fancy/Initialize(mapload)
	. = ..()
	invisible_appearance_holder = new /atom/movable/overlay(src)
	invisible_appearance_holder.invisibility = INVISIBILITY_MAXIMUM
	vis_contents += invisible_appearance_holder

	if(max_gun_rows > 0)
		slots_per_row = ceil(max_gun_slots / max_gun_rows)

	if(!slots)
		slots = new /list(max_gun_slots)

	return INITIALIZE_HINT_LATELOAD

//Legacy support for people just leaving guns on the map floor. If starting_contents becomes a thing, then we can yeet this.
/obj/structure/closet/secure_closet/guncabinet/fancy/LateInitialize()
	. = ..()
	//check first if we've already been stuffed with guns
	for(var/obj/item/gun/G in src)
		if(G in slots)
			continue

		var/empty_slot = slots.Find(null)
		if(!empty_slot)
			break // Cabinet is full
		slots[empty_slot] = G

	//Then scoop up any guns from the floor and place them into racks
	for(var/obj/item/gun/G in loc)
		if(G.density || G.anchored || (case_type && G.locker_class != case_type))
			continue

		var/empty_slot = slots.Find(null)
		// No vacancies
		if(!empty_slot)
			break

		G.forceMove(src)
		slots[empty_slot] = G

	update_icon()

/obj/structure/closet/secure_closet/guncabinet/fancy/Entered(atom/movable/AM)
	. = ..()
	if(invisible_appearance_holder)
		invisible_appearance_holder.vis_contents += AM

/obj/structure/closet/secure_closet/guncabinet/fancy/Exited(atom/movable/AM)
	. = ..()
	if(invisible_appearance_holder)
		invisible_appearance_holder.vis_contents -= AM

/obj/structure/closet/secure_closet/guncabinet/fancy/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GunLocker")
		ui.open()

/obj/structure/closet/secure_closet/guncabinet/fancy/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list(
		"welded" = welded,
		"locked" = locked,
		"open" = opened,
		"max_gun_rows" = max_gun_rows,
		"slots_per_row" = slots_per_row
	)
	var/list/slots_data = list()

	for(var/i in 1 to max_gun_slots)
		var/obj/item/gun/G = slots[i]

		if(G)
			G.update_icon()
			var/current_charge = get_gun_ammo(G)
			var/max_charge = get_max_gun_ammo(G)

			UNTYPED_LIST_ADD(slots_data, list(
				"index" = i,
				"ref" = REF(G),
				"name" = capitalize(G.name),
				"charge" = current_charge,
				"maxCharge" = max_charge,
				"depleted" = (current_charge <= 0),
			))
		else
			UNTYPED_LIST_ADD(slots_data, list(
				"index" = i,
				"ref" = null,
				"name" = "Empty Slot",
				"charge" = 0,
				"maxCharge" = 0,
				"depleted" = TRUE,
			))

	data["slots"] = slots_data
	return data

/obj/structure/closet/secure_closet/guncabinet/fancy/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	switch(action)
		if("open")
			opened = !opened
			update_icon()
			return TRUE

		if("toggle_lock")
			if(!opened && !emagged)
				locked = !locked
				update_icon()
				return TRUE

		if("insert_slot")
			var/target_slot = text2num(params["slot_index"])
			var/obj/item/gun/held_gun = usr.get_active_held_item()
			insert_weapon(held_gun, target_slot, usr)
			return TRUE

		if("eject_slot")
			var/target_slot = text2num(params["slot_index"])
			var/obj/item/gun/G = locate(params["ref"]) in src
			if(!G && target_slot && target_slot <= slots.len)
				G = slots[target_slot]

			if(G && eject_weapon(G, usr))
				if(target_slot && target_slot <= slots.len)
					slots[target_slot] = null
				return TRUE

	return FALSE

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/eject_weapon(obj/item/gun/G, mob/user)
	if(issilicon(user) || isalien(user) || isanimal(user) || !Adjacent(user))
		return FALSE

	if(G.loc != src)
		return FALSE

	user.put_in_hands(G)
	to_chat(user, span_notice("You take \the [G.name] from [src]."))
	update_icon()
	return TRUE

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/insert_weapon(obj/item/gun/G, var/slot_index, mob/user)
	if(issilicon(user) || isalien(user) || isanimal(user) || !Adjacent(user))
		return FALSE

	if(!slot_index || slot_index < 1 || slot_index > max_gun_slots)
		return FALSE

	if(slots[slot_index])
		to_chat(user, span_warning("That slot is already occupied!"))
		return FALSE

	var/obj/item/gun/held_gun = G || user.get_active_held_item()
	if(istype(held_gun) && check_weapon(held_gun, user))
		if(user.unEquip(held_gun))
			held_gun.forceMove(src)
			slots[slot_index] = held_gun
			to_chat(user, span_notice("You place \the [held_gun.name] into [src]."))
			update_icon()
			return TRUE
	else
		to_chat(user, span_warning("You are not holding a valid weapon!"))

	return FALSE

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/check_weapon(obj/item/gun/G, mob/user)
	if(!istype(G))
		return FALSE
	if(G.locker_class != case_type)
		to_chat(user, span_warning("[G] doesn't fit into this type of rack!"))
		return FALSE
	return TRUE

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/get_gun_ammo(obj/item/gun/G)
	if(!G)
		return 0
	if(istype(G, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/proj = G
		if(proj.ammo_magazine)
			return proj.ammo_magazine.stored_ammo.len
	else if(istype(G, /obj/item/gun/energy))
		var/obj/item/gun/energy/egun = G
		if(egun.power_supply)
			return FLOOR(egun.power_supply.charge / max(egun.charge_cost, 1), 1)
	return 0

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/get_max_gun_ammo(obj/item/gun/G)
	if(!G)
		return 0
	if(istype(G, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/proj = G
		if(proj.ammo_magazine)
			return proj.ammo_magazine.max_ammo
	else if(istype(G, /obj/item/gun/energy))
		var/obj/item/gun/energy/egun = G
		if(egun.power_supply)
			return FLOOR(egun.power_supply.maxcharge / max(egun.charge_cost, 1), 1)
	return 0

/obj/structure/closet/secure_closet/guncabinet/fancy/ex_act(severity)
	if(severity >= 2)	//study enough to survive door knockers
		if(!opened)
			welded = TRUE	//simulate being cut open for ease of repair logic
			locked = FALSE
			doorstatus = CABINET_BROKEN
			visible_message(span_warning("The door blows open!"))
			update_icon()
		else
			visible_message(span_warning("The force of the blast scatters [src]'s weapons everywhere!"))
			scatter_contents(max_range = 3, throw_speed = 2)
			update_icon()
	else
		scatter_contents(max_range = 5, throw_speed = 3)
		qdel(src)

/obj/structure/closet/secure_closet/guncabinet/fancy/attackby(obj/item/I, mob/user, params)
	if(isAI(user) || isalien(user) || isanimal(user) || !Adjacent(user))
		return

	if(opened && istype(I, /obj/item/gun) && !(issilicon(user)))
		tgui_interact(user)
		return

	if(I.has_tool_quality(TOOL_WRENCH))
		var/obj/item/tool/wrench/Wench = I
		user.visible_message(
			"[user] begins [anchored ? "un" : ""]securing [src] [anchored ? "from" : "to"] the floor.",
			span_notice("You start [anchored ? "un" : ""]securing [src] [anchored ? "from" : "to"] the floor."))
		if(do_after(user, 2 SECONDS * Wench.toolspeed, src))
			anchored = !anchored
			to_chat(user, span_notice("You [anchored ? "" : "un"]secured [src]!"))
		return

	if(I.has_tool_quality(IS_WELDER))
		var/obj/item/weldingtool/Wald = I.get_welder()
		if(!opened && locked)
			if(!do_after(user, 3 SECONDS * Wald.toolspeed, src))
				return
			welded = TRUE
			locked = FALSE
			doorstatus = CABINET_BROKEN
			update_icon()
			user.visible_message(span_warning("[user] cuts through [src]'s lock with [I]!"))
			return

		if(!opened && doorstatus == CABINET_REPAIR)
			if(!do_after(user, 3 SECONDS * Wald.toolspeed, src))
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
		if(do_after(user, 3 SECONDS, src) && doorstatus == CABINET_BROKEN)
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
	doorstatus = CABINET_BROKEN
	update_icon()
	playsound(src, 'sound/effects/sparks1.ogg', 50, TRUE)
	to_chat(user, span_warning("You overload the electronic lock on the doors."))
	return TRUE

/obj/structure/closet/secure_closet/guncabinet/fancy/update_icon()
	cut_overlays()

	if(slots)
		for(var/i in 1 to min(slots.len, max_gun_slots))
			var/obj/item/gun/G = slots[i]
			if(!G)
				continue

			var/slot_idx = i - 1
			var/col = slot_idx % slots_per_row
			var/row = (slot_idx - col) / slots_per_row
			if(row >= max_gun_rows)
				break

			// Gun overlays are in the locker file, update the overlay if you add more guns!
			var/mutable_appearance/gun_overlay = mutable_appearance(icon, G.overlay_type)
			gun_overlay.pixel_x = (col * gun_sprite_spacingx) + gun_sprite_offsetx
			gun_overlay.pixel_y = gun_sprite_offsety - (row * gun_sprite_spacingy)
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

//stops it won't budge! spam because that's annoying.
/obj/structure/closet/secure_closet/guncabinet/fancy/relaymove(mob/user as mob)
	if(user.stat || !isturf(loc))
		return

//so people can open the gui without a gun in hand.
/obj/structure/closet/secure_closet/guncabinet/fancy/click_ctrl_shift(mob/user)
	if(issilicon(user) || isalien(user) || isanimal(user) || !Adjacent(user))
		return
	tgui_interact(user)

/obj/structure/closet/secure_closet/guncabinet/fancy/shotgun
	name = "Shotgun locker"
	icon_state = "shotguncase"

/obj/structure/closet/secure_closet/guncabinet/fancy/rifle
	name = "Rifle locker"
	icon_state = "riflecase"
	desc = "A strong cabinet used for securing firearms. This one is for long arms such as rifles and shotguns."

/obj/structure/closet/secure_closet/guncabinet/fancy/rifle/wood
	icon_state = "riflefancy"
	repair_material = /obj/item/stack/material/glass/reinforced

/obj/structure/closet/secure_closet/guncabinet/fancy/pistol
	name = "Small Arms locker"
	icon_state = "pistolcase"
	desc = "A strong cabinet used for securing firearms. This one is for hand-held sidearms."
	case_type = GUN_SIDEARM
	repair_material = /obj/item/stack/material/glass/reinforced

/obj/structure/closet/secure_closet/guncabinet/fancy/pistol/wood
	icon_state = "fancypistol"

#undef DEFAULT_RACK_SLOTS
#undef DEFAULT_MAX_ROWS
#undef GUN_SIDEARM
#undef GUN_LONGARM
#undef GUN_HEAVY
#undef GUNCABINET_SLOTS_PER_ROW
#undef GUNCABINET_SPACER_X
#undef GUNCABINET_SPACER_Y
#undef CABINET_NORMAL
#undef CABINET_REPAIR
#undef CABINET_BROKEN
