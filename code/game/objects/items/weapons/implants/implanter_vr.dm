//Vorestation universal translator implant.

/obj/item/weapon/implanter/language
	name = "implanter-language"

/obj/item/weapon/implanter/language/New()
	src.imp = new /obj/item/weapon/implant/language( src )
	..()
	update()
	return
