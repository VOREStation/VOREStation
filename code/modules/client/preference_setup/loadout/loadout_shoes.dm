// Shoelocker
/datum/gear/shoes
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/tourist_1
	display_name = "tourist, black"
	path = /obj/item/clothing/shoes/tourist_1

/datum/gear/shoes/tourist_2
	display_name = "tourist, green"
	path = /obj/item/clothing/shoes/tourist_2

/datum/gear/shoes/sneakerspurple
	display_name = "sneakers, purple"
	path = /obj/item/clothing/shoes/sneakerspurple

/datum/gear/shoes/sneakersblue
	display_name = "sneakers, blue"
	path = /obj/item/clothing/shoes/sneakersblue

/datum/gear/shoes/sneakersred
	display_name = "sneakers, red"
	path = /obj/item/clothing/shoes/sneakersred

/datum/gear/shoes/jackboots
	display_name = "jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots

/datum/gear/shoes/kneeboots
	display_name = "jackboots, knee-length"
	path = /obj/item/clothing/shoes/boots/jackboots/knee

/datum/gear/shoes/thighboots
	display_name = "jackboots. thigh-length"
	path = /obj/item/clothing/shoes/boots/jackboots/thigh

/datum/gear/shoes/workboots
	display_name = "workboots"
	path = /obj/item/clothing/shoes/boots/workboots

/datum/gear/shoes/workboots/toeless
	display_name = "toe-less workboots"
	path = /obj/item/clothing/shoes/boots/workboots/toeless

/datum/gear/shoes/black
	display_name = "shoes, black"
	path = /obj/item/clothing/shoes/black

/datum/gear/shoes/blue
	display_name = "shoes, blue"
	path = /obj/item/clothing/shoes/blue

/datum/gear/shoes/brown
	display_name = "shoes, brown"
	path = /obj/item/clothing/shoes/brown

/datum/gear/shoes/lacey
	display_name = "shoes, oxford selection"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/lacey/New()
    ..()
    var/list/laces = list()
    for(var/lace in typesof(/obj/item/clothing/shoes/laceup))
        var/obj/item/clothing/shoes/laceup/lace_type = lace
        laces[initial(lace_type.name)] = lace_type
    gear_tweaks += new/datum/gear_tweak/path(sortAssoc(laces))

/datum/gear/shoes/green
	display_name = "shoes, green"
	path = /obj/item/clothing/shoes/green

/datum/gear/shoes/orange
	display_name = "shoes, orange"
	path = /obj/item/clothing/shoes/orange

/datum/gear/shoes/purple
	display_name = "shoes, purple"
	path = /obj/item/clothing/shoes/purple

/datum/gear/shoes/rainbow
	display_name = "shoes, rainbow"
	path = /obj/item/clothing/shoes/rainbow

/datum/gear/shoes/red
	display_name = "shoes, red"
	path = /obj/item/clothing/shoes/red

/datum/gear/shoes/white
	display_name = "shoes, white"
	path = /obj/item/clothing/shoes/white

/datum/gear/shoes/yellow
	display_name = "shoes, yellow"
	path = /obj/item/clothing/shoes/yellow

/datum/gear/shoes/hitops/
	display_name = "high-top selection"
	path = /obj/item/clothing/shoes/hitops/

/datum/gear/shoes/hitops/New()
    ..()
    var/list/hitops = list()
    for(var/hitop in typesof(/obj/item/clothing/shoes/hitops))
        var/obj/item/clothing/shoes/hitops/hitop_type = hitop
        hitops[initial(hitop_type.name)] = hitop_type
    gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hitops))

/datum/gear/shoes/flipflops
	display_name = "flip flops"
	path = /obj/item/clothing/shoes/flipflop

/datum/gear/shoes/flipflops/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/athletic
	display_name = "athletic shoes"
	path = /obj/item/clothing/shoes/athletic

/datum/gear/shoes/athletic/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/skater
	display_name = "skater shoes"
	path = /obj/item/clothing/shoes/skater

