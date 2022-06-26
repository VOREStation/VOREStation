//VOREStation Edit - Let's make it so that pAIs don't just always cease to be when they die! It would be cool if we could fix them.
/mob/living/silicon/pai/death(gibbed,deathmessage="fizzles out and clatters to the floor...")
	release_vore_contents()
	close_up(TRUE)
	if(card)
		card.cut_overlays()
		card.setEmotion(16)

		if(gibbed)
			qdel(card)
			..(gibbed)
		else
			card.add_overlay("pai-dead")
			..(gibbed,deathmessage)
