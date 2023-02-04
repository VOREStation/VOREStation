// Mecha simple_mobs are essentially fake mechs. Generally tough and scary to fight.
// By default, they're automatically piloted by some kind of drone AI. They can be set to be "piloted" instead with a var.
// Tries to be as similar to the real deal as possible.

/mob/living/simple_mob/mechanical/mecha
	name = "mecha"
	desc = "A big stompy mech!"
	icon = 'icons/mecha/mecha.dmi'

	faction = "syndicate"
	movement_cooldown = 5
	movement_sound = "mechstep" // This gets fed into playsound(), which can also take strings as a 'group' of sound files.
	turn_sound = 'sound/mecha/mechturn.ogg'
	maxHealth = 300
	mob_size = MOB_LARGE
	damage_threshold = 5 //Anything that's 5 or less damage will not do damage.

	organ_names = /decl/mob_organ_names/mecha

	armor = list(
				"melee"		= 20,
				"bullet"	= 10,
				"laser"		= 0,
				"energy"	= 0,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	response_help = "taps on"
	response_disarm = "knocks on"
	response_harm = "uselessly hits"
	harm_intent_damage = 0

	ai_holder_type = /datum/ai_holder/simple_mob/melee
	say_list_type = /datum/say_list/malf_drone

	var/datum/effect/effect/system/spark_spread/sparks
	var/wreckage = /obj/effect/decal/mecha_wreckage/gygax/dark
	var/pilot_type = null // Set to spawn a pilot when destroyed. Setting this also makes the mecha vulnerable to things that affect sentient minds.
	var/deflect_chance = 10 // Chance to outright stop an attack, just like a normal exosuit.
	var/has_repair_droid = FALSE // If true, heals 2 damage every tick and gets a repair droid overlay.


/mob/living/simple_mob/mechanical/mecha/Initialize()
	sparks = new (src)
	sparks.set_up(3, 1, src)
	sparks.attach(src)

	if(!pilot_type)
		name = "autonomous [initial(name)]"
		desc = "[initial(desc)] It appears to be piloted by a drone intelligence."
	else
		say_list_type = /datum/say_list/merc

	if(has_repair_droid)
		update_icon()

	return ..()

/mob/living/simple_mob/mechanical/mecha/Destroy()
	qdel_null(sparks)
	return ..()

/mob/living/simple_mob/mechanical/mecha/death()
	..(0,"explodes!") // Do everything else first.

	// Make the exploding more convincing with an actual explosion and some sparks.
	sparks.start()
	explosion(get_turf(src), 0, 0, 1, 3)

	// 'Eject' our pilot, if one exists.
	if(pilot_type)
		var/mob/living/L = new pilot_type(loc)
		L.faction = src.faction

	new wreckage(loc) // Leave some wreckage.

	qdel(src) // Then delete us since we don't actually have a body.

/mob/living/simple_mob/mechanical/mecha/handle_special()
	if(has_repair_droid)
		adjustBruteLoss(-2)
		adjustFireLoss(-2)
		adjustToxLoss(-2)
		adjustOxyLoss(-2)
		adjustCloneLoss(-2)
	..()

/mob/living/simple_mob/mechanical/mecha/update_icon()
	..() // Cuts everything else, so do that first.
	if(has_repair_droid)
		add_overlay(image(icon = 'icons/mecha/mecha_equipment.dmi', icon_state = "repair_droid"))

/mob/living/simple_mob/mechanical/mecha/bullet_act()
	. = ..()
	sparks.start()

/mob/living/simple_mob/mechanical/mecha/speech_bubble_appearance()
	return pilot_type ? "" : ..()

// Piloted mechs are controlled by (presumably) something humanoid so they are vulnerable to certain things.
/mob/living/simple_mob/mechanical/mecha/is_sentient()
	return pilot_type ? TRUE : FALSE

/*
// Real mechs can't turn and run at the same time. This tries to simulate that.
// Commented out because the AI can't handle it sadly.
/mob/living/simple_mob/mechanical/mecha/SelfMove(turf/n, direct)
	if(direct != dir)
		set_dir(direct)
		return FALSE // We didn't actually move, and returning FALSE means the mob can try to actually move almost immediately and not have to wait the full movement cooldown.
	return ..()
*/

/mob/living/simple_mob/mechanical/mecha/bullet_act(obj/item/projectile/P)
	if(prob(deflect_chance))
		visible_message(span("warning", "\The [P] is deflected by \the [src]'s armor!"))
		deflect_sprite()
		return 0
	return ..()

/mob/living/simple_mob/mechanical/mecha/proc/deflect_sprite()
	var/image/deflect_image = image('icons/effects/effects.dmi', "deflect_static")
	add_overlay(deflect_image)
	sleep(1 SECOND)
	cut_overlay(deflect_image)
	qdel(deflect_image)
//	flick_overlay_view(deflect_image, src, duration = 1 SECOND, gc_after = TRUE)

/mob/living/simple_mob/mechanical/mecha/attackby(obj/item/I, mob/user)
	if(prob(deflect_chance))
		visible_message(span("warning", "\The [user]'s [I] bounces off \the [src]'s armor!"))
		deflect_sprite()
		user.setClickCooldown(user.get_attack_speed(I))
		return
	..()

/mob/living/simple_mob/mechanical/mecha/ex_act(severity)
	if(prob(deflect_chance))
		severity++ // This somewhat misleadingly makes it less severe.
		deflect_sprite()
	..(severity)

/decl/mob_organ_names/mecha
	hit_zones = list("central chassis", "control module", "hydraulics", "left arm", "right arm", "left leg", "right leg", "sensor suite", "radiator", "power supply", "left equipment mount", "right equipment mount")
