/mob/living/proc/toggle_active_cloaking() // Borrowed from Rogue Star, thanks guys!
	set category = "Abilities.General"
	set name = "Toggle Active Cloaking"

	if(invisibility == INVISIBILITY_OBSERVER)
		invisibility = initial(invisibility)
		to_chat(src, span_notice("You are now visible."))
		alpha = max(alpha + 100, 255)
	else
		invisibility = INVISIBILITY_OBSERVER
		to_chat(src, span_notice("You are now invisible."))
		alpha = max(alpha - 100, 0)

	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(5, 0, src)
	sparks.attach(loc)
	sparks.start()
	visible_message(span_warning("Electrical sparks manifest around \the [src] as they suddenly appear!"))
	qdel(sparks)
