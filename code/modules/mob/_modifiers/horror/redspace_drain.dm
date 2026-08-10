/datum/modifier/redspace_drain
	name = "redspace warp"
	desc = "Your body is being slowly sapped of it's lifeforce, being used to fuel this hellish nightmare of a place."

	on_created_text = span_cult("You feel your body slowly being drained and warped")
	on_expired_text = span_notice("Your body feels more normal.")

	stacks = MODIFIER_STACK_EXTEND

	//mob_overlay_state = "redspace_aura" //Let's be secretive~
	var/mob/living/carbon/human/unfortunate_soul //The human target of our modifier.
	///How long we have had the redspace modifier on us.
	var/current_time = 0

/datum/modifier/redspace_drain/can_apply(mob/living/L, suppress_output = TRUE)
	if(ishuman(L) && !L.isSynthetic() && L.lastarea && is_type_in_list(L.lastarea, GLOB.redspace_areas))
		return TRUE
	return FALSE

/datum/modifier/redspace_drain/on_applied()
	unfortunate_soul = holder
	to_chat(unfortunate_soul, span_cult("You feel as if your lifeforce is slowly being rended from your body."))
	if(!unfortunate_soul.HasDisease(/datum/disease/fleshy_spread))
		var/datum/disease/fleshy_spread/flesh_disease = new /datum/disease/fleshy_spread()
		unfortunate_soul.ForceContractDisease(flesh_disease, BP_TORSO)
	return

/datum/modifier/redspace_drain/on_expire()
	if(QDELETED(holder))
		unfortunate_soul = null
		return //Don't do anything if we got QDEL'd, such as if we were gibbed
	if(unfortunate_soul.stat == DEAD) //Only care if we're dead.
		handle_corpse()
		var/obj/effect/landmark/drop_point
		drop_point = pick(GLOB.latejoin) //Can be changed to whatever exit list you want. By default, uses GLOB.latejoin
		if(drop_point)
			unfortunate_soul.forceMove(get_turf(drop_point))
			unfortunate_soul.maxHealth = max(50, unfortunate_soul.maxHealth) //If they died, send them back with 50 maxHealth or their current maxHealth. Whatever's higher. We're evil, but not mean.
		else
			message_admins("Redspace Drain expired, but no drop point was found, leaving [unfortunate_soul] in limbo. This is a bug. Please report it with this info: redspace_drain/on_expire")
	unfortunate_soul = null

/datum/modifier/redspace_drain/proc/handle_corpse()
	return //Specialty stuff to do to a corpse other than teleport them.

/datum/modifier/redspace_drain/check_if_valid() //We don't call parent. This doesn't wear off without set conditions.
	if(holder.stat == DEAD)
		expire(silent = TRUE)
	else if(holder.lastarea && !is_type_in_list(holder.lastarea, GLOB.redspace_areas))
		expire(silent = TRUE)

/datum/modifier/redspace_drain/tick()
	if(isbelly(holder.loc)) //If you're eaten, let's hold off on doing anything spooky.
		return
	current_time++

	if(current_time % 5 == 0) //Once every 5 ticks, we chip away at them.
		unfortunate_soul.drip(1) //Blood trail.
		unfortunate_soul.take_overall_damage(1) //Small bit of damage
		if(unfortunate_soul.bloodstr.get_reagent_amount(REAGENT_ID_NUMBENZYME) < 2) //We lose all feeling in our body. We can't tell how injured we are.
			unfortunate_soul.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,1)

	if(current_time % 20 == 0) //Once every 20 ticks, we permanetly cripple them.
		unfortunate_soul.maxHealth = max(10, unfortunate_soul.maxHealth - 1) //Max health is reduced by 1, but never below 10. This is PERMANENT for the rest of the round or until resleeving.

	//The dangerous health effects.
	if(current_time % 100 == 0)// Once every 100 ticks, we mutate some organs.
		choose_organs()
		become_drippy()
		to_chat(unfortunate_soul, span_cult("You feel as if your organs are crawling around within your body."))

	//The mental effects.
	unfortunate_soul.fear = min(100, unfortunate_soul.fear + 2) //Fear is increased by 1, but never above 100. You're in a scary place.
	if(current_time % 20 == 0)
		var/obj/item/organ/O = pick(unfortunate_soul.internal_organs)
		if(!O) //If you don't have any internal organs, you know what? No spooky messages for you, freak.
			var/spooky_message = pick("Join us...", "Stay with us...", "Stay forever...", "Don't leave us...", \
			"Don't go...", "We can be as one...", "Become one with us...", \
			"You can feel your [O] squirming inside of you, trying to get out...", "Your [O] is trying to escape...", \
			"Your [O] itches.", "Your [O] is crawling around inside of you.")
			to_chat(unfortunate_soul, span_cult(spooky_message))
		unfortunate_soul.make_dizzy(5)
		unfortunate_soul.stuttering = min(100, unfortunate_soul.stuttering + 10) //Stuttering is increased by 1, but never above 100. You're in a scary place.
	return

