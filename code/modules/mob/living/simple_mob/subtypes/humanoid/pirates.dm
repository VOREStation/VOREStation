///////////////////////////////
//	Yargh Yargh Fiddle De Di
///////////////////////////////

/datum/category_item/catalogue/fauna/pirate
	name = "Pirates"
	desc = "Life on the Frontier is often harsh, and there are many \
	natural hazards which must be navigated and accounted for. In the \
	face of such constant adversity, some colonists will resort to crime \
	and piracy to try and make their way. From misguided attempts at \
	survival to malicious profiteering, Piracy is a constant concern \
	on the Frontier, and is punished harshly by every Megacorporation."
	value = CATALOGUER_REWARD_TRIVIAL

///////////////////////////////
//		Knife Priate
///////////////////////////////
/mob/living/simple_mob/humanoid/pirate
	name = "Pirate"
	desc = "Does what he wants cause a pirate is free."
	tt_desc = "E Homo sapiens"
	icon = 'icons/mob/pirates.dmi'
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/pirate)

	faction = FACTION_PIRATE

	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"

	movement_cooldown = 2

	harm_intent_damage = 5
	melee_damage_lower = 15		//Tac Knife damage
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1

	attacktext = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	loot_list = list(/obj/item/material/knife/tacknife = 100)

	corpse = /obj/effect/landmark/mobcorpse/pirate

	ai_holder_type = /datum/ai_holder/simple_mob/merc
	say_list_type = /datum/say_list/pirate

/mob/living/simple_mob/humanoid/pirate/Initialize(mapload)
	. = ..()
	loot_list += list(/obj/item/salvage/loot/pirate = 35)

//Armored Variant

/mob/living/simple_mob/humanoid/pirate/armored
	name = "Armored Pirate"
	desc = "Does what he wants cause a pirate is free. This one wears crude armor."
	icon_state = "piratemelee-armor"
	icon_living = "piratemelee-armor"
	movement_cooldown = 4
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)
	loot_list = list(/obj/item/material/knife/tacknife = 100, /obj/item/clothing/suit/armor/material/makeshift = 100)

///////////////////////////////
//		Machete Priate
///////////////////////////////

/mob/living/simple_mob/humanoid/pirate/machete
	name = "Pirate Brush Cutter"
	desc = "Does what he wants cause a pirate is free. This one has got a machete."
	tt_desc = "E Homo sapiens"
	icon_state = "piratemelee-machete"
	icon_living = "piratemelee-machete"
	icon_dead = "piratemelee_dead"

	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"


	melee_damage_lower = 25		//Macehte damage
	melee_damage_upper = 25

	attacktext = list("slashed", "chopped", "gouged", "ripped", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	loot_list = list(/obj/item/material/knife/machete = 100)

	corpse = /obj/effect/landmark/mobcorpse/pirate

//Armored Variant

/mob/living/simple_mob/humanoid/pirate/machete/armored
	name = "Armored Brush Cutter"
	desc = "Does what he wants cause a pirate is free. This one has got a machete and wears crude armor."
	icon_state = "piratemelee-machete-armor"
	icon_living = "piratemelee-machete-armor"
	movement_cooldown = 3
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)
	loot_list = list(/obj/item/material/knife/machete = 100, /obj/item/clothing/suit/armor/material/makeshift = 100)

///////////////////////////////
//		E-Sword Priate
///////////////////////////////

/mob/living/simple_mob/humanoid/pirate/las
	name = "Pirate Duelist"
	desc = "Does what he wants cause a pirate is free. This one has a energy sword."
	tt_desc = "E Homo sapiens"
	icon_state = "piratemelee-las"
	icon_living = "piratemelee-las"
	icon_dead = "piratemelee_dead"

	melee_damage_lower = 30		//E-Sword Damage
	melee_damage_upper = 30
	attack_armor_pen = 50

	attack_sound = 'sound/weapons/blade1.ogg'


	loot_list = list(/obj/item/melee/energy/sword/pirate = 100)

//Armored Variant
/mob/living/simple_mob/humanoid/pirate/las/armored
	name = "Armored Duelist"
	desc = "Does what he wants cause a pirate is free. This one has an energy sword."
	icon_state = "piratemelee-las-armor"
	icon_living = "piratemelee-las-armor"
	movement_cooldown = 4
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)
	loot_list = list(/obj/item/melee/energy/sword/pirate = 100, /obj/item/clothing/suit/armor/material/makeshift = 100)


///////////////////////////////
//		Shield Pirate
///////////////////////////////
/mob/living/simple_mob/humanoid/pirate/shield
	name = "Pirate Buckler"
	desc = "Does what he wants cause a pirate is free. This one carries a shield for added protection."
	icon_state = "piratemelee-shield"
	icon_living = "piratemelee-shield"

