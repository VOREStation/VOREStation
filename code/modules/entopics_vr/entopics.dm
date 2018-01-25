//Augmented reality objects and their associated systems for attaching to things
var/global/list/entopic_images = list()
var/global/list/entopic_users = list()

var/global/list/alt_farmanimals = list()

/datum/entopic
	var/name
	var/suffix
	var/icon
	var/icon_state
	var/plane
	var/layer
	var/holder
	var/alpha = 200 //Holo-ish
	var/override = FALSE

	var/image/my_image
	var/registered = FALSE // Less expensive to make it a finite state than to use |= on entopic_images or anything like that.

/datum/entopic/New(var/atom/aholder, var/icon/aicon, var/aicon_state, var/aalpha, var/aplane, var/alayer, var/aoverride, var/aname, var/asuffix)
	ASSERT(aholder && (isicon(aicon) || isicon(icon)))

	//Everything we need to set in the initializer
	var/image/tempimage = image(icon = aicon || icon, loc = aholder, icon_state = aicon_state || icon_state)

	//And everything we don't (order of prescidence: directly passed, datum-specified, then natural byond)
	if(aplane)
		tempimage.plane = plane = aplane
	else if(plane)
		tempimage.plane = plane

	if(alayer)
		tempimage.layer = layer = alayer
	else if(layer)
		tempimage.layer = layer

	if(aalpha)
		tempimage.alpha = alpha = aalpha
	else if(alpha)
		tempimage.alpha = alpha

	if(aoverride)
		tempimage.override = override = aoverride
	else if(override)
		tempimage.override = override

	if(aname)
		tempimage.name = name = aname
	else if(name)
		tempimage.name = name

	if(asuffix)
		tempimage.suffix = suffix = asuffix
	else if(suffix)
		tempimage.suffix = suffix

	//Save these for later
	holder = aholder
	if(aicon)
		icon = aicon
	if(icon_state)
		icon_state = aicon_state

	my_image = tempimage

	register_entopic()

/datum/entopic/Destroy()
	unregister_entopic()
	my_image = null //Bye!
	return ..()

/datum/entopic/proc/register_entopic()
	if(registered || !my_image)
		return

	registered = TRUE
	entopic_images += my_image
	for(var/m in entopic_users)
		var/mob/M = m
		if(M.client)
			M.client.images += my_image

/datum/entopic/proc/unregister_entopic()
	if(!registered || !my_image)
		return

	registered = FALSE
	entopic_images -= my_image
	for(var/m in entopic_users)
		var/mob/M = m
		if(M.client)
			M.client.images -= my_image

/datum/entopic/proc/show()
	if(!my_image)
		return

	my_image.mouse_opacity = 1
	my_image.invisibility = 0
	my_image.alpha = alpha
	my_image.override = override

/datum/entopic/proc/hide()
	if(!my_image)
		return

	my_image.mouse_opacity = 0
	my_image.invisibility = 101
	my_image.alpha = 0
	my_image.override = FALSE

//////////////////////////////////////
// Debug helper stuff
/obj/item/entopic_debug
	name = "Entopic Debugger"
	desc = "You shouldn't see this..."
	icon = 'icons/obj/machines/ar_elements.dmi'
	icon_state = "proj0"

	var/datum/entopic/ent_debug

/obj/item/entopic_debug/New()
	..()
	ent_debug = new(aholder = src, aicon = icon, aicon_state = "holo_Jin")

/proc/entopic_icon_helper(var/atom/A,var/holo = TRUE)
	ASSERT(A)

	var/icon/CI = getCompoundIcon(A)
	var/icon/HI = getHologramIcon(CI)

	usr << ftp(holo ? HI : CI,"[A.name].dmi")
