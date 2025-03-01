/obj/item/clothing/under/gimmick //used to fix an error
	name = "gimmick jumpsuit"
	desc = "Something about this jumpsuit feels... off..."
	icon_state = "grey"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")

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

/obj/item/clothing/under/scratch/skirt
	name = "white skirt suit"
	icon_state = "scratch_skirt"
	item_state_slots = list(slot_r_hand_str = "scratch", slot_l_hand_str = "scratch")

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
	desc = span_italics("'Special delivery!'")
	icon_state = "mailman"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	rolled_sleeves = 0

/obj/item/clothing/under/sexyclown
	name = "sexy-clown suit"
	desc = "It makes you look HONKable!"
	icon_state = "sexyclown"
	item_state_slots = list(slot_r_hand_str = "clown", slot_l_hand_str = "clown")
	body_parts_covered = CHEST
	rolled_sleeves = -1 //Please never

/obj/item/clothing/under/clown //i'm only putting it here to make subtypes of it, since the original suit is under/rank/clown
	name = "clown suit"
	desc = span_italics("<font face='comic sans ms'>Honk!</font>")
	icon_state = "clown"
	rolled_sleeves = -1

/obj/item/clothing/under/clown/green
	name = "green clown suit"
	icon_state = "greenclown"

/obj/item/clothing/under/clown/purple
	name = "purple clown suit"
	icon_state = "purpleclown"

/obj/item/clothing/under/clown/yellow
	name = "yellow clown suit"
	icon_state = "yellowclown"

/obj/item/clothing/under/clown/orange
	name = "orange clown suit"
	icon_state = "orangeclown"

/obj/item/clothing/under/clown/blue
	name = "blue clown suit"
	icon_state = "blueclown"

/obj/item/clothing/under/clown/rainbow
	name = "rainbow clown suit"
	icon_state = "rainbowclown"

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

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = CHEST|LEGS|FEET|ARMS|HANDS
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
	body_parts_covered = CHEST|LEGS|FEET|ARMS|HANDS
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
	body_parts_covered = CHEST|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/under/gentlesuit
	name = "gentlemans suit"
	desc = "A silk black shirt with matching gray slacks. Feels proper."
	icon_state = "gentlesuit"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")
	rolled_sleeves = 0
	starting_accessories = list(/obj/item/clothing/accessory/tie/white, /obj/item/clothing/accessory/wcoat/gentleman)

/obj/item/clothing/under/gentlesuit/skirt
	name = "lady's suit"
	desc = "A silk black blouse with a matching gray skirt. Feels proper."
	icon_state = "gentlesuit_skirt"


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

/obj/item/clothing/under/suit_jacket/really_black/skirt
	name = "executive skirt suit"
	desc = "A formal black suit and red necktie, intended for the station's finest."
	icon_state = "really_black_suit_skirt"

/obj/item/clothing/under/suit_jacket/female
	name = "female executive suit"
	desc = "A formal trouser suit for women, intended for the station's finest."
	icon_state = "black_suit_fem"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")

/obj/item/clothing/under/suit_jacket/female/skirt
	name = "executive skirt"
	desc = "A formal suit skirt  for women, intended for the station's finest."
	body_parts_covered = CHEST|ARMS
	icon_state = "black_suit_fem"
	item_state = "black_formal_skirt"

/obj/item/clothing/under/schoolgirl
	name = "schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	body_parts_covered = CHEST

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state_slots = list(slot_r_hand_str = "cargo", slot_l_hand_str = "cargo")

/obj/item/clothing/under/overalls/sleek
	name = "sleek overalls"
	desc = "A set of modern pleather reinforced overalls."
	icon_state = "overalls_sleek"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/overalls/service
	name = "workman overalls"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic_over"
	item_state_slots = list(slot_r_hand_str = "cargo", slot_l_hand_str = "cargo")
	rolled_sleeves = 0

/obj/item/clothing/under/overalls/frontier
	name = "frontier overalls"
	desc = "Simple denim overalls. A popular style among frontier colonists, when paired with a flannel."
	icon_state = "frontier_over"
	worn_state = "frontier_over"

/obj/item/clothing/under/overalls/rustler
	name = "rustler overalls"
	desc = "A rugged pair of overalls for rustling cattle out on the frontier."
	icon_state = "rustler_over"
	worn_state = "rustler_over"

/obj/item/clothing/under/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state_slots = list(slot_r_hand_str = "sl_suit", slot_l_hand_str = "sl_suit")
	body_parts_covered = CHEST|LEGS

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
	body_parts_covered = CHEST|FEET
	rolled_sleeves = 0

/obj/item/clothing/under/sexymime
	name = "sexy mime outfit"
	desc = "The only time when you DON'T enjoy looking at someone's rack."
	icon_state = "sexymime"
	item_state_slots = list(slot_r_hand_str = "mime", slot_l_hand_str = "mime")
	body_parts_covered = CHEST
	rolled_sleeves = -1 //Please never

/obj/item/clothing/under/sexymime/dress //another style of dress closer to the jumpsuit than the sexy outfit
	name = "mime's jumpskirt"
	desc = "It's not very colourful."
	icon_state = "mimedress"

/obj/item/clothing/under/gladiator
	name = "gladiator uniform"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state_slots = list(slot_r_hand_str = "yellow", slot_l_hand_str = "yellow")
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/ascetic
	name = "plain ascetic garb"
	desc = "Popular with freshly grown vatborn and new age cultists alike."
	icon_state = "ascetic"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")

/*
 * Dress Stuff
 */

/obj/item/clothing/under/dress
	body_parts_covered = CHEST

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

/obj/item/clothing/under/dress/maid/janitor
	name = "maid uniform"
	desc = "A simple maid uniform for housekeeping."
	icon_state = "janimaid"

/obj/item/clothing/under/dress/maid/sexy
	name = "sexy maid costume"
	desc = "You must be a bit risque teasing all of them in a maid uniform!"
	icon_state = "sexymaid"

