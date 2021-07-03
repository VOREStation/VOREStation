//
// Size Gun
//

/obj/item/weapon/gun/energy/sizegun
	name = "size gun" //I have no idea why this was called shrink ray when this increased and decreased size.
	desc = "A highly advanced ray gun with a knob on the side to adjust the size you desire. Warning: Do not insert into mouth."
	icon = 'icons/obj/gun_vr.dmi'
	icon_override = 'icons/obj/gun_vr.dmi'
	icon_state = "sizegun-shrink100"
	item_state = "sizegun-shrink"
	fire_sound = 'sound/weapons/wave.ogg'
	charge_cost = 240
	projectile_type = /obj/item/projectile/beam/sizelaser
	origin_tech = list(TECH_BLUESPACE = 4)
	modifystate = "sizegun-shrink"
	battery_lock = 1
	var/size_set_to = 1
	firemodes = list(
		list(mode_name		= "select size",
			projectile_type	= /obj/item/projectile/beam/sizelaser,
			modifystate		= "sizegun-grow",
			fire_sound		= 'sound/weapons/pulse3.ogg'
		))

/obj/item/weapon/gun/energy/sizegun/New()
	..()
	verbs += .proc/select_size

/obj/item/weapon/gun/energy/sizegun/attack_self(mob/user)
	. = ..()
	select_size()

/obj/item/weapon/gun/energy/sizegun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/beam/sizelaser/G = .
	if(istype(G))
		G.set_size = size_set_to

/obj/item/weapon/gun/energy/sizegun/proc/select_size()
	set name = "Select Size"
	set category = "Object"
	set src in view(1)

	var/prev_size = size_set_to
	var/size_select = input(usr, "Put the desired size (25-200%), (1-600%) in dormitory areas.", "Set Size", size_set_to * 100) as num|null
	if(!size_select)
		return //cancelled
	//We do valid resize testing in actual firings because people move after setting these things.
	//Just a basic clamp here to the valid ranges.
	size_set_to = clamp((size_select/100), RESIZE_MINIMUM_DORMS, RESIZE_MAXIMUM_DORMS)
	to_chat(usr, "<span class='notice'>You set the size to [size_select]%</span>")
	if(size_set_to < RESIZE_MINIMUM || size_set_to > RESIZE_MAXIMUM)
		to_chat(usr, "<span class='notice'>Note: Resizing limited to 25-200% automatically while outside dormatory areas.</span>") //hint that we clamp it in resize
	
	if(size_set_to >= 1 && prev_size < 1)
		item_state = modifystate = "sizegun-grow"
		update_icon()
		
	else if(size_set_to < 1 && prev_size >= 1)
		item_state = modifystate = "sizegun-shrink"
		update_icon()

/obj/item/weapon/gun/energy/sizegun/examine(mob/user)
	. = ..()
	. += "<span class='info'>It is currently set at [size_set_to*100]%</span>"

/obj/item/weapon/gun/energy/sizegun/admin
	name = "modified size gun"
	desc = "Sizegun, without limits on minimum/maximum size, and with unlimited charge. Time to show 'em that size does matter."
	charge_cost = 0
	projectile_type = /obj/item/projectile/beam/sizelaser/admin

/obj/item/weapon/gun/energy/sizegun/abductor
	name = "alien size gun"
	icon_state = "sizegun-abductor"
	item_state = "laser"
	charge_cost = 0
	projectile_type = /obj/item/projectile/beam/sizelaser/admin

/obj/item/weapon/gun/energy/sizegun/abductor/update_icon(ignore_inhands)
	item_state = initial(item_state)

/obj/item/weapon/gun/energy/sizegun/admin/select_size()
	set name = "Select Size"
	set category = "Object"
	set src in view(1)

	var/size_select = input(usr, "Put the desired size (1-600%)", "Set Size", size_set_to * 100) as num|null
	if(!size_select)
		return //cancelled
	size_set_to = clamp((size_select/100), 0, 1000) //eheh
	to_chat(usr, "<span class='notice'>You set the size to [size_select]%</span>")

//
// Beams for size gun
//

/obj/item/projectile/beam/sizelaser
	name = "size beam"
	icon_state = "xray"
	nodamage = 1
	damage = 0
	check_armour = "laser"
	var/set_size = 1 //Let's default to 100%

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/sizelaser/on_hit(var/atom/target)
	var/mob/living/M = target
	var/ignoring_prefs = (target == firer ? TRUE : FALSE) // Resizing yourself
	
	if(istype(M))
		if(!M.resize(set_size, uncapped = M.has_large_resize_bounds(), ignore_prefs = ignoring_prefs))
			to_chat(M, "<font color='blue'>The beam fires into your body, changing your size!</font>")
		M.updateicon()
		return
	return 1

/obj/item/projectile/beam/sizelaser/admin/on_hit(var/atom/target)
	var/mob/living/M = target
	
	if(istype(M))

		var/can_be_big = M.has_large_resize_bounds()
		var/very_big = is_extreme_size(set_size)

		if(very_big && can_be_big) // made an extreme size in an area that allows it, don't assume adminbuse
			to_chat(firer, "<span class='warning'>[M] will lose this size upon moving into an area where this size is not allowed.</span>")
		else if(very_big) // made an extreme size in an area that doesn't allow it, assume adminbuse
			to_chat(firer, "<span class='warning'>[M] will retain this normally unallowed size outside this area.</span>")
		
		M.resize(set_size, uncapped = TRUE, ignore_prefs = TRUE) // Always ignores prefs, caution is advisable

		to_chat(M, "<font color='blue'>The beam fires into your body, changing your size!</font>")
		M.updateicon()
		return
	return 1

/obj/item/projectile/beam/sizelaser/shrink
	set_size = 0.5 //50% of current size

/obj/item/projectile/beam/sizelaser/grow
	set_size = 2.0 //200% of current size

/obj/item/weapon/gun/energy/sizegun/mounted
	name = "mounted size gun"
	self_recharge = 1
	use_external_power = 1