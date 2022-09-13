// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/blazerskirt
	display_name = "blazer, blue with skirt"
	path = /obj/item/clothing/under/blazer/skirt

/datum/gear/uniform/cheongsam
	description = "Various color variations of an old earth dress style. They are pretty close fitting around the waist."
	display_name = "cheongsam selection"

/datum/gear/uniform/cheongsam/New()
	..()
	var/list/cheongasms = list()
	for(var/obj/item/clothing/under/cheongsam/cheongasm_type as anything in typesof(/obj/item/clothing/under/cheongsam))
		cheongasms[initial(cheongasm_type.name)] = cheongasm_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cheongasms))

/datum/gear/uniform/croptop
	description = "Light shirts which shows the midsection of the wearer."
	display_name = "croptop selection"

/datum/gear/uniform/croptop/New()
	..()
	var/list/croptops = list()
	for(var/obj/item/clothing/under/croptop/croptop_type as anything in typesof(/obj/item/clothing/under/croptop))
		croptops[initial(croptop_type.name)] = croptop_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(croptops))

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/cuttop
	display_name = "cut top, grey"
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/red
	display_name = "cut top, red"
	path = /obj/item/clothing/under/cuttop/red

/datum/gear/uniform/jumpsuit
	display_name = "jumpclothes selection"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/list/jumpclothes = list()
	for(var/obj/item/clothing/under/color/jumps as anything in typesof(/obj/item/clothing/under/color))
		jumpclothes[initial(jumps.name)] = jumps
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jumpclothes))

/datum/gear/uniform/qipao_colorable
	display_name = "qipao, colorable"
	path = /obj/item/clothing/under/qipao_colorable

/datum/gear/uniform/qipao_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/qipao2_colorable
	display_name = "qipao, colorable, slim"
	path = /obj/item/clothing/under/qipao2_colorable

/datum/gear/uniform/qipao2_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/skirt
	display_name = "skirt selection"
	path = /obj/item/clothing/under/skirt

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		if((skirt in typesof(/obj/item/clothing/under/skirt/fluff)) || (skirt in typesof(/obj/item/clothing/under/skirt/outfit/fluff)))	//VOREStation addition
			continue												//VOREStation addition
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(skirts))

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/obj/item/clothing/under/pants/pant_type as anything in (typesof(/obj/item/clothing/under/pants) - typesof(/obj/item/clothing/under/pants/altevian)))
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/obj/item/clothing/under/pants/short_type as anything in typesof(/obj/item/clothing/under/shorts))
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorts))

/datum/gear/uniform/job_skirt/ce
	display_name = "skirt, ce"
	path = /obj/item/clothing/under/rank/chief_engineer/skirt
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/job_skirt/atmos
	display_name = "skirt, atmos"
	path = /obj/item/clothing/under/rank/atmospheric_technician/skirt
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/uniform/job_skirt/eng
	display_name = "skirt, engineer"
	path = /obj/item/clothing/under/rank/engineer/skirt
	allowed_roles = list("Chief Engineer","Engineer")

/datum/gear/uniform/job_skirt/roboticist
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/uniform/job_skirt/cmo
	display_name = "skirt, cmo"
	path = /obj/item/clothing/under/rank/chief_medical_officer/skirt
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/job_skirt/chem
	display_name = "skirt, chemist"
	path = /obj/item/clothing/under/rank/chemist/skirt
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/uniform/job_skirt/viro
	display_name = "skirt, virologist"
	path = /obj/item/clothing/under/rank/virologist/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/uniform/job_skirt/med
	display_name = "skirt, medical"
	path = /obj/item/clothing/under/rank/medical/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")

/datum/gear/uniform/job_skirt/sci
	display_name = "skirt, scientist"
	path = /obj/item/clothing/under/rank/scientist/skirt
	allowed_roles = list("Research Director","Scientist", "Xenobiologist")

