// this is a playing card deck based off of the Austrian/Hungarian national card game, Schnapsen
//TODO: Implement functionality for "sub-decks": Create a over-schnapsen deck with nines, eights and sevens.
//TODO:Let players choose 2,3,4 player mode to get decks of ace/ten/jack/queen/king + seven for 3 player, nine+eight for 4 player modes.
//values: ace = 11, ten = 10, unter = 2, ober = 3, king = 4

/obj/item/deck/schnapsen
	name = "deck of schnapsen cards"
	desc = "An ancient trick-taking card game from a bygone-Earth country. For 2 players!"
	icon_state = "deck"

/obj/item/deck/schnapsen/New()
	..()
	var/datum/playingcard/P
	var/colour
	for(var/suit in list("acorns","leaves","bells","hearts"))
		switch(suit)
			if("acorns") colour = "acorn_"
			if("leaves") colour = "leaf_"
			if("bells") colour = "bell_"
			if("hearts") colour = "red_"
		for(var/number in list("ace","ten","unter","ober","king"))
			P = new()
			P.name = "[number] of [suit]"
			if(number == "ten")
				P.card_icon = "[colour]num"
			else
				P.card_icon = "[colour]col"
			P.back_icon = "card_back"
			cards += P
