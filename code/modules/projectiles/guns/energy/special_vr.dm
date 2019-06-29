/obj/item/weapon/gun/energy/ionrifle/pistol
	projectile_type = /obj/item/projectile/ion/pistol // still packs a punch but no AoE

/obj/item/weapon/gun/energy/ionrifle/weak
	projectile_type = /obj/item/projectile/ion/small

/obj/item/weapon/gun/energy/medigun //Adminspawn/ERT etc
	name = "directed restoration system"
	desc = "The BL-3 'Phoenix' is an adaptation on the ML-3 'Medbeam' design that channels the power of the beam into a single healing laser. It is highly energy-inefficient, but its medical power cannot be denied."
	force = 5
	icon_state = "medbeam"
	item_state = "medbeam"
	icon = 'icons/obj/gun_vr.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi',
		)
	slot_flags = SLOT_BELT
	accuracy = 100
	fire_delay = 12
	fire_sound = 'sound/weapons/eluger.ogg'

	projectile_type = /obj/item/projectile/beam/medigun

	accept_cell_type = /obj/item/weapon/cell
	cell_type = /obj/item/weapon/cell/high
	charge_cost = 2500