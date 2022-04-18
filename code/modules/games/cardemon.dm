<<<<<<< HEAD
/*
 * Cardmon trading card game
 */
/obj/item/weapon/pack/cardemon
=======
/obj/item/pack/cardemon
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "cardemon booster pack"
	desc = "Finally! A children's card game in space!"
	icon_state = "card_pack_cardemon"
	parentdeck = "cardemon"

<<<<<<< HEAD
/obj/item/weapon/pack/cardemon/New()
	..()
=======
/obj/item/pack/cardemon/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	var/datum/playingcard/P
	var/i
	for(i=0; i<5; i++)
		var/rarity
		if(prob(10))
			if(prob(5))
				if(prob(5))
					rarity = "Plasteel"
				else
					rarity = "Platinum"
			else
				rarity = "Silver"

		var/nam = pick("Death","Life","Plant","Leaf","Air","Earth","Fire","Water","Killer","Holy", "God", "Ordinary","Demon","Angel", "Plasteel", "Phoron", "Mad", "Insane", "Metal", "Steel", "Secret")
		var/nam2 = pick("Carp", "Corgi", "Cat", "Mouse", "Octopus", "Lizard", "Monkey", "Plant", "Duck", "Demon", "Spider", "Bird", "Slime", "Sheep", "Fish")

		P = new()
		P.name = "[nam] [nam2]"
		P.card_icon = "card_cardemon"
		if(rarity)
			P.name = "[rarity] [P.name]"
			P.card_icon += "_[rarity]"
		P.back_icon = "card_back_cardemon"
		cards += P
