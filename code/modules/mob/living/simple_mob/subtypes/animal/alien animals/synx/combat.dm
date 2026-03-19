//////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// PASSIVE POWERS!!!! /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// nevermind. I added any roleplay flavor weird fur mechanics to happen when you touch or attack the synx.

/mob/living/simple_mob/animal/synx/apply_melee_effects(var/atom/A) //Re-adding this for AI synx
	if(stomach_distended) //Hacky burn damage code
		if(isliving(A)) //Only affect living mobs, should include silicons. This could be expanded to deal special effects to acid-vulnerable objects.
			var/mob/living/L = A
			var/armor_modifier = abs((L.getarmor(null, "bio") / 100) - 1) //Factor in victim bio armor
			var/amount = rand(acid_damage_lower, acid_damage_upper) //Select a damage value
			var/damage_done = amount * armor_modifier
			if(damage_done > 0) //sanity check, no healing the victim if somehow this is a negative value.
				L.adjustFireLoss(damage_done)
				return
			else
				to_chat(src,span_notice("Your stomach bounces off of the victim's armor!"))
				return
		return //If stomach is distended, return here to perform no forcefeeding or poison injecton.

	if(isliving(A))
		var/mob/living/L = A

/*		if(prob(forcefeedchance) && !ckey)//Forcefeeding code //Only triggers if not player-controlled //This does not currently work
			L.Weaken(2)
			update_icon()
			set_AI_busy(TRUE)
			src.feed_self_to_grabbed(src,L)
			update_icon()
			set_AI_busy(FALSE)
*/
		if(L.reagents) //Seemingly broken. Would probably be really annoying anyways, so probably for the best that it doesn't work. -Azel
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				if(prob(poison_chance))
					to_chat(L, span_warning("You feel a strange substance on you."))
					L.reagents.add_reagent(poison_type, poison_per_bite)



/mob/living/simple_mob/animal/synx/hear_say(message,verb,language,fakename,isItalics,var/mob/living/speaker)
	. = ..()
	if(!message || !speaker)    return
	if (speaker == src) return
	speaker = speaker.GetVoice()
	speak += message
	voices += speaker
	if(voices.len>=memorysize)
		voices -= (pick(voices))//making the list more dynamic
	if(speak.len>=memorysize)
		speak -= (pick(speak))//making the list more dynamic
	if(resting)
		resting = !resting
	if(message=="Honk!")
		bikehorn()

/mob/living/simple_mob/animal/synx/Life()
	..()
//mob/living/simple_mob/animal/synx/ai/handle_idle_speaking() //Only ai-controlled synx will randomly speak
	if(voices && prob(speak_chance/2))
		randomspeech()

/mob/living/simple_mob/animal/synx/perform_the_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly, delay) //Synx can only eat people if their organs are on the inside.
	if(stomach_distended)
		to_chat(src,span_notice("You can't eat people without your stomach inside of you!"))
		return
	else
		..()
