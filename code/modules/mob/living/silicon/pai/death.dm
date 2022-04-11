/mob/living/silicon/pai/death(gibbed)
	release_vore_contents()
	if(card)
		card.removePersonality()
		//if(gibbed) //VOREStation Edit Start. This prevents pAIs from joining back into their card after the card's killed
		src.loc = get_turf(card)
		qdel(card)
		/*else
			close_up()
			qdel(card)*/ //VOREStation Edit End.
	if(mind)
		qdel(mind)
	..(gibbed)
	ghostize()
	qdel(src)