//This Should Allow all childs of the shield priate to block
/mob/living/simple_mob/humanoid/pirate/shield/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(15))
			visible_message(span_danger("\The [src] blocks \the [O] with its shield!"))
			if(user)
				ai_holder.react_to_attack(user)
			return
		else
			..()
	else
		to_chat(user, span_warning("This weapon is ineffective, it does no damage."))
		visible_message(span_warning("\The [user] gently taps [src] with \the [O]."))

/mob/living/simple_mob/humanoid/merc/melee/sword/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(25))
		visible_message(span_bolddanger("[src] blocks [Proj] with its shield!"))
		if(Proj.firer)
			ai_holder.react_to_attack(Proj.firer)
		return
	else
		..()

// Armored Variant
/mob/living/simple_mob/humanoid/pirate/shield/armored
	name = "Armored Buckler"
	desc = "Does what he wants cause a pirate is free. This carries a shield and wears crude armor."
	icon_state = "piratemelee-shield-armor"
	icon_living = "piratemelee-shield-armor"
	movement_cooldown = 3
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)
	loot_list = list(/obj/item/material/knife/tacknife = 100, /obj/item/clothing/suit/armor/material/makeshift = 100)

///////////////////////////////
//	Shield Machete Pirate
///////////////////////////////

/mob/living/simple_mob/humanoid/pirate/shield/machete
	name = "Pirate Sword and Boarder"
	desc = "Does what he wants cause a pirate is free. This one has got a machete and a shield."
	icon_state = "piratemelee-shield-machete"
	icon_living = "piratemelee-shield-machete"
	icon_dead = "piratemelee_dead"

	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"


	melee_damage_lower = 25		//Macehte damage
	melee_damage_upper = 25

	attacktext = list("slashed", "chopped", "gouged", "ripped", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	loot_list = list(/obj/item/material/knife/machete = 100)

// Armored Variant
/mob/living/simple_mob/humanoid/pirate/shield/machete/armored
	name = "Armored Sword and Boarder"
	desc = "Does what he wants cause a pirate is free. This one is equipped old fashioned sword and shield along with crude armor."
	icon_state = "piratemelee-shield-machete-armor"
	icon_living = "piratemelee-shield-machete-armor"
	movement_cooldown = 4
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)
	loot_list = list(/obj/item/material/knife/machete = 100, /obj/item/clothing/suit/armor/material/makeshift = 100)





///////////////////////////////
//		Pirate Pistolier
///////////////////////////////

/mob/living/simple_mob/humanoid/pirate/ranged
	name = "Pirate Pistolier"
	desc = "Does what he wants since a pirate is free. This one is armed with a zip gun."
	icon_state = "pirateranged"
	icon_living = "pirateranged"
	icon_dead = "piratemelee_dead"

	reload_time = 4 SECONDS // ZipGuns are finicky an hard to load
	needs_reload = TRUE
	reload_max = 1

	projectiletype = /obj/item/projectile/bullet/shotgun
	projectilesound = 'sound/weapons/weaponsounds_shotgunshot.ogg'

	loot_list = list(/obj/item/gun/projectile/pirate = 100, /obj/item/material/knife/tacknife = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged


//Armored Variant
/mob/living/simple_mob/humanoid/pirate/ranged/armored
	name = "Armored Pistolier"
	desc = "Does what he wants cause a pirate is free. This is armed with a zip gun and wears crude armor."
	icon_state = "pirateranged-armor"
	icon_living = "pirateranged-armor"
	movement_cooldown = 4
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)
	loot_list = list(/obj/item/material/knife/tacknife = 100, /obj/item/gun/projectile/pirate = 100, /obj/item/clothing/suit/armor/material/makeshift = 100)

///////////////////////////////
//		Pirate Blunderbuster
///////////////////////////////

/mob/living/simple_mob/humanoid/pirate/ranged/shotgun
	name = "Pirate Blunderbuster"
	desc = "Does what he wants since a pirate is free. This one has a sawn off shotgun."
	icon_state = "pirateranged-blunder"
	icon_living = "pirateranged-blunder"
	icon_dead = "piratemelee_dead"

	reload_time = 3 SECONDS // Shotgun Reload
	needs_reload = TRUE
	reload_max = 2

	projectiletype = /obj/item/projectile/bullet/pellet/shotgun
	projectilesound = 'sound/weapons/weaponsounds_shotgunshot.ogg'

	loot_list = list(/obj/item/gun/projectile/shotgun/doublebarrel/sawn = 100, /obj/item/material/knife/tacknife = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive

//Armored Variant
/mob/living/simple_mob/humanoid/pirate/ranged/shotgun/armored
	name = "Armored Blunderbuster"
	desc = "Does what he wants cause a pirate is free. This is armed with a sawn off shotgun and wears crude armor."
	icon_state = "pirateranged-blunder-armor"
	icon_living = "pirateranged-blunder-armor"
	movement_cooldown = 4
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)
	loot_list = list(/obj/item/material/knife/tacknife = 100, /obj/item/gun/projectile/shotgun/doublebarrel/sawn = 100, /obj/item/clothing/suit/armor/material/makeshift = 100)

