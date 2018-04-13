/mob/living/simple_animal/construct
	name = "Construct"
	real_name = "Construct"
	var/construct_type = "shade"
	desc = ""
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")

	ui_icons = 'icons/mob/screen1_construct.dmi'
	has_hands = 1
	hand_form = "stone manipulators"

	response_help  = "thinks better of touching"
	response_disarm = "flailed at"
	response_harm   = "punched"

	intelligence_level = SA_HUMANOID // Player controlled.

	hovering = TRUE
	softfall = TRUE //Beings made of Hellmarble and powered by the tears of the damned are not concerned with mortal things such as 'gravity'.
	parachuting = TRUE

	icon_dead = "shade_dead"
	var/do_glow = 1

	speed = -1
	a_intent = I_HURT
	stop_automated_movement = 1

	status_flags = CANPUSH

	universal_speak = 0
	universal_understand = 1

	attack_sound = 'sound/weapons/spiderlunge.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	minbodytemp = 0
	show_stat_health = 1

	faction = "cult"
	supernatural = 1

	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7

	var/nullblock = 0

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	var/list/construct_spells = list()

	can_be_antagged = TRUE

	taser_kill = 0 // no

	shock_resistance = 0.9 //Electricity isn't very effective on stone, especially that from hell.

	armor = list(
				"melee" = 10,
				"bullet" = 10,
				"laser" = 10,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_animal/construct/place_spell_in_hand(var/path)
	if(!path || !ispath(path))
		return 0

	//var/obj/item/weapon/spell/S = new path(src)
	var/obj/item/weapon/spell/construct/S = new path(src)

	//No hands needed for innate casts.
	if(S.cast_methods & CAST_INNATE)
		if(S.run_checks())
			S.on_innate_cast(src)

	if(l_hand && r_hand) //Make sure our hands aren't full.
		if(istype(r_hand, /obj/item/weapon/spell)) //If they are full, perhaps we can still be useful.
			var/obj/item/weapon/spell/r_spell = r_hand
			if(r_spell.aspect == ASPECT_CHROMATIC) //Check if we can combine the new spell with one in our hands.
				r_spell.on_combine_cast(S, src)
		else if(istype(l_hand, /obj/item/weapon/spell))
			var/obj/item/weapon/spell/l_spell = l_hand
			if(l_spell.aspect == ASPECT_CHROMATIC) //Check the other hand too.
				l_spell.on_combine_cast(S, src)
		else //Welp
			to_chat(src, "<span class='warning'>You require a free manipulator to use this power.</span>")
			return 0

	if(S.run_checks())
		put_in_hands(S)
		return 1
	else
		qdel(S)
		return 0

/mob/living/simple_animal/construct/cultify()
	return

/mob/living/simple_animal/construct/New()
	..()
	name = text("[initial(name)] ([rand(1, 1000)])")
	real_name = name
	add_language("Cult")
	add_language("Occult")
	for(var/spell in construct_spells)
		src.add_spell(new spell, "const_spell_ready")
	updateicon()

/mob/living/simple_animal/construct/updateicon()
	overlays.Cut()
	..()
	if(do_glow)
		add_glow()

/mob/living/simple_animal/construct/update_icon()
	..()
	if(do_glow)
		add_glow()

/mob/living/simple_animal/construct/death()
	new /obj/item/weapon/ectoplasm (src.loc)
	..(null,"collapses in a shattered heap.")
	ghostize()
	qdel(src)

/mob/living/simple_animal/construct/attack_generic(var/mob/user)
	if(istype(user, /mob/living/simple_animal/construct/builder))
		var/mob/living/simple_animal/construct/builder/B = user
		if(health < getMaxHealth())
			var/repair_lower_bound = B.melee_damage_lower * -1
			var/repair_upper_bound = B.melee_damage_upper * -1
			adjustBruteLoss(rand(repair_lower_bound, repair_upper_bound))
			adjustFireLoss(rand(repair_lower_bound, repair_upper_bound))
			user.visible_message("<span class='notice'>\The [user] mends some of \the [src]'s wounds.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] is undamaged.</span>")
		return
	return ..()

/mob/living/simple_animal/construct/examine(mob/user)
	..(user)
	var/msg = "<span cass='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n"
	if (src.health < src.getMaxHealth())
		msg += "<span class='warning'>"
		if (src.health >= src.getMaxHealth()/2)
			msg += "It looks slightly dented.\n"
		else
			msg += "<B>It looks severely dented!</B>\n"
		msg += "</span>"
	msg += "*---------*</span>"

	user << msg

/mob/living/simple_animal/construct/Process_Spacemove()
	return 1 //Constructs levitate, can fall from a shuttle with no harm, and are piloted by either damned spirits or some otherworldly entity. It's not hard to believe.

/////////////////Juggernaut///////////////



/mob/living/simple_animal/construct/armoured
	name = "Juggernaut"
	real_name = "Juggernaut"
	construct_type = "juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead"
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 300
	health = 300
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 40
	attack_armor_pen = 60 //Being punched by a living, floating statue.
	attacktext = list("smashed their armoured gauntlet into")
	friendly = list("pats")
	mob_size = MOB_HUGE
	speed = 2 //Not super fast, but it might catch up to someone in armor who got punched once or twice.
	environment_smash = 2
	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	resistance = 10
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser,
							/spell/targeted/fortify,
							/spell/targeted/construct_advanced/slam
							)

	armor = list(
				"melee" = 70,
				"bullet" = 30,
				"laser" = 30,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_animal/construct/armoured/Life()
	weakened = 0
	..()

/mob/living/simple_animal/construct/armoured/bullet_act(var/obj/item/projectile/P)
//	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam)) //If it's going to be slow, it's probably going to need every reflect it can get.
	var/reflectchance = 80 - round(P.damage/3)
	if(prob(reflectchance))
		var/damage_mod = rand(2,4)
		var/projectile_dam_type = P.damage_type
		var/incoming_damage = (round(P.damage / damage_mod) - (round((P.damage / damage_mod) * 0.3)))
		var/armorcheck = run_armor_check(null, P.check_armour)
		var/soakedcheck = get_armor_soak(null, P.check_armour)
		if(!(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam)))
			visible_message("<span class='danger'>The [P.name] bounces off of [src]'s shell!</span>", \
						"<span class='userdanger'>The [P.name] bounces off of [src]'s shell!</span>")
			new /obj/item/weapon/material/shard/shrapnel(src.loc)
			if(!(P.damage_type == BRUTE || P.damage_type == BURN))
				projectile_dam_type = BRUTE
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to brute for physical projectiles, though severely decreased.
			apply_damage(incoming_damage, projectile_dam_type, null, armorcheck, soakedcheck, is_sharp(P), has_edge(P), P)
			return -1 //Doesn't reflect non-beams or non-energy projectiles. They just smack and drop with little to no effect.
		else
			visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>", \
						"<span class='userdanger'>The [P.name] gets reflected by [src]'s shell!</span>")
			damage_mod = rand(3,5)
			incoming_damage = (round(P.damage / damage_mod) - (round((P.damage / damage_mod) * 0.3)))
			if(!(P.damage_type == BRUTE || P.damage_type == BURN))
				projectile_dam_type = BURN
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to burn for energy-type projectiles, though severely decreased.
			apply_damage(incoming_damage, P.damage_type, null, armorcheck, soakedcheck, is_sharp(P), has_edge(P), P)

		// Find a turf near or on the original location to bounce to
		if(P.starting)
			var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, src)
			P.reflected = 1

		return -1 // complete projectile permutation

	return (..(P))



