/*
 * Formal
 */

/obj/item/clothing/accessory/vest
	name = "black vest"
	desc = "Slick black suit vest."
	icon_state = "det_vest"
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon_state = "tan_jacket"
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/jacket/red
	name = "red suit jacket"
	desc = "Relaxing suit jacket."
	icon_state = "red_jacket"

/obj/item/clothing/accessory/jacket/teal
	name = "teal suit jacket"
	desc = "Relaxing suit jacket."
	icon_state = "teal_jacket"

/obj/item/clothing/accessory/jacket/green
	name = "green suit jacket"
	desc = "Relaxing suit jacket."
	icon_state = "green_jacket"

/obj/item/clothing/accessory/jacket/charcoal
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon_state = "charcoal_jacket"

/obj/item/clothing/accessory/jacket/navy
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon_state = "navy_jacket"

/obj/item/clothing/accessory/jacket/burgundy
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon_state = "burgundy_jacket"

/obj/item/clothing/accessory/jacket/checkered
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon_state = "checkered_jacket"

/obj/item/clothing/accessory/jacket/gambler
	name = "gambler suit jacket"
	desc = "Chairman suit jacket."
	icon_state = "gambler_jacket"

/obj/item/clothing/accessory/jacket/extravagant
	name = "extravagant suit jacket"
	desc = "Luxury suit jacket."
	icon_state = "extravagant_jacket"

/*
 * Hawaiian
 */

/obj/item/clothing/accessory/hawaiian
	name = "hawaiian shirt"
	desc = "You probably need some welder googles to look at this."
	icon_state = "hawaiian_cyan"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/hawaiian/blue
	name = "blue hawaiian shirt"
	icon_state = "hawaiian_blue"

/obj/item/clothing/accessory/hawaiian/pink
	name = "pink hawaiian shirt"
	icon_state = "hawaiian_pink"

/obj/item/clothing/accessory/hawaiian/red
	name = "red hawaiian shirt"
	icon_state = "hawaiian_red"

/obj/item/clothing/accessory/hawaiian/yellow
	name = "yellow hawaiian shirt"
	icon_state = "hawaiian_yellow"

/obj/item/clothing/accessory/hawaiian_random
	name = "random hawaiian shirt"
	desc = "A random set of hawaiian shirts for style."

/obj/item/clothing/accessory/hawaiian_random/New()
	return pick(
			prob(2);/obj/item/clothing/accessory/hawaiian,
			prob(2);/obj/item/clothing/accessory/hawaiian/blue,
			prob(2);/obj/item/clothing/accessory/hawaiian/pink,
			prob(2);/obj/item/clothing/accessory/hawaiian/red,
			prob(2);/obj/item/clothing/accessory/hawaiian/yellow
			)

/*
 * 80s
 */

/obj/item/clothing/accessory/tropical
	name = "black tropical shirt"
	desc = "A classic themed neosilk tropical shirt. This one makes you feel like an animal."
	icon_state = "animalstyle"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/tropical/green
	name = "puke-green tropical shirt"
	desc = "A classic themed neosilk tropical shirt. This one makes you look like puke."
	icon_state = "tropicopuke"

/obj/item/clothing/accessory/tropical/pink
	name = "pink tropical shirt"
	desc = "A classic themed neosilk tropical shirt. This one makes you feel nostalgic."
	icon_state = "3005vintage"

/obj/item/clothing/accessory/tropical/blue
	name = "blue tropical shirt"
	desc = "A classic themed neosilk tropical shirt. This one makes you feel out of touch."
	icon_state = "miamivice"

/obj/item/clothing/accessory/tropical_random/New()
	return pick(
			prob(2);/obj/item/clothing/accessory/tropical,
			prob(2);/obj/item/clothing/accessory/tropical/green,
			prob(2);/obj/item/clothing/accessory/tropical/pink,
			prob(2);/obj/item/clothing/accessory/tropical/blue
			)

