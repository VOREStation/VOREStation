/mob/living/simple_mob/humanoid
	mob_class = MOB_CLASS_HUMANOID

	// Generic humanoid mob tolerances
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15

	health = 150			// Point of human crit, as of commenting
	maxHealth = 150

	organ_names = /decl/mob_organ_names/humanoid

	// Most humans leave a corpse
	var/corpse = null
	pain_emote_1p = list("shout out in pain", "growl in pain", "grunt in pain", "gasp out in pain")
	pain_emote_3p = list("shouts out in pain", "growls in pain", "grunts in pain", "gasps out in pain")
	species_sounds = "Human Male" // Yes, we should allow them to differ based on gender, but if someone's making a custom humanoid later:tm: - set your humanoid's species_sounds to match, or var-edit it after spawn.


/mob/living/simple_mob/humanoid/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return

/decl/mob_organ_names/humanoid
	hit_zones = list("head", "torso", "left leg", "right leg", "left arm", "right arm", "left hand", "right hand", "left foot", "right foot") //Same as real people!
