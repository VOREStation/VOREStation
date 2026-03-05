// SEND_SIGNAL(COMSIG_BELLY_UPDATE_VORE_FX) is sometimes used when calling vore_fx() to send belly visuals
// to certain non-belly atoms. Not called here as vore_fx() is usually only called if a mob is in the belly.
// Don't forget it if you need to rework vore_fx().
/obj/belly/proc/vore_fx(mob/living/living_prey, var/severity = 0)
	if(!istype(living_prey))
		return
	if(!living_prey.client)
		return
	if(living_prey.previewing_belly && living_prey.previewing_belly != src)
		return
	if(living_prey.previewing_belly == src && living_prey.vore_selected != src)
		living_prey.previewing_belly = null
		return
	if(!living_prey.show_vore_fx)
		living_prey.clear_fullscreen("belly")
		living_prey.previewing_belly = null
		return
	if(!belly_fullscreen)
		living_prey.clear_fullscreen("belly")
		check_hud_disable(living_prey)
		return

	if(colorization_enabled)
		var/atom/movable/screen/fullscreen/fullscreen_overlay = living_prey.overlay_fullscreen("belly", /atom/movable/screen/fullscreen/belly, severity) // preserving save data
		var/datum/belly_overlays/lookup_belly_path = text2path("/datum/belly_overlays/[lowertext(belly_fullscreen)]")
		if(!lookup_belly_path)
			var/used_fullscreen = belly_fullscreen
			to_chat(owner, span_warning("The belly overlay ([used_fullscreen]) you've selected for [src] no longer exists. Please reselect your overlay."))
			belly_fullscreen = null
			log_runtime("Icon datum was not defined for [used_fullscreen]")

		var/alpha = min(belly_fullscreen_alpha, living_prey.max_voreoverlay_alpha)
		fullscreen_overlay.icon = initial(lookup_belly_path.belly_icon)
		fullscreen_overlay.cut_overlays()
		var/image/overlay_image = image(fullscreen_overlay.icon, belly_fullscreen) //Would be cool if overlay_image could just include color and alpha in the image define so we don't have to copy paste
		overlay_image.color = belly_fullscreen_color
		overlay_image.alpha = alpha
		fullscreen_overlay.add_overlay(overlay_image)
		overlay_image = image(fullscreen_overlay.icon, belly_fullscreen+"-2")
		overlay_image.color = belly_fullscreen_color2
		overlay_image.alpha = alpha
		fullscreen_overlay.add_overlay(overlay_image)
		overlay_image = image(fullscreen_overlay.icon, belly_fullscreen+"-3")
		overlay_image.color = belly_fullscreen_color3
		overlay_image.alpha = alpha
		fullscreen_overlay.add_overlay(overlay_image)
		overlay_image = image(fullscreen_overlay.icon, belly_fullscreen+"-4")
		overlay_image.color = belly_fullscreen_color4
		overlay_image.alpha = alpha
		fullscreen_overlay.add_overlay(overlay_image)
		var/extra_mush = 0
		var/extra_mush_color = mush_color
		if(living_prey.liquidbelly_visuals && ishuman(owner) && metabolism_overlay && metabolism_mush_ratio > 0)
			var/mob/living/carbon/human/human_owner = owner
			var/datum/reagents/metabolism/ingested = human_owner.ingested
			if(ingested && ingested.total_volume > 0)
				if(custom_ingested_color)
					extra_mush_color = custom_ingested_color
				else
					extra_mush_color = ingested.get_color()
				extra_mush = ingested.total_volume * metabolism_mush_ratio
			if(!mush_overlay)
				overlay_image = get_mush_overlay(extra_mush_color, min(custom_ingested_alpha, living_prey.max_voreoverlay_alpha), max_ingested, ingested.total_volume)
				fullscreen_overlay.add_overlay(overlay_image)
		if(show_liquids && living_prey.liquidbelly_visuals && mush_overlay && (owner.nutrition > 0 || max_mush == 0 || min_mush > 0 || (LAZYLEN(contents) * item_mush_val) > 0))
			overlay_image = get_mush_overlay(mush_color, min(mush_alpha, living_prey.max_voreoverlay_alpha), max_mush, owner.nutrition + LAZYLEN(contents) * item_mush_val + extra_mush)
			var/stored_y = overlay_image.pixel_y
			fullscreen_overlay.add_overlay(overlay_image)
			if(metabolism_overlay && metabolism_mush_ratio > 0 && extra_mush > 0)
				var/total_mush_content = owner.nutrition + LAZYLEN(contents) * item_mush_val + extra_mush
				overlay_image = get_mush_extra_overlay(extra_mush_color, min(mush_alpha, (extra_mush / max(total_mush_content, 1)) * mush_alpha), stored_y)
				fullscreen_overlay.add_overlay(overlay_image)
		if(show_liquids && living_prey.liquidbelly_visuals && liquid_overlay && reagents.total_volume)
			overlay_image = get_liquid_overlay()
			overlay_image.alpha = min(overlay_image.alpha, living_prey.max_voreoverlay_alpha)
			fullscreen_overlay.add_overlay(overlay_image)
		fullscreen_overlay.update_for_view(living_prey.client.view)
		return

	var/atom/movable/screen/fullscreen/fullscreen_overlay = living_prey.overlay_fullscreen("belly", /atom/movable/screen/fullscreen/belly/fixed, severity) //preserving save data
	fullscreen_overlay.icon = 'icons/mob/vore_fullscreens/ui_lists/screen_full_vore.dmi'
	fullscreen_overlay.cut_overlays()
	fullscreen_overlay.add_overlay(image(fullscreen_overlay.icon, belly_fullscreen))
	fullscreen_overlay.add_overlay(image(fullscreen_overlay.icon, belly_fullscreen+"-2"))
	fullscreen_overlay.add_overlay(image(fullscreen_overlay.icon, belly_fullscreen+"-3"))
	fullscreen_overlay.add_overlay(image(fullscreen_overlay.icon, belly_fullscreen+"-4"))
	var/image/overlay_image
	var/extra_mush = 0
	var/extra_mush_color = mush_color
	if(living_prey.liquidbelly_visuals && ishuman(owner) && metabolism_overlay && metabolism_mush_ratio > 0)
		var/mob/living/carbon/human/human_owner = owner
		var/datum/reagents/metabolism/ingested = human_owner.ingested
		if(ingested && ingested.total_volume > 0)
			if(custom_ingested_color)
				extra_mush_color = custom_ingested_color
			else
				extra_mush_color = ingested.get_color()
			extra_mush = ingested.total_volume * metabolism_mush_ratio
		if(!mush_overlay)
			overlay_image = get_mush_overlay(extra_mush_color, custom_ingested_alpha, max_ingested, ingested.total_volume)
			fullscreen_overlay.add_overlay(overlay_image)
	if(show_liquids && living_prey.liquidbelly_visuals && mush_overlay && (owner.nutrition > 0 || max_mush == 0 || min_mush > 0 || (LAZYLEN(contents) * item_mush_val) > 0))
		overlay_image = get_mush_overlay(mush_color, mush_alpha, max_mush, owner.nutrition + LAZYLEN(contents) * item_mush_val + extra_mush)
		overlay_image.alpha = mush_alpha
		var/stored_y = overlay_image.pixel_y
		fullscreen_overlay.add_overlay(overlay_image)
		if(metabolism_overlay && metabolism_mush_ratio > 0 && extra_mush > 0)
			var/total_mush_content = owner.nutrition + LAZYLEN(contents) * item_mush_val + extra_mush
			overlay_image = get_mush_extra_overlay(extra_mush_color, min(mush_alpha, (extra_mush / max(total_mush_content, 1)) * mush_alpha), stored_y)
			fullscreen_overlay.add_overlay(overlay_image)
	if(show_liquids && living_prey.liquidbelly_visuals && liquid_overlay && reagents.total_volume)
		overlay_image = get_liquid_overlay()
		fullscreen_overlay.add_overlay(overlay_image)
	fullscreen_overlay.update_for_view(living_prey.client.view)
	check_hud_disable(living_prey)

