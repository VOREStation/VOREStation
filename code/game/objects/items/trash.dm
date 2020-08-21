//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/trash.dmi'
	w_class = ITEMSIZE_SMALL
	desc = "This is rubbish."
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	var/age = 0

/obj/item/trash/New(var/newloc, var/_age)
	..(newloc)
	if(!isnull(_age))
		age = _age

/obj/item/trash/Initialize(mapload)
	if(!mapload || !config.persistence_ignore_mapload)
		SSpersistence.track_value(src, /datum/persistent/filth/trash)
	. = ..()

/obj/item/trash/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/filth/trash)
	. = ..()

/obj/item/trash/raisins
	name = "\improper 4no raisins"
	icon_state = "4no_raisins"

/obj/item/trash/candy
	name = "hard candy wrapper"
	icon_state = "candy"

/obj/item/trash/candy/gums
	name = "gummy candy bag"
	icon_state = "candy_gums"

/obj/item/trash/candy/proteinbar
	name = "protein bar wrapper"
	icon_state = "proteinbar"

/obj/item/trash/candy/fruitbar
	name = "fruit bar wrapper"
	icon_state = "fruitbar"

/obj/item/trash/cheesie
	name = "\improper Cheesie Honkers bag"
	icon_state = "cheesie_honkers"

/obj/item/trash/chips
	name = "chips bag"
	icon_state = "chips"

/obj/item/trash/chips/bbq
	name = "bbq chips bag"
	icon_state = "chips_bbq"

/obj/item/trash/cookiesnack
	name = "\improper Carps Ahoy! miniature cookies packet"
	icon_state = "cookiesnack"

/obj/item/trash/popcorn
	name = "popcorn bag"
	icon_state = "popcorn"

/obj/item/trash/tuna
	name = "tuna can"
	icon_state = "tuna"

/obj/item/trash/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky wrapper"
	icon_state = "sosjerky"

/obj/item/trash/unajerky
	name = "Moghes Imported Sissalik Jerky tin"
	icon_state = "unathitinred"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/syndi_cakes
	name = "syndi cakes box"
	icon_state = "syndi_cakes"

/obj/item/trash/waffles
	name = "waffles tray"
	icon_state = "waffles"

/obj/item/trash/plate
	name = "plate"
	icon_state = "plate"

/obj/item/trash/snack_bowl
	name = "snack bowl"
	icon_state	= "snack_bowl"

/obj/item/trash/pistachios
	name = "pistachios packet"
	icon_state = "pistachios_pack"

/obj/item/trash/semki
	name = "semki packet"
	icon_state = "semki_pack"

/obj/item/trash/koisbar
	name = "candy wrapper"
	icon_state = "koisbar"

/obj/item/trash/kokobar
	name = "candy wrapper"
	icon_state = "kokobar"

/obj/item/trash/gumpack
	name = "gum packet"
	icon_state = "gum_pack"

/obj/item/trash/admints
	name = "mint wrapper"
	icon_state = "admint_pack"

/obj/item/trash/coffee
	name = "empty cup"
	icon_state = "coffee_vended"
	drop_sound = 'sound/items/drop/papercup.ogg'

/obj/item/trash/ramen
	name = "cup ramen"
	icon_state = "ramen"
	drop_sound = 'sound/items/drop/papercup.ogg'

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"
	drop_sound = 'sound/items/trayhit1.ogg'

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle4"

/obj/item/trash/liquidfood
	name = "\improper \"LiquidFood\" ration packet"
	icon_state = "liquidfood"

/obj/item/trash/liquidprotein
	name = "\improper \"LiquidProtein\" ration packet"
	icon_state = "liquidprotein"

/obj/item/trash/liquidvitamin
	name = "\improper \"VitaPaste\" ration packet"
	icon_state = "liquidvitamin"

/obj/item/trash/tastybread
	name = "bread tube wrapper"
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

/obj/item/trash/spitgum
	name = "old gum"
	desc = "A disgusting chewed up wad of gum."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "spit-gum"
	drop_sound = 'sound/items/drop/flesh.ogg'

/obj/item/trash/lollibutt
	name = "lollipop stick"
	desc = "A lollipop stick devoid of pop."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "pop-stick"

/obj/item/trash/spitwad
	name = "spit wad"
	desc = "A disgusting spitwad."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "spit-chew"
	drop_sound = 'sound/items/drop/flesh.ogg'
	slot_flags = SLOT_EARS | SLOT_MASK

/obj/item/trash/attack(mob/M as mob, mob/living/user as mob)
	return
