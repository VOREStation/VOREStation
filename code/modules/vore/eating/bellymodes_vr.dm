// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
// Called from /mob/living/Life() proc.
/datum/belly/proc/process_Life()

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
	if(digest_mode == DM_DIGEST || digest_mode == DM_DIGEST_NUMB)

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

			if(digest_mode == DM_DIGEST_NUMB && ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.bloodstr.get_reagent_amount("numbenzyme") < 5)
					H.bloodstr.add_reagent("numbenzyme",10)

			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustBruteLoss(digest_brute)
				M.adjustFireLoss(digest_burn)

				var/offset = (1 + ((M.weight - 137) / 137)) // 130 pounds = .95 140 pounds = 1.02
				var/difference = owner.size_multiplier / M.size_multiplier
				if(offset) // If any different than default weight, multiply the % of offset.
					owner.nutrition += offset*(10/difference) // 9.5 nutrition per digestion tick if they're 130 pounds and it's same size. 10.2 per digestion tick if they're 140 and it's same size. Etc etc.
				else
					owner.nutrition += (10/difference)

		//if(owner.weakgurgles < 1) // An example for possible trait modifier. (Not existing currently)
			//The "Handle leftovers" spaghetti below should be moved here if above gets done.

		// Handle leftovers.
		var/obj/item/T = pick(internal_contents)
		if(istype(T, /obj/item))
			if(istype(T, /obj/item) && _is_digestable(T) && !(T in items_preserved))
				if(T in items_preserved)// Doublecheck just in case.
					return
				for(var/obj/item/SubItem in T)
					if(istype(SubItem,/obj/item/weapon/storage/internal))
						var/obj/item/weapon/storage/internal/SI = SubItem
						for(var/obj/item/SubSubItem in SI)
							SubSubItem.forceMove(internal_contents)
						qdel(SI)
					else
						SubItem.forceMove(internal_contents)
				owner.nutrition += (1 * T.w_class)
				internal_contents -= T
				qdel(T)
			else
				return
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

			if(M.nutrition >= 100) //Drain them until there's no nutrients left. Slowly "absorb" them.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition
			else if(M.nutrition < 100) //When they're finally drained.
				absorb_living(M)

		return



//////////////////////////// DM_UNABSORB ////////////////////////////
	if(digest_mode == DM_UNABSORB)

		for (var/mob/living/M in internal_contents)
			if(M.absorbed && owner.nutrition >= 100)
				M.absorbed = 0
				M << "<span class='notice'>You suddenly feel solid again </span>"
				owner << "<span class='notice'>You feel like a part of you is missing.</span>"
				owner.nutrition -= 100
		return


//////////////////////////// DM_DRAIN ////////////////////////////
	if(digest_mode == DM_DRAIN)

		for (var/mob/living/M in internal_contents)

			if(prob(10)) //Less often than gurgles. People might leave this on forever.
				var/drainsound = pick(digestion_sounds)
				M << sound(drainsound,volume=80)
				owner << sound(drainsound,volume=80)

			if(M.nutrition >= 100) //Drain them until there's no nutrients left.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition
				return
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

