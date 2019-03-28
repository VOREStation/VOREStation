/obj/item/weapon/gun/energy/kinetic_accelerator
	name = "proto-kinetic accelerator"
	desc = "A self recharging, ranged mining tool that does increased damage in low temperature. Capable of holding up to six slots worth of mod kits."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "kineticgun"
	item_state = "kineticgun"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi')
	projectile_type = /obj/item/projectile/kinetic
	origin_tech = list(TECH_COMBAT = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	can_flashlight = TRUE
	flight_x_offset = 15
	flight_y_offset = 9
	charge_cost = 120 // 20 shots on weapon power cell
	fire_delay = 16
	self_recharge = TRUE
	recharge_time = 10 // every 20*2 seconds will get 20% power restored

	var/max_mod_capacity = 100
	var/list/modkits = list()
	var/empty_state = "kineticgun_empty"

/obj/item/weapon/gun/energy/kinetic_accelerator/examine(mob/user)
	if(..(user, 1))
		if(max_mod_capacity)
			to_chat(user, "<b>[get_remaining_mod_capacity()]%</b> mod capacity remaining.")
			for(var/A in get_modkits())
				var/obj/item/borg/upgrade/modkit/M = A
				to_chat(user, "<span class='notice'>There is a [M.name] mod installed, using <b>[M.cost]%</b> capacity.</span>")

/obj/item/weapon/gun/energy/kinetic_accelerator/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/weapon/tool/crowbar))
		if(modkits.len)
			to_chat(user, "<span class='notice'>You pry the modifications out.</span>")
			playsound(loc, A.usesound, 100, 1)
			for(var/obj/item/borg/upgrade/modkit/M in modkits)
				M.uninstall(src)
		else
			to_chat(user, "<span class='notice'>There are no modifications currently installed.</span>")
	else if(istype(A, /obj/item/borg/upgrade/modkit))
		var/obj/item/borg/upgrade/modkit/MK = A
		MK.install(src, user)
	else
		..()

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/get_remaining_mod_capacity()
	var/current_capacity_used = 0
	for(var/A in get_modkits())
		var/obj/item/borg/upgrade/modkit/M = A
		current_capacity_used += M.cost
	return max_mod_capacity - current_capacity_used

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/get_modkits()
	. = list()
	for(var/A in modkits)
		. += A

/obj/item/weapon/gun/energy/kinetic_accelerator/proc/modify_projectile(obj/item/projectile/kinetic/K)
	for(var/A in get_modkits())
		var/obj/item/borg/upgrade/modkit/M = A
		M.modify_projectile(K)

/obj/item/weapon/gun/energy/kinetic_accelerator/consume_next_projectile()
	var/obj/item/projectile/kinetic/BB = ..()
	if(!istype(BB))
		return
	modify_projectile(BB)

	var/turf/proj_turf = get_turf(src)
	if(!isturf(proj_turf))
		return
	var/datum/gas_mixture/environment = proj_turf.return_air()
	if(environment.temperature > 250)
		BB.name = "weakened [BB.name]"
		BB.damage *= BB.pressure_decrease
	return BB

/obj/item/weapon/gun/energy/kinetic_accelerator/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	. = ..()
	spawn(fire_delay)
		if(power_supply && power_supply.check_charge(charge_cost))
			playsound(loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)

/obj/item/weapon/gun/energy/kinetic_accelerator/update_icon()
	cut_overlays()
	if(!power_supply || !power_supply.check_charge(charge_cost))
		add_overlay(empty_state)
	if(can_flashlight)
		var/iconF = "flight"
		if(gun_light)
			iconF = "flight_on"
		add_overlay(image(icon = icon, icon_state = iconF, pixel_x = flight_x_offset, pixel_y = flight_y_offset))

//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = null
	damage = 32
	damage_type = BRUTE
	check_armour = "bomb"
	range = 3 // Our "range" var is named "kill_count". Yes it is.

	var/pressure_decrease = 0.25
	var/turf_aoe = FALSE
	var/mob_aoe = FALSE
	var/list/hit_overlays = list()

// /obj/item/projectile/kinetic/pod
// 	kill_count = 4
//
// /obj/item/projectile/kinetic/pod/regular
// 	damage = 50
// 	pressure_decrease = 0.5
//
// /obj/item/projectile/kinetic/pod/enhanced
// 	turf_aoe = TRUE
// 	mob_aoe = TRUE

