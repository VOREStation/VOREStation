// Porting stack dragging/auto stacking from TG.

/obj/item/stack/proc/merge(obj/item/stack/S) //Merge src into S, as much as possible
	if(uses_charge || S.uses_charge) // This should realistically never happen, but in case it does lets avoid breaking things.
		return
	if(S.stacktype != stacktype)
		return
	if(S.amount >= S.max_amount)
		return

	var/transfer = get_amount()
	transfer = min(transfer, S.max_amount - S.amount)
	if(pulledby)
		pulledby.start_pulling(S)
	transfer_fingerprints_to(S)
	if(blood_DNA)
		S.blood_DNA |= blood_DNA
	use(transfer)
	S.add(transfer)

/obj/item/stack/Crossed(var/atom/movable/AM)
	if(isturf(AM.loc) && AM != src && istype(AM, src.type) && !AM.throwing)
		merge(AM)
	return ..()