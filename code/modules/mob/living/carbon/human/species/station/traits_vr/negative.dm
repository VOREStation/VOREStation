/datum/trait/negative
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/negative/speed_slow
	name = "Slowdown"
	desc = "Allows you to move slower on average than baseline."
	cost = -2
	var_changes = list("slowdown" = 0.5)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_SHADEKIN_CREW, SPECIES_DIONA, SPECIES_UNATHI) //These are already this slow.
	custom_only = FALSE

/datum/trait/negative/speed_slow_plus
	name = "Slowdown, Major"
	desc = "Allows you to move MUCH slower on average than baseline."
	cost = -3
	var_changes = list("slowdown" = 1.0)
	custom_only = FALSE
	banned_species = list(SPECIES_DIONA) //Diona are even slower than this

/datum/trait/negative/weakling
	name = "Weakling"
	desc = "Causes heavy equipment to slow you down more when carried."
	cost = -1
	var_changes = list("item_slowdown_mod" = 1.5)
	custom_only = FALSE
	banned_species = list(SPECIES_SHADEKIN_CREW, SPECIES_TESHARI) //These are already this weak.

/datum/trait/negative/weakling_plus
	name = "Weakling, Major"
	desc = "Allows you to carry heavy equipment with much more slowdown."
	cost = -2
	var_changes = list("item_slowdown_mod" = 2.0)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI) //These are already this weak.
	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Everything feels so much heavier"
	primitive_expression_messages=list("hunches forwards")

/datum/trait/negative/endurance_low
	name = "Low Endurance"
	desc = "Reduces your maximum total hitpoints to 75."
	cost = -2
	var_changes = list("total_health" = 75)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI, SPECIES_SHADEKIN_CREW) //These are already this weak.

/datum/trait/negative/endurance_low/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/negative/endurance_very_low
	name = "Low Endurance, Major"
	desc = "Reduces your maximum total hitpoints to 50."
	cost = -3 //Teshari HP. This makes the person a lot more suseptable to getting stunned, killed, etc.
	var_changes = list("total_health" = 50)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI) //These are already this weak.

/datum/trait/negative/endurance_very_low/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/negative/minor_brute_weak
	name = "Brute Weakness, Minor"
	desc = "Increases damage from brute damage sources by 15%"
	cost = -1
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.15)
	banned_species = list(SPECIES_TESHARI, SPECIES_TAJARAN, SPECIES_ZADDAT, SPECIES_SHADEKIN_CREW) //These are already this weak.

/datum/trait/negative/brute_weak
	name = "Brute Weakness"
	desc = "Increases damage from brute damage sources by 25%"
	cost = -2
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.25)
	banned_species = list(SPECIES_TESHARI, SPECIES_SHADEKIN_CREW) //These are already this weak.

/datum/trait/negative/brute_weak_plus
	name = "Brute Weakness, Major"
	desc = "Increases damage from brute damage sources by 50%"
	cost = -3
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.5)

/datum/trait/negative/minor_burn_weak
	name = "Burn Weakness, Minor"
	desc = "Increases damage from burn damage sources by 15%"
	cost = -1
	var_changes = list("burn_mod" = 1.15)

/datum/trait/negative/burn_weak
	name = "Burn Weakness"
	desc = "Increases damage from burn damage sources by 25%"
	cost = -2
	var_changes = list("burn_mod" = 1.25)

/datum/trait/negative/burn_weak_plus
	name = "Burn Weakness, Major"
	desc = "Increases damage from burn damage sources by 50%"
	cost = -3
	var_changes = list("burn_mod" = 1.5)

/datum/trait/negative/conductive
	name = "Conductive"
	desc = "Increases your susceptibility to electric shocks by 50%"
	cost = -1
	var_changes = list("siemens_coefficient" = 1.5) //This makes you a lot weaker to tasers.