/obj/item/projectile/kinetic/on_impact(var/atom/A)
	strike_thing(A)
	. = ..()

/obj/item/projectile/kinetic/on_hit(var/atom/target)
	strike_thing(target)
	. = ..()

/obj/item/projectile/kinetic/proc/strike_thing(atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.GetDrilled()
	var/obj/effect/temp_visual/kinetic_blast/K = new /obj/effect/temp_visual/kinetic_blast(target_turf)
	K.color = color
	for(var/type in hit_overlays)
		new type(target_turf)
	if(turf_aoe)
		for(var/T in RANGE_TURFS(1, target_turf) - target_turf)
			if(istype(T, /turf/simulated/mineral))
				var/turf/simulated/mineral/M = T
				M.GetDrilled()
	if(mob_aoe)
		for(var/mob/living/L in range(1, target_turf) - firer - target)
			var/armor = L.run_armor_check(def_zone, check_armour)
			L.apply_damage(damage*mob_aoe, damage_type, def_zone, armor)
			to_chat(L, "<span class='userdanger'>You're struck by a [name]!</span>")

//Modkits
/obj/item/borg/upgrade/modkit
	name = "modification kit"
	desc = "An upgrade for kinetic accelerators."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "modkit"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_MAGNET = 4)
	require_module = 1
	// var/module_type = /obj/item/robot_module/miner
	usesound = 'sound/items/Screwdriver.ogg'
	var/denied_type = null
	var/maximum_of_type = 1
	var/cost = 30
	var/modifier = 1 //For use in any mod kit that has numerical modifiers

/obj/item/borg/upgrade/modkit/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "<span class='notice'>Occupies <b>[cost]%</b> of mod capacity.</span>")

/obj/item/borg/upgrade/modkit/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/weapon/gun/energy/kinetic_accelerator) && !issilicon(user))
		install(A, user)
	else
		..()

/obj/item/borg/upgrade/modkit/action(mob/living/silicon/robot/R)
	if(..())
		return

	for(var/obj/item/weapon/gun/energy/kinetic_accelerator/H in R.module.modules)
		return install(H, usr)

/obj/item/borg/upgrade/modkit/proc/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	. = TRUE
	if(denied_type)
		var/number_of_denied = 0
		for(var/A in KA.get_modkits())
			var/obj/item/borg/upgrade/modkit/M = A
			if(istype(M, denied_type))
				number_of_denied++
			if(number_of_denied >= maximum_of_type)
				. = FALSE
				break
	if(KA.get_remaining_mod_capacity() >= cost)
		if(.)
			to_chat(user, "<span class='notice'>You install the modkit.</span>")
			playsound(loc, usesound, 100, 1)
			user.unEquip(src)
			forceMove(KA)
			KA.modkits += src
		else
			to_chat(user, "<span class='notice'>The modkit you're trying to install would conflict with an already installed modkit. Use a crowbar to remove existing modkits.</span>")
	else
		to_chat(user, "<span class='notice'>You don't have room(<b>[KA.get_remaining_mod_capacity()]%</b> remaining, [cost]% needed) to install this modkit. Use a crowbar to remove existing modkits.</span>")
		. = FALSE

/obj/item/borg/upgrade/modkit/proc/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
	forceMove(get_turf(KA))
	KA.modkits -= src

/obj/item/borg/upgrade/modkit/proc/modify_projectile(obj/item/projectile/kinetic/K)
	return

//Range
/obj/item/borg/upgrade/modkit/range
	name = "range increase"
	desc = "Increases the range of a kinetic accelerator when installed."
	modifier = 1
	cost = 24 //so you can fit four plus a tracer cosmetic

/obj/item/borg/upgrade/modkit/range/modify_projectile(obj/item/projectile/kinetic/K)
	K.range += modifier


//Damage
/obj/item/borg/upgrade/modkit/damage
	name = "damage increase"
	desc = "Increases the damage of kinetic accelerator when installed."
	modifier = 10

/obj/item/borg/upgrade/modkit/damage/modify_projectile(obj/item/projectile/kinetic/K)
	K.damage += modifier


// //Cooldown
// /obj/item/borg/upgrade/modkit/cooldown
// 	name = "cooldown decrease"
// 	desc = "Decreases the cooldown of a kinetic accelerator."
// 	modifier = 2.5

