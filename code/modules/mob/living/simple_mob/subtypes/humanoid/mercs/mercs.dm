///////////////////////////////
//		Merc Mobs Go Here
///////////////////////////////

// Probably shouldn't use this directly, there are a bunch of sub-classes that are more complete.
/mob/living/simple_mob/humanoid/merc
	name = "mercenary"
	desc = "A tough looking heavily-armed individual."
	tt_desc = "E Homo sapiens"
	icon_state = "syndicate"
	icon_living = "syndicate"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"

	faction = "syndicate"
	movement_cooldown = 1

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15		//Tac Knife damage
	melee_damage_upper = 15
	attack_armor_pen = 20
	attack_sharp = TRUE
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 100)	// Same armor values as the vest they drop, plus simple mob immunities

	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier
	loot_list = list(/obj/item/weapon/material/knife/tacknife = 100)	// Might as well give it the knife

	ai_holder_type = /datum/ai_holder/simple_mob/merc
	say_list_type = /datum/say_list/merc

	// Grenade special attack vars
	var/grenade_type = /obj/item/weapon/grenade/concussion
	special_attack_cooldown = 45 SECONDS
	special_attack_min_range = 2
	special_attack_max_range = 7

////////////////////////////////
//		Grenade Attack
////////////////////////////////

// Any merc can use this, just set special_attack_charges to a positive value

// Check if we should bother with the grenade
/mob/living/simple_mob/humanoid/merc/should_special_attack(atom/A)
	var/mob_count = 0				// Are there enough mobs to consider grenading?
	var/turf/T = get_turf(A)
	for(var/mob/M in range(T, 2))
		if(M.faction == faction) 	// Don't grenade our friends
			return FALSE
		if(M in oview(src, special_attack_max_range))	// And lets check if we can actually see at least two people before we throw a grenade
			if(!M.stat)			// Dead things don't warrant a grenade
				mob_count ++
	if(mob_count < 2)
		return FALSE
	else
		return TRUE

// Yes? Throw the grenade
/mob/living/simple_mob/humanoid/merc/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	var/obj/item/weapon/grenade/G = new grenade_type(get_turf(src))
	if(istype(G))
		G.throw_at(A, G.throw_range, G.throw_speed, src)
		G.attack_self(src)
		special_attack_charges = max(special_attack_charges-1, 0)

	set_AI_busy(FALSE)


////////////////////////////////
//		Merc AI Types
////////////////////////////////
/datum/ai_holder/simple_mob/merc
	threaten = TRUE
	returns_home = TRUE		// Stay close to the base...
	wander = TRUE			// ... but "patrol" a little.
	intelligence_level = AI_SMART // Also knows not to walk while confused if it risks death.
	threaten_delay = 30 SECONDS // Mercs will give you 30 seconds to leave or get shot.

/datum/ai_holder/simple_mob/merc/ranged
	pointblank = TRUE		// They get close? Just shoot 'em!
	firing_lanes = TRUE		// But not your buddies!
	conserve_ammo = TRUE	// And don't go wasting bullets!

/datum/ai_holder/simple_mob/merc/ranged/sniper
	vision_range = 14	// We're a person with a long-ranged gun.

/datum/ai_holder/simple_mob/merc/ranged/sniper/max_range(atom/movable/AM)
	return holder.ICheckRangedAttack(AM) ? 14 : 1

////////////////////////////////
//			Melee
////////////////////////////////
/mob/living/simple_mob/humanoid/merc/melee	// Defined in case we add non-sword-and-board mercs
	loot_list = list(/obj/item/weapon/material/knife/tacknife = 100)

// Sword and Shield Merc
/mob/living/simple_mob/humanoid/merc/melee/sword
	icon_state = "syndicatemelee"
	icon_living = "syndicatemelee"

	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_armor_pen = 50
	attack_sharp = TRUE
	attack_edge = 1
	attacktext = list("slashed")

	loot_list = list(/obj/item/weapon/melee/energy/sword = 100, /obj/item/weapon/shield/energy = 100)

// They have a shield, so they try to block
/mob/living/simple_mob/humanoid/merc/melee/sword/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(20))
			visible_message("<span class='danger'>\The [src] blocks \the [O] with its shield!</span>")
			if(user)
				ai_holder.react_to_attack(user)
			return
		else
			..()
	else
		to_chat(user, "<span class='warning'>This weapon is ineffective, it does no damage.</span>")
		visible_message("<span class='warning'>\The [user] gently taps [src] with \the [O].</span>")

/mob/living/simple_mob/humanoid/merc/melee/sword/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(35))
		visible_message("<font color='red'><B>[src] blocks [Proj] with its shield!</B></font>")
		if(Proj.firer)
			ai_holder.react_to_attack(Proj.firer)
		return
	else
		..()


////////////////////////////////
//			Ranged
////////////////////////////////

