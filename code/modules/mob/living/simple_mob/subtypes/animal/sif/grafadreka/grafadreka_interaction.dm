/// Behaviors for being booped by drakes. If falsy, falls through to other behaviors.
/atom/proc/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/drake)
	return


/* Simple drake interactions */

/obj/structure/simple_door/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/drake)
	. = TRUE
	if (drake.a_intent == I_HURT)
		return ..()
	if (!state && !isSwitchingStates)
		Open()


/obj/structure/loot_pile/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/drake)
	. = TRUE
	if (drake.a_intent == I_HURT)
		return ..()
	attack_hand(drake)


/obj/structure/boulder/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/drake)
	. = TRUE
	drake.visible_message(
		SPAN_ITALIC("\The [drake] claws away at \a [src]."),
		SPAN_ITALIC("You dig industriously at \the [src]."),
		range = 5
	)
	if (!do_after(drake, 2 SECONDS, src))
		return
	excavation_level += rand(25, 50)
	if (excavation_level < 100)
		to_chat(drake, SPAN_WARNING("\The [src] withstands your attempts - this time."))
		return
	visible_message(
		SPAN_WARNING("\The [src] crumbles away to debris."),
		range = 5
	)
	qdel(src)


/obj/item/bikehorn/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/drake)
	. = TRUE
	if (drake.a_intent != I_HELP)
		return ..()
	if (!do_after(drake, 1 SECOND, src))
		return
	drake.visible_message(
		SPAN_ITALIC("\The [drake] gnaws on \a [src]."),
		SPAN_ITALIC("You gnaw on \the [src]."),
		range = 5
	)
	attack_self(drake)


/* Trained drake interactions */

/mob/living/simple_mob/animal/sif/grafadreka/trained/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/drake)
	if (drake == src && a_intent == I_GRAB)
		DropItem()
		return TRUE
	return ..()


/obj/item/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/trained/drake)
	if (drake.trained_drake && drake.a_intent == I_GRAB)
		drake.CollectItem(src)
		return TRUE


/obj/machinery/button/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/trained/drake)
	. = TRUE
	if (!drake.trained_drake || drake.a_intent == I_HURT)
		return ..()
	var/datum/gender/gender = gender_datums[drake.get_visible_gender()]
	drake.visible_message(
		SPAN_ITALIC("\The [drake] stands up awkwardly on [gender.his] hind legs and paws at \a [src]."),
		SPAN_ITALIC("You rear up, attempting to push \the [src] with your foreclaws."),
		SPAN_WARNING("You hear something scratching and scrabbling."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(drake, 5 SECONDS, src))
		return
	to_chat(drake, SPAN_NOTICE("After some effort, you manage to push \the [src]."))
	attack_hand(drake)


/obj/machinery/access_button/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/trained/drake)
	. = TRUE
	if (!drake.trained_drake || drake.a_intent == I_HURT)
		return ..()
	var/datum/gender/gender = gender_datums[drake.get_visible_gender()]
	drake.visible_message(
		SPAN_ITALIC("\The [drake] stands up awkwardly on [gender.his] hind legs and paws at \a [src]."),
		SPAN_ITALIC("You rear up, attempting to push \the [src] with your foreclaws."),
		SPAN_WARNING("You hear something scratching and scrabbling."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(drake, 5 SECONDS, src))
		return
	to_chat(drake, SPAN_NOTICE("After some effort, you manage to push \the [src]."))
	attack_hand(drake)


/obj/machinery/firealarm/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/trained/drake)
	. = TRUE
	if (!drake.trained_drake || drake.a_intent == I_HURT)
		return ..()
	var/datum/gender/gender = gender_datums[drake.get_visible_gender()]
	drake.visible_message(
		SPAN_ITALIC("\The [drake] stands up awkwardly on [gender.his] hind legs and paws at \a [src]."),
		SPAN_ITALIC("You rear up, attempting to push \the [src] with your foreclaws."),
		SPAN_WARNING("You hear something scratching and scrabbling."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(drake, 5 SECONDS, src))
		return
	to_chat(drake, SPAN_NOTICE("After some effort, you manage to push \the [src]."))
	attack_hand(src)


/obj/machinery/conveyor_switch/interaction_grafadreka(mob/living/simple_mob/animal/sif/grafadreka/trained/drake)
	. = TRUE
	if (!drake.trained_drake || drake.a_intent == I_HURT)
		return ..()
	visible_message(
		SPAN_ITALIC("\The [drake] pushes bodily against \a [src]."),
		SPAN_ITALIC("You press your shoulder into \the [src], trying to change its direction."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(drake, 2 SECONDS, src))
		return
	to_chat(drake, SPAN_NOTICE("After some effort, you manage to push \the [src]."))
	attack_hand(drake)
