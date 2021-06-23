//////Exile implants will allow you to use the station gate, but not return home. This will allow security to exile badguys/for badguys to exile their kill targets////////


/obj/item/weapon/implanter/exile
	name = "implanter-exile"

/obj/item/weapon/implanter/exile/New()
	src.imp = new /obj/item/weapon/implant/exile( src )
	..()
	update()
	return


/obj/item/weapon/implant/exile
	name = "exile"
	desc = "Prevents you from returning from away missions"

/obj/item/weapon/implant/exile/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [using_map.company_name] Employee Exile Implant<BR>
<b>Implant Details:</b> The onboard gateway system has been modified to reject entry by individuals containing this implant<BR>"}
	return dat

/obj/item/weapon/implantcase/exile
	name = "Glass Case- 'Exile'"
	desc = "A case containing an exile implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-r"


/obj/item/weapon/implantcase/exile/New()
	src.imp = new /obj/item/weapon/implant/exile( src )
	..()
	return


/obj/structure/closet/secure_closet/exile
	name = "Exile Implants"
	req_access = list(access_hos)
	starts_with = list(/obj/item/weapon/implanter/exile = 1, /obj/item/weapon/implantcase/exile = 5)
