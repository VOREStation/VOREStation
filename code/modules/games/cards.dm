/datum/playingcard
	var/name = "playing card"
	var/desc
	var/card_icon = "card_back"
	var/back_icon = "card_back"

/obj/item/weapon/deck
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/playing_cards.dmi'
	var/list/cards = list()
	var/cooldown = 0 // to prevent spam shuffle
<<<<<<< HEAD

/obj/item/weapon/deck/holder
	name = "card box"
	desc = "A small leather case to show how classy you are compared to everyone else."
	icon_state = "card_holder"
=======
	var/decklimit = null // For giving a deck a max card count.
	var/decktype
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)

/obj/item/weapon/deck/cards
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon_state = "deck"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	decktype = /datum/playingcard

/obj/item/weapon/deck/cards/New()
	..()
	var/datum/playingcard/P
	for(var/suit in list("spades","clubs","diamonds","hearts"))

		var/colour
		if(suit == "spades" || suit == "clubs")
			colour = "black_"
		else
			colour = "red_"

		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]num"
			P.back_icon = "card_back"
			cards += P

		for(var/number in list("jack","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]col"
			P.back_icon = "card_back"
			cards += P

	for(var/i = 0, i<2, i++)
		P = new()
		P.name = "joker"
		P.card_icon = "joker"
		cards += P

<<<<<<< HEAD
/obj/item/weapon/deck/attackby(obj/O as obj, mob/user as mob)
	if(istype(O,/obj/item/weapon/hand))
		var/obj/item/weapon/hand/H = O
		if(H.parentdeck == src)
=======
/obj/item/deck/attackby(obj/O as obj, mob/user as mob)
	if(istype(O,/obj/item/cardhand))
		var/obj/item/cardhand/H = O
		if(decklimit && (decklimit <= cards.len))
			to_chat(user,"<span class='warning'>This deck is full!</span>")
			return
		if(ispath(H.cardtype, decktype))
			var/i = 0
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
			for(var/datum/playingcard/P in H.cards)
				if(decklimit && (decklimit <= cards.len)) /// Stop placing the cards
					to_chat(user,"<span class='notice'>You place [i] cards on the bottom of \the [src]</span>.")
					H.update_icon()
					return
				i++
				H.cards -= P
				cards += P
			qdel(H)
			to_chat(user,"<span class='notice'>You place your cards on the bottom of \the [src]</span>.")
			return
		else
			to_chat(user,"<span class='warning'>You can't mix cards from other decks!</span>")
			return
	..()

/obj/item/weapon/deck/attack_hand(mob/user as mob)
	var/mob/living/carbon/human/H = user
	if(istype(src.loc, /obj/item/weapon/storage) || src == H.r_store || src == H.l_store || src.loc == user) // so objects can be removed from storage containers or pockets. also added a catch-all, so if it's in the mob you'll pick it up.
		..()
	else // but if they're not, or are in your hands, you can still draw cards.
		draw_card()

/obj/item/weapon/deck/verb/draw_card()

	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from a deck."
	set src in view(1)

	var/mob/living/carbon/user = usr

	if(usr.stat || !Adjacent(usr)) return

	if(user.hands_are_full()) // Safety check lest the card disappear into oblivion
		to_chat(user,"<span class='notice'>Your hands are full!</span>")
		return

	if(!istype(usr,/mob/living/carbon))
		return

	if(!cards.len)
		to_chat(user,"<span class='notice'>There are no cards in the deck.</span>")
		return

<<<<<<< HEAD
	var/obj/item/weapon/hand/H = user.get_type_in_hands(/obj/item/weapon/hand)
	if(H && !(H.parentdeck == src))
=======
	var/obj/item/cardhand/H = user.get_active_hand(/obj/item/cardhand)
	if(H && !ispath(H.cardtype, decktype))
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
		to_chat(user,"<span class='warning'>You can't mix cards from different decks!</span>")
		return

	if(!H)
		H = new(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user) return

	var/datum/playingcard/P = cards[1]
	H.cards += P
	cards -= P
	H.cardtype = src.decktype
	H.update_icon()
	user.visible_message("<b>\The [user]</b> draws a card.")
	to_chat(user,"<span class='notice'>It's the [P].</span>")

<<<<<<< HEAD
/obj/item/weapon/deck/verb/deal_card()
=======
/obj/item/deck/verb/find_card()
	set category = "Object"
	set name = "Find Card"
	set desc = "Find a specific card from a deck."
	set src in view(1)

	if(!ishuman(usr))
		return
	var/mob/living/carbon/user = usr
	if(user.incapacitated() || !Adjacent(user))
		return

	if(user.hands_are_full())
		to_chat(user,"<span class='notice'>Your hands are full!</span>")
		return

	if(!cards.len)
		to_chat(user,"<span class='notice'>There are no cards in the deck.</span>")
		return

	var/list/pickablecards = list()
	for(var/datum/playingcard/P in cards)
		if(!islist(pickablecards[P.name]))
			pickablecards[P.name] = list()
		pickablecards[P.name] += P
	sortTim(pickablecards, /proc/cmp_text_asc)
	var/pickedcard = input("Which card do you want to remove from the deck?")	as null|anything in pickablecards
	if(!pickedcard || !LAZYLEN(pickablecards[pickedcard]) || !usr || !src)
		return

	var/datum/playingcard/card = pick(pickablecards[pickedcard])
	user.visible_message("<span class = 'notice'>\The [user] searches the [src] for a card.</span>") /// To help catch any cheaters.
	var/obj/item/cardhand/H = new(get_turf(src))
	if(!istype(H, /obj/item/cardhand))
		return
	user.put_in_hands(H)
	H.cards += card
	cards -= card
	H.cardtype = src.decktype
	H.update_icon()

/obj/item/deck/verb/deal_card()
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)

	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!cards.len)
		to_chat(usr,"<span class='notice'>There are no cards in the deck.</span>")
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	//players -= usr

	var/mob/living/M = tgui_input_list(usr, "Who do you wish to deal a card?", "Deal to whom?", players)
	if(!usr || !src || !M) return

	deal_at(usr, M, 1)

