/datum/playingcard
	var/name = "playing card"
	var/card_icon = "card_back"
	var/back_icon = "card_back"

/obj/item/deck
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/playing_cards.dmi'
	description_info = "Alt click to shuffle, Ctrl click to deal, Ctrl+Shift click to deal multiple."
	var/list/cards = list()
	var/cooldown = 0 // to prevent spam shuffle

/obj/item/deck/holder
	name = "card box"
	desc = "A small leather case to show how classy you are compared to everyone else."
	icon_state = "card_holder"

/obj/item/deck/cards
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon_state = "deck"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	var/card_icon_prefix = ""
	var/deck_size = 1 // # of times we will generate cards within this deck

/obj/item/deck/cards/proc/init_cards()
	PROTECTED_PROC(TRUE)
	var/datum/playingcard/pcard
	for(var/i = 0, i < deck_size, i++)
		for(var/suit in list("spades","clubs","diamonds","hearts"))
			var/colour
			switch(suit)
				if("clubs", "spades")
					colour = "black_"
				else
					colour = "red_"

			for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten"))
				pcard = new()
				pcard.name = "[number] of [suit]"
				pcard.card_icon = "[card_icon_prefix][colour]num"
				pcard.back_icon = "[card_icon_prefix]card_back"
				cards += pcard

			for(var/number in list("jack","queen","king"))
				pcard = new()
				pcard.name = "[number] of [suit]"
				pcard.card_icon = "[card_icon_prefix][colour]col"
				pcard.back_icon = "[card_icon_prefix]card_back"
				cards += pcard // Make it so.

		init_jokers()

/obj/item/deck/cards/proc/init_jokers()
	var/datum/playingcard/pcard
	for(var/i = 0, i<2, i++)
		pcard = new()
		pcard.name = "joker"
		pcard.card_icon = "joker"
		cards += pcard

/obj/item/deck/cards/Initialize(mapload)
	. = ..()
	init_cards()

/obj/item/deck/attackby(obj/O, mob/user)
	if(istype(O,/obj/item/hand))
		var/obj/item/hand/H = O
		if(H.parentdeck == src)
			for(var/datum/playingcard/P in H.cards)
				cards += P
			qdel(H)
			to_chat(user,span_notice("You place your cards on the bottom of \the [src]."))
			return
		else
			to_chat(user,span_warning("You can't mix cards from other decks!"))
			return
	..()

/obj/item/deck/attack_hand(mob/user as mob)
	var/mob/living/carbon/human/H = user
	if(ishuman(H) && (istype(src.loc, /obj/item/storage) || src == H.r_store || src == H.l_store || src.loc == user)) // so objects can be removed from storage containers or pockets. also added a catch-all, so if it's in the mob you'll pick it up. Human only, however!
		..()
	else // but if they're not, or are in your hands, you can still draw cards.
		draw_card()

/obj/item/deck/verb/draw_card()

	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from a deck."
	set src in view(1)

	var/mob/living/carbon/user = usr

	if(user.stat || !Adjacent(user)) return

	if(user.hands_are_full()) // Safety check lest the card disappear into oblivion
		to_chat(user,span_notice("Your hands are full!"))
		return

	if(!iscarbon(user))
		return

	if(!cards.len)
		to_chat(user,span_notice("There are no cards in the deck."))
		return

	var/obj/item/hand/H = user.get_type_in_hands(/obj/item/hand)
	if(H && !(H.parentdeck == src))
		to_chat(user,span_warning("You can't mix cards from different decks!"))
		return

	if(!H)
		H = new(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user) return

	var/datum/playingcard/P = cards[1]
	H.cards += P
	cards -= P
	H.parentdeck = src
	H.update_icon()
	user.visible_message(span_infoplain(span_bold("\The [user]") + " draws a card."))
	to_chat(user,span_notice("It's the [P]."))

/obj/item/deck/verb/deal_card()

	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!cards.len)
		to_chat(usr,span_notice("There are no cards in the deck."))
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	//players -= usr

	var/mob/living/M = tgui_input_list(usr, "Who do you wish to deal a card?", "Deal to whom?", players)
	if(!usr || !src || !M) return

	deal_at(usr, M, 1)

