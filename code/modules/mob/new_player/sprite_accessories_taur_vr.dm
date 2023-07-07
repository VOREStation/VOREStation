/*
////////////////////////////
/  =--------------------=  /
/  == Taur Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

// Taur sprites are now a subtype of tail since they are mutually exclusive anyway.

/datum/sprite_accessory/tail/taur
	name = "You should not see this..."
	icon = 'icons/mob/vore/taurs_vr.dmi'
	do_colouration = 1 // Yes color, using tail color
	color_blend_mode = ICON_MULTIPLY  // The sprites for taurs are designed for ICON_MULTIPLY

	can_ride = TRUE			//whether we're real rideable taur or just in that category

	//Could do nested lists but it started becoming a nightmare. It'd be more fun for lookups of a_intent and m_intent, but then subtypes need to
	//duplicate all the messages, and it starts getting awkward. These are singletons, anyway!

	//Messages to owner when stepping on/over
	var/msg_owner_help_walk		= "You carefully step over %prey."
	var/msg_owner_help_run		= "You carefully step over %prey."
	var/msg_owner_harm_walk		= "You methodically place your foot down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	var/msg_owner_harm_run		= "You carelessly step down onto %prey, crushing them!"
	var/msg_owner_disarm_walk	= "You firmly push your foot down on %prey, painfully but harmlessly pinning them to the ground!"
	var/msg_owner_disarm_run	= "You quickly push %prey to the ground with your foot!"
	var/msg_owner_grab_fail		= "You step down onto %prey, squishing them and forcing them down to the ground!"
	var/msg_owner_grab_success	= "You pin %prey down onto the floor with your foot and curl your toes up around their body, trapping them inbetween them!"

	//Messages to prey when stepping on/over
	var/msg_prey_help_walk		= "%owner steps over you carefully!"
	var/msg_prey_help_run		= "%owner steps over you carefully!"
	var/msg_prey_harm_walk		= "%owner methodically places their foot upon your body, slowly applying pressure, crushing you against the floor below!"
	var/msg_prey_harm_run		= "%owner steps carelessly on your body, crushing you!"
	var/msg_prey_disarm_walk	= "%owner firmly pushes their foot down on you, quite painfully but harmlessly pinning you to the ground!"
	var/msg_prey_disarm_run		= "%owner pushes you down to the ground with their foot!"
	var/msg_prey_grab_fail		= "%owner steps down and squishes you with their foot, forcing you down to the ground!"
	var/msg_prey_grab_success	= "%owner pins you down to the floor with their foot and curls their toes up around your body, trapping you inbetween them!"

	//Messages for smalls moving under larges
	var/msg_owner_stepunder		= "%owner runs between your legs." //Weird becuase in the case this is used, %owner is the 'bumper' (src)
	var/msg_prey_stepunder		= "You run between %prey's legs." //Same, inverse
	hide_body_parts	= list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT) //Exclude pelvis just in case.
	clip_mask_icon = 'icons/mob/vore/taurs_vr.dmi'
	clip_mask_state = "taur_clip_mask_def" //Used to clip off the lower part of suits & uniforms.

// Species-unique long tails/taurhalves

// Tails/taurhalves for everyone

/datum/sprite_accessory/tail/taur/wolf
	name = "Wolf (Taur)"
	icon_state = "wolf_s"
	under_sprites = 'icons/mob/taursuits_wolf_vr.dmi'
	suit_sprites = 'icons/mob/taursuits_wolf_vr.dmi'
	icon_sprite_tag = "wolf"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 4

/datum/sprite_accessory/tail/taur/wolf/fatwolf
	name = "Fat Wolf (Taur)"
	icon_state = "fatwolf_s"
	//icon_sprite_tag = "wolf"	//This could be modified later.
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/wolf/wolf_wag
	name = "Wolf (Taur, Fat vwag)"
	icon_state = "wolf_s"
	ani_state = "fatwolf_s"

/datum/sprite_accessory/tail/taur/wolf/wolf_2c
	name = "Wolf 3-color (Taur)"
	icon_state = "wolf_s"
	extra_overlay = "wolf_markings"
	extra_overlay2 = "wolf_markings_2"
	//icon_sprite_tag = "wolf2c"

/datum/sprite_accessory/tail/taur/wolf/fatwolf_2c
	name = "Fat Wolf 3-color (Taur)"
	icon = 'icons/mob/vore/taurs_ch.dmi' //CHOMPEdit
	icon_state = "fatwolf_s"
	extra_overlay = "fatwolf_markings"
	extra_overlay2 = "fatwolf_markings_2" //CHOMPEdit
	//icon_sprite_tag = "fatwolf2c"
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/wolf/wolf_2c_wag
	name = "Wolf 3-color (Taur, Fat vwag)"
	icon = 'icons/mob/vore/taurs_ch.dmi' //CHOMPEdit
	icon_state = "wolf_s"
	extra_overlay = "wolf_markings"
	extra_overlay2 = "wolf_markings_2"
	ani_state = "fatwolf_s"
	extra_overlay_w = "fatwolf_markings"
	extra_overlay2_w = "fatwolf_markings_2" //CHOMPEdit

/datum/sprite_accessory/tail/taur/wolf/synthwolf
	name = "SynthWolf dual-color (Taur)"
	icon_state = "synthwolf_s"
	extra_overlay = "synthwolf_markings"
	extra_overlay2 = "synthwolf_glow"
	//icon_sprite_tag = "synthwolf"
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/wolf/fatsynthwolf
	name = "Fat SynthWolf dual-color (Taur)"
	icon_state = "fatsynthwolf_s"
	extra_overlay = "fatsynthwolf_markings"
	extra_overlay2 = "fatsynthwolf_glow"
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/wolf/fatsynthwolf_wag
	name = "SynthWolf dual-color (Taur, Fat vwag)"
	icon_state = "synthwolf_s"
	extra_overlay = "synthwolf_markings"
	extra_overlay2 = "synthwolf_glow"
	ani_state = "fatsynthwolf_s"
	extra_overlay_w = "fatsynthwolf_markings"
	extra_overlay2_w = "fatsynthwolf_glow"

/datum/sprite_accessory/tail/taur/skunk
	name = "Skunk (Taur)"
	icon_state = "skunk_s"
	extra_overlay = "skunk_markings"
	extra_overlay2 = "skunk_markings_2"
	icon_sprite_tag = "skunk"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/naga
	name = "Naga (Taur)"
	icon_state = "naga_s"
	suit_sprites = 'icons/mob/taursuits_naga_vr.dmi'
	//icon_sprite_tag = "naga"

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

/datum/sprite_accessory/tail/taur/naga/naga_2c
	name = "Naga dual-color (Taur)"
	icon_state = "naga_s"
	extra_overlay = "naga_markings"
	//icon_sprite_tag = "naga2c"

/datum/sprite_accessory/tail/taur/naga/alt_2c
	name = "Naga alt style dual-color (Taur)"
	suit_sprites = 'icons/mob/taursuits_naga_alt_vr.dmi'
	icon_state = "altnaga_s"
	extra_overlay = "altnaga_markings"
	//icon_sprite_tag = "altnaga2c"

/datum/sprite_accessory/tail/taur/naga/alt_3c
	name = "Naga alt style tri-color (Taur)"
	suit_sprites = 'icons/mob/taursuits_naga_alt_vr.dmi'
	icon_state = "altnaga_s"
	extra_overlay = "altnaga_markings"
	extra_overlay2 = "altnaga_stripes"

/datum/sprite_accessory/tail/taur/naga/alt_3c_rattler
	name = "Naga alt style tri-color, rattler (Taur)"
	suit_sprites = 'icons/mob/taursuits_naga_alt_vr.dmi'
	icon_state = "altnaga_s"
	extra_overlay = "altnaga_markings"
	extra_overlay2 = "altnaga_rattler"

/datum/sprite_accessory/tail/taur/naga/alt_3c_tailmaw
	name = "Naga alt style tri-color, tailmaw (Taur)"
	suit_sprites = 'icons/mob/taursuits_naga_alt_vr.dmi'
	icon_state = "altnagatailmaw_s"
	extra_overlay = "altnagatailmaw_markings"
	extra_overlay2 = "altnagatailmaw_eyes"

/datum/sprite_accessory/tail/taur/horse
	name = "Horse (Taur)"
	icon_state = "horse_s"
	under_sprites = 'icons/mob/taursuits_horse_vr.dmi'
	suit_sprites = 'icons/mob/taursuits_horse_vr.dmi'
	icon_sprite_tag = "horse"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 4

	msg_owner_disarm_run = "You quickly push %prey to the ground with your hoof!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their hoof!"

	msg_owner_disarm_walk = "You firmly push your hoof down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their hoof down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your hoof down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their hoof upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey to the ground before scooping them up with your hooves!"
	msg_prey_grab_success = "%owner pins you to the ground before scooping you up with their hooves!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their hoof, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/horse/synthhorse
	name = "SynthHorse dual-color (Taur)"
	icon_state = "synthhorse_s"
	extra_overlay = "synthhorse_markings"
	extra_overlay2 = "synthhorse_glow"
	//icon_sprite_tag = "synthhorse"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/cow
	name = "Cow (Taur)"
	icon_state = "cow_s"
	suit_sprites = 'icons/mob/taursuits_cow_vr.dmi'
	icon_sprite_tag = "cow"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

	msg_owner_disarm_run = "You quickly push %prey to the ground with your hoof!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their hoof!"

	msg_owner_disarm_walk = "You firmly push your hoof down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their hoof down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your hoof down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their hoof upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey to the ground before scooping them up with your hooves!"
	msg_prey_grab_success = "%owner pins you to the ground before scooping you up with their hooves!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their hoof, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/deer
	name = "Deer dual-color (Taur)"
	icon_state = "deer_s"
	extra_overlay = "deer_markings"
	suit_sprites = 'icons/mob/taursuits_deer_vr.dmi'
	icon_sprite_tag = "deer"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 6

	msg_owner_disarm_run = "You quickly push %prey to the ground with your hoof!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their hoof!"

	msg_owner_disarm_walk = "You firmly push your hoof down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their hoof down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your hoof down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their hoof upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey to the ground before scooping them up with your hooves!"
	msg_prey_grab_success = "%owner pins you to the ground before scooping you up with their hooves!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their hoof, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/lizard
	name = "Lizard (Taur)"
	icon_state = "lizard_s"
//	suit_sprites = 'icons/mob/taursuits_lizard_vr.dmi'	///Chomp edit
	suit_sprites = 'icons/mob/taursuits_lizard_ch.dmi'
	icon_sprite_tag = "lizard"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/lizard/fatlizard
	name = "Fat Lizard (Taur)"
	icon_state = "fatlizard_s"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
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
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/lizard/fatlizard_2c
	name = "Fat Lizard (Taur, dual-color)"
	icon_state = "fatlizard_s"
	extra_overlay = "fatlizard_markings"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/lizard/lizard_2c_wag
	name = "Fat Lizard (Taur, dual-color, Fat vwag)"
	icon_state = "lizard_s"
	extra_overlay = "lizard_markings"
	ani_state = "fatlizard_s"
	extra_overlay_w = "fatlizard_markings"

/datum/sprite_accessory/tail/taur/lizard/synthlizard
	name = "SynthLizard dual-color (Taur)"
	icon_state = "synthlizard_s"
	extra_overlay = "synthlizard_markings"
	extra_overlay2 = "synthlizard_glow"
	//icon_sprite_tag = "synthlizard"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/lizard/fatsynthlizard
	name = "Fat SynthLizard dual-color (Taur)"
	icon_state = "fatsynthlizard_s"
	extra_overlay = "fatsynthlizard_markings"
	extra_overlay2 = "fatsynthlizard_glow"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/lizard/synthlizard_wag
	name = "SynthLizard dual-color (Taur, Fat vwag)"
	icon_state = "synthlizard_s"
	extra_overlay = "synthlizard_markings"
	extra_overlay2 = "synthlizard_glow"
	ani_state = "fatsynthlizard_s"
	extra_overlay_w = "fatsynthlizard_markings"
	extra_overlay2_w = "fatsynthlizard_glow"

/datum/sprite_accessory/tail/taur/spider
	name = "Spider (Taur)"
	icon_state = "spider_s"
	suit_sprites = 'icons/mob/taursuits_spider_vr.dmi'
	icon_sprite_tag = "spider"

	msg_owner_disarm_run = "You quickly push %prey to the ground with your leg!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their leg!"

	msg_owner_disarm_walk = "You firmly push your leg down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their leg down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your leg down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their leg upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey down on the ground with your front leg before using your other leg to pick them up, trapping them between two of your front legs!"
	msg_prey_grab_success = "%owner pins you down on the ground with their front leg before using their other leg to pick you up, trapping you between two of their front legs!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their leg, forcing you down to the ground!"

/datum/sprite_accessory/tail/taur/tents
	name = "Tentacles (Taur)"
	icon_state = "tent_s"
	icon_sprite_tag = "tentacle"
	can_ride = 0

	msg_prey_stepunder = "You run between %prey's tentacles."
	msg_owner_stepunder = "%owner runs between your tentacles."

	msg_owner_disarm_run = "You quickly push %prey to the ground with some of your tentacles!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with some of their tentacles!"

	msg_owner_disarm_walk = "You push down on %prey with some of your tentacles, pinning them down firmly under you!"
	msg_prey_disarm_walk = "%owner pushes down on you with some of their tentacles, pinning you down firmly below them!"

	msg_owner_harm_run = "Your tentacles carelessly slide past %prey, crushing them!"
	msg_prey_harm_run = "%owner quickly goes over your body, carelessly crushing you with their tentacles!"

	msg_owner_harm_walk = "Your tentacles methodically apply pressure on %prey's body, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner's thick tentacles methodically apply pressure on your body, crushing you into the floor below!"

	msg_owner_grab_success = "You slide over %prey with your tentacles, smushing them against the ground before wrapping one up around them, trapping them within the tight confines of your tentacles!"
	msg_prey_grab_success = "%owner slides over you with their tentacles, smushing you against the ground before wrapping one up around you, trapping you within the tight confines of their tentacles!"

	msg_owner_grab_fail = "You step down onto %prey with one of your tentacles, forcing them onto the ground!"
	msg_prey_grab_fail = "%owner steps down onto you with one of their tentacles, squishing you and forcing you onto the ground!"

/datum/sprite_accessory/tail/taur/feline
	name = "Feline (Taur)"
	icon_state = "feline_s"
	suit_sprites = 'icons/mob/taursuits_feline_vr.dmi'
	icon_sprite_tag = "feline"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/fatfeline
	name = "Fat Feline (Taur)"
	icon_state = "fatfeline_s"
	//icon_sprite_tag = "fatfeline"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/fatfeline_wag
	name = "Fat Feline (Taur, Fat vwag)"
	icon_state = "fatfeline_s"
	ani_state = "fatfeline_w"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/feline_2c
	name = "Feline 3-color (Taur)"
	icon_state = "feline_s"
	extra_overlay = "feline_markings"
	extra_overlay2 = "feline_markings_2"
	//icon_sprite_tag = "feline2c"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'

/datum/sprite_accessory/tail/taur/feline/fatfeline_2c
	name = "Fat Feline 3-color (Taur)"
	icon = 'icons/mob/vore/taurs_ch.dmi' //CHOMPEdit
	icon_state = "fatfeline_s"
	extra_overlay = "fatfeline_markings"
	extra_overlay2 = "fatfeline_markings_2" //CHOMPEdit
	//icon_sprite_tag = "fatfeline2c"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/feline_2c_wag
	name = "Feline 3-color (Taur, Fat vwag)"
	icon = 'icons/mob/vore/taurs_ch.dmi' //CHOMPEdit
	icon_state = "feline_s"
	extra_overlay = "feline_markings"
	extra_overlay2 = "feline_markings_2"
	ani_state = "fatfeline_s"
	extra_overlay_w = "fatfeline_markings"
	extra_overlay2_w = "fatfeline_markings_2" //CHOMPEdit
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/synthfeline
	name = "SynthFeline dual-color (Taur)"
	icon_state = "synthfeline_s"
	extra_overlay = "synthfeline_markings"
	extra_overlay2 = "synthfeline_glow"
	//icon_sprite_tag = "synthfeline"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/fatsynthfeline
	name = "Fat SynthFeline dual-color (Taur)"
	icon_state = "fatsynthfeline_s"
	extra_overlay = "fatsynthfeline_markings"
	extra_overlay2 = "fatsynthfeline_glow"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/synthfeline_wag
	name = "SynthFeline dual-color (Taur, Fat vwag)"
	icon_state = "synthfeline_s"
	extra_overlay = "synthfeline_markings"
	extra_overlay2 = "synthfeline_glow"
	ani_state = "fatsynthfeline_s"
	extra_overlay_w = "fatsynthfeline_markings"
	extra_overlay2_w = "fatsynthfeline_glow"

/datum/sprite_accessory/tail/taur/synthetic/syntheticagi
	name = "Synthetic chassis - agile (Taur)"
	icon_state = "synthtaur1_s"
	extra_overlay = "synthtaur1_markings"
	extra_overlay2 = "synthtaur1_glow"
	clip_mask_state = "taur_clip_mask_synthtaur1"

/datum/sprite_accessory/tail/taur/synthetic/syntheticagi_fat
	name = "Synthetic chassis - agile (Taur, Fat)"
	icon_state = "synthtaur1_s"
	extra_overlay = "synthtaur1_fat_markings"
	extra_overlay2 = "synthtaur1_glow"
	clip_mask_state = "taur_clip_mask_synthtaur1"

/datum/sprite_accessory/tail/taur/synthetic/syntheticagi_wag
	name = "Synthetic chassis - agile (Taur, Fat vwag)"
	icon_state = "synthtaur1_s"
	extra_overlay = "synthtaur1_markings"
	extra_overlay2 = "synthtaur1_glow"
	ani_state = "synthtaur1_s"
	extra_overlay_w = "synthtaur1_fat_markings"
	extra_overlay2_w = "synthtaur1_glow"
	clip_mask_state = "taur_clip_mask_synthtaur1"

/datum/sprite_accessory/tail/taur/slug
	name = "Slug (Taur)"
	icon_state = "slug_s"
	suit_sprites = 'icons/mob/taursuits_slug_vr.dmi'
	icon_sprite_tag = "slug"

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

/datum/sprite_accessory/tail/taur/frog
	name = "Frog (Taur)"
	icon_state = "frog_s"
	icon_sprite_tag = "frog"

/datum/sprite_accessory/tail/taur/thicktentacles
	name = "Thick Tentacles (Taur)"
	icon_state = "tentacle_s"
	can_ride = 0
	icon_sprite_tag = "thick_tentacles"

	msg_prey_stepunder = "You run between %prey's tentacles."
	msg_owner_stepunder = "%owner runs between your tentacles."

	msg_owner_disarm_run = "You quickly push %prey to the ground with some of your tentacles!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with some of their tentacles!"

	msg_owner_disarm_walk = "You push down on %prey with some of your tentacles, pinning them down firmly under you!"
	msg_prey_disarm_walk = "%owner pushes down on you with some of their tentacles, pinning you down firmly below them!"

	msg_owner_harm_run = "Your tentacles carelessly slide past %prey, crushing them!"
	msg_prey_harm_run = "%owner quickly goes over your body, carelessly crushing you with their tentacles!"

	msg_owner_harm_walk = "Your tentacles methodically apply pressure on %prey's body, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner's thick tentacles methodically apply pressure on your body, crushing you into the floor below!"

	msg_owner_grab_success = "You slide over %prey with your tentacles, smushing them against the ground before wrapping one up around them, trapping them within the tight confines of your tentacles!"
	msg_prey_grab_success = "%owner slides over you with their tentacles, smushing you against the ground before wrapping one up around you, trapping you within the tight confines of their tentacles!"

	msg_owner_grab_fail = "You step down onto %prey with one of your tentacles, forcing them onto the ground!"
	msg_prey_grab_fail = "%owner steps down onto you with one of their tentacles, squishing you and forcing you onto the ground!"

/datum/sprite_accessory/tail/taur/drake //Enabling on request, no suit compatibility but then again see 2 above.
	name = "Drake (Taur)"
	icon_state = "drake_s"
	extra_overlay = "drake_markings"
///	suit_sprites = 'icons/mob/taursuits_drake_vr.dmi'	///Chomp edit
	suit_sprites = 'icons/mob/taursuits_drake_ch.dmi'
	icon_sprite_tag = "drake"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 6

/datum/sprite_accessory/tail/taur/drake/fat
	name = "Fat Drake (Taur)"
	icon_state = "fatdrake_s"
	extra_overlay = "fatdrake_markings"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 6

/datum/sprite_accessory/tail/taur/drake/drake_vwag
	name = "Drake (Taur, Fat vwag)"
	icon_state = "drake_s"
	extra_overlay = "drake_markings"
	ani_state = "fatdrake_s"
	extra_overlay_w = "fatdrake_markings"
	can_loaf = TRUE

/datum/sprite_accessory/tail/taur/otie
	name = "Otie (Taur)"
	icon_state = "otie_s"
	extra_overlay = "otie_markings"
	extra_overlay2 = "otie_markings_2"
	suit_sprites = 'icons/mob/taursuits_otie_vr.dmi'
	icon_sprite_tag = "otie"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_vr_loaf.dmi'
	loaf_offset = 5

/datum/sprite_accessory/tail/taur/alraune/alraune_2c
	name = "Alraune (dual color)"
	icon_state = "alraunecolor_s"
	ani_state = "alraunecolor_closed_s"
	ckeys_allowed = null
	do_colouration = 1
	extra_overlay = "alraunecolor_markings"
	extra_overlay_w = "alraunecolor_closed_markings"
	clip_mask_state = "taur_clip_mask_alraune"
	icon_sprite_tag = "alraune"

/datum/sprite_accessory/tail/taur/wasp
	name = "Wasp (dual color)"
	icon_state = "wasp_s"
	extra_overlay = "wasp_markings"
	clip_mask_state = "taur_clip_mask_wasp"
	icon_sprite_tag = "wasp"

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

/datum/sprite_accessory/tail/taur/mermaid
	name = "Mermaid (Taur)"
	icon_state = "mermaid_s"
	can_ride = 0
	icon_sprite_tag = "mermaid"

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

/datum/sprite_accessory/tail/taur/altmermaid
	name = "Mermaid Alt. (Taur)"
	icon_state = "altmermaid_s"
	can_ride = 0
	icon_sprite_tag = "altmermaid"

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

/datum/sprite_accessory/tail/taur/altmermaid/marked
	name = "Mermaid Koi (Taur)"
	icon_state = "altmermaid_s"
	extra_overlay = "altmermaid_markings"
	extra_overlay2 = "altmermaid_markings2"

/datum/sprite_accessory/tail/taur/pawcow // this grabs suit sprites from the normal cow, the outline is the same
	name = "Cow w/ paws (Taur)"
	icon_state = "pawcow_s"
	extra_overlay = "pawcow_markings"
	suit_sprites = 'icons/mob/taursuits_cow_vr.dmi'
	icon_sprite_tag = "cow"

	msg_owner_disarm_run = "You quickly push %prey to the ground with your paw!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their paw!"

	msg_owner_disarm_walk = "You firmly push your paw down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their paw down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your paw down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their paw upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey to the ground before scooping them up with your paws!"
	msg_prey_grab_success = "%owner pins you to the ground before scooping you up with their paws!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their paw, forcing you down to the ground!"

// Special snowflake tails/taurhalves

//spoopylizz: Roiz Lizden
/datum/sprite_accessory/tail/taur/roiz_long_lizard // Not ACTUALLY a taur, but it uses 32x64 so it wouldn't fit in tails.dmi, and having it as a tail bugs up the sprite.
	name = "Long Lizard Tail (Roiz Lizden)"
	icon_state = "roiz_tail_s"
	do_colouration = 0
	ckeys_allowed = list("spoopylizz")
	hide_body_parts = null
	clip_mask_icon = null
	clip_mask_state = null

//wickedtemp: Chakat Tempest
/datum/sprite_accessory/tail/taur/feline/tempest
	name = "Feline (wickedtemp) (Taur)"
	icon_state = "tempest_s"
	ckeys_allowed = list("wickedtemp")
	can_loaf = FALSE

//silencedmp5a5: Serdykov Antoz
/datum/sprite_accessory/tail/taur/wolf/serdy
	name = "CyberSerdy (silencedmp5a5) (Taur)"
	icon_state = "serdy_s"
	ckeys_allowed = list("silencedmp5a5")
	can_loaf = FALSE

//liquidfirefly: Ariana Scol
/datum/sprite_accessory/tail/taur/centipede
	name = "Centipede (liquidfirefly) (Taur)"
	icon_state = "ariana_s"
	ckeys_allowed = list("liquidfirefly")
	do_colouration = 0

	msg_owner_disarm_run = "You quickly push %prey to the ground with your leg!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with their leg!"

	msg_owner_disarm_walk = "You firmly push your leg down on %prey, painfully but harmlessly pinning them to the ground!"
	msg_prey_disarm_walk = "%owner firmly pushes their leg down on you, quite painfully but harmlessly pinning you to the ground!"

	msg_owner_harm_walk = "You methodically place your leg down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner methodically places their leg upon your body, slowly applying pressure, crushing you against the floor below!"

	msg_owner_grab_success = "You pin %prey down on the ground with your front leg before using your other leg to pick them up, trapping them between two of your front legs!"
	msg_prey_grab_success = "%owner pins you down on the ground with their front leg before using their other leg to pick you up, trapping you between two of their front legs!"

	msg_owner_grab_fail = "You step down onto %prey, squishing them and forcing them down to the ground!"
	msg_prey_grab_fail = "%owner steps down and squishes you with their leg, forcing you down to the ground!"

//natje:
/datum/sprite_accessory/tail/taur/alraune
	name = "Alraune (natje) (Taur)"
	icon_state = "alraune_s"
	ani_state = "alraune_closed_s"
	ckeys_allowed = list("natje")
	do_colouration = 0
	can_ride = 0
	clip_mask_state = "taur_clip_mask_alraune"


	msg_prey_stepunder = "You run between %prey's vines."
	msg_owner_stepunder = "%owner runs between your vines."

	msg_owner_disarm_run = "You quickly push %prey to the ground with some of your vines!"
	msg_prey_disarm_run = "%owner pushes you down to the ground with some of their vines!"

	msg_owner_disarm_walk = "You push down on %prey with some of your vines, pinning them down firmly under you!"
	msg_prey_disarm_walk = "%owner pushes down on you with some of their vines, pinning you down firmly below them!"

	msg_owner_harm_run = "Your vines carelessly slide past %prey, crushing them!"
	msg_prey_harm_run = "%owner quickly goes over your body, carelessly crushing you with their vines!"

	msg_owner_harm_walk = "Your vines methodically apply pressure on %prey's body, crushing them against the floor below!"
	msg_prey_harm_walk = "%owner's thick vines methodically apply pressure on your body, crushing you into the floor below!"

	msg_owner_grab_success = "You slide over %prey with your vines, smushing them against the ground before wrapping one up around them, trapping them within the tight confines of your vines!"
	msg_prey_grab_success = "%owner slides over you with their vines, smushing you against the ground before wrapping one up around you, trapping you within the tight confines of their vines!"

	msg_owner_grab_fail = "You step down onto %prey with one of your vines, forcing them onto the ground!"
	msg_prey_grab_fail = "%owner steps down onto you with one of their vines, squishing you and forcing you onto the ground!"

/datum/sprite_accessory/tail/taur/rat
	name = "Rat (Taur)"
	icon_state = "rat_s"
	extra_overlay = "rat_markings"
	clip_mask_state = "taur_clip_mask_rat"
	icon_sprite_tag = "rat"

/datum/sprite_accessory/tail/taur/noodle
	name = "Eastern Dragon (Taur)"
	icon_state = "noodle_s"
	extra_overlay = "noodle_markings"
	extra_overlay2 = "noodle_markings_2"
	suit_sprites = 'icons/mob/taursuits_noodle_vr.dmi'
	clip_mask_state = "taur_clip_mask_noodle"
	icon_sprite_tag = "noodle"
/* CHOMPEdit - removed as a sprite accessory of the same name already exists for us, and having this here stops it from registering as a sprite accessory.
/datum/sprite_accessory/tail/taur/sect_drone
	name = "Sect Drone (Taur)"
	icon_state = "sect_drone"
	extra_overlay = "sect_drone_markings"
	icon_sprite_tag = "sect_drone"

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
*/
/datum/sprite_accessory/tail/taur/sect_drone/fat
	name = "Fat Sect Drone (Taur)"
	icon_state = "fat_sect_drone"
	extra_overlay = "fat_sect_drone_markings"
	icon_sprite_tag = "sect_drone" //CHOMPEdit addition

