/datum/admin_secret_item/fun_secret/remove_internal_clothing
	name = "Remove 'Internal' Clothing"

/datum/admin_secret_item/fun_secret/remove_internal_clothing/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/obj/item/clothing/under/O in all_clothing)
		qdel(O)
