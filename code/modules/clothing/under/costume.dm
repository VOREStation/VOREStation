/obj/item/clothing/under/costume
	name = "jester costume"
	desc = "Jingle most merrily."
	icon_state = "jester"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "green")

/obj/item/clothing/under/costume/mummy
	name = "mummy bandages"
	desc = "The wrappings of the ancient dead, or somebody who walked clean through a NanoMed."
	icon_state = "mummy"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")

/obj/item/clothing/under/costume/griffin
	name = "griffin costume"
	desc = "The iconic outfit of classic supervillain, The Griffin."
	icon_state = "griffin"
	item_state_slots = list(slot_r_hand_str = "lightbrown", slot_l_hand_str = "lightbrown")

/obj/item/clothing/under/costume/scarecrow
	name = "scarecrow's rags"
	desc = "Ad hominem."
	icon_state = "scarecrow"
	item_state_slots = list(slot_r_hand_str = "lightbrown", slot_l_hand_str = "lightbrown")

/obj/item/clothing/under/costume/ice_fairy
	name = "ice fairy dress"
	desc = "Aren't you cold in that?"
	icon_state = "ice_fairy_dress"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")

/obj/item/clothing/under/costume/witch
	name = "witch dress"
	desc = "They don't make these from canvas anymore."
	icon_state = "dark_witch"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")

//Repathed from old files

/obj/item/clothing/under/costume/rainbow
	name = "rainbow jumpsuit"
	desc = "A multi-colored jumpsuit."
	icon_state = "rainbow"

/obj/item/clothing/under/costume/captain_fly
	name = "rogue's uniform"
	desc = "For the man who doesn't care because he's still free."
	icon_state = "captain_fly"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/obj/item/clothing/under/costume/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state_slots = list(slot_r_hand_str = "sl_suit", slot_l_hand_str = "sl_suit")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/costume/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")

/obj/item/clothing/under/costume/redcoat
	name = "redcoat uniform"
	desc = "Looks old."
	icon_state = "redcoat"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/obj/item/clothing/under/costume/kilt
	name = "kilt"
	desc = "Includes shoes and sporran."
	icon_state = "kilt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|FEET
	rolled_sleeves = 0

/obj/item/clothing/under/costume/gladiator
	name = "gladiator uniform"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state_slots = list(slot_r_hand_str = "yellow", slot_l_hand_str = "yellow")
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/costume/owl
	name = "owl uniform"
	desc = "A jumpsuit with owl wings. Photorealistic owl feathers! Twooooo!"
	icon_state = "owl"

/obj/item/clothing/under/costume/schoolgirl
	name = "schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/costume/sexyclown
	name = "sexy-clown suit"
	desc = "It makes you look HONKable!"
	icon_state = "sexyclown"
	item_state_slots = list(slot_r_hand_str = "clown", slot_l_hand_str = "clown")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	rolled_sleeves = -1 //Please never

/obj/item/clothing/under/costume/sexymime
	name = "sexy mime outfit"
	desc = "The only time when you DON'T enjoy looking at someone's rack."
	icon_state = "sexymime"
	item_state_slots = list(slot_r_hand_str = "mime", slot_l_hand_str = "mime")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	rolled_sleeves = -1 //Please never

/obj/item/clothing/under/costume/sexymaid
	name = "sexy maid costume"
	desc = "You must be a bit risque teasing all of them in a maid uniform!"
	icon_state = "sexymaid"
	index = 1
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

//Ranger uniforms
//On-mob sprites go in icons\mob\uniform.dmi with the format "white_ranger_uniform_s" - with 'white' replaced with green, cyan, etc... of course! Note the _s - this is not optional.
//Item sprites go in icons\obj\clothing\ranger.dmi with the format "white_ranger_uniform"
/obj/item/clothing/under/costume/ranger
	var/unicolor = "white"
	name = "white ranger uniform"
	desc = "Made from a space-proof fibre and tight fitting, this uniform usually gives the agile Rangers all kinds of protection while not inhibiting their movement. \
	This costume is instead made from genuine cotton fibre and is based on the season three uniform."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_uniform"
	rolled_sleeves = FALSE

/obj/item/clothing/under/costume/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_uniform") //allows for custom items
		name = "[unicolor] ranger uniform"
		icon_state = "[unicolor]_ranger_uniform"

/obj/item/clothing/under/costume/ranger/black
	name = "black ranger uniform"
	unicolor = "black"

/obj/item/clothing/under/costume/ranger/pink
	name = "pink ranger uniform"
	unicolor = "pink"

/obj/item/clothing/under/costume/ranger/green
	name = "green ranger uniform"
	unicolor = "green"

/obj/item/clothing/under/costume/ranger/cyan
	name = "cyan ranger uniform"
	unicolor = "cyan"

/obj/item/clothing/under/costume/ranger/orange
	name = "orange ranger uniform"
	unicolor = "orange"

/obj/item/clothing/under/costume/ranger/yellow
	name = "yellow ranger uniform"
	unicolor = "yellow"

//End of old costumes
