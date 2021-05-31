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
	name = "fish flake packet"
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

/obj/item/trash/skrellsnax
	name = "skrellsnax packet"
	icon_state = "skrellsnacks"

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
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/trash/ramen
	name = "cup ramen"
	icon_state = "ramen"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"
	drop_sound = 'sound/items/trayhit1.ogg'

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle4"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

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
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/snacktray
	name = "snacktray"
	icon_state = "snacktray"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/dipbowl
	name = "dip bowl"
	icon_state = "dipbowl"
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/chipbasket
	name = "empty basket"
	icon_state = "chipbasket_empty"
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/spitgum
	name = "old gum"
	desc = "A disgusting chewed up wad of gum."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "spit-gum"
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'

/obj/item/trash/lollibutt
	name = "lollipop stick"
	desc = "A lollipop stick devoid of pop."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "pop-stick"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

/obj/item/trash/spitwad
	name = "spit wad"
	desc = "A disgusting spitwad."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "spit-chew"
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'
	slot_flags = SLOT_EARS | SLOT_MASK

/obj/item/trash/attack(mob/M as mob, mob/living/user as mob)
	return


/obj/item/trash/beef //ADDITION 04/11/2021
	name = "empty beef can"
	icon_state = "beef"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/beans //ADDITION 04/11/2021
	name = "empty bean can"
	icon_state = "beans"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/spinach //ADDITION 04/11/2021
	name = "empty spinach can"
	icon_state = "spinach"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/fishegg //ADDITION 04/11/2021
	name = "empty fisheggs can"
	icon_state = "fisheggs"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/carpegg //ADDITION 04/11/2021
	name = "empty carpeggs can"
	icon_state = "carpeggs"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/salo //ADDITION 04/11/2021
	name = "salo pack"
	icon_state = "pigfat"

/obj/item/trash/croutons //ADDITION 04/11/2021
	name = "suhariki pack"
	icon_state = "croutons"

/obj/item/trash/squid //ADDITION 04/11/2021
	name = "calamari pack"
	icon_state = "squid"

/obj/item/trash/driedfish //ADDITION 04/11/2021
	name = "vobla pack"
	icon_state = "driedfish"

/obj/item/trash/lunacakewrap //ADDITION 04/11/2021
	name = "cake wrapper"
	icon_state = "cakewrap"

/obj/item/trash/mochicakewrap //ADDITION 04/11/2021
	name = "cake wrapper"
	icon_state = "mochicakewrap"

/obj/item/trash/mooncakewrap //ADDITION 04/11/2021
	name = "cake wrapper"
	icon_state = "mooncakewrap"

/obj/item/trash/tidegobs//ADDITION 04/11/2021
	name = "tide gob bag"
	icon_state = "tidegobs"

/obj/item/trash/saturno//ADDITION 04/11/2021
	name = "\improper saturn-Os bag"
	icon_state = "saturn0s"

/obj/item/trash/jupiter//ADDITION 04/11/2021
	name = "gello cup"
	icon_state = "jupiter"

/obj/item/trash/pluto//ADDITION 04/11/2021
	name = "rod bag"
	icon_state = "pluto"

/obj/item/trash/venus//ADDITION 04/11/2021
	name = "hot cakes bag"
	icon_state = "venus"

/obj/item/trash/mars//ADDITION 04/11/2021
	name = "frouka box"
	icon_state = "mars"

/obj/item/trash/oort//ADDITION 04/11/2021
	name = "oort rock bag"
	icon_state = "oort"

/obj/item/trash/weebonuts//ADDITION 04/11/2021
	name = "red alert nuts bag"
	icon_state = "weebonuts"

/obj/item/trash/stick//ADDITION 04/11/2021
	name = "stick"
	desc = "a stick from some snack or other food item, not even useful as crafting material."
	icon_state = "stick"

/obj/item/trash/maps//ADDITION 04/13/2021
	name = "empty MAPS can"
	icon_state = "maps"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/spacer_cake_wrap//ADDITION 04/14/2021
	name = "snack cake wrapper"
	icon_state = "spacer_cake_wrap"

/obj/item/trash/sun_snax//ADDITION 04/14/2021
	name = "sun snax bag"
	icon_state = "sun_snax"

/obj/item/trash/wasabi_peas//ADDITION 04/14/2021
	name = "wasabi peas bag"
	icon_state = "wasabi_peas"

/obj/item/trash/namagashi//ADDITION 04/14/2021
	name = "namagashi bag"
	icon_state = "namagashi"

/obj/item/trash/pocky//ADDITION 04/14/2021
	name = "pocky bag"
	icon_state = "pocky"

/obj/item/trash/appleberry//ADDITION 04/14/2021
	name = "appleberry can"
	icon_state = "appleberry"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/hakarl//ADDITION 04/22/2021
	name = "\improper Indigo Co. Hákarl bag"
	icon_state = "hakarl"

/obj/item/trash/pretzel//ADDITION 04/22/2021
	name = "\improper Value Pretzel Snack"
	icon_state = "pretzel"

/obj/item/trash/sweetration//ADDITION 04/20/2021
	name = "desert ration bag"
	icon_state = "baseration"

/obj/item/trash/genration//ADDITION 04/20/2021
	name = "generic ration bag"
	icon_state = "genration"

/obj/item/trash/meatration//ADDITION 04/20/2021
	name = "meat ration bag"
	icon_state = "meatration"

/obj/item/trash/vegration//ADDITION 04/20/2021
	name = "veggie ration bag"
	icon_state = "vegration"

