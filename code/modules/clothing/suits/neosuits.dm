/* Sprites ported from skyrat/tg, serves as an alternative to the virgo versions of certain clothes.
this file deals with suits/overwear. */

// labcoats

/obj/item/clothing/suit/storage/toggle/labcoat/neo_emt
	name = "EMT jacket"
	desc = "A dark blue labcoat with reflective strips for emergency medical technicians."
	icon_state = "neo_emt"
	item_state_slots = list(slot_r_hand_str = "emt_labcoat", slot_l_hand_str = "emt_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/neo_robo_coat
	name = "robotics labcoat"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_robo_coat"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_labcoat
	name = "long labcoat"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_highvis
	name = "high visibility jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_coat_highvis"
	item_state_slots = list(slot_r_hand_str = "emt_labcoat", slot_l_hand_str = "emt_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/neo_redemt
	name = "red EMT jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_redemt"
	item_state_slots = list(slot_r_hand_str = "emt_labcoat", slot_l_hand_str = "emt_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/neo_blueemt
	name = "dark blue EMT jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_blueemt"
	item_state_slots = list(slot_r_hand_str = "emt_labcoat", slot_l_hand_str = "emt_labcoat")

// generic labcoat subtypes

/obj/item/clothing/suit/storage/toggle/labcoat/neo_hos_parade
	name = "head of security's parade jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_hos_parade"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_engi_dep
	name = "engineer's department jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_engi_dep"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_cargo_dep
	name = "cargo department jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_cargo_dep"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_sci_dep
	name = "science department jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_sci_dep"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_med_dep
	name = "medical department jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_med_dep"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_sec_blue_dep
	name = "blue security department jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_sec_blue_dep"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_sec_red_dep
	name = "red security department jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_sec_red_dep"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_civ_dep
	name = "off-duty department jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_civ_dep"


/obj/item/clothing/suit/storage/toggle/labcoat/neo_police
	name = "traffic officer's jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_police"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_ranger
	name = "ranger's cloak"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_ranger"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_bodyguard_dep
	name = "bodyguard's jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_bodyguard_dep"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_hopformal
	name = "hop's formal jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_hopformal"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_bluemed
	name = "paramedic's jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_bluemed"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_hosformal_blue
	name = "head of security's blue formal jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_hosformal_blue"

/obj/item/clothing/suit/storage/toggle/labcoat/neo_leather
	name = "leather hoodie"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_leather"

// non transforming coats

/obj/item/clothing/suit/neo_armsco_trench
	name = "armsco heavy coat"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_armsco_trench"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/neo_gorka
	name = "gorka jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_gorka"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/neo_gorka_cargo
	name = "cargo gorka"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_gorka_cargo"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/neo_warden_heavy
	name = "heavy warden coat"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_warden_heavy"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/neo_runner_coat
	name = "runner's coat"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_runner_coat"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/neo_bluewarden
	name = "blue warden's jacket"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_bluewarden"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/neo_medical_coat
	name = "medical coat"
	desc = "it bears a tag that says 'Product of Total Gear & Co.'"
	icon_state = "neo_medical_coat"
	body_parts_covered = UPPER_TORSO|ARMS
