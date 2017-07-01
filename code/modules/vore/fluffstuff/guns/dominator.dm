// -------------- Dominator -------------
/obj/item/weapon/gun/energy/gun/fluff/dominator
	name = "\improper MWPSB Dominator"
	desc = "A MWPSB's Dominator from the Federation. Like the basic Energy Gun, this gun has two settings. It is used by the United Federation Public Safety Bureau's Criminal Investigation Division."

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

// Dominator Ammo
/obj/item/projectile/beam/dominator
	name = "dominator lethal beam"
	icon_state = "xray"
	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact