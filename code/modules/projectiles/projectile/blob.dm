/obj/item/projectile/energy/blob //Not super strong.
	name = "spore"
	icon_state = "declone"
	damage = 3
	armor_penetration = 40
	damage_type = BRUTE
	check_armour = "melee"
	pass_flags = PASSTABLE | PASSBLOB
	fire_sound = 'sound/effects/slime_squish.ogg'
	var/splatter = FALSE			// Will this make a cloud of reagents?
	var/splatter_volume = 5			// The volume of its chemical container, for said cloud of reagents.
	var/list/my_chems = list(REAGENT_ID_MOLD)

/obj/item/projectile/energy/blob/splattering
	splatter = TRUE

/obj/item/projectile/energy/blob/New()
	if(splatter)
		create_reagents(splatter_volume)
		ready_chemicals()
	..()

/obj/item/projectile/energy/blob/Destroy()
	qdel(reagents)
	reagents = null
	..()

/obj/item/projectile/energy/blob/on_impact(var/atom/A)
	if(splatter)
		var/turf/location = get_turf(src)
		var/datum/effect/effect/system/smoke_spread/chem/blob/S = new /datum/effect/effect/system/smoke_spread/chem/blob
		S.attach(location)
		S.set_up(reagents, rand(1, splatter_volume), 0, location)
		playsound(location, 'sound/effects/slime_squish.ogg', 30, 1, -3)
		spawn(0)
			S.start()
	..()

/obj/item/projectile/energy/blob/proc/ready_chemicals()
	if(reagents)
		var/reagent_vol = (round((splatter_volume / my_chems.len) * 100) / 100) //Cut it at the hundreds place, please.
		for(var/reagent in my_chems)
			reagents.add_reagent(reagent, reagent_vol)

/obj/item/projectile/energy/blob/toxic
	damage_type = TOX
	check_armour = "bio"
	my_chems = list(REAGENT_ID_AMATOXIN)

/obj/item/projectile/energy/blob/toxic/splattering
	splatter = TRUE

/obj/item/projectile/energy/blob/acid
	damage_type = BURN
	check_armour = "bio"
	my_chems = list(REAGENT_ID_SACID, REAGENT_ID_MOLD)

/obj/item/projectile/energy/blob/acid/splattering
	splatter = TRUE

/obj/item/projectile/energy/blob/combustible
	splatter = TRUE
	flammability = 0.25
	my_chems = list(REAGENT_ID_FUEL, REAGENT_ID_MOLD)

/obj/item/projectile/energy/blob/freezing
	my_chems = list(REAGENT_ID_FROSTOIL)
	modifier_type_to_apply = /datum/modifier/chilled
	modifier_duration = 1 MINUTE

/obj/item/projectile/energy/blob/freezing/splattering
	splatter = TRUE

/obj/item/projectile/bullet/thorn
	name = "spike"
	icon_state = "SpearFlight"
	damage = 20
	damage_type = BIOACID
	armor_penetration = 20
	penetrating = 3
	fire_sound = 'sound/effects/slime_squish.ogg'