/datum/gear/uniform/job_skirt/cargo
	display_name = "skirt, cargo"
	path = /obj/item/clothing/under/rank/cargotech/skirt
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/job_skirt/qm
	display_name = "skirt, QM"
	path = /obj/item/clothing/under/rank/cargo/skirt
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/job_skirt/warden
	display_name = "skirt, warden"
	path = /obj/item/clothing/under/rank/warden/skirt
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/uniform/job_skirt/security
	display_name = "skirt, security"
	path = /obj/item/clothing/under/rank/security/skirt
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_skirt/head_of_security
	display_name = "skirt, hos"
	path = /obj/item/clothing/under/rank/head_of_security/skirt
	allowed_roles = list("Head of Security")

/datum/gear/uniform/job_turtle/science
	display_name = "turtleneck, science"
	path = /obj/item/clothing/under/rank/scientist/turtleneck
	allowed_roles = list("Research Director", "Scientist", "Roboticist", "Xenobiologist")

/datum/gear/uniform/job_turtle/security
	display_name = "turtleneck, security"
	path = /obj/item/clothing/under/rank/security/turtleneck
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_turtle/engineering
	display_name = "turtleneck, engineering"
	path = /obj/item/clothing/under/rank/engineer/turtleneck
	allowed_roles = list("Chief Engineer", "Atmospheric Technician", "Engineer")

/datum/gear/uniform/job_turtle/medical
	display_name = "turtleneck, medical"
	path = /obj/item/clothing/under/rank/medical/turtleneck
	allowed_roles = list("Chief Medical Officer", "Paramedic", "Medical Doctor", "Psychiatrist", "Search and Rescue", "Chemist")

/datum/gear/uniform/jeans_qm
	display_name = "jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jeans
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_qmf
	display_name = "female jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jeans/female
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_cargo
	display_name = "jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jeans
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/jeans_cargof
	display_name = "female jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jeans/female
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/suit/lawyer
	display_name = "suit, one-piece selection"
	path = /obj/item/clothing/under/lawyer

/datum/gear/uniform/suit/lawyer/New()
	..()
	var/list/lsuits = list()
	for(var/obj/item/clothing/suit/lsuit_type as anything in typesof(/obj/item/clothing/under/lawyer))
		lsuits[initial(lsuit_type.name)] = lsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(lsuits))

/datum/gear/uniform/suit/suit_jacket
	display_name = "suit, modular selection"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suit/suit_jacket/New()
	..()
	var/list/msuits = list()
	for(var/msuit in typesof(/obj/item/clothing/under/suit_jacket))
		if(msuit in typesof(/obj/item/clothing/under/suit_jacket/female/fluff))	//VOREStation addition
			continue															//VOREStation addition
		var/obj/item/clothing/suit/msuit_type = msuit
		msuits[initial(msuit_type.name)] = msuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(msuits))

/datum/gear/uniform/suit/amish  //amish
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/gentle
	display_name = "suit, gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/uniform/suit/gentleskirt
	display_name = "suit, lady"
	path = /obj/item/clothing/under/gentlesuit/skirt

/datum/gear/uniform/suit/white
	display_name = "suit, white"
	path = /obj/item/clothing/under/scratch

/datum/gear/uniform/suit/whiteskirt
	display_name = "suit, white skirt"
	path = /obj/item/clothing/under/scratch/skirt

/datum/gear/uniform/suit/detectiveskirt
	display_name = "suit, detective skirt (Detective)"
	path = /obj/item/clothing/under/det/skirt
	allowed_roles = list("Detective")

/datum/gear/uniform/suit/iaskirt
	display_name = "suit, Internal Affairs skirt (Internal Affairs)"
	path = /obj/item/clothing/under/rank/internalaffairs/skirt
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/uniform/suit/bartenderskirt
	display_name = "suit, bartender skirt (Bartender)"
	path = /obj/item/clothing/under/rank/bartender/skirt
	allowed_roles = list("Bartender")

/datum/gear/uniform/scrub
	display_name = "scrubs selection"
	path = /obj/item/clothing/under/rank/medical/scrubs

