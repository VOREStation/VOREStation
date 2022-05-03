//Blade
/obj/item/weapon/material/knifeblade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "knifeblade"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

//Butterfly Knife
/obj/item/weapon/material/butterflyconstruction
	name = "unfinished concealed knife"
	desc = "An unfinished concealed knife, it looks like the screws need to be tightened."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterflystep1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/butterflyconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		to_chat(user, "You finish the concealed blade weapon.")
		playsound(src, W.usesound, 50, 1)
		new /obj/item/weapon/material/butterfly(user.loc, material.name)
		qdel(src)
		return

/obj/item/weapon/material/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/butterflyhandle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/material/knifeblade))
		var/obj/item/weapon/material/knifeblade/B = W
		to_chat(user, "You attach the two concealed blade parts.")
		new /obj/item/weapon/material/butterflyconstruction(user.loc, B.material.name)
		qdel(W)
		qdel(src)
		return

//Switchblade
/obj/item/weapon/material/switchbladeconstruction
	name = "unfinished switchblade"
	desc = "An unfinished switchblade, it looks like the screws need to be tightened."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "switchbladestep1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/switchbladeconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		to_chat(user, "You finish the switchblade.")
		playsound(src, W.usesound, 50, 1)
		new /obj/item/weapon/material/butterfly/switchblade(user.loc, material.name)
		qdel(src)
		return

/obj/item/weapon/material/switchbladehandle
	name = "switchblade grip"
	desc = "A spring loaded grip with screw fittings for a blade."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "switchblade"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/switchbladehandle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/material/knifeblade))
		var/obj/item/weapon/material/knifeblade/B = W
		to_chat(user, "You attach the two switchblade parts.")
		new /obj/item/weapon/material/switchbladeconstruction(user.loc, B.material.name)
		qdel(W)
		qdel(src)
		return