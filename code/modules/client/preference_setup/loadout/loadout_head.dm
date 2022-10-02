/datum/gear/head
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat
	slot = slot_head
	sort_category = "Hats and Headwear"


/datum/gear/head/bandanas
	display_name = "bandana selection"
	path = /obj/item/clothing/head/bandana

/datum/gear/head/bandanas/New()
	..()
	var/bandanatype = list()
	bandanatype["bandana, pirate-red"] = /obj/item/clothing/head/bandana
	bandanatype["bandana, green"] = /obj/item/clothing/head/greenbandana
	bandanatype["bandana, orange"] = /obj/item/clothing/head/orangebandana
	gear_tweaks += new/datum/gear_tweak/path(bandanatype)

/datum/gear/head/beret
	display_name = "beret, colored selection"
	path = /obj/item/clothing/head/beret

/datum/gear/head/beret/New()
	..()
	var/berettype = list()
	berettype["beret, engineering orange"] = /obj/item/clothing/head/beret/engineering
	berettype["beret, purple"] = /obj/item/clothing/head/beret/purple
	berettype["beret, red"] = /obj/item/clothing/head/beret
	gear_tweaks += new/datum/gear_tweak/path(berettype)

/datum/gear/head/beretsec
	display_name = "beret, security selection (Security)"
	path = /obj/item/clothing/head/beret/sec/navy/officer
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/head/beretsec/New()
	..()
	var/berettype = list()
	berettype["officer beret, navy"] = /obj/item/clothing/head/beret/sec/navy/officer
	berettype["officer beret, corporate"] = /obj/item/clothing/head/beret/sec/corporate/officer
	berettype["officer beret, red"] = /obj/item/clothing/head/beret/sec
	berettype["HoS beret, navy"] = /obj/item/clothing/head/beret/sec/navy/hos
	berettype["HoS beret, corporate"] = /obj/item/clothing/head/beret/sec/corporate/hos
	berettype["warden beret, navy"] = /obj/item/clothing/head/beret/sec/navy/warden
	berettype["warden beret, corporate"] = /obj/item/clothing/head/beret/sec/corporate/warden
	gear_tweaks += new/datum/gear_tweak/path(berettype)

/datum/gear/head/cap
	display_name = "cap, soft selection"
	path = /obj/item/clothing/head/soft/black

/datum/gear/head/cap/New()
	..()
	var/captype = list()
	captype["soft cap, black"] = /obj/item/clothing/head/soft/black
	captype["soft cap, blue"] = /obj/item/clothing/head/soft/blue
	captype["soft cap, green"] = /obj/item/clothing/head/soft/green
	captype["soft cap, grey"] = /obj/item/clothing/head/soft/grey
	captype["soft cap, major bill's"] = /obj/item/clothing/head/soft/mbill
	captype["soft cap, orange"] = /obj/item/clothing/head/soft/orange
	captype["soft cap, purple"] = /obj/item/clothing/head/soft/purple
	captype["soft cap, rainbow"] = /obj/item/clothing/head/soft/rainbow
	captype["soft cap, red"] = /obj/item/clothing/head/soft/red
	captype["soft cap, solgov"] = /obj/item/clothing/head/soft/solgov
	captype["soft cap, white"] = /obj/item/clothing/head/soft/mime
	captype["soft cap, yellow"] = /obj/item/clothing/head/soft/yellow
	captype["station cap, blue"] = /obj/item/clothing/head/mailman
	gear_tweaks += new/datum/gear_tweak/path(captype)

/datum/gear/head/sec_cap
	display_name = "cap, soft security selection (Security)"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/head/sec_cap/New()
	..()
	var/list/caps = list()
	for(var/cap in typesof(/obj/item/clothing/head/soft/sec))
		var/obj/item/clothing/head/soft/cap_type = cap
		caps[initial(cap_type.name)] = cap_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(caps))

/datum/gear/head/cap/flat
	display_name = "cap, flat brown"
	path = /obj/item/clothing/head/flatcap

/datum/gear/head/cap/med
	display_name = "cap, medical (Medical)"
	path = /obj/item/clothing/head/soft/med
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic","Search and Rescue")

/datum/gear/head/cap/white
	display_name = "cap (colorable)"
	path = /obj/item/clothing/head/soft/mime

/datum/gear/head/cap/white/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

<<<<<<< HEAD
/datum/gear/head/cap/mbill
	display_name = "cap, major bill's"
	path = /obj/item/clothing/head/soft/mbill

/datum/gear/head/cap/sol
	display_name = "cap, sol"
	path = /obj/item/clothing/head/soft/solgov

