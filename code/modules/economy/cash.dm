/obj/item/spacecash
	name = "0 Thaler"
	var/initial_name = "Thaler"
	desc = "It's worth 0 Thalers."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
	opacity = 0
	density = FALSE
	anchored = FALSE
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = ITEMSIZE_SMALL
	var/access = list()
	access = access_crate_cash
	var/worth = 0
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/spacecash/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/spacecash))
		if(istype(W, /obj/item/spacecash/ewallet)) return 0

		var/obj/item/spacecash/SC = W

		SC.adjust_worth(src.worth)
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user

			h_user.drop_from_inventory(src)
			h_user.drop_from_inventory(SC)
			h_user.put_in_hands(SC)
		to_chat(user, "<span class='notice'>You combine the [initial_name]s to a bundle of [SC.worth] [initial_name]s.</span>")
		qdel(src)

/obj/item/spacecash/update_icon()
	cut_overlays()
	name = "[worth] [initial_name]\s"
	if(worth in list(1000,500,200,100,50,20,10,1))
		icon_state = "spacecash[worth]"
		desc = "It's worth [worth] [initial_name]s."
		return
	var/sum = src.worth
	var/num = 0
	for(var/i in list(1000,500,200,100,50,20,10,1))
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image('icons/obj/items.dmi', "spacecash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			add_overlay(banknote)
	if(num == 0) // Less than one thaler, let's just make it look like 1 for ease
		var/image/banknote = image('icons/obj/items.dmi', "spacecash1")
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		add_overlay(banknote)
	src.desc = "They are worth [worth] [initial_name]s."

/obj/item/spacecash/proc/adjust_worth(var/adjust_worth = 0, var/update = 1)
	worth += adjust_worth
	if(worth > 0)
		if(update)
			update_icon()
		return worth
	else
		qdel(src)
		return 0

/obj/item/spacecash/proc/set_worth(var/new_worth = 0, var/update = 1)
	worth = max(0, new_worth)
	if(update)
		update_icon()
	return worth

/obj/item/spacecash/attack_self()
	var/amount = tgui_input_number(usr, "How many [initial_name]s do you want to take? (0 to [src.worth])", "Take Money", 20)
	if(!src || QDELETED(src))
		return
	amount = round(CLAMP(amount, 0, src.worth))

	if(!amount)
		return

	adjust_worth(-amount)
	var/obj/item/spacecash/SC = new (usr.loc)
	SC.set_worth(amount)
	usr.put_in_hands(SC)

/obj/item/spacecash/c1
	name = "1 Thaler"
	icon_state = "spacecash1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/spacecash/c10
	name = "10 Thaler"
	icon_state = "spacecash10"
	desc = "It's worth 10 Thalers."
	worth = 10

/obj/item/spacecash/c20
	name = "20 Thaler"
	icon_state = "spacecash20"
	desc = "It's worth 20 Thalers."
	worth = 20

/obj/item/spacecash/c50
	name = "50 Thaler"
	icon_state = "spacecash50"
	desc = "It's worth 50 Thalers."
	worth = 50

/obj/item/spacecash/c100
	name = "100 Thaler"
	icon_state = "spacecash100"
	desc = "It's worth 100 Thalers."
	worth = 100

/obj/item/spacecash/c200
	name = "200 Thaler"
	icon_state = "spacecash200"
	desc = "It's worth 200 Thalers."
	worth = 200

/obj/item/spacecash/c500
	name = "500 Thaler"
	icon_state = "spacecash500"
	desc = "It's worth 500 Thalers."
	worth = 500

/obj/item/spacecash/c1000
	name = "1000 Thaler"
	icon_state = "spacecash1000"
	desc = "It's worth 1000 Thalers."
	worth = 1000

/proc/spawn_money(var/sum, spawnloc, mob/living/carbon/human/human_user as mob)
	var/obj/item/spacecash/SC = new (spawnloc)

	SC.set_worth(sum)
	if (ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(SC)
	return

/obj/item/spacecash/ewallet
	name = "charge card"
	initial_name = "charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/spacecash/ewallet/attack_self() return  //Don't act
/obj/item/spacecash/ewallet/attackby()    return  //like actual
/obj/item/spacecash/ewallet/update_icon() return  //space cash

/obj/item/spacecash/ewallet/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "<span class='notice'>Charge card's owner: [src.owner_name]. Thalers remaining: [src.worth].</span>"
