/datum/sprite_accessory/tail/taur/bunny
	name = "Bunny (Taur, Fat vwag)"
	icon = 'icons/rogue-star/tails_64x32_rs.dmi'
	icon_state = "bnytr"
	extra_overlay = "bnytr-m1"
	extra_overlay2 = "bnytr-m2"
	ani_state = "bnytr-f"
	extra_overlay_w = "bnytr-m1"
	extra_overlay2_w = "bnytr-f-m2"

	can_loaf = TRUE
	icon_loaf = 'icons/rogue-star/loafs_64x32.dmi'
	loaf_offset = 4

/datum/sprite_accessory/tail/taur/cow
	name = "Cow (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "cow_s"
	suit_sprites = 'icons/mob/taursuits_cow.dmi'
	icon_sprite_tag = "cow"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3
	vore_tail_sprite_variant = "Cow"
	fullness_icons = 1

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

/datum/sprite_accessory/tail/taur/cow/fat
	name = "Fat Cow (Taur)"
	icon_state = "fatcow_s"

/datum/sprite_accessory/tail/taur/cow/fat_wag
	name = "Cow (Taur, Fat vwag)"
	icon_state = "cow_s"
	ani_state = "fatcow_s"

/datum/sprite_accessory/tail/taur/cow/paw // this grabs suit sprites from the normal cow, the outline is the same
	name = "Cow w/ paws (Taur)"
	icon_state = "pawcow_s"
	extra_overlay = "pawcow_markings"
	suit_sprites = 'icons/mob/taursuits_cow.dmi'
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

/datum/sprite_accessory/tail/taur/deer
	name = "Deer dual-color (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "deer_s"
	extra_overlay = "deer_markings"
	suit_sprites = 'icons/mob/taursuits_deer.dmi'
	icon_sprite_tag = "deer"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 7
	vore_tail_sprite_variant = "Deer"
	belly_variant_when_loaf = TRUE
	fullness_icons = 3

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

/datum/sprite_accessory/tail/taur/deer/deer_wag
	name = "Deer vwag (Dual-color, Taur, Fat)"
	icon_state = "deer_s"
	ani_state = "fatdeer_s"
	extra_overlay_w = "fatdeer_markings"

/datum/sprite_accessory/tail/taur/deer/fatdeer
	name = "Fat Deer (Dual-color Taur)"
	icon_state = "fatdeer_s"
	extra_overlay = "fatdeer_markings"

/datum/sprite_accessory/tail/taur/feline
	name = "Feline (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "feline_s"	//I just want to talk to whomever thought every feline varient needed this same sprite but uniquely renamed...
	suit_sprites = 'icons/mob/taursuits_deer.dmi'
	icon_sprite_tag = "feline"
	extra_overlay = "feline_markings"
	ani_state = "feline_w"
	extra_overlay_w = "feline_markings"		//Honestly there ought to be a wag overlay, but the ones here are too faint that... nah.
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 5
	vore_tail_sprite_variant = "Feline"
	belly_variant_when_loaf = TRUE
	fullness_icons = 1

/datum/sprite_accessory/tail/taur/feline/fat
	name = "Fat Feline (Taur)"
	icon_state = "fatfeline_s"
	extra_overlay = "fatfeline_markings"	//feet, belly, and chest
	ani_state = "fatfeline_w"
	extra_overlay_w = "fatfeline_markings"
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/fat_wag
	name = "Fat Feline (Taur, Fat vwag)"
	ani_state = "fatfeline_s"	//static fat sprite
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/fatfeline_2c
	name = "Fat Feline 3-color (Taur)"
	icon_state = "fatfeline_s"
	extra_overlay = "fatfeline2_markings"		// chest and belly
	extra_overlay2 = "fatfeline2_markings_2"	// feet
	can_loaf = TRUE
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/feline_2c
	name = "Feline 3-color (Taur)"
	icon_state = "feline_s"
	extra_overlay = "feline2_markings"
	extra_overlay2 = "feline2_markings_2"
	//icon_sprite_tag = "feline2c"
	can_loaf = TRUE

