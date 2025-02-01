// Small creatures that will embed themselves in unsuspecting victim's bodies, drink their blood, and/or eat their organs. Steals some things from borers.

/datum/category_item/catalogue/fauna/iceleech
	name = "Sivian Fauna - River Leech"
	desc = "Classification: S Hirudinea phorus \
	<br><br>\
	An incredibly dangerous species of worm phorogenically mutated from a Sivian river leech, \
	believed to have resulted from corporate mining in the Ullran Expanse; these accusations are \
	unfounded, however speculation remains.\
	<br>\
	The creatures' heads hold four long prehensile tendrils surrounding a central beak, which are \
	used as locomotive and grappling appendages. Each is capped in a hollow tooth, capable of pumping \
	chemicals into an unsuspecting host. \
	<br>\
	The rear half of the creature is entirely musculature, capped with a sharp, arrowhead-shaped fin."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/sif/leech
	name = "river leech"
	desc = "What appears to be an oversized leech."
	tt_desc = "S Hirudinea phorus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/iceleech)

	faction = FACTION_LEECH

	icon_state = "leech"
	item_state = "brainslug"
	icon_living = "leech"
	icon_dead = "leech_dead"
	icon = 'icons/mob/animal.dmi'

	density = FALSE	// Non-dense, so things can pass over them.

	status_flags = CANPUSH
	pass_flags = PASSTABLE

	maxHealth = 100
	health = 100

	universal_understand = 1

	special_attack_min_range = 0
	special_attack_max_range = 1

	var/obj/item/organ/external/host_bodypart	// Where in the body we are infesting.
	var/docile = FALSE
	var/chemicals = 0
	var/max_chemicals = 400
	var/list/bodypart_targets = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN,BP_HEAD)
	var/infest_target = BP_TORSO	// The currently chosen bodypart to infest.
	var/mob/living/carbon/host		// Our humble host.
	var/list/produceable_chemicals = list(REAGENT_ID_INAPROVALINE,REAGENT_ID_ANTITOXIN,REAGENT_ID_ALKYSINE,REAGENT_ID_BICARIDINE,REAGENT_ID_TRAMADOL,REAGENT_ID_KELOTANE,REAGENT_ID_LEPORAZINE,REAGENT_ID_IRON,REAGENT_ID_PHORON,REAGENT_ID_CONDENSEDCAPSAICINV,REAGENT_ID_FROSTOIL)
	var/randomized_reagent = REAGENT_ID_IRON	// The reagent chosen at random to be produced, if there's no one piloting the worm.
	var/passive_reagent = REAGENT_ID_PARACETAMOL	// Reagent passively produced by the leech. Should usually be a painkiller.

	var/feeding_delay = 30 SECONDS	// How long do we have to wait to bite our host's organs?
	var/last_feeding = 0

	a_intent = I_HELP

	holder_type = /obj/item/holder/leech

	movement_cooldown = -2
	aquatic_movement = -2

	melee_damage_lower = 1
	melee_damage_upper = 5
	attack_armor_pen = 15
	attack_sharp = TRUE
	attacktext = list("nipped", "bit", "pinched")

	organ_names = /decl/mob_organ_names/leech

	armor = list(
		"melee" = 10,
		"bullet" = 15,
		"laser" = -10,
		"energy" = 0,
		"bomb" = 10,
		"bio" = 100,
		"rad" = 100
		)

	armor_soak = list(
		"melee" = 5,
		"bullet" = 5,
		"laser" = 0,
		"energy" = 0,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 0
		)

	say_list_type = /datum/say_list/leech
	ai_holder_type = /datum/ai_holder/simple_mob/intentional/leech

/mob/living/simple_mob/animal/sif/leech/IIsAlly(mob/living/L)
	. = ..()

	var/mob/living/carbon/human/H = L
	if(!istype(H))
		return .

	if(istype(L.buckled, /obj/vehicle) || L.hovering || L.flying) // Ignore people hovering or on boats.
		return TRUE

	if(!.)
		var/has_organ = FALSE
		var/obj/item/organ/internal/O = H.get_active_hand()
		if(istype(O) && O.robotic < ORGAN_ROBOT && !(O.status & ORGAN_DEAD))
			has_organ = TRUE
		return has_organ

/datum/say_list/leech
	speak = list("...", "Sss..", ". . .","Gss..")
	emote_see = list("vibrates","looks around", "stares", "extends a proboscis")
	emote_hear = list("chitters", "clicks", "gurgles")

