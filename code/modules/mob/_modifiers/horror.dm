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
	/area/redgate
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

/datum/modifier/redspace_drain/proc/choose_organs()
	var/organs_to_replace = rand(2,3)
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
