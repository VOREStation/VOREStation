/mob/living/simple_mob/animal/space/mouse_army
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small militarized rodent."
	tt_desc = "E Mus musculus"
	icon = 'icons/mob/mouse_army.dmi'
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	icon_rest = "mouse_gray_sleep"
	faction = "mouse_army"

	maxHealth = 50
	health = 50
	universal_understand = 1

	taser_kill = 0

	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
//	can_pull_size = ITEMSIZE_TINY
//	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"

	min_oxy = 0 //Require atleast 16kPA oxygen
	minbodytemp = 0		//Below -50 Degrees Celcius
	maxbodytemp = 5000	//Above 50 Degrees Celcius

	//Mob melee settings
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = list("attacked", "chomped", "gnawed on")
	friendly = list("baps", "nuzzles")
	attack_armor_type = "melee"
	attack_sharp = 1
	attack_edge = 1

	//Damage resistances
	shock_resist = 1
	armor = list(
				"melee" = 30,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 0,
				"rad" = 0)	//Standard armor vest stats, slightly dropped due to scale.

	has_langs = list("Mouse")

	holder_type = /obj/item/holder/mouse
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	say_list_type = /datum/say_list/mouse

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	var/rank //pyro, operative, ammo, stealth. more to come. Do not leave blank.

	can_be_drop_prey = FALSE //CHOMP Add
	species_sounds = "Mouse"
	pain_emote_1p = list("squeak", "squik") // CHOMP Addition: Pain/etc sounds
	pain_emote_1p = list("squeaks", "squiks") // CHOMP Addition: Pain/etc sounds

/mob/living/simple_mob/animal/space/mouse_army/Initialize(mapload)
	. = ..()

	add_verb(src,/mob/living/proc/ventcrawl) //CHOMPEdit TGPanel
	add_verb(src,/mob/living/proc/hide) //CHOMPEdit TGPanel

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

	if(!rank)
		rank = pick( list("operative","pyro", "ammo", "stealth") )
	icon_state = "mouse_[rank]"
	item_state = "mouse_[rank]"
	icon_living = "mouse_[rank]"
	icon_dead = "mouse_[rank]_dead"
	icon_rest = "mouse_[rank]_sleep"

/mob/living/simple_mob/animal/space/mouse_army/Crossed(AM as mob|obj)
	var/mob/SK = AM
	if(SK.is_incorporeal())
		return
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M.visible_message(span_blue("[icon2html(src,viewers(M))] Squeek!"))
			playsound(src, 'sound/effects/mouse_squeak.ogg', 35, 1)
	..()

/mob/living/simple_mob/animal/space/mouse_army/death()
	layer = MOB_LAYER
	playsound(src, 'sound/effects/mouse_squeak_loud.ogg', 35, 1)
	if(client)
		client.time_died_as_mouse = world.time
	..()

/mob/living/simple_mob/animal/space/mouse_army/cannot_use_vents()
	return

/mob/living/simple_mob/animal/space/mouse_army/proc/splat()
	src.health = 0
	src.stat = DEAD
	src.icon_dead = "mouse_[rank]_splat"
	src.icon_state = "mouse_[rank]_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

//Base ported from vgstation. Operative Mice.
//Icon artists: DeityLink and plosky1
/mob/living/simple_mob/animal/space/mouse_army/operative
	name = "operative mouse"
	desc = "Where did it get that? Oh no..."
	tt_desc = "E Mus sinister"
	rank = "operative"

	shock_resist = 1
	armor = list(
				"melee" = 40,
				"bullet" = 40,
				"laser" = 30,
				"energy" = 15,
				"bomb" = 35,
				"bio" = 100,
				"rad" = 100)	//Mercenary Voidsuit Resistances, slightly downscaled, due to size.

//Pyro Mouse
/mob/living/simple_mob/animal/space/mouse_army/pyro
	name = "pyro mouse"
	desc = "What kind of madman would strap this to a mouse?"
	tt_desc = "E Mus phlogiston"
	rank = "pyro"

	maxHealth = 30
	health = 30

	//Mob melee settings
	melee_damage_lower = 5
	melee_damage_upper = 10
	attack_sharp = 0
	attack_edge = 0

	//Damage resistances
	shock_resist = 0.6
	armor = list(
				"melee" = 20,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 20,
				"bomb" = 90,
				"bio" = 100,
				"rad" = 100)

	projectiletype = /obj/item/projectile/bullet/incendiary/flamethrower
	base_attack_cooldown = 10

	ai_holder_type = /datum/ai_holder/simple_mob/ranged
	var/ruptured = 0

