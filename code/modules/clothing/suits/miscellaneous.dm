/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 *		Department Jackets
 */

// -S2-note- Needs categorizing and sorting.

/*
 * Lasertag
 */

/obj/item/clothing/suit/bluetag
	name = "blue laser tag armor"
	desc = "Blue Pride, Station Wide."
	icon_state = "bluetag"
	item_state_slots = list(slot_r_hand_str = "tdblue", slot_l_hand_str = "tdblue")
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/weapon/gun/energy/lasertag/blue)
	siemens_coefficient = 3.0

/obj/item/clothing/suit/bluetag/sub
	name = "Brigader Armor"
	desc = "Repilca rmor commonly worn by Spacer Union Brigade members from the hit series Spacer Trail. Modified for Laser Tag (Blue Team)."
	icon_state = "bluetag2"

/obj/item/clothing/suit/redtag
	name = "red laser tag armor"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	item_state_slots = list(slot_r_hand_str = "tdred", slot_l_hand_str = "tdred")
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/weapon/gun/energy/lasertag/red)
	siemens_coefficient = 3.0

/obj/item/clothing/suit/redtag/dom
	name = "Mu'tu'bi Armor"
	desc = "Repilca rmor commonly worn by Dominion Of Mu'tu'bi soldiers from the hit series Spacer Trail. Modified for Laser Tag (Red Team)."
	icon_state = "redtag2"

/*
 * 80s
 */

/obj/item/clothing/suit/storage/puffyblue
	name = "blue puffy coat"
	desc = "A stylish, shiny, very blue puffer coat."
	icon_state = "puffycoatblue"
	item_state = "puffycoatblue"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	item_state_slots = list(slot_r_hand_str = "blue_labcoat", slot_l_hand_str = "blue_labcoat")

/obj/item/clothing/suit/storage/puffypurple
	name = "purple puffy coat"
	desc = "A stylish, shiny, very purple puffer coat."
	icon_state = "puffycoatpurple"
	item_state = "puffycoatpurple"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	item_state_slots = list(slot_r_hand_str = "purple_labcoat", slot_l_hand_str = "purple_labcoat")

/obj/item/clothing/suit/storage/puffyred
	name = "crimson puffy coat"
	desc = "A stylish, shiny, very crimson puffer coat."
	icon_state = "puffycoatred"
	item_state = "puffycoatred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	item_state_slots = list(slot_r_hand_str = "red_labcoat", slot_l_hand_str = "red_labcoat")

/*
 * Costume
 */

/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state_slots = list(slot_r_hand_str = "greatcoat", slot_l_hand_str = "greatcoat")
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon = 'icons/inventory/suit/mob.dmi'
	icon_state = "poncho"
	item_state = "poncho"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_vr.dmi',
		)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	desc = "Yarr."
	icon_state = "hgpirate"
	item_state_slots = list(slot_r_hand_str = "greatcoat", slot_l_hand_str = "greatcoat")
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	desc = "Suit for a cyborg costume."
	icon_state = "death"
	fire_resist = T0C+5200
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A heavy great coat"
	icon_state = "gentlecoat"
	item_state_slots = list(slot_r_hand_str = "greatcoat", slot_l_hand_str = "greatcoat")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/johnny_coat
	name = "johnny~~ coat"
	desc = "Johnny~~"
	icon_state = "gentlecoat"
	item_state_slots = list(slot_r_hand_str = "johnny_coat", slot_l_hand_str = "johnny_coat")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/justice
	name = "justice suit"
	desc = "This pretty much looks ridiculous."
	icon_state = "gentle_coat"
	item_state_slots = list(slot_r_hand_str = "greatcoat", slot_l_hand_str = "greatcoat")
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/spacecash)
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/storage/apron/overalls
	name = "coveralls"
	desc = "A set of denim overalls."
	icon_state = "overalls"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/syndicatefake
	name = "red space suit replica"
	icon_state = "syndicate"
	desc = "A plastic replica of the syndicate space suit, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	w_class = ITEMSIZE_NORMAL
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen,/obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/hastur
	name = "Hastur's Robes"
	desc = "Robes not meant to be worn by man"
	icon_state = "hastur"
	item_state_slots = list(slot_r_hand_str = "rad", slot_l_hand_str = "rad")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/imperium_monk
	name = "Imperium monk"
	desc = "Have YOU killed a xenos today?"
	icon_state = "imperium_monk"
	body_parts_covered = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/chickensuit
	name = "Chicken Suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 2.0

