//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/trash.dmi'
	w_class = ITEMSIZE_SMALL
	desc = "This is rubbish."
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	matter = list(MAT_STEEL = 30)
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

/obj/item/trash/chips/snv
	name = "salt & vinegar chips bag"
	icon_state = "chips_snv"

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
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/asian_bowl
	name = "asian bowl"
	icon_state	= "asian_bowl"
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/snack_bowl
	name = "snack bowl"
	icon_state	= "snack_bowl"
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/small_bowl
	name = "small bowl"
	icon_state	= "small_bowl"
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

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
	name = "empty chip basket"
	icon_state = "chipbasket_empty"
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/spitgum
	name = "old gum"
	desc = "A disgusting chewed up wad of gum."
	icon = 'icons/inventory/face/item.dmi'
	icon_state = "spit-gum"
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'

/obj/item/trash/lollibutt
	name = "lollipop stick"
	desc = "A lollipop stick devoid of pop."
	icon = 'icons/inventory/face/item.dmi'
	icon_state = "pop-stick"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

/obj/item/trash/spitwad
	name = "spit wad"
	desc = "A disgusting spitwad."
	icon = 'icons/inventory/face/item.dmi'
	icon_state = "spit-chew"
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'
	slot_flags = SLOT_EARS | SLOT_MASK

/obj/item/trash/attack(mob/M as mob, mob/living/user as mob)
	return


/obj/item/trash/beef
	name = "empty beef can"
	icon_state = "beef"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/beans
	name = "empty bean can"
	icon_state = "beans"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/tomato
	name = "empty tomato soup can"
	icon_state = "tomato"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/spinach
	name = "empty spinach can"
	icon_state = "spinach"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/fishegg
	name = "empty fisheggs can"
	icon_state = "fisheggs"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/carpegg
	name = "empty carpeggs can"
	icon_state = "carpeggs"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/ntbeans
	name = "empty baked bean can"
	icon_state = "ntbeans"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/salo
	name = "salo pack"
	icon_state = "pigfat"

/obj/item/trash/croutons
	name = "suhariki pack"
	icon_state = "croutons"

/obj/item/trash/squid
	name = "calamari pack"
	icon_state = "squid"

/obj/item/trash/driedfish
	name = "vobla pack"
	icon_state = "driedfish"

/obj/item/trash/lunacakewrap
	name = "cake wrapper"
	icon_state = "cakewrap"

/obj/item/trash/mochicakewrap
	name = "cake wrapper"
	icon_state = "mochicakewrap"

/obj/item/trash/mooncakewrap
	name = "cake wrapper"
	icon_state = "mooncakewrap"

/obj/item/trash/tidegobs
	name = "tide gob bag"
	icon_state = "tidegobs"

/obj/item/trash/saturno
	name = "\improper saturn-Os bag"
	icon_state = "saturn0s"

/obj/item/trash/jupiter
	name = "gello cup"
	icon_state = "jupiter"

/obj/item/trash/pluto
	name = "rod bag"
	icon_state = "pluto"

/obj/item/trash/venus
	name = "hot cakes bag"
	icon_state = "venus"

/obj/item/trash/mars
	name = "frouka box"
	icon_state = "mars"

/obj/item/trash/oort
	name = "oort rock bag"
	icon_state = "oort"

/obj/item/trash/weebonuts
	name = "red alert nuts bag"
	icon_state = "weebonuts"

/obj/item/trash/stick
	name = "stick"
	desc = "a stick from some snack or other food item, not even useful as crafting material."
	icon_state = "stick"

/obj/item/trash/maps
	name = "empty MAPS can"
	icon_state = "maps"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/spacer_cake_wrap
	name = "snack cake wrapper"
	icon_state = "spacercake_wrap"

/obj/item/trash/sun_snax
	name = "sun snax bag"
	icon_state = "sun_snax"

/obj/item/trash/wasabi_peas
	name = "wasabi peas bag"
	icon_state = "wasabi_peas"

/obj/item/trash/namagashi
	name = "namagashi bag"
	icon_state = "namagashi"

/obj/item/trash/pocky
	name = "pocky bag"
	icon_state = "pocky"

/obj/item/trash/appleberry
	name = "appleberry can"
	icon_state = "appleberry"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/hakarl
	name = "\improper Indigo Co. Hákarl bag"
	icon_state = "hakarl"

/obj/item/trash/pretzel
	name = "\improper Value Pretzel Snack"
	icon_state = "pretzel"

/obj/item/trash/sweetration
	name = "desert ration bag"
	icon_state = "baseration"

/obj/item/trash/genration
	name = "generic ration bag"
	icon_state = "genration"

/obj/item/trash/meatration
	name = "meat ration bag"
	icon_state = "meatration"

/obj/item/trash/vegration
	name = "veggie ration bag"
	icon_state = "vegration"

/obj/item/trash/tgmc_mre
	name = "\improper CRS ration bag"
	icon_state = "tgmc_mre_trash"

/obj/item/trash/smolburger
	name = "burger packaging"
	icon_state = "smolburger"

/obj/item/trash/smolhotdog
	name = "hotdog packaging"
	icon_state = "smolhotdog"

/obj/item/trash/smolburrito
	name = "burrito packaging"
	icon_state = "smolburrito"

/obj/item/trash/candybowl
	name = "candy bowl"
	icon_state = "candy_bowl"

/obj/item/trash/brainzsnax
	name = "\improper BrainzSnax can"
	icon_state = "brainzsnax"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/brainzsnaxred
	name = "\improper BrainzSnax RED can"
	icon_state = "brainzsnaxred"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'


/obj/item/trash/pasty
	name = "pasty packaging"
	icon_state = "pasty"

/obj/item/trash/sausageroll
	name = "sausage roll packaging"
	icon_state = "sausageroll"

/obj/item/trash/scotchegg
	name = "scotch egg packaging"
	icon_state = "scotchegg"

/obj/item/trash/porkpie
	name = "pork pie packaging"
	icon_state = "porkpie"

//Candy Bars (1-10)
/obj/item/trash/candy/cb01
	name = "\improper Tau Ceti Bar wrapper"
	icon_state = "cb01"

/obj/item/trash/candy/cb02
	name = "\improper Hundred-Thousand Thaler Bar wrapper"
	icon_state = "cb02"

/obj/item/trash/candy/cb03
	name = "\improper Lars' Saltlakris wrapper"
	icon_state = "cb03"

/obj/item/trash/candy/cb04
	name = "\improper Aerostat Bar wrapper"
	icon_state = "cb04"

/obj/item/trash/candy/cb05
	name = "\improper Andromeda Bar wrapper"
	icon_state = "cb05"

/obj/item/trash/candy/cb06
	name = "\improper Mocha Crunch wrapper"
	icon_state = "cb06"

/obj/item/trash/candy/cb07
	name = "\improper TaroMilk Bar wrapper"
	icon_state = "cb07"

/obj/item/trash/candy/cb08
	name = "\improper Cronk Bar wrapper"
	icon_state = "cb08"

/obj/item/trash/candy/cb09
	name = "\improper Kaju Mamma! Bar wrapper"
	icon_state = "cb09"

/obj/item/trash/candy/cb10
	name = "\improper Shantak Bar wrapper"
	icon_state = "cb10"