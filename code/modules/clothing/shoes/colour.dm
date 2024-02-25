
/obj/item/clothing/shoes/black
	name = "black shoes"
	icon_state = "black"
	desc = "A pair of black shoes."

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"

/obj/item/clothing/shoes/blue
	name = "blue shoes"
	icon_state = "blue"

/obj/item/clothing/shoes/green
	name = "green shoes"
	icon_state = "green"

/obj/item/clothing/shoes/yellow
	name = "yellow shoes"
	icon_state = "yellow"

/obj/item/clothing/shoes/purple
	name = "purple shoes"
	icon_state = "purple"

/obj/item/clothing/shoes/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"

/obj/item/clothing/shoes/white
	name = "white shoes"
	icon_state = "white"
	permeability_coefficient = 0.01

/obj/item/clothing/shoes/rainbow
	name = "rainbow shoes"
	desc = "Very colourful shoes."
	icon_state = "rain_bow"

/obj/item/clothing/shoes/flats
	name = "black flats"
	desc = "Sleek black flats."
	icon_state = "flatsblack"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")

/obj/item/clothing/shoes/flats/white
	name = "white flats"
	desc = "Shiny white flats."
	icon_state = "flatswhite"
	addblends = "flatswhite_a"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")

/obj/item/clothing/shoes/flats/white/color
	name = "flats"
	desc = "Sleek flats."

/obj/item/clothing/shoes/flats/red
	name = "red flats"
	desc = "Ruby red flats."
	icon_state = "flatsred"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/obj/item/clothing/shoes/flats/purple
	name = "purple flats"
	desc = "Royal purple flats."
	icon_state = "flatspurple"
	item_state_slots = list(slot_r_hand_str = "purple", slot_l_hand_str = "purple")

/obj/item/clothing/shoes/flats/blue
	name = "blue flats"
	desc = "Sleek blue flats."
	icon_state = "flatsblue"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")

/obj/item/clothing/shoes/flats/brown
	name = "brown flats"
	desc = "Sleek brown flats."
	icon_state = "flatsbrown"
	item_state_slots = list(slot_r_hand_str = "brown", slot_l_hand_str = "brown")

/obj/item/clothing/shoes/flats/orange
	name = "orange flats"
	desc = "Radiant orange flats."
	icon_state = "flatsorange"
	item_state_slots = list(slot_r_hand_str = "orange", slot_l_hand_str = "orange")

/obj/item/clothing/shoes/orange
	name = "orange shoes"
	icon_state = "orange"
	var/obj/item/weapon/handcuffs/chained = null

/obj/item/clothing/shoes/orange/proc/attach_cuffs(var/obj/item/weapon/handcuffs/cuffs, mob/user as mob)
	if (chained) return

	user.drop_item()
	cuffs.loc = src
	chained = cuffs
	slowdown = 15
	icon_state = "orange1"

/obj/item/clothing/shoes/orange/proc/remove_cuffs(mob/user as mob)
	if (!chained) return

	user.put_in_hands(chained)
	chained.add_fingerprint(user)

	slowdown = initial(slowdown)
	icon_state = "orange"
	chained = null

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	..()
	remove_cuffs(user)

/obj/item/clothing/shoes/orange/attackby(H as obj, mob/user as mob)
	..()
	if (istype(H, /obj/item/weapon/handcuffs))
		attach_cuffs(H, user)

/obj/item/clothing/shoes/hitops
	name = "white high-tops"
	desc = "A pair of shoes that extends past the ankle. Based on a centuries-old, timeless design."
	icon_state = "whitehi"

/obj/item/clothing/shoes/hitops/red
	name = "red high-tops"
	icon_state = "redhi"

/obj/item/clothing/shoes/hitops/brown
	name = "brown high-tops"
	icon_state = "brownhi"

/obj/item/clothing/shoes/hitops/black
	name = "black high-tops"
	icon_state = "blackhi"

/obj/item/clothing/shoes/hitops/orange
	name = "orange high-tops"
	icon_state = "orangehi"

/obj/item/clothing/shoes/hitops/blue
	name = "blue high-tops"
	icon_state = "bluehi"

/obj/item/clothing/shoes/hitops/green
	name = "green high-tops"
	icon_state = "greenhi"

/obj/item/clothing/shoes/hitops/purple
	name = "purple high-tops"
	icon_state = "purplehi"

/obj/item/clothing/shoes/hitops/yellow
	name = "yellow high-tops"
	icon_state = "yellowhi"