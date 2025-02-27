/obj/item/clothing/head/hood
	name = "hood"
	desc = "A generic hood."
	icon_state = "chaplain_hood" //just default to this, whatever. default_hood never existed.
	flags_inv = HIDEEARS | BLOCKHAIR

// Winter coats
/obj/item/clothing/head/hood/winter
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "winterhood"
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hood/winter/captain
	name = "site manager's winter hood"
	desc = "A blue and yellow hood attached to a heavy winter jacket."
	icon_state = "winterhood_captain"
	armor = list(melee = 20, bullet = 15, laser = 20, energy = 10, bomb = 15, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/hop
	name = "head of personnel's winter hood"
	desc = "A cozy winter hood attached to a heavy winter jacket."
	icon_state = "winterhood_hop"

/obj/item/clothing/head/hood/winter/security
	name = "security winter hood"
	desc = "A red, armor-padded winter hood."
	icon_state = "winterhood_security"
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 15, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/security/hos
	name = "head of security's winter hood"
	desc = "A red, armor-padded winter hood, lovingly woven with a Kevlar interleave. Definitely not bulletproof, especially not the part where your face goes."
	icon_state = "winterhood_hos"
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 15, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/medical
	name = "medical winter hood"
	desc = "A white winter coat hood."
	icon_state = "winterhood_medical"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/head/hood/winter/medical/alt
	name = "medical winter hood, alt"
	desc = "A white winter coat hood. It's warm."
	icon_state = "winterhood_medicalalt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/head/hood/winter/medical/viro
	name = "virologist winter hood"
	desc = "A white winter coat hood with green markings."
	icon_state = "winterhood_viro"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/head/hood/winter/medical/para
	name = "paramedic winter hood"
	desc = "A white winter coat hood with blue markings."
	icon_state = "winterhood_medicalalt" //winterhood_para didn't exist, so...Sorry, paramedic.
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/head/hood/winter/medical/chemist
	name = "chemist winter hood"
	desc = "A white winter coat hood."
	icon_state = "winterhood_chemist"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/head/hood/winter/medical/cmo
	name = "chief medical officer's winter hood"
	desc = "A white winter coat hood."
	icon_state = "winterhood_cmo"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/head/hood/winter/science
	name = "science winter hood"
	desc = "A white winter coat hood. This one will keep your brain warm. About as much as the others, really."
	icon_state = "winterhood_science"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/science/robotics
	name = "science winter hood"
	desc = "A black winter coat hood. You can pull it down over your eyes and pretend that you're an outdated, late 1980s interpretation of a futuristic mechanized police force. They'll fix you. They fix everything."
	icon_state = "winterhood_robotics"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/science/rd
	name = "research director's winter hood"
	desc = "A white winter coat hood. It smells faintly of slightly unethical ideas."
	icon_state = "winterhood_rd"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)


/obj/item/clothing/head/hood/winter/engineering
	name = "engineering winter hood"
	desc = "A yellow winter coat hood. Definitely not a replacement for a hard hat."
	icon_state = "winterhood_engineer"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)

/obj/item/clothing/head/hood/winter/engineering/atmos
	name = "atmospherics winter hood"
	desc = "A yellow and blue winter coat hood."
	icon_state = "winterhood_atmos"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)

/obj/item/clothing/head/hood/winter/engineering/ce
	name = "chief engineer's winter hood"
	desc = "A white winter coat hood. Feels surprisingly heavy. The tag says that it's not child safe."
	icon_state = "winterhood_ce"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)

/obj/item/clothing/head/hood/winter/hydro
	name = "hydroponics winter hood"
	desc = "A green winter coat hood."
	icon_state = "winterhood_hydro"

/obj/item/clothing/head/hood/winter/cargo
	name = "cargo winter hood"
	desc = "A grey hood for a winter coat."
	icon_state = "winterhood_cargo"

/obj/item/clothing/head/hood/winter/cargo/miner
	name = "mining winter hood"
	desc = "A dusty winter coat hood."
	icon_state = "winterhood_miner"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/hood/winter/cargo/qm
	name = "quartermaster's winter hood"
	desc = "A dark brown winter coat hood."
	icon_state = "winterhood_qm"