/mob/living/simple_mob/animal/sif/leech/Initialize()
	. = ..()

	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)

/mob/living/simple_mob/animal/sif/leech/get_status_tab_items()
	. = ..()
	. += "Chemicals: [chemicals]"

/mob/living/simple_mob/animal/sif/leech/do_special_attack(atom/A)
	. = TRUE
	if(istype(A, /mob/living/carbon))
		switch(a_intent)
			if(I_DISARM) // Poison
				set_AI_busy(TRUE)
				poison_inject(src, A)
				set_AI_busy(FALSE)
			if(I_GRAB) // Infesting!
				set_AI_busy(TRUE)
				do_infest(src, A)
				set_AI_busy(FALSE)

/mob/living/simple_mob/animal/sif/leech/handle_special()
	if(prob(5))
		randomized_reagent = pick(produceable_chemicals)

	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/floor/water) && src.loc == T && !stat)	// Are we sitting in water, and alive?
		alpha = max(5, alpha - 10)
		if(chemicals + 1 < max_chemicals / 3)
			chemicals++
	else
		alpha = min(255, alpha + 20)

	if(!client && !host)
		infest_target = pick(bodypart_targets)

	if(host && !stat && !host.stat)
		if(ai_holder)
			ai_holder.hostile = FALSE
			ai_holder.lose_target()
		alpha = 5
		if(host.reagents.has_reagent(REAGENT_ID_CORDRADAXON) && !docile)	// Overwhelms the leech with food.
			var/message = "We feel the rush of cardiac pluripotent cells in your host's blood, lulling us into docility."
			to_chat(src, span_warning(message))
			docile = TRUE
			if(chemicals + 5 <= max_chemicals)
				chemicals += 5

		else if(docile)
			var/message = "We shake off our lethargy as the pluripotent cell count declines in our host's blood."
			to_chat(src, span_notice(message))
			docile = FALSE

		if(!host.reagents.has_reagent(passive_reagent))
			host.reagents.add_reagent(passive_reagent, 5)
			chemicals -= 3

		if(!docile && ishuman(host) && chemicals < max_chemicals)
			var/mob/living/carbon/human/H = host
			H.remove_blood(1)
			if(!H.reagents.has_reagent(REAGENT_ID_INAPROVALINE))
				H.reagents.add_reagent(REAGENT_ID_INAPROVALINE, 1)
			chemicals += 2

		if(!client && !docile)	// Automatic 'AI' to manage damage levels.
			if(host.getBruteLoss() >= 30 && chemicals > 50)
				host.reagents.add_reagent(REAGENT_ID_BICARIDINE, 5)
				chemicals -= 30

			if(host.getToxLoss() >= 30 && chemicals > 50)
				var/randomchem = pickweight(list(REAGENT_ID_TRAMADOL = 7, REAGENT_ID_ANTITOXIN = 15, REAGENT_ID_FROSTOIL = 3))
				host.reagents.add_reagent(randomchem, 5)
				chemicals -= 50

			if(host.getFireLoss() >= 30 && chemicals > 50)
				host.reagents.add_reagent(REAGENT_ID_KELOTANE, 5)
				host.reagents.add_reagent(REAGENT_ID_LEPORAZINE, 2)
				chemicals -= 50

			if(host.getOxyLoss() >= 30 && chemicals > 50)
				host.reagents.add_reagent(REAGENT_ID_IRON, 10)
				chemicals -= 40

			if(host.getBrainLoss() >= 10 && chemicals > 100)
				host.reagents.add_reagent(REAGENT_ID_ALKYSINE, 5)
				host.reagents.add_reagent(REAGENT_ID_TRAMADOL, 3)
				chemicals -= 100

			if(prob(30) && chemicals > 50)
				inject_meds(randomized_reagent)

			var/heartless_mod = 0
			if(ishuman(host))	// Species without hearts mean the worm gets hungry faster, if AI controlled.
				var/mob/living/carbon/human/H = host
				if(!H.species.has_organ[O_HEART])
					heartless_mod = 1

			if(prob(15 + (20 * heartless_mod)))
				feed_on_organ()
	else
		if(ai_holder)
			ai_holder.hostile = initial(ai_holder.hostile)

	if(host && host.stat == DEAD && istype(get_turf(host), /turf/simulated/floor/water))
		leave_host()