/obj/item/clothing/under/dress/maid/under_maid
	name = "modern maid costume"
	desc = "You're going to use this for housekeeping, right?"
	icon_state = "under_maid"

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
	name = "site manager's dress uniform"
	desc = "Feminine fashion for the style conscious " + JOB_SITE_MANAGER + "."
	icon_state = "dress_cap"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/under/dress/dress_hop
	name = "head of personnel dress uniform"
	desc = "Feminine fashion for the style conscious HoP."
	icon_state = "dress_hop"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/under/dress/dress_hr
	name = "human resources director uniform"
	desc = "Superior class for the nosy H.R. Director."
	icon_state = "huresource"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/under/dress/black_corset
	name = "black corset"
	desc = "A black corset and skirt for those fancy nights out."
	icon_state = "black_corset"
	body_parts_covered = CHEST

/obj/item/clothing/under/dress/flower_dress
	name = "flower dress"
	desc = "A beautiful dress with a skirt of flowers."
	icon_state = "flower_dress"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/red_swept_dress
	name = "red swept dress"
	desc = "A red dress that sweeps to the side."
	icon_state = "red_swept_dress"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/flamenco
	name = "flamenco dress"
	desc = "A Mexican flamenco dress."
	icon_state = "flamenco"

/obj/item/clothing/under/dress/westernbustle
	name = "western bustle"
	desc = "A western bustle dress from Earth's late 1800's."
	icon_state = "westernbustle"

/obj/item/clothing/under/dress/sari
	name = "red sari"
	desc = "A colorful traditional dress originating from India."
	icon_state = "sari_red"
	item_state_slots = list(slot_r_hand_str = "darkreddress", slot_l_hand_str = "darkreddress")

/obj/item/clothing/under/dress/sari/green
	name = "green sari"
	icon_state = "sari_green"
	item_state_slots = list(slot_r_hand_str = "dress_green", slot_l_hand_str = "dress_green")

/obj/item/clothing/under/dress/lilacdress
	name = "lilac dress"
	desc = "A simple black dress adorned in fake purple lilacs."
	icon_state = "lilacdress"

/obj/item/clothing/under/dress/white
	name = "white wedding dress"
	desc = "A fancy white dress with a blue underdress."
	icon_state = "whitedress1"
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/white2
	name = "long dress"
	desc = "A long dress."
	icon_state = "whitedress2"
	addblends = "whitedress2_a"
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/white3
	name = "short dress"
	desc = "A short, plain dress."
	icon_state = "whitedress3"
	addblends = "whitedress3_a"

/obj/item/clothing/under/dress/white4
	name = "long flared dress"
	desc = "A long white dress that flares out at the bottom."
	icon_state = "whitedress4"
	addblends = "whitedress4_a"
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/darkred
	name = "fancy dark red dress"
	desc = "A short, red dress with a black belt. Fancy."
	icon_state = "darkreddress"

/obj/item/clothing/under/dress/polka
	name = "polka dot dress"
	desc = "A sleeveless, cream colored dress with red polka dots."
	icon_state = "polka"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/twistfront
	name = "twistfront crop dress"
	desc = "A black skirt and red twistfront croptop. Fancy!"
	icon_state = "twistfront"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/cropdress
	name = "crop dress"
	desc = "A red skirt and longsleeved button-up crop top."
	icon_state = "cropdress"

/obj/item/clothing/under/dress/vneck
	name = "v-neck dress"
	desc = "A black v-neck dress with an exaggerated neckline covered in a sheer mesh."
	icon_state = "vneckdress"

/obj/item/clothing/under/dress/bluedress
	name = "blue dress"
	desc = "A plain blue dress with a white belt."
	icon_state = "bluedress"

/obj/item/clothing/under/dress/wench
	name = "wench's dress"
	desc = "A white dress styled like a Ye Old Barmaid. Saucy!"
	icon_state = "wench"

/obj/item/clothing/under/dress/littleblackdress
	name = "little black dress"
	desc = "A little strapless black dress with a red ribbon and flower accessory."
	icon_state = "littleblackdress"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/pinktutu
	name = "pink tutu"
	desc = "A black leotard with a pink mesh tutu. Perfect for ballet practice."
	icon_state = "pinktutu"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/festivedress
	name = "festive dress"
	desc = "A red and white dress themed after some winter holidays. Tastefully festive!"
	icon_state = "festivedress"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/revealingdress
	name = "revealing dress"
	desc = "A very revealing black and blue dress. Is this work appropriate?"
	icon_state = "revealingdress"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/gothic
	name = "gothic dress"
	desc = "A black dress with a sheer mesh over it, tastefully old school goth."
	icon_state = "gothic"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/formalred
	name = "formal red dress"
	desc = "A very formal red dress, for those fancy galas."
	icon_state = "formalred"
	flags_inv = HIDESHOES

/obj/item/clothing/under/dress/pentagram
	name = "pentagram dress"
	desc = "A black dress with straps over the chest in the shape of a pentagram."
	icon_state = "pentagram"

/obj/item/clothing/under/dress/yellowswoop
	name = "yellow swooped dress"
	desc = "A yellow dress that swoops to the side."
	icon_state = "yellowswoop"

/obj/item/clothing/under/dress/countess
	name = "countess dress"
	desc = "A red and black dress fit for a countess."
	icon_state = "countess"

/obj/item/clothing/under/dress/verglasdress
    name = "verglas dress"
    desc = "The modern twist on a forgotten pattern, the Verglas style utilizes comfortable velvet and silver white satin to create an otherworldly effect evocative of winter, or the void."
    icon_state = "verglas_dress"

/obj/item/clothing/under/dress/alpine
	name = "alpine dress"
	desc = "A green and white dress that makes you want to yodel."
	icon_state = "corsetdress"

/obj/item/clothing/under/dress/goldwrap
	name = "golden dress"
	desc = "A dress so ostentatious that you feel poorer just looking at it."
	icon_state = "golddress"

/obj/item/clothing/under/dress/golddress
	name = "golden wrap"
	desc = "An outfit so ostentatious that you feel poorer just looking at it."
	icon_state = "goldwrap"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/hightrousers
	name = "high-waisted trousers"
	desc = "A waistline this high is just made for ripping bodices, swashing buckles, or - just occasionally - sucking blood."
	icon_state = "gayvampire"

/obj/item/clothing/under/dress/singer
	name = "blue singer dress"
	desc = "Just looking at this makes you want to sing."
	icon_state = "bsing"