/obj/item/clothing/suit/monkeysuit
	name = "Monkey Suit"
	desc = "A suit that looks like a primate"
	icon_state = "monkeysuit"
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 2.0

/obj/item/clothing/suit/holidaypriest
	name = "Holiday Priest"
	desc = "This is a nice holiday my son."
	icon_state = "holidaypriest"
	item_state_slots = list(slot_r_hand_str = "labcoat", slot_l_hand_str = "labcoat")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/skeleton
	name = "skeleton costume"
	desc = "A body-tight costume with the human skeleton lined out on it."
	icon_state = "skelecost"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|FEET|HANDS|EYES|HEAD|FACE
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDEGLOVES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "judge", slot_l_hand_str = "judge")

/obj/item/clothing/suit/engicost
	name = "sexy engineering voidsuit costume"
	desc = "It's supposed to look like an engineering voidsuit... It doesn't look like it could protect from much radiation."
	icon_state = "engicost"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|FEET
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

/obj/item/clothing/suit/maxman
	name = "doctor maxman costume"
	desc = "A costume made to look like Dr. Maxman, the famous male-enhancement salesman. Complete with red do-rag and sleeveless labcoat."
	icon_state = "maxman"
	body_parts_covered = LOWER_TORSO|FEET|LEGS|HEAD
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")

/obj/item/clothing/suit/iasexy
	name = "sexy internal affairs suit"
	desc = "Now where's your pen?~"
	icon_state = "iacost"
	body_parts_covered = UPPER_TORSO|FEET|LOWER_TORSO|EYES
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")

/obj/item/clothing/suit/sexyminer
	name = "sexy miner costume"
	desc = "For when you need to get your rocks off."
	icon_state = "sexyminer"
	body_parts_covered = FEET|LOWER_TORSO|HEAD
	flags_inv = HIDEJUMPSUIT|HIDESHOES|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "miner", slot_l_hand_str = "miner")

/obj/item/clothing/suit/sumo
	name = "inflatable sumo wrestler costume"
	desc = "An inflated sumo wrestler costume. It's quite hot."
	icon_state = "sumo"
	body_parts_covered = FEET|LOWER_TORSO|UPPER_TORSO|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "classicponcho", slot_l_hand_str = "classicponcho")
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/hackercost
	name = "classic hacker costume"
	desc = "You would feel insanely cool wearing this."
	icon_state = "hackercost"
	body_parts_covered = FEET|LOWER_TORSO|UPPER_TORSO|LEGS|ARMS|EYES
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "leather_coat", slot_l_hand_str = "leather_coat")

/obj/item/clothing/suit/lumber
	name = "sexy lumberjack costume"
	desc = "Smells of dusky pine. Includes chest hair and beard."
	icon_state = "sexylumber"
	body_parts_covered = FEET|LOWER_TORSO|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "red_labcoat", slot_l_hand_str = "red_labcoat")

/*
 * Misc
 */
<<<<<<< HEAD

/obj/item/clothing/suit/straight_jacket
	name = "straight jacket"
=======
/obj/item/clothing/suit/straight_jacket //A mispelling from time immemorial...
	name = "straitjacket"
>>>>>>> 3e092d401e5... Merge pull request #8743 from Cerebulon/new_basics_engineering
	desc = "A suit that completely restrains the wearer."
	icon_state = "straight_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

	var/resist_time = 4800	// Eight minutes.

