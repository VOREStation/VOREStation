/obj/item/material/butterflyconstruction
	name = "unfinished concealed knife"
	desc = "An unfinished concealed knife, it looks like the screws need to be tightened."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterflystep1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		to_chat(user, "You finish the concealed blade weapon.")
		playsound(src, W.usesound, 50, 1)
		new /obj/item/material/butterfly(user.loc, material.name)
		qdel(src)
		return

/obj/item/material/butterflyblade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly2"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyhandle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/butterflyblade))
		var/obj/item/material/butterflyblade/B = W
		to_chat(user, "You attach the two concealed blade parts.")
		new /obj/item/material/butterflyconstruction(user.loc, B.material.name)
		qdel(W)
		qdel(src)
		return
