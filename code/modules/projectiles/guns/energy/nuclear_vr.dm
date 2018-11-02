/*
//	Virgo's very own file for overriding Polaris' eguns! Should include: Regular egun, Advanced egun, burst egun, mounted egun
//
//	NOTICE: All the eguns are child objects of the base thing. If you modify the base egun, all the other eguns will inherit it unless they explicitly override it.
*/

/obj/item/weapon/gun/energy/gun
	icon = 'icons/obj/eguns_vr.dmi'	//makes the egun look for icons here instead. ALL of the eguns.

/obj/item/weapon/gun/energy/gun/burst
	icon = 'icons/obj/gun.dmi'	//Points it back at the default file so eguns_vr.dmi doesn't need to mirror all the sprites

/obj/item/weapon/gun/energy/gun/nuclear
	icon = 'icons/obj/gun.dmi'	//Points it back at the default file so eguns_vr.dmi doesn't need to mirror all the sprites