/obj/item/clothing/under/dress/singer/yellow
	name = "yellow singer dress"
	desc = "Just looking at this makes you want to sing."
	icon_state = "ysing"

/obj/item/clothing/under/dress/tabard
	name = "white tabard-dress"
	desc = "A gold-trimmed white tabard-dress with a large V-shaped boob window. For when you want to show off your hips and look classy at the same time."
	icon_state = "white_tabard"

/obj/item/clothing/under/dress/tabard/black
	name = "black tabard-dress"
	desc = "A gold-trimmed black tabard-dress with a large circular boob window. For when you want to show off your hips and look classy at the same time."
	icon_state = "black_tabard"

/*
 * Wedding Stuff
 */

/obj/item/clothing/under/wedding
	body_parts_covered = CHEST|LEGS

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
	body_parts_covered = CHEST

/obj/item/clothing/under/wedding/floofdress
	name = "floofy dress"
	desc = "A lovely floofed out dress for formal occasions. Comes in many colors!"
	icon_state = "floofdress"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/whitegown
	name = "white gown"
	desc = "A elegant white gown with accents of sheer mesh."
	icon_state = "whitegown"

/*
 * Uniforms and such
 */

/obj/item/clothing/under/sundress
	name = "sundress"
	desc = "Makes you want to frolic in a field of daisies."
	icon_state = "sundress"
	body_parts_covered = CHEST

/obj/item/clothing/under/sundress_white
	name = "flowery white sundress"
	desc = "A white sundress decorated with purple lilies."
	icon_state = "sundress_white"
	body_parts_covered = CHEST

/obj/item/clothing/under/dress/sundress_pink
	name = "pink stripied sundress"
	desc = "A cute pink sundress."
	icon_state = "pinksun"
	body_parts_covered = CHEST

/obj/item/clothing/under/dress/sundress_white
	name = "white sundress"
	desc = "A white sundress, it's short."
	icon_state = "whitesun"
	body_parts_covered = CHEST

/obj/item/clothing/under/dress/sundress_pinkbow
	name = "bowed pink sundress"
	desc = "A cute pink sundress with a bow."
	icon_state = "bowsun"
	body_parts_covered = CHEST

/obj/item/clothing/under/dress/sundress_blue
	name = "long blue sundress"
	desc = "A long blue sun dress with white frills towards the bottom."
	icon_state = "bluesun"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/dress/sundress_pinkshort
	name = "short pink sundress"
	desc = "A very short pink sundress, it's more like a chemise."
	icon_state = "shortpink"
	body_parts_covered = CHEST

/obj/item/clothing/under/dress/twopiece
	name = "two-piece dress"
	desc = "A fancy two-piece dress, the pieces are sewn together."
	icon_state = "twopiece"
	body_parts_covered = CHEST

/obj/item/clothing/under/dress/gothic2
	name = "lacey gothic dress"
	desc = "An elegant gothic dress with lace decorations."
	icon_state = "gothic2"

/obj/item/clothing/under/captainformal
	name = "site manager's formal uniform"
	desc = "A " + JOB_SITE_MANAGER + "'s formal-wear, for special occasions."
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
	starting_accessories = list(/obj/item/clothing/accessory/tie/navy, /obj/item/clothing/accessory/jacket/charcoal)

/obj/item/clothing/under/suit_jacket/charcoal/skirt
	name = "charcoal skirt"
	icon_state = "charcoal_suit_skirt"

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the station's finest."
	icon_state = "navy_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_blue", slot_l_hand_str = "lawyer_blue")
	starting_accessories = list(/obj/item/clothing/accessory/tie/red, /obj/item/clothing/accessory/jacket/navy)

/obj/item/clothing/under/suit_jacket/navy/skirt
	name = "navy skirt"
	icon_state = "navy_suit_skirt"

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon_state = "burgundy_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_red", slot_l_hand_str = "lawyer_red")
	starting_accessories = list(/obj/item/clothing/accessory/tie/black, /obj/item/clothing/accessory/jacket/burgundy)

/obj/item/clothing/under/suit_jacket/burgundy/skirt
	name = "burgundy skirt"
	icon_state = "burgundy_suit_skirt"

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_red", slot_l_hand_str = "lawyer_red")
	starting_accessories = list(/obj/item/clothing/accessory/tie/navy, /obj/item/clothing/accessory/jacket/red)

/obj/item/clothing/under/suit_jacket/red/skirt
	name = "red skirt"
	icon_state = "red_suit_skirt"

/obj/item/clothing/under/suit_jacket/teal
	name = "teal suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state_slots = list(slot_r_hand_str = "green", slot_l_hand_str = "green")
	starting_accessories = list(/obj/item/clothing/accessory/tie/yellow, /obj/item/clothing/accessory/jacket/teal)

/obj/item/clothing/under/suit_jacket/teal/skirt
	name = "teal skirt suit"
	icon_state = "teal_suit_skirt"

/obj/item/clothing/under/suit_jacket/green
	name = "green suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state_slots = list(slot_r_hand_str = "centcom", slot_l_hand_str = "centcom")
	starting_accessories = list(/obj/item/clothing/accessory/tie/yellow, /obj/item/clothing/accessory/jacket/green)

/obj/item/clothing/under/gov
	name = "green formal uniform"
	desc = "A neat proper uniform of someone on offical business. The collar is " + span_italics("immaculately") + " starched."
	icon_state = "greensuit"
	item_state_slots = list(slot_r_hand_str = "centcom", slot_l_hand_str = "centcom")
	starting_accessories = list(/obj/item/clothing/accessory/tie/darkgreen)
	rolled_sleeves = 0

/obj/item/clothing/under/gov/skirt
	name = "green formal skirt"
	desc = "A neat proper uniform of someone on offical business. The top button is sewn shut."
	icon_state = "greensuit_skirt"

/obj/item/clothing/under/suit_jacket/green/skirt
	name = "green skirt suit"
	icon_state = "green_suit_skirt"

/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon_state = "checkered_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")
	starting_accessories = list(/obj/item/clothing/accessory/tie/black, /obj/item/clothing/accessory/jacket/checkered)

/obj/item/clothing/under/suit_jacket/checkered/skirt
	name = "checkered skirt"
	icon_state = "checkered_suit_skirt"