// Base Ranged Merc, so we don't have to redefine a million vars for every subtype. Uses a pistol.
/mob/living/simple_mob/humanoid/merc/ranged
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	projectiletype = /obj/item/projectile/bullet/pistol/medium
//	casingtype = /obj/item/ammo_casing/spent	//Makes infinite stacks of bullets when put in PoIs.
	projectilesound = 'sound/weapons/Gunshot_light.ogg'
	loot_list = list(/obj/item/weapon/gun/projectile/colt = 100)

	needs_reload = TRUE
	reload_max = 7		// Not the best default, but it fits the pistol
	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged

// C20r SMG
/mob/living/simple_mob/humanoid/merc/ranged/smg
	icon_state = "syndicateranged_smg"
	icon_living = "syndicateranged_smg"

	loot_list = list(/obj/item/weapon/gun/projectile/automatic/c20r = 100)

	projectile_dispersion = 7
	projectile_accuracy = -20
	base_attack_cooldown = 5 // Two attacks a second or so.
	reload_max = 20

/mob/living/simple_mob/humanoid/merc/ranged/smg/sol
	icon_state = "bluforranged_smg"
	icon_living = "blueforranged_smg"

	corpse = /obj/effect/landmark/mobcorpse/solarpeacekeeper
	loot_list = list(/obj/item/weapon/gun/projectile/automatic/c20r = 100)

	base_attack_cooldown = 5 // Two attacks a second or so.
	reload_max = 20

// Rifles
/mob/living/simple_mob/humanoid/merc/ranged/rifle
	icon_state = "syndicateranged_rifle"
	icon_living = "syndicateranged_rifle"

	loot_list = list(/obj/item/weapon/gun/projectile/automatic/z8 = 100)

	projectilesound = 'sound/weapons/Gunshot_heavy.ogg'
	projectiletype = /obj/item/projectile/bullet/rifle/a762
	projectile_dispersion = 8
	projectile_accuracy = -15
	base_attack_cooldown = 5
	reload_max = 30

/mob/living/simple_mob/humanoid/merc/ranged/rifle/mag
	loot_list = list(/obj/item/weapon/gun/magnetic/railgun/flechette = 100)
	projectiletype = /obj/item/projectile/bullet/magnetic/flechette

	projectilesound = 'sound/weapons/rapidslice.ogg'
	reload_max = 10

// Laser Rifle
/mob/living/simple_mob/humanoid/merc/ranged/laser
	icon_state = "syndicateranged_laser"
	icon_living = "syndicateranged_laser"
	projectiletype = /obj/item/projectile/beam/midlaser
	projectilesound = 'sound/weapons/Laser.ogg'

	loot_list = list(/obj/item/weapon/gun/energy/laser = 100)

	projectile_dispersion = 5
	projectile_accuracy = -20
	reload_max = 10

// Ion Rifle
/mob/living/simple_mob/humanoid/merc/ranged/ionrifle
	icon_state = "syndicateranged_ionrifle"
	icon_living = "syndicateranged_ionrifle"
	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'

	loot_list = list(/obj/item/weapon/gun/energy/ionrifle = 100)

	reload_max = 10

// Grenadier, Basically a miniboss
/mob/living/simple_mob/humanoid/merc/ranged/grenadier
	icon_state = "syndicateranged_shotgun"
	icon_living = "syndicateranged_shotgun"
	projectiletype = /obj/item/projectile/bullet/pellet/shotgun		// Buckshot
	projectilesound = 'sound/weapons/Gunshot_shotgun.ogg'

	loot_list = list(/obj/item/weapon/gun/projectile/shotgun/pump = 100)

	reload_max = 4
	reload_time = 1.5 SECONDS	// It's a shotgun, it takes a moment

	projectile_dispersion = 8
	projectile_accuracy = -40
	special_attack_charges = 5

// Technician, also kind of a miniboss. Carries a dartgun and manhack launcher.
/mob/living/simple_mob/humanoid/merc/ranged/technician
	icon_state = "syndicateranged_technician"
	icon_living = "syndicateranged_technician"
	projectiletype = /obj/item/projectile/fake_syringe/poison	// Toxin dart.
	projectilesound = 'sound/weapons/Gunshot_old.ogg'

	loot_list = list(/obj/item/weapon/gun/projectile/dartgun = 100,
		/obj/item/weapon/gun/launcher/grenade = 100,
		/obj/item/weapon/grenade/spawnergrenade/manhacks/mercenary = 50,
		/obj/item/weapon/grenade/spawnergrenade/manhacks/mercenary = 30
		)

	reload_max = 5
	reload_time = 1 SECOND

	// Manhacks.
	grenade_type = /obj/item/weapon/grenade/spawnergrenade/manhacks/mercenary

	projectile_dispersion = 8
	projectile_accuracy = -40
	special_attack_charges = 5