////////////////////////Wraith/////////////////////////////////////////////



/mob/living/simple_animal/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	construct_type = "wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	maxHealth = 200
	health = 200
	melee_damage_lower = 25
	melee_damage_upper = 30
	attack_armor_pen = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed")
	friendly = list("pinches")
	speed = -1
	environment_smash = 1
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/ethereal_jaunt/shift,
							/spell/targeted/ambush_mode
							)

/mob/living/simple_animal/construct/wraith/DoPunch(var/atom/A)
	. = ..()
	if(. && isliving(A))
		var/mob/living/L = A
		L.add_modifier(/datum/modifier/deep_wounds, 30 SECONDS)

/////////////////////////////Artificer/////////////////////////



/mob/living/simple_animal/construct/builder
	name = "Artificer"
	real_name = "Artificer"
	construct_type = "artificer"
	desc = "A bulbous construct dedicated to building and maintaining temples to their otherworldly lords."
	icon = 'icons/mob/mob.dmi'
	icon_state = "artificer"
	icon_living = "artificer"
	maxHealth = 150
	health = 150
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 15 //It's not the strongest of the bunch, but that doesn't mean it can't hurt you.
	melee_damage_upper = 20
	attacktext = list("rammed")
	speed = 0
	environment_smash = 2
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/aoe_turf/conjure/construct/lesser,
							/spell/aoe_turf/conjure/wall,
							/spell/aoe_turf/conjure/floor,
							/spell/aoe_turf/conjure/soulstone,
							/spell/aoe_turf/conjure/pylon,
							/spell/aoe_turf/conjure/door,
							/spell/aoe_turf/conjure/grille,
							/spell/targeted/occult_repair_aura,
							/spell/targeted/construct_advanced/mend_acolyte
							)