/obj/item/clothing/under/suit_jacket/gambler
	name = "gambling suit"
	desc = "The suit of a gambler. Lady luck be with you."
	icon_state = "gambler_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")
	starting_accessories = list(/obj/item/clothing/accessory/tie/black, /obj/item/clothing/accessory/jacket/gambler)

/obj/item/clothing/under/suit_jacket/extravagant
	name = "extravagant suit"
	desc = "An extravagant suit. Perfect for being over dramatic."
	icon_state = "extravagant_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")
	starting_accessories = list(/obj/item/clothing/accessory/jacket/extravagant)

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit. Smart, but casual."
	icon_state = "tan_suit"
	item_state_slots = list(slot_r_hand_str = "tan_suit", slot_l_hand_str = "tan_suit")
	starting_accessories = list(/obj/item/clothing/accessory/tie/yellow, /obj/item/clothing/accessory/jacket)

/obj/item/clothing/under/suit_jacket/tan/skirt
	name = "tan skirt"
	icon_state = "tan_suit_skirt"

/obj/item/clothing/under/cheongsam
	name = "white cheongsam"
	desc = "It is a white cheongsam dress."
	icon_state = "cheongsam-white"
	body_parts_covered = CHEST|LEGS

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

/obj/item/clothing/under/cheongsam/darkred
	name = "dark red cheongsam"
	desc = "It is a dark red cheongsam dress."
	icon_state = "cheongsam-darkred"

/obj/item/clothing/under/cheongsam/green
	name = "green cheongsam"
	desc = "It is a green cheongsam dress."
	icon_state = "cheongsam-green"

/obj/item/clothing/under/cheongsam/purple
	name = "purple cheongsam"
	desc = "It is a purple cheongsam dress."
	icon_state = "cheongsam-purple"

/obj/item/clothing/under/cheongsam/darkblue
	name = "dark blue cheongsam"
	desc = "It is a dark blue cheongsam dress."
	icon_state = "cheongsam-darkblue"

/obj/item/clothing/under/blazer
	name = "blue blazer"
	desc = "A bold but yet conservative outfit, red corduroys, navy blazer and a tie."
	icon_state = "blue_blazer"
	item_state_slots = list(slot_r_hand_str = "lawyer_blue", slot_l_hand_str = "lawyer_blue")

/obj/item/clothing/under/blazer/skirt
	name = "ladies blue blazer"
	desc = "A bold but yet conservative outfit, a red pencil skirt and a navy blazer."
	icon_state = "blue_blazer_skirt"

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

/obj/item/clothing/under/haltertop
	name = "halter top"
	desc = "Jean shorts and a black halter top. Perfect for casual Fridays!"
	icon_state = "haltertop"

/obj/item/clothing/under/tanktop
	name = "tank top"
	desc = "The most versatile top ever created."
	icon_state = "tanktop"

/obj/item/clothing/under/rippedpunk
	name = "ripped punk jeans"
	desc = "Black ripped jeans and a fishnet top. How punk."
	icon_state = "rippedpunk"

/obj/item/clothing/under/greenasym
	name = "green asymmetrical jumpsuit"
	desc = "A green futuristic uniform with asymmetrical pants. Trendy!"
	icon_state = "greenasym"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/cyberpunkharness
	name = "cyberpunk strapped harness"
	desc = "A cyberpunk styled harness and pants. Perfect for your dystopian future."
	icon_state = "cyberhell"
	body_parts_covered = CHEST|LEGS

/obj/item/clothing/under/blackngold
	name = "black and gold gown"
	desc = "A black and gold gown. You get the impression this is typically worn for religious purposes."
	icon_state = "blackngold"

/obj/item/clothing/under/sheerblue
	name = "sheer blue dress"
	desc = "An entirely sheer blue dress. Best worn with something underneath!"
	icon_state = "sheerblue"

/obj/item/clothing/under/disheveled
	name = "disheveled suit"
	desc = "What might pass as well maintained formal attire. If you're blind."
	icon_state = "disheveled"

/obj/item/clothing/under/flower_skirt
	name = "flower skirt"
	desc = "A flowery skirt that comes in a variety of colors."
	icon_state = "flowerskirt"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/fashionminiskirt
	name = "fashionable miniskirt"
	desc = "An impractically short miniskirt allegedly making waves through the local fashion scene."
	icon_state = "miniskirt_fashion"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/retrosweater
	name = "retro sweater"
	desc = "A rugged cableknit sweater and leather pants, fit for a dashing space adventurer."
	icon_state = "retro_sweater"

/obj/item/clothing/under/wednesday
	name = "cropped sweater skirt"
	desc = "A cropped green sweater and matching miniskirt."
	icon_state = "wednesday"

/*
 * Swimsuit
 */

/obj/item/clothing/under/swimsuit/
	siemens_coefficient = 1
	body_parts_covered = 0

/obj/item/clothing/under/swimsuit/black
	name = "black swimsuit"
	desc = "An oldfashioned black swimsuit."
	icon_state = "swim_black"

/obj/item/clothing/under/swimsuit/blue
	name = "blue swimsuit"
	desc = "An oldfashioned blue swimsuit."
	icon_state = "swim_blue"

/obj/item/clothing/under/swimsuit/purple
	name = "purple swimsuit"
	desc = "An oldfashioned purple swimsuit."
	icon_state = "swim_purp"

/obj/item/clothing/under/swimsuit/green
	name = "green swimsuit"
	desc = "An oldfashioned green swimsuit."
	icon_state = "swim_green"

/obj/item/clothing/under/swimsuit/red
	name = "red swimsuit"
	desc = "An oldfashioned red swimsuit."
	icon_state = "swim_red"

/obj/item/clothing/under/swimsuit/striped
	name = "striped swimsuit"
	desc = "A more revealing striped swimsuit."
	icon_state = "swim_striped"

/obj/item/clothing/under/swimsuit/white
	name = "white swimsuit"
	desc = "A classic one piece."
	icon_state = "swim_white"

/obj/item/clothing/under/swimsuit/earth
	name = "earthen swimsuit"
	desc = "A design more popular on Earth these days."
	icon_state = "swim_earth"

