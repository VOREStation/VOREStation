// Shoelocker
/datum/gear/shoes
	display_name = "jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/toeless
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless

/datum/gear/shoes/workboots
	display_name = "workboots"
	path = /obj/item/clothing/shoes/boots/workboots

/datum/gear/shoes/workboots/toeless
	display_name = "toe-less workboots"
	path = /obj/item/clothing/shoes/boots/workboots/toeless

/datum/gear/shoes/sandals
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal

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
	display_name = "shoes, classy"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/dress
	display_name = "shoes, dress"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/green
	display_name = "shoes, green"
	path = /obj/item/clothing/shoes/green

/datum/gear/shoes/leather
	display_name = "shoes, leather"
	path = /obj/item/clothing/shoes/leather

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

/datum/gear/shoes/flats
	display_name = "flats, black"
	path = /obj/item/clothing/shoes/flats

/datum/gear/shoes/hitops/
	display_name = "high-top, white"
	path = /obj/item/clothing/shoes/hitops/

/datum/gear/shoes/hitops/red
	display_name = "high-top, red"
	path = /obj/item/clothing/shoes/hitops/red

/datum/gear/shoes/hitops/black
	display_name = "high-top, black"
	path = /obj/item/clothing/shoes/hitops/black

/datum/gear/shoes/hitops/orange
	display_name = "high-top, orange"
	path = /obj/item/clothing/shoes/hitops/orange

/datum/gear/shoes/hitops/blue
	display_name = "high-top, blue"
	path = /obj/item/clothing/shoes/hitops/blue

/datum/gear/shoes/hitops/green
	display_name = "high-top, green"
	path = /obj/item/clothing/shoes/hitops/green

/datum/gear/shoes/hitops/purple
	display_name = "high-top, purple"
	path = /obj/item/clothing/shoes/hitops/purple

/datum/gear/shoes/hitops/yellow
	display_name = "high-top, yellow"
	path = /obj/item/clothing/shoes/hitops/yellow

/datum/gear/shoes/flats/blue
	display_name = "flats, blue"
	path = /obj/item/clothing/shoes/flats/blue

/datum/gear/shoes/flats/brown
	display_name = "flats, brown"
	path = /obj/item/clothing/shoes/flats/brown

/datum/gear/shoes/flats/orange
	display_name = "flats, orange"
	path = /obj/item/clothing/shoes/flats/orange

/datum/gear/shoes/flats/purple
	display_name = "flats, purple"
	path = /obj/item/clothing/shoes/flats/purple

/datum/gear/shoes/flats/red
	display_name = "flats, red"
	path = /obj/item/clothing/shoes/flats/red

/datum/gear/shoes/flats/white
	display_name = "flats, white"
	path = /obj/item/clothing/shoes/flats/white

/datum/gear/shoes/flipflops
	display_name = "flip flops"
	path = /obj/item/clothing/shoes/flipflop

/datum/gear/shoes/flipflops/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/shoes/athletic
	display_name = "athletic shoes"
	path = /obj/item/clothing/shoes/athletic

/datum/gear/shoes/athletic/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/shoes/skater
	display_name = "skater shoes"
	path = /obj/item/clothing/shoes/skater

/datum/gear/shoes/skater/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/shoes/flats/color
	display_name = "flats"
	path = /obj/item/clothing/shoes/flats/white/color

/datum/gear/shoes/flats/color/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/shoes/cowboy
	display_name = "cowboy boots"
	path = /obj/item/clothing/shoes/boots/cowboy

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
	gear_tweaks = list(gear_tweak_free_color_choice)

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
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/shoes/boots/winter/command
	display_name = "colony director's winter boots"
	path = /obj/item/clothing/shoes/boots/winter/command
	allowed_roles = list("Colony Director")

/datum/gear/shoes/boots/winter/engineering
	display_name = "engineering winter boots"
	path = /obj/item/clothing/shoes/boots/winter/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Station Engineer")

/datum/gear/shoes/boots/winter/atmos
	display_name = "atmospherics winter boots"
	path = /obj/item/clothing/shoes/boots/winter/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/shoes/boots/winter/medical
	display_name = "medical winter boots"
	path = /obj/item/clothing/shoes/boots/winter/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/shoes/boots/winter/mining
	display_name = "mining winter boots"
	path = /obj/item/clothing/shoes/boots/winter/mining
	allowed_roles = list("Shaft Miner")

/datum/gear/shoes/boots/winter/supply
	display_name = "supply winter boots"
	path = /obj/item/clothing/shoes/boots/winter/supply
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/shoes/boots/winter/hydro
	display_name = "hydroponics winter boots"
	path = /obj/item/clothing/shoes/boots/winter/hydro
	allowed_roles = list("Botanist", "Xenobiologist")