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
	..("<span class='warning'>\The [usr] places their hand on the egg!</span>", "is attempting to make a mistake!")

/obj/structure/ghost_pod/manual/clegg/create_occupant(var/mob/M)
	lightning_strike(get_turf(src), cosmetic = TRUE)
	var/list/choices = list(/mob/living/simple_mob/mobs_monsters/clowns/normal, /mob/living/simple_mob/mobs_monsters/clowns/honkling, /mob/living/simple_mob/mobs_monsters/clowns/mayor, /mob/living/simple_mob/mobs_monsters/clowns/blob, /mob/living/simple_mob/mobs_monsters/clowns/mutant, /mob/living/simple_mob/mobs_monsters/clowns/clowns, /mob/living/simple_mob/mobs_monsters/clowns/flesh, /mob/living/simple_mob/mobs_monsters/clowns/scary, /mob/living/simple_mob/mobs_monsters/clowns/chlown, /mob/living/simple_mob/mobs_monsters/clowns/destroyer, /mob/living/simple_mob/mobs_monsters/clowns/giggles, /mob/living/simple_mob/mobs_monsters/clowns/longface, /mob/living/simple_mob/mobs_monsters/clowns/hulk, /mob/living/simple_mob/mobs_monsters/clowns/thin, /mob/living/simple_mob/mobs_monsters/clowns/wide, /mob/living/simple_mob/mobs_monsters/clowns/perm, /mob/living/simple_mob/mobs_monsters/clowns/thicc, /mob/living/simple_mob/mobs_monsters/clowns/punished, /mob/living/simple_mob/mobs_monsters/clowns/sentinel, /mob/living/simple_mob/mobs_monsters/clowns/tunnelclown, /mob/living/simple_mob/mobs_monsters/clowns/cluwne, /mob/living/simple_mob/mobs_monsters/clowns/honkmunculus)
	var/chosen_clown = tgui_input_list(M, "Redspace clowns like themes, what's yours?", "Theme Choice", choices)
	density = FALSE
	var/mob/living/simple_mob/R = new chosen_clown(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(R)
	to_chat(M, "<span class='notice'>You are a <b>Clown!</b>! HONK!</span>")
	R.ckey = M.ckey
	visible_message("<span class='warning'>With a bright flash of light, \the [src] disappears, and in its place you see a... Clown?</span>")
	log_and_message_admins("successfully touched \a [src] and summoned a mistake!")
	..()