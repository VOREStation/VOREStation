/datum/preferences/update_preview_icon() // Lines up and un-overlaps character edit previews. Also un-splits taurs.
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)

	preview_icon = icon('icons/effects/128x72_vr.dmi', bgstate)
	preview_icon.Scale(128, 72)

	mannequin.dir = NORTH
	var/icon/stamp = getFlatIcon(mannequin)
	stamp.Scale(stamp.Width()*size_multiplier,stamp.Height()*size_multiplier)
	preview_icon.Blend(stamp, ICON_OVERLAY, 64-stamp.Width()/2, 5)

	mannequin.dir = WEST
	stamp = getFlatIcon(mannequin)
	stamp.Scale(stamp.Width()*size_multiplier,stamp.Height()*size_multiplier)
	preview_icon.Blend(stamp, ICON_OVERLAY, 16-stamp.Width()/2, 5)

	mannequin.dir = SOUTH
	stamp = getFlatIcon(mannequin)
	stamp.Scale(stamp.Width()*size_multiplier,stamp.Height()*size_multiplier)
	preview_icon.Blend(stamp, ICON_OVERLAY, 112-stamp.Width()/2, 5)

	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.