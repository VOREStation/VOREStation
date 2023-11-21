/obj/effect/calldown_attack
	anchored = TRUE
	density = FALSE
	unacidable = TRUE
	mouse_opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "drop_marker"

/obj/effect/calldown_attack/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/calldown_attack/LateInitialize()
	var/delay = rand(25, 30)
	spawn(delay-7)
		new /obj/effect/falling_effect/calldown_attack(src.loc)
	spawn(delay)
		qdel(src)


/obj/effect/falling_effect/calldown_attack
	falling_type = /obj/effect/illusionary_fall
	crushing = FALSE


/obj/effect/illusionary_fall
	anchored = TRUE
	density = FALSE
	mouse_opacity = 0
	icon = 'icons/effects/random_stuff_vr.dmi'

/obj/effect/illusionary_fall/Initialize(mapload)
	.=..()
	icon_state = "[rand(1,33)]"

/obj/effect/illusionary_fall/end_fall(var/crushing = FALSE)
	for(var/mob/living/L in loc)
		var/target_zone = ran_zone()
		var/blocked = L.run_armor_check(target_zone, "melee")
		var/soaked = L.get_armor_soak(target_zone, "melee")

		if(!L.apply_damage(35, BRUTE, target_zone, blocked, soaked))
			break
	playsound(src, 'sound/effects/clang2.ogg', 50, 1)
	qdel(src)