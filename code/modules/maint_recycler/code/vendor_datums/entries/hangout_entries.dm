/datum/maint_recycler_vendor_entry/DIY_Wood
	name = "WOOD. WOOD. WOOD. WOOD."
	desc = "Dear Humanity. we WOULD those alien bastards. we WOULD those earthlings. and we most definately WOOD use these raggedy-ass materials to build something nice!!"
	object_type_to_spawn = /obj/item/stack/material/wood{amount = 20}
	item_cost = 15 //not too pricy
	tagline = "hehehe. Got Wood?"
	ad_message = "WOOD. WOOD. WOOD."
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_HardWood //this one writes itself
	name = "Hard... Knotty Wood... "
	desc = "Seriously! this tree sucked! unsuitable for professional construction due to how hard the knots are, the savings (and various aches and pains) are passed onto YOU!!!"
	tagline = "Hehehehehe"
	ad_message = "🤤"
	icon_state = "knotty_wood"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	object_type_to_spawn = /obj/item/stack/material/wood/hard{amount = 20}


/datum/maint_recycler_vendor_entry/DIY_Steel
	vendor_category = MAINTVENDOR_CONSTRUCTION
	name = "steel!"
	ad_message = "A Steal of a STEEL!"
	desc = "A steal of a deal! this steel is sure to make you feel like a real deal! buy now, please! I need the money!"
	object_type_to_spawn = /obj/item/stack/material/steel{amount = 20}
	item_cost = 15 //not too pricy
	icon_state = "steal"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Glass
	vendor_category = MAINTVENDOR_CONSTRUCTION
	name = "Glass! Glass! Glass!"
	ad_message = "Crystal Clear!"
	desc = "The savings are crystal clear! You'd be a FREAK to not see straight through it!"
	object_type_to_spawn = /obj/item/stack/material/glass{amount = 20}
	item_cost = 15 //not too pricy
	icon_state = "glass"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_PhoronGlass //technically a straight upgrade but pragmatically people just use it for stripper stages and cyberpunk esq hangouts
	vendor_category = MAINTVENDOR_CONSTRUCTION
	name = "Fru1ty G1a55"
	ad_message = "Fruity!"
	desc = "Not even the top minds at science know why it's pink! some say it's phoron! Sane people say it's gay!"
	object_type_to_spawn = /obj/item/stack/material/glass/phoronglass{amount = 20}
	item_cost = 15 //not too pricy
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Copper
	vendor_category = MAINTVENDOR_CONSTRUCTION
	name = "Copper!"
	ad_message = "Copper!"
	desc = "Used since ancient times, but still more recently than the last time your outfit was in fashion!"
	object_type_to_spawn = /obj/item/stack/material/copper{amount = 20}
	item_cost = 15 //not too pricy
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Carpet
	name = "S0FT CURLY F1BR3S THAT M4TCH THE DRAPE???"
	ad_message = "STANDRD!"
	desc = "PR3MIUM C4RP3T @ RESONABL PRICE!"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	object_type_to_spawn = /obj/item/stack/tile/carpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Carpet_Black
	name = "DON'T RUG ME THE WRONG WAY???"
	ad_message = "BLK! DIAMND!!?"
	desc = "PR3MIUM C4RP3T @ RESONABL PRICE!"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	object_type_to_spawn = /obj/item/stack/tile/carpet/bcarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Carpet_teal
	name = "A T3AL OF A D3AL?"
	ad_message = "TEAL IS BLUE!"
	desc = "PR3MIUM C4RP3T @ RESONABL PRICE! BUY BUY BUY!"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	object_type_to_spawn = /obj/item/stack/tile/carpet/teal{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Carpet_tur
	name = "TURQOISE 4 BORGUIOSE?"
	ad_message = "TURQUOISE IS T3AL!"
	desc = "CARPET! BUY YOUR CARPET HERE! DEALS THAT'LL BLUE YOU AWAY"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	object_type_to_spawn = /obj/item/stack/tile/carpet/turcarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Carpet_blue
	name = "BLU3 CARP3T?"
	ad_message = "BLUE IS TURQOISE!"
	desc = "CARPET! BUY YOUR CARPET HERE! DEALS THAT'LL MAKE YOU WANT TO SPEND MONEY"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	object_type_to_spawn = /obj/item/stack/tile/carpet/blucarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!

/datum/maint_recycler_vendor_entry/DIY_Carpet_fancy_blue
	name = "FANCY BLUE CARPET 4 RICH PEOPLE"
	ad_message = "BLUE! SILVER! BLUE!"
	desc = "IF YOU COULD SEE A SILVER OF THE SAVINGS YOU'D BE BLUE-N AWAY!"
	vendor_category = MAINTVENDOR_CONSTRUCTION
	object_type_to_spawn = /obj/item/stack/tile/carpet/sblucarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!


/datum/maint_recycler_vendor_entry/DIY_Carpet_gay
	name = "SOFT TOESIES FOR YOUR HOMESIES"
	desc = "DUBIOUSLY STRAIGHT? THIS CAME FROM THE FACTORY FLOOR WITH A BIG \"4HOMOS\" LABEL! HATERS WILL SAY IT'S A PRODUCT CODE, BUT WE KNOW THE TRUTH!"
	ad_message = "PINK! PINK! STINK-FREE!"
	object_type_to_spawn = /obj/item/stack/tile/carpet/gaycarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_purple
	name = "P1MP RUG 4 HARDCOR3 GANGST3RS."
	desc = "KEEP UR WRIST LIMP WHEN BITCH SLAPPING THAT BUY BUTTON! "
	object_type_to_spawn = /obj/item/stack/tile/carpet/purcarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_orange
	name = "BLING BLING CARPET 4 U"
	desc = "ORANGE? CHECK. DIAMOND? CHECK. YOU'RE RICHER ALREADY JUST THINKING ABOUT IT!"
	ad_message = "JONES PELT RUG!"
	object_type_to_spawn = /obj/item/stack/tile/carpet/oracarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_brncarpet
	name = "yawn.... some brown carpet for boring people i guess...."
	desc = "not like anyone cares... but this low intensity... yawn... carpet is perfect... yawn... for the refined... yawn... individual..."
	ad_message = "yawn..."
	object_type_to_spawn = /obj/item/stack/tile/carpet/brncarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_blue2
	name = "BLU 4 U CARPET EXCANGE PROGRAM"
	desc = "BLUE? CHECK. FANCY? CHECK. PROBABLY RIPPED FROM A BANK? CHECK. CHECK? CASHED WHEN U HIT BUY!"
	ad_message = "FANCY!"
	object_type_to_spawn = /obj/item/stack/tile/carpet/blucarpet2{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_green
	name = "CACTUS SKIN LOOKING 4 HOME"
	desc = "SPINES REMOVED FANCY PATTERN 4 HOSERS INSTALLED V FANCY CARPET"
	ad_message = "CACTUS GREEN!"
	object_type_to_spawn = /obj/item/stack/tile/carpet/greencarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_purple
	name = "PURPLE! PURPLE! PURPLE!"
	desc = "FANCY PATTERN 4 HOSERS PURPLE MEAN RICH UR RICH"
	ad_message = "ROYAL!"
	object_type_to_spawn = /obj/item/stack/tile/carpet/purplecarpet{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_geometric
	name = "FR3AKY FLOOR COVER LOOKING 4 SUITABLE MATH DORK"
	desc = "GEOMETRIC WITH COOL PATTERNS. I KNOW WHAT I'VE GOT NO LOWBALLS"
	ad_message = "IT'S MATH!"
	object_type_to_spawn = /obj/item/stack/tile/carpet/geo{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_retro
	name = "RETRO. RETRO. RETRO."
	desc = "RELIVE WHEN U WERE A LITTLE RUNT WITH THESE UGLY FUCKING CARPET.S? LIMITED TIME OFFER!"
	ad_message = "SOUL!"
	object_type_to_spawn = /obj/item/stack/tile/carpet/retro{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_retro_red
	name = "CARPET 4 OLD HOS3RS & OTHER ASSORTED PEOPLE OF BAD TASTE"
	desc = "COOL PATTERN IF U WERE BORN 5 CENTURIES AGO LOL! OWN3D N00B"
	ad_message = "SUNBURNT SOUL!"
	object_type_to_spawn = /obj/item/stack/tile/carpet/retro_red{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Carpet_happy
	name = ":D RUG"
	desc = "They say a person needs just three things to be truly happy in this world: someone to love, something to do, and something to hope for. they're wrong. they need this carpet!"
	ad_message = ":D"
	object_type_to_spawn = /obj/item/stack/tile/carpet/happy{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_Sandstone
	name = "S&STON3"
	desc = "HATERS WILL SAY IT'S JUST SAND, WHICH IT IS, BUT FUCK THEM. THEY'RE HATERS. SHOW THEM WHO'S BOSS. BUILD OUT OF SAND. BUILD A SAND CASTLE."
	ad_message = "IT'S WHAT BEACHES CRAVE"
	object_type_to_spawn = /obj/item/stack/material/sandstone{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION

/datum/maint_recycler_vendor_entry/DIY_marble
	name = "a dash of marble for my good fellow"
	desc = "hmm. yes. quite exquisite I must say. the subtle veins of calcite add to the petersonian appeal of this peice. my word, I must have it, and so should you, if I should imply!"
	ad_message = "MON3Y IN 3XC3SS!"
	object_type_to_spawn = /obj/item/stack/material/marble{amount = 20}
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CONSTRUCTION
