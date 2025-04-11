/obj/effect/calldown_attack
	anchored = TRUE
	density = FALSE
	unacidable = TRUE
	mouse_opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "drop_marker"

/obj/effect/calldown_attack/Initialize(mapload)
	. = ..()
	var/delay = rand(25, 30)
	addtimer(CALLBACK(src, PROC_REF(spawn_object)), delay-7)

/obj/effect/calldown_attack/proc/spawn_object()
	new /obj/effect/falling_effect/calldown_attack(loc)
	QDEL_IN(src, 0.7 SECONDS)

/obj/effect/falling_effect/calldown_attack
	falling_type = /obj/effect/illusionary_fall
	crushing = FALSE


/obj/effect/illusionary_fall
	anchored = TRUE
	density = FALSE
	mouse_opacity = 0
	icon = 'icons/effects/random_stuff_vr.dmi'

/obj/effect/illusionary_fall/Initialize(mapload)
	. = ..()
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
