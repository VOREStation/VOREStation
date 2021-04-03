//
// Size Gun
//

/obj/item/weapon/gun/energy/sizegun
	name = "size gun" //I have no idea why this was called shrink ray when this increased and decreased size.
	desc = "A highly advanced ray gun with a knob on the side to adjust the size you desire. Warning: Do not insert into mouth."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "sizegun-shrink100" // Someone can probably do better. -Ace
	item_state = null	//so the human update icon uses the icon_state instead
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
	if(istype(src, /obj/item/weapon/gun/energy/sizegun/admin))
		verbs += /obj/item/weapon/gun/energy/sizegun/admin/select_size
	else
		verbs += /obj/item/weapon/gun/energy/sizegun/proc/select_size

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

	var/size_select = input("Put the desired size (25-200%), (1-600%) in dormitory areas.", "Set Size", size_set_to * 100) as num
	if(!size_range_check(size_select))
		to_chat(usr, "<span class='notice'>Invalid size.</span>")
		return
	size_set_to = (size_select/100)
	to_chat(usr, "<span class='notice'>You set the size to [size_select]%</span>")

/obj/item/weapon/gun/energy/sizegun/examine(mob/user)
	. = ..()
	. += "<span class='info'>It is currently set at [size_set_to*100]%</span>"

/obj/item/weapon/gun/energy/sizegun/admin
	name = "modified size gun"
	desc = "Sizegun, without limits on minimum/maximum size, and with unlimited charge. Time to show 'em that size does matter."
	charge_cost = 0
	projectile_type = /obj/item/projectile/beam/sizelaser/admin

/obj/item/weapon/gun/energy/sizegun/admin/select_size()
	set name = "Select Size"
	set category = "Object"
	set src in view(1)

	var/size_select = input("Put the desired size", "Set Size", size_set_to * 100) as num
	size_set_to = max(1,size_select/100)		//No negative numbers
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
	if(istype(M))
		if(!M.in_dorms() || !istype(M, /mob/living/carbon/human))
			if(!M.resize(clamp(set_size,0.25,2)))
				to_chat(M, "<font color='blue'>The beam fires into your body, changing your size!</font>")
		else
			if(!M.resize(clamp(set_size,0.01,6)))
				to_chat(M, "<font color='blue'>The beam fires into your body, changing your size!</font>")
		M.updateicon()
		return
	return 1

/obj/item/projectile/beam/sizelaser/admin/on_hit(var/atom/target)
	var/mob/living/M = target
	if(istype(M))
		M.resize(set_size, TRUE, FALSE)
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