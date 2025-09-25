
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

/datum/playingcard/casino
	name = "playing card"
	card_icon = "card_back"
	back_icon = "card_back"

/obj/item/deck/casino
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/playing_cards.dmi'

/obj/item/deck/holder/casino //WIP In future do a cool holder
	name = "card box"
	desc = "A small leather case to show how classy you are compared to everyone else."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "card_holder"

/obj/item/deck/cards/casino
	name = "deck of casino cards"
	desc = "A deck of playing cards from the golden goose casino, comes without a joker card!"
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "casino_deck"
	card_icon_prefix = "casino_"

/obj/item/deck/cards/casino/init_jokers()
	return

/obj/item/deck/cards/casino/triple
	name = "big deck of casino cards"
	desc = "A triply-sized deck of playing cards from the golden goose casino, comes without a joker card!"
	deck_size = 3
