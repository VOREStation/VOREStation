///BEAMS
/obj/item/projectile/beam/excursion/pistol_semi
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 25
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"
	
/obj/item/projectile/beam/excursion/pistol_burst
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 15
	light_range = 2
	light_power = 0.5
	light_color = "#FF0D00"
	
/obj/item/projectile/beam/excursion/carbine_semi
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 25
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray
	
/obj/item/projectile/beam/excursion/carbine_burst
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 15
	light_range = 2
	light_power = 0.5
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray
	
/obj/item/projectile/beam/excursion/rifle_semi
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 40
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_pulse
	tracer_type = /obj/effect/projectile/tracer/laser_pulse
	impact_type = /obj/effect/projectile/impact/laser_pulse
	
/obj/item/projectile/beam/excursion/rifle_burst
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 20
	light_range = 2
	light_power = 0.5
	light_color = "#0066FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	tracer_type = /obj/effect/projectile/tracer/laser_blue
	impact_type = /obj/effect/projectile/impact/laser_blue
	
/obj/item/projectile/beam/excursion/dmr_semi
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 50
	light_range = 2
	light_power = 0.5
	light_color = "#00C6FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

///GUNS
/obj/item/weapon/gun/energy/excursion
	name = "excursion energy blaster"
	desc = "A self-charging energy-based gun."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_POWER = 4, TECH_BLUESPACE = 3)

	//self-recharging
	self_recharge = 1	//if set, the weapon will recharge itself
	recharge_time = 4
	charge_tick = 0
	charge_delay = 75	//delay between firing and charging

	battery_lock = 1	//If set, weapon cannot switch batteries
	unacidable = 1
	var/locked = 1

	projectile_type = /obj/item/projectile/beam
	firemodes = list(
		list(mode_name="normal", fire_delay=12, projectile_type=/obj/item/projectile/beam, charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser, charge_cost = 60),
	)

/obj/item/weapon/gun/energy/excursion/emp_act(severity)
	return ..(severity+2)

/obj/item/weapon/gun/energy/excursion/ex_act() //|rugged|
	return

/obj/item/weapon/gun/energy/excursion/attackby(obj/item/I, mob/user)
	var/obj/item/weapon/card/id/id = I.GetID()
	if(istype(id))
		if(check_access(id))
			locked = !locked
			to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		user.visible_message("<span class='notice'>[user] swipes \the [I] against \the [src].</span>")
	else
		return ..()

/obj/item/weapon/gun/energy/excursion/emag_act(var/remaining_charges,var/mob/user)
	..()
	locked = !locked
	to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src]!</span>")

/obj/item/weapon/gun/energy/excursion/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()
	
/obj/item/weapon/gun/energy/excursion/pistol
	name = "excursion blaster pistol"
	desc = "A prototype energy pistol, based on recovered alien technology. Like standard expedition weaponry, it includes a station-lock system. Unlike the phaser rifles, it instead overheats and gradually cools down over time. It is capable of single shot and somewhat inaccurate two-shot burst modes. It has the fastest recharge time of the prototypes. EMPs will cause the systems to overheat."
	icon_state = "blasterpistolsemi100"
	item_state = "phase"
	fire_sound = 'sound/weapons/laser2.ogg'
	w_class = ITEMSIZE_SMALL
	fire_delay = 12
	recharge_time = 4 //base recharge
	charge_delay = 50 //short delay
	accuracy = 0 //no accuracy mod
	modifystate = "blasterpistolsemi"
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BLUESPACE = 3)

	projectile_type = /obj/item/projectile/beam/excursion/pistol_semi
	firemodes = list(
		list(mode_name="semi-auto", burst=1, fire_delay=12, projectile_type=/obj/item/projectile/beam/excursion/pistol_semi, modifystate = "blasterpistolsemi", charge_cost = 400),
		list(mode_name="two-shot burst", burst=2, fire_delay=null, move_delay=4, burst_accuracy=list(-10,-15), dispersion=list(0.0, 0.2), projectile_type=/obj/item/projectile/beam/excursion/pistol_burst, modifystate = "blasterpistolburst", charge_cost = 300),
	)

