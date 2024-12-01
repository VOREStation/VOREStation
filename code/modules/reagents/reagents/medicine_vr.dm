/datum/reagent/adranol
	name = "Adranol"
	id = "adranol"
	description = "A mild sedative that calms the nerves and relaxes the patient."
	taste_description = "milk"
	reagent_state = LIQUID
	color = "#d5e2e5"
	scannable = 1

/datum/reagent/adranol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.confused)
		M.Confuse(-8*removed)
	if(M.eye_blurry)
		M.eye_blurry = max(M.eye_blurry - 25*removed, 0)
	if(M.jitteriness)
		M.make_jittery(min(-25*removed,0))

/datum/reagent/numbing_enzyme
	name = "Numbing Enzyme"
	id = "numbenzyme"
	description = "Some sort of organic painkiller."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#800080"
	metabolism = 0.1 //Lasts up to 200 seconds if you give 20u which is OD.
	mrate_static = TRUE
	overdose = 20 //High OD. This is to make numbing bites have somewhat of a downside if you get bit too much. Have to go to medical for dialysis.
	scannable = 0 //Let's not have medical mechs able to make an extremely strong organic painkiller

/datum/reagent/numbing_enzyme/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 200)
	if(prob(0.01)) //1 in 10000 chance per tick. Extremely rare.
		to_chat(M,span_warning("Your body feels numb as a light, tingly sensation spreads throughout it, like some odd warmth."))
	//Not noted here, but a movement debuff of 1.5 is handed out in human_movement.dm when numbing_enzyme is in a person's bloodstream!

/datum/reagent/numbing_enzyme/overdose(var/mob/living/carbon/M, var/alien)
	//..() //Add this if you want it to do toxin damage. Personally, let's allow them to have the horrid effects below without toxin damage.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(1))
			to_chat(H,span_warning("Your entire body feels numb and the sensation of pins and needles continually assaults you. You blink and the next thing you know, your legs give out momentarily!"))
			H.AdjustWeakened(5) //Fall onto the floor for a few moments.
			H.Confuse(15) //Be unable to walk correctly for a bit longer.
		if(prob(1))
			if(H.losebreath <= 1 && H.oxyloss <= 20) //Let's not suffocate them to the point that they pass out.
				to_chat(H,span_warning("You feel a sharp stabbing pain in your chest and quickly realize that your lungs have stopped functioning!")) //Let's scare them a bit.
				H.losebreath = 10
				H.adjustOxyLoss(5)
		if(prob(2))
			to_chat(H,span_warning("You feel a dull pain behind your eyes and at thee back of your head..."))
			H.hallucination += 20 //It messes with your mind for some reason.
			H.eye_blurry += 20 //Groggy vision for a small bit.
		if(prob(3))
			to_chat(H,span_warning("You shiver, your body continually being assaulted by the sensation of pins and needles."))
			H.emote("shiver")
			H.make_jittery(10)
		if(prob(3))
			to_chat(H,span_warning("Your tongue feels numb and unresponsive."))
			H.stuttering += 20

/datum/reagent/vermicetol
	name = "Vermicetol"
	id = "vermicetol"
	description = "A potent chemical that treats physical damage at an exceptional rate."
	taste_description = "sparkles"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#750404"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/vermicetol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(8 * removed * chem_effective, 0)

/datum/reagent/sleevingcure
	name = "Resleeving Sickness Cure"
	id = "sleevingcure"
	description = "A rare cure provided by Vey-Med that helps counteract negative side effects of using imperfect resleeving machinery."
	taste_description = "chocolate peanut butter"
	taste_mult = 2
	reagent_state = LIQUID
	color = "#b4dcdc"
	overdose = 5
	scannable = 0

/datum/reagent/sleevingcure/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.remove_a_modifier_of_type(/datum/modifier/resleeving_sickness)
	M.remove_a_modifier_of_type(/datum/modifier/faux_resleeving_sickness)



/datum/reagent/prussian_blue //We don't have iodine, so prussian blue we go.
	name = "Prussian Blue"
	id = "prussian_blue"
	description = "Prussian Blue is an medication used to temporarily pause the effects of radiation poisoning to allow for treatment. Does not treat radiation sickness on its own."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#003153" //Blue!
	metabolism = REM * 0.25//20 ticks to do things per unit injected. This means injecting 30u will give you 10 minutes to do what you need.
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/prussian_blue/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(10)) //Miniscule chance of removing some toxins.
		M.adjustToxLoss(-10 * removed)