/obj/item/clothing/under/swimsuit/stripper/stripper_pink
	name = "pink swimsuit"
	desc = "A rather skimpy pink swimsuit."
	icon_state = "stripper_p"

/obj/item/clothing/under/swimsuit/stripper/stripper_green
	name = "green swimsuit"
	desc = "A rather skimpy green swimsuit."
	icon_state = "stripper_g"

/obj/item/clothing/under/swimsuit/stripper/mankini
	name = "mankini"
	desc = "No honest man would wear this abomination"
	icon_state = "mankini"

/obj/item/clothing/under/swimsuit/cowbikini
	name = "cow print bikini"
	desc = "A rather skimpy cow patterned swimsuit."
	icon_state = "swim_cow"

/obj/item/clothing/under/swimsuit/highclass
    name = "high class swimsuit"
    desc = "An elegant swimsuit with a white bikini top and black bikini bottom. Thin black silk drapes down the back and goes to the upper thighs, and authentic gold rings hold the top together at the bust and back."
    icon_state = "swim_highclass"

/obj/item/clothing/under/swimsuit/risque
    name = "risque swimsuit"
    desc = "This fits a bit too snug in all the right places. Comes with a collar, for inscrutable reasons."
    icon_state = "swim_risque"

/obj/item/clothing/under/swimsuit/streamlined
    name = "streamlined swimsuit"
    desc = "An all white one-piece that maintains modesty without sacrificing class."
    icon_state = "swim_stream"

/*
 * Pyjamas
 */

/obj/item/clothing/under/bluepyjamas
	name = "blue pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "blue_pyjamas"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")
	body_parts_covered = CHEST|ARMS|LEGS

/obj/item/clothing/under/redpyjamas
	name = "red pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "red_pyjamas"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	body_parts_covered = CHEST|ARMS|LEGS

/obj/item/clothing/under/rank/psych/turtleneck/sweater
	desc = "A warm looking sweater and a pair of dark blue slacks."
	name = "sweater"
	icon_state = "turtleneck"
	worn_state = "turtleneck"

/obj/item/clothing/under/medigown
	name = "medical gown"
	desc = "A flimsy examination gown, the back ties never close."
	icon_state = "medicalgown"
	worn_state = "medicalgown"
	body_parts_covered = CHEST

/obj/item/clothing/under/bathrobe
	name = "bathrobe"
	desc = "A fluffy robe to keep you from showing off to the world."
	icon_state = "bathrobe"
	worn_state = "bathrobe"

/obj/item/clothing/under/explorer
	desc = "A green uniform for operating in hazardous environments."
	name = "away team's jumpsuit"
	icon_state = "explorer"

/obj/item/clothing/under/explorer/armored
	desc = "A green uniform for operating in hazardous environments. This one looks like it's been modified."
	armor = list(melee = 10, bullet = 10, laser = 10,energy = 10, bomb = 10, bio = 10, rad = 30)
	armorsoak = list(melee = 5, bullet = 5, laser = 5,energy = 5, bomb = 5, bio = 5, rad = 0)

/obj/item/clothing/under/cohesion
	name = "black cohesion suit"
	desc = "A plain black cohesion suit intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit"
	rolled_sleeves = -1 // defeats the purpose!!!

/obj/item/clothing/under/cohesion/striped
	name = "red striped cohesion suit"
	desc = "A black cohesion suit with red stripes intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_striped"

/obj/item/clothing/under/cohesion/decal
	name = "purple decaled cohesion suit"
	desc = "A white cohesion suit with purple decals intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_decal"

/obj/item/clothing/under/cohesion/pattern
	name = "blue patterned cohesion suit"
	desc = "A white cohesion suit with blue patterns intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_pattern"

/obj/item/clothing/under/cohesion/hazard
	name = "hazard cohesion suit"
	desc = "An orange cohesion suit with yellow hazard stripes intended to assist Prometheans in maintaining their form and prevent direct skin exposure."
	icon_state = "cohesionsuit_hazard"

/obj/item/clothing/under/vampirehunter
	name = "18th century outfit"
	desc = "A flashy, if rather stiff set of ancient-styled slacks and tabard. The unyielding nature of the clothes often make one walk stiffly, but with divine purpose."
	icon_state = "belmont"

//Ranger uniforms
//On-mob sprites go in icons\mob\uniform.dmi with the format "white_ranger_uniform_s" - with 'white' replaced with green, cyan, etc... of course! Note the _s - this is not optional.
//Item sprites go in icons\obj\clothing\ranger.dmi with the format "white_ranger_uniform"
/obj/item/clothing/under/color/ranger
	var/unicolor = "white"
	name = "ranger uniform"
	desc = "Made from a space-proof fibre and tight fitting, this uniform usually gives the agile Rangers all kinds of protection while not inhibiting their movement. \
	This costume is instead made from genuine cotton fibre and is based on the season three uniform."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "white_ranger_uniform"
	rolled_down = 0
	rolled_sleeves = 0

/obj/item/clothing/under/color/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_uniform") //allows for custom items
		name = "[unicolor] ranger uniform"
		icon_state = "[unicolor]_ranger_uniform"

/obj/item/clothing/under/color/ranger/black
	unicolor = "black"

/obj/item/clothing/under/color/ranger/pink
	unicolor = "pink"

/obj/item/clothing/under/color/ranger/green
	unicolor = "green"

/obj/item/clothing/under/color/ranger/cyan
	unicolor = "cyan"

/obj/item/clothing/under/color/ranger/orange
	unicolor = "orange"

/obj/item/clothing/under/color/ranger/yellow
	unicolor = "yellow"

/obj/item/clothing/under/boater
	name = "boater outfit"
	desc = "A classic outfit for those with a nautical inclination."
	icon_state = "boater"
	worn_state = "boater"

/obj/item/clothing/under/tourist_1
	name = "summer outfit"
	desc = "The perfect outfit to wear out of town."
	icon_state = "tourist_1"
	worn_state = "tourist_1"

/obj/item/clothing/under/tourist_2
	name = "summer outfit"
	desc = "The perfect outfit to wear out of town."
	icon_state = "tourist_2"
	worn_state = "tourist_2"

