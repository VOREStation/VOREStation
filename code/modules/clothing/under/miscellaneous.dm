/obj/item/clothing/under/pj/red
	name = "red pj's"
	desc = "Sleepwear."
	icon_state = "red_pyjamas"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")

/obj/item/clothing/under/pj/blue
	name = "blue pj's"
	desc = "Sleepwear."
	icon_state = "blue_pyjamas"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")

/obj/item/clothing/under/captain_fly
	name = "rogue's uniform"
	desc = "For the man who doesn't care because he's still free."
	icon_state = "captain_fly"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/obj/item/clothing/under/scratch
	name = "white suit"
	desc = "A white suit, suitable for an excellent host"
	icon_state = "scratch"

/obj/item/clothing/under/sl_suit
	desc = "It's a very amish looking suit."
	name = "amish suit"
	icon_state = "sl_suit"
	rolled_sleeves = 0

/obj/item/clothing/under/waiter
	name = "waiter's outfit"
	desc = "It's a very smart uniform with a special pocket for tip."
	icon_state = "waiter"
	rolled_sleeves = 0

/obj/item/clothing/under/customs
	name = "customs uniform"
	desc = "A standard SolGov customs uniform.  Complete with epaulettes."
	icon_state = "cu_suit"

/obj/item/clothing/under/customs/khaki
	icon_state = "cu_suit_kh"

/obj/item/clothing/under/rank/mailman
	name = "mailman's jumpsuit"
	desc = "<i>'Special delivery!'</i>"
	icon_state = "mailman"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	rolled_sleeves = 0

/obj/item/clothing/under/sexyclown
	name = "sexy-clown suit"
	desc = "It makes you look HONKable!"
	icon_state = "sexyclown"
	item_state_slots = list(slot_r_hand_str = "clown", slot_l_hand_str = "clown")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	rolled_sleeves = -1 //Please never

/obj/item/clothing/under/rank/vice
	name = "vice officer's jumpsuit"
	desc = "It's the standard issue pretty-boy outfit, as seen on Holo-Vision."
	icon_state = "vice"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")

//This set of uniforms looks fairly fancy and is generally used for high-ranking NT personnel from what I've seen, so lets give them appropriate ranks.
/obj/item/clothing/under/rank/centcom
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Captain.\""
	name = "\improper Officer's Dress Uniform"
	icon_state = "officer"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")
	displays_id = 0

/obj/item/clothing/under/rank/centcom_officer
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral.\""
	name = "\improper Officer's Dress Uniform"
	icon_state = "officer"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")
	displays_id = 0

/obj/item/clothing/under/rank/centcom_captain
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral-Executive.\""
	name = "\improper Officer's Dress Uniform"
	icon_state = "centcom"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")
	displays_id = 0

/obj/item/clothing/under/ert
	name = "ERT tactical uniform"
	desc = "A short-sleeved black uniform, paired with grey digital-camo cargo pants. It looks very tactical."
	icon_state = "ert_uniform"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")

/obj/item/clothing/under/gov
	desc = "A neat proper uniform of someone on offical business. The plain, professional attire of an Internal Affairs Agent. The collar is <i>immaculately</i> starched."
	name = "Green formal uniform"
	icon_state = "greensuit"
	item_state_slots = list(slot_r_hand_str = "centcom", slot_l_hand_str = "centcom")
	rolled_sleeves = 0
	starting_accessories = list(/obj/item/clothing/accessory/darkgreen)

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	rolled_sleeves = 0

/obj/item/clothing/under/acj
	name = "administrative cybernetic jumpsuit"
	icon_state = "syndicate"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	desc = "it's a cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/under/owl
	name = "owl uniform"
	desc = "A jumpsuit with owl wings. Photorealistic owl feathers! Twooooo!"
	icon_state = "owl"

/obj/item/clothing/under/johnny
	name = "johnny~~ jumpsuit"
	desc = "Johnny~~"
	icon_state = "johnny"

/obj/item/clothing/under/color/rainbow
	name = "rainbow jumpsuit"
	desc = "A multi-colored jumpsuit."
	icon_state = "rainbow"

