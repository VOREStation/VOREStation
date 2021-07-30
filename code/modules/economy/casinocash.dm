
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

/obj/machinery/chipmachine
	name = "Casino Chip Exchange"
	desc = "Takes all your cash and gives you chips back! No change and half refund!"
	icon = 'icons/obj/casino.dmi'
	icon_state ="chipmachine"
	anchored = 1

/obj/machinery/chipmachine/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/weapon/spacecash))
		//consume the money
		if(prob(50))
			playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

		user << "<span class='info'>You insert [I] into [src].</span>"
		spawn_casinochips(round(I:worth/5), src.loc)
		src.attack_hand(user)
		qdel(I)

	if(istype(I,/obj/item/weapon/spacecasinocash))
		//consume the chips
		if(prob(50))
			playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

		user << "<span class='info'>You insert [I] into [src].</span>"
		spawn_money(round(I:worth/5), src.loc)
		src.attack_hand(user)
		qdel(I)

/obj/item/weapon/spacecasinocash
	name = "broken casino chip"
	desc = "It's worth nothing in a casino."
	gender = PLURAL
	icon = 'icons/obj/casino.dmi'
	icon_state = "spacecasinocash1"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = ITEMSIZE_SMALL
	var/access = list()
	access = access_crate_cash
	var/worth = 0

/obj/item/weapon/spacecasinocash/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/spacecasinocash))

		var/obj/item/weapon/spacecasinocash/SC = W

		SC.adjust_worth(src.worth)
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user

			h_user.drop_from_inventory(src)
			h_user.drop_from_inventory(SC)
			h_user.put_in_hands(SC)
		user << "<span class='notice'>You combine the casino chips to a stack of [SC.worth] of credits.</span>"
		qdel(src)

/obj/item/weapon/spacecasinocash/update_icon()
	overlays.Cut()
	name = "[worth] casino credit\s"
	if(worth in list(1000,500,200,100,50,20,10,1))
		icon_state = "spacecasinocash[worth]"
		desc = "It's a stack of casino chips with a combined value of [worth] credits."
		return
	var/sum = src.worth
	var/num = 0
	for(var/i in list(1000,500,200,100,50,20,10,1))
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image('icons/obj/casino.dmi', "spacecasinocash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			src.overlays += banknote
	if(num == 0) // Less than one credit, let's just make it look like 1 for ease
		var/image/banknote = image('icons/obj/casino.dmi', "spacecasinocash1")
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		src.overlays += banknote
	src.desc = "They are worth [worth] of credits."

/obj/item/weapon/spacecasinocash/proc/adjust_worth(var/adjust_worth = 0, var/update = 1)
	worth += adjust_worth
	if(worth > 0)
		if(update)
			update_icon()
		return worth
	else
		qdel(src)
		return 0

/obj/item/weapon/spacecasinocash/proc/set_worth(var/new_worth = 0, var/update = 1)
	worth = max(0, new_worth)
	if(update)
		update_icon()
	return worth

/obj/item/weapon/spacecasinocash/attack_self()
	var/amount = input(usr, "How much credits worth of chips do you want to take? (0 to [src.worth])", "Take chips", 20) as num
	if(!src || QDELETED(src))
		return
	amount = round(CLAMP(amount, 0, src.worth))

	if(!amount)
		return

	adjust_worth(-amount)
	var/obj/item/weapon/spacecasinocash/SC = new (usr.loc)
	SC.set_worth(amount)
	usr.put_in_hands(SC)

/obj/item/weapon/spacecasinocash/c1
	name = "1 credit casino chip"
	icon_state = "spacecasinocash1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/weapon/spacecasinocash/c10
	name = "10 credit casino chip"
	icon_state = "spacecasinocash10"
	desc = "It's worth 10 credits."
	worth = 10

/obj/item/weapon/spacecasinocash/c20
	name = "20 credit casino chip"
	icon_state = "spacecasinocash20"
	desc = "It's worth 20 credits."
	worth = 20

/obj/item/weapon/spacecasinocash/c50
	name = "50 credit casino chip"
	icon_state = "spacecasinocash50"
	desc = "It's worth 50 credits."
	worth = 50

/obj/item/weapon/spacecasinocash/c100
	name = "100 credit casino chip"
	icon_state = "spacecasinocash100"
	desc = "It's worth 100 credits."
	worth = 100

/obj/item/weapon/spacecasinocash/c200
	name = "200 credit casino chip"
	icon_state = "spacecasinocash200"
	desc = "It's worth 200 credits."
	worth = 200

/obj/item/weapon/spacecasinocash/c500
	name = "500 credit casino chip"
	icon_state = "spacecasinocash500"
	desc = "It's worth 500 credits."
	worth = 500

/obj/item/weapon/spacecasinocash/c1000
	name = "1000 credit casino chip"
	icon_state = "spacecasinocash1000"
	desc = "It's worth 1000 credits."
	worth = 1000

/proc/spawn_casinochips(var/sum, spawnloc, mob/living/carbon/human/human_user as mob)
	var/obj/item/weapon/spacecasinocash/SC = new (spawnloc)

	SC.set_worth(sum)
	if (ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(SC)
	return

/obj/item/weapon/casino_platinum_chip
	name = "platinum chip"
	desc = "Ringa-a-Ding-Ding!"
	icon = 'icons/obj/casino.dmi'
	icon_state = "platinum_chip"
	var/sides = 2
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/casino_platinum_chip/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "Ace"
	else if(result == 2)
		comment = "Joker"
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It lands on [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It lands on [comment]! </span>")