/obj/item/clothing/suit/straight_jacket/attack_hand(mob/living/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(src == H.wear_suit)
			to_chat(H, "<span class='notice'>You need help taking this off!</span>")
			return
	..()

/obj/item/clothing/suit/straight_jacket/equipped(var/mob/living/user,var/slot)
	. = ..()
	if(slot == slot_wear_suit)
		user.drop_l_hand()
		user.drop_r_hand()
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.drop_from_inventory(H.handcuffed)

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	item_state_slots = list(slot_r_hand_str = "labcoat", slot_l_hand_str = "labcoat") //placeholder -S2-
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDETIE|HIDEHOLSTER

/*
 * Kimonos
 */

/obj/item/clothing/suit/kimono
	name = "traditional kimono"
	desc = "A traditional Japanese kimono."
	icon_state = "kimono"
	addblends = "kimono_a"

/obj/item/clothing/suit/kamishimo
	name = "traditional kamishimo"
	desc = "Traditional Japanese menswear."
	icon_state = "kamishimo"
	addblends = "kamishimo_a"

/obj/item/clothing/suit/kimono/red
	name = "red kimono"
	icon_state = "kimono_red"

/obj/item/clothing/suit/kimono/orange
	name = "orange kimono"
	icon_state = "kimono_orange"

/obj/item/clothing/suit/kimono/yellow
	name = "yellow kimono"
	icon_state = "kimono_yellow"

/obj/item/clothing/suit/kimono/green
	name = "green kimono"
	icon_state = "kimono_green"

/obj/item/clothing/suit/kimono/blue
	name = "blue kimono"
	icon_state = "kimono_blue"

/obj/item/clothing/suit/kimono/purple
	name = "purple kimono"
	icon_state = "kimono_purple"

/obj/item/clothing/suit/kimono/violet
	name = "violet kimono"
	icon_state = "kimono_violet"

/obj/item/clothing/suit/kimono/pink
	name = "pink kimono"
	icon_state = "kimono_pink"

/obj/item/clothing/suit/kimono/earth
	name = "earth kimono"
	icon_state = "kimono_earth"

/*
 * Coats
 */

/obj/item/clothing/suit/leathercoat
	name = "leather coat"
	desc = "A long, thick black leather coat."
	icon_state = "leathercoat_alt"
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/leathercoat/sec
	name = "leather coat"
	desc = "A long, thick black leather coat."
	icon_state = "leathercoat_sec"
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/browncoat
	name = "brown leather coat"
	desc = "A long, brown leather coat."
	icon_state = "browncoat"
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/neocoat
	name = "black coat"
	desc = "A flowing, black coat."
	icon_state = "neocoat"
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/customs
	name = "customs jacket"
	desc = "A standard SolGov Customs formal jacket."
	icon_state = "customs_jacket"
	item_state_slots = list(slot_r_hand_str = "suit_blue", slot_l_hand_str = "suit_blue")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/greyjacket
	name = "grey jacket"
	desc = "A fancy twead grey jacket."
	icon_state = "gentlecoat"
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. The coat appears to have its kevlar lining removed."
	icon_state = "detective"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/weapon/tank/emergency/oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,/obj/item/device/uv_light)
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/trench/grey
	name = "grey trenchcoat"
	icon_state = "detective2"
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/peacoat
	name = "peacoat"
	desc = "A well-tailored, stylish peacoat."
	icon_state = "peacoat"
	addblends = "peacoat_a"
	item_state_slots = list(slot_r_hand_str = "peacoat", slot_l_hand_str = "peacoat")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/duster
	name = "duster"
	desc = "A duster is a light, loose-fitting long coat. Dusters are meant to protect your clothing from dust and rain."
	icon_state = "duster"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/weapon/tank/emergency/oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/cardigan
	name = "cardigan"
	desc = "A cozy cardigan in a classic style."
	icon_state = "cardigan"
	addblends = "cardigan_a"
	flags_inv = HIDEHOLSTER

/*
 * stripper
 */
/obj/item/clothing/suit/stripper/stripper_pink
	name = "pink skimpy dress"
	desc = "A rather skimpy pink dress."
	icon_state = "stripper_p_over"
	item_state_slots = list(slot_r_hand_str = "pink_labcoat", slot_l_hand_str = "pink_labcoat")
	siemens_coefficient = 1

/obj/item/clothing/suit/stripper/stripper_green
	name = "green skimpy dress"
	desc = "A rather skimpy green dress."
	icon_state = "stripper_g_over"
	item_state_slots = list(slot_r_hand_str = "green_labcoat", slot_l_hand_str = "green_labcoat")
	siemens_coefficient = 1

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	item_state_slots = list(slot_r_hand_str = "black_suit", slot_l_hand_str = "black_suit")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 2.0