/datum/trait/negative/conductive_plus
	name = "Conductive, Major"
	desc = "Increases your susceptibility to electric shocks by 100%"
	cost = -1
	var_changes = list("siemens_coefficient" = 2.0) //This makes you extremely weak to tasers.
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You recieve a sudden shock of static."
	primitive_expression_messages=list("shudders as their hair stands on end")

/datum/trait/negative/haemophilia
	name = "Haemophilia - Organics only"
	desc = "When you bleed, you bleed a LOT."
	cost = -2
	var_changes = list("bloodloss_rate" = 2)
	can_take = ORGANICS
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER

/datum/trait/negative/hollow
	name = "Hollow Bones/Aluminum Alloy"
	desc = "Your bones and robot limbs are much easier to break."
	cost = -2 //I feel like this should be higher, but let's see where it goes

/datum/trait/negative/hollow/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	for(var/obj/item/organ/external/O in H.organs)
		O.min_broken_damage *= 0.5
		O.min_bruised_damage *= 0.5

/datum/trait/negative/lightweight
	name = "Lightweight"
	desc = "Your light weight and poor balance make you very susceptible to unhelpful bumping. Think of it like a bowling ball versus a pin."
	cost = -2
	var_changes = list("lightweight" = 1)
	custom_only = FALSE

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel off balance..."
	primitive_expression_messages=list("staggers")

/datum/trait/negative/neural_hypersensitivity
	name = "Neural Hypersensitivity"
	desc = "Your nerves are particularly sensitive to physical changes, leading to experiencing twice the intensity of pain and pleasure alike. Makes all pain effects twice as strong, and occur at half as much damage."
	cost = -1
	var_changes = list("trauma_mod" = 2)
	can_take = ORGANICS
	custom_only = FALSE

/datum/trait/negative/breathes
	cost = -2
	can_take = ORGANICS

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like breathing is more difficult..."
	primitive_expression_messages=list("gasps")