/obj/item/clothing/head/hood/winter/bar
	name = "bartender winter hood"
	desc = "A white winter coat hood."
	icon_state = "winterhood_bar"

/obj/item/clothing/head/hood/winter/janitor
	name = "janitor winter hood"
	desc = "A purple hood that smells of space cleaner."
	icon_state = "winterhood_janitor"

/obj/item/clothing/head/hood/winter/aformal
	name = "assistant formal winter hood"
	desc = "A black winter coat hood."
	icon_state = "winterhood_aformal"

/obj/item/clothing/head/hood/winter/ratvar
	name = "brassy winter hood"
	desc = "A brass-plated winter hood that glows softly, hinting at its divinity."
	icon_state = "winterhood_ratvar"
	light_range = 3
	light_power = 1
	light_color = "#B18B25" //clockwork slab background top color
	light_on = TRUE

/obj/item/clothing/head/hood/winter/narsie
	name = "runed winter hood"
	desc = "A black winter hood full of whispering secrets that only She shall ever know."
	icon_state = "winterhood_narsie"

/obj/item/clothing/head/hood/winter/cosmic
	name = "cosmic winter hood"
	desc = "A starry winter hood."
	icon_state = "winterhood_cosmic"

/obj/item/clothing/head/hood/winter/christmasred
	name = "red christmas winter hood"
	desc = "A red festive winter hood."
	icon_state = "winterhood_christmasr"

/obj/item/clothing/head/hood/winter/christmasgreen
	name = "green christmas winter hood"
	desc = "A green festive winter hood."
	icon_state = "winterhood_christmasg"

// Explorer gear
/obj/item/clothing/head/hood/explorer
	name = "explorer hood"
	desc = "An armoured hood for exploring harsh environments."
	icon_state = "explorer"
	flags = THICKMATERIAL
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 35, bio = 75, rad = 35)

// Costumes
/obj/item/clothing/head/hood/carp_hood
	name = "carp hood"
	desc = "A hood attached to a carp costume."
	icon_state = "carp_casual"
	item_state_slots = list(slot_r_hand_str = "carp_casual", slot_l_hand_str = "carp_casual") //Does not exist -S2-
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE	//Space carp like space, so you should too

/obj/item/clothing/head/hood/ian_hood
	name = "corgi hood"
	desc = "A hood that looks just like a corgi's head, it won't guarantee dog biscuits."
	icon_state = "ian"
	item_state_slots = list(slot_r_hand_str = "ian", slot_l_hand_str = "ian") //Does not exist -S2-

//Techpriest
/obj/item/clothing/head/hood/techpriest
	name = "techpriest hood"
	desc = "A techpriest hood."
	icon_state = "techpriesthood"

/obj/item/clothing/head/hood/siffet_hood
	name = "siffet hood"
	desc = "A hood that looks vaguely like a siffet's head. Guaranteed to traumatize your Promethean coworkers."
	icon_state = "siffet"
	item_state_slots = list(slot_r_hand_str = "siffet", slot_l_hand_str = "siffet")

/obj/item/clothing/head/hood/hoodie
	name = "hood"
	desc = "The hood of a hoodie. Cosy!"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "hood_plain"

/obj/item/clothing/head/hood/raincoat
	name = "raincoat hood"
	desc = "A hood attached to a raincoat."
	icon_state = "raincoat"

//hooded cloak hoods
/obj/item/clothing/head/hood/cloak
    name  = "maroon cloak hood"
    desc = "A hood attached to a maroon cloak."
    icon_state = "maroon_cloakhood"
    flags_inv = HIDEEARS|BLOCKHAIR

/obj/item/clothing/head/hood/cloak/winter
    name = "winter cloak hood"
    desc = "A hood attached to a winter cloak."
    icon_state = "winter_cloakhood"

/obj/item/clothing/head/hood/cloak/asymmetric
    name = "asymmetric cloak hood"
    desc = "A hood attached to an asymmetric cloak."
    icon_state = "asymmetric_cloakhood"

/obj/item/clothing/head/hood/cloak/fancy
    name = "fancy cloak hood"
    desc = "A hood attached to a fancy cloak."
    icon_state = "hb_cloakhood"