/obj/item/deck/verb/deal_card_multi()

	set category = "Object"
	set name = "Deal Multiple Cards"
	set desc = "Deal multiple cards from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!cards.len)
		to_chat(usr,span_notice("There are no cards in the deck."))
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	//players -= usr
	var/maxcards = max(min(cards.len,10),1)
	var/dcard = tgui_input_number(usr, "How many card(s) do you wish to deal? You may deal up to [maxcards] cards.", null, null, maxcards)
	if(dcard > maxcards)
		return
	var/mob/living/M = tgui_input_list(usr, "Who do you wish to deal [dcard] card(s)?", "Deal to whom?", players)
	if(!usr || !src || !M) return

	deal_at(usr, M, dcard)

/obj/item/deck/verb/search_cards()

	set category = "Object"
	set name = "Search for Cards"
	set desc = "Search for and draw a specific card (or cards) in the deck. This will be an obvious action to all observers."
	set src in view(1)

	var/mob/living/carbon/user = usr

	if(user.stat || !Adjacent(user)) return

	if(user.hands_are_full()) // Safety check lest the card disappear into oblivion
		to_chat(user,span_notice("Your hands are full!"))
		return

	if(!iscarbon(user))
		return

	if(!cards.len)
		to_chat(user, span_notice("There are no cards in the deck."))
		return

	var/obj/item/hand/H = user.get_type_in_hands(/obj/item/hand)
	if(H && !(H.parentdeck == src))
		to_chat(user, span_warning("You can't mix cards from different decks!"))
		return


	user.visible_message(span_notice("\The [user] looks into \the [src] and searches within it...")) // Emote before doing anything so you can't cheat!

	// We store the card names as a dictionary with the card name as the key and the number of duplicates of that card
	// 		because otherwise the TGUI checkbox checks all duplicate names if you tick just one
	var/list/card_names = list()
	for(var/datum/playingcard/P in cards)
		var/name = P.name
		// If we haven't yet found any cards with this name...
		if(!card_names[name])
			// ... Add them to a new list, where we'll store any duplicates!
			card_names[name] = list()
		card_names[name] += name


	var/list/cards_to_choose = list()
	for(var/key, value in card_names)
		var/list/L = value
		for(var/i = 0, i < length(L), i++)
			cards_to_choose += "[key] ([i+1])"

	var/list/cards_to_draw = tgui_input_checkboxes(user, "Which cards do you want to retrieve?", "Choose your cards", cards_to_choose, 1)

	if(!LAZYLEN(cards_to_draw))
		user.visible_message(span_notice("\The [user] searches for specific cards in \the [src], but draws none."))
		return

	if(!H)
		H = new(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user)
		return // Sanity check

	// Search through our cards for every card the user chose, and remove them from the deck if the name matches!
	for(var/to_draw in cards_to_draw)
		for(var/i = length(cards), i > 0, i--)
			// Ignore the duplicate number at the end, we just want the card name itself!
			var/TDN = copytext(to_draw, 1, length(to_draw) - 3)
			var/datum/playingcard/P = cards[i]
			if(TDN == P.name)
				H.cards += P
				cards -= P
				H.parentdeck = src
				break
	H.update_icon()

	user.visible_message(span_notice("\The [user] searches for specific cards in \the [src], and draws [cards_to_draw.len]."))

/obj/item/deck/item_ctrl_click(mob/user)
	deal_card()

/obj/item/deck/click_ctrl_shift(mob/user)
	deal_card_multi()

/obj/item/deck/proc/deal_at(mob/user, mob/target, dcard) // Take in the no. of card to be dealt
	var/obj/item/hand/H = new(get_step(user, user.dir))
	var/i
	for(i = 0, i < dcard, i++)
		H.cards += cards[1]
		cards -= cards[1]
		H.parentdeck = src
		H.concealed = 1
		H.update_icon()
	if(user==target)
		user.visible_message(span_notice("\The [user] deals [dcard] card(s) to [user.p_themselves()]."))
	else
		user.visible_message(span_notice("\The [user] deals [dcard] card(s) to \the [target]."))
	H.throw_at(get_step(target,target.dir),10,1,H)


