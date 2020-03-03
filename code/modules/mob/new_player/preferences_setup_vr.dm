/datum/preferences/update_preview_icon() // Lines up and un-overlaps character edit previews. Also un-splits taurs.
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	if(!mannequin.dna) // Special handling for preview icons before SSAtoms has initailized.
		mannequin.dna = new /datum/dna(null)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)
	COMPILE_OVERLAYS(mannequin)

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

//TFF 5/8/19 - add randomised sensor setting for random button clicking
/datum/preferences/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	sensorpref = rand(1,5)