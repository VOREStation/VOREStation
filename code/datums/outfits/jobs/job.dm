/decl/hierarchy/outfit/job
	name = "Standard Gear"
	hierarchy_type = /decl/hierarchy/outfit/job

	uniform = /obj/item/clothing/under/color/grey
	shoes = /obj/item/clothing/shoes/black

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/civilian
	pda_slot = slot_belt
	pda_type = /obj/item/pda

	flags = OUTFIT_HAS_BACKPACK

	headset = /obj/item/radio/headset
	headset_alt = /obj/item/radio/headset/alt
	headset_earbud = /obj/item/radio/headset/earbud

/decl/hierarchy/outfit/job/equip_id(mob/living/carbon/human/H, rank, assignment)
	var/obj/item/card/id/C = ..()
	if(!C)
		return
	var/datum/job/J = job_master.GetJob(rank)
	if(J)
		C.access = J.get_access()
	if(H.mind)
		var/datum/mind/M = H.mind
		if(M.initial_account)
			var/datum/money_account/A = M.initial_account
			C.associated_account_number = A.account_number
	return C
