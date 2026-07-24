/datum/sprite_accessory/tail/taur/alraune/alraune_2c
	name = "Alraune (dual color)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
	icon_state = "alraunecolor_s"
	ani_state = "alraunecolor_closed_s"
	ckeys_allowed = null
	do_colouration = TRUE
	extra_overlay = "alraunecolor_markings"
	extra_overlay_w = "alraunecolor_closed_markings"
	clip_mask_state = "taur_clip_mask_alraune"
	icon_sprite_tag = "alraune"

/datum/sprite_accessory/tail/taur/giantspider
	name = "Giant Spider (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
	icon_state = "giantspidertaur"
	do_colouration = FALSE
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

/datum/sprite_accessory/tail/taur/giantspider/colorable
	name = "Giant Spider dual-color (Taur)"
	icon_state = "giantspidertaur-colorable"
	do_colouration = TRUE
	extra_overlay = "giantspidertaur-colorable-markings"
	icon_sprite_tag = "giantspidertaur-colorable"

/datum/sprite_accessory/tail/taur/giantspider/carrier
	name = "Carrier Spider (Taur)"
	icon_state = "carrierspidertaur"
	extra_overlay = null
	icon_sprite_tag = "carrierspidertaur"

/datum/sprite_accessory/tail/taur/giantspider/phoron
	name = "Phorogenic Spider (Taur)"
	icon_state = "phoronspidertaur"
	extra_overlay = null
	icon_sprite_tag = "phoronspidertaur"

/datum/sprite_accessory/tail/taur/giantspider/spark
	name = "Voltaic Spider (Taur)"
	icon_state = "sparkspidertaur"
	extra_overlay = null
	icon_sprite_tag = "sparkspidertaur"

/datum/sprite_accessory/tail/taur/giantspider/frost
	name = "Frost Spider (Taur)"
	icon_state = "frostspidertaur"
	extra_overlay = null
	icon_sprite_tag = "frostspidertaur"

/datum/sprite_accessory/tail/taur/giantspider/ant	//technically not a spider, but it inherits the same messages
	name = "Ant (dual color)"
	icon_state = "ant_s"
	do_colouration = TRUE
	extra_overlay = "ant_markings"
	clip_mask_state = "taur_clip_mask_wasp"
	icon_sprite_tag = "wasp"

/datum/sprite_accessory/tail/taur/giantspider/wasp	//same as above, but for wasps
	name = "Wasp (dual color)"
	icon_state = "wasp_s"
	do_colouration = TRUE
	extra_overlay = "wasp_markings"
	clip_mask_state = "taur_clip_mask_wasp"
	icon_sprite_tag = "wasp"

/datum/sprite_accessory/tail/taur/mermaid
	name = "Mermaid (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
	icon_state = "mermaid_s"
	can_ride = FALSE
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

/datum/sprite_accessory/tail/taur/mermaid/alt
	name = "Mermaid Alt. (Taur)"
	icon_state = "altmermaid_s"
	icon_sprite_tag = "altmermaid"

/datum/sprite_accessory/tail/taur/mermaid/alt/marked
	name = "Mermaid Koi (Taur)"
	icon_state = "altmermaid_s"
	extra_overlay = "altmermaid_markings"
	extra_overlay2 = "altmermaid_markings2"

/datum/sprite_accessory/tail/taur/horse/scoli
	name = "Scolipede (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
	icon_state = "scoli_s"
	extra_overlay = "scoli_markings1"
	extra_overlay2 = "scoli_markings2"

/datum/sprite_accessory/tail/taur/spider
	name = "Spider (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
	icon_state = "spider_s"
	suit_sprites = 'icons/mob/taursuits_spider.dmi'
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

/datum/sprite_accessory/tail/taur/sloog
	name = "Sloog (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
	icon_state = "sloog"
	extra_overlay = "sloog_glowstripe"
	extra_overlay_w = "sloog_glowstripe"
	can_loaf = FALSE

/datum/sprite_accessory/tail/taur/slug
	name = "Slug (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
	icon_state = "slug_s"
	suit_sprites = 'icons/mob/taursuits_deer.dmi' //Yes it sounds odd, but they share the same sprites.
	icon_sprite_tag = "slug"
	vore_tail_sprite_variant = "Slug"
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

/datum/sprite_accessory/tail/taur/slug/snail
	name = "Snail (Taur)"
	icon_state = "slug_s"
	extra_overlay = "snail_shell_marking"

/datum/sprite_accessory/tail/taur/tents
	name = "Tentacles (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
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

/datum/sprite_accessory/tail/taur/tents/thick
	name = "Thick Tentacles (Taur)"
	icon_state = "tentacle_s"
	can_ride = FALSE
	icon_sprite_tag = "thick_tentacles"

/datum/sprite_accessory/tail/taur/treeoak_roots
	name = "Tree Roots (Oak)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_exotic.dmi'
	icon_state = "tree_oak_roots"
	can_ride = FALSE

/*
/datum/sprite_accessory/tail/taur/teppi			// Mostly used as example/template/test subject as to how you use the 'big' taur sprites. Pls give it better icons before uncommenting...
	name = "Teppi (Taur)"
	icon_state = "teppi_s"
	clip_mask_icon = 'icons/mob/vore/taurs128x64.dmi'
	icon = 'icons/mob/vore/taurs128x64.dmi'
	clip_mask_state = "taur_clip_mask_teppi"
	icon_sprite_tag = "teppi"
	offset_x = -32
	offset_y = -11
	mob_offset_y = 11
*/
