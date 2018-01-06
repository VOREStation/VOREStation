/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	light_range = 2
	light_power = 0.5
	light_color = "#55AAFF"
	var/pulse_range = 1


/obj/item/projectile/ion/on_hit(var/atom/target, var/blocked = 0)
		empulse(target, pulse_range, pulse_range, pulse_range, pulse_range)
		return 1

/obj/item/projectile/ion/small
	pulse_range = 0

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	check_armour = "bullet"
	sharp = 1
	edge = 1

/obj/item/projectile/bullet/gyro/on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	nodamage = 1
	check_armour = "energy" // It actually checks heat/cold protection.
	var/target_temperature = 50
	light_range = 2
	light_power = 0.5
	light_color = "#55AAFF"

/obj/item/projectile/temp/on_hit(atom/target, blocked = FALSE)
	..()
	if(isliving(target))
		var/mob/living/L = target

		var/protection = null
		var/potential_temperature_delta = null
		var/new_temperature = L.bodytemperature

		if(target_temperature >= T20C) // Make it cold.
			protection = L.get_cold_protection(target_temperature)
			potential_temperature_delta = 75
			new_temperature = max(new_temperature - potential_temperature_delta, target_temperature)
		else // Make it hot.
			protection = L.get_heat_protection(target_temperature)
			potential_temperature_delta = 200 // Because spacemen temperature needs stupid numbers to actually hurt people.
			new_temperature = min(new_temperature + potential_temperature_delta, target_temperature)

		var/temp_factor = abs(protection - 1)

		new_temperature = round(new_temperature * temp_factor)
		L.bodytemperature = new_temperature

	return 1

/obj/item/projectile/temp/hot
	name = "heat beam"
	target_temperature = 1000

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	check_armour = "bullet"

/obj/item/projectile/meteor/Bump(atom/A as mob|obj|turf|area)
	if(A == firer)
		loc = A.loc
		return

	sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

	if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
		if(A)

			A.ex_act(2)
			playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

			for(var/mob/M in range(10, src))
				if(!M.stat && !istype(M, /mob/living/silicon/ai))\
					shake_camera(M, 3, 1)
			qdel(src)
			return 1
	else
		return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"

/obj/item/projectile/energy/floramut/on_hit(var/atom/target, var/blocked = 0)
	var/mob/living/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
			if(prob(15))
				M.apply_effect((rand(30,80)),IRRADIATE)
				M.Weaken(5)
				for (var/mob/V in viewers(src))
					V.show_message("<font color='red'>[M] writhes in pain as \his vacuoles boil.</font>", 3, "<font color='red'>You hear the crunching of leaves.</font>", 2)
			if(prob(35))
			//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
			//		V.show_message("<font color='red'>[M] is mutated by the radiation beam.</font>", 3, "<font color='red'> You hear the snapping of twigs.</font>", 2)
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message("<font color='red'>The radiation beam singes you!</font>")
			//	for (var/mob/V in viewers(src))
			//		V.show_message("<font color='red'>[M] is singed by the radiation beam.</font>", 3, "<font color='red'> You hear the crackle of burning leaves.</font>", 2)
	else if(istype(target, /mob/living/carbon/))
	//	for (var/mob/V in viewers(src))
	//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
		M.show_message("<font color='blue'>The radiation beam dissipates harmlessly through your body.</font>")
	else
		return 1

/obj/item/projectile/energy/floramut/gene
	name = "gamma somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"
	var/decl/plantgene/gene = null

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"

/obj/item/projectile/energy/florayield/on_hit(var/atom/target, var/blocked = 0)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
			M.nutrition += 30
	else if (istype(target, /mob/living/carbon/))
		M.show_message("<font color='blue'>The radiation beam dissipates harmlessly through your body.</font>")
	else
		return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

/obj/item/projectile/beam/mindflayer/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.Confuse(rand(5,8))

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed_chance = 0 // nope
	nodamage = 1
	damage_type = HALLOSS
	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/bola
	name = "bola"
	icon_state = "bola"
	damage = 5
	embed_chance = 0 //Nada.
	damage_type = HALLOSS
	muzzle_type = null

/obj/item/projectile/bola/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		var/obj/item/weapon/handcuffs/legcuffs/bola/B = new(src.loc)
		if(!B.place_legcuffs(M,firer))
			if(B)
				qdel(B)
	..()

/obj/item/projectile/webball
	name = "ball of web"
	icon_state = "bola"
	damage = 10
	embed_chance = 0 //Nada.
	damage_type = BRUTE
	muzzle_type = null

/obj/item/projectile/webball/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target.loc))
		var/obj/effect/spider/stickyweb/W = locate() in get_turf(target)
		if(!W && prob(75))
			visible_message("<span class='danger'>\The [src] splatters a layer of web on \the [target]!</span>")
			new /obj/effect/spider/stickyweb(target.loc)
	..()
