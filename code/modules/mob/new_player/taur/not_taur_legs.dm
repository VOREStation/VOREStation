// This is for the Big legs that are NOT TAURIC AND DON'T NEED TO BE INVOLVED IN TAURIC LEGS AAAAAAAA
// These sprites should really be a seperate leg mode like digitigrade are.

/datum/sprite_accessory/tail/satyr
	name = "goat legs, colorable"
	icon = 'icons/mob/human_races/sprite_accessories/tails/not_tail_legs.dmi'
	icon_state = "satyr"
	hide_body_parts = list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT) //Exclude pelvis just in case.
	clip_mask_icon = 'icons/mob/human_races/sprite_accessories/biglegs.dmi'
	clip_mask_state = "taur_clip_mask_def" //Used to clip off the lower part of suits & uniforms.

/datum/sprite_accessory/tail/satyrtail
	name = "goat legs with tail, colorable"
	icon = 'icons/mob/human_races/sprite_accessories/tails/not_tail_legs.dmi'
	icon_state = "satyr"
	hide_body_parts = list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT) //Exclude pelvis just in case.
	clip_mask_icon = 'icons/mob/human_races/sprite_accessories/biglegs.dmi'
	clip_mask_state = "taur_clip_mask_def" //Used to clip off the lower part of suits & uniforms.
	extra_overlay = "horse" //I can't believe this works.

/datum/sprite_accessory/tail/synthetic_stilt_legs
	name = "synthetic stilt-legs, colorable"
	icon = 'icons/mob/human_races/sprite_accessories/tails/not_tail_legs.dmi'
	icon_state = "synth_stilts"
	extra_overlay = "synth_stilts_marking"
	hide_body_parts = list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT) //Exclude pelvis just in case.
	clip_mask_icon = 'icons/mob/human_races/sprite_accessories/biglegs.dmi'
	clip_mask_state = "taur_clip_mask_def" //Used to clip off the lower part of suits & uniforms.

/datum/sprite_accessory/tail/taur/bigleggy
	name = "Big Leggies"
	icon = 'icons/mob/human_races/sprite_accessories/biglegs.dmi'
	icon_state = "bigleggy"
	extra_overlay = "bigleggy_markings"
	vore_tail_sprite_variant = "bigleggy"
	fullness_icons = 3
	ani_state = "bigleggy_stanced"
	extra_overlay_w = "bigleggy_markings_stanced"
	clip_mask_state = "taur_clip_mask_def" //Leaving this here to make it clear it it's INTENTIONAL it shows above clothes. Use the marking if you want it to show UNDER clothes!

/datum/sprite_accessory/tail/taur/bigleggy/canine
	name = "Big Leggies (Canine Tail)"
	extra_overlay2 = "bigleggy_canine"
	extra_overlay2_w = "bigleggy_canine"

/datum/sprite_accessory/tail/taur/bigleggy/feline
	name = "Big Leggies (Feline Tail)"
	extra_overlay2 = "bigleggy_feline"
	extra_overlay2_w = "bigleggy_feline"

/datum/sprite_accessory/tail/taur/bigleggy/reptile
	name = "Big Leggies (Reptile Tail)"
	extra_overlay2 = "bigleggy_reptile"
	extra_overlay2_w = "bigleggy_reptile"

/datum/sprite_accessory/tail/taur/bigleggy/snake
	name = "Big Leggies (Snake Tail)"
	extra_overlay2 = "bigleggy_snake"
	extra_overlay2_w = "bigleggy_snake"

/datum/sprite_accessory/tail/taur/bigleggy/fox
	name = "Big Leggies (Fox Tail)"
	extra_overlay2 = "bigleggy_vulpine"
	extra_overlay2_w = "bigleggy_vulpine"

/datum/sprite_accessory/tail/taur/bigleggy/bird
	name = "Big Leggies (Bird)"
	extra_overlay = "bigleggy_m_bird"
	extra_overlay2 = "bigleggy_bird"
	extra_overlay_w = "bigleggy_m_bird_stanced"
	extra_overlay2_w = "bigleggy_bird"

/datum/sprite_accessory/tail/taur/bigleggy/plug
	name = "Big Leggies (Plug Tail)"
	extra_overlay2 = "bigleggy_plug"
	extra_overlay2_w = "bigleggy_plug"

/datum/sprite_accessory/tail/taur/bigleggy/AlienSlug
	name = "Big Leggies (Alien Slug Tail)"
	icon_state = "bigleggy_full_alienslug"
	extra_overlay = "bigleggy_alienslug"
	extra_overlay_w = "bigleggy_alienslug"
	extra_overlay2 = "bigleggy_alienslug_m"
	extra_overlay2_w = "bigleggy_alienslug_m"
