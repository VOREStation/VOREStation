#define PROCESS_REACTION_ITER 5 //when processing a reaction, iterate this many times

/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 100
	var/atom/my_atom = null

/datum/reagents/New(var/max = 100, atom/A = null)
	..()
	maximum_volume = max
	my_atom = A

	//I dislike having these here but map-objects are initialised before world/New() is called. >_>
	if(!SSchemistry.chemical_reagents)
		//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
		var/paths = subtypesof(/datum/reagent)
		SSchemistry.chemical_reagents = list()
		for(var/path in paths)
			var/datum/reagent/D = new path()
			if(!D.name)
				continue
			SSchemistry.chemical_reagents[D.id] = D

/datum/reagents/Destroy()
	for(var/datum/reagent/R in reagent_list)
		qdel(R)
	reagent_list = null
	if(my_atom && my_atom.reagents == src)
		my_atom.reagents = null
	return ..()

/* Internal procs */

/datum/reagents/proc/get_free_space() // Returns free space.
	return maximum_volume - total_volume

/datum/reagents/proc/get_master_reagent() // Returns reference to the reagent with the biggest volume.
	var/the_reagent = null
	var/the_volume = 0

	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_reagent = A

	return the_reagent

/datum/reagents/proc/get_master_reagent_name() // Returns the name of the reagent with the biggest volume.
	var/the_name = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_name = A.name

	return the_name

/datum/reagents/proc/get_master_reagent_id() // Returns the id of the reagent with the biggest volume.
	var/the_id = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_id = A.id

	return the_id

/datum/reagents/proc/update_total() // Updates volume.
	total_volume = 0
	for(var/datum/reagent/R in reagent_list)
		if(R.volume < MINIMUM_CHEMICAL_VOLUME)
			del_reagent(R.id)
		else
			total_volume += R.volume
	return

/datum/reagents/proc/handle_reactions()
	if(QDELETED(my_atom))
		return FALSE
	if(my_atom.flags & NOREACT)
		return FALSE
	var/reaction_occurred
	var/list/eligible_reactions = list()
	var/list/effect_reactions = list()
	do
		reaction_occurred = FALSE
		for(var/datum/reagent/R as anything in reagent_list)
			if(SSchemistry.instant_reactions_by_reagent[R.id])
				eligible_reactions |= SSchemistry.instant_reactions_by_reagent[R.id]

		for(var/decl/chemical_reaction/C as anything in eligible_reactions)
			if(C.can_happen(src) && C.process(src))
				effect_reactions |= C
				reaction_occurred = TRUE
		eligible_reactions.len = 0
	while(reaction_occurred)
	for(var/decl/chemical_reaction/C as anything in effect_reactions)
		C.post_reaction(src)
	update_total()

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/id, var/amount, var/data = null, var/safety = 0)
	if(!isnum(amount) || amount <= 0)
		return 0

	update_total()
	amount = min(amount, get_free_space())


	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			if(current.id == "blood")
				if(LAZYLEN(data) && !isnull(data["species"]) && !isnull(current.data["species"]) && data["species"] != current.data["species"])	// Species bloodtypes are already incompatible, this just stops it from mixing into the one already in a container.
					continue

			current.volume += amount
			if(!isnull(data)) // For all we know, it could be zero or empty string and meaningful
				current.mix_data(data, amount)
			update_total()
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change()
			return 1
	var/datum/reagent/D = SSchemistry.chemical_reagents[id]
	if(D)
		var/datum/reagent/R = new D.type()
		reagent_list += R
		R.holder = src
		R.volume = amount
		R.initialize_data(data)
		update_total()
		if(!safety)
			handle_reactions()
		if(my_atom)
			my_atom.on_reagent_change()
		return 1
	else
		stack_trace("[my_atom] attempted to add a reagent called '[id]' which doesn't exist. ([usr])")
	return 0

/datum/reagents/proc/isolate_reagent(reagent)
	for(var/datum/reagent/R as anything in reagent_list)
		if(R.id != reagent)
			del_reagent(R.id)
			update_total()

/datum/reagents/proc/remove_reagent(var/id, var/amount, var/safety = 0)
	if(!isnum(amount))
		return 0
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			current.volume -= amount // It can go negative, but it doesn't matter
			update_total() // Because this proc will delete it then
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change()
			return 1
	return 0

/datum/reagents/proc/del_reagent(var/id)
	for(var/datum/reagent/current in reagent_list)
		if (current.id == id)
			reagent_list -= current
			qdel(current)
			update_total()
			if(my_atom)
				my_atom.on_reagent_change()
			return 0