/datum/gear/uniform/scrub/New()
	..()
	var/list/scrubs = list()
	for(var/obj/item/clothing/under/rank/medical/scrubs/scrub_type as anything in typesof(/obj/item/clothing/under/rank/medical/scrubs))
		scrubs[initial(scrub_type.name)] = scrub_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(scrubs))

/datum/gear/uniform/oldwoman
	display_name = "old woman attire"
	path = /obj/item/clothing/under/oldwoman

/datum/gear/uniform/sundress
	display_name = "sundress"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/white
	display_name = "sundress, white"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/uniform/dress_fire
	display_name = "flame dress"
	path = /obj/item/clothing/under/dress/dress_fire

/datum/gear/uniform/uniform_captain
	display_name = "uniform, site manager's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Site Manager")

/datum/gear/uniform/corpdetsuit
	display_name = "uniform, corporate (Detective)"
	path = /obj/item/clothing/under/det/corporate
	allowed_roles = list("Detective","Head of Security")

/datum/gear/uniform/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/corpwarsuit
	display_name = "uniform, corporate (Warden)"
	path = /obj/item/clothing/under/rank/warden/corp
	allowed_roles = list("Head of Security","Warden")

/datum/gear/uniform/corphossuit
	display_name = "uniform, corporate (Head of Security)"
	path = /obj/item/clothing/under/rank/head_of_security/corp
	allowed_roles = list("Head of Security")

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr

	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/navysecsuit
	display_name = "uniform, navy blue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/navywarsuit
	display_name = "uniform, navy blue (Warden)"
	path = /obj/item/clothing/under/rank/warden/navyblue
	allowed_roles = list("Head of Security","Warden")

/datum/gear/uniform/navyhossuit
	display_name = "uniform, navy blue (Head of Security)"
	path = /obj/item/clothing/under/rank/head_of_security/navyblue
	allowed_roles = list("Head of Security")

/datum/gear/uniform/shortplaindress
	display_name = "plain dress"
	path = /obj/item/clothing/under/dress/white3

/datum/gear/uniform/shortplaindress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/longdress
	display_name = "long dress"
	path = /obj/item/clothing/under/dress/white2

/datum/gear/uniform/longdress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/longwidedress
	display_name = "long wide dress"
	path = /obj/item/clothing/under/dress/white4

/datum/gear/uniform/longwidedress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/reddress
	display_name = "red dress with belt"
	path = /obj/item/clothing/under/dress/darkred

/datum/gear/uniform/whitewedding
	display_name= "white wedding dress"
	path = /obj/item/clothing/under/wedding/bride_white

/datum/gear/uniform/skirts
	display_name = "executive skirt"
	path = /obj/item/clothing/under/suit_jacket/female/skirt

/datum/gear/uniform/dresses
	display_name = "sailor dress"
	path = /obj/item/clothing/under/dress/sailordress

/datum/gear/uniform/dresses/eveninggown
	display_name = "red evening gown"
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/gear/uniform/dresses/maid
	display_name = "maid uniform selection"
	path = /obj/item/clothing/under/dress/maid

/datum/gear/uniform/dresses/maid/New()
	..()
	var/list/maids = list()
	for(var/obj/item/clothing/under/dress/maid/maid_type as anything in typesof(/obj/item/clothing/under/dress/maid))
		maids[initial(maid_type.name)] = maid_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(maids))

/datum/gear/uniform/utility
	display_name = "utility, black"
	path = /obj/item/clothing/under/utility

/datum/gear/uniform/utility/blue
	display_name = "utility, blue"
	path = /obj/item/clothing/under/utility/blue

/datum/gear/uniform/utility/grey
	display_name = "utility, grey"
	path = /obj/item/clothing/under/utility/grey

/datum/gear/uniform/sweater
	display_name = "sweater, grey"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater

/datum/gear/uniform/frontier
	display_name = "outfit, frontier"
	path = 	/obj/item/clothing/under/frontier

/datum/gear/uniform/yogapants
	display_name = "yoga pants"
	path = /obj/item/clothing/under/pants/yogapants

