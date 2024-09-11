/datum/gear/head
	display_name = "bandana, pirate-red"
	path = /obj/item/clothing/head/bandana
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana_green
	display_name = "bandana, green"
	path = /obj/item/clothing/head/greenbandana

/datum/gear/head/bandana_orange
	display_name = "bandana, orange"
	path = /obj/item/clothing/head/orangebandana

/datum/gear/head/beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret

/datum/gear/head/beret/bsec_warden
	display_name = "beret, navy (warden)"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list(JOB_HEAD_OF_SECURITY,JOB_WARDEN)

/datum/gear/head/beret/bsec_hos
	display_name = "beret, navy (hos)"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list(JOB_HEAD_OF_SECURITY)

/datum/gear/head/beret/csec_warden
	display_name = "beret, corporate (warden)"
	path = /obj/item/clothing/head/beret/sec/corporate/warden
	allowed_roles = list(JOB_HEAD_OF_SECURITY,JOB_WARDEN)

/datum/gear/head/beret/csec_hos
	display_name = "beret, corporate (hos)"
	path = /obj/item/clothing/head/beret/sec/corporate/hos
	allowed_roles = list(JOB_HEAD_OF_SECURITY)

/datum/gear/head/beret/eng
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/engineering

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/cap
	display_name = "cap, brown-flat"
	path = /obj/item/clothing/head/flatcap

/datum/gear/head/cap/selector
	display_name = "cap selector (plain)"
	description = "Pick from a range of plain, coloured softcaps. Includes black, blue, green, and more!"
	path = /obj/item/clothing/head/soft/black

