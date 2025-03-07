// The GOLEM is a spell-flinging synthetic.

/mob/living/simple_mob/mechanical/technomancer_golem
	name = "unknown synthetic"
	desc = "A rather unusual looking synthetic."
	icon = 'icons/mob/mob.dmi'
	icon_state = "golem"
	health = 300
	maxHealth = 300

	faction = FACTION_GOLEM

	response_help   = "pets"
	response_disarm = "pushes away"
	response_harm   = "punches"
	harm_intent_damage = 3
	friendly = "hugs"

	organ_names = /decl/mob_organ_names/golem

	melee_damage_lower = 30 // It has a built in esword.
	melee_damage_upper = 30
	attack_armor_pen = 20
	attack_sound = 'sound/weapons/blade1.ogg'
	attacktext = list("slashed")
	melee_attack_delay = 0.5 SECONDS // Even has custom attack animations.
	ranged_attack_delay = 0.5 SECONDS
	special_attack_delay = 1 SECOND

	special_attack_min_range = 0
	special_attack_max_range = 7

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	var/obj/item/technomancer_core/golem/core = null
	var/obj/item/spell/active_spell = null // Shield and ranged spells
	var/mob/living/master = null
	var/casting = FALSE // Used to ensure the correct animation is played. Testing if a spell exists won't always work as some spells delete themselves upon use.

	var/list/known_spells = list(
		"beam"				= /obj/item/spell/projectile/beam,
		"chain lightning"	= /obj/item/spell/projectile/chain_lightning,
		"force missile"		= /obj/item/spell/projectile/force_missile,
		"ionic bolt"		= /obj/item/spell/projectile/ionic_bolt,
		"lightning"			= /obj/item/spell/projectile/lightning,
		"blink"				= /obj/item/spell/blink,
		"dispel"			= /obj/item/spell/dispel,
		"oxygenate"			= /obj/item/spell/oxygenate,
		"mend life"			= /obj/item/spell/modifier/mend_life,
		"mend synthetic"	= /obj/item/spell/modifier/mend_synthetic,
		"mend organs"		= /obj/item/spell/mend_organs,
		"purify"			= /obj/item/spell/modifier/purify,
		"resurrect"			= /obj/item/spell/resurrect,
		"passwall"			= /obj/item/spell/passwall,
		"repel missiles"	= /obj/item/spell/modifier/repel_missiles,
		"corona"			= /obj/item/spell/modifier/corona,
		"haste"				= /obj/item/spell/modifier/haste
		)

/mob/living/simple_mob/mechanical/technomancer_golem/Initialize(mapload)
	core = new(src)
	return ..()

/mob/living/simple_mob/mechanical/technomancer_golem/Destroy()
	qdel(core)
	return ..()

/mob/living/simple_mob/mechanical/technomancer_golem/unref_spell()
	active_spell = null
	return ..()

/mob/living/simple_mob/mechanical/technomancer_golem/death()
	..()
	visible_message("\The [src] disintegrates!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/simple_mob/mechanical/technomancer_golem/place_spell_in_hand(var/path)
	if(!path || !ispath(path))
		return FALSE
	if(active_spell)
		qdel(active_spell)

	active_spell = new path(src)

/mob/living/simple_mob/mechanical/technomancer_golem/verb/test_giving_spells()
	var/choice = tgui_input_list(usr, "What spell?", "Give spell", known_spells)
	if(choice)
		place_spell_in_hand(known_spells[choice])
	else
		qdel(active_spell)

/mob/living/simple_mob/mechanical/technomancer_golem/get_technomancer_core()
	return core

/mob/living/simple_mob/mechanical/technomancer_golem/can_special_attack(atom/A)
	if(active_spell) // Don't bother checking everything else if no spell is ready.
		return ..()
	return FALSE

/mob/living/simple_mob/mechanical/technomancer_golem/should_special_attack(atom/A)
	return instability < 50 // Don't kill ourselves by casting everything.


/mob/living/simple_mob/mechanical/technomancer_golem/do_special_attack(atom/A)
	var/proximity = Adjacent(A)
	if(active_spell)
		if(proximity && active_spell.cast_methods & CAST_MELEE) // Use melee method if available and close enough.
			return active_spell.on_melee_cast(A, src)
		else if(active_spell.cast_methods & CAST_RANGED) // Otherwise use ranged if possible. Will also work for point-blank range.
			return active_spell.on_ranged_cast(A, src)
	return ..()

/mob/living/simple_mob/mechanical/technomancer_golem/melee_pre_animation(atom/A)
	if(active_spell && active_spell.cast_methods & CAST_MELEE|CAST_RANGED) // If they're trying to melee-cast a spell, use the special animation instead.
		special_pre_animation(A)
		return

	flick("golem_pre_melee", src) // To force the animation to restart.
	icon_living = "golem_pre_melee" // The animation will hold after this point until melee_post_animation() gets called.
	icon_state = "golem_pre_melee"
	setClickCooldown(2)

/mob/living/simple_mob/mechanical/technomancer_golem/melee_post_animation(atom/A)
	if(casting) // Some spells delete themselves when used, so we use a different variable set earlier instead.
		special_post_animation(A)
		return

	flick("golem_post_melee", src)
	icon_living = "golem"
	icon_state = "golem"
	setClickCooldown(6)

/mob/living/simple_mob/mechanical/technomancer_golem/ranged_pre_animation(atom/A)
	flick("golem_pre_ranged", src)
	icon_living = "golem_pre_ranged"
	icon_state = "golem_pre_ranged"
	setClickCooldown(5)

/mob/living/simple_mob/mechanical/technomancer_golem/ranged_post_animation(atom/A)
	flick("golem_post_ranged", src)
	icon_living = "golem"
	icon_state = "golem"
	setClickCooldown(5)

/mob/living/simple_mob/mechanical/technomancer_golem/special_pre_animation(atom/A)
	casting = TRUE
	ranged_pre_animation(A) // Both have the same animation.

/mob/living/simple_mob/mechanical/technomancer_golem/special_post_animation(atom/A)
	casting = FALSE
	ranged_post_animation(A)

/decl/mob_organ_names/golem
	hit_zones = list("helmet", "cuirass", "left tasset", "right tasset", "left gauntlet", "right gauntlet", "weapon")