/datum/gear/uniform/yogapants/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/black_corset
	display_name = "black corset"
	path = /obj/item/clothing/under/dress/black_corset

/datum/gear/uniform/flower_dress
	display_name = "flower dress"
	path = /obj/item/clothing/under/dress/flower_dress

/datum/gear/uniform/red_swept_dress
	display_name = "red swept dress"
	path = /obj/item/clothing/under/dress/red_swept_dress

/datum/gear/uniform/bathrobe
	display_name = "bathrobe"
	path = /obj/item/clothing/under/bathrobe

/datum/gear/uniform/flamenco
	display_name = "flamenco dress"
	path = /obj/item/clothing/under/dress/flamenco

/datum/gear/uniform/westernbustle
	display_name = "western bustle"
	path = /obj/item/clothing/under/dress/westernbustle

/datum/gear/uniform/circuitry
	display_name = "jumpsuit, circuitry (empty)"
	path = /obj/item/clothing/under/circuitry

/datum/gear/uniform/sleekoverall
	display_name = "sleek overalls"
	path = /obj/item/clothing/under/overalls/sleek

/datum/gear/uniform/sarired
	display_name = "sari, red"
	path = /obj/item/clothing/under/dress/sari

/datum/gear/uniform/sarigreen
	display_name = "sari, green"
	path = /obj/item/clothing/under/dress/sari/green

/datum/gear/uniform/wrappedcoat
	display_name = "modern wrapped coat"
	path = /obj/item/clothing/under/moderncoat

/datum/gear/uniform/ascetic
	display_name = "plain ascetic garb"
	path = /obj/item/clothing/under/ascetic

/datum/gear/uniform/pleated
	display_name = "pleated skirt"
	path = /obj/item/clothing/under/skirt/pleated

/datum/gear/uniform/pleated/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/lilacdress
	display_name = "lilac dress"
	path = /obj/item/clothing/under/dress/lilacdress

/datum/gear/uniform/polka
	display_name = "polka dot dress"
	path = /obj/item/clothing/under/dress/polka

/datum/gear/uniform/twistfront
	display_name = "twistfront crop dress"
	path = /obj/item/clothing/under/dress/twistfront

/datum/gear/uniform/cropdress
	display_name = "crop dress"
	path = /obj/item/clothing/under/dress/cropdress

/datum/gear/uniform/vneckdress
	display_name = "v-neck dress"
	path = /obj/item/clothing/under/dress/vneck

/datum/gear/uniform/bluedress
	display_name = "blue dress"
	path = /obj/item/clothing/under/dress/bluedress

/datum/gear/uniform/wench
	display_name = "wench's dress"
	path = /obj/item/clothing/under/dress/wench

/datum/gear/uniform/littleblackdress
	display_name = "little black dress"
	path = /obj/item/clothing/under/dress/littleblackdress

/datum/gear/uniform/pinktutu
	display_name = "pink tutu"
	path = /obj/item/clothing/under/dress/pinktutu

/datum/gear/uniform/festivedress
	display_name = "festive dress"
	path = /obj/item/clothing/under/dress/festivedress

/datum/gear/uniform/haltertop
	display_name = "halter top"
	path = /obj/item/clothing/under/haltertop

/datum/gear/uniform/revealingdress
	display_name = "revealing dress"
	path = /obj/item/clothing/under/dress/revealingdress

/datum/gear/uniform/rippedpunk
	display_name = "ripped punk jeans"
	path = /obj/item/clothing/under/rippedpunk

/datum/gear/uniform/gothic
	display_name = "gothic dress"
	path = /obj/item/clothing/under/dress/gothic

/datum/gear/uniform/formalred
	display_name = "formal red dress"
	path = /obj/item/clothing/under/dress/formalred

/datum/gear/uniform/pentagram
	display_name = "pentagram dress"
	path = /obj/item/clothing/under/dress/pentagram

/datum/gear/uniform/yellowswoop
	display_name = "yellow swooped dress"
	path = /obj/item/clothing/under/dress/yellowswoop

