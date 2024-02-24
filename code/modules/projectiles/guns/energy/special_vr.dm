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

/obj/item/weapon/gun/energy/bfgtaser
	name = "9000-series Ball Lightning Taser"
	desc = "The brainchild of Hephaestus Industries Civil Pacification Division, the BLT-9000 was intended for riot control but despite enthusiastic interest from law-enforcement agencies across the Commonwealth and beyond, its indiscriminate nature led to it being banned from civilian use in virtually all jurisdictions. As a result, most pieces are found in the hands of collectors."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "BFG"
	fire_sound = 'sound/effects/phasein.ogg'
	item_state = "mhdhowitzer"
	wielded_item_state = "mhdhowitzer-wielded" //Placeholder
	slot_flags = SLOT_BELT|SLOT_BACK
	projectile_type = /obj/item/projectile/bullet/BFGtaser
	fire_delay = 20
	w_class = ITEMSIZE_LARGE
	one_handed_penalty = 90 // The thing's heavy and huge.
	accuracy = 45
	charge_cost = 2400 //yes, this bad boy empties an entire weapon cell in one shot. What of it?
	var/spinning_up = FALSE

/obj/item/weapon/gun/energy/bfgtaser/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(spinning_up)
		return
	if(!power_supply || !power_supply.check_charge(charge_cost))
		handle_click_empty(user)
		return

	playsound(src, 'sound/weapons/chargeup.ogg', 100, 1)
	spinning_up = TRUE
	update_icon()
	user.visible_message("<span class='notice'>[user] starts charging the [src]!</span>", \
                        "<span class='notice'>You start charging the [src]!</span>")
	if(do_after(user, 8, src))
		spinning_up = FALSE
		..()
	else
		spinning_up = FALSE

/obj/item/projectile/beam/stun/weak/BFG
	fire_sound = 'sound/effects/sparks6.ogg'
	hitsound = 'sound/effects/sparks4.ogg'
	hitsound_wall = 'sound/effects/sparks7.ogg'

/obj/item/projectile/bullet/BFGtaser
	name = "lightning ball"
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "minitesla"
	speed=5
	damage = 100
	damage_type = AGONY
	check_armour = "energy"
	embed_chance = 0
	hitsound = 'sound/weapons/zapbang.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	var/zaptype = /obj/item/projectile/beam/stun/weak/BFG

/obj/item/projectile/bullet/BFGtaser/process()
	var/list/victims = list()
	for(var/mob/living/M in living_mobs(world.view))
		if(M != firer)
			victims += M
	if(LAZYLEN(victims))
		var/target = pick(victims)
		var/obj/item/projectile/P = new zaptype(src.loc)
		P.launch_projectile_from_turf(target = target, target_zone = null, user = firer, params = null, angle_override = null, forced_spread = 0)
	..()

/obj/item/projectile/bullet/BFGtaser/on_hit()
	var/list/victims = list()
	for(var/mob/living/M in living_mobs(world.view))
		if(M != firer)
			victims += M
	if(LAZYLEN(victims))
		for(var/target in victims)
			var/obj/item/projectile/P = new zaptype(src.loc)
			P.launch_projectile_from_turf(target = target, target_zone = null, user = firer, params = null, angle_override = null, forced_spread = 0)
	..()