///////////////////////////// DM_TRANSFORM_HAIR_AND_EYES /////////////////////////////
	if(digest_mode == DM_TRANSFORM_HAIR_AND_EYES && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = 1 //This used to be RNG, resulting people waiting ages. This way does it instantly.
			if(TFchance == 1)
				if(P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin || P.r_facial != O.r_facial || P.g_facial != O.g_facial || P.b_facial != O.b_facial)
					P.r_hair = O.r_hair
					P.r_facial = O.r_facial
					P.g_hair = O.g_hair
					P.g_facial = O.g_facial
					P.b_hair = O.b_hair
					P.b_facial = O.b_facial
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = O.h_style
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.updateicon()

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5
		return
///////////////////////////// DM_TRANSFORM_MALE /////////////////////////////
	if(digest_mode == DM_TRANSFORM_MALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = 1
			if(TFchance == 1)

				var/TFmodify = rand(1,3)
				if(TFmodify == 1 && P.r_eyes != O.r_eyes || P.g_eyes != O.g_eyes || P.b_eyes != O.b_eyes)
					P.r_eyes = O.r_eyes
					P.g_eyes = O.g_eyes
					P.b_eyes = O.b_eyes
					P << "<span class='notice'>You feel lightheaded and drowsy...</span>"
					owner << "<span class='notice'>You feel warm as you make subtle changes to your captive's body.</span>"
					P.update_eyes()

				if(TFmodify == 2 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin || P.r_facial != O.r_facial || P.g_facial != O.g_facial || P.b_facial != O.b_facial)
					P.r_hair = O.r_hair
					P.r_facial = O.r_facial
					P.g_hair = O.g_hair
					P.g_facial = O.g_facial
					P.b_hair = O.b_hair
					P.b_facial = O.b_facial
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = O.h_style
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.updateicon()

				if(TFmodify == 3 && P.gender != MALE && P.identifying_gender != MALE)
					P.gender = MALE
					P.identifying_gender = MALE
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>You feel strange as you alter your captive's gender.</span>"
					P.update_body()
					P.updateicon()

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5
		return


///////////////////////////// DM_TRANSFORM_FEMALE /////////////////////////////
	if(digest_mode == DM_TRANSFORM_FEMALE && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = 1
			if(TFchance == 1)
				var/TFmodify = rand(1,3)
				if(TFmodify == 1 && P.r_eyes != O.r_eyes || P.g_eyes != O.g_eyes || P.b_eyes != O.b_eyes)
					P.r_eyes = O.r_eyes
					P.g_eyes = O.g_eyes
					P.b_eyes = O.b_eyes
					P << "<span class='notice'>You feel lightheaded and drowsy...</span>"
					owner << "<span class='notice'>You feel warm as your make subtle changes to your captive's body.</span>"
					P.update_eyes()

				if(TFmodify == 2 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin)
					P.r_hair = O.r_hair
					P.g_hair = O.g_hair
					P.b_hair = O.b_hair
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = O.h_style
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>You tingle as your make noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.updateicon()

				if(TFmodify == 3 && P.gender != FEMALE && P.identifying_gender != FEMALE)
					P.f_style = "Shaved"
					P.gender = FEMALE
					P.identifying_gender = FEMALE
					P << "<span class='notice'>Your body feels very strange...</span>"
					owner << "<span class='notice'>You feel strange as you alter your captive's gender.</span>"
					P.update_body()
					P.updateicon()

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5
		return

///////////////////////////// DM_TRANSFORM_KEEP_GENDER  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_KEEP_GENDER && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = 1
			if(TFchance == 1)

				var/TFmodify = rand(1,2)
				if(TFmodify == 1 && P.r_eyes != O.r_eyes || P.g_eyes != O.g_eyes || P.b_eyes != O.b_eyes)
					P.r_eyes = O.r_eyes
					P.g_eyes = O.g_eyes
					P.b_eyes = O.b_eyes
					P << "<span class='notice'>You feel lightheaded and drowsy...</span>"
					owner << "<span class='notice'>You feel warm as you make subtle changes to your captive's body.</span>"
					P.update_eyes()

				if(TFmodify == 2 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin || P.r_facial != O.r_facial || P.g_facial != O.g_facial || P.b_facial != O.b_facial)
					P.r_hair = O.r_hair
					P.r_facial = O.r_facial
					P.g_hair = O.g_hair
					P.g_facial = O.g_facial
					P.b_hair = O.b_hair
					P.b_facial = O.b_facial
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = O.h_style
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.updateicon()

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5
		return

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = 1 //This used to be RNG, resulting people waiting ages. This way does it instantly.
			if(TFchance == 1)
				if(P.species != O.species || P.tail_style != O.tail_style || P.custom_species != O.custom_species || P.ear_style != O.ear_style)
					P.tail_style = O.tail_style
					P.ear_style = O.ear_style
					P.species = O.species
					P.custom_species = O.custom_species
					P.species.create_organs(P) //This is the only way to make it so Unathi TF doesn't result in people dying from organ rejection.
					for(var/obj/item/organ/I in P.organs) //This prevents organ rejection
						I.species = O.species
					for(var/obj/item/organ/I in P.internal_organs) //This prevents organ rejection
						I.species = O.species
					for(var/obj/item/organ/external/Z in P.organs)//Just in case.
						Z.sync_colour_to_human(P)
					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of everything around you... </span>"
					owner << "<span class='notice'>Your body shifts as you make dramatic changes to your captive's body.</span>"
					P.fixblood()
					P.update_body()
					P.update_tail_showing()
					P.updateicon()

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5
		return

///////////////////////////// DM_TRANSFORM_REPLICA /////////////////////////////
	if(digest_mode == DM_TRANSFORM_REPLICA && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue

			var/mob/living/carbon/human/O = owner

			var/TFchance = 1 //This used to be RNG, resulting people waiting ages. This way does it instantly.
			if(TFchance == 1)
				var/TFmodify = rand(1,3)
				if(TFmodify == 1 && P.r_eyes != O.r_eyes || P.g_eyes != O.g_eyes || P.b_eyes != O.b_eyes)
					P.r_eyes = O.r_eyes
					P.g_eyes = O.g_eyes
					P.b_eyes = O.b_eyes
					P << "<span class='notice'>You feel lightheaded and drowsy...</span>"
					owner << "<span class='notice'>You feel warm as you make subtle changes to your captive's body.</span>"
					P.update_eyes()

				if(TFmodify == 2 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin || P.r_facial != O.r_facial || P.g_facial != O.g_facial || P.b_facial != O.b_facial)
					P.r_hair = O.r_hair
					P.r_facial = O.r_facial
					P.g_hair = O.g_hair
					P.g_facial = O.g_facial
					P.b_hair = O.b_hair
					P.b_facial = O.b_facial
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.h_style = O.h_style
					P << "<span class='notice'>Your body tingles all over...</span>"
					owner << "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>"
					P.update_hair()
					P.update_body()
					P.updateicon()

				if(TFmodify == 3 && P.r_hair != O.r_hair || P.g_hair != O.g_hair || P.species != O.species || P.b_hair != O.b_hair || P.r_skin != O.r_skin || P.g_skin != O.g_skin || P.b_skin != O.b_skin || P.tail_style != O.tail_style || P.r_tail != O.r_tail || P.g_tail != O.g_tail || P.b_tail != O.b_tail || P.ear_style != O.ear_style || P.r_facial != O.r_facial || P.g_facial != O.g_facial || P.b_facial != O.b_facial || P.custom_species != O.custom_species)
					P.r_hair = O.r_hair
					P.r_facial = O.r_facial
					P.g_hair = O.g_hair
					P.g_facial = O.g_facial
					P.b_hair = O.b_hair
					P.b_facial = O.b_facial
					P.r_skin = O.r_skin
					P.g_skin = O.g_skin
					P.b_skin = O.b_skin
					P.tail_style = O.tail_style
					P.r_tail = O.r_tail
					P.g_tail = O.g_tail
					P.b_tail = O.b_tail
					P.ear_style = O.ear_style
					P.species = O.species
					P.custom_species = O.custom_species
					P.species.create_organs(P)
					for(var/obj/item/organ/I in P.organs)
						I.species = O.species
					for(var/obj/item/organ/I in P.internal_organs)
						I.species = O.species
					for(var/obj/item/organ/external/Z in P.organs)
						Z.sync_colour_to_human(P)
 					P << "<span class='notice'>You lose sensation of your body, feeling only the warmth of everything around you... </span>"
					owner << "<span class='notice'>Your body shifts as you make dramatic changes to your captive's body.</span>"
					P.fixblood()
					P.update_hair()
					P.update_body()
					P.update_tail_showing()
					P.updateicon()

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5
		return

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue
			if(P.absorbed) //If they're absorbed, don't egg them
				return

			var/mob/living/carbon/human/O = owner

			P.tail_style = O.tail_style
			P.ear_style = O.ear_style
			P.species = O.species
			P.species.create_organs(P)
			for(var/obj/item/organ/I in P.organs)
				I.species = O.species
			for(var/obj/item/organ/I in P.internal_organs)
				I.species = O.species
			for(var/obj/item/organ/external/Z in P.organs)
				Z.sync_colour_to_human(P)
			P << "<span class='notice'>You lose sensation of your body, feeling only the warmth around you as are you as you're encased in an egg. </span>"
			owner << "<span class='notice'>You shift as you make dramatic changes to your captive's body as you encase them in an egg.</span>"
			P.fixblood()
			P.update_hair()
			P.update_body()
			P.update_tail_showing()
			P.update_eyes()
			P.updateicon()
			var/egg_path = /obj/structure/closet/secure_closet/egg //Full credit to Aronai for this version of the egg code.
			var/egg_name = "Odd egg"

			if(O.egg_type in tf_egg_types)
				egg_path = tf_egg_types[O.egg_type]
				egg_name = "[O.egg_type] egg"

			var/obj/structure/closet/secure_closet/egg/egg = new egg_path(get_turf(O))
			P.forceMove(egg)
			egg.name = egg_name
			internal_contents -= P
		return

///////////////////////////// DM_TRANSFORM_KEEP_GENDER_EGG  /////////////////////////////
	if(digest_mode == DM_TRANSFORM_KEEP_GENDER_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue
			if(P.absorbed) //If they're absorbed, don't egg them
				return

			var/mob/living/carbon/human/O = owner

			P.r_hair 			= O.r_hair
			P.r_facial 			= O.r_facial
			P.g_hair 			= O.g_hair
			P.g_facial 			= O.g_facial
			P.b_hair 			= O.b_hair
			P.b_facial 			= O.b_facial
			P.r_skin 			= O.r_skin
			P.g_skin 			= O.g_skin
			P.b_skin 			= O.b_skin
			P.h_style 			= O.h_style
			P.r_eyes 			= O.r_eyes
			P.g_eyes 			= O.g_eyes
			P.b_eyes 			= O.b_eyes
			P << "<span class='notice'>Your body tingles all over...</span>"
			owner << "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>"
			P.update_hair()
			P.update_body()
			P.update_eyes()
			P.updateicon()
			var/egg_path = /obj/structure/closet/secure_closet/egg
			var/egg_name = "Odd egg"

			if(O.egg_type in tf_egg_types)
				egg_path = tf_egg_types[O.egg_type]
				egg_name = "[O.egg_type] egg"

			var/obj/structure/closet/secure_closet/egg/egg = new egg_path(get_turf(O))
			P.forceMove(egg)
			egg.name = egg_name
			internal_contents -= P
		return

///////////////////////////// DM_TRANSFORM_REPLICA_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_REPLICA_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue
			if(P.absorbed) //If they're absorbed, don't egg them
				return

			var/mob/living/carbon/human/O = owner

			P.r_hair 			= O.r_hair
			P.r_facial 			= O.r_facial
			P.g_hair 			= O.g_hair
			P.g_facial 			= O.g_facial
			P.b_hair 			= O.b_hair
			P.b_facial 			= O.b_facial
			P.r_skin 			= O.r_skin
			P.g_skin 			= O.g_skin
			P.b_skin 			= O.b_skin
			P.tail_style 		= O.tail_style
			P.r_tail 			= O.r_tail
			P.g_tail 			= O.g_tail
			P.b_tail 			= O.b_tail
			P.ear_style 		= O.ear_style
			P.h_style 			= O.h_style
			P.species 			= O.species
			P.custom_species 	= O.custom_species
			P.r_eyes 			= O.r_eyes
			P.g_eyes 			= O.g_eyes
			P.b_eyes 			= O.b_eyes

			P.species.create_organs(P)
			for(var/obj/item/organ/I in P.organs)
				I.species = O.species
			for(var/obj/item/organ/I in P.internal_organs)
				I.species = O.species
			for(var/obj/item/organ/external/Z in P.organs)
				Z.sync_colour_to_human(P)
			P << "<span class='notice'>You lose sensation of your body, feeling only the warmth around you as are you as you're encased in an egg. </span>"
			owner << "<span class='notice'>You shift as you make dramatic changes to your captive's body as you encase them in an egg.</span>"
			P.fixblood()
			P.update_hair()
			P.update_body()
			P.update_tail_showing()
			P.update_eyes()
			P.updateicon()
			var/egg_path = /obj/structure/closet/secure_closet/egg
			var/egg_name = "Odd egg"

			if(O.egg_type in tf_egg_types)
				egg_path = tf_egg_types[O.egg_type]
				egg_name = "[O.egg_type] egg"

			var/obj/structure/closet/secure_closet/egg/egg = new egg_path(get_turf(O))
			P.forceMove(egg)
			egg.name = egg_name
			internal_contents -= P
		return

///////////////////////////// DM_TRANSFORM_MALE_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_MALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue
			if(P.absorbed) //If they're absorbed, don't egg them
				return

			var/mob/living/carbon/human/O = owner

			P.r_hair 			= O.r_hair
			P.r_facial 			= O.r_facial
			P.g_hair 			= O.g_hair
			P.g_facial 			= O.g_facial
			P.b_hair 			= O.b_hair
			P.b_facial			= O.b_facial
			P.r_skin 			= O.r_skin
			P.g_skin 			= O.g_skin
			P.b_skin 			= O.b_skin
			P.h_style			= O.h_style
			P.gender 			= MALE
			P.identifying_gender= MALE
			P.r_eyes 			= O.r_eyes
			P.g_eyes 			= O.g_eyes
			P.b_eyes 			= O.b_eyes
			P << "<span class='notice'>Your body feels very strange...</span>"
			owner << "<span class='notice'>You feel strange as you alter your captive's gender.</span>"
			P.update_hair()
			P.update_body()
			P.updateicon()
			var/egg_path = /obj/structure/closet/secure_closet/egg
			var/egg_name = "Odd egg"

			if(O.egg_type in tf_egg_types)
				egg_path = tf_egg_types[O.egg_type]
				egg_name = "[O.egg_type] egg"

			var/obj/structure/closet/secure_closet/egg/egg = new egg_path(get_turf(O))
			P.forceMove(egg)
			egg.name = egg_name
			internal_contents -= P
		return

///////////////////////////// DM_TRANSFORM_FEMALE_EGG /////////////////////////////
	if(digest_mode == DM_TRANSFORM_FEMALE_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue
			if(P.absorbed) //If they're absorbed, don't egg them
				return

			var/mob/living/carbon/human/O = owner

			P.r_hair 			= O.r_hair
			P.r_facial 			= O.r_facial
			P.g_hair 			= O.g_hair
			P.g_facial 			= O.g_facial
			P.b_hair 			= O.b_hair
			P.b_facial 			= O.b_facial
			P.r_skin 			= O.r_skin
			P.g_skin 			= O.g_skin
			P.b_skin 			= O.b_skin
			P.h_style 			= O.h_style
			P.gender 			= FEMALE
			P.identifying_gender= FEMALE
			P.r_eyes 			= O.r_eyes
			P.g_eyes 			= O.g_eyes
			P.b_eyes 			= O.b_eyes
			owner << "<span class='notice'>You feel strange as you alter your captive's gender.</span>"
			P << "<span class='notice'>Your body feels very strange...</span>"
			P.update_hair()
			P.update_body()
			P.updateicon()
			var/egg_path = /obj/structure/closet/secure_closet/egg
			var/egg_name = "Odd egg"

			if(O.egg_type in tf_egg_types)
				egg_path = tf_egg_types[O.egg_type]
				egg_name = "[O.egg_type] egg"

			var/obj/structure/closet/secure_closet/egg/egg = new egg_path(get_turf(O))
			P.forceMove(egg)
			egg.name = egg_name
			internal_contents -= P
		return


///////////////////////////// DM_EGG /////////////////////////////
	if(digest_mode == DM_EGG && ishuman(owner))
		for (var/mob/living/carbon/human/P in internal_contents)
			if(P.stat)
				continue
			if(P.absorbed) //If they're absorbed, don't egg them
				return

			var/mob/living/carbon/human/O = owner
			P << "<span class='notice'>You lose sensation of your body, feeling only the warmth around you as you're encased in an egg. </span>"
			owner << "<span class='notice'>Your body shifts as you encase [P] in an egg.</span>"
			var/egg_path = /obj/structure/closet/secure_closet/egg
			var/egg_name = "Odd egg"

			if(O.egg_type in tf_egg_types)
				egg_path = tf_egg_types[O.egg_type]
				egg_name = "[O.egg_type] egg"

			var/obj/structure/closet/secure_closet/egg/egg = new egg_path(get_turf(O))
			P.forceMove(egg)
			egg.name = egg_name
			internal_contents -= P