/obj/item/clothing/suit/jacket/puffer
	name = "puffer jacket"
	desc = "A thick jacket with a rubbery, water-resistant shell."
	icon_state = "pufferjacket"
	item_state_slots = list(slot_r_hand_str = "chainmail", slot_l_hand_str = "chainmail")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/jacket/puffer/vest
	name = "puffer vest"
	desc = "A thick vest with a rubbery, water-resistant shell."
	icon_state = "puffervest"
	item_state_slots = list(slot_r_hand_str = "chainmail", slot_l_hand_str = "chainmail")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	cold_protection = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/storage/miljacket
	name = "military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_nobadge"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/alt
	name = "military jacket, alternate"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. This one has some extra badges on it."
	icon_state = "militaryjacket_badge"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/green
	name = "green military jacket"
	desc = "A dark but rather high-saturation green canvas jacket. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_green"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/tan
	name = "tan military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. Now in sandy tans for desert fans."
	icon_state = "militaryjacket_tan"
	item_state_slots = list(slot_r_hand_str = "suit_orange", slot_l_hand_str = "suit_orange")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/grey
	name = "grey military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. This one's in urban grey."
	icon_state = "militaryjacket_grey"
	item_state_slots = list(slot_r_hand_str = "suit_grey", slot_l_hand_str = "suit_grey")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/navy
	name = "navy military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. Dark navy, this one is."
	icon_state = "militaryjacket_navy"
	item_state_slots = list(slot_r_hand_str = "suit_navy", slot_l_hand_str = "suit_navy")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/black
	name = "black military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable. Now in tactical black."
	icon_state = "militaryjacket_black"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/miljacket/white
	name = "white military jacket"
	desc = "A white canvas jacket. Don't wear this for walks in the snow, it won't keep you warm - it'll just make it harder to find your frozen corpse."
	icon_state = "militaryjacket_white"
	item_state_slots = list(slot_r_hand_str = "med_dep_jacket", slot_l_hand_str = "med_dep_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomber"
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/toggle/bomber/retro
	name = "retro bomber jacket"
	desc = "A retro style, fur-lined leather bomber jacket that invokes the early days of space exploration when spacemen were spacemen, and laser guns had funny little antennae on them."
	icon_state = "retrojacket"

/obj/item/clothing/suit/storage/bomber/alt
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomberjacket_new"
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/toggle/leather_jacket
	name = "leather jacket"
	desc = "A black leather coat."
	icon_state = "leather_jacket"
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless
	name = "leather vest"
	desc = "A black leather vest."
	icon_state = "leather_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")

/obj/item/clothing/suit/storage/leather_jacket_alt
	name = "leather vest"
	desc = "A black leather vest."
	icon_state = "leather_jacket_alt"
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen
	desc = "A black leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "leather_jacket_nt"
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")

/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless
	name = "leather vest"
	desc = "A black leather vest. A corporate logo is proudly displayed on the back."
	icon_state = "leather_jacket_nt_sleeveless"
	body_parts_covered = UPPER_TORSO
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")

//This one has buttons for some reason
/obj/item/clothing/suit/storage/toggle/brown_jacket
	name = "brown jacket"
	desc = "A brown leather coat."
	icon_state = "brown_jacket"
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	name = "brown vest"
	desc = "A brown leather vest."
	icon_state = "brown_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")

/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	desc = "A brown leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "brown_jacket_nt"
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")

/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless
	name = "brown vest"
	desc = "A brown leather vest. A corporate logo is proudly displayed on the back."
	icon_state = "brown_jacket_nt_sleeveless"
	body_parts_covered = UPPER_TORSO
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")

/obj/item/clothing/suit/storage/toggle/denim_jacket
	name = "denim jacket"
	desc = "A denim coat."
	icon_state = "denim_jacket"
	item_state_slots = list(slot_r_hand_str = "denim_jacket", slot_l_hand_str = "denim_jacket")
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless
	name = "denim vest"
	desc = "A denim vest."
	icon_state = "denim_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO
	item_state_slots = list(slot_r_hand_str = "denim_jacket", slot_l_hand_str = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen
	desc = "A denim coat. A corporate logo is proudly displayed on the back."
	icon_state = "denim_jacket_nt"
	item_state_slots = list(slot_r_hand_str = "denim_jacket", slot_l_hand_str = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless
	name = "denim vest"
	desc = "A denim vest. A corporate logo is proudly displayed on the back."
	icon_state = "denim_jacket_nt_sleeveless"
	body_parts_covered = UPPER_TORSO
	item_state_slots = list(slot_r_hand_str = "denim_jacket", slot_l_hand_str = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "grey hoodie"
	desc = "A warm, grey sweatshirt."
	icon_state = "grey_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_grey", slot_l_hand_str = "suit_grey")
	min_cold_protection_temperature = T0C - 20
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	icon_state = "black_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")

/obj/item/clothing/suit/storage/toggle/hoodie/red
	name = "red hoodie"
	desc = "A warm, red sweatshirt."
	icon_state = "red_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_red", slot_l_hand_str = "suit_red")