/obj/item/clothing/under/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon_state = "psysuit"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/under/gentlesuit
	name = "gentlemans suit"
	desc = "A silk black shirt with a white tie and a matching gray vest and slacks. Feels proper."
	icon_state = "gentlesuit"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")
	rolled_sleeves = 0

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "station administrator's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state_slots = list(slot_r_hand_str = "centcom", slot_l_hand_str = "centcom")

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "head of personnel's suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state_slots = list(slot_r_hand_str = "green", slot_l_hand_str = "green")

/obj/item/clothing/under/suit_jacket
	name = "black suit"
	desc = "A black suit and red tie. Very formal."
	icon_state = "black_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")

/obj/item/clothing/under/suit_jacket/really_black
	name = "executive suit"
	desc = "A formal black suit and red tie, intended for the station's finest."
	icon_state = "really_black_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")

/obj/item/clothing/under/suit_jacket/female
	name = "executive suit"
	desc = "A formal trouser suit for women, intended for the station's finest."
	icon_state = "black_suit_fem"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_red", slot_l_hand_str = "lawyer_red")

/obj/item/clothing/under/schoolgirl
	name = "schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state_slots = list(slot_r_hand_str = "cargo", slot_l_hand_str = "cargo")

/obj/item/clothing/under/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state_slots = list(slot_r_hand_str = "sl_suit", slot_l_hand_str = "sl_suit")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")

/obj/item/clothing/under/redcoat
	name = "redcoat uniform"
	desc = "Looks old."
	icon_state = "redcoat"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/obj/item/clothing/under/kilt
	name = "kilt"
	desc = "Includes shoes and plaid"
	icon_state = "kilt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|FEET
	rolled_sleeves = 0

/obj/item/clothing/under/sexymime
	name = "sexy mime outfit"
	desc = "The only time when you DON'T enjoy looking at someone's rack."
	icon_state = "sexymime"
	item_state_slots = list(slot_r_hand_str = "mime", slot_l_hand_str = "mime")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	rolled_sleeves = -1 //Please never

/obj/item/clothing/under/gladiator
	name = "gladiator uniform"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state_slots = list(slot_r_hand_str = "yellow", slot_l_hand_str = "yellow")
	body_parts_covered = LOWER_TORSO

/*
 * dress
 */
/obj/item/clothing/under/dress
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/dress/blacktango
	name = "black tango dress"
	desc = "Filled with Latin fire."
	icon_state = "black_tango"

/obj/item/clothing/under/dress/blacktango/alt
	name = "black tango dress"
	desc = "Filled with Latin fire."
	icon_state = "black_tango_alt"
	item_state_slots = list(slot_r_hand_str = "black_tango", slot_l_hand_str = "black_tango")

/obj/item/clothing/under/dress/stripeddress
	name = "striped dress"
	desc = "Fashion in space."
	icon_state = "striped_dress"

/obj/item/clothing/under/dress/sailordress
	name = "sailor dress"
	desc = "Formal wear for a leading lady."
	icon_state = "sailor_dress"

/obj/item/clothing/under/dress/redeveninggown
	name = "red evening gown"
	desc = "Fancy dress for space bar singers."
	icon_state = "red_evening_gown"

/obj/item/clothing/under/dress/maid
	name = "maid costume"
	desc = "Maid in China."
	icon_state = "maid"

/obj/item/clothing/under/dress/janimaid
	name = "maid uniform"
	desc = "A simple maid uniform for housekeeping."
	icon_state = "janimaid"

/obj/item/clothing/under/dress/dress_fire
	name = "flame dress"
	desc = "A small black dress with blue flames print on it."
	icon_state = "dress_fire"

/obj/item/clothing/under/dress/dress_green
	name = "green dress"
	desc = "A simple, tight fitting green dress."
	icon_state = "dress_green"

/obj/item/clothing/under/dress/dress_orange
	name = "orange dress"
	desc = "A fancy orange gown for those who like to show leg."
	icon_state = "dress_orange"

/obj/item/clothing/under/dress/dress_pink
	name = "pink dress"
	desc = "A simple, tight fitting pink dress."
	icon_state = "dress_pink"

/obj/item/clothing/under/dress/dress_yellow
	name = "yellow dress"
	desc = "A flirty, little yellow dress."
	icon_state = "dress_yellow"

