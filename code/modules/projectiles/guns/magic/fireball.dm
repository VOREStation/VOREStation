
/obj/item/gun/magic/firestaff
	name = "flaming staff"
	desc = "A long, everburning torch."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staffoffire"
	item_state = "staff"
	fire_sound = 'sound/weapons/emitter.ogg'
	w_class = ITEMSIZE_HUGE
	checks_antimagic = TRUE
	max_charges = 6
	charges = 0
	recharge_rate = 4
	charge_tick = 0
	can_charge = TRUE

	projectile_type = /obj/item/projectile/energy/fireball
