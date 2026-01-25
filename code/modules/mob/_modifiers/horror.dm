// These are modifiers used for various spooky areas that are meant to be SCARY and THREATENING.
// Outside of extreme circumstances, these should not be used.
// For the primary effect, if someone is not in one of the below 'redspace_areas' Then they can not have the modifier
// applied to them. This acts as a failsafe from it from accidentally being used outside of events.
// If you DO want to use this for an event, make the event area a child of /redgate or add it to the below areas list.
// These have some extremely spooky effects and players should know about it beforehand.


// REDSPACE AREAS
// This list needs expansion...  Currently, we have very few proper redspace areas.
// Tossing /area/redgate in here as well. Entering one of these areas (unless coded to do such) doesn't apply
// the modifier, but if you're in one of these areas, you'll keep the modifier until you leave.
var/static/list/redspace_areas = list (
	/area/redspace_abduction,
	/area/redgate,
	/area/survivalpod/redspace // Redspace shelters effectively pull a bit of redspace into realspace, so
)

/datum/modifier/redspace_drain
	name = "redspace warp"
	desc = "Your body is being slowly sapped of it's lifeforce, being used to fuel this hellish nightmare of a place."

	on_created_text = span_cult("You feel your body slowly being drained and warped")
	on_expired_text = span_notice("Your body feels more normal.")

	stacks = MODIFIER_STACK_EXTEND

	//mob_overlay_state = "redspace_aura" //Let's be secretive~
	var/mob/living/carbon/human/unfortunate_soul //The human target of our modifier.

/datum/modifier/redspace_drain/can_apply(mob/living/L, suppress_output = TRUE)
	if(ishuman(L) && !L.isSynthetic() && L.lastarea && is_type_in_list(L.lastarea, redspace_areas))
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
	else if(holder.lastarea && !is_type_in_list(holder.lastarea, redspace_areas))
		expire(silent = TRUE)

/datum/modifier/redspace_drain/tick()
	if(isbelly(holder.loc)) //If you're eaten, let's hold off on doing anything spooky.
		return

	//The dangerous health effects.
	unfortunate_soul.nutrition = max(0, unfortunate_soul.nutrition - 5) //Your nutrition is being sapped faster than usual.
	if(unfortunate_soul.life_tick % 100 == 0)// Once every 100 ticks, we mutate some organs.
		choose_organs()
		become_drippy()
		to_chat(unfortunate_soul, span_cult("You feel as if your organs are crawling around within your body."))

	if(unfortunate_soul.life_tick % 5 == 0) //Once every 5 ticks, we chip away at them.
		unfortunate_soul.drip(1) //Blood trail.
		unfortunate_soul.take_overall_damage(1) //Small bit of damage
		if(unfortunate_soul.bloodstr.get_reagent_amount(REAGENT_ID_NUMBENZYME) < 2) //We lose all feeling in our body. We can't tell how injured we are.
			unfortunate_soul.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,1)
	if(unfortunate_soul.life_tick % 20 == 0) //Once every 20 ticks, we permanetly cripple them.
		unfortunate_soul.maxHealth = max(10, unfortunate_soul.maxHealth - 1) //Max health is reduced by 1, but never below 10. This is PERMANENT for the rest of the round or until resleeving.


	//The mental effects.
	unfortunate_soul.fear = min(100, unfortunate_soul.fear + 2) //Fear is increased by 1, but never above 100. You're in a scary place.
	if(unfortunate_soul.life_tick % 20 == 0)
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
		organs_to_replace = rand(2,3)
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

