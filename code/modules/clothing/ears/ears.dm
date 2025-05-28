/*
	Earmuffs
*/
/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon = 'icons/obj/items.dmi'
	icon_state = "earmuffs"
	item_state_slots = list(slot_r_hand_str = "earmuffs", slot_l_hand_str = "earmuffs")
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	ear_protection = 2

/obj/item/clothing/ears/earmuffs/headphones
	name = "headphones"
	desc = "Unce unce unce unce."
	var/headphones_on = 0
	icon_state = "headphones_off"
	item_state_slots = list(slot_r_hand_str = "headphones", slot_l_hand_str = "headphones")
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earmuffs/headphones/verb/togglemusic()
	set name = "Toggle Headphone Music"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
	if(usr.stat) return

	var/base_icon = copytext(icon_state,1,(length(icon_state) - 3 + headphones_on))

	if(headphones_on)
		icon_state = "[base_icon]_off"
		headphones_on = 0
		to_chat(usr, span_notice("You turn the music off."))
	else
		icon_state = "[base_icon]_on"
		headphones_on = 1
		to_chat(usr, span_notice("You turn the music on."))

	update_clothing_icon()

/*
	Skrell tentacle wear
*/
/obj/item/clothing/ears/skrell
	name = DEVELOPER_WARNING_NAME // "skrell tentacle wear"
	desc = "Some stuff worn by skrell to adorn their head tentacles."
	icon = 'icons/inventory/ears/item.dmi'
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	species_restricted = list(SPECIES_SKRELL)

/obj/item/clothing/ears/skrell/chain
	name = "Gold headtail chains"
	desc = "A delicate golden chain worn by female skrell to decorate their head tails."
	icon_state = "skrell_chain"
	item_state_slots = list(slot_r_hand_str = "egg5", slot_l_hand_str = "egg5")
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/ears/skrell/chain/silver
	name = "Silver headtail chains"
	desc = "A delicate silver chain worn by female skrell to decorate their head tails."
	icon_state = "skrell_chain_sil"
	item_state_slots = list(slot_r_hand_str = "egg", slot_l_hand_str = "egg")

/obj/item/clothing/ears/skrell/chain/bluejewels
	name = "Blue jeweled golden headtail chains"
	desc = "A delicate golden chain adorned with blue jewels worn by female skrell to decorate their head tails."
	icon_state = "skrell_chain_bjewel"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/chain/redjewels
	name = "Red jeweled golden headtail chains"
	desc = "A delicate golden chain adorned with red jewels worn by female skrell to decorate their head tails."
	icon_state = "skrell_chain_rjewel"
	item_state_slots = list(slot_r_hand_str = "egg4", slot_l_hand_str = "egg4")

/obj/item/clothing/ears/skrell/chain/ebony
	name = "Ebony headtail chains"
	desc = "A delicate ebony chain worn by female skrell to decorate their head tails."
	icon_state = "skrell_chain_ebony"
	item_state_slots = list(slot_r_hand_str = "egg6", slot_l_hand_str = "egg6")

/obj/item/clothing/ears/skrell/band
	name = "Gold headtail bands"
	desc = "Golden metallic bands worn by male skrell to adorn their head tails."
	icon_state = "skrell_band"
	item_state_slots = list(slot_r_hand_str = "egg5", slot_l_hand_str = "egg5")
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/ears/skrell/band/silver
	name = "Silver headtail bands"
	desc = "Silver metallic bands worn by male skrell to adorn their head tails."
	icon_state = "skrell_band_sil"
	item_state_slots = list(slot_r_hand_str = "egg", slot_l_hand_str = "egg")

/obj/item/clothing/ears/skrell/band/bluejewels
	name = "Blue jeweled golden headtail bands"
	desc = "Golden metallic bands adorned with blue jewels worn by male skrell to adorn their head tails."
	icon_state = "skrell_band_bjewel"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/band/redjewels
	name = "Red jeweled golden headtail bands"
	desc = "Golden metallic bands adorned with red jewels worn by male skrell to adorn their head tails."
	icon_state = "skrell_band_rjewel"
	item_state_slots = list(slot_r_hand_str = "egg4", slot_l_hand_str = "egg4")

