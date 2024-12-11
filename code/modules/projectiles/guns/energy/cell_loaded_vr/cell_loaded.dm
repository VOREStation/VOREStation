// The Gun //
/obj/item/gun/projectile/cell_loaded //this one can load both medical and security cells! for ERT/admin use.
	name = "multipurpose cell-loaded revolver"
	desc = "Variety is the spice of life! This weapon is a hybrid of the Hephaestus 102b 'Nanotech Selectable-Fire Weapon' and the Vey-Med ML-3 'Medigun', dubbed the 'NSFW-ML3M'. \
	It can fire both harmful and healing cells with an internal nanite fabricator and energy weapon cell loader. Up to three combinations of \
	energy beams can be configured at once. Ammo not included."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "nsfw"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	caliber = "nsfw"

	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_MAGNET = 4)

	fire_sound = 'sound/weapons/Taser.ogg'

	load_method = MAGAZINE //Nyeh heh hehhh.
	magazine_type = null
	allowed_magazines = list(/obj/item/ammo_magazine/cell_mag)
	handle_casings = HOLD_CASINGS //Don't eject batteries!
	recoil = 0
	var/charge_left = 0
	var/max_charge = 0
	charge_sections = 5

/obj/item/gun/projectile/cell_loaded/consume_next_projectile()
	if(chambered && ammo_magazine)
		var/obj/item/ammo_casing/microbattery/batt = chambered
		if(batt.shots_left)
			return new chambered.projectile_type()
		else
			for(var/obj/item/ammo_casing/microbattery/other_batt as anything in ammo_magazine.stored_ammo)
				if(istype(other_batt,chambered.type) && other_batt.shots_left)
					switch_to(other_batt)
					return new chambered.projectile_type()

	return null

/obj/item/gun/projectile/cell_loaded/proc/update_charge()
	charge_left = 0
	max_charge = 0

	if(!chambered)
		return

	var/obj/item/ammo_casing/microbattery/batt = chambered

	if(ammo_magazine) //Crawl to find more
		for(var/obj/item/ammo_casing/microbattery/bullet as anything in ammo_magazine.stored_ammo)
			if(istype(bullet,batt.type))
				charge_left += bullet.shots_left
				max_charge += initial(bullet.shots_left)

/obj/item/gun/projectile/cell_loaded/proc/switch_to(obj/item/ammo_casing/microbattery/new_batt)
	if(ishuman(loc))
		if(chambered && new_batt.type == chambered.type)
			to_chat(loc,span_warning("\The [src] is now using the next [new_batt.type_name] power cell."))
		else
			to_chat(loc,span_warning("\The [src] is now firing [new_batt.type_name]."))

	chambered = new_batt
	update_charge()
	update_icon()
	var/mob/living/M = loc // TGMC Ammo HUD
	if(istype(M)) // TGMC Ammo HUD
		M?.hud_used.update_ammo_hud(M, src)

/obj/item/gun/projectile/cell_loaded/attack_self(mob/user)
	if(!chambered)
		return

	var/list/stored_ammo = ammo_magazine.stored_ammo

	if(stored_ammo.len == 1)
		return //silly you.

	//Find an ammotype that ISN'T the same, or exhaust the list and don't change.
	var/our_slot = stored_ammo.Find(chambered)

	for(var/index in 1 to stored_ammo.len)
		var/true_index = ((our_slot + index - 1) % stored_ammo.len) + 1 // Stupid ONE BASED lists!
		var/obj/item/ammo_casing/microbattery/next_batt = stored_ammo[true_index]
		if(chambered != next_batt && !istype(next_batt, chambered.type))
			switch_to(next_batt)
			break
/*
/obj/item/gun/projectile/cell_loaded/special_check(mob/user)
	if(!chambered)
		return

	var/obj/item/ammo_casing/microbattery/batt = chambered
	if(!batt.shots_left)
		return FALSE

	return TRUE
*/
/obj/item/gun/projectile/cell_loaded/load_ammo(var/obj/item/A, mob/user)
	. = ..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		switch_to(ammo_magazine.stored_ammo[1])

