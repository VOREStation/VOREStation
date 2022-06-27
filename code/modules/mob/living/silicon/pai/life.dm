/mob/living/silicon/pai/Life()

	if(src.cable)
		if(get_dist(src, src.cable) > 1)
			var/turf/T = get_turf_or_move(src.loc)
			for (var/mob/M in viewers(T))
				M.show_message("<font color='red'>The data cable rapidly retracts back into its spool.</font>", 3, "<font color='red'>You hear a click and the sound of wire spooling rapidly.</font>", 2)
			playsound(src, 'sound/machines/click.ogg', 50, 1)

			qdel(src.cable)
			src.cable = null

	if (src.stat == DEAD)
		return

	if(!card.cell || !card.processor || !card.board || !card.capacitor)
		death()

	if(!card.projector && !card.emitter)
		if(loc != card)
			close_up()
			to_chat(src, "<span class ='warning'>ERROR: System malfunction. Service required!</span>")
	if(!card.projector || !card.emitter)
		if(prob(5))
			close_up()
			to_chat(src, "<span class ='warning'>ERROR: System malfunction. Service recommended!</span>")

	handle_regular_hud_updates()
	handle_vision()

	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			to_chat(src, "<font color=green>Communication circuit reinitialized. Speech and messaging functionality restored.</font>")

	handle_statuses()

	if(health <= 0)
		death(null,"fizzles out and clatters to the floor...")
	else if(health < maxHealth && istype(src.loc , /obj/item/device/paicard))
		adjustBruteLoss(-0.5)
		adjustFireLoss(-0.5)

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = 100 - getBruteLoss() - getFireLoss()
