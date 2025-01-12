/*
 * Contains:
 *		Security
 *		Detective
 *		Head of Security
 */

/*
 * Security
 */
/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"" + JOB_WARDEN+ "\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "warden"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0

/obj/item/clothing/under/rank/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "security"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0

/obj/item/clothing/under/rank/security/aces
	name = "ACE security undersuit"
	desc = "A snug but comfortable undersuit with removable arm sleeves, originally developed for the ACE Security Group. Includes a wrist-mounted minicomp."
	icon_state = "aces_undersuit"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0	//sleeves can be removed, but this disables the minicomp
	rolled_down = -1	//can't be rolled down

/obj/item/clothing/under/rank/security/aces/examine(mob/user)
	. = ..()

	if(!rolled_sleeves && Adjacent(user))	//can't see the comp if you've taken the sleeves off, or if you're not adjacent
		. += "<span class='notice'>The minicomp reports that the current station time is [stationtime2text()] and that it is [stationdate2text()].</span>"
		var/TB = src.loc.loc
		if(istype(TB, /turf/simulated))	//no point returning atmospheric data from unsimulated tiles (they don't track pressure anyway, only temperature)
			var/turf/simulated/T = TB
			var/datum/gas_mixture/env = T.return_air()
			. += "<span class='notice'>The minicomp reports the current atmospheric pressure: [env.return_pressure()]kPa, and temperature: [env.temperature]K </span>"

/obj/item/clothing/under/rank/security/modern
	name = "modernized security officer's jumpsuit"
	desc = "A recent redesign of the classic Security jumpsuit, featuring sturdy materials, joint padding, one giant zipper, and tight-fitting synthleather."
	icon_state = "securitymodern"
	item_state = "securitymodern"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	rolled_sleeves = -1
	worn_state = "securitymodern"
	icon = 'icons/inventory/uniform/item.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'

/obj/item/clothing/under/rank/security/turtleneck
	name = "security turtleneck"
	desc = "It's a stylish turtleneck made of a robust nanoweave. Nobody said the Law couldn't be fashionable."
	icon_state = "turtle_sec"
	rolled_down = -1
	rolled_sleeves = -1

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon_state = "dispatch"
	item_state_slots = list(slot_r_hand_str = "detective", slot_l_hand_str = "detective")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security2
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "redshirt2"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corporate"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corporate"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	rolled_sleeves = 0

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	item_state_slots = list(slot_r_hand_str = "green", slot_l_hand_str = "green")
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = -1

/*
 * Detective
 */
/obj/item/clothing/under/det
	name = "detective's suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks."
	icon_state = "detective"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0
	starting_accessories = list(/obj/item/clothing/accessory/tie/blue_clip)

/*
/obj/item/clothing/under/det/verb/rollup()
	set name = "Roll Suit Sleeves"
	set category = "Object"
	set src in usr
	var/unrolled = item_state_slots[slot_w_uniform_str] == initial(worn_state)
	item_state_slots[slot_w_uniform_str] = unrolled ? "[worn_state]_r" : initial(worn_state)
	var/mob/living/carbon/human/H = loc
	H.update_inv_w_uniform(1)
	to_chat(H, span_notice("You roll the sleeves of your shirt [unrolled ? "up" : "down"]"))
*/

/obj/item/clothing/under/det/grey
	icon_state = "detective2"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks."
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long)

/obj/item/clothing/under/det/black
	icon_state = "detective3"
	item_state_slots = list(slot_r_hand_str = "sl_suit", slot_l_hand_str = "sl_suit")
	desc = "An immaculate white dress shirt, paired with a pair of dark grey dress pants, a red tie, and a charcoal vest."
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/vest)

/obj/item/clothing/under/det/corporate
	name = "detective's jumpsuit"
	icon_state = "det_corporate"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	desc = "A more modern uniform for corporate investigators."

/obj/item/clothing/under/det/waistcoat
	icon_state = "detective"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks, complete with a blue striped tie, faux-gold tie clip, and waistcoat."
	starting_accessories = list(/obj/item/clothing/accessory/tie/blue_clip, /obj/item/clothing/accessory/wcoat)

/obj/item/clothing/under/det/grey/waistcoat
	icon_state = "detective2"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks, complete with a red striped tie and waistcoat."
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/wcoat)

/obj/item/clothing/under/det/black/waistcoat
	icon_state = "detective3"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks, a red tie, and a charcoal vest."
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/wcoat)

/obj/item/clothing/under/det/skirt
	name = "detective's skirt"
	icon_state = "detective_skirt"
	desc = "A serious-looking white blouse paired with a formal black pencil skirt."
	item_state_slots = list(slot_r_hand_str = "sl_suit", slot_l_hand_str = "sl_suit")

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"" + JOB_HEAD_OF_SECURITY + "\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hos"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	rolled_sleeves = 0

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "hos_corporate"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	rolled_sleeves = 0

//Jensen cosplay gear
/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"
	rolled_sleeves = -1

/*
 * Navy uniforms
 */
/obj/item/clothing/under/rank/security/navyblue
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officerblueclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/head_of_security/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the " + JOB_HEAD_OF_SECURITY + "."
	name = "head of security's uniform"
	icon_state = "hosblueclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/warden/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the " + JOB_WARDEN + "."
	name = "warden's uniform"
	icon_state = "wardenblueclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0

/*
 * Tan uniforms
 */
/obj/item/clothing/under/rank/security/tan
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officertanclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/head_of_security/tan
	desc = "The insignia on this uniform tells you that this uniform belongs to the " + JOB_HEAD_OF_SECURITY+ "."
	name = "head of security's uniform"
	icon_state = "hostanclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/warden/tan
	desc = "The insignia on this uniform tells you that this uniform belongs to the " + JOB_WARDEN + "."
	name = "warden's uniform"
	icon_state = "wardentanclothes"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0
