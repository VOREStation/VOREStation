//An AI-controlled 'companion' for the Technomancer.  It's tough, strong, and can also use spells.
/mob/living/simple_animal/technomancer_golem
	name = "G.O.L.E.M."
	desc = "A rather unusual looking synthetic."
	icon = 'icons/mob/mob.dmi'
	icon_state = "technomancer_golem"
	health = 250
	maxHealth = 250
	stop_automated_movement = 1
	wander = 0
	response_help   = "pets"
	response_disarm = "pushes away"
	response_harm   = "punches"
	harm_intent_damage = 3

	heat_damage_per_tick = 0
	cold_damage_per_tick = 0

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 0
	speed = 0

	melee_damage_lower = 30 // It has a built in esword.
	melee_damage_upper = 30
	attacktext = "slashed"
	attack_sound = null
	friendly = "hugs"
	resistance = 0

	var/obj/item/weapon/technomancer_core/golem/core = null
	var/obj/item/weapon/spell/active_spell = null // Shield and ranged spells
	var/mob/living/master = null

	var/list/known_spells = list(
		"reflect"			= /obj/item/weapon/spell/reflect,
		"shield"			= /obj/item/weapon/spell/shield,
		"dispel"			= /obj/item/weapon/spell/dispel,
		"mend life"			= /obj/item/weapon/spell/modifier/mend_life,
		"mend synthetic"	= /obj/item/weapon/spell/modifier/mend_synthetic,
		"repel missiles"	= /obj/item/weapon/spell/modifier/repel_missiles,
		"corona"			= /obj/item/weapon/spell/modifier/corona,
		"beam"				= /obj/item/weapon/spell/projectile/beam,
		"chain lightning"	= /obj/item/weapon/spell/projectile/chain_lightning,
		"force missile"		= /obj/item/weapon/spell/projectile/force_missile,
		"ionic bolt"		= /obj/item/weapon/spell/projectile/ionic_bolt,
		"lightning"			= /obj/item/weapon/spell/projectile/lightning
		)

/mob/living/simple_animal/technomancer_golem/New()
	..()
	core = new(src)
	update_icon()

/mob/living/simple_animal/technomancer_golem/Destroy()
	qdel(core)
	return ..()

/mob/living/simple_animal/technomancer_golem/update_icon()
	overlays.Cut()
	overlays.Add(image(icon, src, "golem_sword"))
	overlays.Add(image(icon, src, "golem_spell"))

/mob/living/simple_animal/technomancer_golem/isSynthetic()
	return TRUE // So Mend Synthetic will work on them.

/mob/living/simple_animal/technomancer_golem/place_spell_in_hand(var/path)
	if(!path || !ispath(path))
		return 0

	if(active_spell)
		qdel(active_spell) // Get rid of our old spell.

	var/obj/item/weapon/spell/S = new path(src)
	active_spell = S

/mob/living/simple_animal/technomancer_golem/verb/test_giving_spells()
	var/choice = input(usr, "What spell?", "Give spell") as null|anything in known_spells
	if(choice)
		place_spell_in_hand(known_spells[choice])

// Used to cast spells.
/mob/living/simple_animal/technomancer_golem/RangedAttack(var/atom/A, var/params)
	if(active_spell)
		if(active_spell.cast_methods & CAST_RANGED)
			active_spell.on_ranged_cast(A, src)

/mob/living/simple_animal/technomancer_golem/UnarmedAttack(var/atom/A, var/proximity)
	if(proximity)
		if(active_spell)
			if(active_spell.cast_methods & CAST_MELEE)
				active_spell.on_melee_cast(A, src)
			else if(active_spell.cast_methods & CAST_RANGED)
				active_spell.on_ranged_cast(A, src)
			var/effective_cooldown = round(active_spell.cooldown * core.cooldown_modifier, 5)
			src.setClickCooldown(effective_cooldown)
		else
			..()

/mob/living/simple_animal/technomancer_golem/get_technomancer_core()
	return core

/mob/living/simple_animal/technomancer_golem/proc/bind_to_mob(mob/user)
	if(!user || master)
		return
	master = user
	name = "[master]'s [initial(name)]"

/mob/living/simple_animal/technomancer_golem/examine(mob/user)
	..()
	if(user.mind && technomancers.is_antagonist(user.mind))
		user << "Your pride and joy.  It's a very special synthetic robot, capable of using functions similar to you, and you built it \
		yourself!  It'll always stand by your side, ready to help you out.  You have no idea what GOLEM stands for, however..."

/mob/living/simple_animal/technomancer_golem/Life()
	..()
	handle_ai()

// This is where the real spaghetti begins.
/mob/living/simple_animal/technomancer_golem/proc/handle_ai()
	if(!master)
		return
	if(get_dist(src, master) > 6 || src.z != master.z)
		targeted_blink(master)

	// Give our allies buffs and heals.
	for(var/mob/living/L in view(src))
		if(L in friends)
			support_friend(L)
			return

/mob/living/simple_animal/technomancer_golem/proc/support_friend(var/mob/living/L)
	if(L.getBruteLoss() >= 10 || L.getFireLoss() >= 10)
		if(L.isSynthetic() && !L.has_modifier_of_type(/datum/modifier/technomancer/mend_synthetic))
			place_spell_in_hand(known_spells["mend synthetic"])
			targeted_blink(L)
			UnarmedAttack(L, 1)
		else if(!L.has_modifier_of_type(/datum/modifier/technomancer/mend_life))
			place_spell_in_hand(known_spells["mend life"])
			targeted_blink(L)
			UnarmedAttack(L, 1)
		return


	// Give them repel missiles if they lack it.
	if(!L.has_modifier_of_type(/datum/modifier/technomancer/repel_missiles))
		place_spell_in_hand(known_spells["repel missiles"])
		RangedAttack(L)
		return

/mob/living/simple_animal/technomancer_golem/proc/targeted_blink(var/atom/target)
	var/datum/effect/effect/system/spark_spread/spark_system = new()
	spark_system.set_up(5, 0, get_turf(src))
	spark_system.start()
	src.visible_message("<span class='notice'>\The [src] vanishes!</span>")
	src.forceMove(get_turf(target))
	return