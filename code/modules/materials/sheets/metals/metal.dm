/obj/item/stack/material/steel
	name = MAT_STEEL
	icon_state = "sheet-refined"
	default_type = MAT_STEEL
	no_variants = FALSE
	apply_colour = TRUE
	coin_type = /obj/item/coin/steel

/obj/item/stack/material/plasteel
	name = MAT_PLASTEEL
	icon_state = "sheet-reinforced"
	default_type = MAT_PLASTEEL
	no_variants = FALSE
	apply_colour = TRUE
	coin_type = /obj/item/coin/plasteel

/obj/item/stack/material/plasteel/rebar
	name = MAT_PLASTEELREBAR
	icon_state = "rods"
	default_type = MAT_PLASTEELREBAR
	apply_colour = 1

/obj/item/stack/material/plasteel/rebar/update_icon()
	var/amount = get_amount()
	if((amount <= 5) && (amount > 0))
		icon_state = "rods-[amount]"
	else
		icon_state = "rods"

/obj/item/stack/material/durasteel
	name = MAT_DURASTEEL
	icon_state = "sheet-reinforced"
	item_state = "sheet-metal"
	default_type = MAT_DURASTEEL
	no_variants = FALSE
	apply_colour = TRUE
	coin_type = /obj/item/coin/durasteel

/obj/item/stack/material/titanium
	name = MAT_TITANIUM
	icon_state = "sheet-refined"
	apply_colour = TRUE
	item_state = "sheet-silver"
	default_type = MAT_TITANIUM
	no_variants = FALSE
	coin_type = /obj/item/coin/titanium

/obj/item/stack/material/iron
	name = MAT_IRON
	icon_state = "sheet-ingot"
	default_type = MAT_IRON
	apply_colour = 1
	no_variants = FALSE
	coin_type = /obj/item/coin/iron

/obj/item/stack/material/lead
	name = MAT_LEAD
	icon_state = "sheet-ingot"
	default_type = MAT_LEAD
	apply_colour = 1
	no_variants = FALSE
	coin_type = /obj/item/coin/lead

/obj/item/stack/material/gold
	name = MAT_GOLD
	icon_state = "sheet-ingot"
	default_type = MAT_GOLD
	no_variants = FALSE
	apply_colour = TRUE
	coin_type = /obj/item/coin/gold

/obj/item/stack/material/silver
	name = MAT_SILVER
	icon_state = "sheet-ingot"
	default_type = MAT_SILVER
	no_variants = FALSE
	apply_colour = TRUE
	coin_type = /obj/item/coin/silver

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = MAT_PLATINUM
	icon_state = "sheet-adamantine"
	default_type = MAT_PLATINUM
	no_variants = FALSE
	apply_colour = TRUE
	coin_type = /obj/item/coin/platinum

/obj/item/stack/material/uranium
	name = MAT_URANIUM
	icon_state = "sheet-uranium"
	default_type = MAT_URANIUM
	no_variants = FALSE
	coin_type = /obj/item/coin/uranium

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_type = MAT_METALHYDROGEN
	no_variants = FALSE

// Fusion fuel.
/obj/item/stack/material/deuterium
	name = MAT_DEUTERIUM
	icon_state = "sheet-puck"
	default_type = MAT_DEUTERIUM
	apply_colour = 1
	no_variants = FALSE

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = MAT_TRITIUM
	icon_state = "sheet-puck"
	default_type = MAT_TRITIUM
	apply_colour = TRUE
	no_variants = FALSE

/obj/item/stack/material/osmium
	name = MAT_OSMIUM
	icon_state = "sheet-ingot"
	default_type = MAT_OSMIUM
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/graphite
	name = MAT_GRAPHITE
	icon_state = "sheet-puck"
	default_type = MAT_GRAPHITE
	apply_colour = 1
	no_variants = FALSE
	coin_type = /obj/item/coin/graphite

/obj/item/stack/material/bronze
	name = MAT_BRONZE
	icon_state = "sheet-ingot"
	singular_name = "bronze ingot"
	default_type = MAT_BRONZE
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/tin
	name = MAT_TIN
	icon_state = "sheet-ingot"
	singular_name = "tin ingot"
	default_type = MAT_TIN
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/copper
	name = MAT_COPPER
	icon_state = "sheet-ingot"
	singular_name = "copper ingot"
	default_type = MAT_COPPER
	apply_colour = 1
	no_variants = FALSE
	coin_type = /obj/item/coin/copper

/obj/item/stack/material/aluminium
	name = MAT_ALUMINIUM
	icon_state = "sheet-ingot"
	singular_name = "aluminium ingot"
	default_type = MAT_ALUMINIUM
	apply_colour = 1
	no_variants = FALSE
	coin_type = /obj/item/coin/aluminium