/*
 * Chaps
 */

/obj/item/clothing/accessory/chaps
	name = "brown chaps"
	desc = "A pair of loose, brown leather chaps."
	icon_state = "chaps"

/obj/item/clothing/accessory/chaps/black
	name = "black chaps"
	desc = "A pair of loose, black leather chaps."
	icon_state = "chaps_black"

/*
 * Poncho
 */

/obj/item/clothing/accessory/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"
<<<<<<< HEAD
	icon_override = 'icons/inventory/accessory/mob.dmi'
=======
	icon_override = 'icons/mob/ties.dmi'
	var/icon_override_state		/// Change this for mid-round and paintkit. 
>>>>>>> a17ed4ec65e... Merge pull request #8562 from Sypsoti/ponchofix_v2
	var/fire_resist = T0C+100
	allowed = list(/obj/item/weapon/tank/emergency/oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/suit/mob_teshari.dmi'
	)

/obj/item/clothing/accessory/poncho/equipped() /// Sets override, allows for mid-round changes && custom items. If you improve this code, please update paintkit.dm to accept it.
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_suit == src)
		if(H.species.name == SPECIES_TESHARI)
<<<<<<< HEAD
			icon_override = 'icons/inventory/suit/mob_teshari.dmi'
		else
			icon_override = 'icons/inventory/accessory/mob.dmi'
		update_clothing_icon()
=======
			icon_override = sprite_sheets[SPECIES_TESHARI]
		else if(icon_override_state)
			icon_override = icon_override_state
		else
			icon_override = 'icons/mob/ties.dmi'
		H.update_inv_wear_suit()
>>>>>>> a17ed4ec65e... Merge pull request #8562 from Sypsoti/ponchofix_v2

/obj/item/clothing/accessory/poncho/dropped() // Reset override
	if(icon_override_state)
		icon_override = icon_override_state
	else
		icon_override = 'icons/mob/ties.dmi'

/obj/item/clothing/accessory/poncho/on_attached(obj/item/clothing/S, mob/user) /// Otherwise gives teshari normal icon. 
	. = ..()
	if(icon_override_state)
		icon_override = icon_override_state
	else if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.name == SPECIES_TESHARI)
			icon_override = sprite_sheets[SPECIES_TESHARI]
	else
		icon_override = 'icons/mob/ties.dmi'

/obj/item/clothing/accessory/poncho/green
	name = "green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/accessory/poncho/red
	name = "red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/accessory/poncho/purple
	name = "purple poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is purple."
	icon_state = "purpleponcho"
	item_state = "purpleponcho"

/obj/item/clothing/accessory/poncho/blue
	name = "blue poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is blue."
	icon_state = "blueponcho"
	item_state = "blueponcho"

/obj/item/clothing/accessory/poncho/roles/security
	name = "security poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is black and red, standard NanoTrasen Security colors."
	icon_state = "secponcho"
	item_state = "secponcho"

/obj/item/clothing/accessory/poncho/roles/medical
	name = "medical poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with green and blue tint, standard Medical colors."
	icon_state = "medponcho"
	item_state = "medponcho"

/obj/item/clothing/accessory/poncho/roles/engineering
	name = "engineering poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is yellow and orange, standard Engineering colors."
	icon_state = "engiponcho"
	item_state = "engiponcho"

/obj/item/clothing/accessory/poncho/roles/science
	name = "science poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with purple trim, standard NanoTrasen Science colors."
	icon_state = "sciponcho"
	item_state = "sciponcho"

/obj/item/clothing/accessory/poncho/roles/cargo
	name = "cargo poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is tan and grey, the colors of Cargo."
	icon_state = "cargoponcho"
	item_state = "cargoponcho"

/*
 * Cloak
 */

/obj/item/clothing/accessory/poncho/roles/cloak
	name = "quartermaster's cloak"
	desc = "An elaborate brown and gold cloak."
	icon_state = "qmcloak"
	item_state = "qmcloak"
	body_parts_covered = null

