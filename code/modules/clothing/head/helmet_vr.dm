/obj/item/clothing/head/helmet/solgov
	name = "\improper Solar Central Government helmet"
	desc = "A helmet painted in Peacekeeper blue. Stands out like a sore thumb."

/obj/item/clothing/head/helmet/solgov/command
	name = "\improper Solar Central commander helmet"
	desc = "A helmet with 'Solar Central Government' printed on the back in gold lettering."

/obj/item/clothing/head/helmet/combat/USDF
	name = "marine helmet"
	desc = "If you wanna to keep your brain inside yo' head, you'd best put this on!"
	icon_state = "unsc_helm"
	item_state = "unsc_helm"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/head/helmet/combat/imperial
	name = "imperial soldier helmet"
	desc = "Veni, vidi, vici; I came, I saw, I conquered."
	icon_state = "ge_helm"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/head/helmet/combat/imperial/centurion
	name = "imperial centurion helmet"
	desc = "Vendi, vidi, visa; I came, I saw, I realised this hat was too expensive."
	icon_state = "ge_helmcent"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/head/helmet/fish
	name = "fish skull"
	desc = "You... you're not actually going to wear that, right?"
	icon_state = "fishskull"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'
	flags_inv = HIDEEARS|BLOCKHAIR
	item_state_slots = list(slot_r_hand_str = "fishk", slot_l_hand_str = "fisk")