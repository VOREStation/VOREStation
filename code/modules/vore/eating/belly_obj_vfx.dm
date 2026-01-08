// SEND_SIGNAL(COMSIG_BELLY_UPDATE_VORE_FX) is sometimes used when calling vore_fx() to send belly visuals
// to certain non-belly atoms. Not called here as vore_fx() is usually only called if a mob is in the belly.
// Don't forget it if you need to rework vore_fx().
/obj/belly/proc/vore_fx(mob/living/L, var/severity = 0)
	if(!istype(L))
		return
	if(!L.client)
		return
	if(L.previewing_belly && L.previewing_belly != src)
		return
	if(L.previewing_belly == src && L.vore_selected != src)
		L.previewing_belly = null
		return
	if(!L.show_vore_fx)
		L.clear_fullscreen("belly")
		L.previewing_belly = null
		return
	if(!belly_fullscreen)
		L.clear_fullscreen("belly")
		check_hud_disable(L)
		return

	if(colorization_enabled)
		var/atom/movable/screen/fullscreen/F = L.overlay_fullscreen("belly", /atom/movable/screen/fullscreen/belly, severity) // preserving save data
		var/datum/belly_overlays/lookup_belly_path = text2path("/datum/belly_overlays/[lowertext(belly_fullscreen)]")
		if(!lookup_belly_path)
			var/used_fullscreen = belly_fullscreen
			to_chat(owner, span_warning("The belly overlay ([used_fullscreen]) you've selected for [src] no longer exists. Please reselect your overlay."))
			belly_fullscreen = null
			log_runtime("Icon datum was not defined for [used_fullscreen]")

		var/alpha = min(belly_fullscreen_alpha, L.max_voreoverlay_alpha)
		F.icon = initial(lookup_belly_path.belly_icon)
		F.cut_overlays()
		var/image/I = image(F.icon, belly_fullscreen) //Would be cool if I could just include color and alpha in the image define so we don't have to copy paste
		I.color = belly_fullscreen_color
		I.alpha = alpha
		F.add_overlay(I)
		I = image(F.icon, belly_fullscreen+"-2")
		I.color = belly_fullscreen_color2
		I.alpha = alpha
		F.add_overlay(I)
		I = image(F.icon, belly_fullscreen+"-3")
		I.color = belly_fullscreen_color3
		I.alpha = alpha
		F.add_overlay(I)
		I = image(F.icon, belly_fullscreen+"-4")
		I.color = belly_fullscreen_color4
		I.alpha = alpha
		F.add_overlay(I)
		var/extra_mush = 0
		var/extra_mush_color = mush_color
		if(L.liquidbelly_visuals && ishuman(owner) && metabolism_overlay && metabolism_mush_ratio > 0)
			var/mob/living/carbon/human/H = owner
			var/datum/reagents/metabolism/ingested = H.ingested
			if(ingested && ingested.total_volume > 0)
				if(custom_ingested_color)
					extra_mush_color = custom_ingested_color
				else
					extra_mush_color = ingested.get_color()
				extra_mush = ingested.total_volume * metabolism_mush_ratio
			if(!mush_overlay)
				I = get_mush_overlay(extra_mush_color, min(custom_ingested_alpha, L.max_voreoverlay_alpha), max_ingested, ingested.total_volume)
				F.add_overlay(I)
		if(show_liquids && L.liquidbelly_visuals && mush_overlay && (owner.nutrition > 0 || max_mush == 0 || min_mush > 0 || (LAZYLEN(contents) * item_mush_val) > 0))
			I = get_mush_overlay(mush_color, min(mush_alpha, L.max_voreoverlay_alpha), max_mush, owner.nutrition + LAZYLEN(contents) * item_mush_val + extra_mush)
			var/stored_y = I.pixel_y
			F.add_overlay(I)
			if(metabolism_overlay && metabolism_mush_ratio > 0 && extra_mush > 0)
				var/total_mush_content = owner.nutrition + LAZYLEN(contents) * item_mush_val + extra_mush
				I = get_mush_extra_overlay(extra_mush_color, min(mush_alpha, (extra_mush / max(total_mush_content, 1)) * mush_alpha), stored_y)
				F.add_overlay(I)
		if(show_liquids && L.liquidbelly_visuals && liquid_overlay && reagents.total_volume)
			I = get_liquid_overlay()
			I.alpha = min(I.alpha, L.max_voreoverlay_alpha)
			F.add_overlay(I)
		F.update_for_view(L.client.view)
		return

	var/atom/movable/screen/fullscreen/F = L.overlay_fullscreen("belly", /atom/movable/screen/fullscreen/belly/fixed, severity) //preserving save data
	F.icon = 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore.dmi'
	F.cut_overlays()
	F.add_overlay(image(F.icon, belly_fullscreen))
	F.add_overlay(image(F.icon, belly_fullscreen+"-2"))
	F.add_overlay(image(F.icon, belly_fullscreen+"-3"))
	F.add_overlay(image(F.icon, belly_fullscreen+"-4"))
	var/image/I
	var/extra_mush = 0
	var/extra_mush_color = mush_color
	if(L.liquidbelly_visuals && ishuman(owner) && metabolism_overlay && metabolism_mush_ratio > 0)
		var/mob/living/carbon/human/H = owner
		var/datum/reagents/metabolism/ingested = H.ingested
		if(ingested && ingested.total_volume > 0)
			if(custom_ingested_color)
				extra_mush_color = custom_ingested_color
			else
				extra_mush_color = ingested.get_color()
			extra_mush = ingested.total_volume * metabolism_mush_ratio
		if(!mush_overlay)
			I = get_mush_overlay(extra_mush_color, custom_ingested_alpha, max_ingested, ingested.total_volume)
			F.add_overlay(I)
	if(show_liquids && L.liquidbelly_visuals && mush_overlay && (owner.nutrition > 0 || max_mush == 0 || min_mush > 0 || (LAZYLEN(contents) * item_mush_val) > 0))
		I = get_mush_overlay(mush_color, mush_alpha, max_mush, owner.nutrition + LAZYLEN(contents) * item_mush_val + extra_mush)
		I.alpha = mush_alpha
		var/stored_y = I.pixel_y
		F.add_overlay(I)
		if(metabolism_overlay && metabolism_mush_ratio > 0 && extra_mush > 0)
			var/total_mush_content = owner.nutrition + LAZYLEN(contents) * item_mush_val + extra_mush
			I = get_mush_extra_overlay(extra_mush_color, min(mush_alpha, (extra_mush / max(total_mush_content, 1)) * mush_alpha), stored_y)
			F.add_overlay(I)
	if(show_liquids && L.liquidbelly_visuals && liquid_overlay && reagents.total_volume)
		I = get_liquid_overlay()
		F.add_overlay(I)
	F.update_for_view(L.client.view)
	check_hud_disable(L)

