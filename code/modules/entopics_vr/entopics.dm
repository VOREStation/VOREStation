//Augmented reality objects and their associated systems for attaching to things
var/global/list/entopic_images = list()

/datum/entopic
	var/icon = null
	var/icon_state = null
	var/plane = PLANE_AUGMENTED
	var/layer = OBJ_LAYER

	var/image/my_image
	var/registered = FALSE // Less expensive to make it a finite state than to use |= on entopic_images or anything like that.

/datum/entopic/New(var/atom/aholder, var/icon/aicon, var/aicon_state, var/aplane, var/alayer)
	ASSERT(aholder && (isicon(aicon) || isicon(icon)))

	//Everything we need to set in the initializer
	var/image/tempimage = image(icon = aicon || icon, loc = aholder, icon_state = aicon_state || icon_state)

	//And everything we don't
	tempimage.plane = plane = aplane || plane
	tempimage.layer = layer = alayer || layer

	if(aicon)
		icon = aicon
	if(aicon_state)
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

	entopic_images += my_image
	world << my_image // *noises of disgust*
	registered = TRUE

/datum/entopic/proc/unregister_entopic()
	if(!registered || !my_image)
		return

	entopic_images -= my_image
	registered = FALSE

/datum/entopic/proc/show()
	if(!my_image)
		return

	my_image.mouse_opacity = 1
	my_image.invisibility = 0

/datum/entopic/proc/hide()
	if(!my_image)
		return

	my_image.mouse_opacity = 0
	my_image.invisibility = 101