/obj/item/clothing/ears/skrell/band/ebony
	name = "Ebony headtail bands"
	desc = "Ebony bands worn by male skrell to adorn their head tails."
	icon_state = "skrell_band_ebony"
	item_state_slots = list(slot_r_hand_str = "egg6", slot_l_hand_str = "egg6")

/obj/item/clothing/ears/skrell/colored/band
	name = "Colored headtail bands"
	desc = "Metallic bands worn by male skrell to adorn their head tails."
	icon_state = "skrell_band_sil"
	item_state_slots = list(slot_r_hand_str = "egg", slot_l_hand_str = "egg")

/obj/item/clothing/ears/skrell/colored/chain
	name = "Colored headtail chains"
	desc = "A delicate chain worn by female skrell to decorate their head tails."
	icon_state = "skrell_chain_sil"
	item_state_slots = list(slot_r_hand_str = "egg", slot_l_hand_str = "egg")

/obj/item/clothing/ears/skrell/cloth_female
	name = "red headtail cloth"
	desc = "A cloth shawl worn by female skrell draped around their head tails."
	icon_state = "skrell_cloth_female"
	item_state_slots = list(slot_r_hand_str = "egg4", slot_l_hand_str = "egg4")

/obj/item/clothing/ears/skrell/cloth_female/black
	name = "black headtail cloth"
	icon_state = "skrell_cloth_black_female"
	item_state_slots = list(slot_r_hand_str = "egg6", slot_l_hand_str = "egg6")

/obj/item/clothing/ears/skrell/cloth_female/blue
	name = "blue headtail cloth"
	icon_state = "skrell_cloth_blue_female"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/cloth_female/green
	name = "green headtail cloth"
	icon_state = "skrell_cloth_green_female"
	item_state_slots = list(slot_r_hand_str = "egg3", slot_l_hand_str = "egg3")

/obj/item/clothing/ears/skrell/cloth_female/pink
	name = "pink headtail cloth"
	icon_state = "skrell_cloth_pink_female"
	item_state_slots = list(slot_r_hand_str = "egg1", slot_l_hand_str = "egg1")

/obj/item/clothing/ears/skrell/cloth_female/lightblue
	name = "light blue headtail cloth"
	icon_state = "skrell_cloth_lblue_female"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/cloth_male
	name = "red headtail cloth"
	desc = "A cloth band worn by male skrell around their head tails."
	icon_state = "skrell_cloth_male"
	item_state_slots = list(slot_r_hand_str = "egg4", slot_l_hand_str = "egg4")

/obj/item/clothing/ears/skrell/cloth_male/black
	name = "black headtail cloth"
	icon_state = "skrell_cloth_black_male"
	item_state_slots = list(slot_r_hand_str = "egg6", slot_l_hand_str = "egg6")

/obj/item/clothing/ears/skrell/cloth_male/blue
	name = "blue headtail cloth"
	icon_state = "skrell_cloth_blue_male"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")

/obj/item/clothing/ears/skrell/cloth_male/green
	name = "green headtail cloth"
	icon_state = "skrell_cloth_green_male"
	item_state_slots = list(slot_r_hand_str = "egg3", slot_l_hand_str = "egg3")

/obj/item/clothing/ears/skrell/cloth_male/pink
	name = "pink headtail cloth"
	icon_state = "skrell_cloth_pink_male"
	item_state_slots = list(slot_r_hand_str = "egg1", slot_l_hand_str = "egg1")

/obj/item/clothing/ears/skrell/cloth_male/lightblue
	name = "light blue headtail cloth"
	icon_state = "skrell_cloth_lblue_male"
	item_state_slots = list(slot_r_hand_str = "egg2", slot_l_hand_str = "egg2")
