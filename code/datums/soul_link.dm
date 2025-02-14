// A datum used to link multiple mobs together in some form.
// The code is from TG, however tweaked to be within the preferred code style.

/mob/living
	var/list/owned_soul_links	// Soul links we are the owner of.
	var/list/shared_soul_links	// Soul links we are a/the sharer of.

// Keeps track of a Mob->Mob (potentially Player->Player) connection.
// Can be used to trigger actions on one party when events happen to another.
// Eg: shared deaths.
// Can be used to form a linked list of mob-hopping.
// Does NOT transfer with minds.
/datum/soul_link
	var/mob/living/soul_owner
	var/mob/living/soul_sharer
	var/id // Optional ID, for tagging and finding specific instances.

/datum/soul_link/Destroy()
	if(soul_owner)
		LAZYREMOVE(soul_owner.owned_soul_links, src)
		soul_owner = null
	if(soul_sharer)
		LAZYREMOVE(soul_sharer.shared_soul_links, src)
		soul_sharer = null
	return ..()

/datum/soul_link/proc/remove_soul_sharer(mob/living/sharer)
	if(soul_sharer == sharer)
		soul_sharer = null
		LAZYREMOVE(sharer.shared_soul_links, src)

// Used to assign variables, called primarily by soullink()
// Override this to create more unique soullinks (Eg: 1->Many relationships)
// Return TRUE/FALSE to return the soullink/null in soullink()
/datum/soul_link/proc/parse_args(mob/living/owner, mob/living/sharer)
	if(!owner || !sharer)
		return FALSE
	soul_owner = owner
	soul_sharer = sharer
	LAZYADD(owner.owned_soul_links, src)
	LAZYADD(sharer.shared_soul_links, src)
	return TRUE

// Runs after /living death()
// Override this for content.
/datum/soul_link/proc/owner_died(gibbed, mob/living/owner)

// Runs after /living death()
// Override this for content.
/datum/soul_link/proc/sharer_died(gibbed, mob/living/owner)

// Quick-use helper.
/proc/soul_link(typepath, ...)
	var/datum/soul_link/S = new typepath()
	if(S.parse_args(arglist(args.Copy(2, 0))))
		return S


/////////////////
// MULTISHARER //
/////////////////
// Abstract soullink for use with 1 Owner -> Many Sharer setups
/datum/soul_link/multi_sharer
	var/list/soul_sharers

/datum/soul_link/multi_sharer/parse_args(mob/living/owner, list/sharers)
	if(!owner || !LAZYLEN(sharers))
		return FALSE
	soul_owner = owner
	soul_sharers = sharers
	LAZYADD(owner.owned_soul_links, src)
	for(var/mob/living/L as anything in sharers)
		LAZYADD(L.shared_soul_links, src)
	return TRUE

/datum/soul_link/multi_sharer/remove_soul_sharer(mob/living/sharer)
	LAZYREMOVE(soul_sharers, sharer)


/////////////////
// SHARED FATE //
/////////////////
// When the soulowner dies, the soulsharer dies, and vice versa
// This is intended for two players(or AI) and two mobs

/datum/soul_link/shared_fate/owner_died(gibbed, mob/living/owner)
	if(soul_sharer)
		soul_sharer.death(gibbed)

/datum/soul_link/shared_fate/sharer_died(gibbed, mob/living/sharer)
	if(soul_owner)
		soul_owner.death(gibbed)

//////////////
// ONE WAY  //
//////////////
// When the soul owner dies, the soul sharer dies, but NOT vice versa.
// This is intended for two players (or AI) and two mobs.

/datum/soul_link/one_way/owner_died(gibbed, mob/living/owner)
	if(soul_sharer)
		soul_sharer.dust(FALSE)

/////////////////
// SHARED BODY //
/////////////////
// When the soulsharer dies, they're placed in the soulowner, who remains alive
// If the soulowner dies, the soulsharer is killed and placed into the soulowner (who is still dying)
// This one is intended for one player moving between many mobs

/datum/soul_link/shared_body/owner_died(gibbed, mob/living/owner)
	if(soul_owner && soul_sharer)
		if(soul_sharer.mind)
			soul_sharer.mind.transfer_to(soul_owner)
		soul_sharer.death(gibbed)

/datum/soul_link/shared_body/sharer_died(gibbed, mob/living/sharer)
	if(soul_owner && soul_sharer && soul_sharer.mind)
		soul_sharer.mind.transfer_to(soul_owner)



//////////////////////
// REPLACEMENT POOL //
//////////////////////
// When the owner dies, one of the sharers is placed in the owner's body, fully healed
// Sort of a "winner-stays-on" soullink
// Gibbing ends it immediately

/datum/soul_link/multi_sharer/replacement_pool/owner_died(gibbed, mob/living/owner)
	if(LAZYLEN(soul_sharers) && !gibbed) //let's not put them in some gibs
		var/list/souls = shuffle(soul_sharers.Copy())
		for(var/mob/living/L as anything in souls)
			if(L.stat != DEAD && L.mind)
				L.mind.transfer_to(soul_owner)
				soul_owner.revive(TRUE, TRUE)
				L.death(FALSE)

// Lose your claim to the throne!
/datum/soul_link/multi_sharer/replacement_pool/sharer_died(gibbed, mob/living/sharer)
	remove_soul_sharer(sharer)
