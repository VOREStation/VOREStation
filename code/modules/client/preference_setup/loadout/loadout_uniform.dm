// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Casual Dress"

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
	display_name = "suit, bartender skirt"
	path = /obj/item/clothing/under/rank/bartender/skirt

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

/datum/gear/uniform/overalls
	display_name = "overalls selection"
	path = /obj/item/clothing/under/overalls

/datum/gear/uniform/overalls/New()
	..()
	var/list/overalls = list(
	"Laborer's Overalls" = /obj/item/clothing/under/overalls,
	"Sleek Overalls" = /obj/item/clothing/under/overalls/sleek,
	"Workman Overalls" = /obj/item/clothing/under/overalls/service,
	"Frontier Overalls" = /obj/item/clothing/under/overalls/frontier,
	"Rustler Overalls" = /obj/item/clothing/under/overalls/rustler
	)
	gear_tweaks += new/datum/gear_tweak/path(overalls)

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

/datum/gear/uniform/tanktop
	display_name = "tank top"
	path = /obj/item/clothing/under/tanktop

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

/datum/gear/uniform/hightrousers
	display_name = "high-waisted trousers"
	path = /obj/item/clothing/under/dress/hightrousers

/datum/gear/uniform/vampirehunter
	display_name = "18th century outfit"
	path = /obj/item/clothing/under/vampirehunter

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


//leotards
/datum/gear/uniform/leotard
    display_name = "leotard, black"
    path = /obj/item/clothing/under/leotard

/datum/gear/uniform/leotardcolor
    display_name = "leotard, colorable"
    path = /obj/item/clothing/under/leotardcolor

/datum/gear/uniform/leotardcolor/New()
    ..()
    gear_tweaks += gear_tweak_free_color_choice

//skinsuits
/datum/gear/uniform/skinsuits
	display_name = "skinsuit selection"
	path = /obj/item/clothing/under/skinsuit

/datum/gear/uniform/skinsuits/New()
	..()
	var/list/skinsuits = list(
	"skinsuit"=/obj/item/clothing/under/skinsuit,
	"feminine skinsuit"=/obj/item/clothing/under/skinsuit/fem,
	"gray skinsuit"=/obj/item/clothing/under/skinsuit/gray,
	"feminine gray skinsuit"=/obj/item/clothing/under/skinsuit/fem/gray,
	"leotard skinsuit"=/obj/item/clothing/under/skinsuit/leotard,
	"feminine leotard skinsuit"=/obj/item/clothing/under/skinsuit/fem/leotard,
	"gray leotard skinsuit"=/obj/item/clothing/under/skinsuit/leotard/gray,
	"feminine gray leotard skinsuit"=/obj/item/clothing/under/skinsuit/fem/leotard/gray
	)
	gear_tweaks += list(new/datum/gear_tweak/path(skinsuits))

//baggy turtlenecks
/datum/gear/uniform/turtlebaggys
	display_name = "baggy turtleneck selection"
	path = /obj/item/clothing/under/turtlebaggy

/datum/gear/uniform/turtlebaggys/New()
	..()
	var/list/turtlebaggys = list(
	"cream baggy turtleneck"=/obj/item/clothing/under/turtlebaggy,
	"feminine cream baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/cream_fem,
	"purple baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/purple,
	"feminine purple baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/purple_fem,
	"red baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/red,
	"feminine red baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/red_fem,
	"blue baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/blue,
	"feminine blue baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/blue_fem,
	"green baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/green,
	"feminine green baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/green_fem,
	"black baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/black,
	"feminine black baggy turtleneck"=/obj/item/clothing/under/turtlebaggy/black_fem
	)
	gear_tweaks += list(new/datum/gear_tweak/path(turtlebaggys))

//colorable sweaters
/datum/gear/uniform/bigsweaters
	display_name = "sweater selection, colorable"
	path = /obj/item/clothing/under/bigsweater

/datum/gear/uniform/bigsweaters/New()
	..()
	var/list/bigsweaters = list(
	"cableknit sweater"=/obj/item/clothing/under/bigsweater,
	"keyhole sweater"=/obj/item/clothing/under/bigsweater/keyhole
	)
	gear_tweaks += list(new/datum/gear_tweak/path(bigsweaters), gear_tweak_free_color_choice)

//half-moon outfit
/datum/gear/uniform/halfmoon
    display_name = "half moon outfit"
    path = /obj/item/clothing/under/half_moon

//fiend clothes
/datum/gear/uniform/fiendsuit
    display_name = "fiendish suit"
    path = /obj/item/clothing/under/fiendsuit

/datum/gear/uniform/fienddress
    display_name = "fiendish dress"
    path = /obj/item/clothing/under/fienddress

//tabard dresses
/datum/gear/uniform/tabarddress
	display_name = "tabard-dress selection"
	path = /obj/item/clothing/under/dress/tabard

/datum/gear/uniform/tabarddress/New()
	..()
	var/list/tabarddress = list(
	"white tabard-dress"=/obj/item/clothing/under/dress/tabard,
	"black tabard-dress"=/obj/item/clothing/under/dress/tabard/black
	)
	gear_tweaks += list(new/datum/gear_tweak/path(tabarddress))
