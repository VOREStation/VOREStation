/mob/living/carbon/human/proc/weightgain()
	if (nutrition > 0 && stat != 2)
		if (nutrition > 450 && weight < 500 && weight_gain)
			weight += metabolism*(0.01*weight_gain)

		else if (nutrition <= 50 && stat != 2 && weight > 70 && weight_loss)
			weight -= metabolism*(0.01*weight_loss) // starvation weight loss
