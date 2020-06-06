//This will likely drive me insane, but fuck it. Let's give it a shot. -k22
//This was heavily assisted by MoondancerPony
/obj/item/weapon/gun/energy/modular
	name = "modular weapon"
	desc = "You shouldn't be seeing this. Contact your local time-police station."
	icon_state = "mod_pistol"
	cell_type = /obj/item/weapon/cell/device/weapon
	charge_cost = 120

	var/max_components = 3 //How many components we can hold.
	var/capacitor_rating = 0 //How good are the capacitors inside us?
	var/laser_rating = 0 //How good are the lasers inside of us?
	var/manipulator_rating = 0 //How good are the manipulators inside us?
	var/assembled = 1 //Are we closed up?
	var/max_burst_size = 5 //Don't let our maximum burst size get too high.
	var/list/guncomponents = list() //Generate our list of components.
	var/accepted_components = list(
		/obj/item/weapon/stock_parts/capacitor/,
		/obj/item/weapon/stock_parts/capacitor/adv,
		/obj/item/weapon/stock_parts/capacitor/super,
		/obj/item/weapon/stock_parts/micro_laser/,
		/obj/item/weapon/stock_parts/micro_laser/high,
		/obj/item/weapon/stock_parts/micro_laser/ultra,
		/obj/item/weapon/stock_parts/manipulator/,
		/obj/item/weapon/stock_parts/manipulator/nano,
		/obj/item/weapon/stock_parts/manipulator/pico,
		)
	//Excessively long because it won't accept subtypes for some reason!


/obj/item/weapon/gun/energy/modular/New() //Initialize our components.
	..()
	guncomponents = list()
	guncomponents += new /obj/item/weapon/stock_parts/capacitor
	guncomponents += new /obj/item/weapon/stock_parts/micro_laser
	guncomponents += new /obj/item/weapon/stock_parts/manipulator
	CheckParts()
	FireModeModify()

/obj/item/weapon/gun/energy/modular/proc/CheckParts() //What parts do we have inside us, and how good are they?
	capacitor_rating = 0
	laser_rating = 0
	manipulator_rating = 0
	for(var/obj/item/weapon/stock_parts/capacitor/CA in guncomponents)
		capacitor_rating += CA.rating
	for(var/obj/item/weapon/stock_parts/micro_laser/ML in guncomponents)
		laser_rating += ML.rating
	for(var/obj/item/weapon/stock_parts/manipulator/MA in guncomponents)
		manipulator_rating += MA.rating
	FireModeModify()

/obj/item/weapon/gun/energy/modular/attackby(obj/item/O, mob/user)
	if(O.is_screwdriver())
		to_chat(user, "<span class='notice'>You [assembled ? "disassemble" : "assemble"] the gun.</span>")
		assembled = !assembled
		playsound(src, O.usesound, 50, 1)
		return
	if(O.is_crowbar())
		if(assembled == 1)
			to_chat(user, "<span class='warning'>Disassemble the [src] first!</span>")
			return
		for(var/obj/item/I in guncomponents)
			to_chat(user, "<span class='notice'>You remove the gun's components.</span>")
			playsound(src, O.usesound, 50, 1)
			I.forceMove(get_turf(src))
			guncomponents.Remove(I)
			CheckParts()
		return
	//Someone's attacking us, and it's not anything we have a special case for (i.e. a tool)
	..()
	if(assembled) // can't put anything in
		return
	if(!(O.type in accepted_components))//check if we can accept it
		to_chat(user, "<span class='warning'>You can't add this to [src]!</span>")
		return
	if(guncomponents.len >= max_components) //We have too many componenets and can't fit more.
		to_chat(user, "<span class='warning'>You can't add any more components!</span>")
		return
	if(istype(O, /obj/item/weapon/stock_parts/capacitor) && capacitor_rating == 5)
		to_chat(user, "<span class='warning'>You can't add any more capacitors!</span>")
		return
	user.drop_item()
	guncomponents += O
	O.forceMove(src)
	to_chat(user, "<span class='notice'>You add a component to the [src]</span>")
	CheckParts()