/datum/gear/head/cowboy
	display_name = "cowboy"
	path = /obj/item/clothing/head/cowboy

/datum/gear/head/cowboy/rattan
	display_name = "cowboy, rattan"
	path = /obj/item/clothing/head/cowboy/rattan

/datum/gear/head/cowboy/dark
	display_name = "cowboy, dark"
	path = /obj/item/clothing/head/cowboy/dark

/datum/gear/head/cowboy/ranger
	display_name = "cowboy, ranger"
	path = /obj/item/clothing/head/cowboy/ranger

/datum/gear/head/cowboy/black
	display_name = "cowboy, black"
	path = /obj/item/clothing/head/cowboy/black

/datum/gear/head/cowboy/fancy
	display_name = "cowboy, fancy"
	path = /obj/item/clothing/head/cowboy/fancy

/datum/gear/head/cowboy/rustler
	display_name = "cowboy, rustler"
	path = /obj/item/clothing/head/cowboy/rustler

/datum/gear/head/cowboy/black
	display_name = "cowboy, bandit"
	path = /obj/item/clothing/head/cowboy/bandit

/datum/gear/head/cowboy/wide
	display_name = "cowboy, wide"
	path = /obj/item/clothing/head/cowboy/wide
=======
/datum/gear/head/cowboy
	display_name = "cowboy hat selection"
	path = /obj/item/clothing/head/cowboy_hat

/datum/gear/head/cowboy/New()
	..()
	var/list/hats = list()
	for(var/hat in typesof(/obj/item/clothing/head/cowboy_hat))
		var/obj/item/clothing/head/hat_type = hat
		hats[initial(hat_type.name)] = hat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hats))
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)

/datum/gear/head/fedora/grey
	display_name = "fedora, grey"
	path = /obj/item/clothing/head/fedora

/datum/gear/head/fedora/brown
	display_name = "fedora, brown"
	path = /obj/item/clothing/head/fedora/brown

/datum/gear/head/fedora/white
	display_name = "fedora, white"
	path = /obj/item/clothing/head/fedora/white

/datum/gear/head/fedora/beige
	display_name = "fedora, beige"
	path = /obj/item/clothing/head/fedora/beige

/datum/gear/head/fedora/panama
	display_name = "fedora, panama"
	path = /obj/item/clothing/head/fedora/panama

/datum/gear/head/hairflower
	display_name = "hair flower pin (colorable)"
	path = /obj/item/clothing/head/pin/flower/white

/datum/gear/head/hairflower/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/pin
	display_name = "pin selection"
	path = /obj/item/clothing/head/pin

/datum/gear/head/pin/New()
	..()
	var/list/pins = list()
	for(var/obj/item/clothing/head/pin/pin_type as anything in typesof(/obj/item/clothing/head/pin))
		pins[initial(pin_type.name)] = pin_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pins))

/datum/gear/head/hardhat
	display_name = "hardhat selection"
	path = /obj/item/clothing/head/hardhat
	cost = 2

/datum/gear/head/hardhat/New()
	..()
	var/list/hardhats = list()
	for(var/obj/item/clothing/head/hardhat/hardhat_type as anything in typesof(/obj/item/clothing/head/hardhat))
		hardhats[initial(hardhat_type.name)] = hardhat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hardhats))

/datum/gear/head/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowler

/datum/gear/head/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez

/datum/gear/head/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that

/datum/gear/head/wig/philosopher
	display_name = "wig, natural philosopher"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/wig
	display_name = "wig, powdered"
	path = /obj/item/clothing/head/powdered_wig

/datum/gear/head/ushanka
	display_name = "ushanka selection"
	path = /obj/item/clothing/head/ushanka

/datum/gear/head/ushanka/New()
	..()
	var/list/ushankas = list()
	for(var/ushanka in typesof(/obj/item/clothing/head/ushanka))
		var/obj/item/clothing/head/ushanka/ushanka_type = ushanka
		ushankas[initial(ushanka_type.name)] = ushanka_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(ushankas))

/datum/gear/head/santahat
	display_name = "santa hat"
	path = /obj/item/clothing/head/santa
	cost = 2

/datum/gear/head/santahat/New()
	..()
	var/list/santahats = list()
	for(var/obj/item/clothing/head/santa/santahat_type as anything in typesof(/obj/item/clothing/head/santa))
		santahats[initial(santahat_type.name)] = santahat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(santahats))

/datum/gear/head/hijab
	display_name = "hijab"
	path = /obj/item/clothing/head/hijab

/datum/gear/head/hijab/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/kippa
	display_name = "kippa"
	path = /obj/item/clothing/head/kippa

/datum/gear/head/kippa/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/turban
	display_name = "turban"
	path = /obj/item/clothing/head/turban

