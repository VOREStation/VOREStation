// -------------- NSFW -------------
/obj/item/weapon/gun/projectile/nsfw //this one can load both medical and security cells! for ERT/admin use.
	name = "cell-loaded revolver"
	desc = "Variety is the spice of life! This weapon is a hybrid of the KHI-102b 'Nanotech Selectable-Fire Weapon' and the Vey-Med ML-3 'Medigun', dubbed the 'NSFW-ML3M'. \
	It can fire both harmful and healing cells with an internal nanite fabricator and energy weapon cell loader. Up to three combinations of \
	energy beams can be configured at once. Ammo not included."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)

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
	update_charge()

	cut_overlays()
	if(!chambered)
		return

	var/obj/item/ammo_casing/nsfw_batt/batt = chambered
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

/obj/item/weapon/gun/projectile/nsfw/combat
	name = "cell-loaded revolver"
	desc = "Variety is the spice of life! The KHI-102b 'Nanotech Selectable-Fire Weapon', or NSFW for short, is an unholy hybrid of an ammo-driven  \
	energy weapon that allows the user to mix and match their own fire modes. Up to three combinations of \
	energy beams can be configured at once. Ammo not included."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)

	description_info = "This gun is an energy weapon that uses interchangable microbatteries in a magazine. Each battery is a different beam type, and up to three can be loaded in the magazine. Each battery usually provides four discharges of that beam type, and multiple from the same type may be loaded to increase the number of shots for that type."
	description_fluff = "The Kitsuhana 'Nanotech Selectable Fire Weapon' allows one to customize their loadout in the field, or before deploying, to achieve various results in a weapon they are already familiar with wielding."
	description_antag = ""
	allowed_magazines = list(/obj/item/ammo_magazine/nsfw_mag/combat)


/obj/item/weapon/gun/projectile/nsfw/medical
	name = "\improper ML-3 \'Medigun\'"
	desc = "The ML-3 'Medigun', or ML3M for short, is a powerful cell-based ranged healing device based on the KHI-102b NSFW. \
	It uses an internal nanite fabricator, powered and controlled by discrete cells, to deliver a variety of effects at range. Up to three combinations of \
	healing beams can be configured at once. Ammo not included."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)

	icon_state = "ml3m"
	description_info = "This is a ranged healing device that uses interchangable nanite discharge cells in a magazine. Each cell is a different healing beam type, and up to three can be loaded in the magazine. Each battery usually provides four discharges of that beam type, and multiple from the same type may be loaded to increase the number of shots for that type."
	description_fluff = "The Vey-Med ML-3 'Medigun' allows one to customize their loadout in the field, or before deploying, to allow emergency response personnel to deliver a variety of ranged healing options."
	description_antag = ""
	allowed_magazines = list(/obj/item/ammo_magazine/nsfw_mag/medical)

/obj/item/weapon/gun/projectile/nsfw/medical/cmo
	name = "\improper Advanced ML-3 \'Medigun\'"
	desc = "This is a variation on the ML-3 'Medigun', a powerful cell-based ranged healing device based on the KHI-102b NSFW. \
	It has an extended sight for increased accuracy, and is capable of holding large magazines. Ammo not included."

	icon_state = "ml3m_cmo"


// The Magazine //
/obj/item/ammo_magazine/nsfw_mag
	name = "microbattery magazine"
	desc = "A microbattery holder for a cell-based variable weapon."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "nsfw_mag"
	caliber = "nsfw"
	matter = list(DEFAULT_WALL_MATERIAL = 1680, "glass" = 2000)
	ammo_type = /obj/item/ammo_casing/nsfw_batt
	initial_ammo = 0
	max_ammo = 3
	var/x_offset = 5  //for update_icon() shenanigans- moved here so it can be adjusted for bigger mags
	var/capname = "nsfw_mag" //as above
	var/chargename = "nsfw_mag" //as above
	mag_type = MAGAZINE

	var/list/modes = list()

