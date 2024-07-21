/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	permeability_coefficient = 0.05
	item_flags = NOSLIP
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/clothing_choices = list()
	siemens_coefficient = 0.8
	species_restricted = null
	step_volume_mod = 0.5
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "white"
	step_volume_mod = 0	//It's a mime

/obj/item/clothing/shoes/galoshes
	desc = "Rubber boots"
	name = "galoshes"
	icon_state = "galoshes"
	permeability_coefficient = 0.05
	siemens_coefficient = 0 //They're thick rubber boots! Of course they won't conduct electricity!
	item_flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+0.5
	species_restricted = null
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/clothing/shoes/dress
	name = "dress shoes"
	desc = "Sharp looking low quarters, perfect for a formal uniform."
	icon_state = "laceups"

/obj/item/clothing/shoes/dress/white
	name = "white dress shoes"
	desc = "Brilliantly white low quarters, not a spot on them."
	icon_state = "whitedress"

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	species_restricted = null
	body_parts_covered = 0

	wizard_garb = 1

/obj/item/clothing/shoes/sandals
	desc = "A pair of simple sandals."
	name = "sandals"
	icon_state = "sandals_recolor"

/obj/item/clothing/shoes/flipflop
	name = "flip flops"
	desc = "A pair of foam flip flops. For those not afraid to show a little ankle."
	icon_state = "thongsandal"
	addblends = "thongsandal_a"

/obj/item/clothing/shoes/cookflop
	name = "grilling sandals"
	desc = "All this talk of antags, greytiding, and griefing... I just wanna grill for god's sake!"
	icon_state = "cookflops"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/shoes/tourist_1
	name = "tourist sandals"
	desc = "Black sandals usually worn by tourists. Need I say more?"
	icon_state = "tourist_1"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/shoes/tourist_2
	name = "tourist sandals"
	desc = "Green sandals usually worn by tourists. Need I say more?"
	icon_state = "tourist_2"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/shoes/sandal/clogs
	name = "plastic clogs"
	desc = "A pair of plastic clog shoes."
	icon_state = "clogs"

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "magic shoes"
	icon_state = "black"
	body_parts_covered = FEET

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	slowdown = SHOES_SLOWDOWN+0.5
	force = 0
	var/footstep = 1	//used for squeeks whilst walking
	species_restricted = null

/obj/item/clothing/shoes/clown_shoes/handle_movement(var/turf/walking, var/running)
	if(running)
		if(footstep >= 2)
			footstep = 0
			playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
		else
			footstep++
	else
		playsound(src, "clownstep", 20, 1)

/obj/item/clothing/shoes/cult
	name = "boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon_state = "cult"
	item_state_slots = list(slot_r_hand_str = "cult", slot_l_hand_str = "cult")
	force = 2
	siemens_coefficient = 0.7

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = null

/obj/item/clothing/shoes/cult/cultify()
	return

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume"
	icon_state = "boots"

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	force = 0
	species_restricted = null
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/clothing.ogg'
	pickup_sound = 'sound/items/pickup/clothing.ogg'

/obj/item/clothing/shoes/slippers/worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state_slots = list(slot_r_hand_str = "slippers", slot_l_hand_str = "slippers")

/obj/item/clothing/shoes/laceup
	name = "black oxford shoes"
	icon_state = "oxford_black"

/obj/item/clothing/shoes/laceup/grey
	name = "grey oxford shoes"
	icon_state = "oxford_grey"

/obj/item/clothing/shoes/laceup/brown
	name = "brown oxford shoes"
	icon_state = "oxford_brown"

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	item_state_slots = list(slot_r_hand_str = "galoshes", slot_l_hand_str = "galoshes")
	item_flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+0.5
	species_restricted = null

/obj/item/clothing/shoes/athletic
	name = "athletic shoes"
	desc = "A pair of sleek athletic shoes. Made by and for the sporty types."
	icon_state = "sportshoe"
	addblends = "sportshoe_a"
	item_state_slots = list(slot_r_hand_str = "sportheld", slot_l_hand_str = "sportheld")

/obj/item/clothing/shoes/skater
	name = "skater shoes"
	desc = "A pair of wide shoes with thick soles.  Designed for skating."
	icon_state = "skatershoe"
	addblends = "skatershoe_a"
	item_state_slots = list(slot_r_hand_str = "skaterheld", slot_l_hand_str = "skaterheld")

/obj/item/clothing/shoes/heels
	name = "high heels"
	desc = "A pair of high-heeled shoes. Fancy!"
	icon_state = "heels"
	addblends = "heels_a"

/obj/item/clothing/shoes/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated canvas used for wrapping claws or paws"
	icon_state = "clothwrap"
	item_state = "clothwrap"
	force = 0
	w_class = ITEMSIZE_SMALL
	species_restricted = null
	drop_sound = 'sound/items/drop/clothing.ogg'
	pickup_sound = 'sound/items/pickup/clothing.ogg'

/obj/item/clothing/shoes/boots/ranger
	var/bootcolor = "white"
	name = "ranger boots"
	desc = "The Rangers special lightweight hybrid magboots-jetboots perfect for EVA. If only these functions were so easy to copy in reality.\
	 These ones are just a well-made pair of boots in appropriate colours."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_boots"

/obj/item/clothing/shoes/boots/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_boots")
		name = "[bootcolor] ranger boots"
		icon_state = "[bootcolor]_ranger_boots"

/obj/item/clothing/shoes/boots/ranger/black
	bootcolor = "black"

/obj/item/clothing/shoes/boots/ranger/pink
	bootcolor = "pink"

/obj/item/clothing/shoes/boots/ranger/green
	bootcolor = "green"

/obj/item/clothing/shoes/boots/ranger/cyan
	bootcolor = "cyan"

/obj/item/clothing/shoes/boots/ranger/orange
	bootcolor = "orange"

/obj/item/clothing/shoes/boots/ranger/yellow
	bootcolor = "yellow"

/*
 * 80s
 */

/obj/item/clothing/shoes/sneakerspurple
	name = "purple sneakers"
	desc = "A stylish, expensive pair of purple sneakers."
	icon_state = "sneakerspurple"
	item_state = "sneakerspurple"

/obj/item/clothing/shoes/sneakersblue
	name = "blue sneakers"
	desc = "A stylish, expensive pair of blue sneakers."
	icon_state = "sneakersblue"
	item_state = "sneakersblue"

/obj/item/clothing/shoes/sneakersred
	name = "red sneakers"
	desc = "A stylish, expensive pair of red sneakers."
	icon_state = "sneakersred"
	item_state = "sneakersred"

/obj/item/clothing/shoes/ballet
	name = "pointe shoes"
	desc = "These shoes feature long lace straps and flattened off toes. Great for the most elegant of dances!"
	icon_state = "ballet"
	item_state = "ballet"