/datum/modifier/redspace_drain/proc/replace_eyes(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/eyes/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/eyes/new_organ = new /obj/item/organ/internal/eyes/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_heart(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/heart/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/heart/new_organ = new /obj/item/organ/internal/heart/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_lungs(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/lungs/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/lungs/new_organ = new /obj/item/organ/internal/lungs/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_liver(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/liver/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/liver/new_organ = new /obj/item/organ/internal/liver/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_kidneys(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/kidneys/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/kidneys/new_organ = new /obj/item/organ/internal/kidneys/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_appendix(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/appendix/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/appendix/new_organ = new /obj/item/organ/internal/appendix/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_voicebox(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/voicebox/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/voicebox/new_organ = new /obj/item/organ/internal/voicebox/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_spleen(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/spleen/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/spleen/new_organ = new /obj/item/organ/internal/spleen/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_stomach(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/stomach/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/stomach/new_organ = new /obj/item/organ/internal/stomach/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

/datum/modifier/redspace_drain/proc/replace_intestine(obj/item/organ/internal/O)
	if(istype(O, /obj/item/organ/internal/intestine/horror))
		return
	var/organ_spot = O.parent_organ
	var/obj/item/organ/internal/intestine/new_organ = new /obj/item/organ/internal/intestine/horror()
	O.removed(unfortunate_soul)
	qdel(O)
	new_organ.replaced(unfortunate_soul,unfortunate_soul.get_organ(organ_spot))
	var/random_name = pick("pulsating", "quivering", "throbbing", "crawling", "oozing", "melting", "gushing", "dripping", "twitching", "slimy", "gooey")
	new_organ.name = "[random_name] [initial(new_organ.name)]"

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

/datum/modifier/redsight
	name = "redsight"
	desc = "You can see into the unknown."
	client_color = "#ce6161"

	on_created_text = span_alien("You feel as though you can see the horrors of reality!")
	on_expired_text = span_notice("Your sight returns to what it once was.")
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/redsight/on_applied()
	holder.see_invisible = 60
	holder.see_invisible_default = 60
	holder.vis_enabled += VIS_GHOSTS
	holder.recalculate_vis()

/datum/modifier/redsight/on_expire()
	holder.see_invisible_default = initial(holder.see_invisible_default)
	holder.see_invisible = holder.see_invisible_default
	holder.vis_enabled -= VIS_GHOSTS
	holder.recalculate_vis()

/datum/modifier/redsight/can_apply(var/mob/living/L)
	if(L.stat)
		to_chat(L, span_warning("You can't be unconscious or dead to see the unknown."))
		return FALSE
	var/obj/item/organ/internal/eyes/E = L.internal_organs_by_name[O_EYES]
	if(E && istype(E, /obj/item/organ/internal/eyes/horror))
		return ..()
	return FALSE

/datum/modifier/redsight/check_if_valid() //We don't call parent. This doesn't wear off without set conditions.
	//Dead?
	if(holder.stat == DEAD)
		expire(silent = TRUE)
	//We got eyes and they're special eyes?
	var/obj/item/organ/internal/eyes/E = holder.internal_organs_by_name[O_EYES]
	if(!E)
		expire(silent = TRUE)
	else if(!istype(E, /obj/item/organ/internal/eyes/horror))
		expire(silent = TRUE)

/datum/modifier/redsight/tick()
	..()

///The PERMANENT debuff that redspace warp leaves you with.
/datum/modifier/redspace_corruption
	name = "redspace corruption"
	desc = "Your body has been permanently twisted."

	on_created_text = null
	on_expired_text = null

	stacks = MODIFIER_STACK_EXTEND

	///Time since we last revived
	var/time_since_revival = 0

	///Cooldown on how often we can revive.
	var/revival_cooldown = 60 SECONDS

	///When did we last do a 'heal tick' ?
	var/heal_tick = 0

	///How often do we do a 'heal tick' ?
	var/heal_tick_cooldown = 5 SECONDS

	///What chance is there per tick that we unsheath an armblade and face someone?
	var/blade_chance = 1

	///What is the chance that we inject a paralyze a nearby crewmember that is standing too close to us?
	var/injection_chance = 3

	///If we have our flesh armor deployed or not.
	var/armor_deployed = FALSE

	///At what time did we deploy our armor?
	var/armor_deployed_time = 0

	///How long can we upkeep our armor?
	var/armor_duration = 5 MINUTES

	///What is our hivemind name?
	var/speech_name = "The Unseen Horror"


	var/mob/living/carbon/human/unfortunate_soul //The human target of our modifier.

/datum/modifier/redspace_corruption/can_apply(mob/living/L, suppress_output = TRUE)
	if(ishuman(L) && !L.isSynthetic())
		if(L.mind?.assigned_role == JOB_CHAPLAIN)
			return FALSE
		return TRUE
	return FALSE

/datum/modifier/redspace_corruption/on_applied()
	unfortunate_soul = holder
	ADD_TRAIT(unfortunate_soul, TRAIT_REDSPACE_CORRUPTED, UNHOLY_TRAIT)
	ADD_TRAIT(unfortunate_soul, UNIQUE_MINDSTRUCTURE, UNHOLY_TRAIT)
	speech_name = pick("Lost Soul", "Rescued One", "The Embraced", "The Chosen", "The Unseen Horror", "Obedient Servant", "Willing Follower")

	//SHUNT ALL THE IMPORTANT ORGANS TO THE CHEST!
	var/obj/item/organ/internal/brain/brain = unfortunate_soul.internal_organs_by_name[O_BRAIN]
	var/obj/item/organ/internal/eyes/eyes = unfortunate_soul.internal_organs_by_name[O_EYES]
	var/obj/item/organ/external/chest/torso = unfortunate_soul.get_organ(BP_TORSO)
	if(unfortunate_soul.should_have_organ(O_BRAIN))
		brain.parent_organ = BP_TORSO //Move the brain to the torso.
		torso.internal_organs |= brain
	if(unfortunate_soul.should_have_organ(O_EYES))
		eyes.parent_organ = BP_TORSO //Move the eyes to the torso.
		torso.internal_organs |= eyes
	for(var/obj/item/organ/external/head/ex_organ in unfortunate_soul.organs)
		ex_organ.cannot_break = TRUE
		ex_organ.dislocated = -1
		ex_organ.nonsolid = TRUE
		ex_organ.spread_dam = TRUE
		ex_organ.max_damage = 5 //VERY fragile, now.
		ex_organ.vital = FALSE
		ex_organ.encased = FALSE
		ex_organ.cannot_gib = FALSE
		if(brain)
			ex_organ.internal_organs -= brain //Remove the brain from the head.
		if(eyes)
			ex_organ.internal_organs -= eyes

/datum/modifier/redspace_corruption/on_expire()
	REMOVE_TRAIT(unfortunate_soul, TRAIT_REDSPACE_CORRUPTED, UNHOLY_TRAIT)
	REMOVE_TRAIT(unfortunate_soul, UNIQUE_MINDSTRUCTURE, UNHOLY_TRAIT)
	unfortunate_soul = null

/datum/modifier/redspace_corruption/tick()
	//Handles resurrection and healing if dead.
	var/bellied = FALSE
	if(isbelly(unfortunate_soul.loc))
		bellied = TRUE
		var/mob/living/carbon/human/predator = unfortunate_soul.loc.loc
		if(istype(predator) && !predator.HasDisease(/datum/disease/fleshy_spread))
			var/datum/disease/fleshy_spread/flesh_disease = new /datum/disease/fleshy_spread()
			predator.ForceContractDisease(flesh_disease, BP_TORSO)

	if(unfortunate_soul.stat == DEAD)
		handle_death()
		return

	if(!armor_deployed && (unfortunate_soul.stunned || unfortunate_soul.weakened || unfortunate_soul.paralysis || unfortunate_soul.health < unfortunate_soul.getMaxHealth() * 0.75))
		if(assume_battle_stance())
			unfortunate_soul.adjustHalLoss(-200) //WAKE UP SAMURI
			unfortunate_soul.reagents.add_reagent(REAGENT_ID_ADRENALINE, 5)
			unfortunate_soul.reagents.add_reagent(REAGENT_ID_EPINEPHRINE, 5)
			unfortunate_soul.reagents.add_reagent(REAGENT_ID_NUMBENZYME, 1)
			to_chat(unfortunate_soul, span_large(span_bolddanger("Your body surges with adrenaline, and every cell ignites with a primal fight or flight. Your instincts are screaming through every fiber of your body: Escape the danger. Kill the threats. Protect your body. SURVIVE.")))
			return

	else if(unfortunate_soul.stat == UNCONSCIOUS)
		return

	if(bellied)
		return

	if(armor_deployed && ((armor_deployed_time + armor_duration) < world.time)) //Time ran out.

		//Are we still in panic mode?
		if(unfortunate_soul.stunned || unfortunate_soul.weakened || unfortunate_soul.paralysis || (unfortunate_soul.health < unfortunate_soul.maxHealth * 0.75))
			return
		else
			equip_flesh_armor(/obj/item/clothing/suit/space/changeling/armored, /obj/item/clothing/head/helmet/space/changeling/armored, /obj/item/clothing/shoes/magboots/changeling/armored, /obj/item/clothing/gloves/combat/changeling)
			armor_deployed = FALSE
		return
	//Stuff that happens when we're ALIVE.
	if(prob(blade_chance))
		//If we have an open hand and we have people near us, unsheath an armblade and face them.
		//This plays a BIG SCARY MESSAGE in chat and will make people panic.
		if(!unfortunate_soul.hands_are_full())
			if(attempt_armblade())
				return
	if(prob(injection_chance))
		var/list_of_humans = list()
		var/prick_message
		for(var/mob/living/carbon/human/target in oview(1, unfortunate_soul.loc))
			if(target.has_modifier_of_type(/datum/modifier/redspace_corruption)) //No cyclic injections!
				if(!prick_message)
					to_chat(unfortunate_soul, span_warning("Your body stealthily injects [target] but they seem unaffected."))
					to_chat(target, span_bolddanger("You feel a tiny prick."))
					prick_message = TRUE
				continue
			if(is_changeling(target))
				if(!prick_message)
					to_chat(unfortunate_soul, span_warning("Your body stealthily injects [target] but they seem unaffected."))
					to_chat(target, span_bolddanger("You feel a tiny prick."))
					prick_message = TRUE
				continue
			list_of_humans += target
		if(LAZYLEN(list_of_humans))
			var/mob/living/carbon/human/prey = pick(list_of_humans)
			if(!prey)
				return
			to_chat(prey, span_bolddanger("You feel a tiny prick."))
			prey.reagents.add_reagent(REAGENT_ID_ZOMBIEPOWDER, 5)
			if(!prey.HasDisease(/datum/disease/fleshy_spread))
				var/datum/disease/fleshy_spread/flesh_disease = new /datum/disease/fleshy_spread()
				prey.ForceContractDisease(flesh_disease)
			to_chat(unfortunate_soul, span_warning("[prey] walks too close to you, your body instinctually stinging them"))

	return

/datum/modifier/redspace_corruption/proc/handle_death()

	//Cooldown?

	if(armor_deployed && (armor_deployed_time + (armor_duration * 2)) < world.time) //Takes longer for armor to undeploy when dead.
		exit_battle_stance()

	if(heal_tick + heal_tick_cooldown > world.time)
		return

	var/obj/item/organ/internal/brain/brain = unfortunate_soul.internal_organs_by_name[O_BRAIN]
	if(unfortunate_soul.should_have_organ(O_BRAIN))
		if(!brain) //Removed the brain? Can't do anything.
			return

	var/obj/item/organ/internal/heart/heart = unfortunate_soul.internal_organs_by_name[O_HEART]
	if(!heart)
		return


	var/blood_volume = unfortunate_soul.vessel.get_reagent_amount(REAGENT_ID_BLOOD)
	var/lethal_blood = FALSE
	if(unfortunate_soul.reagents.get_reagent_amount(REAGENT_ID_MYELAMINE) < 5)
		unfortunate_soul.reagents.add_reagent(REAGENT_ID_MYELAMINE, 5) //Helps stabilize them.
	if(!heart || heart.is_broken())
		blood_volume *= 0.3
	else if(heart.is_bruised())
		blood_volume *= 0.7
	else if(heart.damage > 1)
		blood_volume *= 0.8
	if(blood_volume < unfortunate_soul.species.blood_volume*unfortunate_soul.species.blood_level_fatal)
		unfortunate_soul.reagents.add_reagent(REAGENT_ID_SYNTHBLOOD, 25) //Will get processed below.
		lethal_blood = TRUE

	//Circulate chems.
	for(var/i in 1 to 5)
		unfortunate_soul.handle_chemicals_in_body()
	unfortunate_soul.handle_organs()

	//Slowly come back from the dead.
	unfortunate_soul.heal_overall_damage(2, 2)
	unfortunate_soul.adjustToxLoss(-5)
	unfortunate_soul.adjustOxyLoss(-5)
	unfortunate_soul.adjustBrainLoss(-0.5)

	//Handle our organs. We might not heal entirely before we come back, but that's fine. If we die again, we come back again.
	for(var/obj/item/organ/I in unfortunate_soul.internal_organs)
		I.process()
		I.germ_level = max(0, I.germ_level - 25)
		I.damage = max(0, I.damage - 2.5)
		if(I.status & ORGAN_DEAD && (I.damage < I.is_broken()) && (I.germ_level < INFECTION_LEVEL_ONE)) //If we have any dead organs, try to revive them.
			I.status = 0

	for(var/obj/item/organ/external/limb in unfortunate_soul.bad_external_organs)
		limb.germ_level = max(0, limb.germ_level - 25)
		if(limb.status & ORGAN_DEAD && (limb.damage < limb.is_broken()) && (limb.germ_level < INFECTION_LEVEL_ONE)) //If we have any dead organs, try to revive them.
			limb.status = 0

	heal_tick = world.time

	//Big checks to see if there's a reason we CAN'T revive.
	if(time_since_revival + revival_cooldown > world.time) //On cooldown.
		return
	if(lethal_blood) //Blood volume is low enough we'd immediately die upon revival.
		return
	if(unfortunate_soul.health <= -(unfortunate_soul.getMaxHealth() * 0.33)) //Too injured to revive. We want to be a bit JUST before hardcrit.
		return
	if(unfortunate_soul.check_vital_organs()) //Missing a vital organ.
		return
	if(unfortunate_soul.teleop) //Aghosted or the sort.
		return
	if(!unfortunate_soul.mind) //Mind is gone.
		return


	//This won't get EVERYTHING, but if we end up reviving just to die shortly afterwards to heal up further, that's fine.

	//Time to revive! This FORCIBLY grabs their mind and puts it back in.
	revive()
	return

/datum/modifier/redspace_corruption/proc/revive()
	//Force us back into the body.
	unfortunate_soul.grab_ghost(TRUE)

	//Defib stuff here.
	GLOB.dead_mob_list.Remove(unfortunate_soul)
	if((unfortunate_soul in GLOB.living_mob_list) || (unfortunate_soul in GLOB.dead_mob_list))
		WARNING("Mob [unfortunate_soul] was revived but already in the living or dead list still!")
	GLOB.living_mob_list += unfortunate_soul
	unfortunate_soul.timeofdeath = 0
	unfortunate_soul.set_stat(UNCONSCIOUS) //Life() can bring them back to consciousness if it needs to.
	unfortunate_soul.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	unfortunate_soul.reload_fullscreen()

	//Awaken!
	unfortunate_soul.emote("gasp")
	unfortunate_soul.Weaken(rand(10,25))
	unfortunate_soul.updatehealth()
	time_since_revival = world.time

//Returns TRUE If we succeeded. FALSE if we failed.
/datum/modifier/redspace_corruption/proc/attempt_armblade()
	var/list_of_humans = list()
	for(var/mob/living/carbon/human/target in oview(4, unfortunate_soul.loc))
		if(target.has_modifier_of_type(/datum/modifier/redspace_corruption)) //Flesh knows flesh.
			continue
		if(is_changeling(target))
			continue
		list_of_humans += target
	if(LAZYLEN(list_of_humans))
		var/mob/person_to_stare_at_with_our_special_eyes = pick(list_of_humans)
		if(!person_to_stare_at_with_our_special_eyes)
			return FALSE
		deploy_armblade()
		unfortunate_soul.face_atom(person_to_stare_at_with_our_special_eyes)
		if(get_dist(unfortunate_soul, person_to_stare_at_with_our_special_eyes.loc) > 1)
			step_towards(unfortunate_soul, person_to_stare_at_with_our_special_eyes)
		if(get_dist(unfortunate_soul, person_to_stare_at_with_our_special_eyes.loc) > 1)
			step_towards(unfortunate_soul, person_to_stare_at_with_our_special_eyes)
		return TRUE
	return FALSE

/datum/modifier/redspace_corruption/proc/deploy_armblade()
	var/obj/item/melee/changeling/arm_blade/blade = new /obj/item/melee/changeling/arm_blade(unfortunate_soul)
	if(!unfortunate_soul.put_in_hands(blade))
		qdel(blade) //failed, sad.

//shamelessly stolen from changeling/armor.dm
/datum/modifier/redspace_corruption/proc/equip_flesh_armor(var/armor_type, var/helmet_type, var/boot_type, var/glove_type)

	var/mob/living/carbon/human/M = unfortunate_soul

	//First, check if we're already wearing the armor, and if so, take it off.
	if(istype(M.wear_suit, armor_type) || istype(M.head, helmet_type) || istype(M.shoes, boot_type) || istype(M.gloves, glove_type))
		M.visible_message(span_warning("[M] casts off their [M.wear_suit.name]!"),
		span_warning("We cast off our [M.wear_suit.name]"),
		span_warningplain("You hear the organic matter ripping and tearing!"))
		if(istype(M.wear_suit, armor_type))
			qdel(M.wear_suit)
		if(istype(M.head, helmet_type))
			qdel(M.head)
		if(istype(M.shoes, boot_type))
			qdel(M.shoes)
		if(istype(M.gloves, glove_type))
			qdel(M.gloves)
		M.update_inv_wear_suit()
		M.update_inv_head()
		M.update_hair()
		M.update_inv_shoes()
		M.update_inv_gloves()
		return TRUE

	var/obj/item/clothing/suit/A = new armor_type(M)
	if(M.wear_suit)
		M.unEquip(M.wear_suit, TRUE)
	M.equip_to_slot_or_del(A, slot_wear_suit)

	var/obj/item/clothing/suit/H = new helmet_type(M)
	if(M.head)
		M.unEquip(M.head, TRUE)
	M.equip_to_slot_or_del(H, slot_head)

	var/obj/item/clothing/shoes/B = new boot_type(M)
	if(M.shoes)
		M.unEquip(M.shoes, TRUE)
	M.equip_to_slot_or_del(B, slot_shoes)

	var/obj/item/clothing/gloves/G = new glove_type(M)
	if(M.gloves)
		M.unEquip(M.gloves, TRUE)
	M.equip_to_slot_or_del(G, slot_gloves)

	playsound(M, 'sound/effects/blobattack.ogg', 30, 1)
	M.update_inv_wear_suit()
	M.update_inv_head()
	M.update_hair()
	M.update_inv_shoes()
	M.update_inv_gloves()
	return TRUE

///Equips armor and melee weapon. If we succeed, returns TRUE. FALSE if we fail.
/datum/modifier/redspace_corruption/proc/assume_battle_stance()
	if(equip_flesh_armor(/obj/item/clothing/suit/space/changeling/armored,/obj/item/clothing/head/helmet/space/changeling/armored,/obj/item/clothing/shoes/magboots/changeling/armored, /obj/item/clothing/gloves/combat/changeling))
		to_chat(unfortunate_soul, span_warning("Your flesh shifts and hardens into a protective armor!"))
		armor_deployed = TRUE
		armor_deployed_time = world.time
		unfortunate_soul.drop_l_hand()
		unfortunate_soul.drop_r_hand()
		deploy_armblade()
		deploy_armblade()
		return TRUE
	return FALSE

/datum/modifier/redspace_corruption/proc/exit_battle_stance()
	if(armor_deployed)
		equip_flesh_armor(/obj/item/clothing/suit/space/changeling/armored, /obj/item/clothing/head/helmet/space/changeling/armored, /obj/item/clothing/shoes/magboots/changeling/armored, /obj/item/clothing/gloves/combat/changeling)
		armor_deployed = FALSE
		unfortunate_soul.drop_l_hand()
		unfortunate_soul.drop_r_hand()