/obj/item/ammo_magazine/nsfw_mag/update_icon()
	cut_overlays()
	if(!stored_ammo.len)
		return //Why bother

	var/current = 0
	for(var/B in stored_ammo)
		var/obj/item/ammo_casing/nsfw_batt/batt = B
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

/obj/item/ammo_magazine/nsfw_mag/combat //security
	name = "microbattery magazine"
	desc = "A microbattery holder for the \'NSFW\'"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)
	description_info = "This magazine holds NSFW microbatteries to power the NSFW handgun. Up to three can be loaded at once, and each provides four shots of their respective energy type. Loading multiple of the same type will provide additional shots of that type. The batteries can be recharged in a normal recharger."
	ammo_type = /obj/item/ammo_casing/nsfw_batt/combat

/obj/item/ammo_magazine/nsfw_mag/medical //medical
	name = "nanite magazine"
	desc = "A nanite fabrication magazine for the \'ML-3/M\'"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)
	description_info = "This magazine holds self-charging nanite fabricators to power the ML-3 'Medigun'. Up to three can be loaded at once, and each provides four shots of their respective healing type. Loading multiple of the same type will provide additional shots of that type. The batteries can be recharged in a normal recharger."
	ammo_type = /obj/item/ammo_casing/nsfw_batt/medical
	icon_state = "ml3m_mag"

/obj/item/ammo_magazine/nsfw_mag/medical/advanced
	name = "advanced nanite magazine"
	desc = "A nanite discharge cell for the \'ML-3/M\'. This one is a more advanced version which can hold six individual nanite discharge cells."
	max_ammo = 6
	x_offset = 3
	icon_state = "ml3m_mag_extended"

// The Casing //
/obj/item/ammo_casing/nsfw_batt
	name = "\'NSFW\' microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)
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

/obj/item/ammo_casing/nsfw_batt/Initialize()
	. = ..()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	update_icon()

/obj/item/ammo_casing/nsfw_batt/update_icon()
	cut_overlays()

	var/image/ends = image(icon, icon_state = "[initial(icon_state)]_ends")
	ends.color = type_color
	add_overlay(ends)

/obj/item/ammo_casing/nsfw_batt/expend()
	shots_left--

// Specific batteries //
// Security (Combat) //

/obj/item/ammo_casing/nsfw_batt/combat
	name = "\'NSFW\' microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)

/obj/item/ammo_casing/nsfw_batt/combat/lethal
	name = "\'NSFW\' microbattery - LETHAL"
	type_color = "#bf3d3d"
	type_name = "<span style='color:#bf3d3d;font-weight:bold;'>LETHAL</span>"
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/nsfw_batt/combat/stun
	name = "\'NSFW\' microbattery - STUN"
	type_color = "#0f81bc"
	type_name = "<span style='color:#0f81bc;font-weight:bold;'>STUN</span>"
	projectile_type = /obj/item/projectile/beam/stun/blue

/obj/item/ammo_casing/nsfw_batt/combat/net
	name = "\'NSFW\' microbattery - NET"
	type_color = "#43f136"
	type_name = "<span style='color:#43d136;font-weight:bold;'>NET</span>"
	projectile_type = /obj/item/projectile/beam/energy_net

/obj/item/ammo_casing/nsfw_batt/combat/xray
	name = "\'NSFW\' microbattery - XRAY"
	type_color = "#32c025"
	type_name = "<span style='color:#32c025;font-weight:bold;'>XRAY</span>"
	projectile_type = /obj/item/projectile/beam/xray

/obj/item/ammo_casing/nsfw_batt/combat/shotstun
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

/obj/item/ammo_casing/nsfw_batt/combat/ion
	name = "\'NSFW\' microbattery - ION"
	type_color = "#d084d6"
	type_name = "<span style='color:#d084d6;font-weight:bold;'>ION</span>"
	projectile_type = /obj/item/projectile/ion/small

/obj/item/ammo_casing/nsfw_batt/combat/stripper
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

/obj/item/ammo_casing/nsfw_batt/combat/final
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

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

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