/obj/item/weapon/deck/verb/deal_card_multi()

	set category = "Object"
	set name = "Deal Multiple Cards"
	set desc = "Deal multiple cards from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!cards.len)
		to_chat(usr,"<span class='notice'>There are no cards in the deck.</span>")
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

<<<<<<< HEAD
/obj/item/weapon/deck/proc/deal_at(mob/user, mob/target, dcard) // Take in the no. of card to be dealt
	var/obj/item/weapon/hand/H = new(get_step(user, user.dir))
=======
/obj/item/deck/proc/deal_at(mob/user, mob/target, dcard) // Take in the no. of card to be dealt
	var/obj/item/cardhand/H = new(get_step(user, user.dir))
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	var/i
	for(i = 0, i < dcard, i++)
		H.cards += cards[1]
		cards -= cards[1]
		H.cardtype = src.decktype
		H.concealed = 1
		H.update_icon()
	if(user==target)
		var/datum/gender/TU = gender_datums[user.get_visible_gender()]
		user.visible_message("<span class = 'notice'>\The [user] deals [dcard] card(s) to [TU.himself].</span>")
	else
		user.visible_message("<span class = 'notice'>\The [user] deals [dcard] card(s) to \the [target].</span>")
	H.throw_at(get_step(target,target.dir),10,1,H)


<<<<<<< HEAD
/obj/item/weapon/hand/attackby(obj/O as obj, mob/user as mob)
	if(cards.len == 1 && istype(O, /obj/item/weapon/pen))
=======
/obj/item/deck/verb/cheater_deal() /// Takes from the bottom of the deck, chance to expose your cheat.
	set category = "Object"
	set name = "Deal From Bottom"
	set desc = "Deal a card from the bottom of a deck, like a cheater."
	set src in view(1)

	if(!cards.len)
		to_chat(usr,"<span class='notice'>There are no cards in the deck.</span>")
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	var/mob/living/M = input("Who do you wish to deal a card?") as null|anything in players
	if(!usr || !src || !M) return

	if(prob(30))
		usr.visible_message("<span class = 'warning'>\The [usr] dealt from the bottom of the deck!</span>")

	moveElement(cards, cards.len, 1) /// Deal_at moves the first card in the list.
	deal_at(usr, M, 1)

