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
	charge_cost = 100
	projectile_type = /obj/item/projectile/beam/sizelaser
	origin_tech = "bluespace=4"
	modifystate = "sizegun-shrink"
	self_recharge = 1
	var/size_set_to = 1
	firemodes = list(
		list(mode_name		= "select size",
			projectile_type	= /obj/item/projectile/beam/sizelaser,
			modifystate		= "sizegun-grow",
			fire_sound		= 'sound/weapons/pulse3.ogg'
		))

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

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

	on_hit(var/atom/target)
		var/mob/living/M = target
		if(ishuman(target))
			var/mob/living/carbon/human/H = M
			H.resize(set_size)
			H.show_message("<font color='blue'> The beam fires into your body, changing your size!</font>")
			H.updateicon()
		else if (istype(target, /mob/living/))
			var/mob/living/H = M
			H.resize(set_size)
			H.updateicon()
		else
			return 1

/obj/item/weapon/gun/energy/sizegun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/beam/sizelaser/G = .
	if(istype(G))
		G.set_size = size_set_to

/obj/item/weapon/gun/energy/sizegun/verb/select_size()
	set name = "Select Size"
	set category = "Object"
	set src in view(1)

	var/size_select = input("Put the desired size (25-200%)", "Set Size", 200) as num
	if(size_select>200 || size_select<25)
		usr << "<span class='notice'>Invalid size.</span>"
		return
	size_set_to = (size_select/100)
	usr << "<span class='notice'>You set the size to [size_select]%</span>"

/obj/item/weapon/gun/energy/sizegun/examine(mob/user)
	..()
	var/size_examine = (size_set_to*100)
	user << "<span class='info'>It is currently set at [size_examine]%</span>"
