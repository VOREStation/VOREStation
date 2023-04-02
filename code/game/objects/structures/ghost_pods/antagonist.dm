//Antagonist ghost pods for potentially self replicating creatures, xenomorphs as one example. These should not naturally spawn on their own.

/obj/structure/ghost_pod/automatic/xenomorph_egg
	name = "xenomorph egg"
	desc = "A disgusting egg dripping with clear ooze, the existence of this is a omen for what is to come."
	description_info = "This contains a growing xenomorph larva, which may wake up at any moment. The larva will be another player, once activated."
	icon = 'icons/mob/alien.dmi'
	icon_state = "egg"
	icon_state_opened = "egg_opened" //Can be placed on map with used = 1 for POI decorations
	var/health = 50 //So they can be destroyed by the crew
	density = FALSE
	ghost_query_type = /datum/ghost_query/xenomorph_larva
	delay_to_try_again = 1 MINUTES //10 minutes for egg to grow, 5 minutes for larva to mature

/obj/structure/ghost_pod/automatic/xenomorph_egg/create_occupant(var/mob/M)
	var/mob/living/carbon/alien/larva/R = new(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(R)
	// Description for new larva, so they understand what to expect.
	to_chat(M, "<span class='notice'>You are a <b>Xenomorph Larva</b>, freshly slithered out of their egg to serve the hive.</span>")
	to_chat(M, "<span class='notice'><b>Be sure to carefully listen to your queen, as xenomorph egg spawns may act different to loner xenomorph spawns.</b></span>")
	to_chat(M, "<span class='warning'><b>Remember, you are technically a antagonist. Be sure to learn the context of your existence via IC or ahelp to prevent headaches, and follow the orders of your queen to the letter.</b></span>")
	to_chat(M, "<span class='notice'> Your life for the hive!</span>")
	R.ckey = M.ckey
	visible_message("<span class='warning'>\the [src] peels open, and a fresh larva slithers out!</span>")
	..()

/obj/structure/ghost_pod/automatic/xenomorph_egg/proc/healthcheck()
	if(health <=0)
		visible_message("<span class='warning'>\the [src] splatters everywhere as it cracks open!</span>")
		playsound(src, 'sound/effects/slime_squish.ogg', 50, 1)
		qdel(src)
	return

/obj/structure/ghost_pod/automatic/xenomorph_egg/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(user.get_attack_speed(W))
	switch(W.damtype)
		if("fire")
			health -= W.force * 1.25 //It really doesn't like fire
		if("brute")
			health -= W.force * 0.75 //Bit hard to cut
	playsound(src, 'sound/effects/attackblob.ogg', 50, 1)
	healthcheck()
	..()
	return

/obj/structure/ghost_pod/automatic/xenomorph_egg/bullet_act(var/obj/item/projectile/Proj)
	switch(damtype)
		if("fire")
			health -= Proj.damage * 1.5 //It burns!
		if("brute")
			health -= Proj.damage //It hurts a bit more then a sharp stick
	healthcheck()
	..()
	return