/obj/item/cardhand/attackby(obj/O as obj, mob/user as mob)
	if(cards.len == 1 && istype(O, /obj/item/pen))
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
		var/datum/playingcard/P = cards[1]
		if(P.name != "Blank Card")
			to_chat(user,"<span class = 'notice'>You cannot write on that card.</span>")
			return
		var/cardtext = sanitize(tgui_input_text(user, "What do you wish to write on the card?", "Card Editing", null, MAX_PAPER_MESSAGE_LEN), MAX_PAPER_MESSAGE_LEN)
		if(!cardtext)
			return
		P.name = cardtext
		// SNOWFLAKE FOR CAG, REMOVE IF OTHER CARDS ARE ADDED THAT USE THIS.
		P.card_icon = "cag_white_card"
		update_icon()
<<<<<<< HEAD
	else if(istype(O,/obj/item/weapon/hand))
		var/obj/item/weapon/hand/H = O
		if(H.parentdeck == src.parentdeck) // Prevent cardmixing
=======
	else if(istype(O,/obj/item/cardhand))
		var/obj/item/cardhand/H = O
		if(H.cardtype == src.cardtype) // Prevent cardmixing
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
			for(var/datum/playingcard/P in cards)
				H.cards += P
			H.concealed = src.concealed
			user.drop_from_inventory(src)
			qdel(src)
			H.update_icon()
			return
		else
			to_chat(user,"<span class = 'notice'>You cannot mix cards from other decks!</span>")
			return

	..()

/obj/item/weapon/deck/attack_self()
	shuffle()


/obj/item/weapon/deck/verb/verb_shuffle()
	set category = "Object"
	set name = "Shuffle"
	set desc = "Shuffle the cards in the deck."
	set src in view(1)
	shuffle()

/obj/item/weapon/deck/proc/shuffle()
	var/mob/living/user = usr
	if (cooldown < world.time - 10) // 15 ticks cooldown
		var/list/newcards = list()
		while(cards.len)
			var/datum/playingcard/P = pick(cards)
			newcards += P
			cards -= P
		cards = newcards
		user.visible_message("<span class = 'notice'>\The [user] shuffles [src].</span>")
		playsound(src, 'sound/items/cardshuffle.ogg', 50, 1)
		cooldown = world.time
	else
		return


/obj/item/weapon/deck/MouseDrop(mob/user as mob) // Code from Paper bin, so you can still pick up the deck
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/simple_mob))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]

				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(user,"<span class='notice'>You try to move your [temp.name], but cannot!</span>")
					return

				to_chat(user,"<span class='notice'>You pick up [src].</span>")
				user.put_in_hands(src)

	return

/obj/item/weapon/deck/verb_pickup() // Snowflaked so pick up verb work as intended
	var/mob/user = usr
	if((istype(user) && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/simple_mob))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]

				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(user,"<span class='notice'>You try to move your [temp.name], but cannot!</span>")
					return

				to_chat(user,"<span class='notice'>You pick up [src].</span>")
				user.put_in_hands(src)
	return

/obj/item/weapon/pack/
	name = "Card Pack"
	desc = "For those with disposible income."

	icon_state = "card_pack"
	icon = 'icons/obj/playing_cards.dmi'
	w_class = ITEMSIZE_TINY
	var/list/cards = list()
	var/decktype = null // For defining their decktype.
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'


/obj/item/weapon/pack/attack_self(var/mob/user as mob)
	user.visible_message("<span class ='danger'>[user] rips open \the [src]!</span>")
<<<<<<< HEAD
	var/obj/item/weapon/hand/H = new()
=======
	var/obj/item/cardhand/H = new()
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)

	H.cards += cards
	H.cardtype = decktype
	cards.Cut();
	user.drop_item()
	qdel(src)

	H.update_icon()
	user.put_in_active_hand(H)

<<<<<<< HEAD
/obj/item/weapon/hand
=======
/obj/item/cardhand
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "empty"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = ITEMSIZE_TINY

	var/concealed = 0
	var/list/cards = list()
	var/cardtype

<<<<<<< HEAD
/obj/item/weapon/hand/verb/discard()
=======
/obj/item/cardhand/verb/discard()
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)

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