/obj/item/clothing/under/relaxwear_1
	name = "casual outfit"
	desc = "Something casual to wear out on the town. Pairs well with the holiday season."
	icon_state = "relaxwear_1"
	worn_state = "relaxwear_1"
	starting_accessories = list(/obj/item/clothing/accessory/wcoat/swvest/red)

/obj/item/clothing/under/relaxwear_2
	name = "relaxing outfit"
	desc = "A comfy looking set of clothes to relax in, even if the style is a bit dated."
	icon_state = "relaxwear_2"
	worn_state = "relaxwear_2"
	starting_accessories = list(/obj/item/clothing/accessory/wcoat/swvest/green)

/obj/item/clothing/under/serviceoveralls
	name = "workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic"
	item_state_slots = list(slot_r_hand_str = "cargo", slot_l_hand_str = "cargo")
	rolled_sleeves = 0

/obj/item/clothing/under/frontier
	name = "frontier clothes"
	desc = "A rugged flannel shirt and denim overalls. A popular style among frontier colonists."
	icon_state = "frontier"
	worn_state = "frontier"

/obj/item/clothing/under/rustler
	name = "rustler outfit"
	desc = "A rugged outfit for rustling cattle out on the frontier."
	icon_state = "rustler"
	worn_state = "rustler"

/obj/item/clothing/under/cowboy
	name = "cowboy clothes"
	desc = "Some rugged clothes for hard labor out on the farm."
	icon_state = "cowboy"
	worn_state = "cowboy"

/obj/item/clothing/under/cowboy/tan
	name = "tan cowboy clothes"
	icon_state = "cowboy_tan"
	worn_state = "cowboy_tan"

/obj/item/clothing/under/cowboy/brown
	name = "brown cowboy clothes"
	icon_state = "cowboy_brown"
	worn_state = "cowboy_brown"

/obj/item/clothing/under/cowboy/grey
	name = "grey cowboy clothes"
	icon_state = "cowboy_grey"
	worn_state = "cowboy_grey"

/obj/item/clothing/under/curator
	name = "curator uniform"
	desc = "A rugged uniform suitable for treasure hunting."
	icon_state = "curator"
	worn_state = "curator"

/*
 * 80s
 */

/obj/item/clothing/under/tropical
	name = "black tropical oufit"
	desc = "A classic themed outfit. This one makes you feel like an animal."
	icon_state = "animalstyle"
	worn_state = "animalstyle"
	starting_accessories = list(/obj/item/clothing/accessory/tropical)

/obj/item/clothing/under/tropical/green
	name = "puke-green tropical oufit"
	desc = "A classic themed outfit. This one makes you look like puke."
	icon_state = "tropicopuke"
	worn_state = "tropicopuke"
	starting_accessories = list(/obj/item/clothing/accessory/tropical/green)

/obj/item/clothing/under/tropical/pink
	name = "pink tropical oufit"
	desc = "A classic themed outfit. This one makes you feel nostalgic."
	icon_state = "3005vintage"
	worn_state = "3005vintage"
	starting_accessories = list(/obj/item/clothing/accessory/tropical/pink)

/obj/item/clothing/under/tropical/blue
	name = "pink tropical oufit"
	desc = "A classic themed outfit. This one makes you feel out of touch."
	icon_state = "miamivice"
	worn_state = "miamivice"
	starting_accessories = list(/obj/item/clothing/accessory/tropical/blue)

/*
 * Modern
 */

/obj/item/clothing/under/moderncoat
	name = "modern wrapped coat (pants)"
	desc = "The cutting edge of fashion."
	icon_state = "mod_coat_pants"
	worn_state = "mod_coat_pants"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	body_parts_covered = CHEST|LEGS
	starting_accessories = list(/obj/item/clothing/accessory/jacket/modwrap)

/obj/item/clothing/under/modjump
	name = "modern jumpsuit"
	desc = "A stylish jumpsuit of modern culture."
	icon_state = "mod_jump"
	worn_state = "mod_jump"
	item_state_slots = list(slot_r_hand_str = "orange", slot_l_hand_str = "orange")

/obj/item/clothing/under/modjump2
	name = "modern outfit"
	desc = "A stylish outfit of modern culture."
	icon_state = "mod_jump2"
	worn_state = "mod_jump2"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")

/obj/item/clothing/under/modjump3
	name = "cyber jumpsuit"
	desc = "A cool cyberpunk styled jumpsuit. The lights on the back glitched out and don't work."
	icon_state = "cyber"
	worn_state = "cyber"
	item_state_slots = list(slot_r_hand_str = "grey", slot_l_hand_str = "grey")

/*
 * Corporate Uniforms
 */

/obj/item/clothing/under/mbill
	name = "\improper Major Bill's uniform"
	desc = "A uniform belonging to Major Bill's Transportation, a shipping megacorporation."
	icon_state = "mbill"
	worn_state = "mbill"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/major_bills)

/obj/item/clothing/under/mbill_flight
	name = "\improper Major Bill's flightsuit"
	desc = "A flightsuit belonging to Major Bill's Transportation, a shipping megacorporation."
	icon_state = "mbill_flight"
	worn_state = "mbill_flight"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/major_bills)
	starting_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1)
	rolled_sleeves = 0

/obj/item/clothing/under/corp/aether
	name = "\improper Aether jumpsuit"
	desc = "A jumpsuit belonging to Aether Atmospherics and Recycling, a Trans-Stellar that supplies recycling and atmospheric systems to colonies."
	icon_state = "aether"
	worn_state = "aether"

/obj/item/clothing/under/corp/pcrc
	name = "\improper PCRC uniform"
	desc = "A uniform belonging to Proxima Centauri Risk Control, a private security firm."
	icon_state = "pcrc"
	item_state = "jensensuit"
	worn_state = "pcrc"

/obj/item/clothing/under/corp/centauri
	name = "\improper Centauri Provisions jumpsuit"
	desc = "A jumpsuit belonging to Centauri Provisions, a Trans-Stellar best known for its food and drink products."
	icon_state = "centauri"
	worn_state = "centauri"

/obj/item/clothing/under/corp/grayson
	name = "\improper Grayson overalls"
	desc = "A set of overalls belonging to Grayson Manufactories, a mining Trans-Stellar."
	icon_state = "grayson_mech"
	worn_state = "grayson_mech"

