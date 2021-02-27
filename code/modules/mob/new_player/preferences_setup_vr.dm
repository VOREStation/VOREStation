/datum/preferences/update_preview_icon() // Lines up and un-overlaps character edit previews. Also un-splits taurs.
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	if(!mannequin.dna) // Special handling for preview icons before SSAtoms has initailized.
		mannequin.dna = new /datum/dna(null)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)
	mannequin.update_transform()
	mannequin.toggle_tail_vr(setting = TRUE)
	mannequin.toggle_wing_vr(setting = TRUE)
	COMPILE_OVERLAYS(mannequin)

	update_character_previews(new /mutable_appearance(mannequin))

//TFF 5/8/19 - add randomised sensor setting for random button clicking
/datum/preferences/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	sensorpref = rand(1,5)