<<<<<<< HEAD
		var/obj/item/weapon/hand/H = new(src.loc)
=======
		var/obj/item/cardhand/H = new(src.loc)
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
		H.cards += card
		cards -= card
		H.concealed = 0
		H.cardtype = src.cardtype
		H.update_icon()
		src.update_icon() /// Calls for qdel if no cards
		usr.visible_message("<span class = 'notice'>\The [usr] plays \the [discarding].</span>")
		H.loc = get_turf(usr)
		H.Move(get_step(usr,usr.dir))

	if(!cards.len)
		qdel(src)

<<<<<<< HEAD
/obj/item/weapon/hand/attack_self(var/mob/user as mob)
=======
/obj/item/cardhand/attack_self(var/mob/user as mob)
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	concealed = !concealed
	update_icon()
	user.visible_message("<span class = 'notice'>\The [user] [concealed ? "conceals" : "reveals"] their hand.</span>")

<<<<<<< HEAD
/obj/item/weapon/hand/examine(mob/user)
=======
/obj/item/cardhand/examine(mob/user)
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	. = ..()
	if((!concealed) && cards.len)
		. += "It contains: "
		for(var/datum/playingcard/P in cards)
			if(!P.desc)
				. += "\The [P.name]."
			else
				. += "[P.name]: [P.desc]"

<<<<<<< HEAD
/obj/item/weapon/hand/verb/Removecard()
=======
/obj/item/cardhand/verb/Removecard()
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)

	set category = "Object"
	set name = "Remove card"
	set desc = "Remove a card from the hand."
	set src in view(1)

	var/mob/living/carbon/user = usr

	if(user.stat || !Adjacent(user)) return

	if(user.hands_are_full()) // Safety check lest the card disappear into oblivion
		to_chat(usr,"<span class='danger'>Your hands are full!</span>")
		return

	var/list/pickablecards = list() /// Make it so duplicates don't cause runtimes
	for(var/datum/playingcard/P in cards)
		if(!islist(pickablecards[P.name]))
			pickablecards[P.name] += list()
		pickablecards[P.name] += P
	var/pickedcard = tgui_input_list(usr, "Which card do you want to remove from the hand?", "Card Selection", pickablecards)

	if(!pickedcard || !LAZYLEN(pickablecards[pickedcard]) || !usr || !src)
		return

	var/datum/playingcard/card = pick(pickablecards[pickedcard])

<<<<<<< HEAD
	var/obj/item/weapon/hand/H = new(get_turf(src))
=======
	var/obj/item/cardhand/H = new(get_turf(src))
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	user.put_in_hands(H)
	H.cards += card
	cards -= card
	H.cardtype = src.cardtype
	H.concealed = src.concealed
	H.update_icon()
	src.update_icon()

	if(!cards.len)
		qdel(src)
	return

<<<<<<< HEAD
/obj/item/weapon/hand/update_icon(var/direction = 0)
=======
/obj/item/cardhand/update_icon(var/direction = 0)
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)

	var/cardNumber = cards.len

	if(!cardNumber)
		qdel(src)
		return
	else if(cardNumber > 1)
		name = "hand of cards ([cardNumber])"
		desc = "Some playing cards."
	else
		name = "playing card"
		desc = "A playing card."

	cut_overlays()


	if(cardNumber == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		I.pixel_x += (-5+rand(10))
		I.pixel_y += (-5+rand(10))
		add_overlay(I)
		return

<<<<<<< HEAD
	var/offset = FLOOR(20/cardNumber, 1)
=======
	var/offset = max(FLOOR(20/cards.len, 1), 1) /// Keeps +20 cards from shifting back into one.
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)

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
		if(i>20)
			return
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

<<<<<<< HEAD

/obj/item/weapon/hand/dropped(mob/user as mob)
=======
/obj/item/cardhand/dropped(mob/user as mob)
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	if(locate(/obj/structure/table, loc))
		src.update_icon(user.dir)

<<<<<<< HEAD
/obj/item/weapon/hand/pickup(mob/user as mob)
=======
/obj/item/cardhand/pickup(mob/user as mob)
>>>>>>> 589122cd24f... Card fixes and QOL (#8996)
	..()
	src.update_icon()
