// Special snowflake tails/taurhalves

//spoopylizz: Roiz Lizden
/datum/sprite_accessory/tail/taur/roiz_long_lizard // Not ACTUALLY a taur, but it uses 64x32 so it wouldn't fit in tails.dmi, and having it as a tail bugs up the sprite.
	name = "Long Lizard Tail (Roiz Lizden)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_snowflake.dmi'
	icon_state = "roiz_tail_s"
	do_colouration = FALSE
	ckeys_allowed = list("spoopylizz")
	hide_body_parts = null
	clip_mask_icon = null
	clip_mask_state = null

//grallstonefist: Ranihrönn Skrolk
/datum/sprite_accessory/tail/taur/altmermaid/orcamermaid
	name = "Mermaid Orca (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_snowflake.dmi'
	icon_state = "orcamermaid_s"
	can_ride = TRUE
	do_colouration = FALSE
	ckeys_allowed = list("grallstonefist")

//wickedtemp: Chakat Tempest
/datum/sprite_accessory/tail/taur/feline/tempest
	name = "Feline (wickedtemp) (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_snowflake.dmi'
	icon_state = "tempest_s"
	ckeys_allowed = list("wickedtemp")
	can_loaf = FALSE

//silencedmp5a5: Serdykov Antoz
/datum/sprite_accessory/tail/taur/wolf/serdy
	name = "CyberSerdy (silencedmp5a5) (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_snowflake.dmi'
	icon_state = "serdy_s"
	ckeys_allowed = list("silencedmp5a5")
	can_loaf = FALSE

//liquidfirefly: Ariana Scol
/datum/sprite_accessory/tail/taur/centipede
	name = "Centipede (liquidfirefly) (Taur)"
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_snowflake.dmi'
	icon_state = "ariana_s"
	ckeys_allowed = list("liquidfirefly")
	do_colouration = FALSE

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
	icon = 'icons/mob/human_races/sprite_accessories/taurs/taurs_snowflake.dmi'
	icon_state = "alraune_s"
	ani_state = "alraune_closed_s"
	ckeys_allowed = list("natje")
	do_colouration = FALSE
	can_ride = FALSE
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
