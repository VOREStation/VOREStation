//Weird coins that I would prefer didn't work with normal vending machines. Might use them to make weird vending machines later.

/obj/item/aliencoin
	icon = 'icons/obj/aliencoins.dmi'
	name = "curious coin"
	desc = "A curious triangular coin made primarily of some kind of dark, smooth metal. "
	icon_state = "triangle"
	randpixel = 8
	force = 0.5
	throwforce = 0.5
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/sides = 2
	var/value = 1
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/aliencoin/New()
	randpixel_xy()

/obj/item/aliencoin/basic

/obj/item/aliencoin/gold
	name = "curious coin"
	icon_state = "triangle-g"
	desc = "A curious triangular coin made primarily of some kind of dark, smooth metal. This one's markings appear to reveal a golden material underneath."
	value = 10

/obj/item/aliencoin/silver
	name = "curious coin"
	icon_state = "triangle-s"
	desc = "A curious triangular coin made primarily of some kind of dark, smooth metal. This one's markings appear to reveal a silver material underneath."
	value = 5

/obj/item/aliencoin/phoron
	name = "curious coin"
	icon_state = "triangle-p"
	desc = "A curious triangular coin made primarily of some kind of dark, smooth metal. This one's markings appear to reveal a purple material underneath."
	value = 20


/obj/item/aliencoin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message("<span class='notice'>[user] has thrown [src]. It lands on [comment]! </span>", runemessage = "[src] landed on [comment]")
	if(rand(1,20) == 1)
		user.visible_message("<span class='notice'>[user] fumbled the [src]!</span>", runemessage = "fumbles [src]")
		user.remove_from_mob(src)

/obj/item/aliencoin/examine(var/mob/user)
	. = ..()
	if(Adjacent(user))
		. += "<span class='notice'>It has some writing along its edge that seems to be some language that you are not familiar with. The face of the coin is very smooth, with what appears to be some kind of angular logo along the left side, and a couple of lines of the alien text along the opposite side. The reverse side is similarly smooth, the top of it features what appears to be some kind of vortex, surrounded by six stars, three on either side, with further swirls and intricate patterns along the bottom sections of this face. Looking closely, you can see that there is more text hidden among the swirls.</span>"
