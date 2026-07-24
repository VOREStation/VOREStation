/datum/sprite_accessory/tail/taur/drake //Enabling on request, no suit compatibility but then again see 2 above.
	name = "Drake (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_reptile.dmi'
	icon_state = "drake_s"
	extra_overlay = "drake_markings"
///	suit_sprites = 'icons/mob/taursuits_drake.dmi'
	suit_sprites = 'icons/mob/taursuits_drake_ch.dmi'
	icon_sprite_tag = "drake"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 6
	vore_tail_sprite_variant = "Drake"
	belly_variant_when_loaf = TRUE
	fullness_icons = 3

/datum/sprite_accessory/tail/taur/drake/fat
	name = "Fat Drake (Taur)"
	icon_state = "fatdrake_s"
	extra_overlay = "fatdrake_markings"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 6

/datum/sprite_accessory/tail/taur/drake/drake_vwag
	name = "Drake (Taur, Fat vwag)"
	icon_state = "drake_s"
	extra_overlay = "drake_markings"
	ani_state = "fatdrake_s"
	extra_overlay_w = "fatdrake_markings"
	can_loaf = TRUE

/datum/sprite_accessory/tail/taur/drake/extended
	name = "Fat Drake Extended (Taur)"
	icon_state = "extended_fatdrake"
	extra_overlay = "extended_fatdrake_markings"
	extra_overlay2 = "extended_fatdrake_markings2"
	fullness_icons = 2
	can_loaf = TRUE //Soon //Actually, NOW
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi' //This file needs to be nuked during the removal of 'taurs_ch_loaf.dmi' into the normal loaf file.
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/drake/extended/spotty
	name = "Fat Spotted Drake Extended (Taur)"
	vore_tail_sprite_variant = "FatDrake"
	icon_state = "spottedextended_fatdrake"
	extra_overlay = "spottedextended_fatdrake_markings"
	extra_overlay_w = "spottedextended_fatdrake_markings"
	extra_overlay2 = "spottedextended_fatdrake_markings_2"
	extra_overlay2_w = "spottedextended_fatdrake_markings_2"
	fullness_icons = 2
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi' //This file needs to be nuked during the removal of 'taurs_ch_loaf.dmi' into the normal loaf file.
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/drake/spotty
	name = "Spotted Drake (Taur, Tricolor)"
	icon_state = "spotteddrake_s"
	extra_overlay = "spotteddrake_markings"
	extra_overlay_w = "spotteddrake_markings"
	extra_overlay2 = "spotteddrake_markings_2"
	extra_overlay2_w = "spotteddrake_markings_2"
	suit_sprites = 'icons/mob/taursuits_drake_ch.dmi'
	icon_sprite_tag = "drake"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi' //This file needs to be nuked during the removal of 'taurs_ch_loaf.dmi' into the normal loaf file.
	loaf_offset = 6

/datum/sprite_accessory/tail/taur/drake/fat/spotty
	name = "Fat Spotted Drake (Taur, Tricolor)"
	vore_tail_sprite_variant = "FatDrake"
	icon_state = "fatspotteddrake_s"
	extra_overlay = "fatspotteddrake_markings"
	extra_overlay_w = "fatspotteddrake_markings"
	extra_overlay2 = "fatspotteddrake_markings_2"
	extra_overlay2_w = "fatspotteddrake_markings_2"
	fullness_icons = 2
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi' //This file needs to be nuked during the removal of 'taurs_ch_loaf.dmi' into the normal loaf file.
	loaf_offset = 6

/datum/sprite_accessory/tail/taur/drake/extended_alt
	name = "Drake Extended (Taur)"
	vore_tail_sprite_variant = "Drake"
	icon_state = "extended_drake"
	extra_overlay = "extended_drake_markings"
	extra_overlay_w = "extended_drake_markings"
	extra_overlay2 = "extended_drake_markings_2"
	extra_overlay2_w = "extended_drake_markings_2"
	fullness_icons = 3
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/drake/extended_alt/spotted
	name = "Spotted Drake Extended (Taur)"
	vore_tail_sprite_variant = "Drake"
	icon_state = "spottedextended_drake"
	extra_overlay = "spottedextended_drake_markings"
	extra_overlay_w = "spottedextended_drake_markings"
	extra_overlay2 = "spottedextended_drake_markings_2"
	extra_overlay2_w = "spottedextended_drake_markings_2"
	fullness_icons = 3
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi' //This file needs to be nuked during the removal of 'taurs_ch_loaf.dmi' into the normal loaf file.
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/lizard
	name = "Lizard (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_reptile.dmi'
	icon_state = "lizard_s"
	suit_sprites = 'icons/mob/taursuits_lizard_ch.dmi'
	icon_sprite_tag = "lizard"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 5
	vore_tail_sprite_variant = "Lizard"
	fullness_icons = 1

