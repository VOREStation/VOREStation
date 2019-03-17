
//Bartender
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chefhat"

//Captain
/obj/item/clothing/head/caphat
	name = "colony director's hat"
	icon_state = "captain"
	desc = "It's good being the king."
	body_parts_covered = 0

/obj/item/clothing/head/caphat/cap
	name = "colony director's cap"
	desc = "You fear to wear it for the negligence it brings."
	icon_state = "capcap"

/obj/item/clothing/head/caphat/formal
	name = "parade hat"
	desc = "No one in a commanding position should be without a perfect, white hat of ultimate authority."
	icon_state = "officercap"

//HOP
/obj/item/clothing/head/caphat/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"

//Chaplain
/obj/item/clothing/head/chaplain_hood
	name = "chaplain's hood"
	desc = "It's a hood that covers the head. It keeps you warm during the space winters."
	icon_state = "chaplain_hood"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

//Chaplain but spookier
/obj/item/clothing/head/chaplain_hood/whiteout
	name = "white hood"
	desc = "It's a generic white hood. Very spooky."
	icon_state = "whiteout_hood"
	item_state_slots = list(slot_r_hand_str = "beret_white", slot_l_hand_str = "beret_white")

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

//Mime
/obj/item/clothing/head/beret
	name = "beret"
	desc = "A beret, an artists favorite headwear."
	icon_state = "beret"
	body_parts_covered = 0

//Security
/obj/item/clothing/head/beret/sec
	name = "security beret"
	desc = "A beret with the security insignia emblazoned on it. For officers that are more inclined towards style than safety."
	icon_state = "beret_officer"
	item_state_slots = list(slot_r_hand_str = "beret", slot_l_hand_str = "beret")

/obj/item/clothing/head/beret/sec/navy/officer
	name = "officer beret"
	desc = "A navy blue beret with an officer's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_navy_officer"
	item_state_slots = list(slot_r_hand_str = "beret_navy", slot_l_hand_str = "beret_navy")

/obj/item/clothing/head/beret/sec/navy/hos
	name = "Head of Security beret"
	desc = "A navy blue beret with a Head of Security's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_navy_hos"
	item_state_slots = list(slot_r_hand_str = "beret_navy", slot_l_hand_str = "beret_navy")

/obj/item/clothing/head/beret/sec/navy/warden
	name = "warden beret"
	desc = "A navy blue beret with a warden's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_navy_warden"
	item_state_slots = list(slot_r_hand_str = "beret_navy", slot_l_hand_str = "beret_navy")

/obj/item/clothing/head/beret/sec/corporate/officer
	name = "officer beret"
	desc = "A corporate black beret with an officer's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_officer"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")

/obj/item/clothing/head/beret/sec/corporate/hos
	name = "Head of Security beret"
	desc = "A corporate black beret with a Head of Security's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_hos"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")

/obj/item/clothing/head/beret/sec/corporate/warden
	name = "warden beret"
	desc = "A corporate black beret with a warden's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_warden"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")

/obj/item/clothing/head/helmet/warden
	name = "warden's helmet"
	desc = "Standard Warden gear. Protects the head from impacts."

/obj/item/clothing/head/helmet/warden/hat
	name = "warden's hat"
	desc = "It's a special hat issued to the Warden of a securiy force."
	icon_state = "policehelm"
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/HoS
	name = "Head of Security helmet"
	desc = "Standard Head of Security gear. Protects the head from impacts."

/obj/item/clothing/head/helmet/HoS/hat
	name = "Head of Security Hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/dermal
	name = "Dermal Armour Patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	item_state_slots = list(slot_r_hand_str = "", slot_l_hand_str = "")
	valid_accessory_slots = null
	show_examine = FALSE
	flags_inv = null

/obj/item/clothing/head/det
	name = "fedora"
	desc = "A brown fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."
	icon_state = "detective"
	allowed = list(/obj/item/weapon/reagent_containers/food/snacks/candy_corn, /obj/item/weapon/pen)
	armor = list(melee = 10, bullet = 10, laser = 15, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	valid_accessory_slots = null
	show_examine = FALSE

/obj/item/clothing/head/det/grey
	icon_state = "detective2"
	item_state_slots = list(slot_r_hand_str = "detective", slot_l_hand_str = "detective")
	desc = "A grey fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."

/obj/item/clothing/head/beret/engineering
	name = "engineering beret"
	desc = "A beret with the engineering insignia emblazoned on it. For engineers that are more inclined towards style than safety."
	icon_state = "beret_orange"

/obj/item/clothing/head/beret/purple
	name = "purple beret"
	desc = "A stylish, if purple, beret."
	icon_state = "beret_purpleyellow"

/obj/item/clothing/head/beret/centcom/officer
	name = "officers beret"
	desc = "A dark blue beret adorned with a silver patch. Worn by NanoTrasen Officials."
	icon_state = "beret_centcom_officer"
	item_state_slots = list(slot_r_hand_str = "beret_white", slot_l_hand_str = "beret_white")

/obj/item/clothing/head/beret/centcom/captain
	name = "captains beret"
	desc = "A white beret adorned with a blue patch. Worn by NanoTrasen command staff."
	icon_state = "beret_centcom_captain"
	item_state_slots = list(slot_r_hand_str = "beret_white", slot_l_hand_str = "beret_white")

/obj/item/clothing/head/beret/sec/gov
	name = "officer beret"
	desc = "A black beret with a gold emblem."
	icon_state = "beret_corporate_hos"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")

//Medical
/obj/item/clothing/head/surgery
	name = "surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	icon_state = "surgcap_blue"
	item_state_slots = list(slot_r_hand_str = "beret_blue", slot_l_hand_str = "beret_blue")
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/surgery/purple
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is deep purple."
	icon_state = "surgcap_purple"
	item_state_slots = list(slot_r_hand_str = "beret_purple", slot_l_hand_str = "beret_purple")

/obj/item/clothing/head/surgery/blue
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is baby blue."
	icon_state = "surgcap_blue"
	item_state_slots = list(slot_r_hand_str = "beret_blue", slot_l_hand_str = "beret_blue")

/obj/item/clothing/head/surgery/green
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is dark green."
	icon_state = "surgcap_green"
	item_state_slots = list(slot_r_hand_str = "beret_green", slot_l_hand_str = "beret_green")

/obj/item/clothing/head/surgery/black
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is black."
	icon_state = "surgcap_black"
	item_state_slots = list(slot_r_hand_str = "beret_black", slot_l_hand_str = "beret_black")

/obj/item/clothing/head/surgery/navyblue
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is navy blue."
	icon_state = "surgcap_navyblue"
	item_state_slots = list(slot_r_hand_str = "beret_navy", slot_l_hand_str = "beret_navy")
