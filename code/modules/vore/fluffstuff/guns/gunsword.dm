/obj/item/weapon/gun/energy/gun/fluff/gunsword
	name = "Sword Buster"
	desc = "The Sword Buster gun is custom built using the science behind a Golden Empire pistol. The cell can be removed in close range and used as energy shortsword."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "gbuster100"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = null
	item_icons = null

	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 4)
	slot_flags = null
	projectile_type = /obj/item/projectile/beam/stun
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	charge_meter = 1

	cell_type = /obj/item/weapon/cell/device/weapon/gunsword

	modifystate = "gbuster"

	firemodes = list(
	list(mode_name="stun", charge_cost=240,projectile_type=/obj/item/projectile/beam/stun, modifystate="gbuster", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", charge_cost=480,projectile_type=/obj/item/projectile/beam, modifystate="gbuster", fire_sound='sound/weapons/gauss_shoot.ogg'),
	)



// -----------------gunsword battery--------------------------
/obj/item/weapon/cell/device/weapon/gunsword
	name = "Buster Cell"
	desc = "The Buster Cell. It doubles as a sword when activated outside the gun housing."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "gsaberoff"
	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gsaberoff"
	maxcharge = 2400
	charge_amount = 20
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 5)

	var/active = 0
	var/active_force = 30
	var/active_throwforce = 20
	var/active_w_class = ITEMSIZE_LARGE
	var/active_embed_chance = 0		//In the off chance one of these is supposed to embed, you can just tweak this var
	sharp = 0
	edge = 0
	armor_penetration = 50
	flags = NOBLOODY
	var/lrange = 2
	var/lpower = 2
	var/lcolor = "#800080"


/obj/item/weapon/cell/device/weapon/gunsword/proc/activate(mob/living/user)
	if(active)
		return
	icon_state = "gsaber"
	item_state = "gsaber"
	active = 1
	embed_chance = active_embed_chance
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	w_class = active_w_class
	playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
	set_light(lrange, lpower, lcolor)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")



/obj/item/weapon/cell/device/weapon/gunsword/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
	icon_state = "gsaberoff"
	item_state = "gsaberoff"
	active = 0
	embed_chance = initial(embed_chance)
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)
	set_light(0,0)
	attack_verb = list()


/obj/item/weapon/cell/device/weapon/gunsword/attack_self(mob/living/user as mob)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts [TU.himself] with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			user.take_organ_damage(5,5)
		deactivate(user)
		update_icon()
		update_held_icon()
	else
		activate(user)
		update_icon()
		update_held_icon()

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/weapon/cell/device/weapon/gunsword/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	if(active)
		user.visible_message(pick("<span class='danger'>\The [user] is slitting [TU.his] stomach open with \the [src]! It looks like [TU.he] [TU.is] trying to commit seppuku.</span>",\
			"<span class='danger'>\The [user] is falling on \the [src]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>"))
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/cell/device/weapon/gunsword/update_icon()
	overlays.Cut()