// Porting stack dragging/auto stacking from TG.

/obj/item/stack/proc/merge(obj/item/stack/S) //Merge src into S, as much as possible
	var/transfer = get_amount()
	transfer = min(transfer, S.max_amount - S.amount)
	if(pulledby)
		pulledby.start_pulling(S)
	transfer_fingerprints_to(S)
	if(blood_DNA)
		S.blood_DNA |= blood_DNA
	use(transfer)
	S.add(transfer)

/obj/item/stack/proc/can_merge(obj/item/stack/S)
	if(uses_charge || S.uses_charge) // This should realistically never happen, but in case it does lets avoid breaking things.
		return
	if(S.stacktype != stacktype)
		return
	if(S.amount >= S.max_amount)
		return
	if(!isturf(loc) || !isturf(S.loc))
		return FALSE
	if(src == S)
		return FALSE
	if(ismob(S.loc) || ismob(loc))
		return FALSE
	if(S.throwing || throwing)
		return FALSE
	if(S.amount < 1 || amount < 1)
		return FALSE
	return TRUE

/obj/item/stack/Crossed(var/atom/movable/AM)
	if(istype(AM, src.type)) // Sanity so we don't try to merge non-stacks.
		if(can_merge(AM))
			merge(AM)
	return ..()