/obj/item/hand/attackby(obj/O as obj, mob/user as mob)
	if(cards.len == 1 && istype(O, /obj/item/pen))
		var/datum/playingcard/P = cards[1]
		if(P.name != "Blank Card")
			to_chat(user,span_notice("You cannot write on that card."))
			return
		var/cardtext = tgui_input_text(user, "What do you wish to write on the card?", "Card Editing", null, MAX_PAPER_MESSAGE_LEN)
		if(!cardtext)
			return
		P.name = cardtext
		// SNOWFLAKE FOR CAG, REMOVE IF OTHER CARDS ARE ADDED THAT USE THIS.
		P.card_icon = "cag_white_card"
		update_icon()
	else if(istype(O,/obj/item/hand))
		var/obj/item/hand/H = O
		if(H.parentdeck == src.parentdeck) // Prevent cardmixing
			for(var/datum/playingcard/P in cards)
				H.cards += P
			H.concealed = src.concealed
			user.drop_from_inventory(src)
			qdel(src)
			H.update_icon()
			return
		else
			to_chat(user,span_notice("You cannot mix cards from other decks!"))
			return

	..()

/obj/item/deck/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	shuffle(user)


/obj/item/deck/verb/verb_shuffle()
	set category = "Object"
	set name = "Shuffle"
	set desc = "Shuffle the cards in the deck."
	set src in view(1)
	shuffle(usr)

/obj/item/deck/proc/shuffle(mob/user)
	if (cooldown < world.time - 10) // 15 ticks cooldown
		var/list/newcards = list()
		while(cards.len)
			var/datum/playingcard/P = pick(cards)
			newcards += P
			cards -= P
		cards = newcards
		user.visible_message(span_notice("\The [user] shuffles [src]."))
		playsound(src, 'sound/items/cardshuffle.ogg', 50, 1)
		cooldown = world.time
	else
		return

/obj/item/deck/click_alt(mob/user)
	if(user.stat || !Adjacent(user))
		return
	shuffle(user)

