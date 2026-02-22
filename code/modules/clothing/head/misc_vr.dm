/obj/item/clothing/head/centhat/customs
	desc = "A formal hat for SolCom Customs Officers."

/obj/item/clothing/head/fish
	name = "fish skull"
	desc = "You... you're not actually going to wear that, right?"
	icon_state = "fishskull"
	flags_inv = HIDEEARS|BLOCKHAIR

/obj/item/clothing/head/crown
	name = "crown"
	desc = "How regal!"
	icon_state = "crown"

/obj/item/clothing/head/fancy_crown
	name = "fancy crown"
	desc = "How extraordinarily regal!"
	icon_state = "fancycrown"

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
	icon_state = "pizzadelivery"
	item_state = "pizzadelivery"

/obj/item/clothing/head/fluff/names_pizza
	name = "pizza delivery hat"
	desc = "A hat fit for delivering pizzas! Smells of pepperoni and unpaid student debt."
	icon_state = "pizzadelivery_fluff"
	item_state = "pizzadelivery_fluff"

/obj/item/clothing/head/wedding
	name = "wedding veil"
	desc = "A lace veil worn over the face, typically by a bride during their wedding."
	icon_state = "weddingveil"

/obj/item/clothing/head/halo/alt
	name = "metal halo"
	desc = "A halo made of a light metal. This one doesn't float, but it's still a circle on your head!"
	icon_state = "halo_alt"

/obj/item/clothing/head/buckethat
	name = "bucket hat"
	desc = "Turns out these are actually called 'gatsby caps' but telling people you wear a bucket is slightly more interesting, so that's what it's called."
	icon_state = "buckethat"

/obj/item/clothing/head/nonla
	name = "non la"
	desc = "A conical hat typically woven from leaves, good for keeping the sun AND rain off your head, in case it happens to be sunny while raining."
	icon_state = "nonla"

//////////TALON HATS//////////

/obj/item/clothing/head/soft/talon
	name = "Talon baseball cap"
	desc = "It's a ballcap bearing the colors of ITV Talon."
	icon_state = "talonsoft"
	item_state = "talonsoft"
	item_state_slots = list(slot_r_hand_str = "blacksoft", slot_l_hand_str = "blacksoft")

/obj/item/clothing/head/caphat/talon
	name = "Talon nautical hat"
	desc = "It's a classic nautical hat bearing the colors of ITV Talon. Perfect for commanding the ship."
	icon_state = "talon_captain_cap"
	item_state = "taloncaptaincap"

/obj/item/clothing/head/soft/talon/refreshed
	name = "Talon cap"
	desc = "It's a standard dark blue baseball cap, it has the ITV Talon logo on the front proudly displayed."
	icon = 'icons/inventory/head/item.dmi'
	icon_override = 'icons/inventory/head/mob.dmi'
	icon_state = "talonnewsoft"
	item_state = "talonnewsoft"
	item_state_slots = list(slot_r_hand_str = "blacksoft", slot_l_hand_str = "blacksoft")

/obj/item/clothing/head/caphat/talon/refreshed
	name = "Talon captain's peaked cap"
	desc = "It's a parade cap usually worn by the ITV Talon's commanding officer, it displays power and discipline to whoever wears it."
	icon = 'icons/inventory/head/item.dmi'
	icon_override = 'icons/inventory/head/mob.dmi'
	icon_state = "talon_caphat"
	item_state = "talon_caphat"

/obj/item/clothing/head/caphat/talon/pilot
	name = "Talon pilot's cap"
	desc = "It's a formal cap worn usually by ITV Talon's piloting personnel, embezzled with the ITV Talon's logo on the front of the cap."
	icon = 'icons/inventory/head/item.dmi'
	icon_override = 'icons/inventory/head/mob.dmi'
	icon_state = "talon_pilothat"
	item_state = "talon_pilothat"

/obj/item/clothing/head/beret/talon
	name = "Talon beret"
	desc = "It's a basic beret colored to match ITV Talon's uniforms."
	icon_state = "beret_talon"
	item_state = "baret_talon"

/obj/item/clothing/head/beret/talon/refreshed
	name = "Talon beret"
	desc = "It's a standard dark blue beret with nothing especially interesting on it."
	icon = 'icons/inventory/head/item.dmi'
	icon_override = 'icons/inventory/head/mob.dmi'
	icon_state = "talon_beret"
	item_state = "talon_beret"

/obj/item/clothing/head/beret/talon/command
	name = "Talon officer beret"
	desc = "It's a basic beret colored to match ITV Talon's uniforms with a badge pinned on the front. Perfect for commanders."
	icon_state = "beret_talon_officer"
	item_state = "baret_talon_command"


/obj/item/clothing/head/beret/talon/command/refreshed
	name = "Talon officer beret"
	desc = "It's a standard dark blue beret with the ITV Talon logo on the front proudly displayed."
	icon = 'icons/inventory/head/item.dmi'
	icon_override = 'icons/inventory/head/mob.dmi'
	icon_state = "talon_officer_beret"
	item_state = "talon_officer_beret"

// tiny tophat

/obj/item/clothing/head/tinytophat
	name = "tiny tophat"
	desc = "A tophat that is far too small to properly sit on someone's head!"
	icon_state = "tiny_tophat"

//Replikant Hat

/obj/item/clothing/head/eulrhat
	name = "sleek side cap"
	desc = "A simple wedge cap with red accents, popular with biosynthetic personnel."
	icon_state = "eulrhat"