/obj/item/weapon/gun/energy/excursion/carbine
	name = "excursion blaster carbine"
	desc = "A prototype energy carbine, based on recovered alien technology. Like standard expedition weaponry, it includes a station-lock system. Unlike the phaser rifles, it instead overheats and gradually cools down over time. It can fire quite rapidly, but best suited to short ranges as its accuracy is somewhat poor, particularly in burst mode. Its burst mode is also very inefficient in terms of power consumption. EMPs will cause the systems to overheat."
	icon_state = "blastercarbinesemi100"
	item_state = "phasecarbine"
	fire_sound = 'sound/weapons/laser2.ogg'
	w_class = ITEMSIZE_NORMAL
	fire_delay = 8
	recharge_time = 6 //slightly slower recharge
	charge_delay = 75 //standard recovery time
	accuracy = -5 //below average accuracy
	modifystate = "blastercarbinesemi"
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_POWER = 4, TECH_BLUESPACE = 3)

	projectile_type = /obj/item/projectile/beam/excursion/carbine_semi
	firemodes = list(
		list(mode_name="semi-auto", burst=1, fire_delay=10, projectile_type=/obj/item/projectile/beam/excursion/carbine_semi, modifystate = "blastercarbinesemi", charge_cost = 300),
		list(mode_name="tri-burst", burst=3, fire_delay=null, move_delay=5, burst_accuracy=list(-10,-15,-20), dispersion=list(0.2, 0.25, 0.5), projectile_type=/obj/item/projectile/beam/excursion/carbine_burst, modifystate = "blastercarbineburst", charge_cost = 400),
	)
	
/obj/item/weapon/gun/energy/excursion/rifle
	name = "excursion blaster rifle"
	desc = "A prototype energy rifle, based on recovered alien technology. Like standard expedition weaponry, it includes a station-lock system. Unlike the phaser rifles, it instead overheats and gradually cools down over time. It has standard semi-automatic and three-shot burst modes. It is fairly well-balanced in terms of performance, though it fires slower than the prototype pistol. EMPs will cause the systems to overheat."
	icon_state = "blasterriflesemi100"
	item_state = "phaserifle"
	fire_sound = 'sound/weapons/laser2.ogg'
	w_class = ITEMSIZE_LARGE //just about fits in packs, but takes up a lot of space
	fire_delay = 15
	recharge_time = 8 //slower recharge
	charge_delay = 100 //longer delay
	accuracy = 15 //improved accuracy
	modifystate = "blasterriflesemi"
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BLUESPACE = 3)

	projectile_type = /obj/item/projectile/beam/excursion/rifle_semi
	firemodes = list(
		list(mode_name="semi-auto", burst=1, fire_delay=10, projectile_type=/obj/item/projectile/beam/excursion/rifle_semi, modifystate = "blasterriflesemi", charge_cost = 240),
		list(mode_name="tri-burst", burst=3, fire_delay=null, move_delay=5, burst_accuracy=list(0,-10,-10), dispersion=list(0.0, 0.1, 0.3), projectile_type=/obj/item/projectile/beam/excursion/rifle_burst, modifystate = "blasterrifleburst", charge_cost = 266),
	)
	
/obj/item/weapon/gun/energy/excursion/dmr
	name = "excursion precision blaster"
	desc = "A prototype precision energy rifle with an optical scope, based on recovered alien technology. Like standard expedition weaponry, it includes a station-lock system. Unlike the phaser rifles, it instead overheats and gradually cools down over time. It has very good accuracy, but fires and recharges very slowly compared to the standard rifle, and can only operate in single-shot mode. EMPs will cause the systems to overheat."
	icon_state = "blasterdmrsemi100"
	item_state = "stunrifle"
	fire_sound = 'sound/weapons/laser2.ogg'
	w_class = ITEMSIZE_HUGE //really big, can't fit in backpacks
	fire_delay = 20
	recharge_time = 12 //much slower charge
	charge_delay = 150 //long charge delay
	accuracy = 15 //improved accuracy
	scoped_accuracy = 75 //extremely good accuracy when scoped
	modifystate = "blasterdmrsemi"
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_POWER = 4, TECH_BLUESPACE = 3)

	projectile_type = /obj/item/projectile/beam/excursion/dmr_semi
	charge_cost = 600
	
	firemodes = list(
		list(mode_name="semi-auto", burst=1, fire_delay=20, projectile_type = /obj/item/projectile/beam/excursion/dmr_semi, charge_cost = 600),
	)

/obj/item/weapon/gun/energy/excursion/dmr/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(1.5)