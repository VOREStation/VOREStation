/**************
* AI-specific *
**************/
/obj/item/camera/siliconcam
	var/in_camera_mode = 0
	var/photos_taken = 0
	var/list/obj/item/photo/aipictures = list()

/obj/item/camera/siliconcam/ai_camera //camera AI can take pictures with
	name = "AI photo camera"

/obj/item/camera/siliconcam/robot_camera //camera cyborgs can take pictures with
	name = "Cyborg photo camera"

/obj/item/camera/siliconcam/drone_camera //currently doesn't offer the verbs, thus cannot be used
	name = "Drone photo camera"

/obj/item/camera/siliconcam/proc/injectaialbum(obj/item/photo/p, var/sufix = "") //stores image information to a list similar to that of the datacore
	p.loc = src
	photos_taken++
	p.name = "Image [photos_taken][sufix]"
	aipictures += p

/obj/item/camera/siliconcam/proc/injectmasteralbum(obj/item/photo/p) //stores image information to a list similar to that of the datacore
	var/mob/living/silicon/robot/C = usr
	if(C.connected_ai)
		C.connected_ai.aiCamera.injectaialbum(p.copy(1), " (synced from [C.name])")
		to_chat(C.connected_ai, span_unconscious("Image uploaded by [C.name]"))
		to_chat(usr, span_unconscious("Image synced to remote database"))	//feedback to the Cyborg player that the picture was taken
	else
		to_chat(usr, span_unconscious("Image recorded"))
	// Always save locally
	injectaialbum(p)

/obj/item/camera/siliconcam/proc/selectpicture(obj/item/camera/siliconcam/cam)
	if(!cam)
		cam = getsource()

	var/list/nametemp = list()
	var/find
	if(cam.aipictures.len == 0)
		to_chat(usr, span_userdanger("No images saved"))
		return
	for(var/obj/item/photo/t in cam.aipictures)
		nametemp += t.name
	find = tgui_input_list(usr, "Select image (numbered in order taken)", "Picture Choice", nametemp)
	if(!find)
		return

	for(var/obj/item/photo/q in cam.aipictures)
		if(q.name == find)
			return q

/obj/item/camera/siliconcam/proc/viewpictures()
	var/obj/item/photo/selection = selectpicture()

	if(!selection)
		return

	selection.show(usr)
	to_chat(usr,selection.desc)

/obj/item/camera/siliconcam/proc/deletepicture(obj/item/camera/siliconcam/cam)
	var/selection = selectpicture(cam)

	if(!selection)
		return

	aipictures -= selection
	to_chat(usr, span_unconscious("Local image deleted"))

/obj/item/camera/siliconcam/ai_camera/can_capture_turf(turf/T, mob/user)
	var/mob/living/silicon/ai = user
	return ai.TurfAdjacent(T)

/obj/item/camera/siliconcam/proc/toggle_camera_mode()
	if(in_camera_mode)
		camera_mode_off()
	else
		camera_mode_on()

/obj/item/camera/siliconcam/proc/camera_mode_off()
	src.in_camera_mode = 0
	to_chat(usr, span_infoplain(span_bold("Camera Mode deactivated")))

/obj/item/camera/siliconcam/proc/camera_mode_on()
	src.in_camera_mode = 1
	to_chat(usr, span_infoplain(span_bold("Camera Mode activated")))

/obj/item/camera/siliconcam/ai_camera/printpicture(mob/user, obj/item/photo/p)
	injectaialbum(p)
	to_chat(usr, span_unconscious("Image recorded"))

/obj/item/camera/siliconcam/robot_camera/printpicture(mob/user, obj/item/photo/p)
	injectmasteralbum(p)

/mob/living/silicon/ai/proc/take_image()
	set category = "AI.Commands"
	set name = "Take Image"
	set desc = "Takes an image"

	if(aiCamera)
		aiCamera.toggle_camera_mode()

/mob/living/silicon/ai/proc/view_images()
	set category = "AI.Commands"
	set name = "View Images"
	set desc = "View images"

	if(aiCamera)
		aiCamera.viewpictures()

/mob/living/silicon/ai/proc/delete_images()
	set category = "AI.Commands"
	set name = "Delete Image"
	set desc = "Delete image"

	if(aiCamera)
		aiCamera.deletepicture()

/mob/living/silicon/robot/proc/take_image()
	set category ="Abilities.Silicon"
	set name = "Take Image"
	set desc = "Takes an image"

	if(aiCamera)
		aiCamera.toggle_camera_mode()

/mob/living/silicon/robot/proc/view_images()
	set category ="Abilities.Silicon"
	set name = "View Images"
	set desc = "View images"

	if(aiCamera)
		aiCamera.viewpictures()

/mob/living/silicon/robot/proc/delete_images()
	set category = "Abilities.Silicon"
	set name = "Delete Image"
	set desc = "Delete a local image"

	if(aiCamera)
		aiCamera.deletepicture()

/obj/item/camera/siliconcam/proc/getsource()
	if(istype(src.loc, /mob/living/silicon/ai))
		return src

	var/mob/living/silicon/robot/C = usr
	var/obj/item/camera/siliconcam/Cinfo
	if(C.connected_ai)
		Cinfo = C.connected_ai.aiCamera
	else
		Cinfo = src
	return Cinfo

/mob/living/silicon/proc/GetPicture()
	if(!aiCamera)
		return
	return aiCamera.selectpicture()
