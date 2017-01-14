//Vorestation universal translator implant.

/obj/item/weapon/implanter/language/vrversion
	name = "implanter-language"

/obj/item/weapon/implanter/language/vrversion/New()
	src.imp = new /obj/item/weapon/implant/language/vrversion( src )
	..()
	update()
	return
