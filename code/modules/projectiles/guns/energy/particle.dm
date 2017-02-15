/obj/item/weapon/gun/energy/particle
	name = "Antiparticle projector gun"
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "particle"
	item_state = "particle"
	desc = "An unconventional firearm, APP guns generate attogram-scale quantities of antimatter which are then launched using an electromagnetic field."
	force = 5
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	projectile_type = /obj/item/projectile/bullet/particle
	origin_tech = null
	fire_delay = 10
	charge_cost = 240	//same cost as lasers
	var/safetycatch = 0 //if 1, won't let you fire in pressurised environment, rather than malfunctioning


/obj/item/weapon/gun/energy/particle/special_check(var/mob/user)
	if (..())
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/environment = T ? T.return_air() : null
		var/pressure =  environment ? environment.return_pressure() : 0

		if (!power_supply || power_supply.charge < charge_cost)
			user.visible_message("<span class='warning'>*click*</span>", "<span class='danger'>*click*</span>")
			playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
			return 0
		if(pressure >= 10)
			if (safetycatch) //weapons with a pressure regulator simply won't fire
				user.visible_message("<span class='warning'>*click*</span>", "<span class='danger'>The pressure-interlock prevents you from firing \the [src].</span>")
				playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
				return 0
			else if (prob(min(pressure, 100))) //pressure% chance of failing
				var/severity = rand(pressure)
				if (severity <= 10) // just doesn't fire. 10% chance in 100 atmo.
					user.visible_message("<span class='warning'>*click*</span>", "<span class='danger'>\The [src] jams.</span>")
					playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
				else if (severity <= 60) //50% chance of fizzling and wasting a shot
					user.visible_message("<span class='warning'>\The [user] fires \the [src], but the shot fizzles in the air!</span>", "<span class='danger'>You fire \the [src], but the shot fizzles in the air!</span>")
					power_supply.charge -= charge_cost
					playsound(src.loc, fire_sound, 100, 1)
					var/datum/effect/effect/system/spark_spread/sparks = PoolOrNew(/datum/effect/effect/system/spark_spread)
					sparks.set_up(2, 1, T)
					sparks.start()
					update_icon()
				else if (severity <= 80) //20% chance of shorting out and emptying the cell
					user.visible_message("<span class='warning'>\The [user] pulls the trigger, but \the [src] shorts out!</span>", "<span class='danger'>You pull the trigger, but \the [src] shorts out!</span>")
					power_supply.charge = 0
					var/datum/effect/effect/system/spark_spread/sparks = PoolOrNew(/datum/effect/effect/system/spark_spread)
					sparks.set_up(2, 1, T)
					sparks.start()
					update_icon()
				else if (severity <= 90) //10% chance of breaking the gun
					user.visible_message("<span class='warning'>\The [user] pulls the trigger, but \the [src] erupts in a shower of sparks!</span>", "<span class='danger'>You pull the trigger, but \the [src] bursts into a shower of sparks!</span>")
					var/datum/effect/effect/system/spark_spread/sparks = PoolOrNew(/datum/effect/effect/system/spark_spread)
					sparks.set_up(2, 1, T)
					sparks.start()
					power_supply.charge = 0
					power_supply.maxcharge = 0
					power_supply.desc += " It seems to be burnt out!"
					desc += " The casing is covered in scorch-marks."
					fire_delay += fire_delay // even if you swap out the cell for a good one, the gun's cluckety-clucked.
					charge_cost += charge_cost
					update_icon()
				else if (severity <= 150) // 10% chance of exploding
					user << "<span class='danger'>The [src] explodes!</span>"
					explosion(T, -1, -1, 1, 1)
					qdel(src)
				else //can only possibly happen if you're dumb enough to fire it in an OVER pressure environment, over 150kPa
					user << "<span class='danger'>The [src] explodes catastrophically!</span>"
					explosion(T, -1, 1, 2, 2)
					qdel(src)
				return 0
		return 1
	return 0


// projectiles below

/obj/item/projectile/bullet/particle
	name = "particle"
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "particle"
	damage = 40
	damage_type = BURN
	check_armour = "energy"
	embed_chance = 0