/mob/living/simple_mob/animal/space/mouse_army/pyro/death()
	visible_message(span_critical("\The [src]'s tank groans!"))
	var/delay = rand(1, 3)
	spawn(0)
		// Flash black and red as a warning.
		for(var/i = 1 to delay)
			if(i % 2 == 0)
				color = "#000000"
			else
				color = "#FF0000"
			sleep(1)

	spawn(rand (1,5))
		if(!ruptured)
			visible_message(span_critical("\The [src]'s tank ruptures!"))
			ruptured = 1
			adjust_fire_stacks(2)
			IgniteMob()
	return ..()

//Ammo Mouse
/mob/living/simple_mob/animal/space/mouse_army/ammo
	name = "ammo mouse"
	desc = "Aww! It's carrying a bunch of tiny bullets!"
	tt_desc = "E Mus tela"
	rank = "ammo"

	maxHealth = 30
	health = 30

	//Mob melee settings
	melee_damage_lower = 1
	melee_damage_upper = 5
	attack_sharp = 0
	attack_edge = 0

	//Damage resistances
	shock_resist = 0.6
	armor = list(
				"melee" = 40,
				"bullet" = 30,
				"laser" = 10,
				"energy" = 10,
				"bomb" = 15,
				"bio" = 100,
				"rad" = 100)

	var/exploded = FALSE
	var/explosion_dev_range		= 0
	var/explosion_heavy_range	= 0
	var/explosion_light_range	= 2
	var/explosion_flash_range	= 4 // This doesn't do anything iirc.

	var/explosion_delay_lower	= 1 SECOND	// Lower bound for explosion delay.
	var/explosion_delay_upper	= 3 SECONDS	// Upper bound.

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/animal/space/mouse_army/ammo/death()
	visible_message(span_critical("\The [src]'s body begins to rupture!"))
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	spawn(0)
		// Flash black and red as a warning.
		for(var/i = 1 to delay)
			if(i % 2 == 0)
				color = "#000000"
			else
				color = "#FF0000"
			sleep(1)

	spawn(rand(1,5))
		if(src && !exploded)
			visible_message(span_critical("\The [src]'s body detonates!"))
			exploded = 1
			explosion(src.loc, explosion_dev_range, explosion_heavy_range, explosion_light_range, explosion_flash_range)
			qdel(src)
	return ..()