/datum/gear/uniform/greenasym
	display_name = "green asymmetrical jumpsuit"
	path = /obj/item/clothing/under/greenasym

/datum/gear/uniform/cyberpunkharness
	display_name = "cyberpunk strapped harness"
	path = /obj/item/clothing/under/cyberpunkharness

/datum/gear/uniform/whitegown
	display_name = "white gown"
	path = /obj/item/clothing/under/wedding/whitegown

/datum/gear/uniform/floofdress
	display_name = "floofy dress"
	path = /obj/item/clothing/under/wedding/floofdress

/datum/gear/uniform/floofdress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/blackngold
	display_name = "black and gold gown"
	path = /obj/item/clothing/under/blackngold

/datum/gear/uniform/sheerblue
	display_name = "sheer blue dress"
	path = /obj/item/clothing/under/sheerblue

/datum/gear/uniform/disheveled
	display_name = "disheveled suit"
	path = /obj/item/clothing/under/disheveled

/datum/gear/uniform/orangedress
	display_name = "orange dress"
	path = /obj/item/clothing/under/dress/dress_orange

/datum/gear/uniform/sundress_pink
	display_name = "pink sundress"
	path = /obj/item/clothing/under/dress/sundress_pink

/datum/gear/uniform/sundress_white
	display_name = "white sundress"
	path = /obj/item/clothing/under/dress/sundress_white

/datum/gear/uniform/sundress_pinkbow
	display_name = "bowed pink sundress"
	path = /obj/item/clothing/under/dress/sundress_pinkbow

/datum/gear/uniform/sundress_blue
	display_name = "long blue sundress"
	path = /obj/item/clothing/under/dress/sundress_blue

/datum/gear/uniform/sundress_pinkshort
	display_name = "short pink sundress"
	path = /obj/item/clothing/under/dress/sundress_pinkshort

/datum/gear/uniform/twopiece
	display_name = "two-piece dress"
	path = /obj/item/clothing/under/dress/twopiece

/datum/gear/uniform/gothic2
	display_name = "lacey gothic dress"
	path = /obj/item/clothing/under/dress/gothic2

/datum/gear/uniform/flowerskirt
	display_name = "flower skirt"
	path = /obj/item/clothing/under/flower_skirt

/datum/gear/uniform/flowerskirt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/countess
	display_name = "countess dress"
	path = /obj/item/clothing/under/dress/countess

/datum/gear/uniform/verglasdress
	display_name = "verglas dress"
	path = /obj/item/clothing/under/dress/verglasdress

/datum/gear/uniform/fashionminiskirt
	display_name = "fashionable miniskirt"
	path = /obj/item/clothing/under/fashionminiskirt

/datum/gear/uniform/fashionminiskirt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/paramedunidark
	display_name = "paramedic uniform, dark"
	path = /obj/item/clothing/under/rank/paramedunidark
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Paramedic")

/datum/gear/uniform/parameduniskirtdark
	display_name = "paramedic skirt, dark"
	path = /obj/item/clothing/under/rank/parameduniskirtdark
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Paramedic")

/datum/gear/uniform/paramedunilight
	display_name = "paramedic uniform, light"
	path = /obj/item/clothing/under/rank/paramedunilight
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Paramedic")

/datum/gear/uniform/parameduniskirtlight
	display_name = "paramedic skirt, light"
	path = /obj/item/clothing/under/rank/parameduniskirtlight
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Paramedic")

/datum/gear/uniform/tourist_1
	display_name = "tourist outfit, white"
	path = /obj/item/clothing/under/tourist_1

/datum/gear/uniform/tourist_2
	display_name = "tourist outfit, blue"
	path = /obj/item/clothing/under/tourist_2

/datum/gear/uniform/cowboy_outfits
	display_name = "cowboy outfit selection"
	path = /obj/item/clothing/under/cowboy

