// -------------- NSFW -------------
/obj/item/weapon/gun/projectile/nsfw
	name = "KHI-102b \'NSFW\'"
	desc = "Variety is the spice of life! The 'Nanotech Selectable-Fire Weapon' is an unholy hybrid of an ammo-driven \
	energy weapon that allows the user to mix and match their own fire modes. Up to three combinations of \
	energy beams can be configured at once. Ammo not included."

	description_info = "This gun is an energy weapon that uses interchangable microbatteries in a magazine. Each battery is a different beam type, and up to three can be loaded in the magazine. Each battery usually provides four discharges of that beam type, and multiple from the same type may be loaded to increase the number of shots for that type."
	description_fluff = "The Kitsuhana 'Nanotech Selectable Fire Weapon' allows one to customize their loadout in the field, or before deploying, to achieve various results in a weapon they are already familiar with wielding."
	description_antag = ""

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "nsfw"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	caliber = "nsfw"

	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_MAGNETS = 4)

	fire_sound = 'sound/weapons/Taser.ogg'

	load_method = MAGAZINE //Nyeh heh hehhh.
	magazine_type = null
	allowed_magazines = list(/obj/item/ammo_magazine/nsfw_mag)
	handle_casings = HOLD_CASINGS //Don't eject batteries!
	recoil = 0
	var/charge_left = 0
	var/max_charge = 0
	charge_sections = 5

/obj/item/weapon/gun/projectile/nsfw/consume_next_projectile()
	if(chambered && ammo_magazine)
		var/obj/item/ammo_casing/nsfw_batt/batt = chambered
		if(batt.shots_left)
			return new chambered.projectile_type()
		else
			for(var/B in ammo_magazine.stored_ammo)
				var/obj/item/ammo_casing/nsfw_batt/other_batt = B
				if(istype(other_batt,chambered.type) && other_batt.shots_left)
					switch_to(other_batt)
					return new chambered.projectile_type()
					break

	return null

/obj/item/weapon/gun/projectile/nsfw/proc/update_charge()
	charge_left = 0
	max_charge = 0

	if(!chambered)
		return

	var/obj/item/ammo_casing/nsfw_batt/batt = chambered

	charge_left = batt.shots_left
	max_charge = initial(batt.shots_left)
	if(ammo_magazine) //Crawl to find more
		for(var/B in ammo_magazine.stored_ammo)
			var/obj/item/ammo_casing/nsfw_batt/bullet = B
			if(istype(bullet,batt.type))
				charge_left += bullet.shots_left
				max_charge += initial(bullet.shots_left)

/obj/item/weapon/gun/projectile/nsfw/proc/switch_to(obj/item/ammo_casing/nsfw_batt/new_batt)
	if(ishuman(loc))
		if(chambered && new_batt.type == chambered.type)
			to_chat(loc,"<span class='warning'>\The [src] is now using the next [new_batt.type_name] power cell.</span>")
		else
			to_chat(loc,"<span class='warning'>\The [src] is now firing [new_batt.type_name].</span>")

	chambered = new_batt
	update_charge()
	update_icon()

/obj/item/weapon/gun/projectile/nsfw/attack_self(mob/user)
	if(!chambered)
		return

	var/list/stored_ammo = ammo_magazine.stored_ammo

	if(stored_ammo.len == 1)
		return //silly you.

	//Find an ammotype that ISN'T the same, or exhaust the list and don't change.
	var/our_slot = stored_ammo.Find(chambered)

	for(var/index in 1 to stored_ammo.len)
		var/true_index = ((our_slot + index - 1) % stored_ammo.len) + 1 // Stupid ONE BASED lists!
		var/obj/item/ammo_casing/nsfw_batt/next_batt = stored_ammo[true_index]
		if(chambered != next_batt && !istype(next_batt, chambered.type))
			switch_to(next_batt)
			break
/*
/obj/item/weapon/gun/projectile/nsfw/special_check(mob/user)
	if(!chambered)
		return

	var/obj/item/ammo_casing/nsfw_batt/batt = chambered
	if(!batt.shots_left)
		return FALSE

	return TRUE
*/
/obj/item/weapon/gun/projectile/nsfw/load_ammo(var/obj/item/A, mob/user)
	. = ..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		switch_to(ammo_magazine.stored_ammo[1])

/obj/item/weapon/gun/projectile/nsfw/unload_ammo(mob/user, var/allow_dump=1)
	chambered = null
	return ..()

