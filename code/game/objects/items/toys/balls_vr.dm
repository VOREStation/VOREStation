/obj/item/toy/tennis
	name = "tennis ball"
	desc = "A classic tennis ball; a hollow rubber sphere covered in felt. This one has seen better days, and seems to have lost most of its bounce."
	icon = 'icons/obj/balls_vr.dmi'
	icon_state = "tennis_classic"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/righthand_balls_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/lefthand_balls_vr.dmi',
		slot_wear_mask_str = 'icons/mob/mouthball_vr.dmi',
		)
	item_state = "tennis_classic"
	slot_flags = SLOT_MASK
	throw_range = 14
	w_class = ITEMSIZE_SMALL

/obj/item/toy/tennis/red
	name = "red tennis ball"
	desc = "A red tennis ball. It goes twice as fast!"
	icon_state = "tennis_red"
	item_state = "tennis_red"
	throw_speed = 8 //base throw_speed is 4, and that's already super fast

/obj/item/toy/tennis/yellow
	name = "yellow tennis ball"
	desc = "A yellow tennis ball. Or is it orange? Orangey-yellow?"
	icon_state = "tennis_yellow"
	item_state = "tennis_yellow"

/obj/item/toy/tennis/green
	name = "green tennis ball"
	desc = "A bright green tennis ball. Tastes faintly of lime... or maybe soap."
	icon_state = "tennis_green"
	item_state = "tennis_green"

/obj/item/toy/tennis/cyan
	name = "cyan tennis ball"
	desc = "A cyan tennis ball. What a curious color choice."
	icon_state = "tennis_cyan"
	item_state = "tennis_cyan"

/obj/item/toy/tennis/blue
	name = "blue tennis ball"
	desc = "A blue tennis ball. Who makes blue tennis balls anyway?"
	icon_state = "tennis_blue"
	item_state = "tennis_blue"

/obj/item/toy/tennis/purple
	name = "purple tennis ball"
	desc = "A purple tennis ball. Now you've seen everything. Purple, seriously?"
	icon_state = "tennis_purple"
	item_state = "tennis_purple"

/obj/item/toy/baseball
	name = "baseball"
	desc = "A classic baseball; a rubber core surrounded by yarn and covered by faux leather. Getting hit with one is akin to getting punched."
	icon = 'icons/obj/balls_vr.dmi'
	icon_state = "baseball"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/righthand_balls_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/lefthand_balls_vr.dmi',
		slot_wear_mask_str = 'icons/mob/mouthball_vr.dmi',
		)
	item_state = "baseball"
	slot_flags = SLOT_MASK
	throw_range = 16
	force = 2.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 5
	w_class = ITEMSIZE_SMALL
