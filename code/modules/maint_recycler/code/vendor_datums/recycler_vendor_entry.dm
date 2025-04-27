/datum/maint_recycler_vendor_entry
	var/name = "Cool Object to buy" //what it's shown as in the vendor
	var/ad_message = "" //what comes after the name in the vendor
	var/desc = "What the object actually is" //what's shown to the user upon hovering
	var/object_type_to_spawn
	var/item_cost = 15 //in RP/Recycle Points

	var/tagline = "Thank you for your patronage!" //what's said by the vendor upon vending
	var/per_person_cap = -1 //-1 for infinite!
	var/per_round_cap = -1 //ditto. Global. for everyone. etc.
	var/list/purchased_by //associated list. client.key to amount bought.

	var/list/required_access = null //for stuff that doesn't make sense to have as standard station equipment or from cargo
	// but would be weird to hand out to just anyone.
	//can technically be cheesed as the source of "money" isn't tied to the ID, so you can borrow someone's access
	//but if someone's willing to be a big enough nerd, I'm not gonna waste time trying to stop it.

	var/vendor_category = MAINTVENDOR_GENERIC
	var/icon_state

	var/is_scam = FALSE //if we spawn nothing, this needs to be true - special handling for this in the vendor later.

/datum/maint_recycler_vendor_entry/proc/initialize()
	if(!icon_state)
		icon_state = "generic[rand(1,10)]"
	if(islist(icon_state))
		icon_state = pick(icon_state)


/datum/maint_recycler_vendor_entry/proc/spawn_at(var/loc)
	var/obj/item/item = new object_type_to_spawn(get_turf(loc))
	post_purchase_handling(item)

/datum/maint_recycler_vendor_entry/proc/spawn_with_delay(var/loc)
	addtimer(CALLBACK(src, PROC_REF(spawn_at),loc), 0.5 SECONDS)


/datum/maint_recycler_vendor_entry/proc/post_purchase_handling(var/obj/bought)
	SHOULD_CALL_PARENT(FALSE)

/datum/maint_recycler_vendor_entry/proc/getPurchasedCount()
	.=0
	for(var/v in purchased_by)
		. += purchased_by[v]
	return .
