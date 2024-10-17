/mob
	var/bloody_hands = 0
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0
	var/list/feet_blood_DNA
	var/track_blood_type
	var/feet_blood_color

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes/
	var/track_blood = 0

/obj/item/reagent_containers/glass/rag
	name = "rag"
	desc = "For cleaning up messes, you suppose."
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 10
	can_be_placed_into = null
	flags = OPENCONTAINER | NOBLUDGEON
	unacidable = FALSE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

	var/on_fire = 0
	var/burn_time = 20 //if the rag burns for too long it turns to ashes

/obj/item/reagent_containers/glass/rag/Initialize()
	. = ..()
	update_name()

/obj/item/reagent_containers/glass/rag/Destroy()
	STOP_PROCESSING(SSobj, src) //so we don't continue turning to ash while gc'd
	return ..()

/obj/item/reagent_containers/glass/rag/attack_self(mob/user as mob)
	if(on_fire)
		user.visible_message(span_warning("\The [user] stamps out [src]."), span_warning("You stamp out [src]."))
		user.unEquip(src)
		extinguish()
	else
		remove_contents(user)

/obj/item/reagent_containers/glass/rag/attackby(obj/item/W, mob/user)
	if(!on_fire && istype(W, /obj/item/flame))
		var/obj/item/flame/F = W
		if(F.lit)
			src.ignite()
			if(on_fire)
				visible_message(span_warning("\The [user] lights [src] with [W]."))
			else
				to_chat(user, span_warning("You manage to singe [src], but fail to light it."))

	. = ..()
	update_name()

/obj/item/reagent_containers/glass/rag/proc/update_name()
	if(on_fire)
		name = "burning [initial(name)]"
	else if(reagents.total_volume)
		name = "damp [initial(name)]"
	else
		name = "dry [initial(name)]"

/obj/item/reagent_containers/glass/rag/update_icon()
	if(on_fire)
		icon_state = "raglit"
	else
		icon_state = "rag"

	var/obj/item/reagent_containers/food/drinks/bottle/B = loc
	if(istype(B))
		B.update_icon()

/obj/item/reagent_containers/glass/rag/proc/remove_contents(mob/user, atom/trans_dest = null)
	if(!trans_dest && !user.loc)
		return

	if(reagents.total_volume)
		var/target_text = trans_dest? "\the [trans_dest]" : "\the [user.loc]"
		user.visible_message(span_danger("\The [user] begins to wring out [src] over [target_text]."), span_notice("You begin to wring out [src] over [target_text]."))

		if(do_after(user, reagents.total_volume*5)) //50 for a fully soaked rag
			if(trans_dest)
				reagents.trans_to(trans_dest, reagents.total_volume)
			else
				reagents.splash(user.loc, reagents.total_volume)
			user.visible_message(span_danger("\The [user] wrings out [src] over [target_text]."), span_notice("You finish to wringing out [src]."))
			update_name()

/obj/item/reagent_containers/glass/rag/proc/wipe_down(atom/A, mob/user)
	if(!reagents.total_volume)
		to_chat(user, span_warning("The [initial(name)] is dry!"))
	else
		user.visible_message("[user] starts to wipe [A] with [src].")
		update_name()
		if(do_after(user,30))
			user.visible_message("[user] finishes wiping [A]!")
			A.on_rag_wipe(src)