/obj/item/clothing/accessory/poncho/roles/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon_state = "cecloak"
	item_state = "cecloak"

/obj/item/clothing/accessory/poncho/roles/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon_state = "cmocloak"
	item_state = "cmocloak"

/obj/item/clothing/accessory/poncho/roles/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon_state = "hopcloak"
	item_state = "hopcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon_state = "rdcloak"
	item_state = "rdcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon_state = "qmcloak"
	item_state = "qmcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the head of security."
	icon_state = "hoscloak"
	item_state = "hoscloak"

/obj/item/clothing/accessory/poncho/roles/cloak/captain
	name = "site manager's cloak"
	desc = "An elaborate cloak meant to be worn by the site manager."
	icon_state = "capcloak"
	item_state = "capcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak."
	icon_state = "cargocloak"
	item_state = "cargocloak"

/obj/item/clothing/accessory/poncho/roles/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak."
	icon_state = "miningcloak"
	item_state = "miningcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/security
	name = "red cloak"
	desc = "A simple red and black cloak."
	icon_state = "seccloak"
	item_state = "seccloak"

/obj/item/clothing/accessory/poncho/roles/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak."
	icon_state = "servicecloak"
	item_state = "servicecloak"

/obj/item/clothing/accessory/poncho/roles/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak."
	icon_state = "engicloak"
	item_state = "engicloak"

/obj/item/clothing/accessory/poncho/roles/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak."
	icon_state = "atmoscloak"
	item_state = "atmoscloak"

/obj/item/clothing/accessory/poncho/roles/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak."
	icon_state = "scicloak"
	item_state = "scicloak"

/obj/item/clothing/accessory/poncho/roles/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak."
	icon_state = "medcloak"
	item_state = "medcloak"


/obj/item/clothing/accessory/poncho/roles/cloak/custom //A colorable cloak
	name = "cloak"
	desc = "A simple, bland cloak."
	icon_state = "colorcloak"
	item_state = "colorcloak"