/datum/trait/negative/breathes/phoron
	name = "Phoron Breather"
	desc = "You breathe phoron instead of oxygen (which is poisonous to you), much like a Vox."
	var_changes = list("breath_type" = GAS_PHORON, "poison_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/vox)

/datum/trait/negative/breathes/nitrogen
	name = "Nitrogen Breather"
	desc = "You breathe nitrogen instead of oxygen (which is poisonous to you). Incidentally, phoron isn't poisonous to breathe to you."
	var_changes = list("breath_type" = GAS_N2, "poison_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/nitrogen_breather)


/datum/trait/negative/monolingual
	name = "Monolingual"
	desc = "You are not good at learning languages."
	cost = -1
	var_changes = list("num_alternate_languages" = 0)
	var_changes_pref = list("extra_languages" = -3)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

/datum/trait/negative/dark_blind
	name = "Nyctalopia"
	desc = "You cannot see in dark at all."
	cost = -1
	var_changes = list("darksight" = 0)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="The dark seems darker than usual."
	primitive_expression_messages=list("looks towards the light")

/datum/trait/negative/bad_shooter
	name = "Bad Shot"
	desc = "You are terrible at aiming."
	cost = -1
	var_changes = list("gun_accuracy_mod" = -35)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your hands quiver"
	primitive_expression_messages=list("hands quiver uncontrollably")

/datum/trait/negative/bad_swimmer
	name = "Bad Swimmer"
	desc = "You can't swim very well, all water slows you down a lot and you drown in deep water. You also swim up and down 25% slower."
	cost = -1
	custom_only = FALSE
	var_changes = list("bad_swimmer" = 1, "water_movement" = 4, "swim_mult" = 1.25)
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER
	excludes = list(/datum/trait/positive/good_swimmer)

/datum/trait/negative/less_blood
	name = "Low Blood Volume"
	desc = "You have 33.3% less blood volume compared to most species, making you more prone to blood loss issues."
	cost = -3
	var_changes = list("blood_volume" = 375)
	excludes = list(/datum/trait/negative/less_blood_extreme)
	can_take = ORGANICS

/datum/trait/negative/less_blood_extreme
	name = "Low Blood Volume, Extreme"
	desc = "You have 60% less blood volume compared to most species, making you much more prone to blood loss issues."
	cost = -5
	var_changes = list("blood_volume" = 224)
	excludes = list(/datum/trait/negative/less_blood)
	can_take = ORGANICS

/datum/trait/negative/extreme_slowdown
	name = "Slowdown, Extreme"
	desc = "You move EXTREMELY slower than baseline"
	cost = -8
	var_changes = list("slowdown" = 4.0)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like moving is more difficult..."
	primitive_expression_messages=list("moves sluggishly")

/datum/trait/negative/low_blood_sugar
	name = "Low Blood Sugar"
	desc = "If you let your nutrition get too low, you will start to experience adverse affects including hallucinations, unconsciousness, and weakness"
	cost = -1
	special_env = TRUE

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel drowsy..."
	primitive_expression_messages=list("looks drowsy")

/datum/trait/negative/low_blood_sugar/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.nutrition > 200 || isbelly(H.loc))
		return
	if((H.nutrition < 200) && prob(5))
		if(H.nutrition > 100)
			to_chat(H,span_warning("You start to feel noticeably weak as your stomach rumbles, begging for more food. Maybe you should eat something to keep your blood sugar up"))
		else if(H.nutrition > 50)
			to_chat(H,span_warning("You begin to feel rather weak, and your stomach rumbles loudly. You feel lightheaded and it's getting harder to think. You really need to eat something."))
		else if(H.nutrition > 25)
			to_chat(H,span_danger("You're feeling very weak and lightheaded, and your stomach continously rumbles at you. You really need to eat something!"))
		else
			to_chat(H,span_critical("You're feeling extremely weak and lightheaded. You feel as though you might pass out any moment and your stomach is screaming for food by now! You should really find something to eat!"))
	if((H.nutrition < 100) && prob(10))
		H.Confuse(10)
	if((H.nutrition < 50) && prob(25))
		H.hallucination = max(30,H.hallucination+8)
	if((H.nutrition < 25) && prob(5))
		H.drowsyness = max(100,H.drowsyness+30)


/datum/trait/negative/blindness
	name = "Permanently blind"
	desc = "You are blind. For whatever reason, nothing is able to change this fact, not even surgery. WARNING: YOU WILL NOT BE ABLE TO SEE ANY POSTS USING THE ME VERB, ONLY SUBTLE AND DIALOGUE ARE VIEWABLE TO YOU, YOU HAVE BEEN WARNED."
	cost = -12
	special_env = TRUE
	custom_only = FALSE

	// Traitgenes Replaces /datum/trait/negative/disability_blind, made into a gene trait
	is_genetrait = TRUE
	hidden = TRUE //Making this so people can't pick it in character select. While a blind character makes senese, not being able to see posts is a massive issue that needs to be addressed some other time.

	sdisability=BLIND
	activation_message="You can't seem to see anything."
	primitive_expression_messages=list("stumbles aimlessly.")

/datum/trait/negative/blindness/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		//no matter what you do, the blindess still comes for you // Traitgenes tweaked to be consistant with other gene traits by using var

/datum/trait/negative/agoraphobia
	name = "Agoraphobia"
	desc = "You very much dislike being in crowded places. When in the company of more than two other people, you start to panic and experience adverse effects."
	cost = -3
	var/warning_cap = 400
	var/hallucination_cap = 25
	var/escalation_speed = 0.8
	special_env = TRUE
	excludes = list(/datum/trait/negative/lonely,/datum/trait/negative/lonely/major)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like you need some space"
	primitive_expression_messages=list("keeps their distance from others")

/datum/trait/negative/agoraphobia/handle_environment_special(var/mob/living/carbon/human/H)
	spawn(0)
		var/list/in_range = list()
		// If they're dead or unconcious they're a bit beyond this kind of thing.
		if(H.stat)
			return
		// No point processing if we're already stressing the hell out.
		if(H.hallucination >= hallucination_cap && H.loneliness_stage >= warning_cap)
			return
		in_range |= check_mob_company(H,H)	//Checks our item slots and bellies for any people.
		in_range |= belly_check(H,H.loc)	//Recursive check if we're in anyones bellies, are they in anyone's belly, etc.
		in_range |= holder_check(H,H.loc)	//Recursive check if someone's holding us, is anyone holding them, etc.

		// Check for company.
		for(var/mob/living/M in viewers(get_turf(H)))
			in_range |= check_mob_company(H,M)

		for(var/obj/effect/overlay/aiholo/A in range(5, H))
			in_range |= A

		if(in_range.len > 2)
			if(H.loneliness_stage < warning_cap)
				H.loneliness_stage = min(warning_cap,H.loneliness_stage+escalation_speed)
			handle_loneliness(H)
			if(H.loneliness_stage >= warning_cap && H.hallucination < hallucination_cap)
				H.hallucination = min(hallucination_cap,H.hallucination+2.5*escalation_speed)
		else
			H.loneliness_stage = max(H.loneliness_stage-4,0)


/datum/trait/negative/agoraphobia/proc/handle_loneliness(var/mob/living/carbon/human/H)
	if(world.time < H.next_loneliness_time)
		return //Moved this at the top so we dont waste time assigning vars we will never use
	var/ms = handle_loneliness_message(H)
	if(ms)
		to_chat(H, ms)
	H.next_loneliness_time = world.time+500
	H.fear = min((H.fear + 3), 102)

/datum/trait/negative/agoraphobia/proc/handle_loneliness_message(var/mob/living/carbon/human/H)
	var/Lonely = H.loneliness_stage
	if(Lonely == escalation_speed)
		return "You notice there's more people than you feel comfortable with around you..."
	else if(Lonely >= 50 && Lonely < 250)
		return "You start to feel anxious from the number of people around you."
	else if(Lonely >= 250 && Lonely < warning_cap)
		if(H.stuttering < hallucination_cap)
			H.stuttering += 5
		return "[pick("You don't think you can last much longer with this much company!", "You should go find some space!")]" //if we add more here make it a list for readability
	else if(Lonely >= warning_cap)
		var/list/panicmessages = list(	"Why am I still here? I have to leave and get some space!",
						"Please, just let me be alone!",
						"I need to be alone!")
		return span_bolddanger("[pick(panicmessages)]")
	return FALSE

/datum/trait/negative/agoraphobia/proc/find_held_by(var/atom/item)
	if(!item || !istype(item))
		return null
	else if(istype(item,/mob/living))
		return item
	else
		return find_held_by(item.loc)

/datum/trait/negative/agoraphobia/proc/holder_check(var/mob/living/carbon/human/H,var/obj/item/holder/H_holder)
	var/list/in_range = list()
	if(istype(H_holder))
		var/mob/living/held_by = find_held_by(H_holder)
		if(held_by)
			in_range |= check_mob_company(H,held_by,FALSE)
		in_range |= holder_check(H,held_by)
	return in_range

/datum/trait/negative/agoraphobia/proc/belly_check(var/mob/living/carbon/human/H,var/obj/belly/B)
	var/list/in_range = list()
	if(istype(B))
		in_range |= check_mob_company(H,B.owner,FALSE)
		if(isbelly(B.owner.loc))
			in_range |= belly_check(H,B.owner.loc)
	return in_range

/datum/trait/negative/agoraphobia/proc/check_mob_company(var/mob/living/carbon/human/H,var/mob/living/M,var/invis_matters = TRUE)
	var/list/in_range = list()
	if(!istype(M))
		return in_range
	var/social_check = !istype(M, /mob/living/carbon) && !istype(M, /mob/living/silicon/robot)
	var/ckey_check = !M.ckey
	var/overall_checks = M == H || M.stat == DEAD || social_check || ckey_check
	if(invis_matters && M.invisibility > H.see_invisible)
		return in_range
	if(!overall_checks)
		in_range |= M
	in_range |= check_contents(M,H)
	return in_range

/datum/trait/negative/agoraphobia/proc/check_contents(var/atom/item,var/mob/living/carbon/human/H,var/max_layer = 3,var/current_layer = 1)
	var/list/in_range = list()
	if(!item || !istype(item) || current_layer > max_layer)
		return in_range
	for(var/datum/content in item.contents)
		if(istype(content,/obj/item/holder))
			var/obj/item/holder/contentholder = content
			in_range |= check_mob_company(H,contentholder.held_mob)
		else
			in_range |= check_contents(content,H,max_layer,current_layer+1)
	return in_range

/datum/trait/negative/lonely
	name = "Minor loneliness vulnerability"
	desc = "You're very prone to loneliness! Being alone for extended periods of time causes adverse effects. Most mobs will cure this loneliness as long as they aren't hostile."
	cost = -1
	var/warning_cap = 400
	var/only_people = FALSE
	var/hallucination_cap = 25
	var/escalation_speed = 0.8
	special_env = TRUE
	excludes = list(/datum/trait/negative/lonely/major,/datum/trait/negative/agoraphobia)

/datum/trait/negative/lonely/major
	name = "Major loneliness vulnerability"
	desc = "You're extremely prone to loneliness! Being alone for extended periods of time causes adverse effects. Most mobs won't be enough to cure this loneliness, you need other social beings."
	cost = -3
	warning_cap = 300
	hallucination_cap = 50
	escalation_speed = 1.3
	only_people = TRUE
	special_env = TRUE
	excludes = list(/datum/trait/negative/lonely,/datum/trait/negative/agoraphobia)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like you are in desperate need of company..."
	primitive_expression_messages=list("Looks up at you pleadingly")

/datum/trait/negative/lonely/proc/sub_loneliness(var/mob/living/carbon/human/H,var/amount = 4)
	H.loneliness_stage = max(H.loneliness_stage - 4, 0)
	if(world.time >= H.next_loneliness_time && H.loneliness_stage > 0)
		to_chat(H, span_infoplain("The nearby company calms you down..."))
		H.next_loneliness_time = world.time+500

/datum/trait/negative/lonely/proc/check_mob_company(var/mob/living/carbon/human/H,var/mob/living/M)
	if(!istype(M))
		return 0
	var/social_check = only_people && !istype(M, /mob/living/carbon) && !istype(M, /mob/living/silicon/robot)
	var/self_invisible_check = M == H || M.invisibility > H.see_invisible
	var/ckey_check = only_people && !M.ckey
	var/overall_checks = M.stat == DEAD || social_check || ckey_check
	if(self_invisible_check)
		return 0
	if((M.faction == "neutral" || M.faction == H.faction) && !overall_checks)
		sub_loneliness(H)
		return 1
	else
		if(M.vore_organs)
			for(var/obj/belly/B in M.vore_organs)
				for(var/mob/living/content in B.contents)
					if(istype(content))
						check_mob_company(H,content)
	return 0

/datum/trait/negative/lonely/proc/check_contents(var/atom/item,var/mob/living/carbon/human/H,var/max_layer = 3,var/current_layer = 1)
	if(!item || !istype(item) || current_layer > max_layer)
		return 0
	for(var/datum/content in item.contents)
		if(istype(content,/obj/item/holder))
			var/obj/item/holder/contentholder = content
			if(check_mob_company(H,contentholder.held_mob))
				return 1
		else
			if(check_contents(content,H,max_layer,current_layer+1))
				return 1
	return 0

/datum/trait/negative/lonely/handle_environment_special(var/mob/living/carbon/human/H)
	spawn(0)
		// If they're dead or unconcious they're a bit beyond this kind of thing.
		if(H.stat)
			return
		// No point processing if we're already stressing the hell out.
		if(H.hallucination >= hallucination_cap && H.loneliness_stage >= warning_cap)
			return

		// Outpost 21 addition begin - extended loneliness mechanics
		if(H.mind && H.mind.changeling) // We are never alone~
			H.loneliness_stage = 0
			return
		if(H.has_brain_worms()) // Brain friends!
			sub_loneliness(H)
			return
		// Outpost 21 addition end

		// Vored? Not gonna get frightened.
		if(isbelly(H.loc))
			sub_loneliness(H)
			return
		if(istype(H.loc, /obj/item/holder))
			sub_loneliness(H)
			return
		// Check for company.
		if(check_contents(H,H)) //Check our item slots and storage for any micros.
			sub_loneliness(H)
			return
		for(var/mob/living/M in viewers(get_turf(H)))
			if(check_mob_company(H,M))
				return
		//Check to see if there's anyone in our belly
		if(H.vore_organs)
			for(var/obj/belly/B in H.vore_organs)
				for(var/mob/living/content in B.contents)
					if(istype(content))
						if(check_mob_company(H,content))
							return
		for(var/obj/item/holder/micro/M in range(1, H))
			sub_loneliness(H)
		for(var/obj/effect/overlay/aiholo/A in range(5, H))
			sub_loneliness(H)

		for(var/obj/item/toy/plushie/teshari/P in range(5, H))
			sub_loneliness(H)

		// No company? Suffer :(
		if(H.loneliness_stage < warning_cap)
			H.loneliness_stage = min(warning_cap,H.loneliness_stage+escalation_speed)
		handle_loneliness(H)
		if(H.loneliness_stage >= warning_cap && H.hallucination < hallucination_cap)
			H.hallucination = min(hallucination_cap,H.hallucination+2.5*escalation_speed)

/datum/trait/negative/lonely/proc/handle_loneliness(var/mob/living/carbon/human/H)
	var/ms = ""
	if(H.loneliness_stage == escalation_speed)
		ms = "[pick("Well.. No one is around you anymore...","Well.. You're alone now...","You suddenly feel alone...")]" // Outpost 21 edit - More variety
	if(H.loneliness_stage >= 50)
		ms = "[pick("You begin to feel alone...","You feel isolated...","You need company...","Where is everyone?...","You need to find someone...")]" // Outpost 21 edit - More variety
	if(H.loneliness_stage >= 250)
		ms = "[pick("You don't think you can last much longer without some visible company!", "You should go find someone to be with!","You need to find company!","Find someone to be with!")]" // Outpost 21 edit - More variety
		if(H.stuttering < hallucination_cap)
			H.stuttering += 5
	if(H.loneliness_stage >= warning_cap)
		ms = span_danger(span_bold("[pick("Where are the others?", "Please, there has to be someone nearby!", "I don't want to be alone!","Please, anyone! I don't want to be alone!")]")) // Outpost 21 edit - More variety
	if(world.time < H.next_loneliness_time)
		return
	if(ms != "")
		to_chat(H, ms)
	H.next_loneliness_time = world.time+500
	H.fear = min((H.fear + 3), 102)


/datum/trait/negative/endurance_glass // Glass Cannon
	name = "Glass Endurance"
	desc = "Your body is very fragile. Reduces your maximum hitpoints to 25. Beware sneezes. You require only 50 damage in total to die, compared to 200 normally. You will go into crit after losing 25 HP, compared to crit at 100 HP."
	cost = -12 // Similar to Very Low Endurance, this straight up will require you NEVER getting in a fight. This is extremely crippling. I salute the madlad that takes this.
	var_changes = list("total_health" = 25)

/datum/trait/negative/endurance_glass/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/negative/endurance_glass // Glass Cannon
	name = "Glass Endurance"
	desc = "Your body is very fragile. Reduces your maximum hitpoints to 25. Beware sneezes. You require only 50 damage in total to die, compared to 200 normally. You will go into crit after losing 25 HP, compared to crit at 100 HP."
	cost = -12 // Similar to Very Low Endurance, this straight up will require you NEVER getting in a fight. This is extremely crippling. I salute the madlad that takes this.
	var_changes = list("total_health" = 25)

/datum/trait/negative/endurance_glass/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/negative/reduced_biocompat_minor
	name = "Reduced Biocompatibility, Minor"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 80% as effective on you!"
	cost = -2
	var_changes = list("chem_strength_heal" = 0.8)
	can_take = ORGANICS

/datum/trait/negative/reduced_biocompat
	name = "Reduced Biocompatibility"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 60% as effective on you!"
	cost = -4
	var_changes = list("chem_strength_heal" = 0.6)
	can_take = ORGANICS

/datum/trait/negative/reduced_biocompat_extreme
	name = "Reduced Biocompatibility, Major"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 30% as effective on you!"
	cost = -8
	var_changes = list("chem_strength_heal" = 0.3)
	can_take = ORGANICS

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel no different"
	primitive_expression_messages=list("blinks")

// Rykkanote: Relocated these here as we're no longer a YW downstream.
/datum/trait/negative/light_sensitivity
	name = "Photosensitivity"
	desc = "You have trouble dealing with sudden flashes of light, taking some time for you to recover. The effects of flashes from cameras and security equipment leaves you stunned for some time. 50% increased stun duration from flashes."
	cost = -1
	var_changes = list("flash_mod" = 1.5)

/datum/trait/negative/light_sensitivity_plus
	name = "Photosensitivity, Major"
	desc = "You have trouble dealing with sudden flashes of light, taking quite a long time for you to be able to recover. The effects of flashes from cameras and security equipment leave you stunned for some time. 100% (2x) stun duration from flashes."
	cost = -2
	var_changes = list("flash_mod" = 2.0)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Lights feel painful to look at..."
	primitive_expression_messages=list("holds a hand up to their eyes")

/datum/trait/negative/haemophilia_plus
	name = "Haemophilia, Major"
	desc = "Some say that when it rains, it pours.  Unfortunately, this is also true for yourself if you get cut. You bleed much faster than average, at 3x the normal rate."
	cost = -3
	can_take = ORGANICS

	activation_message="You feel "
	primitive_expression_messages=list("bumps their toe, screaming in pain")

/datum/trait/negative/haemophilia_plus/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/haemophilia)

