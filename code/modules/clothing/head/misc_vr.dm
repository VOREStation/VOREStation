/obj/item/clothing/head/centhat/customs
	desc = "A formal hat for SolCom Customs Officers."

/obj/item/clothing/head/fish
	name = "fish skull"
	desc = "You... you're not actually going to wear that, right?"
	icon_state = "fishskull"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'
	flags_inv = HIDEEARS|BLOCKHAIR

/obj/item/clothing/head/crown
	name = "crown"
	desc = "How regal!"
	icon_state = "crown"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/head/fancy_crown
	name = "fancy crown"
	desc = "How extraordinarily regal!"
	icon_state = "fancycrown"
	icon = 'icons/obj/clothing/hats_vr.dmi'
	icon_override = 'icons/mob/head_vr.dmi'

/obj/item/clothing/head/shiny_hood
	icon_override = 'icons/mob/modular_shiny_vr.dmi'
	icon = 'icons/obj/clothing/modular_shiny_vr.dmi'
	name = "shiny hood"
	desc = "You can be a super-hero in this! Just don't forget your suit!"
	icon_state = "hood_o"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = FACE|HEAD

/obj/item/clothing/head/shiny_hood/poly
	name = "polychromic shiny hood"
	icon_state = "hood_col_o"
	polychromic = TRUE

/obj/item/clothing/head/shiny_hood/closed
	name = "shiny hood"
	desc = "You can be a super-hero in this! Just don't forget your superhuman senses!"
	icon_state = "hood_c"
	gas_transfer_coefficient = 0.90

/obj/item/clothing/head/shiny_hood/closed/poly
	name = "polychromic closed shiny hood"
	icon_state = "hood_col_o"
	polychromic = TRUE