/datum/gear/head/turban/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/taqiyah
	display_name = "taqiyah"
	path = /obj/item/clothing/head/taqiyah

/datum/gear/head/taqiyah/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/kitty
	display_name = "kitty ears"
	path = /obj/item/clothing/head/kitty

/datum/gear/head/rabbit
	display_name = "rabbit ears"
	path = /obj/item/clothing/head/rabbitears

/datum/gear/head/beanie
	display_name = "beanie"
	path = /obj/item/clothing/head/beanie

/datum/gear/head/beanie/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/loose_beanie
	display_name = "loose beanie"
	path = /obj/item/clothing/head/beanie_loose

/datum/gear/head/loose_beanie/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/beretg
	display_name = "beret (colorable)"
	path = /obj/item/clothing/head/beretg

/datum/gear/head/beretg/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/sombrero
	display_name = "sombrero"
	path = /obj/item/clothing/head/sombrero

/datum/gear/head/flatcapg
<<<<<<< HEAD
	display_name = "flat cap"
=======
	display_name = "cap, flat (colorable)"
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)
	path = /obj/item/clothing/head/flatcap/grey

/datum/gear/head/flatcapg/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/bow/small
	display_name = "hair bow, small (colorable)"
	path = /obj/item/clothing/head/pin/bow

/datum/gear/head/bow/small/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/welding/
	display_name = "welding helmet selection (engineering/robotics)"
	path = /obj/item/clothing/head/welding
	cost = 2
	allowed_roles = list("Chief Engineer","Engineer","Atmospheric Technician","Research Director","Roboticist")

/datum/gear/head/welding/New()
	..()
	var/list/welding_helmets = list()
	for(var/welding_helmet in typesof(/obj/item/clothing/head/welding))
		var/obj/item/clothing/head/welding/welding_helmet_type = welding_helmet
		welding_helmets[initial(welding_helmet_type.name)] = welding_helmet_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(welding_helmets))

/datum/gear/head/beret/solgov
<<<<<<< HEAD
	display_name = "beret government, selection"
=======
	display_name = "beret, government selection"
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)
	path = /obj/item/clothing/head/beret/solgov

/datum/gear/head/beret/solgov/New()
	..()
	var/list/sols = list()
	for(var/sol_style in typesof(/obj/item/clothing/head/beret/solgov))
		var/obj/item/clothing/head/beret/solgov/sol = sol_style
		sols[initial(sol.name)] = sol
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(sols))

/datum/gear/head/surgery
	display_name = "surgical cap selection"
	description = "Choose from a number of rings of different caps."
	path = /obj/item/clothing/head/surgery

/datum/gear/head/surgery/New()
	..()
	var/cap_type = list()
	cap_type["Purple cap"] = /obj/item/clothing/head/surgery/purple
	cap_type["Blue cap"] = /obj/item/clothing/head/surgery/blue
	cap_type["Green cap"] = /obj/item/clothing/head/surgery/green
	cap_type["Black cap"] = /obj/item/clothing/head/surgery/black
	cap_type["Navy cap"] = /obj/item/clothing/head/surgery/navyblue
	gear_tweaks += new/datum/gear_tweak/path(cap_type)

/datum/gear/head/circuitry
	display_name = "headwear, circuitry (empty)"
	path = /obj/item/clothing/head/circuitry

/datum/gear/head/maangtikka
	display_name = "maang tikka"
	path = /obj/item/clothing/head/maangtikka

/datum/gear/head/jingasa
	display_name = "jingasa"
	path = /obj/item/clothing/head/jingasa

/datum/gear/head/sunflower_crown
	display_name = "sunflower crown"
	path = /obj/item/clothing/head/sunflower_crown

/datum/gear/head/lavender_crown
	display_name = "lavender crown"
	path = /obj/item/clothing/head/lavender_crown

/datum/gear/head/poppy_crown
	display_name = "poppy crown"
	path = /obj/item/clothing/head/poppy_crown

/datum/gear/head/rose_crown
	display_name = "rose crown"
	path = /obj/item/clothing/head/rose_crown

/datum/gear/head/blackngoldheaddress
	display_name = "black and gold headdress"
	path = /obj/item/clothing/head/blackngoldheaddress

/datum/gear/head/plaguedoctor
	display_name = "plague doctor's hat"
	path = /obj/item/clothing/head/plaguedoctorhat

/datum/gear/head/plaguedoctor2
	display_name = "golden plague doctor's hat"
	path = /obj/item/clothing/head/plaguedoctorhat/gold

/datum/gear/head/wheat
	display_name = "straw hat"
	path = /obj/item/clothing/head/wheat