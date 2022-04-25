var/global/create_object_html = null

/datum/admins/proc/create_object(var/mob/user)
	if (!create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(/obj), ";")
		create_object_html = file2text('html/create_object.html')
		create_object_html = replacetext(create_object_html, "null /* object types */", "\"[objectjs]\"")

	user << browse(replacetext(create_object_html, "/* ref src */", "\ref[src]"), "window=create_object;size=680x600")


/datum/admins/proc/quick_create_object(var/mob/user)

	var/quick_create_object_html = null
	var/pathtext = null
	var/list/choices = list("/obj",
	"/obj/structure",
	"/obj/item",
	"/obj/item/device",
	"/obj/item/weapon",
	"/obj/item/weapon/gun",
	"/obj/item/weapon/reagent_containers",
	"/obj/item/weapon/reagent_containers/food",
	"/obj/item/clothing",
	"/obj/item/weapon/storage/box/fluff", //VOREStation Edit,
	"/obj/machinery",
	"/obj/mecha",
	"/obj/item/mecha_parts",
	"/obj/item/mecha_parts/mecha_equipment")
	
	pathtext = tgui_input_list(usr, "Select the path of the object you wish to create.", "Path", choices, "/obj")

	if(!pathtext)
		return
	var path = text2path(pathtext)

	if (!quick_create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(path), ";")
		quick_create_object_html = file2text('html/create_object.html')
		quick_create_object_html = replacetext(quick_create_object_html, "null /* object types */", "\"[objectjs]\"")

	user << browse(replacetext(quick_create_object_html, "/* ref src */", "\ref[src]"), "window=quick_create_object;size=680x600")
