/obj/belly/proc/put_in_egg(var/atom/movable/M, message=0)
	var/mob/living/carbon/human/O = owner
	var/egg_path = /obj/structure/closet/secure_closet/egg
	var/egg_name = "odd egg"

	if(O.vore_egg_type in tf_vore_egg_types)
		egg_path = tf_vore_egg_types[O.vore_egg_type]
		egg_name = "[O.vore_egg_type] egg"

	var/obj/structure/closet/secure_closet/egg/egg = new egg_path(src)
	M.forceMove(egg)
	egg.name = egg_name
	if(message)
		to_chat(M, "<span class='notice'>You lose sensation of your body, feeling only the warmth around you as you're encased in an egg.</span>")
		to_chat(O, "<span class='notice'>Your body shifts as you encase [M] in an egg.</span>")