/datum/reagents/proc/has_reagent(var/id, var/amount = 0)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			if(current.volume >= amount)
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/has_any_reagent(var/list/check_reagents)
	for(var/datum/reagent/current in reagent_list)
		if(current.id in check_reagents)
			if(current.volume >= check_reagents[current.id])
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/has_all_reagents(var/list/check_reagents)
	//this only works if check_reagents has no duplicate entries... hopefully okay since it expects an associative list
	var/missing = check_reagents.len
	for(var/datum/reagent/current in reagent_list)
		if(current.id in check_reagents)
			if(current.volume >= check_reagents[current.id])
				missing--
	return !missing

/datum/reagents/proc/clear_reagents()
	for(var/datum/reagent/current in reagent_list)
		del_reagent(current.id)
	return

/datum/reagents/proc/get_reagent_amount(var/id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.volume
	return 0

/datum/reagents/proc/get_data(var/id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.get_data()
	return 0

/datum/reagents/proc/get_reagents()
	. = list()
	for(var/datum/reagent/current in reagent_list)
		. += "[current.id] ([current.volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/* Holder-to-holder and similar procs */

/datum/reagents/proc/remove_any(var/amount = 1) // Removes up to [amount] of reagents from [src]. Returns actual amount removed.
	amount = min(amount, total_volume)

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_remove = current.volume * part
		remove_reagent(current.id, amount_to_remove, 1)

	update_total()
	handle_reactions()
	return amount

/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]).
	if(!target || !istype(target))
		return

	amount = max(0, min(amount, total_volume, target.get_free_space() / multiplier))

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		target.add_reagent(current.id, amount_to_transfer * multiplier, current.get_data(), safety = 1) // We don't react until everything is in place
		if(!copy)
			remove_reagent(current.id, amount_to_transfer, 1)

	if(!copy)
		handle_reactions()
	target.handle_reactions()
	return amount

/* Holder-to-atom and similar procs */

//The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
//not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
//If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
//call the appropriate trans_to_*() proc.
/datum/reagents/proc/trans_to(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	touch(target) //First, handle mere touch effects

	if(ismob(target))
		return splash_mob(target, amount, copy)
	if(isturf(target))
		return trans_to_turf(target, amount, multiplier, copy)
	if(isobj(target) && target.is_open_container())
		return trans_to_obj(target, amount, multiplier, copy)
	return 0

//Splashing reagents is messier than trans_to, the target's loc gets some of the reagents as well.
/datum/reagents/proc/splash(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/min_spill=0, var/max_spill=60)
	var/spill = 0
	if(!isturf(target) && target.loc)
		spill = amount*(rand(min_spill, max_spill)/100)
		amount -= spill
	if(spill)
		splash(target.loc, spill, multiplier, copy, min_spill, max_spill)

	if(!trans_to(target, amount, multiplier, copy))
		touch(target, amount)

/datum/reagents/proc/trans_type_to(var/target, var/rtype, var/amount = 1)
	if (!target)
		return

	var/datum/reagent/transfering_reagent = get_reagent(rtype)

	if (istype(target, /atom))
		var/atom/A = target
		if (!A.reagents || !A.simulated)
			return

	amount = min(amount, transfering_reagent.volume)

	if(!amount)
		return


	var/datum/reagents/F = new /datum/reagents(amount)
	var/tmpdata = get_data(rtype)
	F.add_reagent(rtype, amount, tmpdata)
	remove_reagent(rtype, amount)


	if (istype(target, /atom))
		return F.trans_to(target, amount) // Let this proc check the atom's type
	else if (istype(target, /datum/reagents))
		return F.trans_to_holder(target, amount)

/datum/reagents/proc/trans_id_to(var/atom/target, var/id, var/amount = 1)
	if (!target || !target.reagents)
		return

	amount = min(amount, get_reagent_amount(id))

	if(!amount)
		return

	var/datum/reagents/F = new /datum/reagents(amount)
	var/tmpdata = get_data(id)
	F.add_reagent(id, amount, tmpdata)
	remove_reagent(id, amount)

	return F.trans_to(target, amount) // Let this proc check the atom's type

// When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
// This does not handle transferring reagents to things.
// For example, splashing someone with water will get them wet and extinguish them if they are on fire,
// even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
/datum/reagents/proc/touch(var/atom/target, var/amount)
	if(ismob(target))
		touch_mob(target, amount)
	if(isturf(target))
		touch_turf(target, amount)
	if(isobj(target))
		touch_obj(target, amount)
	return

/datum/reagents/proc/touch_mob(var/mob/target)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_mob(target, current.volume)

	update_total()

/datum/reagents/proc/touch_turf(var/turf/target, var/amount)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_turf(target, amount)

	update_total()

/datum/reagents/proc/touch_obj(var/obj/target, var/amount)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_obj(target, amount)

	update_total()

// Attempts to place a reagent on the mob's skin.
// Reagents are not guaranteed to transfer to the target.
// Do not call this directly, call trans_to() instead.
/datum/reagents/proc/splash_mob(var/mob/target, var/amount = 1, var/copy = 0)
	var/perm = 1
	if(isliving(target)) //will we ever even need to tranfer reagents to non-living mobs?
		var/mob/living/L = target
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.check_shields(0, null, null, null, "the spray") == 1)		//If they block the spray, it does nothing.
				amount = 0
		perm = L.reagent_permeability()
	return trans_to_mob(target, amount, CHEM_TOUCH, perm, copy)

