GLOBAL_LIST_INIT(allocated_gamma_loot,list())
GLOBAL_LIST_INIT(unique_gamma_loot,list(\
		/obj/item/perfect_tele,\
		/obj/item/bluespace_harpoon,\
		/obj/item/clothing/glasses/thermal/syndi,\
		/obj/item/gun/energy/netgun,\
		/obj/item/gun/projectile/dartgun,\
		/obj/item/clothing/gloves/black/bloodletter,\
		/obj/item/gun/energy/mouseray/metamorphosis))

/datum/element/lootable
	var/chance_nothing = 0			// Unlucky people might need to loot multiple spots to find things.
	var/chance_uncommon = 10		// Probability of pulling from the uncommon_loot list.
	var/chance_rare = 1				// Ditto, but for rare_loot list.
	var/chance_gamma = 0			// Singledrop global loot table shaded with all piles.

	var/loot_depletion = FALSE		// If true, loot piles can be 'depleted' after a certain number of searches by different players, where no more loot can be obtained.
	var/loot_left = 0				// When this reaches zero, and loot_depleted is true, you can't obtain anymore loot.
	var/delete_on_depletion = FALSE	// If true, and if the loot gets depleted as above, the pile is deleted.

	var/list/common_loot = list()	// Common is generally less-than-useful junk and filler, at least for maint loot piles.
	var/list/uncommon_loot = list()	// Uncommon is actually maybe some useful items, usually the reason someone bothers looking inside.
	var/list/rare_loot = list()		// Rare is really powerful, or at least unique items.

/datum/element/lootable/Attach(atom/target)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LOOT_REWARD, PROC_REF(loot))

/datum/element/lootable/Detach(atom/target)
	. = ..()
	UnregisterSignal(target, COMSIG_LOOT_REWARD)

/datum/element/lootable/proc/loot(atom/source,mob/living/L)
	SIGNAL_HANDLER
	// The loot's all gone.
	if(loot_depletion && loot_left <= 0)
		to_chat(L, span_warning("\The [source] has been picked clean."))
		return

	// You got unlucky.
	if(chance_nothing && prob(chance_nothing))
		to_chat(L, span_warning("Nothing in this pile really catches your eye..."))
		return

	// You found something!
	var/obj/item/loot = null
	var/span = "notice" // Blue

	if(prob(chance_uncommon) && uncommon_loot.len) // You might still get something good.
		loot = produce_uncommon_item(source)
		span = "alium" // Green

	else if(prob(chance_rare) && rare_loot.len) // You won THE GRAND PRIZE!
		loot = produce_rare_item(source)
		span = "cult" // Purple and bold.

	else if(prob(chance_gamma) && GLOB.unique_gamma_loot.len) // ULTRA GRAND PRIZE
		loot = produce_gamma_item(source)
		span = "cult" // Purple and bold.

	else  // Welp.
		loot = produce_common_item(source)

	if(istype(loot,/obj/random))
		var/obj/random/randy = loot
		var/new_I = randy.spawn_item()
		qdel_swap(loot,new_I)

	//We either have an item to hand over or we don't, at this point!
	if(loot)
		loot.forceMove(get_turf(source))
		var/final_message = "You found \a [loot]!"
		switch(span)
			if("notice")
				final_message = span_notice(final_message)
			if("cult")
				final_message = span_cult(final_message)
			if("alium")
				final_message = span_alium(final_message)
		to_chat(L, span_info(final_message))
		if(loot_depletion)
			loot_left--
			if(loot_left <= 0)
				to_chat(L, span_warning("You seem to have gotten the last of the spoils inside \the [source]."))
				if(delete_on_depletion)
					qdel(source)


/datum/element/lootable/proc/produce_common_item(atom/source)
	var/path = pick(common_loot)
	return new path(source)

/datum/element/lootable/proc/produce_uncommon_item(atom/source)
	var/path = pick(uncommon_loot)
	return new path(source)

/datum/element/lootable/proc/produce_rare_item(atom/source)
	var/path = pick(rare_loot)
	return new path(source)

/// These are types that can only spawn once, and then will be removed from this list.
/datum/element/lootable/proc/produce_gamma_item(atom/source)
	var/path = pick_n_take(GLOB.unique_gamma_loot)
	if(!path) //Tapped out, reallocate?
		for(var/P in GLOB.allocated_gamma_loot)
			var/datum/weakref/WF = GLOB.allocated_gamma_loot[P]
			var/obj/item/I = WF?.resolve()
			if(QDELETED(I) || istype(I.loc,/obj/machinery/computer/cryopod))
				restore_gamma_loot(P)
				path = P
				break

	if(path)
		var/obj/item/I = new path()
		GLOB.allocated_gamma_loot[path] = WEAKREF(I)
		return I
	else
		return produce_rare_item(source)

/// Restores a removed gamma loot item back to the loot table
/proc/restore_gamma_loot(var/w_type)
	GLOB.allocated_gamma_loot -= w_type
	GLOB.unique_gamma_loot += w_type
