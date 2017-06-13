// -------------- Protector -------------
/obj/item/weapon/gun/energy/gun/protector
	name = "\improper KHI-98a \'Protector\'"
	desc = "The KHI-98a is the first firearm custom-designed for Nanotrasen by KHI. It features a powerful stun mode, and \
	an alert-level-locked lethal mode, only usable on code blue and higher. It also features a DNA lock mechanism."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "protstun100"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	fire_sound = 'sound/weapons/Taser.ogg'
	projectile_type = /obj/item/projectile/beam/stun

	modifystate = "protstun"

	dna_lock = 1

	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)

	firemodes = list(
	list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/protector, modifystate="protstun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="protkill", fire_sound='sound/weapons/gauss_shoot.ogg'),
	)

	var/emagged = FALSE

/obj/item/weapon/gun/energy/gun/protector/special_check(mob/user)
	if(!emagged && mode_name == "lethal" && get_security_level() == "green")
		to_chat(user,"<span class='warning'>The trigger refuses to depress while on the lethal setting under security level green!</span>")
		return FALSE

	return ..()


/obj/item/weapon/gun/energy/gun/protector/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(!emagged)
		emagged = TRUE
		to_chat(user,"<span class='warning'>You disable the alert level locking mechanism on \the [src]!</span>")

	return TRUE

// Protector beams
/obj/item/projectile/beam/stun/protector
	name = "protector stun beam"
	icon_state = "omnilaser" //A little more cyan
	light_color = "#00C6FF"
	agony = 50 //Normal is 40 when this was set
	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

//R&D Design
/datum/design/item/weapon/protector
	desc = "The 'Protector' is an advanced energy gun that cannot be fired in lethal mode on low security alert levels, but features DNA locking and a powerful stun."
	id = "protector"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 2000, "silver" = 1000)
	build_path = /obj/item/weapon/gun/energy/gun/protector
	sort_string = "TAADA"
