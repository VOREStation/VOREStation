//////Exile implants will allow you to use the station gate, but not return home. This will allow security to exile badguys/for badguys to exile their kill targets////////


/obj/item/implanter/exile
	name = "implanter-exile"

/obj/item/implanter/exile/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/exile(src)
	update()

/obj/item/implant/exile
	name = "exile"
	desc = "Prevents you from returning from away missions"

/obj/item/implant/exile/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [using_map.company_name] Employee Exile Implant<BR>
<b>Implant Details:</b> The onboard gateway system has been modified to reject entry by individuals containing this implant<BR>"}
	return dat

/obj/item/implantcase/exile
	name = "Glass Case- 'Exile'"
	desc = "A case containing an exile implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-r"


/obj/item/implantcase/exile/Initialize(mapload)
	. = ..()
	src.imp = new /obj/item/implant/exile(src)


/obj/structure/closet/secure_closet/exile
	name = "Exile Implants"
	req_access = list(access_hos)
	starts_with = list(/obj/item/implanter/exile = 1, /obj/item/implantcase/exile = 5)
