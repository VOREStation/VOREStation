/obj/item/clothing/head/centhat/customs
	desc = "A formal hat for SolCom Customs Officers."

/obj/item/clothing/head/fish
	name = "fish skull"
	desc = "You... you're not actually going to wear that, right?"
	icon_state = "fishskull"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	flags_inv = HIDEEARS|BLOCKHAIR

/obj/item/clothing/head/crown
	name = "crown"
	desc = "How regal!"
	icon_state = "crown"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'

/obj/item/clothing/head/fancy_crown
	name = "fancy crown"
	desc = "How extraordinarily regal!"
	icon_state = "fancycrown"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'

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

/obj/item/clothing/head/pelt
	name = "Bear pelt"
	desc = "A luxurious bear pelt, good to keep warm in winter. Or to sleep through winter."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "bearpelt_brown"
	item_state = "bearpelt_brown"

/obj/item/clothing/head/pelt/wolfpelt
	name = "Wolf pelt"
	desc = "A fuzzy wolf pelt, demanding respect as a hunter, well if it isn't synthetic or anything at least. Or bought."
	icon_override = 'icons/mob/wolfpelt_vr.dmi'
	icon_state = "wolfpelt_brown"
	item_state = "wolfpelt_brown"

/obj/item/clothing/head/pelt/wolfpeltblack
	name = "Wolf pelt"
	desc = "A fuzzy wolf pelt, demanding respect as a hunter, well if it isn't synthetic or anything at least. Or bought."
	icon_override = 'icons/mob/wolfpelt_vr.dmi'
	icon_state = "wolfpelt_gray"
	item_state = "wolfpelt_gray"

/obj/item/clothing/head/pelt/tigerpelt
	name = "Shiny tiger pelt"
	desc = "A vibrant tiger pelt, particularly fabulous."
	icon_state = "tigerpelt_shiny"
	item_state = "tigerpelt_shiny"

/obj/item/clothing/head/pelt/tigerpeltsnow
	name = "Snow tiger pelt"
	desc = "A pelt of a less vibrant tiger, but rather warm."
	icon_state = "tigerpelt_snow"
	item_state = "tigerpelt_snow"

/obj/item/clothing/head/pelt/tigerpeltpink
	name = "Pink tiger pelt"
	desc = "A particularly vibrant tiger pelt, for those who want to be the most fabulous at parties."
	icon_state = "tigerpelt_pink"
	item_state = "tigerpelt_pink"

/obj/item/clothing/head/pizzaguy
	name = "pizza delivery visor"
	desc = "A fancy visor showing alignment to pizza delivery service. Extremely risky career choice."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "pizzadelivery"
	item_state = "pizzadelivery"

/obj/item/clothing/head/wedding
	name = "wedding veil"
	desc = "A lace veil worn over the face, typically by a bride during their wedding."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "weddingveil"

/obj/item/clothing/head/halo/alt
	name = "metal halo"
	desc = "A halo made of a light metal. This one doesn't float, but it's still a circle on your head!"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "halo_alt"

/obj/item/clothing/head/buckethat
	name = "bucket hat"
	desc = "Turns out these are actually called 'gatsby caps' but telling people you wear a bucket is slightly more interesting, so that's what it's called."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "buckethat"

/obj/item/clothing/head/nonla
	name = "non la"
	desc = "A conical hat typically woven from leaves, good for keeping the sun AND rain off your head, in case it happens to be sunny while raining."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "nonla"

//////////TALON HATS//////////

/obj/item/clothing/head/soft/talon
	name = "Talon baseball cap"
	desc = "It's a ballcap bearing the colors of ITV Talon."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "talonsoft"
	item_state = "talonsoft"
	item_state_slots = list(slot_r_hand_str = "blacksoft", slot_l_hand_str = "blacksoft")

/obj/item/clothing/head/caphat/talon
	name = "Talon nautical hat"
	desc = "It's a classic nautical hat bearing the colors of ITV Talon. Perfect for commanding the ship."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "talon_captain_cap"
	item_state = "taloncaptaincap"

/obj/item/clothing/head/beret/talon
	name = "Talon beret"
	desc = "It's a basic baret colored to match ITV Talon's uniforms."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "beret_talon"
	item_state = "baret_talon"

/obj/item/clothing/head/beret/talon/command
	name = "Talon officer beret"
	desc = "It's a basic baret colored to match ITV Talon's uniforms with a badge pinned on the front. Perfect for commanders."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "beret_talon_officer"
	item_state = "baret_talon_command"

/obj/item/clothing/head/cowboy
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_vr_teshari.dmi'
		)