/obj/item/reagent_containers/glass/rag/attack(atom/target as obj|turf|area, mob/user as mob , flag)
	if(isliving(target)) //Leaving this as isliving.
		var/mob/living/M = target
		if(on_fire) //Check if rag is on fire, if so igniting them and stopping.
			user.visible_message(span_danger("\The [user] hits [target] with [src]!"),)
			user.do_attack_animation(src)
			M.IgniteMob()
		else if(user.zone_sel.selecting == O_MOUTH) //Check player target location, provided the rag is not on fire. Then check if mouth is exposed.
			if(ishuman(target)) //Added this since player species process reagents in majority of cases.
				var/mob/living/carbon/human/H = target
				if(H.head && (H.head.body_parts_covered & FACE)) //Check human head coverage.
					to_chat(user, span_warning("Remove their [H.head] first."))
					return
				else if(reagents.total_volume) //Final check. If the rag is not on fire and their face is uncovered, smother target.
					user.do_attack_animation(src)
					user.visible_message(
						span_danger("\The [user] smothers [target] with [src]!"),
						span_warning("You smother [target] with [src]!"),
						"You hear some struggling and muffled cries of surprise"
						)
					//it's inhaled, so... maybe CHEM_BLOOD doesn't make a whole lot of sense but it's the best we can do for now
					reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
					update_name()
				else
					to_chat(user, span_warning("You can't smother this creature."))
			else
				to_chat(user, span_warning("You can't smother this creature."))
		else
			wipe_down(target, user)
	else
		wipe_down(target, user)
	return

/obj/item/reagent_containers/glass/rag/afterattack(atom/A as obj|turf|area, mob/user as mob, proximity)
	if(!proximity)
		return

	if(istype(A, /obj/structure/reagent_dispensers) || istype(A, /obj/item/reagent_containers/glass/bucket) || istype(A, /obj/structure/mopbucket))  //VOREStation Edit - "Allows rags to be used on buckets and mopbuckets"
		if(!reagents.get_free_space())
			to_chat(user, span_warning("\The [src] is already soaked."))
			return

		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			user.visible_message(span_infoplain(span_bold("\The [user]") + " soaks [src] using [A]."), span_notice("You soak [src] using [A]."))
			update_name()
		return

	if(!on_fire && istype(A) && (src in user))
		if(A.is_open_container() && !(A in user))
			remove_contents(user, A)
		else if(!ismob(A)) //mobs are handled in attack() - this prevents us from wiping down people while smothering them.
			wipe_down(A, user)
		return

/obj/item/reagent_containers/glass/rag/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 50 + T0C)
		src.ignite()
	if(exposed_temperature >= 900 + T0C)
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)

//rag must have a minimum of 2 units welder fuel or ehtanol based reagents and at least 80% of the reagents must so.
/obj/item/reagent_containers/glass/rag/proc/can_ignite()
	var/fuel
	if(reagents.get_reagent_amount("fuel"))
		fuel += reagents.get_reagent_amount("fuel")

	else
		for(var/datum/reagent/ethanol/R in reagents.reagent_list)
			fuel += reagents.get_reagent_amount(R.id)

	return (fuel >= 2 && fuel >= reagents.total_volume*0.8)

/obj/item/reagent_containers/glass/rag/proc/ignite()
	if(on_fire)
		return
	if(!can_ignite())
		return

	//also copied from matches
	if(reagents.get_reagent_amount("phoron")) // the phoron explodes when exposed to fire
		visible_message(span_danger("\The [src] conflagrates violently!"))
		var/datum/effect/effect/system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount("phoron") / 2.5, 1), get_turf(src), 0, 0)
		e.start()
		qdel(src)
		return

	START_PROCESSING(SSobj, src)
	set_light(2, null, "#E38F46")
	on_fire = 1
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/proc/extinguish()
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	on_fire = 0

	//rags sitting around with 1 second of burn time left is dumb.
	//ensures players always have a few seconds of burn time left when they light their rag
	if(burn_time <= 5)
		visible_message(span_warning("\The [src] falls apart!"))
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/process()
	if(!can_ignite())
		visible_message(span_warning("\The [src] burns out."))
		extinguish()

	//copied from matches
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

	if(burn_time <= 0)
		STOP_PROCESSING(SSobj, src)
		new /obj/effect/decal/cleanable/ash(location)
		qdel(src)
		return

	reagents.remove_reagent("fuel", reagents.maximum_volume/25)
	for(var/datum/reagent/ethanol/R in reagents.reagent_list)
		if(istype(R, /datum/reagent/ethanol))
			reagents.remove_reagent(R.id, reagents.maximum_volume/25)
	update_name()
	burn_time--
