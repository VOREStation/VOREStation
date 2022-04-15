// this is a playing card deck based off of the Austrian/Hungarian national card game, Schnapsen
//TODO: Sprite up Double German/William Tell card icons. Sending this in as is as I suck at spriting and want to play schnapsen
//TODO: Implement functionality for "sub-decks": Create a over-schnapsen deck with nines, eights and sevens. 
//TODO:Let players choose 2,3,4 player mode to get decks of ace/ten/jack/queen/king + seven for 3 player, nine+eight for 4 player modes. 


/obj/item/weapon/deck/schnapsen
 	name = "deck of schnapsen cards"
 	desc = "An ancient trick-taking card game from a bygone-Earth country. For 2 players!"
	icon_state = "deck"

/obj/item/weapon/deck/schnapsen/New()
	..()
	//Stealing french card icons. 
	var/datum/playingcard/P
	var/colour
	for(var/suit in list("spades","clubs","diamonds","hearts"))
		if(suit == "spades" || suit == "clubs")
			colour = "black_"
		else
			colour = "red_"	
		for(var/number in list("ace","ten","jack","queen","king")) //Schnapsen has knight worth 2 pts, queen 3 pts, king 4. Ace 11, ten 10
			P = new()
			P.name = "[number] of [suit]"
			if(number == "ten")
				P.card_icon = "[colour]num"
			else
				P.card_icon = "[colour]col"
			P.back_icon = "card_back"
			cards += P