///////////////////////////////
//		Pirate Ziplas
///////////////////////////////

/mob/living/simple_mob/humanoid/pirate/ranged/handcannon
	name = "Pirate Handcannon"
	desc = "Does what he wants since a pirate is free. This one has an improvised laser pistol."
	icon_state = "pirateranged-handcannon"
	icon_living = "pirateranged-handcannon"
	icon_dead = "piratemelee_dead"

	reload_time = 6 SECONDS //Zip-Las takes a real long time to reload.
	needs_reload = TRUE
	reload_max = 1

	projectiletype = /obj/item/projectile/beam/heavylaser
	projectilesound = 'sound/weapons/weaponsounds_laserstrong.ogg'

	loot_list = list(/obj/item/gun/energy/zip = 100, /obj/item/material/knife/tacknife = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive

//Armored Variant
/mob/living/simple_mob/humanoid/pirate/ranged/handcannon/armored
	name = "Armored Handcannon"
	desc = "Does what he wants cause a pirate is free. This one has a improvised laser pistol and crude armor."
	icon_state = "pirateranged-handcannon-armor"
	icon_living = "pirateranged-handcannon-armor"
	movement_cooldown = 4
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)
	loot_list = list(/obj/item/material/knife/tacknife = 100, /obj/item/gun/energy/zip = 100, /obj/item/clothing/suit/armor/material/makeshift = 100)

///////////////////////////////
//		First Mate
///////////////////////////////
/mob/living/simple_mob/humanoid/pirate/mate
	name = "First Mate"
	desc = "A leading figure amongst the pirate hoards. This one is armed with a laser cutlass"
	tt_desc = "E Homo sapiens"
	icon_state = "mate"
	icon_living = "mate"
	icon_dead = "piratemelee_dead"

	melee_damage_lower = 30		//E-Sword Damage
	melee_damage_upper = 30
	attack_armor_pen = 50

	attack_sound = 'sound/weapons/blade1.ogg'

	armor = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)

	loot_list = list(/obj/item/melee/energy/sword/pirate = 100, /obj/item/clothing/suit/pirate = 100)