// /obj/item/borg/upgrade/modkit/cooldown/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
// 	. = ..()
// 	if(.)
// 		KA.overheat_time -= modifier

// /obj/item/borg/upgrade/modkit/cooldown/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
// 	KA.overheat_time += modifier
// 	..()

//Cooldown
/obj/item/borg/upgrade/modkit/efficiency
	name = "energy efficiency"
	desc = "Decreases the energy use of a kinetic accelerator."
	modifier = 20

/obj/item/borg/upgrade/modkit/efficiency/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(.)
		KA.charge_cost -= modifier

/obj/item/borg/upgrade/modkit/efficiency/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
	KA.charge_cost += modifier
	..()

//AoE blasts
/obj/item/borg/upgrade/modkit/aoe
	modifier = 0

/obj/item/borg/upgrade/modkit/aoe/modify_projectile(obj/item/projectile/kinetic/K)
	K.name = "kinetic explosion"
	if(!K.turf_aoe && !K.mob_aoe)
		K.hit_overlays += /obj/effect/temp_visual/explosion/fast
	K.mob_aoe += modifier

/obj/item/borg/upgrade/modkit/aoe/turfs
	name = "mining explosion"
	desc = "Causes the kinetic accelerator to destroy rock in an AoE."
	denied_type = /obj/item/borg/upgrade/modkit/aoe/turfs

/obj/item/borg/upgrade/modkit/aoe/turfs/modify_projectile(obj/item/projectile/kinetic/K)
	..()
	K.turf_aoe = TRUE

/obj/item/borg/upgrade/modkit/aoe/turfs/andmobs
	name = "offensive mining explosion"
	desc = "Causes the kinetic accelerator to destroy rock and damage mobs in an AoE."
	maximum_of_type = 3
	modifier = 0.25

/obj/item/borg/upgrade/modkit/aoe/mobs
	name = "offensive explosion"
	desc = "Causes the kinetic accelerator to damage mobs in an AoE."
	modifier = 0.2


//Indoors
/obj/item/borg/upgrade/modkit/indoors
	name = "decrease pressure penalty"
	desc = "Increases the damage a kinetic accelerator does in a high pressure environment."
	modifier = 2
	denied_type = /obj/item/borg/upgrade/modkit/indoors
	maximum_of_type = 2
	cost = 40

/obj/item/borg/upgrade/modkit/indoors/modify_projectile(obj/item/projectile/kinetic/K)
	K.pressure_decrease *= modifier

//Cosmetic

/obj/item/borg/upgrade/modkit/chassis_mod
	name = "super chassis"
	desc = "Makes your KA yellow. All the fun of having a more powerful KA without actually having a more powerful KA."
	cost = 0
	denied_type = /obj/item/borg/upgrade/modkit/chassis_mod
	var/chassis_icon = "kineticgun_u"
	var/chassis_name = "super-kinetic accelerator"

/obj/item/borg/upgrade/modkit/chassis_mod/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	. = ..()
	if(.)
		KA.icon_state = chassis_icon
		KA.name = chassis_name

/obj/item/borg/upgrade/modkit/chassis_mod/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
	KA.icon_state = initial(KA.icon_state)
	KA.name = initial(KA.name)
	..()

/obj/item/borg/upgrade/modkit/chassis_mod/orange
	name = "hyper chassis"
	desc = "Makes your KA orange. All the fun of having explosive blasts without actually having explosive blasts."
	chassis_icon = "kineticgun_h"
	chassis_name = "hyper-kinetic accelerator"

/obj/item/borg/upgrade/modkit/tracer
	name = "white tracer bolts"
	desc = "Causes kinetic accelerator bolts to have a white tracer trail and explosion."
	cost = 0
	denied_type = /obj/item/borg/upgrade/modkit/tracer
	var/bolt_color = "#FFFFFF"

/obj/item/borg/upgrade/modkit/tracer/modify_projectile(obj/item/projectile/kinetic/K)
	K.icon_state = "ka_tracer"
	K.color = bolt_color

/obj/item/borg/upgrade/modkit/tracer/adjustable
	name = "adjustable tracer bolts"
	desc = "Causes kinetic accelerator bolts to have a adjustably-colored tracer trail and explosion. Use in-hand to change color."

/obj/item/borg/upgrade/modkit/tracer/adjustable/attack_self(mob/user)
	bolt_color = input(user,"Choose Color") as color
