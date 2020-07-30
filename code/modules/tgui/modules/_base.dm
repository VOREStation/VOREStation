/*
TGUI MODULES

This allows for datum-based TGUIs that can be hooked into objects.
This is useful for things such as the power monitor, which needs to exist on a physical console in the world, but also as a virtual device the AI can use

Code is pretty much ripped verbatim from nano modules, but with un-needed stuff removed
*/
/datum/tgui_module
	var/name
	var/datum/host
<<<<<<< HEAD
	var/list/using_access

	var/tgui_id
=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui

/datum/tgui_module/New(var/host)
	src.host = host

/datum/tgui_module/tgui_host()
	return host ? host : src

/datum/tgui_module/tgui_close(mob/user)
	if(host)
		host.tgui_close(user)
<<<<<<< HEAD

/datum/tgui_module/proc/check_access(mob/user, access)
	if(!access)
		return 1

	if(using_access)
		if(access in using_access)
			return 1
		else
			return 0

	if(!istype(user))
		return 0

	var/obj/item/weapon/card/id/I = user.GetIdCard()
	if(!I)
		return 0

	if(access in I.access)
		return 1

	return 0
=======
>>>>>>> f1eb479... Merge pull request #7317 from ShadowLarkens/tgui