/datum/sprite_accessory/tail/taur/feline/feline_2c_wag
	name = "Feline 3-color (Taur, Fat vwag)"
	extra_overlay = "feline2_markings"
	extra_overlay2 = "feline2_markings_2"
	ani_state = "fatfeline_s"
	extra_overlay = "fatfeline2_markings"
	extra_overlay2 = "fatfeline2_markings_2"
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/tiger
	name = "Tiger (Taur)"
	suit_sprites = 'icons/mob/taursuits_deer.dmi'
	icon_sprite_tag = "feline"
	extra_overlay = "feline_markings"
	extra_overlay2 = "tiger_markings"
	extra_overlay2_w = "tiger_markings_w"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 5
	vore_tail_sprite_variant = "Feline"
	belly_variant_when_loaf = TRUE
	fullness_icons = 1

/datum/sprite_accessory/tail/taur/feline/tiger/fat
	name = "Fat Tiger (Taur)"
	icon_state = "fatfeline_s"
	extra_overlay = "fatfeline_markings"
	extra_overlay2 = "fattiger_markings"
	extra_overlay2_w = "fattiger_markings_w"
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/feline/tiger/fat_vwag
	name = "Tiger (Taur, Fat vwag)"
	ani_state = "fatfeline_s"
	extra_overlay_w = "fatfeline_markings"
	extra_overlay2_w = "fattiger_markings"

/datum/sprite_accessory/tail/taur/fox
	name = "Fox (Taur, 3-color)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "fox"
	extra_overlay = "fox_markings"
	extra_overlay2 = "fox_markings2"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	vore_tail_sprite_variant = "F"
	fullness_icons = 3
	loaf_offset = 4

/datum/sprite_accessory/tail/taur/fox/kitsune
	name = "Kitsune (Taur)"
	icon_state = "kitsune"
	extra_overlay = "kitsune_markings"
	extra_overlay2 = "kitsune_markings2"

/datum/sprite_accessory/tail/taur/frog
	name = "Frog (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "frog_s"
	icon_sprite_tag = "frog"

/datum/sprite_accessory/tail/taur/horse
	name = "Horse (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "horse_s"
	under_sprites = 'icons/mob/taursuits_horse.dmi'
	suit_sprites = 'icons/mob/taursuits_horse.dmi'
	icon_sprite_tag = "horse"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 4
	vore_tail_sprite_variant = "Horse"
	fullness_icons = 1

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

/datum/sprite_accessory/tail/taur/horse/big
	name = "Kentauri (Taur)"
	icon_state = "kentauri_s"
	extra_overlay = "kentauri_markings"

/datum/sprite_accessory/tail/taur/horse/horse_2c
	name = "Horse & colorable tail (Taur)"
	extra_overlay = "horse_markings"
	//icon_sprite_tag = "wolf2c"

/datum/sprite_accessory/tail/taur/otie
	name = "Otie (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "otie_s"
	extra_overlay = "otie_markings"
	extra_overlay2 = "otie_markings_2"
	suit_sprites = 'icons/mob/taursuits_otie.dmi'
	icon_sprite_tag = "otie"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 5
	vore_tail_sprite_variant = "Otie"
	belly_variant_when_loaf = TRUE
	fullness_icons = 1

/datum/sprite_accessory/tail/taur/rat
	name = "Rat (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "rat_s"
	extra_overlay = "rat_markings"
	clip_mask_state = "taur_clip_mask_rat"
	icon_sprite_tag = "rat"

/datum/sprite_accessory/tail/taur/redpanda
	name = "Red Panda (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "redpanda"

/datum/sprite_accessory/tail/taur/redpanda/dc
	name = "Red Panda (Taur dual-color)"
	icon_state = "redpanda_dc"
	extra_overlay = "redpanda_dc_markings"

/datum/sprite_accessory/tail/taur/sergal/wheaties
	name = "Sergal (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "sergwheat"
	icon_sprite_tag = "wolf"
	vore_tail_sprite_variant = "N"
	fullness_icons = 3
	struggle_anim = TRUE

/datum/sprite_accessory/tail/taur/sergal/wheaties/fat
	name = "Fat Sergal (Taur)"
	icon_state = "fatsergal"
	icon_sprite_tag = "wolf"
	vore_tail_sprite_variant = "N"
	fullness_icons = 3
	struggle_anim = TRUE

/datum/sprite_accessory/tail/taur/sergal/wheaties_2c
	name = "Sergal (Taur, dual-color)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "sergwheat"
	extra_overlay = "sergwheat_markings"
	icon_sprite_tag = "wolf"
	vore_tail_sprite_variant = "N"
	fullness_icons = 3
	struggle_anim = TRUE