/datum/modifier/redspace_drain/proc/choose_organs(organs_to_replace)
	if(!organs_to_replace)
		organs_to_replace = rand(1,2)
	if(organs_to_replace <= 0) //Sanity
		return
	for(var/i = 0 to organs_to_replace)
		var/organ_choice = pick("eyes", "heart", "lungs", "liver", "kidneys", "appendix", "voicebox", "spleen", "stomach", "intestine")
		switch(organ_choice)
			if("eyes")
				var/obj/item/organ/internal/eyes/E = unfortunate_soul.internal_organs_by_name[O_EYES]
				if(E)
					replace_eyes(E)
			if("heart")
				var/obj/item/organ/internal/heart/H = unfortunate_soul.internal_organs_by_name[O_HEART]
				if(H)
					replace_heart(H)
			if("lungs")
				var/obj/item/organ/internal/lungs/L = unfortunate_soul.internal_organs_by_name[O_LUNGS]
				if(L)
					replace_lungs(L)
			if("liver")
				var/obj/item/organ/internal/liver/L = unfortunate_soul.internal_organs_by_name[O_LIVER]
				if(L)
					replace_liver(L)
			if("kidneys")
				var/obj/item/organ/internal/kidneys/K = unfortunate_soul.internal_organs_by_name[O_KIDNEYS]
				if(K)
					replace_kidneys(K)
			if("appendix")
				var/obj/item/organ/internal/appendix/A = unfortunate_soul.internal_organs_by_name[O_APPENDIX]
				if(A)
					replace_appendix(A)
			if("voicebox")
				var/obj/item/organ/internal/voicebox/V = unfortunate_soul.internal_organs_by_name[O_VOICE]
				if(V)
					replace_voicebox(V)
			if("spleen")
				var/obj/item/organ/internal/spleen/S = unfortunate_soul.internal_organs_by_name[O_SPLEEN]
				if(S)
					replace_spleen(S)
			if("stomach")
				var/obj/item/organ/internal/stomach/S = unfortunate_soul.internal_organs_by_name[O_STOMACH]
				if(S)
					replace_stomach(S)
			if("intestine")
				var/obj/item/organ/internal/intestine/E = unfortunate_soul.internal_organs_by_name[O_INTESTINE]
				if(E)
					replace_intestine(E)

///Variant redspace drain ONLY used for the virus.
/datum/modifier/redspace_drain/lesser
	name = "redspace infection"
	desc = "Your body is warping..."

	on_created_text = null
	on_expired_text = null

/datum/modifier/redspace_drain/lesser/can_apply(mob/living/L, suppress_output = TRUE)
	if(ishuman(L) && !L.isSynthetic())
		return TRUE
	return FALSE

/datum/modifier/redspace_drain/lesser/on_applied()
	unfortunate_soul = holder
	return

/datum/modifier/redspace_drain/lesser/on_expire()
	unfortunate_soul = null
	return

/datum/modifier/redspace_drain/lesser/check_if_valid()
	if(expire_at && expire_at < world.time)
		src.expire()

/datum/modifier/redspace_drain/lesser/tick()
	return
/*
/datum/modifier/redspace_drain/proc/replace_organ() //Old version of doing this WITHOUT the custom organs. Preserved as an alternative version / reference
	var/obj/item/organ/O = pick(unfortunate_soul.internal_organs)
	if(O)
		var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
		O.name = "[random_name] [initial(O.name)]"
		O.desc = "A twisted, warped version of a [initial(O.name)] covered in thick, red, pulsating tendrils."
		O.take_damage(3)
		O.color = "#760b0b"
		O.add_autopsy_data("ANOMALOUS FLESH GROWTH", 3)
		O.decays = FALSE
		O.meat_type = /obj/item/reagent_containers/food/snacks/meat/worm //It turns into 'weird meat' with the desc of 'A chunk of pulsating meat'
		O.can_reject = FALSE
*/

/datum/modifier/redspace_drain/proc/become_drippy()
	if(!(unfortunate_soul.species.flags & NO_DNA)) //Doing it as such in case drippy is ever made NOT a trait gene.
		var/datum/gene/trait/drippy_trait = get_gene_from_trait(/datum/trait/neutral/drippy)
		unfortunate_soul.dna.SetSEState(drippy_trait.block, TRUE)
		domutcheck(unfortunate_soul, null, GENE_ALWAYS_ACTIVATE)
		unfortunate_soul.UpdateAppearance()