/obj/item/weapon/storage/secure/briefcase/nsfw_pack
	name = "\improper KHI-102b \'NSFW\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL

/obj/item/weapon/storage/secure/briefcase/nsfw_pack/New()
	..()
	new /obj/item/weapon/gun/projectile/nsfw/combat(src)
	new /obj/item/ammo_magazine/nsfw_mag/combat(src)
	for(var/path in subtypesof(/obj/item/ammo_casing/nsfw_batt/combat))
		new path(src)

/obj/item/weapon/storage/secure/briefcase/nsfw_pack_hos
	name = "\improper KHI-102b \'NSFW\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL

/obj/item/weapon/storage/secure/briefcase/nsfw_pack_hos/New()
	..()
	new /obj/item/weapon/gun/projectile/nsfw/combat(src)
	new /obj/item/ammo_magazine/nsfw_mag/combat(src)
	new /obj/item/ammo_casing/nsfw_batt/combat/lethal(src)
	new /obj/item/ammo_casing/nsfw_batt/combat/lethal(src)
	new /obj/item/ammo_casing/nsfw_batt/combat/stun(src)
	new /obj/item/ammo_casing/nsfw_batt/combat/stun(src)
	new /obj/item/ammo_casing/nsfw_batt/combat/net(src)
	new /obj/item/ammo_casing/nsfw_batt/combat/ion(src)

/obj/item/weapon/storage/firstaid/ml3m_pack_med
	name = "\improper ML-3 \'Medigun\' kit"
	desc = "A storage case for a multi-purpose healing gun. Variety hour!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	icon_state = "pinky"

