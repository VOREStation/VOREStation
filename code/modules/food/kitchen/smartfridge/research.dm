/*
 * Xenobiological
 */
/obj/machinery/smartfridge/secure/extract
	name = "\improper Biological Sample Storage"
	desc = "A refrigerated storage unit for xenobiological samples."
	icon_contents = "slime"
	req_access = list(access_research)

/obj/machinery/smartfridge/secure/extract/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/slime_extract) || istype(O, /obj/item/slimepotion))
		return 1
	return 0