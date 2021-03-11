//For custom heads with custom parts since the base code is restricted to a single icon file.

/obj/item/organ/external/head/vr
	var/eye_icons_vr = 'icons/mob/human_face_vr.dmi'
	var/eye_icon_vr = "blank_eyes"
	eye_icon = "blank_eyes"

/obj/item/organ/external/head/vr/sergal
	eye_icon_vr = "eyes_sergal"

/obj/item/organ/external/head/vr/werebeast
	eye_icons_vr = 'icons/mob/werebeast_face_vr.dmi'
	eye_icon_vr = "werebeast_eyes"
	head_offset = 6

/obj/item/organ/external/head/vr/shadekin
	cannot_gib = 1
	cannot_amputate = 1

	eye_icons_vr = 'icons/mob/human_face_vr.dmi'
	eye_icon_vr = "eyes_shadekin"