/obj/item/weapon/gun/energy/modular/proc/FireModeModify() //Check our laser, manipulator, and capacitor ratings, adjust stun and lethal firemodes depending on laser / manipulator rating and burst size depending on capacitors.
	//check our lethal and stun ratings depending on laser and manipulator rating.
	var/burstmode = capacitor_rating
	var/beammode
	var/beammode_lethal
	var/chargecost
	var/chargecost_lethal

	if(laser_rating >= 15)
		beammode_lethal = /obj/item/projectile/beam/sniper
		beammode = /obj/item/projectile/beam/stun
		chargecost = 300
		chargecost_lethal = 600
	else if(laser_rating >= 10)
		beammode_lethal = /obj/item/projectile/beam/xray
		beammode = /obj/item/projectile/beam/stun
		chargecost = 300
		chargecost_lethal = 200
	else if(laser_rating == 8 && manipulator_rating == 5) //very specific set of combinations. No, you can't make a pulse rifle. Sorry research.
		beammode_lethal = /obj/item/projectile/beam/heavylaser
		beammode = /obj/item/projectile/beam/stun
		chargecost = 300
		chargecost_lethal = 600
	else if(laser_rating >= 5)
		beammode_lethal = /obj/item/projectile/beam/midlaser
		beammode = /obj/item/projectile/beam/stun/med
		chargecost = 180
		chargecost_lethal = 240
	else if(laser_rating < 5)
		beammode_lethal = /obj/item/projectile/beam/weaklaser
		beammode = /obj/item/projectile/beam/stun/weak
		chargecost = 100
		chargecost_lethal = 200

	firemodes = list(
		new /datum/firemode(src, list(mode_name="stun", projectile_type=beammode, charge_cost = chargecost)),
		new /datum/firemode(src, list(mode_name="lethal", projectile_type=beammode_lethal, charge_cost = chargecost_lethal)),
		new /datum/firemode(src, list(mode_name="[burstmode] shot stun", projectile_type=beammode, charge_cost = chargecost, burst = burstmode)),
		new /datum/firemode(src, list(mode_name="[burstmode] shot lethal", projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = burstmode)),
		)

/obj/item/weapon/gun/energy/modular/load_ammo(var/obj/item/C, mob/user)
	if(istype(C, cell_type))
		if(self_recharge || battery_lock)
			to_chat(user, "<span class='notice'>[src] does not have a battery port.</span>")
			return
		var/obj/item/weapon/cell/P = C
		if(power_supply)
			to_chat(user, "<span class='notice'>[src] already has a power cell.</span>")
		else
			user.visible_message("[user] is reloading [src].", "<span class='notice'>You start to insert [P] into [src].</span>")
			if(do_after(user, 10))
				user.remove_from_mob(P)
				power_supply = P
				P.loc = src
				user.visible_message("[user] inserts [P] into [src].", "<span class='notice'>You insert [P] into [src].</span>")
				playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
				update_icon()
				update_held_icon()
		return

/obj/item/weapon/gun/energy/modular/pistol
	name = "modular pistol"
	icon_state = "mod_pistol"
	max_components = 6
	desc = "A bulky modular pistol frame. This only only accepts six parts."
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	burst_delay = 2

/obj/item/weapon/gun/energy/modular/carbine
	name = "modular carbine"
	icon_state = "mod_carbine"
	max_components = 8
	desc = "A modular version of the standard laser carbine. This one can hold 8 components."
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3, TECH_MATERIAL = 3)
	burst_delay = 2

/obj/item/weapon/gun/energy/modular/cannon
	name = "modular cannon"
	icon_state = "mod_cannon"
	max_components = 14
	desc = "Say hello, to my little friend!"
	one_handed_penalty = 4 //dual wielding = no.
	cell_type = /obj/item/weapon/cell //We're bigger. We can use much larger power cells.
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 4) //its a damn cannon capable of holding a huge amount of parts.
	burst_delay = 4 //preventing extreme silliness.