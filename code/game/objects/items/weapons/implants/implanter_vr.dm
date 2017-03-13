//Vorestation universal translator implant.

/obj/item/weapon/implanter/vrlanguage
	name = "implanter-language"

/obj/item/weapon/implanter/vrlanguage/New()
	src.imp = new /obj/item/weapon/implant/vrlanguage( src )
	..()
	update()
	return
