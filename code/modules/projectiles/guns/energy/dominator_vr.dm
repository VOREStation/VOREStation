// -------------- Dominator -------------
/obj/item/gun/energy/gun/fluff/dominator
	name = "bulky energy gun"
	desc = "A MWPSB Dominator from the Federation. Like the basic Energy Gun, this gun has two settings. It is used by the United Federation Public Safety Bureau's Criminal Investigation Division. The weapon can only be fired by the owner and is alert-level locked."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "dominatorstun100"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = null
	item_icons = null

	fire_sound = 'sound/weapons/Taser.ogg'
	projectile_type = /obj/item/projectile/beam/stun

	modifystate = "dominatorstun"

	dna_lock = 1

	firemodes = list(
	list(mode_name="stun", charge_cost=240,projectile_type=/obj/item/projectile/beam/stun, modifystate="dominatorstun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", charge_cost=480,projectile_type=/obj/item/projectile/beam/dominator, modifystate="dominatorkill", fire_sound='sound/weapons/gauss_shoot.ogg'),
	)

	var/emagged = FALSE


/obj/item/gun/energy/gun/fluff/dominator/special_check(mob/user)
	if(!emagged && mode_name == "lethal" && get_security_level() == "green")
		to_chat(user,"<span class='warning'>The trigger refuses to depress while on the lethal setting under security level green!</span>")
		return FALSE

	return ..()

/obj/item/gun/energy/gun/fluff/dominator/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(!emagged)
		emagged = TRUE
		to_chat(user,"<span class='warning'>You disable the alert level locking mechanism on \the [src]!</span>")

	return TRUE


// Dominator Ammo
/obj/item/projectile/beam/dominator
	name = "dominator lethal beam"
	icon_state = "xray"
	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray
