/obj/item/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/material/kitchen/utensil
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'
	w_class = ITEMSIZE_TINY
	thrown_force_divisor = 1
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = TRUE
	edge = TRUE
	/// 6 when wielded with hardness 60 (steel)
	force_divisor = 0.1
	/// 5 when thrown with weight 20 (steel)
	thrown_force_divisor = 0.25
	var/scoop_volume = 5
	/// Name for currently loaded food object. Becomes a holder reference if there's a micro
	var/loaded
	/// Color for currently loaded food object.
	var/loaded_color
	/// Micros in the inventory, should be just the holder but...
	var/list/food_inserted_micros

/obj/item/material/kitchen/utensil/Initialize(mapload)
	. = ..()
	if (prob(60))
		pixel_y = rand(0, 4)
	create_reagents(scoop_volume)

/obj/item/material/kitchen/utensil/Destroy()
	if(loaded && isholder(loaded))
		var/obj/item/holder/held = loaded
		held.dump_mob()
	if(food_inserted_micros)
		for(var/mob/creature in food_inserted_micros)
			container_resist(creature, FALSE)
	. = ..()
	return

/obj/item/material/kitchen/utensil/update_icon()
	. = ..()
	cut_overlays()
	if(loaded)
		if(isholder(loaded))
			//show the micro on our utensil
			var/obj/item/holder/held = loaded
			var/icon/micro_icon = icon(held)
			var/mutable_appearance/micro_overlay = mutable_appearance(icon, micro_icon)
			micro_overlay.pixel_y = 6
			add_overlay(micro_overlay)
		else
			var/image/I = new(icon, "loadedfood")
			I.color = loaded_color
			add_overlay(I)

/obj/item/material/kitchen/utensil/proc/load_food(mob/user, obj/item/reagent_containers/food/snacks/loading)
	if(user.loc == loading)
		to_chat(user, span_warning("You resist the urge to recusively scoop your location."))
		return
	if (reagents.total_volume > 0 || loaded)
		to_chat(user, span_danger("There is already something on \the [src]."))
		return
	if (!loading?.reagents?.total_volume)
		to_chat(user, span_notice("Nothing to scoop up in \the [loading]!"))

	loaded = "\the [loading]"
	user.visible_message( \
		span_infoplain(span_bold("\The [user]") + " scoops up some of [loaded] with \the [src]!"),
		span_notice("You scoop up some of [loaded] with \the [src]!")
	)
	loading.bitecount++
	loading.reagents.trans_to_obj(src, min(loading.reagents.total_volume, scoop_volume))
	loaded_color = loading.filling_color

	if(loading)
		for(var/mob/living/micro in loading.food_inserted_micros)
			var/do_transfer = FALSE

			if(!loading.reagents.total_volume)
				do_transfer = TRUE
			else
				var/transfer_chance = (loading.bitecount/(loading.bitecount + (loading.bitesize / loading.reagents.total_volume) + 1))*100
				if(prob(transfer_chance))
					do_transfer = TRUE

			if(do_transfer)
				micro.forceMove(src)
				LAZYREMOVE(loading.food_inserted_micros, micro)
				LAZYADD(food_inserted_micros, micro)

	if (loading.reagents.total_volume <= 0)
		qdel(loading)
	update_icon()

/obj/item/material/kitchen/utensil/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(loaded || food_inserted_micros)
		user.visible_message(span_notice("\The [user] dumps something off from the [src]."))
		on_rag_wipe()

