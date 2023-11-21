/obj/item/stack/material/steel
	name = MAT_STEEL
	icon_state = "sheet-refined"
	default_type = MAT_STEEL
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-reinforced"
	default_type = "plasteel"
	no_variants = FALSE
	apply_colour = TRUE

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
	name = "durasteel"
	icon_state = "sheet-reinforced"
	item_state = "sheet-metal"
	default_type = "durasteel"
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/titanium
	name = MAT_TITANIUM
	icon_state = "sheet-refined"
	apply_colour = TRUE
	item_state = "sheet-silver"
	default_type = MAT_TITANIUM
	no_variants = FALSE

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-ingot"
	default_type = "iron"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/lead
	name = "lead"
	icon_state = "sheet-ingot"
	default_type = "lead"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-ingot"
	default_type = "gold"
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-ingot"
	default_type = "silver"
	no_variants = FALSE
	apply_colour = TRUE

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	default_type = "platinum"
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	default_type = "uranium"
	no_variants = FALSE

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_type = "mhydrogen"
	no_variants = FALSE

// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	icon_state = "sheet-puck"
	default_type = "deuterium"
	apply_colour = 1
	no_variants = FALSE

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-puck"
	default_type = "tritium"
	apply_colour = TRUE
	no_variants = FALSE

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-ingot"
	default_type = "osmium"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/graphite
	name = "graphite"
	icon_state = "sheet-puck"
	default_type = MAT_GRAPHITE
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/bronze
	name = "bronze"
	icon_state = "sheet-ingot"
	singular_name = "bronze ingot"
	default_type = "bronze"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/tin
	name = "tin"
	icon_state = "sheet-ingot"
	singular_name = "tin ingot"
	default_type = "tin"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/copper
	name = "copper"
	icon_state = "sheet-ingot"
	singular_name = "copper ingot"
	default_type = "copper"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/aluminium
	name = "aluminium"
	icon_state = "sheet-ingot"
	singular_name = "aluminium ingot"
	default_type = "aluminium"
	apply_colour = 1
	no_variants = FALSE