/datum/sprite_accessory/tail/taur/sect_drone/drone_wag
	name = "Sect Drone (Taur, Fat vwag)"
	icon_state = "sect_drone"
	extra_overlay = "sect_drone_markings"
	ani_state = "fat_sect_drone"
	extra_overlay_w = "fat_sect_drone_markings"
	icon_sprite_tag = "sect_drone" //CHOMPEdit addition

/datum/sprite_accessory/tail/taur/giantspider_colorable//these are honestly better fit for vass icontypes whoops
	name = "Giant Spider dual-color (Taur)"
	icon_state = "giantspidertaur-colorable"
	extra_overlay = "giantspidertaur-colorable-markings"
	icon_sprite_tag = "giantspidertaur-colorable"

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

/datum/sprite_accessory/tail/taur/carrierspider
	name = "Carrier Spider (Taur)"
	icon_state = "carrierspidertaur"
	extra_overlay = null
	icon_sprite_tag = "carrierspidertaur"

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

/datum/sprite_accessory/tail/taur/giantspider
	name = "Giant Spider (Taur)"
	icon_state = "giantspidertaur"
	extra_overlay = null
	icon_sprite_tag = "giantspidertaur"

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

/datum/sprite_accessory/tail/taur/phoronspider
	name = "Phorogenic Spider (Taur)"
	icon_state = "phoronspidertaur"
	extra_overlay = null
	icon_sprite_tag = "phoronspidertaur"

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

/datum/sprite_accessory/tail/taur/sparkspider
	name = "Voltaic Spider (Taur)"
	icon_state = "sparkspidertaur"
	extra_overlay = null
	icon_sprite_tag = "sparkspidertaur"

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

/datum/sprite_accessory/tail/taur/frostspider
	name = "Frost Spider (Taur)"
	icon_state = "frostspidertaur"
	extra_overlay = null
	icon_sprite_tag = "frostspidertaur"

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

/datum/sprite_accessory/tail/taur/ant
	name = "Ant (dual color)"
	icon_state = "ant_s"
	extra_overlay = "ant_markings"
	clip_mask_state = "taur_clip_mask_wasp"
	icon_sprite_tag = "wasp"

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

/datum/sprite_accessory/tail/taur/naga/fat
	name = "Naga (Taur, Fat, dual color)"
	icon_state = "fatnaga_s"
	extra_overlay = "fatnaga_markings"

