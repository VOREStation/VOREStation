//VOREStation Edit - Let's make it so that pAIs don't just always cease to be when they die! It would be cool if we could fix them.
/mob/living/silicon/pai/death(gibbed,deathmessage="fizzles out and clatters to the floor...")
	if(paiDA && card)
		var/area/t = get_area(src)
		var/obj/item/radio/headset/a = new /obj/item/radio/headset/heads/captain(null)
		if(istype(t, /area/syndicate_station) || istype(t, /area/syndicate_mothership) || istype(t, /area/shuttle/syndicate_elite) )
			//give the syndies a bit of stealth
			a.autosay("PAI \"[src]\" has died in Space!", "PAI [src]'s Death Alarm")
		else
			a.autosay("PAI \"[src]\" has died in [t.name]!", "PAI [src]'s Death Alarm")
		paiDA = FALSE // no repeats we died already
		qdel(a)
//	set_respawn_timer()
	release_vore_contents()
	close_up(TRUE)
	if(card)
		card.cut_overlays()
		card.setEmotion(16)
		card.damage_random_component()

		if(gibbed)
			qdel(card)
			..(gibbed)
		else
			card.add_overlay("pai-dead")
			..(gibbed,deathmessage)
