// This is a parody of Cards Against Humanity (https://en.wikipedia.org/wiki/Cards_Against_Humanity)
// which is licensed under CC BY-NC-SA 2.0, the full text of which can be found at the following URL:
// https://creativecommons.org/licenses/by-nc-sa/2.0/legalcode

/obj/item/weapon/deck/cah
	name = "\improper CAG deck (white)"
	desc = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the white deck."
	icon_state = "cag_white"
	decktype = /datum/playingcard/cah/white
	var/blanks = 5

<<<<<<< HEAD
/obj/item/weapon/deck/cah/black
=======
/datum/playingcard/cah/white

/obj/item/deck/cah/black
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	name = "\improper CAG deck (black)"
	desc = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the black deck."
	icon_state = "cag_black"
	decktype = /datum/playingcard/cah/black
	blanks = 0

<<<<<<< HEAD
/obj/item/weapon/deck/cah/New()
	..()
	var/datum/playingcard/P
=======
/datum/playingcard/cah/black

/obj/item/deck/cah/Initialize()
	. = ..()
	var/datum/playingcard/P = new decktype
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	for(var/cardtext in card_text_list)
		P = new()
		P.name = "[cardtext]"
		P.card_icon = "[icon_state]_card"
		P.back_icon = "[icon_state]_card_back"
		cards += P
	if(!blanks)
		return
	for(var/x=1 to blanks)
		P = new()
		P.name = "Blank Card"
		P.card_icon = "[icon_state]_card_back"
		P.back_icon = "[icon_state]_card_back"