/mob/living/simple_mob/animal/space/mouse_army/stealth
	name = "stealth mouse"
	desc = "I bet you thought the normal ones were scary!"
	tt_desc = "E Mus insidiis"
	rank = "stealth"

	//Mob melee settings
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_sharp = 1
	attack_edge = 1

	//Damage resistances
	shock_resist = 0.6
	armor = list(
				"melee" = 50,
				"bullet" = 10,
				"laser" = 10,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

	player_msg = "You have an imperfect, but automatic stealth. If you attack something while 'hidden', then \
	you will do bonus damage, stun the target, and unstealth for a period of time.<br>\
	Getting attacked will also break your stealth."

	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run

	var/cloaked_alpha = 45
	var/cloaked_bonus_damage = 20
	var/cloaked_weaken_amount = 3
	var/cloak_cooldown = 10 SECONDS
	var/last_uncloak = 0


/mob/living/simple_mob/animal/space/mouse_army/stealth/proc/can_cloak()
	if(stat)
		return FALSE
	if(last_uncloak + cloak_cooldown > world.time)
		return FALSE

	return TRUE

/mob/living/simple_mob/animal/space/mouse_army/stealth/uncloak()
	last_uncloak = world.time
	if(!cloaked)
		return
	animate(src, alpha = initial(alpha), time = 1 SECOND)
	cloaked = FALSE

/mob/living/simple_mob/animal/space/mouse_army/stealth/break_cloak()
	uncloak()


/mob/living/simple_mob/animal/space/mouse_army/stealth/is_cloaked()
	return cloaked

/mob/living/simple_mob/animal/space/mouse_army/stealth/handle_special()
	if(!cloaked && can_cloak())
		cloak()

/mob/living/simple_mob/animal/space/mouse_army/stealth/apply_bonus_melee_damage(atom/A, damage_amount)
	if(cloaked)
		return damage_amount + cloaked_bonus_damage
	return ..()

/mob/living/simple_mob/animal/space/mouse_army/stealth/apply_melee_effects(atom/A)
	if(cloaked)
		if(isliving(A))
			var/mob/living/L = A
			L.Weaken(cloaked_weaken_amount)
			to_chat(L, span_danger("\The [src] ambushes you!"))
			playsound(L, 'sound/weapons/spiderlunge.ogg', 75, 1)
	uncloak()
	..()

/mob/living/simple_mob/animal/space/mouse_army/stealth/bullet_act(obj/item/projectile/P)
	. = ..()
	break_cloak()

/mob/living/simple_mob/animal/space/mouse_army/stealth/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	. = ..()
	break_cloak()


// Mouse noises
/datum/say_list/mouse
	speak = list("Squeek!","SQUEEK!","Squeek?")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")





////////////////////
//	Mouse Tanks
////////////////////

// Tiny mecha.
// Designed for ranged attacks.

/datum/category_item/catalogue/technology/mouse_tank
	name = "Whisker Tank"
	desc = "Unofficially dubbed the 'Whisker Tank', this micro mecha is not unfamiliar \
	in several neighboring sectors. Known for its speed and small size, theories \
	on the origin of these devices cover a wide array of probabilities. The general \
	consensus is that these tanks were designed as weapons of sabotage that never saw wide\
	deployment. Since that theoretical time, others may have discovered and modified this \
	technology for their own twisted ends."
	value = CATALOGUER_REWARD_EASY


/mob/living/simple_mob/mechanical/mecha/mouse_tank
	name = "\improper Whisker Tank"
	desc = "A shockingly functional, miniaturized tank. Its inventor is unknown, but widely reviled."
	catalogue_data = list(/datum/category_item/catalogue/technology/mouse_tank)
	icon = 'modular_chomp/icons/mob/animal_ch.dmi'
	icon_state = "whisker"
	wreckage = /obj/structure/loot_pile/mecha/mouse_tank
	faction = "mouse_army"

	maxHealth = 150
	armor = list(
				"melee" = 25,
				"bullet" = 20,
				"laser" = 30,
				"energy" = 15,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100
				)

	projectiletype = /obj/item/projectile/bullet/pistol/medium

	movement_cooldown = 2
	base_attack_cooldown = 8

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/mechanical/mecha/mouse_tank/manned
	pilot_type = /mob/living/simple_mob/animal/space/mouse_army/operative

// Immune to heat damage, resistant to lasers, and it spits fire.
/datum/category_item/catalogue/technology/mouse_tank/livewire
	name = "Livewire Assault Tank"
	desc = "Dubbed the 'Livewire Assault Tank', this pattern of the 'standard' Whisker \
	tank has been condemned by multiple governments and corporations due to the \
	infamous brutality of its armaments. The utilization of this kind of technology would \
	spark a major scandal if its origins could ever be proven."
	value = CATALOGUER_REWARD_EASY


/mob/living/simple_mob/mechanical/mecha/mouse_tank/livewire
	name = "\improper Livewire Assault Tank"
	desc = "A scorched, miniaturized light tank. It is mentioned only in hushed whispers."
	catalogue_data = list(/datum/category_item/catalogue/technology/mouse_tank/livewire)
	icon_state = "livewire"
	wreckage = /obj/structure/loot_pile/mecha/mouse_tank/livewire

	maxHealth = 200
	heat_resist = 1
	armor = list(
				"melee" = 0,
				"bullet" = 20,
				"laser" = 50,
				"energy" = 0,
				"bomb" = 50,
				"bio" = 100,
				"rad" = 100
				)

	projectiletype = /obj/item/projectile/bullet/incendiary/dragonflame

	movement_cooldown = 3
	base_attack_cooldown = 15

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/mechanical/mecha/mouse_tank/livewire/manned
	pilot_type = /mob/living/simple_mob/animal/space/mouse_army/pyro

//Rockets? Rockets.
/datum/category_item/catalogue/technology/mouse_tank/eraticator
	name = "Eraticator Artillery Platform"
	desc = "Rare and fearsome weapons platforms, 'Eraticators', as they have come to be \
	known, are frighteningly powerful long ranged tanks built entirely around exotic \
	gyrojet technology. The raw cost and specialized nature of its design makes it a rare \
	but formidable foe. It is often accompanied by mechanized reinforcements."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/mecha/mouse_tank/eraticator
	name = "\improper Eraticator Artillery Platform"
	desc = "A heavy, miniaturized artillery platform. If you can hear it squeaking, you're too close."
	catalogue_data = list(/datum/category_item/catalogue/technology/mouse_tank/eraticator)
	icon_state = "eraticator"
	wreckage = /obj/structure/loot_pile/mecha/mouse_tank/eraticator

	maxHealth = 300
	heat_resist = 1
	armor = list(
				"melee" = 20,
				"bullet" = 50,
				"laser" = 50,
				"energy" = 20,
				"bomb" = 80,
				"bio" = 100,
				"rad" = 100
				)

	projectiletype = /obj/item/projectile/bullet/gyro

	movement_cooldown = 5
	base_attack_cooldown = 15

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/mechanical/mecha/mouse_tank/eraticator/manned
	pilot_type = /mob/living/simple_mob/animal/space/mouse_army/ammo