/obj/item/clothing/under/dress/dress_saloon
	name = "saloon girl dress"
	desc = "A old western inspired gown for the girl who likes to drink."
	icon_state = "dress_saloon"
	item_state_slots = list(slot_r_hand_str = "dress_white", slot_l_hand_str = "dress_white")

/obj/item/clothing/under/dress/dress_cap
	name = "station administrator's dress uniform"
	desc = "Feminine fashion for the style concious Station Administrator."
	icon_state = "dress_cap"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/dress_hop
	name = "head of personnel dress uniform"
	desc = "Feminine fashion for the style concious HoP."
	icon_state = "dress_hop"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/dress_hr
	name = "human resources director uniform"
	desc = "Superior class for the nosy H.R. Director."
	icon_state = "huresource"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/*
 * wedding stuff
 */
/obj/item/clothing/under/wedding/
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/wedding/bride_orange
	name = "orange wedding dress"
	desc = "A big and puffy orange dress."
	icon_state = "bride_orange"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_purple
	name = "purple wedding dress"
	desc = "A big and puffy purple dress."
	icon_state = "bride_purple"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_blue
	name = "blue wedding dress"
	desc = "A big and puffy blue dress."
	icon_state = "bride_blue"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_red
	name = "red wedding dress"
	desc = "A big and puffy red dress."
	icon_state = "bride_red"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_white
	name = "silky wedding dress"
	desc = "A white wedding gown made from the finest silk."
	icon_state = "bride_white"
	flags_inv = HIDESHOES
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/sundress
	name = "sundress"
	desc = "Makes you want to frolic in a field of daisies."
	icon_state = "sundress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/sundress_white
	name = "white sundress"
	desc = "A white sundress decorated with purple lilies."
	icon_state = "sundress_white"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/captainformal
	name = "station administrator's formal uniform"
	desc = "A Station Administrator's formal-wear, for special occasions."
	icon_state = "captain_formal"
	item_state_slots = list(slot_r_hand_str = "lawyer_blue", slot_l_hand_str = "lawyer_blue")

/obj/item/clothing/under/hosformalmale
	name = "head of security's formal uniform"
	desc = "A male head of security's formal-wear, for special occasions."
	icon_state = "hos_formal_male"
	item_state_slots = list(slot_r_hand_str = "lawyer_red", slot_l_hand_str = "lawyer_red")

/obj/item/clothing/under/hosformalfem
	name = "head of security's formal uniform"
	desc = "A female head of security's formal-wear, for special occasions."
	icon_state = "hos_formal_fem"
	item_state_slots = list(slot_r_hand_str = "lawyer_red", slot_l_hand_str = "lawyer_red")

/obj/item/clothing/under/assistantformal
	name = "assistant's formal uniform"
	desc = "An assistant's formal-wear. Why an assistant needs formal-wear is still unknown."
	icon_state = "assistant_formal"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")

/obj/item/clothing/under/suit_jacket/charcoal
	name = "charcoal suit"
	desc = "A charcoal suit and red tie. Very professional."
	icon_state = "charcoal_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")
	starting_accessories = list(/obj/item/clothing/accessory/navy, /obj/item/clothing/accessory/charcoal_jacket)

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the station's finest."
	icon_state = "navy_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_blue", slot_l_hand_str = "lawyer_blue")
	starting_accessories = list(/obj/item/clothing/accessory/red, /obj/item/clothing/accessory/navy_jacket)

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon_state = "burgundy_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_red", slot_l_hand_str = "lawyer_red")
	starting_accessories = list(/obj/item/clothing/accessory/black, /obj/item/clothing/accessory/burgundy_jacket)

/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon_state = "checkered_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")
	starting_accessories = list(/obj/item/clothing/accessory/black, /obj/item/clothing/accessory/checkered_jacket)

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit. Smart, but casual."
	icon_state = "tan_suit"
	item_state_slots = list(slot_r_hand_str = "tan_suit", slot_l_hand_str = "tan_suit")
	starting_accessories = list(/obj/item/clothing/accessory/yellow, /obj/item/clothing/accessory/tan_jacket)

/obj/item/clothing/under/serviceoveralls
	name = "workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic"
	item_state_slots = list(slot_r_hand_str = "cargo", slot_l_hand_str = "cargo")
	rolled_sleeves = 0