/obj/item/clothing/suit/storage/toggle/hoodie/blue
	name = "blue hoodie"
	desc = "A warm, blue sweatshirt."
	icon_state = "blue_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_blue", slot_l_hand_str = "suit_blue")

/obj/item/clothing/suit/storage/toggle/hoodie/green
	name = "green hoodie"
	desc = "A warm, green sweatshirt."
	icon_state = "green_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")

/obj/item/clothing/suit/storage/toggle/hoodie/orange
	name = "orange hoodie"
	desc = "A warm, orange sweatshirt."
	icon_state = "orange_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_orange", slot_l_hand_str = "suit_orange")

/obj/item/clothing/suit/storage/toggle/hoodie/yellow
	name = "yellow hoodie"
	desc = "A warm, yellow sweatshirt."
	icon_state = "yellow_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_yellow", slot_l_hand_str = "suit_yellow")

/obj/item/clothing/suit/storage/toggle/hoodie/cti
	name = "CTI hoodie"
	desc = "A warm, black sweatshirt.  It bears the letters CTI on the back, a lettering to the prestigious university in Tau Ceti, Ceti Technical Institute.  There is a blue supernova embroidered on the front, the emblem of CTI."
	icon_state = "cti_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")

/obj/item/clothing/suit/storage/toggle/hoodie/mu
	name = "mojave university hoodie"
	desc = "A warm, gray sweatshirt.  It bears the letters MU on the front, a lettering to the well-known public college, Mojave University."
	icon_state = "mu_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_grey", slot_l_hand_str = "suit_grey")

/obj/item/clothing/suit/storage/toggle/hoodie/nt
	name = "NT hoodie"
	desc = "A warm, blue sweatshirt.  It proudly bears the silver NanoTrasen insignia lettering on the back.  The edges are trimmed with silver."
	icon_state = "nt_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_blue", slot_l_hand_str = "suit_blue")

/obj/item/clothing/suit/storage/toggle/hoodie/smw
	name = "Space Mountain Wind hoodie"
	desc = "A warm, black sweatshirt.  It has the logo for the popular softdrink Space Mountain Wind on both the front and the back."
	icon_state = "smw_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")

/obj/item/clothing/suit/storage/toggle/hoodie/nrti
	name = "New Reykjavik Technical Institute hoodie"
	desc = "A warm, gray sweatshirt. It bears the letters NRT on the back, in reference to Sif's premiere technical institute."
	icon_state = "nrti_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_grey", slot_l_hand_str = "suit_grey")

/obj/item/clothing/suit/whitedress
	name = "white dress"
	desc = "A fancy dress."
	icon_state = "white_dress"
	item_state_slots = list(slot_r_hand_str = "white_dress", slot_l_hand_str = "white_dress")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/varsity
	name = "black varsity jacket"
	desc = "A favorite of jocks everywhere from Sol to Nyx."
	icon_state = "varsity"
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")
	flags_inv = HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/varsity/red
	name = "red varsity jacket"
	icon_state = "varsity_red"

/obj/item/clothing/suit/varsity/purple
	name = "purple varsity jacket"
	icon_state = "varsity_purple"

/obj/item/clothing/suit/varsity/green
	name = "green varsity jacket"
	icon_state = "varsity_green"

/obj/item/clothing/suit/varsity/blue
	name = "blue varsity jacket"
	icon_state = "varsity_blue"

/obj/item/clothing/suit/varsity/brown
	name = "brown varsity jacket"
	icon_state = "varsity_brown"

/*
 * Department Jackets
 */
/obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	name = "department jacket, security"
	desc = "A cozy jacket in security's colors. Show your department pride!"
	icon_state = "sec_dep_jacket"
	item_state_slots = list(slot_r_hand_str = "sec_dep_jacket", slot_l_hand_str = "sec_dep_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/engi_dep_jacket
	name = "department jacket, engineering"
	desc = "A cozy jacket in engineering's colors. Show your department pride!"
	icon_state = "engi_dep_jacket"
	item_state_slots = list(slot_r_hand_str = "engi_dep_jacket", slot_l_hand_str = "engi_dep_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	name = "department jacket, supply"
	desc = "A cozy jacket in supply's colors. Show your department pride!"
	icon_state = "supply_dep_jacket"
	item_state_slots = list(slot_r_hand_str = "supply_dep_jacket", slot_l_hand_str = "supply_dep_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	name = "department jacket, science"
	desc = "A cozy jacket in science's colors. Show your department pride!"
	icon_state = "sci_dep_jacket"
	item_state_slots = list(slot_r_hand_str = "sci_dep_jacket", slot_l_hand_str = "sci_dep_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/med_dep_jacket
	name = "department jacket, medical"
	desc = "A cozy jacket in medical's colors. Show your department pride!"
	icon_state = "med_dep_jacket"
	item_state_slots = list(slot_r_hand_str = "med_dep_jacket", slot_l_hand_str = "med_dep_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/light_jacket
	name = "grey light jacket"
	desc = "A light, cozy jacket. Now in grey."
	icon_state = "grey_dep_jacket"
	item_state_slots = list(slot_r_hand_str = "grey_dep_jacket", slot_l_hand_str = "grey_dep_jacket")
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/toggle/light_jacket/blue
	name = "dark blue light jacket"
	desc = "A light, cozy jacket. Now in dark blue."
	icon_state = "blue_dep_jacket"
	item_state_slots = list(slot_r_hand_str = "blue_dep_jacket", slot_l_hand_str = "blue_dep_jacket")

/*
 * Track Jackets
 */
/obj/item/clothing/suit/storage/toggle/track
	name = "track jacket"
	desc = "A track jacket, for the athletic."
	icon_state = "trackjacket"
	item_state_slots = list(slot_r_hand_str = "black_labcoat", slot_l_hand_str = "black_labcoat")
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/toggle/track/blue
	name = "blue track jacket"
	icon_state = "trackjacketblue"
	item_state_slots = list(slot_r_hand_str = "blue_labcoat", slot_l_hand_str = "blue_labcoat")


/obj/item/clothing/suit/storage/toggle/track/green
	name = "green track jacket"
	icon_state = "trackjacketgreen"
	item_state_slots = list(slot_r_hand_str = "green_labcoat", slot_l_hand_str = "green_labcoat")

/obj/item/clothing/suit/storage/toggle/track/red
	name = "red track jacket"
	icon_state = "trackjacketred"
	item_state_slots = list(slot_r_hand_str = "red_labcoat", slot_l_hand_str = "red_labcoat")

/obj/item/clothing/suit/storage/toggle/track/white
	name = "white track jacket"
	icon_state = "trackjacketwhite"
	item_state_slots = list(slot_r_hand_str = "labcoat", slot_l_hand_str = "labcoat")

//Flannels

/obj/item/clothing/suit/storage/flannel
	name = "Flannel shirt"
	desc = "A comfy, grey flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel"
	item_state_slots = list(slot_r_hand_str = "black_labcoat", slot_l_hand_str = "black_labcoat")
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	flags_inv = HIDEHOLSTER
	var/rolled = 0
	var/tucked = 0
	var/buttoned = 0

/obj/item/clothing/suit/storage/flannel/verb/roll_sleeves()
	set name = "Roll Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(usr.stat)
		return

	if(rolled == 0)
		rolled = 1
		body_parts_covered &= ~(ARMS)
		to_chat(usr, "<span class='notice'>You roll up the sleeves of your [src].</span>")
	else
		rolled = 0
		body_parts_covered = initial(body_parts_covered)
		to_chat(usr, "<span class='notice'>You roll down the sleeves of your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/verb/tuck()
	set name = "Toggle Shirt Tucking"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(tucked == 0)
		tucked = 1
		to_chat(usr, "<span class='notice'>You tuck in your your [src].</span>")
	else
		tucked = 0
		to_chat(usr, "<span class='notice'>You untuck your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/verb/button()
	set name = "Toggle Shirt Buttons"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(buttoned == 0)
		buttoned = 1
		flags_inv = HIDETIE|HIDEHOLSTER
		to_chat(usr, "<span class='notice'>You button your [src].</span>")
	else
		buttoned = 0
		flags_inv = HIDEHOLSTER
		to_chat(usr, "<span class='notice'>You unbutton your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/update_icon()
	icon_state = initial(icon_state)
	if(rolled)
		icon_state += "r"
	if(tucked)
		icon_state += "t"
	if(buttoned)
		icon_state += "b"
	update_clothing_icon()

/obj/item/clothing/suit/storage/flannel/red
	desc = "A comfy, red flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_red"
	item_state_slots = list(slot_r_hand_str = "red_labcoat", slot_l_hand_str = "red_labcoat")

/obj/item/clothing/suit/storage/flannel/aqua
	desc = "A comfy, aqua flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_aqua"
	item_state_slots = list(slot_r_hand_str = "blue_labcoat", slot_l_hand_str = "blue_labcoat")

/obj/item/clothing/suit/storage/flannel/brown
	desc = "A comfy, brown flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_brown"
	item_state_slots = list(slot_r_hand_str = "johnny", slot_l_hand_str = "johnny")

//Green Uniform

/obj/item/clothing/suit/storage/toggle/greengov
	name = "green formal jacket"
	desc = "A sleek proper formal jacket with gold buttons."
	icon_state = "suitjacket_green"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/snowsuit
	name = "snowsuit"
	desc = "A suit made to keep you nice and toasty on cold winter days. Or at least alive."
	icon_state = "snowsuit"
	item_state_slots = list(slot_r_hand_str = "labcoat", slot_l_hand_str = "labcoat")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/snowsuit/command
	name = "command snowsuit"
	icon_state = "snowsuit_command"

/obj/item/clothing/suit/storage/snowsuit/security
	name = "security snowsuit"
	icon_state = "snowsuit_security"

/obj/item/clothing/suit/storage/snowsuit/medical
	name = "medical snowsuit"
	icon_state = "snowsuit_medical"

/obj/item/clothing/suit/storage/snowsuit/engineering
	name = "engineering snowsuit"
	icon_state = "snowsuit_engineering"

/obj/item/clothing/suit/storage/snowsuit/cargo
	name = "cargo snowsuit"
	icon_state = "snowsuit_cargo"

/obj/item/clothing/suit/storage/snowsuit/science
	name = "science snowsuit"
	icon_state = "snowsuit_science"

/obj/item/clothing/suit/caution
	name = "wet floor sign"
	desc = "Caution! Wet Floor!"
	description_fluff = "Used by the janitor to passive-aggressively point at when you eventually slip on one of their mopped floors."
	description_info = "Alt-click, or click in-hand to toggle the caution lights. It looks like you can wear it in your suit slot."
	icon_state = "caution"
	drop_sound = 'sound/items/drop/shoes.ogg'
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = 2
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	attack_verb = list("warned", "cautioned", "smashed")
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/suit/caution/attack_self()
	toggle()

/obj/item/clothing/suit/caution/AltClick()
	toggle()

/obj/item/clothing/suit/caution/proc/toggle()
	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))	return
	else if(src.icon_state == "caution")
		src.icon_state = "caution_blinking"
		src.item_state = "caution_blinking"
		usr.show_message("You turn the wet floor sign on.")
		playsound(src.loc, 'sound/machines/button.ogg', 30, 1)
	else
		src.icon_state = "caution"
		src.item_state = "caution"
		usr.show_message("You turn the wet floor sign off.")
	update_clothing_icon()

//Ruin Marine (Doom Marine)
/obj/item/clothing/suit/marine
	name = "marine armor"
	desc = "A set of marine prop armor from the popular game 'Ruin'."
	icon_state = "marine"
	body_parts_covered = FEET|LOWER_TORSO|UPPER_TORSO|LEGS
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	item_state_slots = list(slot_r_hand_str = "green_labcoat", slot_l_hand_str = "green_labcoat")