/obj/item/gun/projectile/cell_loaded/unload_ammo(mob/user, var/allow_dump=1)
	chambered = null
	return ..()

/obj/item/gun/projectile/cell_loaded/update_icon()
	update_charge()

	cut_overlays()
	if(!chambered)
		return

	var/obj/item/ammo_casing/microbattery/batt = chambered
	var/batt_color = batt.type_color //Used many times

	//Mode bar
	var/image/mode_bar = image(icon, icon_state = "[initial(icon_state)]_type")
	mode_bar.color = batt_color
	add_overlay(mode_bar)

	//Barrel color
	var/image/barrel_color = image(icon, icon_state = "[initial(icon_state)]_barrel")
	barrel_color.alpha = 150
	barrel_color.color = batt_color
	add_overlay(barrel_color)

	//Charge bar
	var/ratio = CEILING(((charge_left / max_charge) * charge_sections), 1)
	for(var/i = 0, i < ratio, i++)
		var/image/charge_bar = image(icon, icon_state = "[initial(icon_state)]_charge")
		charge_bar.pixel_x = i
		charge_bar.color = batt_color
		add_overlay(charge_bar)


// The Magazine //
/obj/item/ammo_magazine/cell_mag
	name = "microbattery magazine"
	desc = "A microbattery holder for a cell-based variable weapon."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "cell_mag"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	caliber = "nsfw"
	ammo_type = /obj/item/ammo_casing/microbattery
	initial_ammo = 0
	max_ammo = 3
	var/x_offset = 5  //for update_icon() shenanigans- moved here so it can be adjusted for bigger mags
	var/capname = "nsfw_mag" //as above
	var/chargename = "nsfw_mag" //as above
	mag_type = MAGAZINE

	var/list/modes = list()

/obj/item/ammo_magazine/cell_mag/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_casing/microbattery))
		var/obj/item/ammo_casing/microbattery/B = W
		if(!istype(B, ammo_type))
			to_chat(user, span_warning("[B] does not fit into [src]."))
			return
		if(stored_ammo.len >= max_ammo)
			to_chat(user, span_warning("[src] is full!"))
			return
		user.remove_from_mob(B)
		B.loc = src
		stored_ammo.Add(B)
		update_icon()
	playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
	update_icon()
	if(istype(loc, /obj/item/gun/projectile/cell_loaded)) // Update the HUD if we're in a gun + have a user. Not that one should be able to reload the mag while it's in a gun, but just in caaaaase.
		var/obj/item/gun/projectile/cell_loaded/cell_load = loc
		var/mob/living/M = cell_load.loc
		if(istype(M))
			M?.hud_used.update_ammo_hud(M, cell_load)

/obj/item/ammo_magazine/cell_mag/update_icon()
	cut_overlays()
	if(!stored_ammo.len)
		return //Why bother

	var/current = 0
	for(var/obj/item/ammo_casing/microbattery/batt as anything in stored_ammo)
		var/image/cap = image(icon, icon_state = "[capname]_cap")
		cap.color = batt.type_color
		cap.pixel_x = current * x_offset //Caps don't need a pixel_y offset
		add_overlay(cap)

		if(batt.shots_left)
			var/ratio = CEILING(((batt.shots_left / initial(batt.shots_left)) * 4), 1) //4 is how many lights we have a sprite for
			var/image/charge = image(icon, icon_state = "[chargename]_charge-[ratio]")
			charge.color = "#29EAF4" //Could use battery color but eh.
			charge.pixel_x = current * x_offset
			add_overlay(charge)

		current++ //Increment for offsets

/obj/item/ammo_magazine/cell_mag/advanced
	name = "advanced microbattery magazine"
	desc = "A microbattery holder for a cell-based variable weapon. This one has much more cell capacity!"
	max_ammo = 6
	x_offset = 3
	icon_state = "cell_mag_extended"