/obj/item/weapon/storage/firstaid/ml3m_pack_med/New()
	..()
	new /obj/item/weapon/gun/projectile/nsfw/medical(src)
	new /obj/item/ammo_magazine/nsfw_mag/medical(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/brute(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/burn(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/stabilize(src)

/obj/item/weapon/storage/firstaid/ml3m_pack_cmo
	name = "\improper Advanced ML-3 \'Medigun\' kit"
	desc = "A storage case for a multi-purpose healing gun. Variety hour!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_NORMAL
	icon_state = "clottingkit"

/obj/item/weapon/storage/firstaid/ml3m_pack_cmo/New()
	..()
	new /obj/item/weapon/gun/projectile/nsfw/medical/cmo(src)
	new /obj/item/ammo_magazine/nsfw_mag/medical/advanced(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/brute2(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/brute2(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/burn2(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/burn2(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/stabilize2(src)
	new /obj/item/ammo_casing/nsfw_batt/medical/stabilize2(src)


// Medical //

/obj/item/ammo_casing/nsfw_batt/medical
	name = "\'ML-3/M\' nanite cell - UNKNOWN"
	desc = "A miniature nanite fabricator for a medigun."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)
	icon_state = "ml3m_batt"

/obj/item/projectile/beam/ML3M
	name = "\improper healing beam"
	icon_state = "medbeam"
	nodamage = 1
	damage = 0
	check_armour = "laser"
	light_color = "#80F5FF"

	combustion = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/medigun
	tracer_type = /obj/effect/projectile/tracer/medigun
	impact_type = /obj/effect/projectile/impact/medigun

/obj/item/projectile/beam/ML3M/on_hit(var/mob/living/carbon/human/target) //what does it do when it hits someone?
	return

/obj/item/ammo_casing/nsfw_batt/medical/brute
	name = "\'ML-3/M\' nanite cell - BRUTE"
	type_color = "#BF0000"
	type_name = "<span style='color:#BF0000;font-weight:bold;'>BRUTE</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/brute

/obj/item/projectile/beam/ML3M/brute/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-10)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/burn
	name = "\'ML-3/M\' nanite cell - BURN"
	type_color = "#FF8000"
	type_name = "<span style='color:#FF8000;font-weight:bold;'>BURN</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/burn

/obj/item/projectile/beam/ML3M/burn/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustFireLoss(-10)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/stabilize
	name = "\'ML-3/M\' nanite cell - STABILIZE" //Disinfects all open wounds, cures oxy damage
	type_color = "#0080FF"
	type_name = "<span style='color:#0080FF;font-weight:bold;'>STABILIZE</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/stabilize

/obj/item/projectile/beam/ML3M/stabilize/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustOxyLoss(-30)
		for(var/name in list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO))
			var/obj/item/organ/external/O = target.organs_by_name[name]
			for (var/datum/wound/W in O.wounds)
				if (W.internal)
					continue
				W.disinfect()
		target.add_modifier(/datum/modifier/stabilize, 20 SECONDS)
	else
		return 1

/datum/modifier/stabilize
	name = "stabilize"
	desc = "Your injuries are stabilized and your pain abates!"
	mob_overlay_state = "cyan_sparkles"
	stacks = MODIFIER_STACK_EXTEND
	pain_immunity = TRUE
	bleeding_rate_percent = 0.1 //only a little
	incoming_oxy_damage_percent = 0

/obj/item/ammo_casing/nsfw_batt/medical/tox
	name = "\'ML-3/M\' nanite cell - TOX"
	type_color = "#00A000"
	type_name = "<span style='color:#00A000;font-weight:bold;'>TOX</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/tox

/obj/item/projectile/beam/ML3M/tox/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustToxLoss(-10)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/omni
	name = "\'ML-3/M\' nanite cell - OMNI"
	type_color = "#8040FF"
	type_name = "<span style='color:#8040FF;font-weight:bold;'>OMNI</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/omni

/obj/item/projectile/beam/ML3M/omni/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-5)
		target.adjustFireLoss(-5)
		target.adjustToxLoss(-5)
		target.adjustOxyLoss(-15)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/antirad
	name = "\'ML-3/M\' nanite cell - OMNI"
	type_color = "#008000"
	type_name = "<span style='color:#008000;font-weight:bold;'>ANTIRAD</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/antirad

/obj/item/projectile/beam/ML3M/antirad/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustToxLoss(-5)
		target.radiation = max(target.radiation - 350, 0) //same as 5 units of arithrazine, sans the brute damage
	else
		return 1


/obj/item/ammo_casing/nsfw_batt/medical/brute2
	name = "\'ML-3/M\' nanite cell - BRUTE-II"
	type_color = "#BF0000"
	type_name = "<span style='color:#BF0000;font-weight:bold;'>BRUTE-II</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/brute2

/obj/item/projectile/beam/ML3M/brute2/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-20)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/burn2
	name = "\'ML-3/M\' nanite cell - BURN-II"
	type_color = "#FF8000"
	type_name = "<span style='color:#FF8000;font-weight:bold;'>BURN-II</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/burn2

/obj/item/projectile/beam/ML3M/burn2/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustFireLoss(-20)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/stabilize2
	name = "\'ML-3/M\' nanite cell - STABILIZE-II" //Disinfects and bandages all open wounds, cures all oxy damage
	type_color = "#0080FF"
	type_name = "<span style='color:#0080FF;font-weight:bold;'>STABILIZE-II</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/stabilize2

/obj/item/projectile/beam/ML3M/stabilize2/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustOxyLoss(-200)
		for(var/name in list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO))
			var/obj/item/organ/external/O = target.organs_by_name[name]
			for (var/datum/wound/W in O.wounds)
				if(W.internal)
					continue
				if(O.is_bandaged() == FALSE)
					W.bandage()
				if(O.is_salved() == FALSE)
					W.salve()
				W.disinfect()
		target.add_modifier(/datum/modifier/stabilize, 20 SECONDS)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/omni2
	name = "\'ML-3/M\' nanite cell - OMNI-II"
	type_color = "#8040FF"
	type_name = "<span style='color:#8040FF;font-weight:bold;'>OMNI-II</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/omni2

/obj/item/projectile/beam/ML3M/omni2/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-10)
		target.adjustFireLoss(-10)
		target.adjustToxLoss(-10)
		target.adjustOxyLoss(-30)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/tox2
	name = "\'ML-3/M\' nanite cell - TOX-II"
	type_color = "#00A000"
	type_name = "<span style='color:#00A000;font-weight:bold;'>TOX-II</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/tox2

/obj/item/projectile/beam/ML3M/tox2/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustToxLoss(-20)
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/haste
	name = "\'ML-3/M\' nanite cell - HASTE"
	type_color = "#FF3300"
	type_name = "<span style='color:#FF3300;font-weight:bold;'>HASTE</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/haste

/obj/item/projectile/beam/ML3M/haste/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.add_modifier(/datum/modifier/ml3mhaste, 20 SECONDS)
	else
		return 1

/datum/modifier/ml3mhaste
	name = "haste"
	desc = "You can move much faster!"
	mob_overlay_state = "haste"
	stacks = MODIFIER_STACK_EXTEND
	slowdown = -1 //a little faster!
	evasion = 1.25 //and a little harder to hit!

/obj/item/ammo_casing/nsfw_batt/medical/resistance
	name = "\'ML-3/M\' nanite cell - RESIST"
	type_color = "#555555"
	type_name = "<span style='color:#555555;font-weight:bold;'>RESIST</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/resistance

/obj/item/projectile/beam/ML3M/resistance/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.add_modifier(/datum/modifier/resistance, 20 SECONDS)
	else
		return 1

/datum/modifier/resistance
	name = "resistance"
	desc = "You resist 25% of all incoming damage and stuns!"
	mob_overlay_state = "repel_missiles"
	stacks = MODIFIER_STACK_EXTEND
	disable_duration_percent = 0.75
	incoming_damage_percent = 0.75

/obj/item/ammo_casing/nsfw_batt/medical/revival
	name = "\'ML-3/M\' nanite cell - REVIVAL"
	type_color = "#669900"
	type_name = "<span style='color:#669900;font-weight:bold;'>REVIVAL</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/revival

/obj/item/projectile/beam/ML3M/revival/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		if(target.stat == DEAD)
			target.adjustBruteLoss(-50)
			target.adjustFireLoss(-50)
			target.adjustToxLoss(-50)
			target.adjustOxyLoss(-200)
	else
		return 1

/datum/modifier/resistance
	name = "resistance"
	desc = "You resist 25% of all incoming damage and stuns!"
	mob_overlay_state = "repel_missiles"
	stacks = MODIFIER_STACK_EXTEND
	disable_duration_percent = 0.75
	incoming_damage_percent = 0.75

// Illegal cells!
/obj/item/ammo_casing/nsfw_batt/medical/shrink
	name = "\'ML-3/M\' nanite cell - SHRINK"
	type_color = "#910ffc"
	type_name = "<span style='color:#910ffc;font-weight:bold;'>SHRINK</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/shrink

/obj/item/projectile/beam/ML3M/shrink/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.resize(0.5)
		target.show_message("<font color='blue'> The beam fires into your body, changing your size!</font>")
		target.updateicon()
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/grow
	name = "\'ML-3/M\' nanite cell - GROW"
	type_color = "#fc0fdc"
	type_name = "<span style='color:#fc0fdc;font-weight:bold;'>GROW</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/grow

/obj/item/projectile/beam/ML3M/grow/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.resize(2.0)
		target.show_message("<font color='blue'> The beam fires into your body, changing your size!</font>")
		target.updateicon()
	else
		return 1

/obj/item/ammo_casing/nsfw_batt/medical/normalsize
	name = "\'ML-3/M\' nanite cell - NORMALSIZE"
	type_color = "#C70FEC"
	type_name = "<span style='color:#C70FEC;font-weight:bold;'>NORMALSIZE</span>"
	projectile_type = /obj/item/projectile/beam/ML3M/normalsize

/obj/item/projectile/beam/ML3M/normalsize/on_hit(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.resize(1)
		target.show_message("<font color='blue'> The beam fires into your body, changing your size!</font>")
		target.updateicon()
	else
		return 1