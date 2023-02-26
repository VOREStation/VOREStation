/*
 * This is a playing card deck based off of the Rider-Waite Tarot Deck.
 */
/obj/item/weapon/deck/tarot
	name = "deck of tarot cards"
	desc = "For all your occult needs!"
	icon_state = "deck_tarot"
	decktype = /datum/playingcard/tarot

/datum/playingcard/tarot/

/obj/item/weapon/deck/tarot/New()
	..()

	var/datum/playingcard/tarot/P
	for(var/name in list("Fool","Magician","High Priestess","Empress","Emperor","Hierophant","Lovers","Chariot","Strength","Hermit","Wheel of Fortune","Justice","Hanged Man","Death","Temperance","Devil","Tower","Star","Moon","Sun","Judgement","World"))
		P = new()
		P.name = "[name]"
		P.card_icon = "tarot_major"
		P.back_icon = "card_back_tarot"
		cards += P
	for(var/suit in list("wands","pentacles","cups","swords"))
		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","page","knight","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "tarot_[suit]"
			P.back_icon = "card_back_tarot"
			cards += P

/obj/item/weapon/deck/tarot/shuffle()
	var/mob/living/user = usr
	if (cooldown < world.time - 10)
		var/list/newcards = list()
		while(cards.len)
			var/datum/playingcard/tarot/P = pick(cards)
			P.name = replacetext(P.name," reversed","")
			if(prob(50))
				P.name += " reversed"
			newcards += P
			cards -= P
		cards = newcards
		playsound(src, 'sound/items/cardshuffle.ogg', 50, 1)
		user.visible_message("\The [user] shuffles [src].")
		cooldown = world.time
	else
		return