/datum/sprite_accessory/tail/taur/lizard/fatlizard
	name = "Fat Lizard (Taur)"
	icon_state = "fatlizard_s"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/lizard/lizard_wag
	name = "Lizard (Taur, Fat vwag)"
	icon_state = "lizard_s"
	ani_state = "fatlizard_s"

/datum/sprite_accessory/tail/taur/lizard/lizard_2c
	name = "Lizard dual-color (Taur)"
	icon_state = "lizard_s"
	extra_overlay = "lizard_markings"
	//icon_sprite_tag = "lizard2c"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/lizard/fatlizard_2c
	name = "Fat Lizard (Taur, dual-color)"
	icon_state = "fatlizard_s"
	extra_overlay = "fatlizard_markings"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/lizard/lizard_2c_wag
	name = "Fat Lizard (Taur, dual-color, Fat vwag)"
	icon_state = "lizard_s"
	extra_overlay = "lizard_markings"
	ani_state = "fatlizard_s"
	extra_overlay_w = "fatlizard_markings"

/datum/sprite_accessory/tail/taur/lizard/spotty
	name = "Spotted Lizard (Taur, Tricolor)"
	icon_state = "spottedlizard_s"
	extra_overlay = "spottedlizard_markings"
	extra_overlay_w = "spottedlizard_markings"
	extra_overlay2 = "spottedlizard_markings_2"
	extra_overlay2_w = "spottedlizard_markings_2"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi' //This file needs to be nuked during the removal of 'taurs_ch_loaf.dmi' into the normal loaf file.
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/lizard/spotty_fat
	name = "Fat Spotted Lizard (Taur, Tricolor)"
	icon_state = "fatspottedlizard_s"
	extra_overlay = "fatspottedlizard_markings"
	extra_overlay_w = "fatspottedlizard_markings"
	extra_overlay2 = "fatspottedlizard_markings_2"
	extra_overlay2_w = "fatspottedlizard_markings_2"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi' //This file needs to be nuked during the removal of 'taurs_ch_loaf.dmi' into the normal loaf file.
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/naga
	name = "Naga (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_reptile.dmi'
	icon_state = "naga_s"
	suit_sprites = 'icons/mob/taursuits_naga.dmi'
	//icon_sprite_tag = "naga"
	vore_tail_sprite_variant = "Naga"
	fullness_icons = 1

	msg_owner_help_walk = "You carefully slither around %prey."
	msg_prey_help_walk = "%owner's huge tail slithers past beside you!"

	msg_owner_help_run = "You carefully slither around %prey."
	msg_prey_help_run = "%owner's huge tail slithers past beside you!"

	msg_owner_disarm_run = "Your tail slides over %prey, pushing them down to the ground!"
	msg_prey_disarm_run = "%owner's tail slides over you, forcing you down to the ground!"

	msg_owner_disarm_walk = "You push down on %prey with your tail, pinning them down under you!"
	msg_prey_disarm_walk = "%owner pushes down on you with their tail, pinning you down below them!"

	msg_owner_harm_run = "Your heavy tail carelessly slides past %prey, crushing them!"
	msg_prey_harm_run = "%owner quickly goes over your body, carelessly crushing you with their heavy tail!"

	msg_owner_harm_walk = "Your heavy tail slowly and methodically slides down upon %prey, crushing against the floor below!"
	msg_prey_harm_walk = "%owner's thick, heavy tail slowly and methodically slides down upon your body, mercilessly crushing you into the floor below!"

	msg_owner_grab_success = "You slither over %prey with your large, thick tail, smushing them against the ground before coiling up around them, trapping them within the tight confines of your tail!"
	msg_prey_grab_success = "%owner slithers over you with their large, thick tail, smushing you against the ground before coiling up around you, trapping you within the tight confines of their tail!"

	msg_owner_grab_fail = "You squish %prey under your large, thick tail, forcing them onto the ground!"
	msg_prey_grab_fail = "%owner pins you under their large, thick tail, forcing you onto the ground!"

	msg_prey_stepunder = "You jump over %prey's thick tail."
	msg_owner_stepunder = "%owner bounds over your tail."