/datum/reagents/proc/trans_to_mob(var/mob/target, var/amount = 1, var/type = CHEM_BLOOD, var/multiplier = 1, var/copy = 0) // Transfer after checking into which holder...
	if(!target || !istype(target))
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(type == CHEM_BLOOD)
			var/datum/reagents/R = C.reagents
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == CHEM_INGEST)
			var/datum/reagents/R = C.ingested
			return C.ingest(src, R, amount, multiplier, copy)
		if(type == CHEM_TOUCH)
			var/datum/reagents/R = C.touching
			return trans_to_holder(R, amount, multiplier, copy)
	else
		var/datum/reagents/R = new /datum/reagents(amount)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_mob(target)

/datum/reagents/proc/trans_to_turf(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Turfs don't have any reagents (at least, for now). Just touch it.
	if(!target)
		return

	var/datum/reagents/R = new /datum/reagents(amount * multiplier)
	. = trans_to_holder(R, amount, multiplier, copy)
	R.touch_turf(target, amount)
	return

/datum/reagents/proc/trans_to_obj(var/obj/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
	if(!target)
		return

	if(!target.reagents)
		var/datum/reagents/R = new /datum/reagents(amount * multiplier)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_obj(target, amount)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy)

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(var/max_vol, var/reagents_type = /datum/reagents)
	if(!ispath(reagents_type))
		reagents_type = /datum/reagents
	reagents = new reagents_type(max_vol, src)

// Aurora Cooking Port
/datum/reagents/proc/get_reagent(var/id) // Returns reference to reagent matching passed ID
	for(var/datum/reagent/A in reagent_list)
		if (A.id == id)
			return A

	return null

//Spreads the contents of this reagent holder all over the vicinity of the target turf.
/datum/reagents/proc/splash_area(var/turf/epicentre, var/range = 3, var/portion = 1.0, var/multiplier = 1, var/copy = 0)
	var/list/things = dview(range, epicentre, INVISIBILITY_LIGHTING)
	var/list/turfs = list()
	for (var/turf/T in things)
		turfs += T
	if (!turfs.len)
		return//Nowhere to splash to, somehow
	//Create a temporary holder to hold all the amount that will be spread
	var/datum/reagents/R = new /datum/reagents(total_volume * portion * multiplier)
	trans_to_holder(R, total_volume * portion, multiplier, copy)
	//The exact amount that will be given to each turf
	var/turfportion = R.total_volume / turfs.len
	for (var/turf/T in turfs)
		var/datum/reagents/TR = new /datum/reagents(turfportion)
		R.trans_to_holder(TR, turfportion, 1, 0)
		TR.splash_turf(T)
	qdel(R)


//Spreads the contents of this reagent holder all over the target turf, dividing among things in it.
//50% is divided between mobs, 20% between objects, and whatever is left on the turf itself
/datum/reagents/proc/splash_turf(var/turf/T, var/amount = null, var/multiplier = 1, var/copy = 0)
	if (isnull(amount))
		amount = total_volume
	else
		amount = min(amount, total_volume)
	if (amount <= 0)
		return
	var/list/mobs = list()
	for (var/mob/M in T)
		mobs += M
	var/list/objs = list()
	for (var/obj/O in T)
		objs += O
	if (objs.len)
		var/objportion = (amount * 0.2) / objs.len
		for(var/obj/O as anything in objs)
			trans_to(O, objportion, multiplier, copy)
	amount = min(amount, total_volume)
	if (mobs.len)
		var/mobportion = (amount * 0.5) / mobs.len
		for(var/mob/M as anything in mobs)
			trans_to(M, mobportion, multiplier, copy)
	trans_to(T, total_volume, multiplier, copy)
	if (total_volume <= 0)
		qdel(src)

/**
 * Calls [/datum/reagent/proc/on_update] on every reagent in this holder
 *
 * Arguments:
 * * atom/A - passed to on_update
 */
/datum/reagents/proc/conditional_update(atom/A)
	var/list/cached_reagents = reagent_list
	for(var/datum/reagent/reagent as anything in cached_reagents)
		reagent.on_update(A)
	update_total()