/datum/gear/uniform/cowboy_outfits/New()
	..()
	var/list/cowboy_outfits = list(
	"Patterned Cowboy Outfit" = /obj/item/clothing/under/cowboy,
	"Tan Cowboy Outfit" = /obj/item/clothing/under/cowboy/tan,
	"Brown Cowboy Outfit" = /obj/item/clothing/under/cowboy/brown,
	"Grey Cowboy Outfit" = /obj/item/clothing/under/cowboy/grey
	)
	gear_tweaks += new/datum/gear_tweak/path(cowboy_outfits)

/datum/gear/uniform/utility/gsa
	display_name = "utility, galactic survey"
	path = /obj/item/clothing/under/gsa

/datum/gear/uniform/utility/gsa_work
	display_name = "heavy utility, galactic survey"
	path = /obj/item/clothing/under/gsa_work

/*
 * 80s
 */

/datum/gear/uniform/tropical_outfit/black
	display_name = "tropical outfit, animal style"
	path = /obj/item/clothing/under/tropical

/datum/gear/uniform/tropical_outfit/green
	display_name = "tropical outfit, tropico-puke"
	path = /obj/item/clothing/under/tropical/green

/datum/gear/uniform/tropical_outfit/pink
	display_name = "tropical outfit, 3005 vintage"
	path = /obj/item/clothing/under/tropical/pink

/datum/gear/uniform/tropical_outfit/blue
	display_name = "tropical outfit, miami vice"
	path = /obj/item/clothing/under/tropical/blue

/*
 * Branded Uniforms
 */

/datum/gear/uniform/brandsuit/mbill
	display_name = "uniform, major bill's"
	path = /obj/item/clothing/under/mbill

/datum/gear/uniform/brandsuit/mbill_flight
	display_name = "uniform, major bill's flightsuit (Pilot)"
	path = /obj/item/clothing/under/mbill_flight
	allowed_roles = list("Pilot")

/datum/gear/uniform/brandsuit/aether
	display_name = "jumpsuit, aether"
	path = /obj/item/clothing/under/corp/aether

/datum/gear/uniform/brandsuit/focal
	display_name = "jumpsuit, focal"
	path = /obj/item/clothing/under/corp/focal

/datum/gear/uniform/brandsuit/pcrc
	display_name = "uniform, PCRC (Security)"
	path = /obj/item/clothing/under/corp/pcrc
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/brandsuit/grayson
	display_name = "outfit, grayson"
	path = /obj/item/clothing/under/corp/grayson

/datum/gear/uniform/brandsuit/grayson_jump
	display_name = "jumpsuit, grayson"
	path = /obj/item/clothing/under/corp/grayson_jump

/datum/gear/uniform/brandsuit/wardt
	display_name = "jumpsuit, ward-takahashi"
	path = /obj/item/clothing/under/corp/wardt

/datum/gear/uniform/brandsuit/hephaestus
	display_name = "jumpsuit, hephaestus"
	path = 	/obj/item/clothing/under/corp/hephaestus

/datum/gear/uniform/brandsuit/centauri
	display_name = "jumpsuit, centauri provisions"
	path = /obj/item/clothing/under/corp/centauri

/datum/gear/uniform/brandsuit/morpheus
	display_name = "jumpsuit, morpheus"
	path = /obj/item/clothing/under/corp/morpheus

/datum/gear/uniform/brandsuit/wulf
	display_name = "jumpsuit, wulf"
	path = /obj/item/clothing/under/corp/wulf

/datum/gear/uniform/brandsuit/zenghu
	display_name = "jumpsuit, zeng-hu"
	path = /obj/item/clothing/under/corp/zenghu

/datum/gear/uniform/brandsuit/xion
	display_name = "jumpsuit, xion"
	path = /obj/item/clothing/under/corp/xion

/datum/gear/uniform/brandsuit/vedmed
	display_name = "jumpsuit, vey-med (Medical)"
	path = /obj/item/clothing/under/corp/veymed
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")

/datum/gear/uniform/brandsuit/kaleidoscope
	display_name = "outfit, kaleidoscope (Science)"
	path = 	/obj/item/clothing/under/corp/kaleidoscope
	allowed_roles = list("Research Director","Scientist","Xenobiologist")