/datum/sprite_accessory/tail/taur/naga/fat
	name = "Naga (Taur, Fat, dual color)"
	icon_state = "fatnaga_s"
	extra_overlay = "fatnaga_markings"
	suit_sprites = null

/datum/sprite_accessory/tail/taur/naga/naga_2c
	name = "Naga dual-color (Taur)"
	icon_state = "naga_s"
	extra_overlay = "naga_markings"
	//icon_sprite_tag = "naga2c"

/datum/sprite_accessory/tail/taur/naga/alt
	name = "Naga alt (Taur)"
	icon_state = "naga_alt_s"
	vore_tail_sprite_variant = "NagaAlt"
	fullness_icons = 1

/datum/sprite_accessory/tail/taur/naga/alt/second
	name = "Naga dual-color alt (Taur)"
	extra_overlay = "naga_alt_markings"

/datum/sprite_accessory/tail/taur/naga/alt_2c
	name = "Naga alt style dual-color (Taur)"
	suit_sprites = 'icons/mob/taursuits_naga.dmi' //TODO: PORT CHOMPS NAGA_ALT AND MAKE THESE NAGA_ALT.
	icon_state = "altnaga_s"
	extra_overlay = "altnaga_markings"
	//icon_sprite_tag = "altnaga2c"

/datum/sprite_accessory/tail/taur/naga/alt_3c
	name = "Naga alt style tri-color (Taur)"
	suit_sprites = 'icons/mob/taursuits_naga.dmi' //TODO: PORT CHOMPS NAGA_ALT AND MAKE THESE NAGA_ALT.
	icon_state = "altnaga_s"
	extra_overlay = "altnaga_markings"
	extra_overlay2 = "altnaga_stripes"

/datum/sprite_accessory/tail/taur/naga/alt_3c_rattler
	name = "Naga alt style tri-color, rattler (Taur)"
	suit_sprites = 'icons/mob/taursuits_naga.dmi' //TODO: PORT CHOMPS NAGA_ALT AND MAKE THESE NAGA_ALT.
	icon_state = "altnaga_s"
	extra_overlay = "altnaga_markings"
	extra_overlay2 = "altnaga_rattler"

/datum/sprite_accessory/tail/taur/naga/alt_3c_tailmaw
	name = "Naga alt style tri-color, tailmaw (Taur)"
	suit_sprites = 'icons/mob/taursuits_naga.dmi' //TODO: PORT CHOMPS NAGA_ALT AND MAKE THESE NAGA_ALT.
	icon_state = "altnagatailmaw_s"
	extra_overlay = "altnagatailmaw_markings"
	extra_overlay2 = "altnagatailmaw_eyes"

/datum/sprite_accessory/tail/taur/noodle
	name = "Eastern Dragon (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_reptile.dmi'
	icon_state = "noodle_s"
	extra_overlay = "noodle_markings"
	extra_overlay2 = "noodle_markings_2"
	suit_sprites = 'icons/mob/taursuits_noodle.dmi'
	clip_mask_state = "taur_clip_mask_noodle"
	icon_sprite_tag = "noodle"

/datum/sprite_accessory/tail/taur/teshari // chickenbutt
	name = "Teshari dual-color (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_teshari.dmi'
	icon_loaf = 'icons/mob/vore/taurs_teshari_loaf.dmi'
	icon_state = "tesh"
	icon_sprite_tag = "tesh"
	extra_overlay = "tesh_markings"
	can_loaf = TRUE
	belly_variant_when_loaf = TRUE
	loaf_offset = 4
	fullness_icons = 1
	vore_tail_sprite_variant = "Tesh"

/datum/sprite_accessory/tail/taur/teshari/alt
	name = "Teshari dual-color Alt (Taur)"
	extra_overlay = "tesh_markings_alt"
