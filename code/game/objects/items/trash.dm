//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/trash.dmi'
	w_class = ITEMSIZE_SMALL
	desc = "This is rubbish."
	drop_sound = 'sound/items/drop/wrapper.ogg'
	var/age = 0

/obj/item/trash/New(var/newloc, var/_age)
	..(newloc)
	if(!isnull(_age))
		age = _age

/obj/item/trash/Initialize()
	SSpersistence.track_value(src, /datum/persistent/filth/trash)
	. = ..()

/obj/item/trash/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/filth/trash)
	. = ..()

/obj/item/trash/raisins
	name = "\improper 4no raisins"
	icon_state = "4no_raisins"

/obj/item/trash/candy
	name = "candy"
	icon_state = "candy"

/obj/item/trash/candy/proteinbar
	name = "protein bar"
	icon_state = "proteinbar"

/obj/item/trash/cheesie
	name = "\improper Cheesie Honkers"
	icon_state = "cheesie_honkers"

/obj/item/trash/chips
	name = "chips"
	icon_state = "chips"

/obj/item/trash/popcorn
	name = "popcorn"
	icon_state = "popcorn"

/obj/item/trash/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"

/obj/item/trash/unajerky
	name = "Moghes Imported Sissalik Jerky"
	icon_state = "unathitinred"
	drop_sound = 'sound/items/drop/soda.ogg'

/obj/item/trash/syndi_cakes
	name = "syndi cakes"
	icon_state = "syndi_cakes"

/obj/item/trash/waffles
	name = "waffles"
	icon_state = "waffles"

/obj/item/trash/plate
	name = "plate"
	icon_state = "plate"

/obj/item/trash/snack_bowl
	name = "snack bowl"
	icon_state	= "snack_bowl"

/obj/item/trash/pistachios
	name = "pistachios pack"
	icon_state = "pistachios_pack"

/obj/item/trash/semki
	name = "semki pack"
	icon_state = "semki_pack"

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"
	drop_sound = 'sound/items/trayhit1.ogg'

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle4"

/obj/item/trash/liquidfood
	name = "\improper \"LiquidFood\" ration"
	icon_state = "liquidfood"

/obj/item/trash/liquidprotein
	name = "\improper \"LiquidProtein\" ration"
	icon_state = "liquidprotein"

/obj/item/trash/liquidvitamin
	name = "\improper \"VitaPaste\" ration"
	icon_state = "liquidvitamin"

/obj/item/trash/tastybread
	name = "bread tube"
	icon_state = "tastybread"

// Aurora Food Port
/obj/item/trash/brownies
	name = "brownie tray"
	icon_state = "brownies"

/obj/item/trash/snacktray
	name = "snacktray"
	icon_state = "snacktray"

/obj/item/trash/dipbowl
	name = "dip bowl"
	icon_state = "dipbowl"

/obj/item/trash/chipbasket
	name = "empty basket"
	icon_state = "chipbasket_empty" 

/obj/item/trash/attack(mob/M as mob, mob/living/user as mob)
	return