/datum/reagent/lipozilase // The anti-nutriment that rapidly removes weight.
	name = "Lipozilase"
	id = "lipozilase"
	description = "A chemical compound that causes a dangerously powerful fat-burning reaction."
	taste_description = "blandness"
	reagent_state = LIQUID
	color = "#47AD6D"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lipozilase/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(-20 * removed)
	if(M.weight > 50)
		M.weight -= 0.3

/datum/reagent/lipostipo // The drug that rapidly increases weight.
	name = "Lipostipo"
	id = "lipostipo"
	description = "A chemical compound that causes a dangerously powerful fat-adding reaction."
	taste_description = "blubber"
	reagent_state = LIQUID
	color = "#61731C"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lipostipo/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(-20 * removed)
	if(M.weight < 500)
		M.weight += 0.3

/datum/reagent/polymorph
	name = "Transforitine"
	id = "polymorph"
	description = "A chemical that instantly transforms the consumer into another creature."
	taste_description = "luck"
	reagent_state = LIQUID
	color = "#a754de"
	scannable = 1
	var/tf_type = /mob/living/simple_mob/animal/passive/mouse
	var/tf_possible_types = list(
		"mouse" = /mob/living/simple_mob/animal/passive/mouse,
		"rat" = /mob/living/simple_mob/animal/passive/mouse/rat,
		"giant rat" = /mob/living/simple_mob/vore/aggressive/rat,
		"dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
		"woof" = /mob/living/simple_mob/vore/woof,
		"corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
		"cat" = /mob/living/simple_mob/animal/passive/cat,
		"chicken" = /mob/living/simple_mob/animal/passive/chicken,
		"cow" = /mob/living/simple_mob/animal/passive/cow,
		"lizard" = /mob/living/simple_mob/animal/passive/lizard,
		"rabbit" = /mob/living/simple_mob/vore/rabbit,
		"fox" = /mob/living/simple_mob/animal/passive/fox,
		"fennec" = /mob/living/simple_mob/vore/fennec,
		"cute fennec" = /mob/living/simple_mob/animal/passive/fennec,
		"fennix" = /mob/living/simple_mob/vore/fennix,
		"red panda" = /mob/living/simple_mob/vore/redpanda,
		"opossum" = /mob/living/simple_mob/animal/passive/opossum,
		"horse" = /mob/living/simple_mob/vore/horse,
		"goose" = /mob/living/simple_mob/animal/space/goose,
		"sheep" = /mob/living/simple_mob/vore/sheep,
		"space bumblebee" = /mob/living/simple_mob/vore/bee,
		"space bear" = /mob/living/simple_mob/animal/space/bear,
		"voracious lizard" = /mob/living/simple_mob/vore/aggressive/dino,
		"giant frog" = /mob/living/simple_mob/vore/aggressive/frog,
		"jelly blob" = /mob/living/simple_mob/vore/jelly,
		"wolf" = /mob/living/simple_mob/vore/wolf,
		"direwolf" = /mob/living/simple_mob/vore/wolf/direwolf,
		"great wolf" = /mob/living/simple_mob/vore/greatwolf,
		"sect queen" = /mob/living/simple_mob/vore/sect_queen,
		"sect drone" = /mob/living/simple_mob/vore/sect_drone,
		"panther" = /mob/living/simple_mob/vore/aggressive/panther,
		"giant snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
		"deathclaw" = /mob/living/simple_mob/vore/aggressive/deathclaw,
		"otie" = /mob/living/simple_mob/vore/otie,
		"mutated otie" =/mob/living/simple_mob/vore/otie/feral,
		"red otie" = /mob/living/simple_mob/vore/otie/red,
		"defanged xenomorph" = /mob/living/simple_mob/vore/xeno_defanged,
		"catslug" = /mob/living/simple_mob/vore/alienanimals/catslug,
		"monkey" = /mob/living/carbon/human/monkey,
		"wolpin" = /mob/living/carbon/human/wolpin,
		"sparra" = /mob/living/carbon/human/sparram,
		"saru" = /mob/living/carbon/human/sergallingm,
		"sobaka" = /mob/living/carbon/human/sharkm,
		"farwa" = /mob/living/carbon/human/farwa,
		"neaera" = /mob/living/carbon/human/neaera,
		"stok" = /mob/living/carbon/human/stok,
		"weretiger" = /mob/living/simple_mob/vore/weretiger,
		"dragon" = /mob/living/simple_mob/vore/bigdragon/friendly,
		"leopardmander" = /mob/living/simple_mob/vore/leopardmander
		)