/obj/item/material/kitchen/utensil/attack(mob/living/carbon/creature, mob/living/user, target_zone, attack_modifier)
	if(!istype(creature))
		return ..()

	if(creature == user && user.loc == src)
		return container_resist(user)

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == BP_HEAD || user.zone_sel.selecting == O_EYES)
			if(CLUMSY_HARM_CHANCE(user))
				creature = user
			return eyestab(creature,user)
		else
			return ..()

	if(creature != user)
		if(!user.check_for_scoopable(creature))
			return ITEM_INTERACT_FAILURE
		creature.visible_message(span_bold("\The [user]") + " scoops [creature] up with \the [src].")
		//using the holder for overlay nonsense
		var/obj/item/holder/held = new creature.holder_type(get_turf(user), creature)
		held.sync(creature)
		//we would add the micro to the food list but the holder handles stuff a lot better.
		loaded = held
		update_icon()
		//we've picked someone up, count it just like we would food
		return ITEM_INTERACT_SUCCESS

	if(loaded)
		if(!standard_feed_mob(user, creature))
			return ITEM_INTERACT_FAILURE
		if(reagents)
			if(!creature.consume_liquid_belly && liquid_belly_check())
				to_chat(user, span_vdanger("[user == creature ? "you can't" : "\The [creature] can't"] consume that, it contains something produced from a belly!"))
				return ITEM_INTERACT_FAILURE
			reagents.trans_to_mob(creature, reagents.total_volume, CHEM_INGEST)
		if(isholder(loaded))
			var/obj/item/holder/held = loaded
			for(var/mob/living/micro in held.contents)
				if(!can_food_vore(creature, micro))
					micro.forceMove(get_turf(creature))
				else
					creature.vore_selected.nom_atom(micro)
		if(food_inserted_micros)
			for(var/mob/living/micro in food_inserted_micros)
				LAZYREMOVE(food_inserted_micros, micro)
				if(!can_food_vore(creature, micro))
					micro.forceMove(get_turf(creature))
				else
					creature.vore_selected.nom_atom(micro)
		if(creature == user)
			if(!creature.can_eat(loaded))
				return ITEM_INTERACT_FAILURE
			creature.visible_message(span_bold("\The [user]") + " eats some of [loaded] with \the [src].")
			var/fullness = creature.nutrition + (creature.reagents.get_reagent_amount(REAGENT_ID_NUTRIMENT) * 25)
			if (fullness <= 50)
				to_chat(creature, span_danger("You nearly swallow the whole [src] in your ravanous hunger!"))
			if (fullness > 50 && fullness <= 150)
				to_chat(creature, span_notice("You hungrily dump the contents of [src] into your gob."))
			if (fullness > 150 && fullness <= 1000)
				to_chat(creature, span_notice("You take a bite from [src]."))
			if (fullness > 1000 && fullness <= 3000)
				to_chat(creature, span_notice("You force another mouthful from [src]."))
			if (fullness > 3000 && fullness <= 5500)
				to_chat(creature, span_danger("You wince as you take another unwilling bite from [src]. You can feel your stomach getting firm as it reaches its limits."))
			if (fullness > 5500 && fullness <= 6000)
				to_chat(creature, span_danger("You glug down the bite from [src], you are reaching the very limits of what you can eat, but maybe a few more bites could be managed..."))
			if (fullness > 6000) // There has to be a limit eventually.
				to_chat(creature, span_danger("Nope. That's it. You literally cannot take another bite, not even a wafer thin mint."))
				return ITEM_INTERACT_FAILURE
		else
			user.visible_message(span_warning("\The [user] begins to feed \the [creature]!"))
			if(!(creature.can_force_feed(user, loaded) && do_after(user, 5 SECONDS, creature)))
				return ITEM_INTERACT_FAILURE
			creature.visible_message(span_bold("\The [user]") + " feeds some of [loaded] to \the [creature] with \the [src].")
		playsound(src,'sound/items/eatfood.ogg', rand(10,40), 1)
		loaded = null
		update_icon()
		return ITEM_INTERACT_SUCCESS

	else
		to_chat(user, span_warning("You don't have anything on \the [src]."))	//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK
		return ITEM_INTERACT_FAILURE

/obj/item/material/kitchen/utensil/on_rag_wipe()
	. = ..()
	if(reagents.total_volume > 0)
		reagents.clear_reagents()
	//handle the holder
	if(loaded && isholder(loaded))
		var/obj/item/holder/held = loaded
		held.dump_mob()
	//handle 'hidden' micros from food transferring
	if(food_inserted_micros)
		for(var/mob/creature in food_inserted_micros)
			container_resist(creature, FALSE)
	loaded = null
	cut_overlays()
	return

/obj/item/material/kitchen/utensil/examine()
	if(isholder(loaded))
		. += span_notice("It has [loaded] stuck in it.")
	if(food_inserted_micros)
		. += span_notice("It has [english_list(food_inserted_micros)] stuck in it.")

/obj/item/material/kitchen/utensil/container_resist(mob/living/micro, willingly = TRUE)
	if(isdisposalpacket(loc))
		micro.forceMove(loc)
	else
		micro.forceMove(get_turf(src))

	if(willingly)
		to_chat(micro, span_warning("You climb off of \the [src]."))
	else
		to_chat(micro, span_warning("You're dumped off of \the [src]."))
	LAZYREMOVE(food_inserted_micros, micro)

/obj/item/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"
	sharp = TRUE
	edge = FALSE

/obj/item/material/kitchen/utensil/fork/plastic
	default_material = MAT_PLASTIC

/obj/item/material/kitchen/utensil/foon
	name = "foon"
	desc = "It's a foon. The forgotten cousin of the spork."
	icon_state = "foon"
	sharp = TRUE
	edge = FALSE

/obj/item/material/kitchen/utensil/foon/plastic
	default_material = MAT_PLASTIC

/obj/item/material/kitchen/utensil/spork
	name = "spork"
	desc = "It's a spork. The (un)holy merger of a spoon and fork."
	icon_state = "spork"
	sharp = TRUE
	edge = FALSE

/obj/item/material/kitchen/utensil/spork/plastic
	default_material = MAT_PLASTIC

/obj/item/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")
	edge = FALSE
	sharp = FALSE
	force_divisor = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/material/kitchen/utensil/spoon/plastic
	default_material = MAT_PLASTIC

/*
 * Knives
 */

/* From the time of Clowns. Commented out for posterity, and sanity.
/obj/item/material/knife/attack(target as mob, mob/living/user as mob)
	if (CLUMSY_HARM_CHANCE(user))
		to_chat(user, span_warning("You accidentally cut yourself with \the [src]."))
		user.take_organ_damage(20)
		return
	return ..()
*/
/obj/item/material/knife/plastic
	default_material = MAT_PLASTIC

/*
 * Rolling Pins
 */

/obj/item/material/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the " + JOB_BARTENDER+ "."
	icon_state = "rolling_pin"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	default_material = MAT_WOOD
	force_divisor = 0.7 // 10 when wielded with weight 15 (wood)
	dulled_divisor = 0.75	// Still a club
	thrown_force_divisor = 1 // as above
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/material/kitchen/rollingpin/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(CLUMSY_HARM_CHANCE(user))
		to_chat(user, span_warning("\The [src] slips out of your hand and hits your head."))
		user.take_organ_damage(10)
		user.Paralyse(2)
		return ITEM_INTERACT_SUCCESS
	return ..()