/datum/gear/shoes/skater/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/flats
	display_name = "flats"
	path = /obj/item/clothing/shoes/flats/white/color

/datum/gear/shoes/flats/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/cowboy
	display_name = "cowboy boots"
	path = /obj/item/clothing/shoes/boots/cowboy

/datum/gear/shoes/cowboy/classic
	display_name = "cowboy boots, classic"
	path = /obj/item/clothing/shoes/boots/cowboy/classic

/datum/gear/shoes/cowboy/brown
	display_name = "cowboy boots, brown"
	path = /obj/item/clothing/shoes/boots/cowboy/brown

/datum/gear/shoes/cowboy/black
	display_name = "cowboy boots, black"
	path = /obj/item/clothing/shoes/boots/cowboy/black

/datum/gear/shoes/cowboy/white
	display_name = "cowboy boots, white"
	path = /obj/item/clothing/shoes/boots/cowboy/white

/datum/gear/shoes/cowboy/fancy
	display_name = "cowboy boots, fancy"
	path = /obj/item/clothing/shoes/boots/cowboy/fancy

/datum/gear/shoes/cowboy/snakeskin
	display_name = "cowboy boots, snake skin"
	path = /obj/item/clothing/shoes/boots/cowboy/snakeskin

/datum/gear/shoes/cowboy/lizard
	display_name = "cowboy boots, lizard skin"
	path = /obj/item/clothing/shoes/boots/cowboy/lizard

/datum/gear/shoes/cowboy/lizard/masterwork
	display_name = "cowboy boots, lizard skin (masterwork)"
	path = /obj/item/clothing/shoes/boots/cowboy/lizard/masterwork

/datum/gear/shoes/jungle
	display_name = "jungle boots"
	path = /obj/item/clothing/shoes/boots/jungle
	cost = 2

/datum/gear/shoes/duty
	display_name = "duty boots"
	path = 	/obj/item/clothing/shoes/boots/duty
	cost = 2

/datum/gear/shoes/dress
	display_name = "shoes, dress"
	path = 	/obj/item/clothing/shoes/dress

/datum/gear/shoes/dress/white
	display_name = "shoes, dress white"
	path = 	/obj/item/clothing/shoes/dress/white

/datum/gear/shoes/heels
	display_name = "high heels"
	path = /obj/item/clothing/shoes/heels

/datum/gear/shoes/heels/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/slippers
	display_name = "bunny slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/boots/winter
	display_name = "winter boots"
	path = /obj/item/clothing/shoes/boots/winter

/datum/gear/shoes/boots/winter/security
	display_name = "security winter boots"
	path = /obj/item/clothing/shoes/boots/winter/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/shoes/boots/winter/science
	display_name = "science winter boots"
	path = /obj/item/clothing/shoes/boots/winter/science

/datum/gear/shoes/boots/winter/command
	display_name = "site manager's winter boots"
	path = /obj/item/clothing/shoes/boots/winter/command
	allowed_roles = list("Site Manager")

/datum/gear/shoes/boots/winter/engineering
	display_name = "engineering winter boots"
	path = /obj/item/clothing/shoes/boots/winter/engineering

/datum/gear/shoes/boots/winter/atmos
	display_name = "atmospherics winter boots"
	path = /obj/item/clothing/shoes/boots/winter/atmos

/datum/gear/shoes/boots/winter/medical
	display_name = "medical winter boots"
	path = /obj/item/clothing/shoes/boots/winter/medical

/datum/gear/shoes/boots/winter/mining
	display_name = "mining winter boots"
	path = /obj/item/clothing/shoes/boots/winter/mining

/datum/gear/shoes/boots/winter/supply
	display_name = "supply winter boots"
	path = /obj/item/clothing/shoes/boots/winter/supply

/datum/gear/shoes/boots/winter/hydro
	display_name = "hydroponics winter boots"
	path = /obj/item/clothing/shoes/boots/winter/hydro

/datum/gear/shoes/circuitry
	display_name = "boots, circuitry (empty)"
	path = /obj/item/clothing/shoes/circuitry