// Sniper, definitely a miniboss, based on its massive range advantage, and method of battle.
// Creates a beam for 2 seconds, fire after another .5, then a 5 second reload.
/mob/living/simple_mob/humanoid/merc/ranged/sniper
	icon_state = "syndicateranged_sniper"
	icon_living = "syndicateranged_sniper"
	projectiletype = /obj/item/projectile/bullet/rifle/a145/highvel // Really scary bullet.
	projectilesound = 'sound/weapons/Gunshot_cannon.ogg'

	projectile_accuracy = 75

	reload_max = 1
	reload_time = 5 SECONDS

	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged/sniper

	ranged_attack_delay = 2.5 SECONDS

	loot_list = list(/obj/item/sniper_rifle_part/barrel = 50,
		/obj/item/sniper_rifle_part/stock = 50,
		/obj/item/sniper_rifle_part/trigger_group = 50,
		/obj/item/weapon/grenade/spawnergrenade/manhacks/mercenary = 90
		)

	// Babyfrags.
	grenade_type = /obj/item/weapon/grenade/explosive/mini
	// Babyfrags go a long way.
	special_attack_min_range = 6
	special_attack_max_range = 10

/mob/living/simple_mob/humanoid/merc/ranged/sniper/ranged_pre_animation(atom/A)
	Beam(get_turf(A), icon_state = "sniper_beam", time = 2 SECONDS, maxdistance = 15)
	. = ..()

/mob/living/simple_mob/humanoid/merc/ranged/sniper/shoot_target(atom/A)
	set waitfor = FALSE

	if(!istype(A) || QDELETED(A))
		return

	setClickCooldown(get_attack_speed())

	face_atom(A)

	var/atom/orig_targ = A

	if(ranged_attack_delay)
		A = get_turf(orig_targ)
		ranged_pre_animation(A)
		handle_attack_delay(A, ranged_attack_delay) // This will sleep this proc for a bit, which is why waitfor is false.

	if(needs_reload)
		if(reload_count >= reload_max)
			try_reload()
			return FALSE

	visible_message("<span class='danger'><b>\The [src]</b> fires at \the [orig_targ]!</span>")
	shoot(A)
	if(casingtype)
		new casingtype(loc)

	if(ranged_attack_delay)
		ranged_post_animation(A)

	return TRUE

////////////////////////////////
//		Space Mercs
////////////////////////////////

// Sword Space Merc
/mob/living/simple_mob/humanoid/merc/melee/sword/space
	name = "syndicate commando"
	icon_state = "syndicatemeleespace"
	icon_living = "syndicatemeleespace"

	movement_cooldown = -1

	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 100)	// Same armor as their voidsuit

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando

/mob/living/simple_mob/humanoid/merc/melee/sword/space/Process_Spacemove(var/check_drift = 0)
	return

// Ranged Space Merc
/mob/living/simple_mob/humanoid/merc/ranged/space
	name = "syndicate sommando"
	icon_state = "syndicaterangedpsace"
	icon_living = "syndicaterangedpsace"

	movement_cooldown = -1

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	projectile_dispersion = 7
	projectile_accuracy = -20

	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando

/mob/living/simple_mob/humanoid/merc/ranged/space/Process_Spacemove(var/check_drift = 0)
	return

////////////////////////////////
//			PoI Mercs
////////////////////////////////

// Most likely to drop a broken weapon matching them, if it's a gun.
/mob/living/simple_mob/humanoid/merc/melee/poi
	loot_list = list(/obj/item/weapon/material/knife/tacknife/combatknife = 100)

/mob/living/simple_mob/humanoid/merc/melee/sword/poi
	loot_list = list(/obj/item/weapon/melee/energy/sword/color = 20,
		/obj/item/weapon/shield/energy = 40
		)

/mob/living/simple_mob/humanoid/merc/ranged/poi
	loot_list = list(/obj/random/projectile/scrapped_pistol = 100)

/mob/living/simple_mob/humanoid/merc/ranged/smg/poi
	loot_list = list(/obj/random/projectile/scrapped_smg = 100)

/mob/living/simple_mob/humanoid/merc/ranged/laser/poi
	loot_list = list(/obj/random/projectile/scrapped_laser = 100)

/mob/living/simple_mob/humanoid/merc/ranged/ionrifle/poi
	loot_list = list(/obj/random/projectile/scrapped_ionrifle = 100)

/mob/living/simple_mob/humanoid/merc/ranged/grenadier/poi
	loot_list = list(/obj/random/projectile/scrapped_shotgun = 100)

/mob/living/simple_mob/humanoid/merc/ranged/rifle/poi
	loot_list = list(/obj/random/projectile/scrapped_bulldog = 100)

/mob/living/simple_mob/humanoid/merc/ranged/rifle/mag/poi
	loot_list = list(/obj/random/projectile/scrapped_flechette = 100)

/mob/living/simple_mob/humanoid/merc/ranged/technician/poi
	loot_list = list(/obj/random/projectile/scrapped_dartgun = 100,
		/obj/random/projectile/scrapped_grenadelauncher = 100,
		/obj/item/weapon/grenade/spawnergrenade/manhacks/mercenary = 50,
		/obj/item/weapon/grenade/spawnergrenade/manhacks/mercenary = 30
		)