/obj/item/weapon/gun/projectile/nsfw/update_icon()
	var/mutable_appearance/ma = new(src)
	update_charge()

	if(!chambered)
		ma.overlays = list()
		appearance = ma
		return

	var/obj/item/ammo_casing/nsfw_batt/batt = chambered
	var/batt_color = batt.type_color //Used many times
	var/list/newverlays = list()

	//Mode bar
	var/mutable_appearance/mode_bar = mutable_appearance(icon, "[initial(icon_state)]_type")
	mode_bar.color = batt_color
	newverlays += mode_bar

	//Barrel color
	var/mutable_appearance/barrel_color = mutable_appearance(icon, "[initial(icon_state)]_barrel")
	barrel_color.alpha = 150
	barrel_color.color = batt_color
	newverlays += barrel_color

	//Charge bar
	var/ratio = Ceiling((charge_left / max_charge) * charge_sections)
	for(var/i = 0, i < ratio, i++)
		var/mutable_appearance/charge_bar = mutable_appearance(icon, "[initial(icon_state)]_charge")
		charge_bar.pixel_x = i
		charge_bar.color = batt_color
		newverlays += charge_bar

	ma.overlays = newverlays
	if(ma.overlays.len != newverlays.len) //PANIC!
		del(ma)
		spawn(5)
			update_icon()
		return

	appearance = ma

// The Magazine //
/obj/item/ammo_magazine/nsfw_mag
	name = "microbattery magazine"
	desc = "A microbattery holder for the \'NSFW\'"

	description_info = "This magazine holds NSFW microbatteries to power the NSFW handgun. Up to three can be loaded at once, and each provides four shots of their respective energy type. Loading multiple of the same type will provide additional shots of that type. The batteries can be recharged in a normal recharger."

	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "nsfw_mag"
	caliber = "nsfw"
	matter = list(DEFAULT_WALL_MATERIAL = 1680, "glass" = 2000)
	ammo_type = /obj/item/ammo_casing/nsfw_batt
	initial_ammo = 0
	max_ammo = 3
	mag_type = MAGAZINE

	var/list/modes

/obj/item/ammo_magazine/nsfw_mag/New()
	..()
	modes = list()

/obj/item/ammo_magazine/nsfw_mag/update_icon()
	var/mutable_appearance/ma = new(src)

	if(!stored_ammo.len)
		ma.overlays = list()
		appearance = ma
		return //Why bother

	var/x_offset = 5
	var/list/newverlays = list()

	var/current = 0
	for(var/B in stored_ammo)
		var/obj/item/ammo_casing/nsfw_batt/batt = B
		var/mutable_appearance/cap = mutable_appearance(icon,"[initial(icon_state)]_cap")
		cap.color = batt.type_color
		cap.pixel_x = current * x_offset //Caps don't need a pixel_y offset
		newverlays += cap

		if(batt.shots_left)
			var/ratio = Ceiling((batt.shots_left / initial(batt.shots_left)) * 4) //4 is how many lights we have a sprite for
			var/mutable_appearance/charge = mutable_appearance(icon,"[initial(icon_state)]_charge-[ratio]")
			charge.color = "#29EAF4" //Could use battery color but eh.
			charge.pixel_x = current * x_offset
			newverlays += charge

		current++ //Increment for offsets

	ma.overlays = newverlays
	if(ma.overlays.len != newverlays.len) //PANIC!
		del(ma)
		spawn(5)
			update_icon()
		return

	appearance = ma

// The Casing //
/obj/item/ammo_casing/nsfw_batt
	name = "\'NSFW\' microbattery - LETHAL"
	desc = "A miniature battery for an energy weapon."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "nsfw_batt"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	w_class = ITEMSIZE_TINY

	leaves_residue = 0
	caliber = "nsfw"
	var/shots_left = 4
	var/type_color = "#bf3d3d"
	var/type_name = "<span style='color:#bf3d3d;font-weight:bold;'>LETHAL</span>"
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/nsfw_batt/New()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	update_icon()

/obj/item/ammo_casing/nsfw_batt/update_icon()
	var/mutable_appearance/ma = new(src)
	ma.overlays.Cut()

	var/mutable_appearance/ends = mutable_appearance(icon,"[initial(icon_state)]_ends")
	ends.color = type_color
	ma.overlays += ends

	appearance = ma

/obj/item/ammo_casing/nsfw_batt/expend()
	shots_left--

// Specific batteries //
/obj/item/ammo_casing/nsfw_batt/stun
	name = "\'NSFW\' microbattery - STUN"
	type_color = "#0f81bc"
	type_name = "<span style='color:#0f81bc;font-weight:bold;'>STUN</span>"
	projectile_type = /obj/item/projectile/beam/stun/blue

/obj/item/ammo_casing/nsfw_batt/net
	name = "\'NSFW\' microbattery - NET"
	type_color = "#43f136"
	type_name = "<span style='color:#43d136;font-weight:bold;'>NET</span>"
	projectile_type = /obj/item/projectile/beam/energy_net

/obj/item/ammo_casing/nsfw_batt/xray
	name = "\'NSFW\' microbattery - XRAY"
	type_color = "#32c025"
	type_name = "<span style='color:#32c025;font-weight:bold;'>XRAY</span>"
	projectile_type = /obj/item/projectile/beam/xray

