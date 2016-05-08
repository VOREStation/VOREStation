// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
// Called from /mob/living/Life() proc.
/datum/belly/proc/process_Life()

///////////////////////////// TIMER /////////////////////////////
	if(!internal_contents.len || air_master.current_cycle%3 != 1)
		return

/////////////////////////// Auto-Emotes ///////////////////////////
	if((digest_mode in emote_lists) && !emotePend)
		emotePend = 1

		spawn(emoteTime)
			var/list/EL = emote_lists[digest_mode]
			for(var/mob/living/M in internal_contents)
				M << "<span class='notice'>[pick(EL)]</span>"
			src.emotePend = 0

//////////////////////// Absorbed Handling ////////////////////////
	for(var/mob/living/M in internal_contents)
		if(M.absorbed)
			M.Weaken(5)

///////////////////////////// DM_HOLD /////////////////////////////
	if(digest_mode == DM_HOLD)
		return //Pretty boring, huh

//////////////////////////// DM_DIGEST ////////////////////////////
	if(digest_mode == DM_DIGEST)

		if(prob(50)) //Was SO OFTEN. AAAA.
			var/churnsound = pick(digestion_sounds)
			for(var/mob/hearer in range(1,owner))
				hearer << sound(churnsound,volume=80)

		for (var/mob/living/M in internal_contents)
			//Pref protection!
			if (!M.digestable || M.absorbed)
				continue

			//Person just died in guts!
			if(M.stat == DEAD)
				var/digest_alert_owner = pick(digest_messages_owner)
				var/digest_alert_prey = pick(digest_messages_prey)

				//Replace placeholder vars
				digest_alert_owner = replacetext(digest_alert_owner,"%pred",owner)
				digest_alert_owner = replacetext(digest_alert_owner,"%prey",M)
				digest_alert_owner = replacetext(digest_alert_owner,"%belly",lowertext(name))

				digest_alert_prey = replacetext(digest_alert_prey,"%pred",owner)
				digest_alert_prey = replacetext(digest_alert_prey,"%prey",M)
				digest_alert_prey = replacetext(digest_alert_prey,"%belly",lowertext(name))

				//Send messages
				owner << "<span class='notice'>" + digest_alert_owner + "</span>"
				M << "<span class='notice'>" + digest_alert_prey + "</span>"

				owner.nutrition += 20 // so eating dead mobs gives you *something*.
				var/deathsound = pick(death_sounds)
				for(var/mob/hearer in range(1,owner))
					hearer << deathsound
				digestion_death(M)
				owner.update_icons()
				continue

			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustBruteLoss(2)
				M.adjustFireLoss(3)

			/* POLARISTODO - Depends on weight and scale
				var/offset
				if (M.weight > 137)
					offset = 1 + ((M.weight - 137) / 137)
				if (M.weight < 137)
					offset = (137 - M.weight) / 137
				var/difference = owner.playerscale / M.playerscale
				if(offset) // If any different than default weight, multiply the % of offset.
					owner.nutrition += offset*(10/difference)
				else
					owner.nutrition += (10/difference)
			*/

		return


//////////////////////////// DM_ABSORB ////////////////////////////
	if(digest_mode == DM_ABSORB)

		for (var/mob/living/M in internal_contents)

			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				var/absorbsound = pick(digestion_sounds)
				M << sound(absorbsound,volume=80)
				owner << sound(absorbsound,volume=80)

			if(M.absorbed)
				continue

			if(M.nutrition >= 4) //Drain them until there's no nutrients left. Slowly "absorb" them.
				M.nutrition -= 3
				owner.nutrition += 3
			else if(M.nutrition < 4) //When they're finally drained.
				absorb_living(M)

		return

///////////////////////////// DM_HEAL /////////////////////////////
	if(digest_mode == DM_HEAL)
		if(prob(50)) //Wet heals!
			var/healsound = pick(digestion_sounds)
			for(var/mob/hearer in range(1,owner))
				hearer << sound(healsound,volume=80)

		for (var/mob/living/M in internal_contents)
			if(M.stat != DEAD)
				if(owner.nutrition > 90 && (M.health < M.maxHealth))
					M.adjustBruteLoss(-5)
					M.adjustFireLoss(-5)
					owner.nutrition -= 2
					if(M.nutrition <= 400)
						M.nutrition += 1
		return