/obj/belly/proc/check_hud_disable(var/mob/living/living_prey)
	if(disable_hud && living_prey != owner)
		if(living_prey?.hud_used?.hud_shown)
			to_chat(living_prey, span_vnotice("((Your pred has disabled huds in their belly. Turn off vore FX and hit F12 to get it back; or relax, and enjoy the serenity.))"))
			living_prey.toggle_hud_vis(TRUE)

/obj/belly/proc/get_mush_overlay(color, alpha, limit, content)
	var/image/I = image('icons/mob/vore_fullscreens/bubbles.dmi', "mush")
	I.color = color
	I.pixel_y = -450 + (450 / max(limit, 1) * max(min(limit, content), 1))
	if(I.pixel_y < -450 + (450 / 100 * min_mush))
		I.pixel_y = -450 + (450 / 100 * min_mush)
	I.alpha = alpha
	return I

/obj/belly/proc/get_mush_extra_overlay(color, alpha, stored_y)
	var/image/I = image('icons/mob/vore_fullscreens/bubbles.dmi', "mush")
	I.color = color
	I.pixel_y = stored_y
	I.alpha = alpha
	return I

/obj/belly/proc/get_liquid_overlay()
	var/image/I
	if(digest_mode == DM_HOLD && item_digest_mode == IM_HOLD)
		I = image('icons/mob/vore_fullscreens/bubbles.dmi', "calm")
	else
		I = image('icons/mob/vore_fullscreens/bubbles.dmi', "bubbles")
	if(custom_reagentcolor)
		I.color = custom_reagentcolor
	else
		I.color = reagentcolor
	if(custom_reagentalpha)
		I.alpha = custom_reagentalpha
	else
		I.alpha = max(150, min(custom_max_volume, 255)) - (255 - belly_fullscreen_alpha)
	I.pixel_y = -450 + min((450 / custom_max_volume * reagents.total_volume), 450 / 100 * max_liquid_level)
	return I

/obj/belly/proc/vore_preview(mob/living/L)
	if(!istype(L) || !L.client)
		L.previewing_belly = null
		return
	L.previewing_belly = src
	vore_fx(L)

/obj/belly/proc/clear_preview(mob/living/L)
	L.previewing_belly = null
	L.clear_fullscreen("belly")
