/obj/item/gun/energy/particle //base gun, similar stats to an egun
	name = "Anti-particle projector pistol"
	icon_state = "ppistol"
	item_state = "ppistol"
	desc = "A Kawashima Material Technology Model 7 anti-particle projector, housed in a rugged casing."
	description_info = "An unconventional weapon, APP guns generate attogram-scale quantities of antimatter which \
	are then launched using an electromagnetic field. They are only suitable for use in depressurised environments, \
	else the antimatter pellet is liable to strike the air before it reaches the target. This can result in catastrophic \
	failure, making them unsuitable as military weapons in practical situations as they are prone to backfiring and \
	jamming, though they perform as adequately as any laser weapon in vacuum. Nonetheless, they have found a niche among \
	miners and salvage crews, as their lack of usefulness as a firearm in habitable areas means most authorities do not \
	classify them as dangerous weapons (at least, not dangerous to whoever they're pointed at) - instead, in most \
	jurisdictions including NT space, APP guns are officially classed as mining equipment rather than firearms."
	fire_sound = 'sound/weapons/blaster.ogg'
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	projectile_type = /obj/item/projectile/bullet/particle
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_MATERIAL = 2)
	fire_delay = 10
	charge_cost = 200	//slightly more shots than lasers
	var/safetycatch = 0 //if 1, won't let you fire in pressurised environment, rather than malfunctioning
	var/obj/item/pressurelock/attached_safety


/obj/item/gun/energy/particle/advanced //particle equivalent of AEG
	name = "Advanced anti-particle rifle"
	icon_state = "particle"
	item_state = "particle"
	desc = "An antiparticle projector gun with an enhanced power-generation unit."
	slot_flags = SLOT_BELT
	force = 8 //looks heavier than a pistol
	w_class = ITEMSIZE_LARGE	//bigger than a pistol, too.
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	fire_delay = 6	//This one's not a handgun, it should have the same fire delay as everything else
	self_recharge = 1
	modifystate = null
	battery_lock = 1
	recharge_time = 6 // every 6 ticks, recharge 2 shots. Slightly slower than AEG.
	charge_delay = 10 //Starts recharging faster after firing than an AEG though.

/obj/item/gun/energy/particle/cannon //particle version of laser cannon
	name = "Anti-particle cannon"
	desc = "A giant beast of an antimatter gun, packed with an internal reactor to allow for extreme longevity on remote mining expeditions."
	icon_state = "heavyparticle"
	item_state = "heavyparticle"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	projectile_type = /obj/item/projectile/bullet/particle/heavy
	battery_lock = 1
	fire_delay = 15 // fires faster than a laser cannon. c'mon, it's an awesome-but-impractical endgame gun.
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	force = 10
	one_handed_penalty = 8 // The thing's heavy and huge.
	accuracy = 3
	charge_cost = 400 // 6 shots
	self_recharge = 1
	charge_delay = 15 //won't start charging until it's ready to fire again
	recharge_time = 8 //40 ticks after that to refill the whole thing.

//special behaviours for particle guns below

/obj/item/gun/energy/particle/special_check(var/mob/user)
	if (..())
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/environment = T ? T.return_air() : null
		var/pressure =  environment ? environment.return_pressure() : 0

		if (!power_supply || power_supply.charge < charge_cost)
			user.visible_message("<span class='warning'>*click*</span>", "<span class='danger'>*click*</span>")
			playsound(src, 'sound/weapons/empty.ogg', 100, 1)
			return 0
		if(pressure >= 10)
			if (safetycatch) //weapons with a pressure regulator simply won't fire
				user.visible_message("<span class='warning'>*click*</span>", "<span class='danger'>The pressure-interlock prevents you from firing \the [src].</span>")
				playsound(src, 'sound/weapons/empty.ogg', 100, 1)
				return 0
			else if (prob(min(pressure, 100))) //pressure% chance of failing
				var/severity = rand(pressure)
				pressuremalfunction(severity, user, T)
				return 0
		return 1
	return 0

