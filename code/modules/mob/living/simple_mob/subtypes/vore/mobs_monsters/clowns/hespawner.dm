// These are used to spawn a specific mob when triggered, with the mob controlled by a player pulled from the ghost pool, hense its name.
/obj/structure/ghost_pod/manual/clegg
	name = "Clown Egg?"
	desc = "Why does this have to be what this is?"
	icon = 'icons/mob/mobs_monsters/giantclowns.dmi'
	icon_state = "c_egg"
	icon_state_opened = "c_egg_opened"	// Icon to switch to when 'used'.
	ghost_query_type = /datum/ghost_query/hellclown

/datum/ghost_query/hellclown
	role_name = "egg clown"
	question = "THE HONKMOTHER REQUESTS SUBJECTS. REPORT TO THE ELEMENTAL TO JOIN THE HONKENING."
	cutoff_number = 1

/obj/structure/ghost_pod/manual/clegg/trigger()
	..(span_warning("\The [usr] places their hand on the egg!"), "is attempting to make a mistake!")

/obj/structure/ghost_pod/manual/clegg/create_occupant(var/mob/M)
	lightning_strike(get_turf(src), cosmetic = TRUE)
	var/list/choices = list(/mob/living/simple_mob/clowns/normal, /mob/living/simple_mob/clowns/honkling, /mob/living/simple_mob/clowns/mayor, /mob/living/simple_mob/clowns/blob, /mob/living/simple_mob/clowns/mutant, /mob/living/simple_mob/clowns/clowns, /mob/living/simple_mob/clowns/flesh, /mob/living/simple_mob/clowns/scary, /mob/living/simple_mob/clowns/chlown, /mob/living/simple_mob/clowns/destroyer, /mob/living/simple_mob/clowns/giggles, /mob/living/simple_mob/clowns/longface, /mob/living/simple_mob/clowns/hulk, /mob/living/simple_mob/clowns/thin, /mob/living/simple_mob/clowns/wide, /mob/living/simple_mob/clowns/perm, /mob/living/simple_mob/clowns/thicc, /mob/living/simple_mob/clowns/punished, /mob/living/simple_mob/clowns/sentinel, /mob/living/simple_mob/clowns/tunnelclown, /mob/living/simple_mob/clowns/cluwne, /mob/living/simple_mob/clowns/honkmunculus)
	var/chosen_clown = tgui_input_list(M, "Redspace clowns like themes, what's yours?", "Theme Choice", choices)
	density = FALSE
	var/mob/living/simple_mob/R = new chosen_clown(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(R)
	to_chat(M, span_notice("You are a <b>Clown!</b>! HONK!"))
	R.ckey = M.ckey
	visible_message(span_warning("With a bright flash of light, \the [src] disappears, and in its place you see a... Clown?"))
	log_and_message_admins("successfully touched \a [src] and summoned a mistake!")
	..()