/datum/gear/head/cap/selector/New()
	..()
	var/list/selector_uniforms = list(
		"black"=/obj/item/clothing/head/soft/black,
		"blue"=/obj/item/clothing/head/soft/blue,
		"green"=/obj/item/clothing/head/soft/green,
		"grey"=/obj/item/clothing/head/soft/grey,
		"orange"=/obj/item/clothing/head/soft/orange,
		"purple"=/obj/item/clothing/head/soft/purple,
		"rainbow"=/obj/item/clothing/head/soft/rainbow,
		"red"=/obj/item/clothing/head/soft/red,
		"yellow"=/obj/item/clothing/head/soft/yellow
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/head/cap/mailman
	display_name = "cap, blue station"
	path = /obj/item/clothing/head/mailman

/datum/gear/head/cap/white
	display_name = "cap (colorable)"
	path = /obj/item/clothing/head/soft/mime

/datum/gear/head/cap/white/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/halo
	display_name = "halo (colorable)"
	path = /obj/item/clothing/head/halo

/datum/gear/head/halo/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/cap/sol
	display_name = "cap, sol"
	path = /obj/item/clothing/head/soft/solgov

/datum/gear/head/cowboy
	display_name = "cowboy hat selector"
	description = "Pick from a range of styles of classic cowboy hat. Giddyup!"
	path = /obj/item/clothing/head/cowboy

/datum/gear/head/cowboy/New()
	..()
	var/list/selector_uniforms = list(
		"Classic"=/obj/item/clothing/head/cowboy,
		"Rattan"=/obj/item/clothing/head/cowboy/rattan,
		"Dark"=/obj/item/clothing/head/cowboy/dark,
		"Ranger"=/obj/item/clothing/head/cowboy/ranger,
		"Black"=/obj/item/clothing/head/cowboy/black,
		"Fancy"=/obj/item/clothing/head/cowboy/fancy,
		"Rustler's"=/obj/item/clothing/head/cowboy/rustler,
		"Bandit's"=/obj/item/clothing/head/cowboy/bandit,
		"Wide"=/obj/item/clothing/head/cowboy/wide
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/head/fedora/grey
	display_name = "fedora selector"
	description = "Pick from a range of fedoras. Available in grey, white, brown, beige, and panama style."
	path = /obj/item/clothing/head/fedora

/datum/gear/head/fedora/grey/New()
	..()
	var/list/selector_uniforms = list(
		"Brown"=/obj/item/clothing/head/fedora/brown,
		"White"=/obj/item/clothing/head/fedora/white,
		"Beige"=/obj/item/clothing/head/fedora/beige,
		"Panama"=/obj/item/clothing/head/fedora/panama,
		"Grey"=/obj/item/clothing/head/fedora
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

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

/datum/gear/head/boater
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat

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
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/wig
	display_name = "powdered wig"
	path = /obj/item/clothing/head/powdered_wig

/datum/gear/head/ushanka
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka

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
	display_name = "beret"
	path = /obj/item/clothing/head/beretg

/datum/gear/head/beretg/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/sombrero
	display_name = "sombrero"
	path = /obj/item/clothing/head/sombrero

/datum/gear/head/flatcapg
	display_name = "flat cap"
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

/datum/gear/head/welding
	display_name = "welding mask selection"
	description = "Select from a range of welding masks (engineering crew/roboticists only)"
	path = /obj/item/clothing/head/welding
	cost = 2
	allowed_roles = list("Chief Engineer","Engineer","Atmospheric Technician","Research Director","Roboticist")

/datum/gear/head/welding/New()
	..()
	var/list/selector_uniforms = list(
		"plain"=/obj/item/clothing/head/welding,
		"engineering"=/obj/item/clothing/head/welding/engie,
		"fancy"=/obj/item/clothing/head/welding/fancy,
		"demonic"=/obj/item/clothing/head/welding/demon,
		"knightly"=/obj/item/clothing/head/welding/knight,
		"replikant"=/obj/item/clothing/head/welding/arar
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/head/beret/solgov
	display_name = "beret government, selection"
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

/datum/gear/head/sec_hat_selector
	display_name = "Security - Basic Headwear"
	description = "Select from a range of hats available to all Security personnel."
	allowed_roles = list(JOB_HEAD_OF_SECURITY, JOB_WARDEN, JOB_DETECTIVE, JOB_SECURITY_OFFICER)
	path = /obj/item/clothing/head/soft/sec/corp

/datum/gear/head/sec_hat_selector/New()
	..()
	var/list/selector_uniforms = list(
		"Navy Security Beret"=/obj/item/clothing/head/beret/sec/navy/officer,
		"CorpSec Beret"=/obj/item/clothing/head/beret/sec/corporate/officer,
		"Security Beret"=/obj/item/clothing/head/beret/sec,
		"CorpSec Softcap"=/obj/item/clothing/head/soft/sec/corp,
		"Security Softcap"=/obj/item/clothing/head/soft/sec,
		"Proxima Centauri Contractor Beret"=/obj/item/clothing/head/beret/corp/pcrc
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/head/med_hat_selector
	display_name = "Medical - Basic Headwear"
	description = "Select from a range of hats available to all Medical personnel."
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")
	path = /obj/item/clothing/head/soft/med

/datum/gear/head/med_hat_selector/New()
	..()
	var/list/selector_uniforms = list(
		"medical softcap"=/obj/item/clothing/head/soft/med,
		"paramedic softcap"=/obj/item/clothing/head/soft/paramed,
		"medical beret"=/obj/item/clothing/head/beret/medical,
		"chemist's beret"=/obj/item/clothing/head/beret/medical/chem,
		"virologist's beret"=/obj/item/clothing/head/beret/medical/viro
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/head/giantbow	//Public version of Dessa's bow!
	display_name = "Giant Bow"
	path = /obj/item/clothing/head/fluff/giantbow

/datum/gear/head/giantbow/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/head/bows
	display_name = "hair bow selection, colorable"
	path = /obj/item/clothing/head/bow

/datum/gear/head/bows/New()
	..()
	var/list/bows = list(
	"large bow"=/obj/item/clothing/head/bow,
	"small bow"=/obj/item/clothing/head/bow/small,
	"back bow"=/obj/item/clothing/head/bow/back,
	"sweet bow"=/obj/item/clothing/head/bow/sweet
	)
	gear_tweaks += list(new/datum/gear_tweak/path(bows), gear_tweak_free_color_choice)

/datum/gear/head/pilot
	display_name = "pilot helmets selection"
	description = "Your choice of four hard-wearing head-protecting helmets for pilots."
	path = /obj/item/clothing/head/pilot_vr
	allowed_roles = list("Pilot", "Talon Pilot")

/datum/gear/head/pilot/New()
	..()
	var/list/selector_uniforms = list(
		"pilot helmet, standard"=/obj/item/clothing/head/pilot_vr,
		"pilot helmet, alt"=/obj/item/clothing/head/pilot_vr/alt,
		"pilot helmet, ITV Talon"=/obj/item/clothing/head/pilot_vr/talon,
		"pilot helmet, major bill's transport"=/obj/item/clothing/head/pilot_vr/mbill
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))
