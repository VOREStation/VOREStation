/mob/living/simple_mob/homunculus
	name = "homunculus"
	desc = "A strange misshapen humanoid creature made purely from glamour!"

	icon_dead = "homunculus"
	icon_living = "homunculus"
	icon_state = "homunculus"
	icon = 'icons/mob/vore.dmi'

	ai_holder_type = /datum/ai_holder/simple_mob/passive

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	var/owner

/mob/living/simple_mob/homunculus/death()
	if(owner)
		var/obj/item/glamour_face/O = owner
		O.homunculus = 0
	qdel(src)

/mob/living/simple_mob/homunculus/update_icon()
	return

/mob/living/simple_mob/homunculus/update_icons()
	return

/mob/living/simple_mob/homunculus/evil
	var/seen_melee
	var/seen_gun
	var/transformed
	var/seen_armour
	maxHealth = 100
	health = 100

	faction = "glamour"

	melee_damage_lower = 5
	melee_damage_upper = 7

	ai_holder_type = /datum/ai_holder/simple_mob/hostile

/mob/living/simple_mob/homunculus/evil/Life()
	handle_homunculus()
	return ..()

/mob/living/simple_mob/homunculus/evil/proc/handle_homunculus()
	if(!transformed)
		for(var/mob/living/carbon/human/H in range(8, src))
			if(H.stat == DEAD)
				continue
			name = H.name
			desc = H.desc
			icon = H.icon
			icon_state = H.icon_state
			copy_overlays(H, TRUE)
			resize(H.size_multiplier, ignore_prefs = TRUE)
			var/obj/item/A = H.get_active_hand()
			var/obj/item/I = H.get_inactive_hand()
			if(istype(A,/obj/item/weapon/material) || istype(A,/obj/item/weapon/melee) || istype(I,/obj/item/weapon/material) || istype(I,/obj/item/weapon/melee))
				seen_melee = 1
				melee_damage_lower = 20
				melee_damage_upper = 30
			if(istype(A,/obj/item/weapon/gun/projectile) || istype(I,/obj/item/weapon/gun/projectile))
				seen_gun = 1
				projectiletype = /obj/item/projectile/bullet/pistol/medium
				projectilesound = 'sound/weapons/Gunshot_light.ogg'
				if(istype(A,/obj/item/weapon/gun/projectile/shotgun) || istype(I,/obj/item/weapon/gun/projectile/shotgun))
					projectiletype = /obj/item/projectile/bullet/pellet/shotgun
					projectilesound = 'sound/weapons/Gunshot_shotgun.ogg'
					reload_time = 1.5 SECONDS
					ranged_attack_delay = 1.5 SECONDS
					projectile_dispersion = 8
					projectile_accuracy = -40
				if(istype(A,/obj/item/weapon/gun/projectile/automatic) || istype(I,/obj/item/weapon/gun/projectile/automatic))
					base_attack_cooldown = 5
					projectile_dispersion = 7
					projectile_accuracy = -20
				if(istype(A,/obj/item/weapon/gun/projectile/heavysniper) || istype(I,/obj/item/weapon/gun/projectile/heavysniper))
					projectiletype = /obj/item/projectile/bullet/rifle/a145/highvel // Do not get seen with a big ass sniper!
					projectilesound = 'sound/weapons/Gunshot_cannon.ogg'
					ranged_attack_delay = 2.5 SECONDS
					reload_time = 5 SECONDS
					projectile_accuracy = 75
			if(istype(A,/obj/item/weapon/gun/energy) || istype(I,/obj/item/weapon/gun/energy))
				seen_gun = 1
				projectiletype = /obj/item/projectile/beam/midlaser
				projectilesound = 'sound/weapons/Laser.ogg'
				projectile_dispersion = 5
				projectile_accuracy = -20
				if(istype(A,/obj/item/weapon/gun/energy/ionrifle) || istype(I,/obj/item/weapon/gun/energy/ionrifle))
					projectiletype = /obj/item/projectile/ion
				if(istype(A,/obj/item/weapon/gun/energy/lasercannon) || istype(I,/obj/item/weapon/gun/energy/lasercannon))
					projectiletype = /obj/item/projectile/beam/heavylaser
					ranged_attack_delay = 2.5 SECONDS
					reload_time = 5 SECONDS
					projectilesound = 'sound/weapons/lasercannonfire.ogg'
				if(istype(A,/obj/item/weapon/gun/energy/sniperrifle) || istype(I,/obj/item/weapon/gun/energy/sniperrifle))
					projectiletype = /obj/item/projectile/beam/sniper // Do not get seen with a big ass sniper!
					projectilesound = 'sound/weapons/gauss_shoot.ogg'
					ranged_attack_delay = 2.5 SECONDS
					reload_time = 5 SECONDS
					projectile_accuracy = 75
			if(istype(A,/obj/item/weapon/gun/magnetic) || istype(I,/obj/item/weapon/gun/magnetic))
				seen_gun = 1
				projectiletype = /obj/item/projectile/bullet/magnetic/bore
				projectilesound = 'sound/weapons/railgun.ogg'
				ranged_attack_delay = 1.5 SECONDS
				projectile_dispersion = 5
				projectile_accuracy = 20
			var/obj/item/clothing/suit/S = H.get_equipped_item(slot_wear_suit)
			if(istype(S,/obj/item/clothing/suit/armor) || istype(S,/obj/item/clothing/suit/space/rig/))
				armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 100)
			transformed = 1
			return TRUE

