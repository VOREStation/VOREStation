/datum/disease2/effect/mlem
	name = "Mlemington's Syndrome"
	stage = 2
	chance_maxm = 25
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("[pick("Mlem.","MLEM!","Mlem?")]")