/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "vest"
	icon_override = 'icons/inventory/accessory/mob.dmi'
	item_state_slots = list(slot_r_hand_str = "wcoat", slot_l_hand_str = "wcoat")
	allowed = list(/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/wcoat/red
	name = "red waistcoat"
	icon_state = "red_waistcoat"
	item_state = "red_waistcoat"

/obj/item/clothing/accessory/wcoat/grey
	name = "grey waistcoat"
	icon_state = "grey_waistcoat"
	item_state = "grey_waistcoat"

/obj/item/clothing/accessory/wcoat/brown
	name = "brown waistcoat"
	icon_state = "brown_waistcoat"
	item_state = "brown_waistcoat"

/obj/item/clothing/accessory/wcoat/gentleman
	name = "elegant waistcoat"
	icon_state = "elegant_waistcoat"
	item_state = "elegant_waistcoat"

/*
 * Sweatervests
 */

/obj/item/clothing/accessory/wcoat/swvest
	name = "black sweater vest"
	desc = "A sleeveless sweater. Wear this if you don't want your arms to be warm, or if you're a nerd."
	icon_state = "sweatervest"
	item_state = "sweatervest"

/obj/item/clothing/accessory/wcoat/swvest/blue
	name = "blue sweater vest"
	icon_state = "sweatervest_blue"
	item_state = "sweatervest_blue"

/obj/item/clothing/accessory/wcoat/swvest/red
	name = "red sweater vest"
	icon_state = "sweatervest_red"
	item_state = "sweatervest_red"

/obj/item/clothing/accessory/wcoat/swvest/green
	name = "green sweater vest"
	icon_state = "sweatervest_green"
	item_state = "sweatervest_green"

/*
 * Sweaters
 */

/obj/item/clothing/accessory/sweater
	name = "sweater"
	desc = "A warm knit sweater."
	icon_override = 'icons/inventory/accessory/mob.dmi'
	icon_state = "sweater"
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/sweater/pink
	name = "pink sweater"
	desc = "A warm knit sweater. This one's pink in color."
	icon_state = "sweater_pink"

/obj/item/clothing/accessory/sweater/mint
	name = "mint sweater"
	desc = "A warm knit sweater. This one has a minty tint to it."
	icon_state = "sweater_mint"

/obj/item/clothing/accessory/sweater/blue
	name = "blue sweater"
	desc = "A warm knit sweater. This one's colored in a lighter blue."
	icon_state = "sweater_blue"

/obj/item/clothing/accessory/sweater/heart
	name = "heart sweater"
	desc = "A warm knit sweater. This one's colored in a lighter blue, and has a big pink heart right in the center!"
	icon_state = "sweater_blueheart"

/obj/item/clothing/accessory/sweater/nt
	name = "dark blue sweater"
	desc = "A warm knit sweater. This one's a darker blue."
	icon_state = "sweater_nt"

/obj/item/clothing/accessory/sweater/keyhole
	name = "keyhole sweater"
	desc = "A lavender sweater with an open chest."
	icon_state = "keyholesweater"

/obj/item/clothing/accessory/sweater/blackneck
	name = "black turtleneck"
	desc = "A tight turtleneck, entirely black in coloration."
	icon_state = "turtleneck_black"

/obj/item/clothing/accessory/sweater/winterneck
	name = "Christmas turtleneck"
	desc = "A really cheesy holiday sweater, it actually kinda itches."
	icon_state = "turtleneck_winterred"

/obj/item/clothing/accessory/sweater/uglyxmas
	name = "ugly Christmas sweater"
	desc = "A gift that probably should've stayed in the back of the closet."
	icon_state = "uglyxmas"

/obj/item/clothing/accessory/sweater/flowersweater
	name = "flowery sweater"
	desc =  "An oversized and flowery pink sweater."
	icon_state = "flowersweater"

/obj/item/clothing/accessory/sweater/redneck
	name = "red turtleneck"
	desc = "A comfortable turtleneck in a dark red."
	icon_state = "turtleneck_red"

/obj/item/clothing/accessory/sweater/virgin
	name = "virgin killer"
	desc = "A knit sweater that leaves little to the imagination."
	icon_state = "virginkiller"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/*
 * Misc
 */

/obj/item/clothing/accessory/cowledvest
	name = "cowled vest"
	desc = "A body warmer for the 24th century." //VOREStation Edit
	icon_state = "cowled_vest"

/obj/item/clothing/accessory/asymmetric
	name = "blue asymmetrical jacket"
	desc = "Insultingly avant-garde in prussian blue."
	icon_state = "asym_blue"

/obj/item/clothing/accessory/asymmetric/purple
	name = "purple asymmetrical jacket"
	desc = "Insultingly avant-garde in mauve."
	icon_state = "asym_purple"

/obj/item/clothing/accessory/asymmetric/green
	name = "green asymmetrical jacket"
	desc = "Insultingly avant-garde in aqua."
	icon_state = "asym_green"

/obj/item/clothing/accessory/asymovercoat
	name = "orange asymmetrical overcoat"
	desc = "An asymmetrical orange overcoat in a 2560's fashion."
	icon_state = "asymovercoat"

/*
 * Cowboy Vests
 */

/obj/item/clothing/accessory/cowboy_vest
	name = "ranger cowboy vest"
	desc = "A rugged looking vest made from leather. For those that tame the wilds."
	icon_state = "cowboyvest_ranger"

/obj/item/clothing/accessory/cowboy_vest/brown
	name = "brown cowboy vest"
	icon_state = "cowboyvest_brown"

/obj/item/clothing/accessory/cowboy_vest/grey
	name = "grey cowboy vest"
	icon_state = "cowboyvest_grey"