/obj/item/clothing/under/corp/grayson_jump
	name = "\improper Grayson jumpsuit"
	desc = "A jumpsuit belonging to Grayson Manufactories, a mining Trans-Stellar."
	icon_state = "grayson"
	worn_state = "grayson"
	rolled_sleeves = 0

/obj/item/clothing/under/corp/wardt
	name = "\improper Ward-Takahashi jumpsuit"
	desc = "A jumpsuit belonging to Ward-Takahashi, a Trans-Stellar in the consumer goods market."
	icon_state = "robotics2"
	worn_state = "robotics2"

/obj/item/clothing/under/corp/confederacy
	name = "\improper Confederacy uniform"
	desc = "A military uniform belonging to the Confederacy of Man, an independent human government."
	icon_state = "confed"
	worn_state = "confed"

/obj/item/clothing/under/corp/saare
	name = "\improper SAARE uniform"
	desc = "A dress uniform belonging to Stealth Assault Enterprises, a minor private military corporation."
	icon_state = "saare"
	worn_state = "saare"

/obj/item/clothing/under/corp/focal
	name = "\improper Focal Point jumpsuit"
	desc = "A jumpsuit belonging to Focal Point Energistics, an engineering megacorporation."
	icon_state = "focal"
	worn_state = "focal"

/obj/item/clothing/under/corp/wulf
	name = "\improper Wulf jumpsuit"
	desc = "A jumpsuit belonging to Wulf Aeronautics, a ship-building and propulsion systems Trans-Stellar."
	icon_state = "wulf"
	worn_state = "wulf"
	rolled_sleeves = 0

/obj/item/clothing/under/corp/hephaestus
	name = "\improper Hephaestus jumpsuit"
	desc = "A jumpsuit belonging to Hephaestus, a Trans-Stellar best known for high-grade arms manufacturing."
	icon_state = "heph"
	worn_state = "heph"
	rolled_sleeves = 0

/obj/item/clothing/under/corp/kaleidoscope
	name = "\improper Kaleidoscope uniform"
	desc = "A science uniform belonging to Kaleidoscope Cosmetics, a cosmetic and gene-modification trans-stellar."
	icon_state = "kaleido"
	worn_state = "kaleido"
	rolled_sleeves = 0

/obj/item/clothing/under/corp/veymed
	name = "\improper Vey-Med uniform"
	desc = "A uniform belonging to Vey-Medical, a Skrellian biomedical Trans-Stellar."
	icon_state = "veymed"
	worn_state = "veymed"
	rolled_sleeves = 0

/obj/item/clothing/under/corp/wardt
	name = "\improper Ward-Takahashi jumpsuit"
	desc = "A jumpsuit belonging to Ward-Takahashi, a Trans-Stellar in the consumer goods market."
	icon_state = "robotics2"
	worn_state = "robotics2"

/obj/item/clothing/under/corp/xion
	name = "\improper Xion jumpsuit"
	desc = "A jumpsuit belonging to Xion Manufacturing, an industrial equipment Trans-Stellar."
	icon_state = "xion"
	worn_state = "xion"
	rolled_sleeves = 0

/obj/item/clothing/under/corp/zenghu
	name = "\improper Zeng-Hu jumpsuit"
	desc = "A jumpsuit belonging to Zeng-Hu Pharmaceuticals, a Trans-Stellar in the business of exactly what you'd expect.."
	icon_state = "zenghu"
	worn_state = "zenghu"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red)
	rolled_sleeves = 0

/obj/item/clothing/under/corp/morpheus
	name = "\improper Morpheus jumpsuit"
	desc = "A uniform belonging to Morpheus Cyberkinetics, a positronic-run cybernetics Trans-Stellar."
	icon_state = "morpheus"
	worn_state = "morpheus"

/obj/item/clothing/under/corp/xion
	name = "\improper Xion jumpsuit"
	desc = "A jumpsuit belonging to Xion Manufacturing, an industrial equipment Trans-Stellar."
	icon_state = "xion"
	worn_state = "xion"
	rolled_sleeves = 0

/obj/item/clothing/under/corp/hedberg
	name = "\improper Hedberg law enforcement uniform"
	desc = "A sturdy civilian law enforcement uniform belonging to the Hedberg-Hammarstrom private security corporation."
	icon_state = "hedberg"
	worn_state = "hedberg"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) //Equivalent to security officer's jumpsuit
	rolled_sleeves = 0

/obj/item/clothing/under/corp/hedbergtech
	name = "\improper Hedberg technician uniform"
	desc = "A technician's uniform belonging to the Hedberg-Hammarstrom private security corporation. It is lightly shielded against radiation."
	icon_state = "hedberg_tech"
	worn_state = "hedberg_tech"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10) // Equivalent to engineer's jumpsuit.
	rolled_sleeves = 0

//christmas stuff
/obj/item/clothing/under/christmas/red
	name = "red christmas suit"
	desc = "A simple red christmas suit that looks close to Santa's!"
	icon_state = "christmasred"

/obj/item/clothing/under/christmas/green
	name = "green christmas suit"
	desc = "A simple green christmas suit. Smells minty!"
	icon_state = "christmasgreen"

/obj/item/clothing/under/christmas/croptop/red
	name = "red crop-top christmas suit"
	desc = "A simple red christmas suit that doesn't quite looks like Mrs Claus'."
	icon_state = "christmascroppedred"

/obj/item/clothing/under/christmas/croptop/green
	name = "green crop-top christmas suit"
	desc = "A simple green christmas suit that doesn't quite looks like Mrs Claus'. Smells minty!"
	icon_state = "christmascroppedgreen"

//leotards
/obj/item/clothing/under/leotard
    name = "black leotard"
    desc = "A black leotard with a piece of semi-transparent cloth near the bust. Perfect for showing off cleavage. Bunny ears not included."
    icon_state = "leotard"

/obj/item/clothing/under/leotardcolor
    name = "colored leotard"
    desc = "A colorable leotard with a piece of semi-transparent cloth near the bust. Perfect for showing off cleavage. Bunny ears not included."
    icon_state = "leotard_color"

//skinsuits
/obj/item/clothing/under/skinsuit
	name = "skinsuit"
	desc = "Similar to other form-fitting latex bodysuits in design and function, skinsuits typically feature integrated hardpoints around common wear areas."
	icon_state = "skinsuit"

