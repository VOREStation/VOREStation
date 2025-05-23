//Vorestation universal translator implant.

/obj/item/implanter/vrlanguage
	name = "implanter-language"

/obj/item/implanter/vrlanguage/New()
	src.imp = new /obj/item/implant/vrlanguage( src )
	..()
	update()
	return
