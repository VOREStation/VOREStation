/*
 * Science
 */
/obj/item/clothing/under/rank/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Research Director\". Its fabric provides minor protection from biological contaminants."
	name = "research director's jumpsuit"
	icon_state = "director"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/research_director/rdalt
	desc = "A dress suit and slacks stained with hard work and dedication to science. Perhaps other things as well, but mostly hard work and dedication."
	name = "head researcher uniform"
	icon_state = "rdalt"
	item_state_slots = list(slot_r_hand_str = "director", slot_l_hand_str = "director")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/research_director/dress_rd
	name = "research director dress uniform"
	desc = "Feminine fashion for the style conscious RD. Its fabric provides minor protection from biological contaminants."
	icon_state = "dress_rd"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/scientist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's jumpsuit"
	icon_state = "science"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/scientist/turtleneck
	name = "science turtleneck"
	desc = "It's a stylish turtleneck weaved with an explosive-resistant, comfortable mesh. You don't have to look like a dork to be a dork."
	icon_state = "turtle_sci"
	item_state_slots = list(slot_r_hand_str = "purple", slot_l_hand_str = "purple")
	rolled_down = -1
	rolled_sleeves = -1

/obj/item/clothing/under/rank/chemist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a chemist rank stripe on it."
	name = "chemist's jumpsuit"
	icon_state = "chemistry"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/*
 * Medical
 */
/obj/item/clothing/under/rank/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon_state = "cmo"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon_state = "genetics"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon_state = "virology"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/nursesuit
	desc = "It's a jumpsuit commonly worn by nursing staff in the medical department."
	name = "nurse's suit"
	icon_state = "nursesuit"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	rolled_sleeves = -1

/obj/item/clothing/under/rank/nurse
	desc = "A dress commonly worn by the nursing staff in the medical department."
	name = "nurse's dress"
	icon_state = "nurse"
	item_state_slots = list(slot_r_hand_str = "nursesuit", slot_l_hand_str = "nursesuit")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	rolled_sleeves = -1

/obj/item/clothing/under/rank/orderly
	desc = "A white suit to be worn by medical attendants."
	name = "orderly's uniform"
	icon_state = "orderly"
	item_state_slots = list(slot_r_hand_str = "nursesuit", slot_l_hand_str = "nursesuit")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/medical
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	name = "medical doctor's jumpsuit"
	icon_state = "medical"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/medical/turtleneck
	name = "medical turtleneck"
	desc = "It's a stylish turtleneck made of bioresistant fiber. Look good, save lives- what more could you want?"
	icon_state = "turtle_med"
	rolled_down = -1
	rolled_sleeves = -1

/obj/item/clothing/under/rank/medical/paramedic
	name = "short sleeve medical jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one has a cross on the chest denoting that the wearer is trained medical personnel."
	icon_state = "medical_short"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	rolled_sleeves = -1

/obj/item/clothing/under/rank/medical/scrubs
	name = "blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in baby blue."
	icon_state = "scrubsblue"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")

/obj/item/clothing/under/rank/medical/scrubs/green
	name = "green scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	icon_state = "scrubsgreen"
	item_state_slots = list(slot_r_hand_str = "green", slot_l_hand_str = "green")

/obj/item/clothing/under/rank/medical/scrubs/purple
	name = "purple scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in deep purple."
	icon_state = "scrubspurple"
	item_state_slots = list(slot_r_hand_str = "purple", slot_l_hand_str = "purple")

/obj/item/clothing/under/rank/medical/scrubs/black
	name = "black scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in black."
	icon_state = "scrubsblack"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")

/obj/item/clothing/under/rank/medical/scrubs/navyblue
	name = "navy blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in navy blue."
	icon_state = "scrubsnavyblue"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")

/obj/item/clothing/under/rank/medical/scrubs/white
	name = "scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards"
	icon_state = "scrubs"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	index = 1

/obj/item/clothing/under/rank/psych
	desc = "A basic white jumpsuit. It has turqouise markings that denote the wearer as a psychiatrist."
	name = "psychiatrist's jumpsuit"
	icon_state = "psych"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")

/obj/item/clothing/under/rank/psych/turtleneck
	desc = "A turqouise turtleneck and a pair of dark blue slacks, belonging to a psychologist."
	name = "psychologist's turtleneck"
	icon_state = "psychturtle"
	item_state_slots = list(slot_r_hand_str = "psyche", slot_l_hand_str = "psyche")
	rolled_sleeves = 0

/*
 * Medsci, unused (i think) stuff
 */
/obj/item/clothing/under/rank/geneticist_new
	desc = "It's made of a special fiber which provides minor protection against biohazards."
	name = "geneticist's jumpsuit"
	icon_state = "genetics_new"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/chemist_new
	desc = "It's made of a special fiber which provides minor protection against biohazards."
	name = "chemist's jumpsuit"
	icon_state = "chemist_new"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/scientist_new
	desc = "Made of a special fiber that gives special protection against biohazards and small explosions."
	name = "scientist's jumpsuit"
	icon_state = "scientist_new"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/virologist_new
	desc = "Made of a special fiber that gives increased protection against biohazards."
	name = "virologist's jumpsuit"
	icon_state = "virologist_new"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0