/obj/item/deck/MouseDrop(mob/user) // Code from Paper bin, so you can still pick up the deck
	if((user == usr && (!( user.restrained() ) && (!( user.stat ) && (user.contents.Find(src) || in_range(src, user))))))
		if(!isanimal(user))
			if( !user.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if (H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(user,span_notice("You try to move your [temp.name], but cannot!"))
					return

				to_chat(user,span_notice("You pick up [src]."))
				user.put_in_hands(src)

	return

/obj/item/deck/verb_pickup() // Snowflaked so pick up verb work as intended
	var/mob/user = usr
	if((istype(user) && (!( user.restrained() ) && (!( user.stat ) && (user.contents.Find(src) || in_range(src, user))))))
		if(!isanimal(user))
			if( !user.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if (H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(user,span_notice("You try to move your [temp.name], but cannot!"))
					return

				to_chat(user,span_notice("You pick up [src]."))
				user.put_in_hands(src)
	return

/obj/item/deck/cards/triple
	name = "big deck of cards"
	desc = "A simple deck of playing cards with triple the number of cards."
	deck_size = 3

/obj/item/pack/
	name = "Card Pack"
	desc = "For those with disposible income."

	icon_state = "card_pack"
	icon = 'icons/obj/playing_cards.dmi'
	w_class = ITEMSIZE_TINY
	var/list/cards = list()
	var/parentdeck = null // This variable is added here so that card pack dependent card can be mixed together by defining a "parentdeck" for them
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'


/obj/item/pack/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	user.visible_message(span_danger("[user] rips open \the [src]!"))
	var/obj/item/hand/H = new()

	H.cards += cards
	H.parentdeck = src.parentdeck
	cards.Cut();
	user.drop_item()
	qdel(src)

	H.update_icon()
	user.put_in_active_hand(H)

/obj/item/hand
	name = "hand of cards"
	desc = "Some playing cards."
	description_info = "Alt click to remove a card, Ctrl click to discard cards."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "empty"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = ITEMSIZE_TINY

	var/concealed = 0
	var/list/cards = list()
	var/parentdeck = null

/obj/item/hand/verb/discard()

	set category = "Object"
	set name = "Discard"
	set desc = "Place (a) card(s) from your hand in front of you."

	var/i
	var/maxcards = min(cards.len,5) // Maximum of 5 cards at once
	var/discards = tgui_input_number(usr, "How many cards do you want to discard? You may discard up to [maxcards] card(s)", null, null, maxcards, 0)
	if(discards > maxcards)
		return
	for	(i = 0;i < discards;i++)
		var/list/to_discard = list()
		for(var/datum/playingcard/P in cards)
			to_discard[P.name] = P
		var/discarding = tgui_input_list(usr, "Which card do you wish to put down?", "Card Selection", to_discard)

		if(!discarding || !to_discard[discarding] || !usr || !src) return

		var/datum/playingcard/card = to_discard[discarding]
		to_discard.Cut()

		var/obj/item/hand/H = new(src.loc)
		H.cards += card
		cards -= card
		H.concealed = 0
		H.parentdeck = src.parentdeck
		H.update_icon()
		src.update_icon()
		usr.visible_message(span_notice("\The [usr] plays \the [discarding]."))
		H.loc = get_turf(usr)
		H.Move(get_step(usr,usr.dir))

	if(!cards.len)
		qdel(src)

/obj/item/hand/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	concealed = !concealed
	update_icon()
	user.visible_message(span_notice("\The [user] [concealed ? "conceals" : "reveals"] their hand."))

/obj/item/hand/examine(mob/user)
	. = ..()
	if((!concealed) && cards.len)
		. += "It contains: "
		for(var/datum/playingcard/P in cards)
			. += "\The [P.name]."

/obj/item/hand/verb/Removecard()

	set category = "Object"
	set name = "Remove card"
	set desc = "Remove a card from the hand."
	set src in view(1)

	var/mob/living/carbon/user = usr

	if(user.stat || !Adjacent(user)) return

	if(user.hands_are_full()) // Safety check lest the card disappear into oblivion
		to_chat(user,span_danger("Your hands are full!"))
		return

	var/pickablecards = list()
	for(var/datum/playingcard/P in cards)
		pickablecards[P.name] = P
	var/pickedcard = tgui_input_list(user, "Which card do you want to remove from the hand?", "Card Selection", pickablecards)

	if(!pickedcard || !pickablecards[pickedcard] || !user || !src) return

	var/datum/playingcard/card = pickablecards[pickedcard]

	var/obj/item/hand/H = new(get_turf(src))
	user.put_in_hands(H)
	H.cards += card
	cards -= card
	H.parentdeck = src.parentdeck
	H.concealed = src.concealed
	H.update_icon()
	src.update_icon()

	if(!cards.len)
		qdel(src)
	return

/obj/item/hand/update_icon(var/direction = 0)

	var/cardNumber = cards.len

	if(!cardNumber)
		qdel(src)
		return
	else if(cardNumber > 1)
		name = "hand of cards ([cardNumber])"
		desc = "Some playing cards."
	else
		name = "a playing card"
		desc = "A playing card."

	cut_overlays()


	if(cardNumber == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		I.pixel_x += (-5+rand(10))
		I.pixel_y += (-5+rand(10))
		add_overlay(I)
		return

	var/offset = FLOOR(20/cardNumber, 1)

	var/matrix/M = matrix()
	if(direction)
		switch(direction)
			if(NORTH)
				M.Translate( 0,  0)
			if(SOUTH)
				M.Translate( 0,  4)
			if(WEST)
				M.Turn(90)
				M.Translate( 3,  0)
			if(EAST)
				M.Turn(90)
				M.Translate(-2,  0)
	var/i = 0
	for(var/datum/playingcard/P in cards)
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		//I.pixel_x = origin+(offset*i)
		switch(direction)
			if(SOUTH)
				I.pixel_x = 8-(offset*i)
			if(WEST)
				I.pixel_y = -6+(offset*i)
			if(EAST)
				I.pixel_y = 8-(offset*i)
			else
				I.pixel_x = -7+(offset*i)
		I.transform = M
		add_overlay(I)
		i++


/obj/item/hand/dropped(mob/user)
	..()
	if(locate(/obj/structure/table, loc))
		src.update_icon(user.dir)
	else
		update_icon()

/obj/item/hand/pickup(mob/user)
	..()
	src.update_icon()

/obj/item/hand/item_ctrl_click(mob/user)
	if(user.stat || !Adjacent(user))
		return
	discard()

/obj/item/hand/click_alt(mob/user)
	Removecard()