/obj/item/ammo_casing/nsfw_batt/shotstun
	name = "\'NSFW\' microbattery - SCATTERSTUN"
	type_color = "#88ffff"
	type_name = "<span style='color:#88ffff;font-weight:bold;'>SCATTERSTUN</span>"
	projectile_type = /obj/item/projectile/bullet/pellet/e_shot_stun

/obj/item/projectile/bullet/pellet/e_shot_stun
	icon_state = "spell"
	damage = 2
	agony = 20
	pellets = 6			//number of pellets
	range_step = 2		//projectile will lose a fragment each time it travels this distance. Can be a non-integer.
	base_spread = 90	//lower means the pellets spread more across body parts. If zero then this is considered a shrapnel explosion instead of a shrapnel cone
	spread_step = 10
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

/obj/item/ammo_casing/nsfw_batt/ion
	name = "\'NSFW\' microbattery - ION"
	type_color = "#d084d6"
	type_name = "<span style='color:#d084d6;font-weight:bold;'>ION</span>"
	projectile_type = /obj/item/projectile/ion/small

/obj/item/ammo_casing/nsfw_batt/stripper
	name = "\'NSFW\' microbattery - STRIPPER"
	type_color = "#fc8d0f"
	type_name = "<span style='color:#fc8d0f;font-weight:bold;'>STRIPPER</span>"
	projectile_type = /obj/item/projectile/bullet/stripper

/obj/item/projectile/bullet/stripper
	icon_state = "magicm"
	nodamage = 1
	agony = 5
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

/obj/item/projectile/bullet/stripper/on_hit(var/atom/stripped)
	if(ishuman(stripped))
		var/mob/living/carbon/human/H = stripped
		if(H.wear_suit)
			H.unEquip(H.wear_suit)
		if(H.w_uniform)
			H.unEquip(H.w_uniform)
		if(H.back)
			H.unEquip(H.back)
		if(H.shoes)
			H.unEquip(H.shoes)
		if(H.gloves)
			H.unEquip(H.gloves)
		//Hats can stay! Most other things fall off with removing these.
	..()

/obj/item/ammo_casing/nsfw_batt/final
	name = "\'NSFW\' microbattery - FINAL OPTION"
	type_color = "#fcfc0f"
	type_name = "<span style='color:#000000;font-weight:bold;'>FINAL OPTION</span>" //Doesn't look good in yellow in chat
	projectile_type = /obj/item/projectile/beam/final_option

/obj/item/projectile/beam/final_option
	name = "final option beam"
	icon_state = "omnilaser"
	nodamage = 1
	agony = 5
	damage_type = HALLOSS
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/final_option/on_hit(var/atom/impacted)
	if(isliving(impacted))
		var/mob/living/L = impacted
		if(L.mind)
			var/nif
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				nif = H.nif
			SStranscore.m_backup(L.mind,nif,one_time = TRUE)
		L.gib()

	..()
/*
/obj/item/ammo_casing/nsfw_batt/shrink
	name = "\'NSFW\' microbattery - SHRINK"
	type_color = "#910ffc"
	type_name = "<span style='color:#910ffc;font-weight:bold;'>SHRINK</span>"
	projectile_type = /obj/item/projectile/beam/shrinklaser

/obj/item/ammo_casing/nsfw_batt/grow
	name = "\'NSFW\' microbattery - GROW"
	type_color = "#fc0fdc"
	type_name = "<span style='color:#fc0fdc;font-weight:bold;'>GROW</span>"
	projectile_type = /obj/item/projectile/beam/growlaser
*/
/obj/item/weapon/storage/secure/briefcase/nsfw_pack
	name = "\improper KHI-102b \'NSFW\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	max_w_class = ITEMSIZE_NORMAL

/obj/item/weapon/storage/secure/briefcase/nsfw_pack/New()
	..()
	new /obj/item/weapon/gun/projectile/nsfw(src)
	new /obj/item/ammo_magazine/nsfw_mag(src)
	for(var/path in typesof(/obj/item/ammo_casing/nsfw_batt))
		new path(src)

/obj/item/weapon/storage/secure/briefcase/nsfw_pack_hos
	name = "\improper KHI-102b \'NSFW\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	max_w_class = ITEMSIZE_NORMAL

/obj/item/weapon/storage/secure/briefcase/nsfw_pack_hos/New()
	..()
	new /obj/item/weapon/gun/projectile/nsfw(src)
	new /obj/item/ammo_magazine/nsfw_mag(src)
	new /obj/item/ammo_casing/nsfw_batt(src)
	new /obj/item/ammo_casing/nsfw_batt(src)
	new /obj/item/ammo_casing/nsfw_batt/stun(src)
	new /obj/item/ammo_casing/nsfw_batt/stun(src)
	new /obj/item/ammo_casing/nsfw_batt/net(src)
	new /obj/item/ammo_casing/nsfw_batt/ion(src)

