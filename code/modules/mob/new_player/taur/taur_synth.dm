/datum/sprite_accessory/tail/taur/sectdrone
	name = "Sect Drone (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_synth.dmi'
	icon_state = "sectdrone"
	extra_overlay = "sectdrone_markings"
	icon_sprite_tag = "sectdrone"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	vore_tail_sprite_variant = "SectDrone"
	belly_variant_when_loaf = TRUE
	struggle_anim = TRUE
	loaf_offset = 3
	fullness_icons = 3
	requires_clipping = TRUE
	clip_mask_state = "taur_clip_mask_sectdrone"

	msg_owner_disarm_run = "You quickly push %prey to the ground with your leg!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their leg!"

	msg_owner_disarm_walk = "You firmly push your leg down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their leg down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your leg down upon %prey's body, slowly applying pressure, crushing them against the floor!"
	msg_prey_harm_walk = "%owner methodically places their leg upon your body, slowly applying pressure, crushing you against the floor!"

	msg_owner_grab_success = "You pin %prey down on the ground with your front leg before using your other leg to pick them up, trapping them between two of your front legs!"
	msg_prey_grab_success = "%owner pins you down on the ground with their front leg before using their other leg to pick you up, trapping you between two of their front legs!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their leg, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/sectdrone/drone_wag
	name = "Sect Drone (Taur, Fat vwag)"
	icon_sprite_tag_fat = "fatsectdrone"
	ani_state = "fatsectdrone"
	extra_overlay_w = "fatsectdrone_markings"
	icon_sprite_tag = "sectdrone"

/datum/sprite_accessory/tail/taur/sectdrone/fat
	name = "Fat Sect Drone (Taur)"
	icon_state = "fatsectdrone"
	extra_overlay = "fatsectdrone_markings"
	icon_sprite_tag = "sectdrone"

/datum/sprite_accessory/tail/taur/horse/synthhorse
	name = "SynthHorse dual-color (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_synth.dmi'
	icon_state = "synthhorse_s"
	extra_overlay = "synthhorse_markings"
	extra_overlay2 = "synthhorse_glow"
	icon_sprite_tag = "synthhorse"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/synthfeline
	name = "SynthFeline dual-color (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_synth.dmi'
	icon_state = "synthfeline_s"
	extra_overlay = "synthfeline_markings"
	extra_overlay2 = "synthfeline_glow"
	icon_sprite_tag = "synthfeline"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/synthfeline/fat
	name = "Fat SynthFeline dual-color (Taur)"
	icon_state = "fatsynthfeline_s"
	extra_overlay = "fatsynthfeline_markings"
	extra_overlay2 = "fatsynthfeline_glow"
	icon_sprite_tag = "fatsynthfeline"

/datum/sprite_accessory/tail/taur/feline/synthfeline/fat_wag
	name = "SynthFeline dual-color (Taur, Fat vwag)"
	icon_sprite_tag_fat = "fatsynthfeline"
	ani_state = "fatsynthfeline_s"
	extra_overlay_w = "fatsynthfeline_markings"
	extra_overlay2_w = "fatsynthfeline_glow"

/datum/sprite_accessory/tail/taur/synthetic/syntheticagi
	name = "Synthetic chassis - agile (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_synth.dmi'
	icon_state = "synthtaur1_s"
	icon_sprite_tag = "synthtaur1"
	extra_overlay = "synthtaur1_markings"
	extra_overlay2 = "synthtaur1_glow"
	requires_clipping = TRUE
	clip_mask_state = "taur_clip_mask_synthtaur1"

/datum/sprite_accessory/tail/taur/synthetic/syntheticagi/fat
	name = "Synthetic chassis - agile (Taur, Fat)"
	icon_state = "synthtaur1_fat_s"
	icon_sprite_tag = "synthtaur1_fat"
	extra_overlay = "synthtaur1_fat_markings"
	extra_overlay2 = "synthtaur1_glow"
	clip_mask_state = "taur_clip_mask_synthtaur1"

/datum/sprite_accessory/tail/taur/synthetic/syntheticagi/fat_wag
	name = "Synthetic chassis - agile (Taur, Fat vwag)"
	icon_sprite_tag_fat = "synthtaur1_fat"
	ani_state = "synthtaur1_fat_s"
	extra_overlay_w = "synthtaur1_fat_markings"
	extra_overlay2_w = "synthtaur1_glow"
	clip_mask_state = "taur_clip_mask_synthtaur1"

/datum/sprite_accessory/tail/taur/lizard/synthlizard
	name = "SynthLizard dual-color (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_synth.dmi'
	icon_state = "synthlizard_s"
	icon_sprite_tag = "synthlizard"
	extra_overlay = "synthlizard_markings"
	extra_overlay2 = "synthlizard_glow"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3
	vore_tail_sprite_variant = "SynthLiz"
	fullness_icons = 1

/datum/sprite_accessory/tail/taur/lizard/synthlizard/fat
	name = "Fat SynthLizard dual-color (Taur)"
	icon_state = "fatsynthlizard_s"
	icon_sprite_tag = "fatsynthlizard"
	extra_overlay = "fatsynthlizard_markings"
	extra_overlay2 = "fatsynthlizard_glow"

/datum/sprite_accessory/tail/taur/lizard/synthlizard/fat_wag
	name = "SynthLizard dual-color (Taur, Fat vwag)"
	icon_sprite_tag_fat = "fatsynthlizard"
	ani_state = "fatsynthlizard_s"
	extra_overlay_w = "fatsynthlizard_markings"
	extra_overlay2_w = "fatsynthlizard_glow"

/datum/sprite_accessory/tail/taur/naga/synthnaga
	name = "Synthetic Naga dual-color (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_synth.dmi'
	icon_state = "synthnaga"
	icon_sprite_tag = "synthnaga"
	extra_overlay = "synthnaga_belly"

/datum/sprite_accessory/tail/taur/longvirus
	name = "Long Virus (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_synth.dmi'
	icon_state = "longvirus_s"
	extra_overlay = "longvirus_markings"
	icon_sprite_tag = "longvirus"

/datum/sprite_accessory/tail/taur/wolf/synthwolf
	name = "SynthWolf dual-color (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_synth.dmi'
	icon_state = "synthwolf_s"
	icon_sprite_tag = "synthwolf"
	extra_overlay = "synthwolf_markings"
	extra_overlay2 = "synthwolf_glow"
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/wolf/synthwolf/fat
	name = "Fat SynthWolf dual-color (Taur)"
	icon_state = "fatsynthwolf_s"
	icon_sprite_tag = "fatsynthwolf"
	extra_overlay = "fatsynthwolf_markings"
	extra_overlay2 = "fatsynthwolf_glow"

/datum/sprite_accessory/tail/taur/wolf/synthwolf/fat_wag
	name = "SynthWolf dual-color (Taur, Fat vwag)"
	icon_sprite_tag_fat = "fatsynthwolf"
	ani_state = "fatsynthwolf_s"
	extra_overlay_w = "fatsynthwolf_markings"
	extra_overlay2_w = "fatsynthwolf_glow"