/mob/living/simple_mob/animal/sif/leech/verb/infest()
	set category = "Abilities.Leech"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(docile)
		to_chat(src, span_alium("We are too tired to do this..."))
		return

	do_infest(src)

/mob/living/simple_mob/animal/sif/leech/proc/do_infest(var/mob/living/user, var/mob/living/target = null)
	if(host)
		to_chat(user, span_alien("We are already within a host."))
		return

	if(stat)
		to_chat(user, span_warning("We cannot infest a target in your current state."))
		return

	var/mob/living/carbon/M = target

	if(!M && src.client)
		var/list/choices = list()
		for(var/mob/living/carbon/C in view(1,src))
			if(src.Adjacent(C))
				choices += C

		if(!choices.len)
			to_chat(user, span_warning("There are no viable hosts within range..."))
			return

		M = tgui_input_list(src, "Who do we wish to infest?", "Target Choice", choices)

	if(!M || !src) return

	if(!(src.Adjacent(M))) return

	if(!istype(M) || M.isSynthetic())
		to_chat(user, "\The [M] cannot be infested.")
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/obj/item/organ/external/E = H.organs_by_name[infest_target]
		if(!E || E.is_stump() || E.robotic >= ORGAN_ROBOT)
			to_chat(src,"\The [H] does not have an infestable [infest_target]!")

		var/list/covering_clothing = E.get_covering_clothing()
		for(var/obj/item/clothing/C in covering_clothing)
			if(C.armor["melee"] >= 20 + attack_armor_pen)
				to_chat(user, span_notice("We cannot get through that host's protective gear."))
				return

	if(!do_after(src,2))
		to_chat(user, span_notice("As [M] moves away, we are dislodged and fall to the ground."))
		return

	if(!M || !src)
		return

	if(src.stat)
		to_chat(user, span_warning("We cannot infest a target in your current state."))
		return

	if(M in view(1, src))
		to_chat(user,span_alien("We burrow into [M]'s flesh."))
		if(!M.stat)
			to_chat(M, span_critical("You feel a sharp pain as something digs into your flesh!"))

		src.host = M
		src.forceMove(M)
		if(ai_holder)
			ai_holder.hostile = FALSE
			ai_holder.lose_target()

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			host_bodypart = H.get_organ(infest_target)
			host_bodypart.implants |= src

		return
	else
		to_chat(user, span_notice("They are no longer in range."))
		return

/mob/living/simple_mob/animal/sif/leech/verb/uninfest()
	set category = "Abilities.Leech"
	set name = "Uninfest"
	set desc = "Leave your current host."

	if(docile)
		to_chat(src, span_alium("We are too tired to do this..."))
		return

	leave_host()

/mob/living/simple_mob/animal/sif/leech/proc/leave_host()
	if(!host)
		return

	host_bodypart.implants -= src
	host_bodypart = null

	forceMove(get_turf(host))

	reset_view(null)

	host = null

/mob/living/simple_mob/animal/sif/leech/verb/inject_victim()
	set category = "Abilities.Leech"
	set name = "Incapacitate Potential Host"
	set desc = "Inject an organic host with an incredibly painful mixture of chemicals."

	if(docile)
		to_chat(src, span_alium("We are too tired to do this..."))
		return

	var/mob/living/carbon/M
	if(src.client)
		var/list/choices = list()
		for(var/mob/living/carbon/C in view(1,src))
			if(src.Adjacent(C))
				choices += C

		if(!choices.len)
			to_chat(src, span_warning("There are no viable hosts within range..."))
			return

		M = tgui_input_list(src, "Who do we wish to inject?", "Target Choice", choices)

	if(!M || stat)
		return

	poison_inject(src, M)

/mob/living/simple_mob/animal/sif/leech/proc/poison_inject(var/mob/living/user, var/mob/living/carbon/L)
	if(!L || !Adjacent(L) || stat)
		return

	var/mob/living/carbon/human/H = L

	if(!istype(H) || H.isSynthetic())
		to_chat(user, span_warning("You cannot inject this target..."))

	var/obj/item/organ/external/E = H.organs_by_name[infest_target]
	if(!E || E.is_stump() || E.robotic >= ORGAN_ROBOT)
		to_chat(src,"\The [H] does not have an infestable [infest_target]!")

	var/list/covering_clothing = E.get_covering_clothing()
	for(var/obj/item/clothing/C in covering_clothing)
		if(C.armor["melee"] >= 40 + attack_armor_pen)
			to_chat(user, span_notice("You cannot get through that host's protective gear."))
			return

	H.add_modifier(/datum/modifier/poisoned/paralysis, 15 SECONDS)