/datum/trait/negative/haemophilia_plus/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.remove_modifiers_of_type(/datum/modifier/trait/haemophilia)

/datum/trait/negative/pain_intolerance_basic
	name = "Pain Intolerance"
	desc = "You are frail and sensitive to pain. You experience 25% more pain from all sources."
	cost = -2
	var_changes = list("pain_mod" = 1.2)

/datum/trait/negative/pain_intolerance_advanced
	name = "Pain Intolerance, Major"
	desc = "You are highly sensitive to all sources of pain, and experience 50% more pain."
	cost = -3
	var_changes = list("pain_mod" = 1.5) //this makes you extremely vulnerable to most sources of pain, a stunbaton bop or shotgun beanbag will do around 90 agony, almost enough to drop you in one hit.

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel as though the airflow around you is painful..."
	primitive_expression_messages=list("bumps their toe, screaming in pain")

/datum/trait/negative/sensitive_biochem
	name = "Sensitive Biochemistry"
	desc = "Your biochemistry is a little delicate, rendering you more susceptible to both deadly toxins and the more subtle ones. You'll probably want to list this in your medical records, and perhaps in your exploitable info as well. Toxin damages and knockout drugs are 25% stronger on you."
	cost = -1
	var_changes = list("chem_strength_tox" = 1.25)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

/datum/trait/negative/slipperydirt
	name = "Dirt Vulnerability"
	desc = "Even the tiniest particles of dirt give you uneasy footing, even through several layers of footwear."
	cost = -5
	var_changes = list("dirtslip" = TRUE)