///////////////////////////////
//		Mate Pistolier
///////////////////////////////
/mob/living/simple_mob/humanoid/pirate/mate/ranged
	name = "Mate Pistolier"
	desc = "A leading figure amongst the pirate hoards. This one is armed with a obsolete laser pistol."
	icon_state = "mate-pistoler"
	icon_living = "mate-pistoler"
	icon_dead = "piratemelee_dead"

	reload_time = 2 SECONDS //Retro Energy Pistol is far easier to reload than Zip-Las
	needs_reload = TRUE
	reload_max = 5

	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15

	projectiletype = /obj/item/projectile/beam/midlaser
	projectilesound = 'sound/weapons/weaponsounds_lasermid.ogg'

	attack_sound = 'sound/weapons/bladeslice.ogg'
	base_attack_cooldown = 10

	loot_list = list(/obj/item/gun/energy/retro = 100, /obj/item/clothing/suit/pirate = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged

/mob/living/simple_mob/humanoid/pirate/mate/ranged/bosun /// Special Mech Pilot Pirate
	name = "Bosun"
	desc = "An oily pirate mechanist. Thankfully he has but an old laser to defend himself with."
	icon_state = "bosun"
	icon_living = "bosun"
	movement_cooldown = 3
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive/blood_hunter // This is for use in the Pirate Ripley Mecha

	loot_list = list(/obj/item/gun/energy/retro = 100, /obj/item/clothing/head/welding = 100, /obj/item/clothing/suit/pirate = 100)

///////////////////////////////
//		Mate Sweeper
///////////////////////////////

/mob/living/simple_mob/humanoid/pirate/mate/ranged/shotgun
	name = "Mate Blunderbuster"
	desc = "A leading figure amongst the pirate hoards. This one is armed with a four barreled shotgun"
	icon_state = "mate-shotgun"
	icon_living = "mate-shotgun"
	icon_dead = "piratemelee_dead"

	reload_time = 4 SECONDS //Assume use of speedloaders
	needs_reload = TRUE
	reload_max = 4

	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_sound = 'sound/weapons/bladeslice.ogg'

	projectiletype = /obj/item/projectile/bullet/pellet/shotgun
	projectilesound = 'sound/weapons/weaponsounds_shotgunshot.ogg'
	base_attack_cooldown = 5

	loot_list = list(/*/obj/item/gun/projectile/shotgun/doublebarrel/quad = 100, Downstream*/ /obj/item/clothing/suit/pirate = 100)

///////////////////////////////
//		Mate Marksman
///////////////////////////////

/mob/living/simple_mob/humanoid/pirate/mate/ranged/rifle
	name = "Mate Marksman"
	desc = "A leading figure amongst the pirate hoards. This one is armed with a rifle."
	icon_state = "mate-rifle"
	icon_living = "mate-rifle"
	icon_dead = "piratemelee_dead"

	reload_time = 1.5 SECONDS //Assume use of speedloaders
	needs_reload = TRUE
	reload_max = 5

	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_sound = 'sound/weapons/bladeslice.ogg'

	projectiletype = /obj/item/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'
	base_attack_cooldown = 10

	loot_list = list(/obj/item/gun/projectile/shotgun/pump/rifle = 100, /obj/item/clothing/suit/pirate = 100)

///////////////////////////////
//		Pirate Captain
///////////////////////////////
/mob/living/simple_mob/humanoid/pirate/captain
	name = "Pirate Captain"
	desc = "Leader of a Pirate Vessel armed with an entire belt of improvised laser pistols. A true villian indeed."
	icon_state = "captain"
	icon_living = "captain"
	icon_dead = "pirateranged_dead"

	reload_time = 10 SECONDS // I mean its a belt of pistols not exactly easy to reload. Especially with how much damage the barage does.
	needs_reload = TRUE
	reload_max = 4
	projectiletype = /obj/item/projectile/beam/heavylaser
	projectilesound = 'sound/weapons/weaponsounds_laserstrong.ogg'
	base_attack_cooldown = 5

	corpse = /obj/effect/landmark/mobcorpse/pirate/ranged

	loot_list = list(/obj/item/gun/energy/zip = 100, /obj/item/gun/energy/zip = 100, /obj/item/gun/energy/zip = 100, /obj/item/gun/energy/zip = 100) //Belt of pistols

	var/obj/item/shield_projector/shields = null

/mob/living/simple_mob/humanoid/pirate/captain/Initialize(mapload)
	shields = new /obj/item/shield_projector/rectangle/automatic/drone(src)
	return ..()

/mob/living/simple_mob/humanoid/pirate/captain/Process_Spacemove(var/check_drift = 0)
	return TRUE

/obj/item/shield_projector/rectangle/automatic/drone
	shield_health = 150
	max_shield_health = 150
	shield_regen_delay = 10 SECONDS
	shield_regen_amount = 10
	size_x = 1
	size_y = 1



/mob/living/simple_mob/mechanical/mecha/ripley/pirate
	name = "Hull Ripper"
	desc = "A Ripley modified by pirates. Sports additional riveted armor plating and a jury rigged machine gun in addition to its hull piercing drill."
	catalogue_data = list(/datum/category_item/catalogue/technology/ripley)
	icon = 'icons/mob/pirates.dmi'
	icon_state = "pirate"
	faction = "pirate"
	wreckage = /obj/structure/loot_pile/mecha/ripley/pirate

	maxHealth = 250
	heat_resist = 1
	armor = list(
				"melee"		= 30,
				"bullet"	= 40,
				"laser"		= 50,
				"energy"	= 5,
				"bomb"		= 50,
				"bio"		= 100,
				"rad"		= 100
				)

	projectiletype = /obj/item/projectile/bullet/pistol
	base_attack_cooldown = 0.5 SECONDS
	needs_reload = TRUE
	reload_max = 30
	reload_time = 3

/mob/living/simple_mob/mechanical/mecha/ripley/pirate/manned
	pilot_type = /mob/living/simple_mob/humanoid/pirate/mate/ranged/bosun

/mob/living/simple_mob/mechanical/mecha/ripley/pirate/last_stand_merc	//Special version used as a quasi boss fight
	name = "Xeno Ripper"
	desc = "A Ripley modified by a desperate merc. It sports additional riveted armor plating splattered with dried xeno blood and a jury rigged machine gun in addition to its drill.\
			A repair drone flits around the intimidating mech."
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive
	maxHealth = 170				//Less Health
	has_repair_droid = TRUE		//But has repair drone
	pilot_type = /mob/living/simple_mob/humanoid/possessed/merc/feral	//Possessed rig suit piloting a mech. Tremble in fear
	movement_shake_radius = 5