/////////////////////////////Behemoth/////////////////////////
/*
 * The Behemoth. Admin-allowance only, still try to keep it in some guideline of 'Balanced', even if it means Security has to be fully geared to be so.
 */

/mob/living/simple_animal/construct/behemoth
	name = "Behemoth"
	real_name = "Behemoth"
	construct_type = "juggernaut"
	desc = "The pinnacle of occult technology, Behemoths are nothing shy of both an Immovable Object, and Unstoppable Force."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 750
	health = 750
	speak_emote = list("rumbles")
	response_harm   = "harmlessly punched"
	harm_intent_damage = 0
	melee_damage_lower = 50
	melee_damage_upper = 50
	attacktext = list("brutally crushed")
	friendly = list("pokes") //Anything nice the Behemoth would do would still Kill the Human. Leave it at poke.
	speed = 5
	environment_smash = 2
	attack_sound = 'sound/weapons/heavysmash.ogg'
	resistance = 10
	icon_scale = 2
	var/energy = 0
	var/max_energy = 1000
	armor = list(
				"melee" = 60,
				"bullet" = 60,
				"laser" = 60,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser,
							/spell/targeted/fortify,
							/spell/targeted/construct_advanced/slam
							)

/mob/living/simple_animal/construct/behemoth/bullet_act(var/obj/item/projectile/P)
	var/reflectchance = 80 - round(P.damage/3)
	if(prob(reflectchance))
		visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>", \
						"<span class='userdanger'>The [P.name] gets reflected by [src]'s shell!</span>")

		// Find a turf near or on the original location to bounce to
		if(P.starting)
			var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, src)
			P.reflected = 1

		return -1 // complete projectile permutation

	return (..(P))

////////////////////////Harvester////////////////////////////////
/*
 * Master of Spells and Ranged Abilities. Not as fragile as the Wraith, but nowhere near as maneuverable and deadly in melee.
 */

/mob/living/simple_animal/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	construct_type = "harvester"
	desc = "A tendril-laden construct piloted by a chained mind."
	icon = 'icons/mob/mob.dmi'
	icon_state = "harvester"
	icon_living = "harvester"
	maxHealth = 150
	health = 150
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_sharp = 1
	attacktext = list("violently stabbed")
	friendly = list("caresses")
	speed = 0
	environment_smash = 1
	attack_sound = 'sound/weapons/pierce.ogg'

	armor = list(
				"melee" = 10,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 20,
				"bomb" = 20,
				"bio" = 100,
				"rad" = 100)

	construct_spells = list(
			/spell/aoe_turf/knock/harvester,
			/spell/targeted/construct_advanced/inversion_beam,
			/spell/targeted/construct_advanced/agonizing_sphere,
			/spell/rune_write
		)

////////////////Glow//////////////////
/mob/living/simple_animal/construct/proc/add_glow()
	var/image/eye_glow = image(icon,"glow-[icon_state]")
	eye_glow.plane = PLANE_LIGHTING_ABOVE
	overlays += eye_glow
	set_light(2, -2, l_color = "#FFFFFF")

/mob/living/simple_animal/construct/proc/remove_glow()
	overlays.Cut()

////////////////HUD//////////////////////

/mob/living/simple_animal/construct/Life()
	. = ..()
	if(.)
		if(fire)
			if(fire_alert)							fire.icon_state = "fire1"
			else									fire.icon_state = "fire0"
		if(pullin)
			if(pulling)								pullin.icon_state = "pull1"
			else									pullin.icon_state = "pull0"

		if(purged)
			if(purge > 0)							purged.icon_state = "purge1"
			else									purged.icon_state = "purge0"

		silence_spells(purge)

/mob/living/simple_animal/construct/updatehealth() //Special icons.
	health = getMaxHealth() - getToxLoss() - getFireLoss() - getBruteLoss()

	//Alive, becoming dead
	if((stat < DEAD) && (health <= 0))
		death()

	//Overhealth
	if(health > getMaxHealth())
		health = getMaxHealth()

	//Update our hud if we have one
	if(healths)
		if(stat != DEAD)
			var/heal_per = (health / getMaxHealth()) * 100
			switch(heal_per)
				if(100 to INFINITY)
					healths.icon_state = "[construct_type]_health0"
				if(80 to 100)
					healths.icon_state = "[construct_type]_health1"
				if(60 to 80)
					healths.icon_state = "[construct_type]_health2"
				if(40 to 60)
					healths.icon_state = "[construct_type]_health3"
				if(20 to 40)
					healths.icon_state = "[construct_type]_health4"
				if(0 to 20)
					healths.icon_state = "[construct_type]_health5"
				else
					healths.icon_state = "[construct_type]_health6"
		else
			healths.icon_state = "[construct_type]_health7"