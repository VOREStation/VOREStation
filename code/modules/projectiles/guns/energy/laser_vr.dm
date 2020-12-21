/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"icon_override" is the file with the on-mob icons, can be the same file
	"item_state" is the iconstate for the on-mob icons:
		item_state_s is used for worn uniforms on mobs
		item_state_r and item_state_l are for being held in each hand

	"item_state_slots" can replace "item_state", it is a list:
		item_state_slots["slotname1"] = "item state for that slot"
		item_state_slots["slotname2"] = "item state for that slot"

	on guns, in particular:
	item_state being null makes it look for exactly the icon_state in the on-mob file,
		including any 0,75,etc appended from the energy bar setting
	item_state being present prevents different mode sprites, sadly, but you may
		be able to override this on the gun itself with a proc
*/

/* TEMPLATE
//ckey:Character Name
/obj/item/weapon/gun/type/fluff/charactername
	name = ""
	desc = ""

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "myicon"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "myicon"

*/

// For general use
/obj/item/weapon/gun/energy/imperial
	name = "imperial energy pistol"
	desc = "An elegant weapon developed by the Imperium Auream. Their weaponsmiths have cleverly found a way to make a gun that is only about the size of an average energy pistol, yet with the fire power of a laser carbine."
	icon_state = "ge_pistol"
	item_state = "ge_pistol"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	icon = 'icons/obj/gun_vr.dmi'
	item_icons = list(slot_r_hand_str = 'icons/obj/gun_vr.dmi', slot_l_hand_str = 'icons/obj/gun_vr.dmi') // WORK YOU FUCKING CUNT PIECE OF SHIT BASTARD STUPID BITCH ITEM ICON AAAAHHHH
	item_state_slots = list(slot_r_hand_str = "ge_pistol_r", slot_l_hand_str = "ge_pistol_l")
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	force = 10
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/imperial

// Removed because gun64_vr.dmi guns don't work.
/*
//-----------------------G44 Energy Variant--------------------
/obj/item/weapon/gun/energy/gun/burst/g44e
	name = "G44 Energy Rifle"
	desc = "The G44 Energy is a laser variant of the G44 lightweight assault rifle manufactured by the National Armory of Gaia. Though almost exclusively to the United Federation's Military Assault Command Operations Department (MACOs) and Starfleet, it is occassionally sold to security departments for their stun capabilities."
	icon = 'icons/obj/gun64_vr.dmi'
	icon_state = "g44estun100"
	item_state = "energystun100" //This is temporary.
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 100
	force = 8
	w_class = ITEMSIZE_LARGE
	fire_delay = 6
	pixel_x = -16

	projectile_type = /obj/item/projectile/beam/stun/weak
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)
	modifystate = "g44estun"

	one_handed_penalty = 60

	firemodes = list(
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="g44estun", fire_sound='sound/weapons/Taser.ogg', charge_cost = 100),
		list(mode_name="stun burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="g44estun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="g44ekill", fire_sound='sound/weapons/Laser.ogg', charge_cost = 200),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="g44ekill", fire_sound='sound/weapons/Laser.ogg'),
		)
*/

//////////////////// Energy Weapons ////////////////////

// ------------ Energy Luger ------------
/obj/item/weapon/gun/energy/gun/eluger
	name = "energy Luger"
	desc = "The finest sidearm produced by RauMauser. Although its battery cannot be removed, its ergonomic design makes it easy to shoot, allowing for rapid follow-up shots. It also has the ability to toggle between stun and kill."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "elugerstun100"
	item_state = "gun"
	fire_delay = null // Lugers are quite comfortable to shoot, thus allowing for more controlled follow-up shots. Rate of fire similar to a laser carbine.
	battery_lock = 1 // In exchange for balance, you cannot remove the battery. Also there's no sprite for that and I fucking suck at sprites. -Ace
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2) // Illegal tech cuz Space Nazis
	modifystate = "elugerstun"
	fire_sound = 'sound/weapons/Taser.ogg'
	firemodes = list(
	list(mode_name="stun", charge_cost=120,projectile_type=/obj/item/projectile/beam/stun, modifystate="elugerstun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", charge_cost=240,projectile_type=/obj/item/projectile/beam/eluger, modifystate="elugerkill", fire_sound='sound/weapons/eluger.ogg'),
	)

//////////////////// Eris Ported Guns ////////////////////
//HoP gun
/obj/item/weapon/gun/energy/gun/martin
	name = "holdout energy gun"
	desc = "The FS PDW E \"Martin\" is small holdout e-gun. Don't miss!"
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "PDW"
	item_state = "gun"
	w_class = ITEMSIZE_SMALL
	projectile_type = /obj/item/projectile/beam/stun
	charge_cost = 1200
	charge_meter = 0
	modifystate = null
	battery_lock = 1
	fire_sound = 'sound/weapons/Taser.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg', charge_cost = 600),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg', charge_cost = 1200),
		)

/obj/item/weapon/gun/energy/gun/martin/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun") add_overlay("taser_pdw")
		if("lethal") add_overlay("lazer_pdw")