// The Casing //
/obj/item/ammo_casing/microbattery
	name = "\'NSFW\' microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "nsfw_batt"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	w_class = ITEMSIZE_TINY
	var/shots_left = 4

	leaves_residue = 0
	caliber = "nsfw"
	var/type_color = null
	var/type_name = null
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/microbattery/Initialize()
	. = ..()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	update_icon()

/obj/item/ammo_casing/microbattery/update_icon()
	cut_overlays()

	var/image/ends = image(icon, icon_state = "[initial(icon_state)]_ends")
	ends.color = type_color
	add_overlay(ends)

/obj/item/ammo_casing/microbattery/expend()
	shots_left--


// The Pack //
/obj/item/storage/secure/briefcase/nsfw_pack_hybrid
	name = "hybrid cell-loaded gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/gun/projectile/cell_loaded,/obj/item/ammo_magazine/cell_mag,/obj/item/ammo_casing/microbattery)

/obj/item/storage/secure/briefcase/nsfw_pack_hybrid/New()
	..()
	new /obj/item/gun/projectile/cell_loaded(src)
	new /obj/item/ammo_magazine/cell_mag/advanced(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/net(src)
	new /obj/item/ammo_casing/microbattery/combat/net(src)
	new /obj/item/ammo_casing/microbattery/medical/brute3(src)
	new /obj/item/ammo_casing/microbattery/medical/burn3(src)
	new /obj/item/ammo_casing/microbattery/medical/stabilize2(src)
	new /obj/item/ammo_casing/microbattery/medical/toxin3(src)
	new /obj/item/ammo_casing/microbattery/medical/omni3(src)

/obj/item/storage/secure/briefcase/nsfw_pack_hybrid_combat
	name = "military cell-loaded gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/gun/projectile/cell_loaded,/obj/item/ammo_magazine/cell_mag,/obj/item/ammo_casing/microbattery)

/obj/item/storage/secure/briefcase/nsfw_pack_hybrid_combat/New()
	..()
	new /obj/item/gun/projectile/cell_loaded(src)
	new /obj/item/ammo_magazine/cell_mag/advanced(src)
	new /obj/item/ammo_casing/microbattery/combat/shotstun(src)
	new /obj/item/ammo_casing/microbattery/combat/shotstun(src)
	new /obj/item/ammo_casing/microbattery/combat/lethal(src)
	new /obj/item/ammo_casing/microbattery/combat/lethal(src)
	new /obj/item/ammo_casing/microbattery/combat/lethal(src)
	new /obj/item/ammo_casing/microbattery/combat/ion(src)
	new /obj/item/ammo_casing/microbattery/combat/xray(src)
	new /obj/item/ammo_casing/microbattery/medical/stabilize2(src)
	new /obj/item/ammo_casing/microbattery/medical/haste(src)
	new /obj/item/ammo_casing/microbattery/medical/resist(src)

// TGMC Ammo HUD: Custom handling for cell-loaded weaponry.
/*
/obj/item/gun/projectile/cell_loaded/get_ammo_type()
	if(!projectile_type)
		return list("unknown", "unknown")
	else
		var/obj/item/projectile/P = projectile_type
		return list(initial(P.hud_state), initial(P.hud_state_empty))
*/
/obj/item/gun/projectile/cell_loaded/get_ammo_count()
	if(!chambered)
		return 0 // We're not chambered, so we have 0 rounds loaded.

	var/obj/item/ammo_casing/microbattery/batt = chambered

	var/shots
	if(ammo_magazine) // Check how much ammo we have
		for(var/obj/item/ammo_casing/microbattery/bullet as anything in ammo_magazine.stored_ammo)
			if(istype(bullet,batt.type))
				shots += bullet.shots_left
		if(shots > 0) // We have shots ready to fire.
			return shots
		else // We're out of shots.
			return 0
	else // Else, we're unloaded/don't have a magazine.
		return 0
