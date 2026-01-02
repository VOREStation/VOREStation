/datum/component/pref_overlays
	var/list/client_images

/datum/component/pref_overlays/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	client_images = list()

	RegisterSignal(parent, COMSIG_PLAYER_PREF_CHANGED, PROC_REF(update_for))
	RegisterSignal(parent, COMSIG_PLAYER_ENTERED_VIEW, PROC_REF(update_for))

/datum/component/pref_overlays/Destroy()
	for(var/client/C in client_images)
		var/list/L = client_images[C]
		for(var/image/I in L)
			C.images -= I

	UnregisterSignal(parent, list(COMSIG_PLAYER_PREF_CHANGED, COMSIG_PLAYER_ENTERED_VIEW))
	client_images = null
	parent = null
	. = ..()

/datum/component/pref_overlays/proc/viewer_allows(mob/viewer)
	return FALSE

/datum/component/pref_overlays/proc/get_icon()
	return null

/datum/component/pref_overlays/proc/get_layer()
	return FLOAT_LAYER

/datum/component/pref_overlays/proc/apply_icon_blending(icon/I)
	return

/datum/component/pref_overlays/proc/get_overlay_states(mob/viewer)
	return list()

/datum/component/pref_overlays/proc/build_images(mob/viewer)
	var/list/images = list()
	var/icon_file = get_icon()
	if(!icon_file)
		return images

	var/mob/M = parent
	for(var/state in get_overlay_states(viewer))
		var/icon/I = new/icon(icon = icon_file, icon_state = state)
		apply_icon_blending(I)

		var/image/img = image(I, loc = parent)
		img.overlays += em_block_image_generic(img)
		img.layer = get_layer()
		img.plane = M.plane
		img.appearance_flags = M.appearance_flags

		images += img

	return images

/datum/component/pref_overlays/proc/update_for(mob/viewer)
	SIGNAL_HANDLER
	if(!viewer || !viewer.client)
		return

	if(!viewer_allows(viewer))
		clear_for(viewer)
		return

	var/list/old = client_images[viewer.client]
	if(old)
		for(var/image/I in old)
			viewer.client.images -= I

	var/list/new_images = build_images(viewer)
	client_images[viewer.client] = new_images

	for(var/image/I in new_images)
		viewer.client.images += I

/datum/component/pref_overlays/proc/update_all_viewers()
	SIGNAL_HANDLER
	for(var/mob/M in viewers(parent))
		update_for(M)

/datum/component/pref_overlays/proc/clear_for(mob/viewer)
	var/client/C = viewer?.client
	if(!C)
		return

	var/list/L = client_images[C]
	if(!L)
		return

	for(var/image/I in L)
		C.images -= I

	client_images -= C

////////////////////////////////////////////////////
// Vore overlay component
////////////////////////////////////////////////////

/datum/component/pref_overlays/vore/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	. = ..()

	RegisterSignal(parent, COMSIG_VORE_OVERLAY_CHANGED, PROC_REF(update_all_viewers))

/datum/component/pref_overlays/vore/Destroy()
	UnregisterSignal(parent, COMSIG_VORE_OVERLAY_CHANGED)
	. = ..()

/datum/component/pref_overlays/vore/get_icon()
	return 'icons/mob/vore/Bellies.dmi'

/datum/component/pref_overlays/vore/get_layer()
	return BODY_LAYER + VORE_BELLY_LAYER

/datum/component/pref_overlays/vore/viewer_allows(mob/viewer)
	return viewer.read_preference(/datum/preference/toggle/tummy_sprites)

/datum/component/pref_overlays/vore/get_overlay_states(mob/viewer)
	var/list/L = list()
	var/mob/living/carbon/human/M = parent
	if(!istype(M))
		return L

	if(M.wear_suit && M.wear_suit.flags_inv & HIDETAIL)
		return L

	var/vs_fullness = M.vore_fullness_ex["stomach"]
	var/state_name = "[M.species.vore_belly_default_variant]Belly[vs_fullness][(M.struggle_anim_stomach ? "" : " idle")]"
	L += state_name

	return L

/datum/component/pref_overlays/vore/apply_icon_blending(icon/I)
	var/mob/M = parent
	I.Blend(M.vore_sprite_color["stomach"], M.vore_sprite_multiply["stomach"] ? ICON_MULTIPLY : ICON_ADD)


////////////////////////////////////////////////////
// Vore Tail overlay component
////////////////////////////////////////////////////

/datum/component/pref_overlays/vore_tail/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	. = ..()

	RegisterSignal(parent, COMSIG_VORE_TAIL_CHANGED, PROC_REF(update_all_viewers))

/datum/component/pref_overlays/vore_tail/Destroy()
	UnregisterSignal(parent, COMSIG_VORE_TAIL_CHANGED)
	. = ..()

/datum/component/pref_overlays/vore_tail/get_layer()
	return BODY_LAYER + VORE_TAIL_LAYER

/datum/component/pref_overlays/vore_tail/get_icon()
	var/mob/living/carbon/human/M = parent
	return M.tail_style?.bellies_icon_path

/datum/component/pref_overlays/vore_tail/viewer_allows(mob/viewer)
	return viewer.read_preference(/datum/preference/toggle/tummy_sprites)

/datum/component/pref_overlays/vore_tail/get_overlay_states(mob/viewer)
	var/list/L = list()
	var/mob/living/carbon/human/M = parent
	if(!istype(M))
		return L
	if(!M.tail_style || !istaurtail(M.tail_style) || !M.tail_style.vore_tail_sprite_variant)
		return L

	var vs_fullness = M.vore_fullness_ex["taur belly"]
	var loaf_alt = M.lying && M.tail_style.belly_variant_when_loaf
	var fullness_icons = min(M.tail_style.fullness_icons, vs_fullness)

	var state_name = "Taur[M.tail_style.vore_tail_sprite_variant]-Belly-[fullness_icons][loaf_alt ? " loaf" : (M.struggle_anim_taur ? "" : " idle")]"
	L += state_name

	return L

/datum/component/pref_overlays/vore_tail/apply_icon_blending(icon/I)
	var/mob/M = parent
	I.Blend(M.vore_sprite_color["taur belly"], M.vore_sprite_multiply["taur belly"] ? ICON_MULTIPLY : ICON_ADD)

/datum/component/pref_overlays/vore_tail/build_images(mob/viewer)
	var/list/images = list()
	var/mob/living/carbon/human/M = parent
	var/icon_file = get_icon()
	if(!icon_file)
		return images

	for(var/state in get_overlay_states(viewer))
		var/icon/I = new/icon(icon = icon_file, icon_state = state)
		apply_icon_blending(I)

		var/image/img = image(I)
		img.pixel_x = -16
		if(M.tail_style.em_block)
			img.overlays += em_block_image_generic(img)

		img.layer = get_layer()
		img.plane = M.plane
		img.appearance_flags = M.appearance_flags

		images += img

	return images