/datum/sprite_accessory/tail/taur/sergal/wheaties_2c/fat
	name = "Fat Sergal (Taur, dual-color)"
	icon_state = "fatsergal"
	extra_overlay = "sergwheat_markings"
	icon_sprite_tag = "wolf"
	vore_tail_sprite_variant = "N"
	fullness_icons = 3
	struggle_anim = TRUE

/datum/sprite_accessory/tail/taur/skunk
	name = "Skunk (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "skunk_s"
	extra_overlay = "skunk_markings"
	extra_overlay2 = "skunk_markings_2"
	icon_sprite_tag = "skunk"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 3
	vore_tail_sprite_variant = "Skunk" //Sadly there appears to be no sprites... For now!
	belly_variant_when_loaf = TRUE
	fullness_icons = 1

/datum/sprite_accessory/tail/taur/wolf
	name = "Wolf (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "wolf_s"
	under_sprites = 'icons/mob/taursuits_wolf.dmi'
	suit_sprites = 'icons/mob/taursuits_wolf.dmi'
	icon_sprite_tag = "wolf"
	can_loaf = TRUE
	icon_loaf = 'icons/mob/vore/taurs_loaf.dmi'
	loaf_offset = 4
	vore_tail_sprite_variant = "N"
	fullness_icons = 3
	struggle_anim = TRUE

/datum/sprite_accessory/tail/taur/wolf/fat
	name = "Fat Wolf (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "fatwolf_s"
	icon_sprite_tag = "wolf"	//This could be modified later.
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/wolf/fat_wag
	name = "Wolf (Taur, Fat vwag)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "wolf_s"
	ani_state = "fatwolf_s"

/datum/sprite_accessory/tail/taur/wolf/fatwolf_2c
	name = "Fat Wolf 3-color (Taur)"
	icon_state = "fatwolf2_s"
	extra_overlay = "fatwolf2_markings"
	extra_overlay2 = "fatwolf2_markings_2"
	loaf_offset = 3

/datum/sprite_accessory/tail/taur/wolf/fatwolf_2c/fatwolfalt
	name = "Fat Wolf 3-color-alt (Taur)"
	icon_state = "fatwolfalt_s"
	extra_overlay = "fatwolfalt_markings1"
	extra_overlay2 = "fatwolfalt_markings2"
	icon_sprite_tag = "wolf"

/datum/sprite_accessory/tail/taur/wolf/wolf_2c
	name = "Wolf 3-color (Taur)"
	icon_state = "wolf_s"
	extra_overlay = "wolf_markings"
	extra_overlay2 = "wolf_markings_2"
	//icon_sprite_tag = "wolf2c"

/datum/sprite_accessory/tail/taur/wolf/wolf_2c_wag
	name = "Wolf 3-color (Taur, Fat vwag)"
	icon_state = "wolf2_s"
	extra_overlay = "wolf2_markings"
	extra_overlay2 = "wolf2_markings_2"
	extra_overlay_w = "fatwolf2_markings"
	extra_overlay2_w = "fatwolf2_markings_2"
	ani_state = "fatwolf2_s"

/datum/sprite_accessory/tail/taur/wolf/wolf_3
	name = "WolfTG (Taur)" //It's Citadel, not TG. :V
	icon_state = "wolf3_s"
	do_colouration = FALSE	//this is already pre-colored.

/datum/sprite_accessory/tail/taur/wolf/husky
	name = "Husky (Taur)"
	icon_state = "husky_s"

/datum/sprite_accessory/tail/taur/wolf/huskyfat
	name = "Fat Husky (Taur)"
	icon_state = "huskyf_s"

/datum/sprite_accessory/tail/taur/zorgoia
	name = "Zorgoia (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "zorgoia"
	extra_overlay = "zorgoia_fluff"

/datum/sprite_accessory/tail/taur/zorgoia/fat
	name = "Zorgoia (Fat Taur)"
	extra_overlay = "zorgoia_fat2"

/datum/sprite_accessory/tail/taur/zorgoia_new
	name = "Zorgoia (Taur) (New)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_animal.dmi'
	icon_state = "zorgoia_new"
	extra_overlay = "zorgoia_new_fluff"

/datum/sprite_accessory/tail/taur/zorgoia_new/fat
	name = "Zorgoia (Fat Taur) (New)"
	icon_state = "zorgoia_new_fat"
	extra_overlay = "zorgoia_new_fat_overlay"