/obj/item/clothing/under/skinsuit/gray
    name = "gray skinsuit"
    icon_state = "skinsuit_g"

/obj/item/clothing/under/skinsuit/leotard
    name = "leotard skinsuit"
    desc = "The skinsuit's leotard variant has long since eclipsed its initial function as a breathable undersuit for submersible hardsuits. Although still utilized in this role, it has become rather fashionable to wear outside of deep water operations."
    icon_state = "skinsuitleo"


/obj/item/clothing/under/skinsuit/leotard/gray
    name = "gray leotard skinsuit"
    icon_state = "skinsuitleo_g"

/obj/item/clothing/under/skinsuit/fem
	name = "feminine skinsuit"
	desc = "Similar to other form-fitting latex bodysuits in design and function, skinsuits typically feature integrated hardpoints around common wear areas."
	icon_state = "skinsuitfem"

/obj/item/clothing/under/skinsuit/fem/gray
    name = "feminine gray skinsuit"
    icon_state = "skinsuitfem_g"

/obj/item/clothing/under/skinsuit/fem/leotard
    name = "feminine leotard skinsuit"
    desc = "The skinsuit's leotard variant has long since eclipsed its initial function as a breathable undersuit for submersible hardsuits. Although still utilized in this role, it has become rather fashionable to wear outside of deep water operations."
    icon_state = "skinsuitfemleo"

/obj/item/clothing/under/skinsuit/fem/leotard/gray
    name = "feminine gray leotard skinsuit"
    icon_state = "skinsuitfemleo_g"

//baggy turtlenecks
/obj/item/clothing/under/turtlebaggy
	name = "cream baggy turtleneck (cream)"
	desc = "A cozy knit turtleneck. It's too baggy and comfortable to be tactical."
	icon_state = "bb_turtle"
	body_parts_covered = CHEST|ARMS


/obj/item/clothing/under/turtlebaggy/cream_fem
    name = "feminine cream baggy turtleneck"
    icon_state = "bb_turtle_fem"


/obj/item/clothing/under/turtlebaggy/purple
    name = "purple baggy turtleneck"
    icon_state = "bb_turtlepur"


/obj/item/clothing/under/turtlebaggy/purple_fem
    name = "feminine purple baggy turtleneck"
    icon_state = "bb_turtlepur_fem"


/obj/item/clothing/under/turtlebaggy/red
    name = "red baggy turtleneck"
    icon_state = "bb_turtlered"


/obj/item/clothing/under/turtlebaggy/red_fem
    name = "feminine red baggy turtleneck"
    icon_state = "bb_turtlered_fem"


/obj/item/clothing/under/turtlebaggy/blue
    name = "blue baggy turtleneck"
    icon_state = "bb_turtleblu"


/obj/item/clothing/under/turtlebaggy/blue_fem
    name = "feminine blue baggy turtleneck"
    icon_state = "bb_turtleblu_fem"


/obj/item/clothing/under/turtlebaggy/green
    name = "green baggy turtleneck"
    icon_state = "bb_turtlegrn"


/obj/item/clothing/under/turtlebaggy/green_fem
    name = "feminine green baggy turtleneck"
    icon_state = "bb_turtlegrn_fem"


/obj/item/clothing/under/turtlebaggy/black
    name = "black baggy turtleneck"
    icon_state = "bb_turtleblk"


/obj/item/clothing/under/turtlebaggy/black_fem
    name = "feminine black baggy turtleneck"
    icon_state = "bb_turtleblk_fem"

//more big sweaters

/obj/item/clothing/under/bigsweater
	name = "cableknit sweater"
	desc = "Why trade style for comfort?"
	icon_state = "cableknit"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/under/bigsweater/keyhole
	icon_state = "keyhole"

/obj/item/clothing/under/keyhole
	name = "cableknit sweater"
	desc = "Why trade style for comfort?."
	icon_state = "cableknit"
	body_parts_covered = CHEST|ARMS


//half-moon outfit
/obj/item/clothing/under/half_moon
    name = "half moon outfit"
    desc = "This eminently fashionable outfit consists of a tailored latex leotard and daringly cut white shorts. Paired with plunging off-color stockings, it's to die for."
    icon_state = "half_moon"

//fiend clothes
/obj/item/clothing/under/fiendsuit
    name = "fiendish suit"
    desc = "A red and black suit befitting someone from the dark pits themselves… Or someone way too edgy."
    icon_state = "fiendsuit"


/obj/item/clothing/under/fienddress
    name = "fiendish dress"
    desc = "A red and black dress befitting someone from the dark pits themselves… Or someone way too edgy."
    icon_state = "fienddress"

//bunny suits

/obj/item/clothing/under/bunnysuit_maid
	name = "bunny suit"
	desc = "A black and white bunny suit, extremely skimpy. Tails and ears sold seperately."
	icon_state = "bunnysuit_maid"

/obj/item/clothing/under/bunnysuit
	name = "bunny suit"
	desc = "A bunny suit, extremely skimpy. Tails and ears sold seperately."
	icon_state = "bunnysuit_colour"


/obj/item/clothing/under/reverse_bunnysuit
	name = "reverse bunny suit"
	desc = "A reverse bunny suit, literally just covers everything except the bits you're supposed to. Tails and ears sold seperately."
	icon_state = "reverse_bunnysuit_colour"

/obj/item/clothing/under/reverse_bunnysuit_maid
	name = "reverse bunny suit"
	desc = "A maid themed reverse bunny suit, literally just covers everything except the bits you're supposed to. Tails and ears sold seperately."
	icon_state = "reverse_bunnysuit_maid"

/obj/item/clothing/under/reverse_bunnytop
	name = "reverse bunny suit"
	desc = "A reverse bunny suit, literally just covers everything except the bits you're supposed to. Tails and ears sold seperately."
	icon_state = "reverse_bunnytop_colour"

/obj/item/clothing/under/reverse_bunnytop_maid
	name = "reverse bunny suit"
	desc = "A maid themed reverse bunny suit, literally just covers everything except the bits you're supposed to. Tails and ears sold seperately."
	icon_state = "reverse_bunnytop_maid"