/datum/reagent/polymorph/affect_blood(var/mob/living/carbon/target, var/removed)
	var/mob/living/M = target
	log_debug("polymorph start")
	if(!istype(M))
		log_debug("polymorph istype")
		return
	if(M.tf_mob_holder)
		log_debug("polymorph tf_holder")
		var/mob/living/ourmob = M.tf_mob_holder
		if(ourmob.ai_holder)
			log_debug("polymorph ai")
			var/datum/ai_holder/our_AI = ourmob.ai_holder
			our_AI.set_stance(STANCE_IDLE)
		M.tf_mob_holder = null
		ourmob.ckey = M.ckey
		var/turf/get_dat_turf = get_turf(target)
		ourmob.loc = get_dat_turf
		ourmob.forceMove(get_dat_turf)
		ourmob.vore_selected = M.vore_selected
		M.vore_selected = null
		for(var/obj/belly/B as anything in M.vore_organs)
			log_debug("polymorph belly")
			B.loc = ourmob
			B.forceMove(ourmob)
			B.owner = ourmob
			M.vore_organs -= B
			ourmob.vore_organs += B

		ourmob.Life(1)
		if(ishuman(M))
			log_debug("polymorph human")
			for(var/obj/item/W in M)
				log_debug("polymorph items")
				if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))
					log_debug("polymorph implants")
					continue
				M.drop_from_inventory(W)

		qdel(target)
		return
	else
		log_debug("polymorph else")
		if(M.stat == DEAD)	//We can let it undo the TF, because the person will be dead, but otherwise things get weird.
			log_debug("polymorph dead")
			return
		log_debug("polymorph not dead")
		var/mob/living/new_mob = spawn_mob(M)
		new_mob.faction = M.faction

		if(new_mob && isliving(new_mob))
			log_debug("polymorph new_mob")
			for(var/obj/belly/B as anything in new_mob.vore_organs)
				log_debug("polymorph new_mob belly")
				new_mob.vore_organs -= B
				qdel(B)
			new_mob.vore_organs = list()
			new_mob.name = M.name
			new_mob.real_name = M.real_name
			for(var/lang in M.languages)
				new_mob.languages |= lang
			M.copy_vore_prefs_to_mob(new_mob)
			new_mob.vore_selected = M.vore_selected
			if(ishuman(M))
				log_debug("polymorph ishuman part2")
				var/mob/living/carbon/human/H = M
				if(ishuman(new_mob))
					log_debug("polymorph ishuman(newmob)")
					var/mob/living/carbon/human/N = new_mob
					N.gender = H.gender
					N.identifying_gender = H.identifying_gender
				else
					log_debug("polymorph gender else")
					new_mob.gender = H.gender
			else
				log_debug("polymorph gender else 2")
				new_mob.gender = M.gender
				if(ishuman(new_mob))
					var/mob/living/carbon/human/N = new_mob
					N.identifying_gender = M.gender

			for(var/obj/belly/B as anything in M.vore_organs)
				B.loc = new_mob
				B.forceMove(new_mob)
				B.owner = new_mob
				M.vore_organs -= B
				new_mob.vore_organs += B

			new_mob.ckey = M.ckey
			if(M.ai_holder && new_mob.ai_holder)
				var/datum/ai_holder/old_AI = M.ai_holder
				old_AI.set_stance(STANCE_SLEEP)
				var/datum/ai_holder/new_AI = new_mob.ai_holder
				new_AI.hostile = old_AI.hostile
				new_AI.retaliate = old_AI.retaliate
			M.loc = new_mob
			M.forceMove(new_mob)
			new_mob.tf_mob_holder = M
	target.bloodstr.clear_reagents() //Got to clear all reagents to make sure mobs don't keep spawning.
	target.ingested.clear_reagents()
	target.touching.clear_reagents()

/datum/reagent/polymorph/proc/spawn_mob(var/mob/living/target)
	log_debug("polymorph proc spawn mob")
	var/choice = pick(tf_possible_types)
	tf_type = tf_possible_types[choice]
	log_debug("polymorph [tf_type]")
	if(!ispath(tf_type))
		log_debug("polymorph tf_type fail")
		return
	log_debug("polymorph tf_type pass")
	var/new_mob = new tf_type(get_turf(target))
	return new_mob

/datum/reagent/glamour
	name = "Glamour"
	id = "glamour"
	description = "This material is from somewhere else, just being near produces changes."
	taste_description = "change"
	reagent_state = LIQUID
	color = "#ffffff"
	scannable = 1

/datum/reagent/glamour/affect_blood(var/mob/living/carbon/target, var/removed)
	add_verb(target, /mob/living/carbon/human/proc/enter_cocoon)
	target.bloodstr.clear_reagents() //instantly clears reagents afterwards
	target.ingested.clear_reagents()
	target.touching.clear_reagents()