/obj/item/weapon/gun/energy/gun/martin/update_icon()
	cut_overlays()
	update_mode()

/////////////////////////////////////////////////////
//////////////////// Custom Ammo ////////////////////
/////////////////////////////////////////////////////
//---------------- Beams ----------------
/obj/item/projectile/beam/eluger
	name = "laser beam"
	icon_state = "xray"
	light_color = "#00FF00"
	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/imperial
	name = "laser beam"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	icon_state = "darkb"
	light_color = "#8837A3"
	muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	tracer_type = /obj/effect/projectile/tracer/darkmatter
	impact_type = /obj/effect/projectile/impact/darkmatter

/obj/item/projectile/beam/stun/kin21
	name = "kinh21 stun beam"
	icon_state = "omnilaser"
	light_color = "#0000FF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

//Gun Locking Mechanism
/obj/item/weapon/gun/energy/locked
	req_access = list(access_armory) //for toggling safety
	var/locked = 1
	var/lockable = 1

/obj/item/weapon/gun/energy/locked/attackby(obj/item/I, mob/user)
	var/obj/item/weapon/card/id/id = I.GetID()
	if(istype(id) && lockable)
		if(check_access(id))
			locked = !locked
			to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		user.visible_message("<span class='notice'>[user] swipes \the [I] against \the [src].</span>")
	else
		return ..()

/obj/item/weapon/gun/energy/locked/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(lockable)
		locked = !locked
		to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src]!</span>")

/obj/item/weapon/gun/energy/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.station_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()

//Expedition Frontier Phaser
/obj/item/weapon/gun/energy/locked/frontier
	name = "frontier phaser"
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "phaser"
	item_state = "phaser"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi', "slot_belt" = 'icons/mob/belt_vr.dmi')
	fire_sound = 'sound/weapons/laser2.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_POWER = 4)
	charge_cost = 300

	battery_lock = 1
	unacidable = 1

	var/recharging = 0
	var/phase_power = 75

	projectile_type = /obj/item/projectile/beam
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam/blue, charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser/blue, charge_cost = 80),
	)

/obj/item/weapon/gun/energy/locked/frontier/unload_ammo(var/mob/user)
	if(recharging)
		return
	recharging = 1
	update_icon()
	user.visible_message("<span class='notice'>[user] opens \the [src] and starts pumping the handle.</span>", \
						"<span class='notice'>You open \the [src] and start pumping the handle.</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(src,'sound/items/change_drill.ogg',25,1)
		if(power_supply.give(phase_power) < phase_power)
			break

	recharging = 0
	update_icon()

/obj/item/weapon/gun/energy/locked/frontier/update_icon()
	if(recharging)
		icon_state = "[initial(icon_state)]_pump"
		update_held_icon()
		return
	..()

/obj/item/weapon/gun/energy/locked/frontier/emp_act(severity)
	return ..(severity+2)

/obj/item/weapon/gun/energy/locked/frontier/ex_act() //|rugged|
	return

/obj/item/weapon/gun/energy/locked/frontier/unlocked
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank charger for recharging away from civilization."
	req_access = newlist() //for toggling safety
	locked = 0
	lockable = 0

//Phaser Carbine - Reskinned phaser
/obj/item/weapon/gun/energy/locked/frontier/carbine
	name = "frontier carbine"
	desc = "An ergonomically improved version of the venerable frontier phaser, the carbine is a fairly new weapon, and has only been produced in limited numbers so far. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "carbinekill"
	item_state = "retro"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi')

	modifystate = "carbinekill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam/blue, modifystate="carbinekill", charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser/blue, modifystate="carbinestun", charge_cost = 80),
	)

/obj/item/weapon/gun/energy/locked/frontier/carbine/update_icon()
	if(recharging)
		icon_state = "[modifystate]_pump"
		update_held_icon()
		return
	..()

/obj/item/weapon/gun/energy/locked/frontier/carbine/unlocked
	desc = "An ergonomically improved version of the venerable frontier phaser, the carbine is a fairly new weapon, and has only been produced in limited numbers so far."
	req_access = newlist() //for toggling safety
	locked = 0
	lockable = 0

//Expeditionary Holdout Phaser Pistol
/obj/item/weapon/gun/energy/locked/frontier/holdout
	name = "holdout frontier phaser"
	desc = "An minaturized weapon designed for the purpose of expeditionary support to defend themselves on the field. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "holdoutkill"
	item_state = null
	phase_power = 100

	w_class = ITEMSIZE_SMALL
	charge_cost = 600
	modifystate = "holdoutkill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam/blue, modifystate="holdoutkill", charge_cost = 600),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser/blue, modifystate="holdoutstun", charge_cost = 160),
		list(mode_name="stun", fire_delay=12, projectile_type=/obj/item/projectile/beam/stun/med, modifystate="holdoutshock", charge_cost = 300),
	)

/obj/item/weapon/gun/energy/locked/frontier/holdout/unlocked
	desc = "An minaturized weapon designed for the purpose of expeditionary support to defend themselves on the field. Includes a built-in crank charger for recharging away from civilization."
	req_access = newlist() //for toggling safety
	locked = 0
	lockable = 0