/obj/item/gun/energy/particle/proc/pressuremalfunction(severity, var/mob/user, var/turf/T)
	if (severity <= 10) // just doesn't fire. 10% chance in 100 atmo.
		user.visible_message("<span class='warning'>*click*</span>", "<span class='danger'>\The [src] jams.</span>")
		playsound(src, 'sound/weapons/empty.ogg', 100, 1)
	else if (severity <= 60) //50% chance of fizzling and wasting a shot
		user.visible_message("<span class='warning'>\The [user] fires \the [src], but the shot fizzles in the air!</span>", "<span class='danger'>You fire \the [src], but the shot fizzles in the air!</span>")
		power_supply.charge -= charge_cost
		playsound(src, fire_sound, 100, 1)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(2, 1, T)
		sparks.start()
		update_icon()
	else if (severity <= 80) //20% chance of shorting out and emptying the cell
		user.visible_message("<span class='warning'>\The [user] pulls the trigger, but \the [src] shorts out!</span>", "<span class='danger'>You pull the trigger, but \the [src] shorts out!</span>")
		power_supply.charge = 0
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(2, 1, T)
		sparks.start()
		update_icon()
	else if (severity <= 90) //10% chance of breaking the gun
		user.visible_message("<span class='warning'>\The [user] pulls the trigger, but \the [src] erupts in a shower of sparks!</span>", "<span class='danger'>You pull the trigger, but \the [src] bursts into a shower of sparks!</span>")
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(2, 1, T)
		sparks.start()
		power_supply.charge = 0
		power_supply.maxcharge = 1 //just to avoid div/0 runtimes
		power_supply.desc += " It seems to be burnt out!"
		desc += " The casing is covered in scorch-marks."
		fire_delay += fire_delay // even if you swap out the cell for a good one, the gun's cluckety-clucked.
		charge_cost += charge_cost
		update_icon()
	else if (severity <= 150) // 10% chance of exploding
		user.visible_message("<span class='danger'>\The [user] pulls the trigger, but \the [src] explodes!</span>", "<span class='danger'>The [src] explodes!</span>")
		log_and_message_admins("blew themself up with a particle gun.", user)
		explosion(T, -1, -1, 1, 1)
		qdel(src)
	else //can only possibly happen if you're dumb enough to fire it in an OVER pressure environment, over 150kPa
		user.visible_message("<span class='danger'>\The [user] pulls the trigger, but \the [src] explodes!</span>", "<span class='danger'>The [src] explodes catastrophically!</span>")
		log_and_message_admins("blew their dumb ass up with a particle gun.", user)
		explosion(T, -1, 1, 2, 2)
		qdel(src)

/obj/item/gun/energy/particle/cannon/pressuremalfunction(severity, user, T)
	..(severity*2, user, T)


/obj/item/gun/energy/particle/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/pressurelock))
		if(safetycatch)
			to_chat(user, "<span class='notice'>\The [src] already has a [attached_safety].</span>")
			return
		to_chat(user, "<span class='notice'>You insert \the [A] into \the [src].</span>")
		user.drop_item()
		A.loc = src
		attached_safety = A
		safetycatch = 1
		return

	if(istype(A, /obj/item/tool/screwdriver))
		if(safetycatch && attached_safety)
			to_chat(user, "<span class='notice'>You begin removing \the [attached_safety] from \the [src].</span>")
			if(do_after(user, 25))
				to_chat(user, "<span class='notice'>You remove \the [attached_safety] from \the [src].</span>")
				user.put_in_hands(attached_safety)
				safetycatch = 0
				attached_safety = null
			return
	..()


// accessory

/obj/item/pressurelock
	name = "Pressure interlock"
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "pressurelock"
	desc = "A safety interlock that can be installed in an antiparticle projector. It prevents the weapon from discharging in pressurised environments."
	w_class = ITEMSIZE_TINY
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

// projectiles below

/obj/item/projectile/bullet/particle
	name = "antimatter pellet"
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "particle"
	damage = 40
	damage_type = BURN
	check_armour = "energy"
	embed_chance = 0

/obj/item/projectile/bullet/particle/heavy
	name = "antimatter slug"
	icon_state = "particle-heavy"
	damage = 80 // same as a laser cannon
	armor_penetration = 25 //it explodes on the surface of things, so less armor pen than the laser cannon
	light_range = 3
	light_power = 1
	light_color = "#CCFFFF"

/turf/simulated/mineral/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/bullet/particle))
		if(prob(Proj.damage))
			GetDrilled()
	..()