/* POLARISTODO - Depends on Taurs, and egg objects.

///////////////////////////// DM_TRANSFORM_MALE /////////////////////////////
	if(digest_mode == DM_TRANSFORM_MALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = prob(10)
			if(TFchance == 1)

				var/TFmodify = rand(1,3)
				if(TFmodify == 1 && P.r_eyes != O.r_eyes || P.g_eyes != O.g_eyes || P.b_eyes != O.b_eyes)
					P.r_eyes = O.r_eyes
					P.g_eyes = O.g_eyes
					P.b_eyes = O.b_eyes
					P << "<span class='notice'>You feel lightheaded and drowsy...</span>"
					owner << "<span class='notice'>Your belly feels warm as your womb makes subtle changes to your captive's body.</span>"
					P.update_body()

				if(TFmodify == 2 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin)
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()

				if(TFmodify == 3 && P.gender != MALE)
					P.gender = MALE
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_body()

			if(O.nutrition > 0)
				O.nutrition -= 2
			if(P.nutrition < 400)
				P.nutrition += 1
		return


///////////////////////////// DM_TRANSFORM_FEMALE /////////////////////////////
	if(digest_mode == DM_TRANSFORM_FEMALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = prob(10)
			if(TFchance == 1)
				var/TFmodify = rand(1,3)
				if(TFmodify == 1 && P.r_eyes != O.r_eyes || P.g_eyes != O.g_eyes || P.b_eyes != O.b_eyes)
					P.r_eyes = O.r_eyes
					P.g_eyes = O.g_eyes
					P.b_eyes = O.b_eyes
					P << "<span class='notice'>You feel lightheaded and drowsy...</span>"
					owner << "<span class='notice'>Your belly feels warm as your womb makes subtle changes to your captive's body.</span>"
					P.update_body()

				if(TFmodify == 2 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin)
					P.r_hair = O.r_hair
					P.g_hair = O.g_hair
					P.b_hair = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()

				if(TFmodify == 3 && P.gender != FEMALE)
					P.f_style = "Shaved"
					P.gender = FEMALE
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_body()

			if(O.nutrition > 0)
				O.nutrition -= 2
			if(P.nutrition < 400)
				P.nutrition += 1
		return

///////////////////////////// DM_TRANSFORM_KEEP_GENDER  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_KEEP_GENDER && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = prob(10)
			if(TFchance == 1)

				var/TFmodify = rand(1,2)
				if(TFmodify == 1 && P.r_eyes != O.r_eyes || P.g_eyes != O.g_eyes || P.b_eyes != O.b_eyes)
					P.r_eyes = O.r_eyes
					P.g_eyes = O.g_eyes
					P.b_eyes = O.b_eyes
					P << "<span class='notice'>You feel lightheaded and drowsy...</span>"
					owner << "<span class='notice'>Your belly feels warm as your womb makes subtle changes to your captive's body.</span>"
					P.update_body()

				if(TFmodify == 2 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin)
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()

			if(O.nutrition > 0)
				O.nutrition -= 2
			if(P.nutrition < 400)
				P.nutrition += 1
		return

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = prob(10)
			if(TFchance == 1)
				var/TFmodify = rand(1,3)
				if(TFmodify == 1 && P.r_eyes != O.r_eyes || P.g_eyes != O.g_eyes || P.b_eyes != O.b_eyes)
					P.r_eyes = O.r_eyes
					P.g_eyes = O.g_eyes
					P.b_eyes = O.b_eyes
					P << "<span class='notice'>You feel lightheaded and drowsy...</span>"
					owner << "<span class='notice'>Your belly feels warm as your womb makes subtle changes to your captive's body.</span>"
					P.update_body()

				if(TFmodify == 2 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin)
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					//Omitted clause : P.race_icon != O.race_icon
					//No idea how to work with that one, species system got changed a lot
					//Also this makes it similar to the previous one until fixed

				if(TFmodify == 3 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin || P.taur != O.taur || P.r_taur != O.r_taur || P.g_taur != O.g_taur || P.b_taur != O.b_taur)
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb... </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()

			if(O.nutrition > 0)
				O.nutrition -= 2
			if(P.nutrition < 400)
				P.nutrition += 1
		return


///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.species.name == "Unathi")
				var/obj/structure/closet/secure_closet/egg/unathi/J = new /obj/structure/closet/secure_closet/egg/unathi(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Tajara")
				var/obj/structure/closet/secure_closet/egg/tajaran/J = new /obj/structure/closet/secure_closet/egg/tajaran(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Skrell")
				var/obj/structure/closet/secure_closet/egg/skrell/J = new /obj/structure/closet/secure_closet/egg/skrell(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Sergal")
				var/obj/structure/closet/secure_closet/egg/sergal/J = new /obj/structure/closet/secure_closet/egg/sergal(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."

				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Akula")
				var/obj/structure/closet/secure_closet/egg/shark/J = new /obj/structure/closet/secure_closet/egg/shark(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Nevrean")
				var/obj/structure/closet/secure_closet/egg/nevrean/J = new /obj/structure/closet/secure_closet/egg/nevrean(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Human")
				var/obj/structure/closet/secure_closet/egg/human/J = new /obj/structure/closet/secure_closet/egg/human(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."

				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Slime Person")
				var/obj/structure/closet/secure_closet/egg/slime/J = new /obj/structure/closet/secure_closet/egg/slime(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.taur = O.taur
					P.r_taur = O.r_taur
					P.g_taur = O.g_taur
					P.b_taur = O.b_taur
					P.h_style = "Bedhead"
					P.species = O.species
					P.custom_species = O.custom_species
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of the womb as you're encased in an egg. </span>"
					owner << "<span class='notice'>Your belly shifts as your womb makes dramatic changes to your captive's body as you encase them in an egg.</span>"
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.loc = J
					J.name = "[defined_species] egg"
		return

///////////////////////////// DM_TRANSFORM_KEEP_GENDER_EGG  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_KEEP_GENDER_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.species.name == "Unathi")
				var/obj/structure/closet/secure_closet/egg/unathi/J = new /obj/structure/closet/secure_closet/egg/unathi(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."

				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Tajara")
				var/obj/structure/closet/secure_closet/egg/tajaran/J = new /obj/structure/closet/secure_closet/egg/tajaran(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Skrell")
				var/obj/structure/closet/secure_closet/egg/skrell/J = new /obj/structure/closet/secure_closet/egg/skrell(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Sergal")
				var/obj/structure/closet/secure_closet/egg/sergal/J = new /obj/structure/closet/secure_closet/egg/sergal(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Akula")
				var/obj/structure/closet/secure_closet/egg/shark/J = new /obj/structure/closet/secure_closet/egg/shark(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Nevrean")
				var/obj/structure/closet/secure_closet/egg/nevrean/J = new /obj/structure/closet/secure_closet/egg/nevrean(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Human")
				var/obj/structure/closet/secure_closet/egg/human/J = new /obj/structure/closet/secure_closet/egg/human(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"

			if(O.species.name == "Slime Person")
				var/obj/structure/closet/secure_closet/egg/slime/J = new /obj/structure/closet/secure_closet/egg/slime(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>Your belly tingles as your womb makes noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.loc = J
					J.name = "[defined_species] egg"
		return

///////////////////////////// DM_TRANSFORM_MALE_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_MALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.species.name == "Unathi")
				var/obj/structure/closet/secure_closet/egg/unathi/J = new /obj/structure/closet/secure_closet/egg/unathi(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Tajara")
				var/obj/structure/closet/secure_closet/egg/tajaran/J = new /obj/structure/closet/secure_closet/egg/tajaran(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Skrell")
				var/obj/structure/closet/secure_closet/egg/skrell/J = new /obj/structure/closet/secure_closet/egg/skrell(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Sergal")
				var/obj/structure/closet/secure_closet/egg/sergal/J = new /obj/structure/closet/secure_closet/egg/sergal(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Akula")
				var/obj/structure/closet/secure_closet/egg/shark/J = new /obj/structure/closet/secure_closet/egg/shark(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Nevrean")
				var/obj/structure/closet/secure_closet/egg/nevrean/J = new /obj/structure/closet/secure_closet/egg/nevrean(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Human")
				var/obj/structure/closet/secure_closet/egg/human/J = new /obj/structure/closet/secure_closet/egg/human(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Slime Person")
				var/obj/structure/closet/secure_closet/egg/slime/J = new /obj/structure/closet/secure_closet/egg/slime(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = MALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
		return

///////////////////////////// DM_TRANSFORM_FEMALE_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_FEMALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			if(O.species.name == "Unathi")
				var/obj/structure/closet/secure_closet/egg/unathi/J = new /obj/structure/closet/secure_closet/egg/unathi(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Tajara")
				var/obj/structure/closet/secure_closet/egg/tajaran/J = new /obj/structure/closet/secure_closet/egg/tajaran(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Skrell")
				var/obj/structure/closet/secure_closet/egg/skrell/J = new /obj/structure/closet/secure_closet/egg/skrell(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Sergal")
				var/obj/structure/closet/secure_closet/egg/sergal/J = new /obj/structure/closet/secure_closet/egg/sergal(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Akula")
				var/obj/structure/closet/secure_closet/egg/shark/J = new /obj/structure/closet/secure_closet/egg/shark(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Nevrean")
				var/obj/structure/closet/secure_closet/egg/nevrean/J = new /obj/structure/closet/secure_closet/egg/nevrean(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Human")
				var/obj/structure/closet/secure_closet/egg/human/J = new /obj/structure/closet/secure_closet/egg/human(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()

			if(O.species.name == "Slime Person")
				var/obj/structure/closet/secure_closet/egg/slime/J = new /obj/structure/closet/secure_closet/egg/slime(O.loc)
				if (O.custom_species)
					var/defined_species = O.custom_species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					J.desc = "This egg has a very unique look to it."
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
				else
					var/defined_species = O.species
					P.r_hair = O.r_hair
					P.r_facial = O.r_hair
					P.g_hair = O.g_hair
					P.g_facial = O.g_hair
					P.b_hair = O.b_hair
					P.b_facial = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = "Bedhead"
					P.gender = FEMALE
					P.loc = J
					J.name = "[defined_species] egg"
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>Your belly feels strange as your womb alters your captive's gender.</span>"
					P.update_hair()
					P.update_body()
		return

*/