/obj/item/clothing/under/cheongsam
	name = "white cheongsam"
	desc = "It is a white cheongsam dress."
	icon_state = "mai_yang"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/cheongsam/red
	name = "red cheongsam"
	desc = "It is a red cheongsam dress."
	icon_state = "cheongsam-red"

/obj/item/clothing/under/cheongsam/blue
	name = "blue cheongsam"
	desc = "It is a blue cheongsam dress."
	icon_state = "cheongsam-blue"

/obj/item/clothing/under/cheongsam/black
	name = "black cheongsam"
	desc = "It is a black cheongsam dress."
	icon_state = "cheongsam-black"

/obj/item/clothing/under/blazer
	name = "blue blazer"
	desc = "A bold but yet conservative outfit, red corduroys, navy blazer and a tie."
	icon_state = "blue_blazer"
	item_state_slots = list(slot_r_hand_str = "lawyer_blue", slot_l_hand_str = "lawyer_blue")

/obj/item/clothing/under/croptop
	name = "crop top"
	desc = "A shirt that has had the top cropped. This one is NT sponsored."
	icon_state = "croptop"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")

/obj/item/clothing/under/croptop/red
	name = "red crop top"
	desc = "A red shirt that has had the top cropped."
	icon_state = "croptop_red"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/obj/item/clothing/under/croptop/grey
	name = "grey crop top"
	desc = "A grey shirt that has had the top cropped."
	icon_state = "croptop_grey"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")

/obj/item/clothing/under/cuttop
	name = "grey cut top"
	desc = "A grey shirt that has had the top cut low."
	icon_state = "cuttop"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")

/obj/item/clothing/under/cuttop/red
	name = "red cut top"
	desc = "A red shirt that has had the top cut low."
	icon_state = "cuttop_red"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/obj/item/clothing/under/harness
	name = "gear harness"
	desc = "How... minimalist."
	icon_state = "gear_harness"
	body_parts_covered = 0

/obj/item/clothing/under/dress/white
	name = "white wedding dress"
	desc = "A fancy white dress with a blue underdress."
	icon_state = "whitedress1"
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/white2
	name = "long dress"
	desc = "A long dress."
	icon_state = "whitedress2"
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/white3
	name = "short dress"
	desc = "A short, plain dress."
	icon_state = "whitedress3"

/obj/item/clothing/under/dress/white4
	name = "long flared dress"
	desc = "A long white dress that flares out at the bottom."
	icon_state = "whitedress4"
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/darkred
	name = "fancy dark red dress"
	desc = "A short, red dress with a black belt. Fancy."
	icon_state = "darkreddress"

/*
 * swimsuit
 */
/obj/item/clothing/under/swimsuit/
	siemens_coefficient = 1
	body_parts_covered = 0

/obj/item/clothing/under/swimsuit/black
	name = "black swimsuit"
	desc = "An oldfashioned black swimsuit."
	icon_state = "swim_black"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/blue
	name = "blue swimsuit"
	desc = "An oldfashioned blue swimsuit."
	icon_state = "swim_blue"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/purple
	name = "purple swimsuit"
	desc = "An oldfashioned purple swimsuit."
	icon_state = "swim_purp"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/green
	name = "green swimsuit"
	desc = "An oldfashioned green swimsuit."
	icon_state = "swim_green"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/red
	name = "red swimsuit"
	desc = "An oldfashioned red swimsuit."
	icon_state = "swim_red"
	siemens_coefficient = 1

/*
 * pyjamas
 */
/obj/item/clothing/under/bluepyjamas
	name = "blue pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "blue_pyjamas"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/under/redpyjamas
	name = "red pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "red_pyjamas"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/under/stripper
	body_parts_covered = 0

/obj/item/clothing/under/stripper/stripper_pink
	name = "pink swimsuit"
	desc = "A rather skimpy pink swimsuit."
	icon_state = "stripper_p_under"
	siemens_coefficient = 1

/obj/item/clothing/under/stripper/stripper_green
	name = "green swimsuit"
	desc = "A rather skimpy green swimsuit."
	icon_state = "stripper_g_under"
	siemens_coefficient = 1

/obj/item/clothing/under/stripper/mankini
	name = "mankini"
	desc = "No honest man would wear this abomination"
	icon_state = "mankini"
	siemens_coefficient = 1