/obj/belly/proc/check_hud_disable(var/mob/living/living_prey)
	if(disable_hud && living_prey != owner)
		if(living_prey?.hud_used?.hud_shown)
			to_chat(living_prey, span_vnotice("((Your pred has disabled huds in their belly. Turn off vore FX and hit F12 to get it back; or relax, and enjoy the serenity.))"))
			living_prey.toggle_hud_vis(TRUE)

/obj/belly/proc/get_mush_overlay(color, alpha, limit, content)
	var/image/overlay_image = image('icons/mob/vore_fullscreens/bubbles.dmi', "mush")
	overlay_image.color = color
	overlay_image.pixel_y = -450 + (450 / max(limit, 1) * max(min(limit, content), 1))
	if(overlay_image.pixel_y < -450 + (450 / 100 * min_mush))
		overlay_image.pixel_y = -450 + (450 / 100 * min_mush)
	overlay_image.alpha = alpha
	return overlay_image

/obj/belly/proc/get_mush_extra_overlay(color, alpha, stored_y)
	var/image/overlay_image = image('icons/mob/vore_fullscreens/bubbles.dmi', "mush")
	overlay_image.color = color
	overlay_image.pixel_y = stored_y
	overlay_image.alpha = alpha
	return overlay_image

/obj/belly/proc/get_liquid_overlay()
	var/image/overlay_image
	if(digest_mode == DM_HOLD && item_digest_mode == IM_HOLD)
		overlay_image = image('icons/mob/vore_fullscreens/bubbles.dmi', "calm")
	else
		overlay_image = image('icons/mob/vore_fullscreens/bubbles.dmi', "bubbles")
	if(custom_reagentcolor)
		overlay_image.color = custom_reagentcolor
	else
		overlay_image.color = reagentcolor
	if(custom_reagentalpha)
		overlay_image.alpha = custom_reagentalpha
	else
		overlay_image.alpha = max(150, min(custom_max_volume, 255)) - (255 - belly_fullscreen_alpha)
	overlay_image.pixel_y = -450 + min((450 / custom_max_volume * reagents.total_volume), 450 / 100 * max_liquid_level)
	return overlay_image

/obj/belly/proc/vore_preview(mob/living/living_prey)
	if(!istype(living_prey) || !living_prey.client)
		living_prey.previewing_belly = null
		return
	living_prey.previewing_belly = src
	vore_fx(living_prey)

/obj/belly/proc/clear_preview(mob/living/living_prey)
	living_prey.previewing_belly = null
	living_prey.clear_fullscreen("belly")