/mob/living/simple_mob/animal/sif/leech/verb/medicate_host()
	set category = "Abilities.Leech"
	set name = "Produce Chemicals (50)"
	set desc = "Inject your host with possibly beneficial chemicals, to keep the blood flowing."

	if(docile)
		to_chat(src, span_alium("We are too tired to do this..."))
		return

	if(!host || chemicals <= 50)
		to_chat(src, span_alien("We cannot produce any chemicals right now."))
		return

	if(host)
		var/chem = tgui_input_list(src, "Select a chemical to produce.", "Chemicals", produceable_chemicals)
		inject_meds(chem)

/mob/living/simple_mob/animal/sif/leech/proc/inject_meds(var/chem)
	if(host)
		chemicals = max(1, chemicals - 50)
		host.reagents.add_reagent(chem, 5)
		to_chat(src, span_alien("We injected \the [host] with five units of [chem]."))

/mob/living/simple_mob/animal/sif/leech/verb/feed_on_organ()
	set category = "Abilities.Leech"
	set name = "Feed on Organ"
	set desc = "Extend probosci to feed on a piece of your host's organs."

	if(docile)
		to_chat(src, span_alium("We are too tired to do this..."))
		return

	if(host && world.time >= last_feeding + feeding_delay)
		var/list/host_internal_organs = host.internal_organs

		for(var/obj/item/organ/internal/O in host_internal_organs)	// Remove organs with maximum damage.
			if(O.damage >= O.max_damage)
				host_internal_organs -= O

		var/target
		if(client)
			target = tgui_input_list(src, "Select an organ to feed on.", "Organs", host_internal_organs)
			if(!target)
				to_chat(src, span_alien("We decide not to feed."))
				return

		if(!target)
			target = pick(host_internal_organs)

		if(target)
			bite_organ(target)

	else
		to_chat(src, span_warning("We cannot feed now."))

/mob/living/simple_mob/animal/sif/leech/proc/bite_organ(var/obj/item/organ/internal/O)
	last_feeding = world.time

	if(O)
		to_chat(src, span_alien("We feed on [O]."))
		O.take_damage(2,silent=prob(10))
		chemicals = min(max_chemicals, chemicals + 60)
		host.add_modifier(/datum/modifier/grievous_wounds, 60 SECONDS)
		adjustBruteLoss(rand(-10,-60))
		adjustFireLoss(rand(-10,-60))

/datum/ai_holder/simple_mob/intentional/leech
	hostile = TRUE
	retaliate = TRUE
	vision_range = 3
	mauling = TRUE
	returns_home = TRUE
	can_flee = TRUE
	home_low_priority = TRUE	// If we've got a target, we're going for them.
	max_home_distance = 1	// Low to ensure the creature doesn't leave the water unless it has a host.

/datum/ai_holder/simple_mob/intentional/leech/handle_special_strategical()
	var/mob/living/simple_mob/animal/sif/leech/SL = holder
	if(!SL.host && !istype(get_turf(SL), /turf/simulated/floor/water))
		var/list/nearby_water = list()
		for(var/turf/simulated/floor/water/W in view(holder, 10))
			nearby_water |= W
		if(nearby_water && nearby_water.len)
			var/turf/T = pick(nearby_water)
			if(T && can_attack(T))
				home_turf = T

/datum/ai_holder/simple_mob/intentional/leech/special_flee_check()
	var/mob/living/simple_mob/animal/sif/leech/SL = holder

	if(!SL.host && !istype(get_turf(SL), /turf/simulated/floor/water))
		return TRUE

/datum/ai_holder/simple_mob/intentional/leech/pre_special_attack(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(ishuman(L) && !L.isSynthetic())
			if(L.incapacitated() || (L.stat && L.stat != DEAD) || L.resting || L.paralysis)
				holder.a_intent = I_GRAB		// Infesting time.
			else
				holder.a_intent = I_DISARM	// They're standing up! Try to drop or stun them.
		else
			holder.a_intent = I_HURT		// Otherwise, bite.

	else if(istype(A, /obj/item))
		var/obj/item/I = A
		if(istype(I, /obj/item/reagent_containers/food/snacks))
			holder.a_intent = I_HURT
	else
		holder.a_intent = I_HURT

/decl/mob_organ_names/leech
	hit_zones = list("mouthparts", "central segment", "tail segment")
